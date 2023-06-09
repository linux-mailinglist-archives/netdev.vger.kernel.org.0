Return-Path: <netdev+bounces-9517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E41B772998E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A3C1281906
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1032A16433;
	Fri,  9 Jun 2023 12:21:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A5879E5
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:21:14 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2350198C;
	Fri,  9 Jun 2023 05:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686313272; x=1717849272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTC+D+o/JlYk0zrvZXo2OmpIk746elHLTpeBE+rcNvo=;
  b=OM54Vnbh4br6jYqXYR2lwWYvqB54DAVqi6qxS3I/gtTJLA5dfuXMamx/
   +NFesEEE857e51uVUSpu5jHtXXopmkdiI4KiWOkoVBZxmLTwhMWrrC5iM
   KBsbYHrA+9jxWWRRE5eDHYpPiHZFBir+2cNp8bbsGN7g/jIJ/IWuV9o0V
   BhqO8BBe7nfgy9A8xc2+H6OhSggFWyh/ZeZF9iVFid1npSLQkpKBB74bP
   2PgAL8wHOjYSPaNA0OkH3EzmHBj0STOxXzBs6aZUmrXFEWBhwvDGtnFSb
   lnKJYw6pWCraXreCSdB/ZRcdDS1psERMy2K9aF86HAibVYcHPS+ISnddY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="337219790"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337219790"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 05:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="710348275"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="710348275"
Received: from amlin-018-114.igk.intel.com ([10.102.18.114])
  by orsmga002.jf.intel.com with ESMTP; 09 Jun 2023 05:20:58 -0700
From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To: kuba@kernel.org,
	jiri@resnulli.us,
	arkadiusz.kubalewski@intel.com,
	vadfed@meta.com,
	jonathan.lemon@gmail.com,
	pabeni@redhat.com
Cc: corbet@lwn.net,
	davem@davemloft.net,
	edumazet@google.com,
	vadfed@fb.com,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	saeedm@nvidia.com,
	leon@kernel.org,
	richardcochran@gmail.com,
	sj@kernel.org,
	javierm@redhat.com,
	ricardo.canuelo@collabora.com,
	mst@redhat.com,
	tzimmermann@suse.de,
	michal.michalik@intel.com,
	gregkh@linuxfoundation.org,
	jacek.lawrynowicz@linux.intel.com,
	airlied@redhat.com,
	ogabbay@kernel.org,
	arnd@arndb.de,
	nipun.gupta@amd.com,
	axboe@kernel.dk,
	linux@zary.sk,
	masahiroy@kernel.org,
	benjamin.tissoires@redhat.com,
	geert+renesas@glider.be,
	milena.olech@intel.com,
	kuniyu@amazon.com,
	liuhangbin@gmail.com,
	hkallweit1@gmail.com,
	andy.ren@getcruise.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	lucien.xin@gmail.com,
	nicolas.dichtel@6wind.com,
	phil@nwl.cc,
	claudiajkang@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	poros@redhat.com,
	mschmidt@redhat.com,
	linux-clk@vger.kernel.org,
	vadim.fedorenko@linux.dev
Subject: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem interface
Date: Fri,  9 Jun 2023 14:18:44 +0200
Message-Id: <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Vadim Fedorenko <vadim.fedorenko@linux.dev>

Add documentation explaining common netlink interface to configure DPLL
devices and monitoring events. Common way to implement DPLL device in
a driver is also covered.

Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 Documentation/driver-api/dpll.rst  | 458 +++++++++++++++++++++++++++++
 Documentation/driver-api/index.rst |   1 +
 2 files changed, 459 insertions(+)
 create mode 100644 Documentation/driver-api/dpll.rst

diff --git a/Documentation/driver-api/dpll.rst b/Documentation/driver-api/dpll.rst
new file mode 100644
index 000000000000..8caa4af022ad
--- /dev/null
+++ b/Documentation/driver-api/dpll.rst
@@ -0,0 +1,458 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+The Linux kernel dpll subsystem
+===============================
+
+The main purpose of dpll subsystem is to provide general interface
+to configure devices that use any kind of Digital PLL and could use
+different sources of signal to synchronize to as well as different
+types of outputs.
+The main interface is NETLINK_GENERIC based protocol with an event
+monitoring multicast group defined.
+
+Device object
+=============
+
+Single dpll device object means single Digital PLL circuit and bunch of
+connected pins.
+It reports the supported modes of operation and current status to the
+user in response to the `do` request of netlink command
+``DPLL_CMD_DEVICE_GET`` and list of dplls registered in the subsystem
+with `dump` netlink request of the same command.
+Changing the configuration of dpll device is done with `do` request of
+netlink ``DPLL_CMD_DEVICE_SET`` command.
+A device handle is ``DPLL_A_ID``, it shall be provided to get or set
+configuration of particular device in the system. It can be obtained
+with a ``DPLL_CMD_DEVICE_GET`` `dump` request or
+a ``DPLL_CMD_DEVICE_ID_GET`` `do` request, where the one must provide
+attributes that result in single device match.
+
+Pin object
+==========
+
+A pin is amorphic object which represents either input or output, it
+could be internal component of the device, as well as externally
+connected.
+The number of pins per dpll vary, but usually multiple pins shall be
+provided for a single dpll device.
+Pin's properties, capabilities and status is provided to the user in
+response to `do` request of netlink ``DPLL_CMD_PIN_GET`` command.
+It is also possible to list all the pins that were registered in the
+system with `dump` request of ``DPLL_CMD_PIN_GET`` command.
+Configuration of a pin can be changed by `do` request of netlink
+``DPLL_CMD_PIN_SET`` command.
+Pin handle is a ``DPLL_A_PIN_ID``, it shall be provided to get or set
+configuration of particular pin in the system. It can be obtained with
+``DPLL_CMD_PIN_GET`` `dump` request or ``DPLL_CMD_PIN_ID_GET`` `do`
+request, where user provides attributes that result in single pin match.
+
+Pin selection
+=============
+
+In general, selected pin (the one which signal is driving the dpll
+device) can be obtained from ``DPLL_A_PIN_STATE`` attribute, and only
+one pin shall be in ``DPLL_PIN_STATE_CONNECTED`` state for any dpll
+device.
+
+Pin selection can be done either manually or automatically, depending
+on hardware capabilities and active dpll device work mode
+(``DPLL_A_MODE`` attribute). The consequence is that there are
+differences for each mode in terms of available pin states, as well as
+for the states the user can request for a dpll device.
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
+  input for automatic selection algorithm
+- ``DPLL_PIN_STATE_DISCONNECTED`` - the pin shall be not considered as
+  a valid input for automatic selection algorithm
+In automatic mode (``DPLL_MODE_AUTOMATIC``) the user can only receive
+pin state ``DPLL_PIN_STATE_CONNECTED`` once automatic selection
+algorithm locks a dpll device with one of the inputs.
+
+For other dpll device operating modes there is no pin selection
+mechanics.
+
+Shared pins
+===========
+
+A single pin object can be attached to multiple dpll devices.
+Then there are two groups of configuration knobs:
+1) Set on a pin - the configuration affects all dpll devices pin is
+   registered to (i.e. ``DPLL_A_PIN_FREQUENCY``),
+2) Set on a pin-dpll tuple - the configuration affects only selected
+   dpll device (i.e. ``DPLL_A_PIN_PRIO``, ``DPLL_A_PIN_STATE``,
+   ``DPLL_A_PIN_DIRECTION``).
+
+MUX-type pins
+=============
+
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
+ {'clock-id': 282574471561216,
+  'module-name': 'ice',
+  'pin-dpll-caps': 4,
+  'pin-id': 13,
+  'pin-parent': [{'pin-id': 2, 'pin-state': 'connected'},
+                 {'pin-id': 3, 'pin-state': 'disconnected'},
+                 {'id': 0, 'pin-direction': 'input'},
+                 {'id': 1, 'pin-direction': 'input'}],
+  'pin-type': 'synce-eth-port'}
+}]``
+
+Only one child pin can provide its signal to the parent MUX-type pin at
+a time, the selection is done by requesting change of a child pin state
+on desired parent, with the use of ``DPLL_A_PIN_PARENT`` nested
+attribute. Example of netlink `set state on parent pin` message format:
+
+  =====================  =============================================
+  ``DPLL_A_PIN_ID``      child pin id
+  ``DPLL_A_PIN_PARENT``  nested attribute for requesting configuration
+                         related to parent pin
+    ``DPLL_A_PIN_ID``    parent pin id
+    ``DPLL_A_PIN_STATE`` requested pin state on parent
+
+Pin priority
+============
+
+Some devices might offer a capability of automatic pin selection mode
+(enum value ``DPLL_MODE_AUTOMATIC`` of ``DPLL_A_MODE`` attribute).
+Usually, automatic selection is performed on the hardware level, which
+means only pins directly connected to the dpll can be used for automatic
+input pin selection.
+In automatic selection mode, the user cannot manually select a input
+pin for the device, instead the user shall provide all directly
+connected pins with a priority ``DPLL_A_PIN_PRIO``, the device would
+pick a highest priority valid signal and use it to control the DPLL
+device. Example of netlink `set priority on parent pin` message format:
+
+  =====================  =============================================
+  ``DPLL_A_PIN_ID``      child pin id
+  ``DPLL_A_PIN_PARENT``  nested attribute for requesting configuration
+                         related to parent pin
+    ``DPLL_A_ID``        parent dpll id
+    ``DPLL_A_PIN_PRIO``  requested pin prio on parent dpll
+
+Child pin of MUX-type is not capable of automatic input pin selection,
+in order to configure a input of a MUX-type pin, the user needs to
+request desired pin state of the child pin on the parent pin,
+as described in the ``MUX-type pins`` chapter.
+
+Configuration commands group
+============================
+
+Configuration commands are used to get information about registered
+dpll devices (and pins), as well as set configuration of device or pins.
+As dpll devices must be abstracted and reflect real hardware,
+there is no way to add new dpll device via netlink from user space and
+each device should be registered by its driver.
+
+All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
+any spamming/DoS from unauthorized userspace applications.
+
+List of netlink commands with possible attributes
+=================================================
+
+All constants identifying command types use a ``DPLL_CMD_`` prefix and
+suffix according to command purpose. All attributes use a ``DPLL_A_``
+prefix and suffix according to attribute purpose:
+
+  ==================================== =================================
+  ``DPLL_CMD_DEVICE_ID_GET``           command to get device ID
+    ``DPLL_A_MODULE_NAME``             attr module name of registerer
+    ``DPLL_A_CLOCK_ID``                attr Unique Clock Identifier
+                                       (EUI-64), as defined by the
+                                       IEEE 1588 standard
+    ``DPLL_A_TYPE``                    attr type of dpll device
+  ``DPLL_CMD_DEVICE_GET``              command to get device info or
+                                       dump list of available devices
+    ``DPLL_A_ID``                      attr unique dpll device ID
+    ``DPLL_A_MODULE_NAME``             attr module name of registerer
+    ``DPLL_A_CLOCK_ID``                attr Unique Clock Identifier
+                                       (EUI-64), as defined by the
+                                       IEEE 1588 standard
+    ``DPLL_A_MODE``                    attr selection mode
+    ``DPLL_A_MODE_SUPPORTED``          attr available selection modes
+    ``DPLL_A_LOCK_STATUS``             attr dpll device lock status
+    ``DPLL_A_TEMP``                    attr device temperature info
+    ``DPLL_A_TYPE``                    attr type of dpll device
+  ``DPLL_CMD_DEVICE_SET``              command to set dpll device config
+    ``DPLL_A_ID``                      attr internal dpll device index
+    ``DPLL_A_MODE``                    attr selection mode to configure
+  ``DPLL_CMD_PIN_GET``                 command to get pin ID
+    ``DPLL_A_MODULE_NAME``             attr module name of registerer
+    ``DPLL_A_CLOCK_ID``                attr Unique Clock Identifier
+                                       (EUI-64), as defined by the
+                                       IEEE 1588 standard
+    ``DPLL_A_PIN_BOARD_LABEL``         attr pin board label provided
+                                       by registerer
+    ``DPLL_A_PIN_PANEL_LABEL``         attr pin panel label provided
+                                       by registerer
+    ``DPLL_A_PIN_PACKAGE_LABEL``       attr pin package label provided
+                                       by registerer
+    ``DPLL_A_PIN_TYPE``                attr type of a pin
+  ``DPLL_CMD_PIN_GET``                 command to get pin info or dump
+                                       list of available pins
+    ``DPLL_A_PIN_ID``                  attr unique a pin ID
+    ``DPLL_A_MODULE_NAME``             attr module name of registerer
+    ``DPLL_A_CLOCK_ID``                attr Unique Clock Identifier
+                                       (EUI-64), as defined by the
+                                       IEEE 1588 standard
+    ``DPLL_A_PIN_BOARD_LABEL``         attr pin board label provided
+                                       by registerer
+    ``DPLL_A_PIN_PANEL_LABEL``         attr pin panel label provided
+                                       by registerer
+    ``DPLL_A_PIN_PACKAGE_LABEL``       attr pin package label provided
+                                       by registerer
+    ``DPLL_A_PIN_TYPE``                attr type of a pin
+    ``DPLL_A_PIN_DIRECTION``           attr direction of a pin
+    ``DPLL_A_PIN_FREQUENCY``           attr current frequency of a pin
+    ``DPLL_A_PIN_FREQUENCY_SUPPORTED`` nested attr provides supported
+                                       frequencies
+      ``DPLL_A_PIN_ANY_FREQUENCY_MIN`` attr minimum value of frequency
+      ``DPLL_A_PIN_ANY_FREQUENCY_MAX`` attr maximum value of frequency
+    ``DPLL_A_PIN_PARENT``              nested attr for each parent the
+                                       pin is connected with
+      ``DPLL_A_ID``                    attr provided if parent is dpll
+                                       device
+      ``DPLL_A_PIN_ID``                attr provided if parent is a pin
+      ``DPLL_A_PIN_PRIO``              attr priority of pin on the
+                                       dpll device
+      ``DPLL_A_PIN_STATE``             attr state of pin on the dpll
+                                       device or on the parent pin
+    ``DPLL_A_PIN_DPLL_CAPS``           attr bitmask of pin-dpll
+                                       capabilities
+  ``DPLL_CMD_PIN_SET``                 command to set pins configuration
+    ``DPLL_A_PIN_ID``                  attr unique a pin ID
+    ``DPLL_A_PIN_DIRECTION``           attr requested direction of a pin
+    ``DPLL_A_PIN_FREQUENCY``           attr requested frequency of a pin
+    ``DPLL_A_PIN_PARENT``              nested attr for each parent
+                                       related configuration of a pin
+                                       requested
+      ``DPLL_A_ID``                    attr provided if parent is dpll
+                                       device
+      ``DPLL_A_PIN_ID``                attr provided if parent is a pin
+      ``DPLL_A_PIN_PRIO``              attr requested priority of pin on
+                                       the dpll device
+      ``DPLL_A_PIN_STATE``             attr requested state of pin on
+                                       the dpll device or on the parent
+                                       pin
+
+Netlink dump requests
+=====================
+
+The ``DPLL_CMD_DEVICE_GET`` and ``DPLL_CMD_PIN_GET`` commands are
+capable of dump type netlink requests, in which case the response is in
+the same format as for their ``do`` request, but every device or pin
+registered in the system is returned.
+
+SET commands format
+===================
+
+``DPLL_CMD_DEVICE_SET`` - to target a dpll device, the user provides
+``DPLL_A_ID``, which is unique identifier of dpll device in the system,
+as well as parameter being configured (``DPLL_A_MODE``).
+
+``DPLL_CMD_PIN_SET`` - to target a pin user has to provide a
+``DPLL_A_PIN_ID``, which is unique identifier of a pin in the system.
+Also configured pin parameters must be added.
+If ``DPLL_A_PIN_DIRECTION`` or ``DPLL_A_PIN_FREQUENCY`` are configured,
+this affects all the dpll device they are connected, that is why those
+attributes shall not be enclosed in ``DPLL_A_PIN_PARENT``.
+Other attributes:
+``DPLL_A_PIN_PRIO`` or ``DPLL_A_PIN_STATE`` must be enclosed in
+``DPLL_A_PIN_PARENT`` as their configuration relates to only one
+parent dpll or parent pin.
+Nested attribute of either ``DPLL_A_ID`` or ``DPLL_A_PIN_ID`` determines
+if configuration was requested on a dpll device or on a pin
+respectively.
+In general, it is possible to configure multiple parameters at once, but
+internally each parameter change will be invoked separately, where order
+of configuration is not guaranteed by any means.
+
+Device level configuration pre-defined enums
+=================================================
+
+Values for ``DPLL_A_LOCK_STATUS`` attribute:
+
+  ================================== ===================================
+  ``DPLL_LOCK_STATUS_UNLOCKED``      dpll device is in freerun, not
+                                     locked to any input pin
+  ``DPLL_LOCK_STATUS_LOCKED``        dpll device is locked to the input
+                                     but no holdover capability yet
+                                     acquired
+  ``DPLL_LOCK_STATUS_LOCKED_HO_ACQ`` dpll device is locked to the input
+                                     pin with holdover capability
+                                     acquired
+  ``DPLL_LOCK_STATUS_HOLDOVER``      dpll device lost a lock, using its
+                                     frequency holdover capabilities
+
+Values for ``DPLL_A_MODE`` attribute:
+
+  ======================= ==============================================
+  ``DPLL_MODE_MANUAL``    input pin is manually selected by setting pin
+                          state to ``DPLL_PIN_STATE_CONNECTED`` on a
+                          dpll device
+  ``DPLL_MODE_AUTOMATIC`` input pin is auto selected according to
+                          configured pin priorities and input signal
+                          validity
+  ``DPLL_MODE_HOLDOVER``  force holdover mode of dpll
+  ``DPLL_MODE_FREERUN``   dpll device is driven by supplied system clock
+                          without holdover capabilities
+
+Values for ``DPLL_A_TYPE`` attribute:
+
+  ================= ===================================================
+  ``DPLL_TYPE_PPS`` dpll device used to provide pulse-per-second output
+  ``DPLL_TYPE_EEC`` dpll device used to drive ethernet equipment clock
+
+Pin level configuration pre-defined enums
+=========================================
+
+Values for ``DPLL_A_PIN_STATE`` attribute:
+
+  =============================== ======================================
+  ``DPLL_PIN_STATE_CONNECTED``    Pin used as active input for a dpll
+                                  device or for a parent pin
+  ``DPLL_PIN_STATE_DISCONNECTED`` Pin disconnected from a dpll device or
+                                  from a parent pin
+  ``DPLL_PIN_STATE_SELECTABLE``   Pin enabled for automatic selection
+
+Values for ``DPLL_A_PIN_DIRECTION`` attribute:
+
+  ============================= ====================================
+  ``DPLL_PIN_DIRECTION_INPUT``  used to provide its signal to a dpll
+                                device
+  ``DPLL_PIN_DIRECTION_OUTPUT`` used to output the signal from a dpll
+                                device
+
+Values for ``DPLL_A_PIN_TYPE`` attributes:
+
+  ================================ =====================================
+  ``DPLL_PIN_TYPE_MUX``            MUX type pin, connected pins shall
+                                   have their own types
+  ``DPLL_PIN_TYPE_EXT``            External pin
+  ``DPLL_PIN_TYPE_SYNCE_ETH_PORT`` SyncE on Ethernet port
+  ``DPLL_PIN_TYPE_INT_OSCILLATOR`` Internal Oscillator (i.e. Holdover
+                                   with Atomic Clock as an input)
+  ``DPLL_PIN_TYPE_GNSS``           GNSS 1PPS input
+
+Values for ``DPLL_A_PIN_DPLL_CAPS`` attributes:
+
+  ====================================== ===============================
+  ``DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE`` Bit present if direction of
+                                         pin can change
+  ``DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE``  Bit present if priority of pin
+                                         can change
+  ``DPLL_PIN_CAPS_STATE_CAN_CHANGE``     Bit present if state of pin can
+                                         change
+
+Notifications
+=============
+
+dpll device can provide notifications regarding status changes of the
+device, i.e. lock status changes, input/output changes or other alarms.
+There is one multicast group that is used to notify user-space apps via
+netlink socket: ``DPLL_MCGRP_MONITOR``
+
+Notifications messages:
+
+  ============================== =====================================
+  ``DPLL_CMD_DEVICE_CREATE_NTF`` dpll device was created
+  ``DPLL_CMD_DEVICE_DELETE_NTF`` dpll device was deleted
+  ``DPLL_CMD_DEVICE_CHANGE_NTF`` dpll device has changed
+  ``DPLL_CMD_PIN_CREATE_NTF``    dpll pin was created
+  ``DPLL_CMD_PIN_DELETE_NTF``    dpll pin was deleted
+  ``DPLL_CMD_PIN_CHANGE_NTF``    dpll pin has changed
+
+Events format is the same as for the corresponding get command.
+Format of ``DPLL_CMD_DEVICE_`` events is the same as response of
+``DPLL_CMD_DEVICE_GET``.
+Format of ``DPLL_CMD_PIN_`` events is same as response of
+``DPLL_CMD_PIN_GET``.
+
+Device driver implementation
+============================
+
+Device is allocated by dpll_device_get() call. Second call with the
+same arguments will not create new object but provides pointer to
+previously created device for given arguments, it also increases
+refcount of that object.
+Device is deallocated by dpll_device_put() call, which first
+decreases the refcount, once refcount is cleared the object is
+destroyed.
+
+Device should implement set of operations and register device via
+dpll_device_register() at which point it becomes available to the
+users. Multiple driver instances can obtain reference to it with
+dpll_device_get(), as well as register dpll device with their own
+ops and priv.
+
+The pins are allocated separately with dpll_pin_get(), it works
+similarly to dpll_device_get(). Function first creates object and then
+for each call with the same arguments only the object refcount
+increases. Also dpll_pin_put() works similarly to dpll_device_put().
+
+A pin can be registered with parent dpll device or parent pin, depending
+on hardware needs. Each registration requires registerer to provide set
+of pin callbacks, and private data pointer for calling them:
+- dpll_pin_register() - register pin with a dpll device,
+- dpll_pin_on_pin_register() - register pin with another MUX type pin.
+
+Notifications of adding or removing dpll devices are created within
+subsystem itself.
+Notifications about registering/deregistering pins are also invoked by
+the subsystem.
+Notifications about status changes either of dpll device or a pin are
+invoked in two ways:
+- after successful change was requested on dpll subsystem, the subsystem
+  calls corresponding notification,
+- requested by device driver with dpll_device_change_ntf() or
+  dpll_pin_change_ntf() when driver informs about the status change.
+
+The device driver using dpll interface is not required to implement all
+the callback operation. Neverthelessi, there are few required to be
+implemented.
+Required dpll device level callback operations:
+- ``.mode_get``,
+- ``.lock_status_get``.
+
+Required pin level callback operations:
+- ``.state_get`` (pins registered with dpll device),
+- ``.state_on_pin_get`` (pins registered with parent pin),
+- ``.direction_get``.
+
+Every other operation handler is checked for existence and
+``-ENOTSUPP`` is returned in case of absence of specific handler.
+
+SyncE enablement
+================
+For SyncE enablement it is required to allow control over dpll device
+for a software application which monitors and configures the inputs of
+dpll device in response to current state of a dpll device and its
+inputs.
+In such scenario, dpll device input signal shall be also configurable
+to drive dpll with signal recovered from the PHY netdevice.
+This is done by exposing a pin to the netdevice - attaching pin to the
+netdevice itself with:
+netdev_dpll_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin);
+Exposed pin id handle ``DPLL_A_PIN_ID`` is then identifiable by the user
+as it is attached to rtnetlink respond to get ``RTM_NEWLINK`` command in
+nested attribute ``IFLA_DPLL_PIN``.
diff --git a/Documentation/driver-api/index.rst b/Documentation/driver-api/index.rst
index ff9aa1afdc62..8c017dc51514 100644
--- a/Documentation/driver-api/index.rst
+++ b/Documentation/driver-api/index.rst
@@ -113,6 +113,7 @@ available subsections can be seen below.
    xillybus
    zorro
    hte/index
+   dpll
 
 .. only::  subproject and html
 
-- 
2.37.3


