Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA566F0F79
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344440AbjD1AVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 20:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbjD1AVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 20:21:18 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281A83A89;
        Thu, 27 Apr 2023 17:20:47 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 33RIPmF9007912;
        Thu, 27 Apr 2023 17:20:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=mj7gNSI4Et3dNmvaBIpIFoYb1Y2J8y67h3k5ulAI4ro=;
 b=Lvbrrg+gzWU1ZHoZeKVnUaZQxvbLE2nA8wNGgPQPwuir+N5B2jxsD+JTlxrnm9KWN+2i
 uH5hodkH3XCfwiWYCoX8XCyAfSmmfs/NL2/LxrnYO/VYQN1xDGjkNnUx9wFiS7I56i8U
 2cPepQMB2ZsnJYwuFKuEzAq2KxBaDTkDbhE+0M0B2+WyaoHlSx7ClmObkLO0lJ0vBeb5
 +oCvp4Mu+j2TqkaCmN1UUjo2pfPrJnwvG53f36IRdzB/njW3fdSMLLnT+T6wM5BDCPJz
 HkNYUmDKiYvgYlG/59wBxSeOSpwIQ5ViTZxmKbhw1bCNbmokI1RzgcYbXT/9n+v//okR yw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3q7utb3r16-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Apr 2023 17:20:33 -0700
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server id
 15.1.2507.23; Thu, 27 Apr 2023 17:20:29 -0700
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        <poros@redhat.com>, <mschmidt@redhat.com>,
        <netdev@vger.kernel.org>, <linux-clk@vger.kernel.org>
Subject: [RFC PATCH v7 3/8] dpll: documentation on DPLL subsystem interface
Date:   Thu, 27 Apr 2023 17:20:04 -0700
Message-ID: <20230428002009.2948020-4-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230428002009.2948020-1-vadfed@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: dNcRAW2A-0--u7z5SnY6J6PyMuDxv1uf
X-Proofpoint-ORIG-GUID: dNcRAW2A-0--u7z5SnY6J6PyMuDxv1uf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_09,2023-04-27_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

Add documentation explaining common netlink interface to configure DPLL
devices and monitoring events. Common way to implement DPLL device in
a driver is also covered.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 Documentation/dpll.rst             | 408 +++++++++++++++++++++++++++++
 Documentation/networking/index.rst |   1 +
 2 files changed, 409 insertions(+)
 create mode 100644 Documentation/dpll.rst

diff --git a/Documentation/dpll.rst b/Documentation/dpll.rst
new file mode 100644
index 000000000000..fba5bc027967
--- /dev/null
+++ b/Documentation/dpll.rst
@@ -0,0 +1,408 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+The Linux kernel dpll subsystem
+===============================
+
+
+The main purpose of dpll subsystem is to provide general interface
+to configure devices that use any kind of Digital PLL and could use
+different sources of signal to synchronize to as well as different
+types of outputs.
+The main interface is NETLINK_GENERIC based protocol with an event
+monitoring multicast group defined.
+
+
+Device object
+=============
+Single dpll device object means single Digital PLL circuit and bunch of
+pins connected with it.
+It provides its supported working modes and current status to the user
+in response to the `do` request of netlink command
+``DPLL_CMD_DEVICE_GET`` and list of dplls registered in the subsystem
+with `dump` netlink request of same command.
+Requesting configuration of dpll device is done with `do` request of
+netlink ``DPLL_CMD_DEVICE_SET`` command.
+
+
+Pin object
+==========
+A pin is amorphic object which represents either source or output, it
+could be internal component of the device, as well as externaly
+connected.
+The number of pins per dpll vary, but usually multiple pins shall be
+provided for a single dpll device.
+Pin's properties, capabilities and status is provided to the user in
+response to `do` request of netlink ``DPLL_CMD_PIN_GET`` command.
+It is also possible to list all the pins that were registered in the
+system with `dump` request of ``DPLL_CMD_PIN_GET`` command.
+Configuration of a pin can be changed by `do` request of netlink
+``DPLL_CMD_PIN_SET`` command.
+
+
+Pin selection
+=============
+In general selected pin (the one which signal is driving the dpll
+device) can be obtained from ``DPLL_A_PIN_STATE`` attribute, and only
+one pin shall be in ``DPLL_PIN_STATE_CONNECTED`` state for any dpll
+device.
+
+Pin selection can be done either manualy or automatically, depending on
+hardware capabilities and active dpll device work mode
+(``DPLL_A_MODE`` attribute). The consequence is that, there are
+differences for each mode in terms of available pin states, as well
+as for the states the user can request for a dpll device.
+
+In manual mode (``DPLL_MODE_MANUAL``) the user can request or receive
+one of following pin states:
+- ``DPLL_PIN_STATE_CONNECTED`` - the pin is used to drive dpll device
+- ``DPLL_PIN_STATE_DISCONNECTED`` - the pin is not used to drive dpll
+  device
+
+In automatic mode (``DPLL_MODE_AUTOMATIC``) the user can request or
+receive one of following pin states:
+- ``DPLL_PIN_STATE_SELECTABLE`` - the pin shall be considered as valid
+  source for automatic selection algorithm
+- ``DPLL_PIN_STATE_DISCONNECTED`` - the pin shall be not considered as
+  a valid source for automatic selection algorithm
+In automatic mode (``DPLL_MODE_AUTOMATIC``) the user can only receive
+pin state ``DPLL_PIN_STATE_CONNECTED`` once automatic selection
+algorithm locks a dpll device with one of the sources.
+
+
+Shared pins
+===========
+A single pin object can be registered to multiple dpll devices.
+Then there are two groups of configuration knobs:
+1) Set on a pin - the configuration affects all dpll devices pin is
+   registered to. (i.e. ``PIN_FREQUENCY``, ``PIN_DIRECTION``),
+2) Set on a pin-dpll tuple - the configuration affects only selected
+   dpll device. (i.e. PIN_PRIO, PIN_STATE).
+
+
+MUX-type pins
+=============
+A pin can be MUX-type, it aggregates child pins and serves as a pin
+multiplexer. One or more pins are registered with MUX-type instead of
+being directly registered to a dpll device.
+Pins registered with a MUX-type provide user with additional nested
+attribute ``DPLL_A_PIN_PARENT`` for each parent they were registered
+with.
+If a pin was registered with multiple parent pins, they behave like a
+multiple output multiplexer. In this case output of a
+``DPLL_CMD_PIN_GET`` would contain multiple pin-parent nested
+attributes with current state related to each parent, like:
+
+``'pin': [{
+        'device': [{'bus-name': 'pci',
+                    'dev-name': '0000:21:00.0_0', 'id': 0}],
+        'pin-direction': {'doc': 'pin used as a source of a signal',
+                          'name': 'source'},
+        'pin-idx': 13,
+        'pin-parent': [{'pin-parent-idx': 2,
+                        'pin-state': {'doc': 'pin disconnected',
+                                      'name': 'disconnected'}},
+                       {'pin-parent-idx': 3,
+                        'pin-state': {'doc': 'pin disconnected',
+                                      'name': 'disconnected'}}],
+        }]``
+
+Only one child pin can provide it's signal to the parent MUX-type pin at
+a time, the selection is done with requesting change of child pin state
+to ``DPLL_PIN_STATE_CONNECTED`` and providing a target MUX-type pin
+index value in ``DPLL_A_PARENT_PIN_IDX``.
+
+Pin priority
+============
+Some devices might offer a capability of automatic pin selection mode
+(enum value ``DPLL_MODE_AUTOMATIC`` of ``DPLL_A_MODE`` attribute).
+Usually such automatic selection is offloaded to the hardware,
+which means only pins directly connected to the dpll are capable of
+automatic source pin selection.
+In automatic selection mode, the user cannot manually select a source
+pin for the device, instead the user shall provide all directly
+connected pins with a priority ``DPLL_A_PIN_PRIO``, the device would
+pick a highest priority valid signal and connect with it.
+Child pin of MUX-type is not capable of automatic source pin selection,
+in order to configure a source of a MUX-type pin, the user needs to
+request desired pin state of the child pin on the parent - it is done
+with providing additional attribute for pin set state request - index
+of parent pin he wish to propagate its signal to
+(``DPLL_A_PARENT_PIN_IDX``).
+
+
+Configuration commands group
+============================
+
+Configuration commands are used to get or dump information about
+registered dpll devices (and pins), as well as set configuration of
+device or pins. As dpll device could not be abstract and reflects real
+hardware, there is no way to add new dpll device via netlink from user
+space and each device should be registered by it's driver.
+
+All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
+any spamming/D.o.S. from unauthorized userspace applications.
+
+List of netlink commands with possible attributes
+=================================================
+
+All constants identifying command types use ``DPLL_CMD_`` prefix and
+suffix according to command purpose. All attributes use ``DPLL_A_``
+prefix and suffix according to attribute purpose:
+
+  ============================  =======================================
+  ``DEVICE_GET``                command to get device info or dump list
+                                of available devices
+    ``ID``                      attr internal dpll device ID
+    ``DEV_NAME``                attr dpll device name
+    ``BUS_NAME``                attr dpll device bus name
+    ``MODE``                    attr selection mode
+    ``MODE_SUPPORTED``          attr available selection modes
+    ``LOCK_STATUS``             attr internal frequency-lock status
+    ``TEMP``                    attr device temperature information
+    ``CLOCK_ID``                attr Unique Clock Identifier (EUI-64),
+                                as defined by the IEEE 1588 standard
+    ``TYPE``                    attr type or purpose of dpll device
+  ``DEVICE_SET``                command to set dpll device configuration
+    ``ID``                      attr internal dpll device index
+    ``NAME``                    attr dpll device name (not required if
+                                dpll device index was provided)
+    ``MODE``                    attr selection mode to configure
+  ``PIN_GET``                   command to get pin info or dump list of
+                                available pins
+    ``DEVICE``                  nest attr for each dpll device pin is
+                                connected with
+      ``ID``                    attr internal dpll device ID
+      ``DEV_NAME``              attr dpll device name
+      ``BUS_NAME``              attr dpll device bus name
+      ``PIN_PRIO``              attr priority of pin on the dpll device
+      ``PIN_STATE``             attr state of pin on the dpll device
+    ``PIN_IDX``                 attr index of a pin on the dpll device
+    ``PIN_DESCRIPTION``         attr description provided by driver
+    ``PIN_TYPE``                attr type of a pin
+    ``PIN_DIRECTION``           attr direction of a pin
+    ``PIN_FREQUENCY``           attr current frequency of a pin
+    ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
+    ``PIN_ANY_FREQUENCY_MIN``   attr minimum value of frequency in case
+                                pin/dpll supports any frequency
+    ``PIN_ANY_FREQUENCY_MAX``   attr maximum value of frequency in case
+                                pin/dpll supports any frequency
+    ``PIN_PARENT``              nest attr for each MUX-type parent, that
+                                pin is connected with
+      ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
+                                device
+      ``PIN_STATE``             attr state of a pin on parent pin
+    ``PIN_RCLK_DEVICE``         attr name of a device, where pin
+                                recovers clock signal from
+    ``PIN_DPLL_CAPS``           attr bitmask of pin-dpll capabilities
+
+  ``PIN_SET``                   command to set pins configuration
+    ``ID``                      attr internal dpll device index
+    ``BUS_NAME``                attr dpll device name (not required if
+                                dpll device ID was provided)
+    ``DEV_NAME``                attr dpll device name (not required if
+                                dpll device ID was provided)
+    ``PIN_IDX``                 attr index of a pin on the dpll device
+    ``PIN_DIRECTION``           attr direction to be set
+    ``PIN_FREQUENCY``           attr frequency to be set
+    ``PIN_PRIO``                attr pin priority to be set
+    ``PIN_STATE``               attr pin state to be set
+    ``PIN_PARENT_IDX``          attr if provided state is to be set with
+                                parent pin instead of with dpll device
+
+Netlink dump requests
+=====================
+
+The ``DEVICE_GET`` and ``PIN_GET`` commands are capable of dump type
+netlink requests, in which case the response is in the same format as
+for their ``do`` request.
+
+
+SET commands format
+===================
+
+``DEVICE_SET`` - to target a dpll device, the user provides either a
+``ID`` or both ``BUS_NAME`` and ``DEV_NAME``, as well as parameter being
+configured (``DPLL_A_MODE``).
+
+``PIN_SET`` - to target a pin user has to provide a ``PIN_IDX``, but
+pin does not exist on its own, thus a dpll device must be also targeted
+with either a ``ID`` or both ``BUS_NAME`` and ``DEV_NAME`` to which
+pin being configured was registered with. Also configured pin parameters
+must be added.
+If ``PIN_DIRECTION`` or ``PIN_FREQUENCY`` are configured, this affects
+all the dpll device they are connected.
+If ``PIN_PRIO`` or ``PIN_STATE`` are configured, this affects only
+the dpll device being targeted.
+If valid ``PIN_PARENT_IDX`` is provided, the set command shall affect
+the configuration between a pin and it's parent, which is a
+``PIN_STATE``.
+In general it is possible to configure multiple parameters at once.
+
+
+Device level configuration pre-defined enums
+=================================================
+
+For all below enum names used for configuration of dpll device use
+the ``DPLL_`` prefix.
+
+Values for ``DPLL_A_LOCK_STATUS`` attribute:
+
+  ============================= ======================================
+  ``LOCK_STATUS_UNLOCKED``      dpll device is in freerun, not locked
+                                to any source pin
+  ``LOCK_STATUS_CALIBRATING``   dpll device calibrates to lock to the
+                                source pin signal
+  ``LOCK_STATUS_LOCKED``        dpll device is locked to the source
+                                pin frequency
+  ``LOCK_STATUS_HOLDOVER``      dpll device lost a lock, using its
+                                frequency holdover capabilities
+
+Values for ``DPLL_A_MODE`` attribute:
+
+  =================== ================================================
+  ``MODE_FORCED``     source pin is force-selected by setting pin
+                      state to ``DPLL_PIN_STATE_CONNECTED`` on a dpll
+  ``MODE_AUTOMATIC``  source pin is auto selected according to
+                      configured pin priorities and source signal
+                      validity
+  ``MODE_HOLDOVER``   force holdover mode of dpll
+  ``MODE_FREERUN``    dpll device is driven by supplied system clock
+                      without holdover capabilities
+  ``MODE_NCO``        similar to FREERUN, with possibility to
+                      numerically control frequency offset
+
+Values for ``DPLL_A_TYPE`` attribute:
+
+  ============= ===================================================
+  ``TYPE_PPS``  dpll device used to provide pulse-per-second output
+  ``TYPE_EEC``  dpll device used to drive ethernet equipment clock
+
+
+
+Pin level configuration pre-defined enums
+=========================================
+
+For all below enum names used for configuration of pin use the
+``DPLL_PIN_`` prefix.
+
+Values for ``DPLL_A_PIN_STATE`` attribute:
+
+  ======================= ========================================
+  ``STATE_CONNECTED``     Pin used as active source for a dpll
+                          device or for a parent pin
+  ``STATE_DISCONNECTED``  Pin disconnected from a dpll device or
+                          from a parent pin
+  ``STATE_SELECTABLE``    Pin enabled for automatic selection
+
+Values for ``DPLL_A_PIN_DIRECTION`` attribute:
+
+  ======================= ==============================
+  ``DIRECTION_SOURCE``    Pin used as a source of signal
+  ``DIRECTION_OUTPUT``    Pin used to output signal
+
+Values for ``DPLL_A_PIN_TYPE`` attributes:
+
+  ======================== ========================================
+  ``TYPE_MUX``             MUX type pin, connected pins shall have
+                           their own types
+  ``TYPE_EXT``             External pin
+  ``TYPE_SYNCE_ETH_PORT``  SyncE on Ethernet port
+  ``TYPE_INT_OSCILLATOR``  Internal Oscillator (i.e. Holdover with
+                           Atomic Clock as a Source)
+  ``TYPE_GNSS``            GNSS 1PPS source
+
+Values for ``DPLL_A_PIN_DPLL_CAPS`` attributes:
+
+  ============================= ================================
+  ``CAPS_DIRECTION_CAN_CHANGE`` Bit present if direction can change
+  ``CAPS_PRIORITY_CAN_CHANGE``  Bit present if priority can change
+  ``CAPS_STATE_CAN_CHANGE``     Bit present if state can change
+
+
+Notifications
+=============
+
+dpll device can provide notifications regarding status changes of the
+device, i.e. lock status changes, source/output type changes or alarms.
+This is the multicast group that is used to notify user-space apps via
+netlink socket: ``DPLL_MCGRP_MONITOR``
+
+Notifications messages (attrbiutes use ``DPLL_A`` prefix):
+
+  ========================= ==========================================
+  ``EVENT_DEVICE_CREATE``   event value new dpll device was created
+    ``ID``                  attr internal dpll device ID
+    ``DEV_NAME``            attr dpll device name
+    ``BUS_NAME``            attr dpll device bus name
+  ``EVENT_DEVICE_DELETE``   event value dpll device was deleted
+    ``ID``                  attr dpll device index
+  ``EVENT_DEVICE_CHANGE``   event value dpll device attribute has
+                            changed
+    ``ID``                  attr modified dpll device ID
+    ``PIN_IDX``             attr the modified pin index
+
+Device change event shall consiste of the attribute and the value that
+has changed.
+
+
+Device driver implementation
+============================
+
+Device is allocated by ``dpll_device_get`` call. Second call with the
+same arguments doesn't create new object but provides pointer to
+previously created device for given arguments, it also increase refcount
+of that object.
+Device is deallocated by ``dpll_device_put`` call, which first decreases
+the refcount, once refcount is cleared the object is destroyed.
+
+Device should implement set of operations and register device via
+``dpll_device_register`` at which point it becomes available to the
+users. Only one driver instance can register a dpll device within dpll
+subsytem. Multiple driver instances can obtain reference to it with
+``dpll_device_get``.
+
+The pins are allocated separately with ``dpll_pin_get``, it works
+similarly to ``dpll_device_get``. Creates object and the for each call
+with the same arguments the object refcount increases.
+
+Once dpll device is created, allocated pin can be registered with it
+with 2 different methods, always providing implemented pin callbacks,
+and private data pointer for calling them:
+``dpll_pin_register`` - simple registration with a dpll device.
+``dpll_pin_on_pin_register`` - register pin with another MUX type pin.
+
+For different instances of a device driver requiring to find already
+registered dpll (i.e. to connect its pins to it) use ``dpll_device_get``
+to obtain proper dpll device pointer.
+
+The name of dpll device is generated based on registerer provided module
+struct pointer, clock_id and device_idx values.
+Name is in format: ``%s/%llx/%d`` where arguments are as follows:
+``module_name(dpll->module)`` - syscall on parent module struct pointer
+``dpll->clock_id``            - registerer given clock id
+``dpll->device_idx``          - registerer given device id
+
+Notifications of adding or removing dpll devices are created within
+subsystem itself.
+Notifications about registering/deregistering pins are also invoked by
+the subsystem.
+Notifications about status changes either of dpll device or a pin shall
+be requested by device driver with ``dpll_device_notify`` or
+``dpll_pin_notify``.
+
+The device driver using dpll interface is not required to implement all
+the callback operation. Nevertheless there are few required to be
+implemented.
+Required dpll device level callback operations:
+- ``.mode_get``
+- ``.lock_status_get``
+
+Required pin level callback operations:
+- ``.state_get``
+- ``.direction_get``
+
+There is no strict requirement to implement all the operations for
+each device, every operation handler is checked for existence and
+ENOTSUPP is returned in case of absence of specific handler.
+
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index a164ff074356..4828d6f6daf1 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -17,6 +17,7 @@ Contents:
    dsa/index
    devlink/index
    caif/index
+   dpll
    ethtool-netlink
    ieee802154
    j1939
-- 
2.34.1

