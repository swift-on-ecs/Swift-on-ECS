//
//  CommandFrameSystem.swift
//  Swift-on-ECS
//
//  Created by WeZZard on 12/12/17.
//

public final class CommandFrameSystem: _DependentSystem {
    internal typealias _Manager = _CommandFrameSystemManager
    
    internal typealias _Metadata = _CommandFrameSystemMetadata
    
    internal let _owner: _DependentSystemOwner<_Metadata>
    
    internal let _manager: _Manager
    
    internal init(owner: _DependentSystemOwner<_Metadata>, manager: _Manager) {
        _owner = owner
        _manager = manager
    }
}

extension CommandFrameSystem: ImplicitSystem {
    public var name: String {
        get { return _manager.name(forSystem: self) }
        set { _manager.setName(newValue, forSystem: self) }
    }
    
    public var isEnabled: Bool {
        get { return _manager.isEnabled(forSystem: self) }
        set { _manager.setEnabled(newValue, forSystem: self) }
    }
    
    public var qualityOfService: SystemQoS {
        get { return _manager.qualityOfService(forSystem: self) }
        set { _manager.setQualityOfService(newValue, forSystem: self) }
    }
}

extension CommandFrameSystem: DependentSystem {
    public var required: Set<CommandFrameSystem> {
        return _manager.systems(requiringSystem: self)
    }
    
    public var requires: Set<CommandFrameSystem> {
        return _manager.systems(requiredBySystem: self)
    }
    
    @discardableResult
    public func setRequired(by systems: Set<CommandFrameSystem>)
        -> CommandFrameSystem
    {
        for each in systems {
            _manager.setSystem(self, isRequiredBySystem: each)
        }
        return self
    }
    
    @discardableResult
    public func setNotRequired(by systems: Set<CommandFrameSystem>)
        -> CommandFrameSystem
    {
        for each in systems {
            _manager.setSystem(self, isNotRequiredBySystem: each)
        }
        return self
    }
    
    @discardableResult
    public func setRequires(_ systems: Set<CommandFrameSystem>)
        -> CommandFrameSystem
    {
        for each in systems {
            _manager.setSystem(self, requiresSystem: each)
        }
        return self
    }
    
    @discardableResult
    public func setNotRequires(_ systems: Set<CommandFrameSystem>)
        -> CommandFrameSystem
    {
        for each in systems {
            _manager.setSystem(self, doesNotRequireSystem: each)
        }
        return self
    }
}

extension CommandFrameSystem: Equatable {
    public static func == (
        lhs: CommandFrameSystem,
        rhs: CommandFrameSystem
        ) -> Bool
    {
        return lhs._manager === rhs._manager && lhs._owner === rhs._owner
    }
}

extension CommandFrameSystem: Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(_owner).hashValue
    }
}
