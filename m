Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36F46B9AD3
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbjCNQPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCNQPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:15:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6811999D7E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:14:49 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l12so6593164wrm.10
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678810488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AV9SREcrL6QKpZ2wurUrQ13yI9lfNjB+lRREEn0lHxk=;
        b=dWIwKFFcNpeC63D2f3Jn26yTPokHDcIU6QuW06jsB1zFJLTo736CkTWGc5e+W8H8Gy
         l0psP1xxF3j2uIQKx3ETLwxuHm5srl0eEeIueAivCTLylgYOf3gc0p7hcBUd4zEtWDWC
         ljGAiqikPlIemlNg5gJdn6lT89zENXkBh9x1bUjOSvVNV+23wS55FRca0sMXgJllmzpu
         gcB8+kHoToOjYIIEht0Xgr6tEs8ojJ9NWgu3PUO5Crjvtx0HYoWGe0MZcH0iQffWSIx6
         6WaMwxujxB1R6G7f4bZp3McmYk8f1Vy3Phn3qafu35ev36kchjAvN3Pum73nV1FPXIb3
         468Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AV9SREcrL6QKpZ2wurUrQ13yI9lfNjB+lRREEn0lHxk=;
        b=r60EHNrjW3wNqVVeiFJWTdfk1xaB7s7LXZa7mf2rbgpUQZfiaT2OkvVQoKT0DWMmTU
         fmGblSyCW/9uFiJ7SA1MiULuh2yHnbB7+9f96XPVUWlSoA6tMpFmVRf9zo0cuEvWsiRs
         7oKw1ezoHEB+JxtVZffiycXvp2n5dbZRSDXQGmi7jHYh4KOrgXVLRbWKD1qrVwn8o4lk
         WWyU8DF+4cIk7dQmD1ofyZC5w/ba+4IwUzj8Vvq2imzkMxjO+1AKh8Q6fYPEbr04wCgM
         k/ZCVIgiqssnMl9WV/DJc3BPsxlu2l1RrNrnqs+oWOragg8vd62VCBlvHDKTbAjpRwnB
         Kh2g==
X-Gm-Message-State: AO0yUKW8DldhJoux3VpIJPNqNLLM+osHATbVlXNVFwHSD0SvXwy+fNq8
        qz0/gWUfoC9J1BfCwavxR+/dHg==
X-Google-Smtp-Source: AK7set8q9MCWPL1Zr6KRlyPU+uOMZIUDRQj0mxL5uNyg4Q1vLSPit+p3mnLXkuJomxyeoPYcZcuNLA==
X-Received: by 2002:adf:f846:0:b0:2c7:d575:e8a4 with SMTP id d6-20020adff846000000b002c7d575e8a4mr23626825wrq.65.1678810487800;
        Tue, 14 Mar 2023 09:14:47 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d468d000000b002cff06039d7sm312088wrq.39.2023.03.14.09.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:14:47 -0700 (PDT)
Date:   Tue, 14 Mar 2023 17:14:45 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH RFC v6 3/6] dpll: documentation on DPLL subsystem
 interface
Message-ID: <ZBCddQzjRHvYifzi@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-4-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-4-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:04AM CET, vadfed@meta.com wrote:
>Add documentation explaining common netlink interface to configure DPLL
>devices and monitoring events. Common way to implement DPLL device in
>a driver is also covered.
>
>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>---
> Documentation/networking/dpll.rst  | 347 +++++++++++++++++++++++++++++
> Documentation/networking/index.rst |   1 +
> 2 files changed, 348 insertions(+)
> create mode 100644 Documentation/networking/dpll.rst
>
>diff --git a/Documentation/networking/dpll.rst b/Documentation/networking/dpll.rst
>new file mode 100644
>index 000000000000..25cd81edc73c
>--- /dev/null
>+++ b/Documentation/networking/dpll.rst
>@@ -0,0 +1,347 @@
>+.. SPDX-License-Identifier: GPL-2.0
>+
>+===============================
>+The Linux kernel DPLL subsystem
>+===============================
>+
>+
>+The main purpose of DPLL subsystem is to provide general interface
>+to configure devices that use any kind of Digital PLL and could use
>+different sources of signal to synchronize to as well as different
>+types of outputs.
>+The main interface is NETLINK_GENERIC based protocol with an event
>+monitoring multicast group defined.
>+
>+
>+Dpll object

rather perhaps "Device object"?


>+===========
>+Single dpll device object means single Digital PLL circuit and bunch of
>+pins connected with it.
>+It provides its capablities and current status to the user in response

Which capabilities you have in mind. There is CAPs for pins, but I see
none for device.


>+to the `do` request of netlink command ``DPLL_CMD_DEVICE_GET`` and list
>+of dplls registered in the subsystem with `dump` netlink request of same
>+command.
>+Requesting configuration of dpll device is done with `do` request of
>+netlink ``DPLL_CMD_DEVICE_SET`` command.
>+
>+
>+Pin object
>+==========
>+A pin is amorphic object which represents either input or output, it

In the code and UAPI you use terms "source" and "output". Please align
to that.


>+could be internal component of the device, as well as externaly
>+connected.
>+The number of pins per dpll vary, but usually multiple pins shall be
>+provided for a single dpll device.
>+Pin's properities and capabilities are provided to the user in response

s/properities/properties/

There is more provided, like "status" for example.


>+to `do` request of netlink ``DPLL_CMD_PIN_GET`` command.
>+It is also possible to list all the pins that were registered either
>+with dpll or different pin with `dump` request of ``DPLL_CMD_PIN_GET``

I don't follow. Dump of DPLL_CMD_PIN_GET just dumps always all the pins
in the system. Am I missing something?


>+command.
>+Configuration of a pin can be changed by `do` request of netlink
>+``DPLL_CMD_PIN_SET`` command.
>+
>+
>+Shared pins
>+===========
>+Pin can be shared by multiple dpll devices. Where configuration on one
>+pin can alter multiple dplls (i.e. PIN_FREQUENCY, PIN_DIRECTION),
>+or configure just one pin-dpll pair (i.e. PIN_PRIO, PIN_STATE).

Perhaps this can be extended to something like this:

A single pin object can be registered to multiple dpll devices.
Then there are two groups of configuration knobs:
1) Set on a pin - the configuration affects all dpll devices pin is
   registered to. (i.e. PIN_FREQUENCY, PIN_DIRECTION),
2) Set on a pin-dpll tuple - the configuration affects only selected
   dpll device. (i.e. PIN_PRIO, PIN_STATE).


>+
>+
>+MUX-type pins
>+=============
>+A pin can be MUX-type, which aggregates child pins and serves as pin
>+multiplexer. One or more pins are attached to MUX-type instead of being
>+directly connected to a dpll device.

Perhaps you can say "registered" in stead of "connected" and "attached"
so this is aligned with the function names?


>+Pins registered with a MUX-type provides user with additional nested

s/provides/provide/


>+attribute ``DPLL_A_PIN_PARENT`` for each parrent they were registered

s/parrent/parent/

I'm confused. Can one pin be registered to multiple parents? How is that
supposed to be working?


>+with.
>+Only one child pin can provide it's signal to the parent MUX-type pin at
>+a time, the selection is done with requesting change of child pin state
>+to ``DPLL_PIN_STATE_CONNECTED`` and providing a target MUX-type pin
>+index value in ``DPLL_A_PARENT_PIN_IDX``
>+
>+
>+Pin priority
>+============
>+Some devices might offer a capability of automatic pin selection mode.

Tell the enum value.


>+Usually such automatic selection is offloaded to the hardware,
>+which means only pins directly connected to the dpll are capable of
>+automatic source pin selection.
>+In automatic selection mode, the user cannot manually select a source
>+pin for the device, instead the user shall provide all directly
>+connected pins with a priority ``DPLL_A_PIN_PRIO``, the device would
>+pick a highest priority valid signal and connect with it.
>+Child pin of MUX-type are not capable of automatic source pin selection,

s/are not/is not/


>+in order to configure a source of a MUX-type pin the user still needs
>+to request desired pin state.

Perhaps emphasize that this is the state of the child?


>+
>+
>+Configuration commands group
>+============================
>+
>+Configuration commands are used to get or dump information about
>+registered DPLL devices (and pins), as well as set configuration of
>+device or pins. As DPLL device could not be abstract and reflects real
>+hardware, there is no way to add new DPLL device via netlink from user
>+space and each device should be registered by it's driver.
>+
>+All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
>+any spamming/D.o.S. from unauthorized userspace applications.
>+
>+List of command with possible attributes
>+========================================
>+
>+All constants identifying command types use ``DPLL_CMD_`` prefix and
>+suffix according to command purpose. All attributes use ``DPLL_A_``
>+prefix and suffix according to attribute purpose:
>+
>+  ============================  =======================================
>+  ``DEVICE_GET``                command to get device info or dump list
>+                                of available devices
>+    ``ID``                      attr internal dpll device ID
>+    ``DEV_NAME``                attr dpll device name
>+    ``BUS_NAME``                attr dpll device bus name
>+    ``MODE``                    attr selection mode
>+    ``MODE_SUPPORTED``          attr available selection modes
>+    ``SOURCE_PIN_IDX``          attr index of currently selected source
>+    ``LOCK_STATUS``             attr internal frequency-lock status
>+    ``TEMP``                    attr device temperature information
>+    ``CLOCK_ID``                attr Unique Clock Identifier (EUI-64),
>+                                as defined by the IEEE 1588 standard
>+    ``TYPE``                    attr type or purpose of dpll device
>+  ``DEVICE_SET``                command to set dpll device configuration
>+    ``ID``                      attr internal dpll device index
>+    ``NAME``                    attr dpll device name (not required if
>+                                dpll device index was provided)
>+    ``MODE``                    attr selection mode to configure
>+  ``PIN_GET``                   command to get pin info or dump list of
>+                                available pins
>+    ``DEVICE``                  nest attr for each dpll device pin is
>+                                connected with

Ah, now I understand what this is about. Didn't occur to me from the
netlink UAPI :/


>+      ``ID``                    attr internal dpll device ID
>+      ``DEV_NAME``              attr dpll device name
>+      ``BUS_NAME``              attr dpll device bus name
>+      ``PIN_PRIO``              attr priority of pin on the dpll device
>+      ``PIN_STATE``             attr state of pin on the dpll device
>+    ``PIN_IDX``                 attr index of a pin on the dpll device
>+    ``PIN_DESCRIPTION``         attr description provided by driver
>+    ``PIN_TYPE``                attr type of a pin
>+    ``PIN_DIRECTION``           attr direction of a pin
>+    ``PIN_FREQUENCY``           attr current frequency of a pin
>+    ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
>+    ``PIN_ANY_FREQUENCY_MIN``   attr minimum value of frequency in case
>+                                pin/dpll supports any frequency
>+    ``PIN_ANY_FREQUENCY_MAX``   attr maximum value of frequency in case
>+                                pin/dpll supports any frequency
>+    ``PIN_PARENT``              nest attr for each MUX-type parent, that
>+                                pin is connected with
>+      ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
>+                                device
>+      ``PIN_STATE``             attr state of a pin on parent pin
>+    ``PIN_RCLK_DEVICE``         attr name of a device, where pin
>+                                recovers clock signal from
>+    ``PIN_DPLL_CAPS``           attr bitmask of pin-dpll capabilities
>+
>+  ``PIN_SET``                   command to set pins configuration
>+    ``ID``                      attr internal dpll device index
>+    ``BUS_NAME``                attr dpll device name (not required if
>+                                dpll device ID was provided)
>+    ``DEV_NAME``                attr dpll device name (not required if
>+                                dpll device ID was provided)
>+    ``PIN_IDX``                 attr index of a pin on the dpll device
>+    ``PIN_DIRECTION``           attr direction to be set
>+    ``PIN_FREQUENCY``           attr frequency to be set
>+    ``PIN_PRIO``                attr pin priority to be set
>+    ``PIN_STATE``               attr pin state to be set
>+    ``PIN_PRIO``                attr pin priority to be set

I think it would be good to emhasize which attribute is valid in which
combination, meaning alone, dpll needs to be specified, parent pin needs
to be specified


>+    ``PIN_PARENT_IDX``          attr if provided state is to be set with
>+                                parent pin instead of with dpll device
>+
>+Netlink dump requests
>+=====================
>+
>+The ``DEVICE_GET`` and ``PIN_GET`` commands are capable of dump type
>+netlink requests. Possible response message attributes for netlink dump
>+requests:
>+
>+  ==============================  =======================================
>+  ``PIN_GET``                     command to dump pins

Maintain the order and start with DEVICE_GET 



>+    ``PIN``                       attr nested type contains single pin
>+      ``DEVICE``                  nest attr for each dpll device pin is
>+                                  connected with
>+        ``ID``                    attr internal dpll device ID
>+        ``DEV_NAME``              attr dpll device name
>+        ``BUS_NAME``              attr dpll device bus name
>+      ``PIN_IDX``                 attr index of dumped pin (on dplls)
>+      ``PIN_DESCRIPTION``         description of a pin provided by driver
>+      ``PIN_TYPE``                attr value of pin type
>+      ``PIN_FREQUENCY``           attr current frequency of a pin
>+      ``PIN_FREQUENCY_SUPPORTED`` attr provides supported frequencies
>+      ``PIN_RCLK_DEVICE``         attr name of a device, where pin
>+                                  recovers clock signal from
>+      ``PIN_DIRECTION``           attr direction of a pin
>+      ``PIN_PARENT``              nest attr for each MUX-type parent,
>+                                  that pin is connected with
>+        ``PIN_PARENT_IDX``        attr index of a parent pin on the dpll
>+                                  device
>+        ``PIN_STATE``             attr state of a pin on parent pin
>+
>+  ``DEVICE_GET``                  command to dump dplls
>+    ``DEVICE``                    attr nested type contatin a single
>+                                  dpll device
>+      ``ID``                      attr internal dpll device ID
>+      ``DEV_NAME``                attr dpll device name
>+      ``BUS_NAME``                attr dpll device bus name

Hmm, why you need to repeat this for dump? Just say the message format
is the same as for DO and you are done with it.


>+
>+
>+Dpll device level configuration pre-defined enums
>+=================================================
>+
>+For all below enum names used for configuration of dpll device use
>+the ``DPLL_`` prefix.
>+
>+Values for ``DPLL_A_LOCK_STATUS`` attribute:
>+
>+  ============================= ======================================
>+  ``LOCK_STATUS_UNLOCKED``      DPLL is in freerun, not locked to any
>+                                source pin
>+  ``LOCK_STATUS_CALIBRATING``   DPLL device calibrates to lock to the
>+                                source pin signal
>+  ``LOCK_STATUS_LOCKED``        DPLL device is locked to the source
>+                                pin frequency
>+  ``LOCK_STATUS_HOLDOVER``      DPLL device lost a lock, using its
>+                                frequency holdover capabilities
>+
>+Values for ``DPLL_A_MODE`` attribute:
>+
>+  =================== ================================================
>+  ``MODE_FORCED``     source pin is force-selected by setting pin
>+                      state to ``DPLL_PIN_STATE_CONNECTED`` on a dpll
>+  ``MODE_AUTOMATIC``  source pin is auto selected according to
>+                      configured pin priorities and source signal
>+                      validity
>+  ``MODE_HOLDOVER``   force holdover mode of DPLL
>+  ``MODE_FREERUN``    DPLL is driven by supplied system clock without
>+                      holdover capabilities
>+  ``MODE_NCO``        similar to FREERUN, with possibility to
>+                      numerically control frequency offset
>+
>+Values for ``DPLL_A_TYPE`` attribute:
>+
>+  ============= ================================================
>+  ``TYPE_PPS``  DPLL used to provide pulse-per-second output
>+  ``TYPE_EEC``  DPLL used to drive ethernet equipment clock
>+
>+
>+
>+Pin level configuration pre-defined enums
>+=========================================
>+
>+For all below enum names used for configuration of pin use the
>+``DPLL_PIN`` prefix.
>+
>+Values for ``DPLL_A_PIN_STATE`` attribute:
>+
>+  ======================= ========================================
>+  ``STATE_CONNECTED``     Pin connected to a dpll or parent pin
>+  ``STATE_DISCONNECTED``  Pin disconnected from dpll or parent pin
>+
>+Values for ``DPLL_A_PIN_DIRECTION`` attribute:
>+
>+  ======================= ==============================
>+  ``DIRECTION_SOURCE``    Pin used as a source of signal
>+  ``DIRECTION_OUTPUT``    Pin used to output signal
>+
>+Values for ``DPLL_A_PIN_TYPE`` attributes:
>+
>+  ======================== ========================================
>+  ``TYPE_MUX``             MUX type pin, connected pins shall have
>+                           their own types
>+  ``TYPE_EXT``             External pin
>+  ``TYPE_SYNCE_ETH_PORT``  SyncE on Ethernet port
>+  ``TYPE_INT_OSCILLATOR``  Internal Oscillator (i.e. Holdover with
>+                           Atomic Clock as a Source)
>+  ``TYPE_GNSS``            GNSS 1PPS source
>+
>+Values for ``DPLL_A_PIN_DPLL_CAPS`` attributes:
>+
>+  ============================= ================================
>+  ``CAPS_DIRECTION_CAN_CHANGE`` Bit present if direction can change
>+  ``CAPS_PRIORITY_CAN_CHANGE``  Bit present if priority can change
>+  ``CAPS_STATE_CAN_CHANGE``     Bit present if state can change
>+
>+
>+Notifications
>+=============
>+
>+DPLL device can provide notifications regarding status changes of the
>+device, i.e. lock status changes, source/output type changes or alarms.
>+This is the multicast group that is used to notify user-space apps via
>+netlink socket: ``DPLL_MCGRP_MONITOR``
>+
>+Notifications messages (attrbiutes use ``DPLL_A`` prefix):
>+
>+  ========================= ==========================================
>+  ``EVENT_DEVICE_CREATE``   event value new DPLL device was created
>+    ``ID``                  attr internal dpll device ID
>+    ``DEV_NAME``            attr dpll device name
>+    ``BUS_NAME``            attr dpll device bus name
>+  ``EVENT_DEVICE_DELETE``   event value DPLL device was deleted
>+    ``ID``                  attr dpll device index
>+  ``EVENT_DEVICE_CHANGE``   event value DPLL device attribute has
>+                            changed
>+    ``ID``                  attr modified dpll device ID
>+    ``PIN_IDX``             attr the modified pin index
>+
>+Device change event shall consiste of the attribute and the value that
>+has changed.
>+
>+
>+Device driver implementation
>+============================
>+
>+Device is allocated by ``dpll_device_get`` call. Second call with the
>+same arguments doesn't create new object but provides pointer to
>+previously created device for given arguments, it also increase refcount
>+of that object.
>+Device is deallocated by ``dpll_device_put`` call, which first decreases
>+the refcount, once refcount is cleared the object is destroyed.
>+
>+Device should implement set of operations and register device via
>+``dpll_device_register`` at which point it becomes available to the
>+users. Only one driver can register a dpll device within dpll subsytem.

"Driver instance". Btw, I need to change it for mlx5. I will try to
implement it in coming days.


>+Multiple driver instances can obtain reference to it with
>+``dpll_device_get``.
>+
>+The pins are allocated separately with ``dpll_pin_get``, it works
>+similarly to ``dpll_device_get``. Creates object and the for each call
>+with the same arguments the object refcount increases.
>+
>+Once DPLL device is created, allocated pin can be registered with it

In this text, you use "dpll", "Dpll", "DPLL". Could you unify?



>+with 2 different methods, always providing implemented pin callbacks,
>+and private data pointer for calling them:
>+``dpll_pin_register`` - simple registration with a dpll device.
>+``dpll_pin_on_pin_register`` - register pin with another MUX type pin.
>+
>+For different instances of a device driver requiring to find already
>+registered DPLL (i.e. to connect its pins to id) use ``dpll_device_get``

s/to id/to it/


>+to obtain proper dpll device pointer.
>+
>+The name od DPLL device is generated based on registerer provided device

s/name od/name of/


>+struct pointer and dev_driver_id value.
>+Name is in format: ``%s_%u`` witch arguments:
>+``dev_name(struct device *)`` - syscall on parent device struct
>+``dev_driver_idx``            - registerer given id
>+
>+Notifications of adding or removing DPLL devices are created within
>+subsystem itself.
>+Notifications about registering/deregistering pins are also invoked by
>+the subsystem.
>+Notifications about dpll status changes shall be requested by device
>+driver with ``dpll_device_notify`` corresponding attribute as a reason.
>+
>+There is no strict requirement to implement all the operations for
>+each device, every operation handler is checked for existence and
>+ENOTSUPP is returned in case of absence of specific handler.

Not sure internal implementation details are necessary. Just say that
driver is free to implement a set of ops it supports, leave the rest not
implemented.


>+
>diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
>index 4ddcae33c336..6eb83a47cc2d 100644
>--- a/Documentation/networking/index.rst
>+++ b/Documentation/networking/index.rst
>@@ -17,6 +17,7 @@ Contents:
>    dsa/index
>    devlink/index
>    caif/index
>+   dpll
>    ethtool-netlink
>    ieee802154
>    j1939
>-- 
>2.34.1
>
