Return-Path: <netdev+bounces-275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B878C6F6ABF
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A9C6280D3E
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CACBFBEF;
	Thu,  4 May 2023 12:02:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE83FBE1
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:02:38 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101F85FCE
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 05:02:34 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-306f9df5269so243940f8f.3
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 05:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683201752; x=1685793752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TexwvfATyT6tg0+RarmoKWt3lxWf2GgNqNGSaEA2CJ4=;
        b=nBpbKzvRGdjo2TYEedCeisw4lispYmN2oY8l65XCA9EwUfnSygAKOOGKpt2rejHAMW
         Ar0MuDltJCicoqgeTEAyx8C6q+5Xe/NkDeBdEdeCrxlLEULhoh7gPsbMNqxF/w50PXA6
         a8IqRVeIkNC4sv33LClEhnsypHIJecbgSDlmyDlvnAD03XeBDFNT6Ud0+c2D/67Co7vn
         0UEEIKX9taBA/n/J3Lfr0Ls1Iq4HNqg7y8Ic/DSanwRB4qqj4GY2ezmj6daZnf88qFQ4
         IDGEMyIjdhTstX5PhiKkRy14CvQjlX3AqQoptmDdOGORgAcBzT3AX7cvUNjxNi5zFMRB
         fmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683201752; x=1685793752;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TexwvfATyT6tg0+RarmoKWt3lxWf2GgNqNGSaEA2CJ4=;
        b=Wd1ir3KK7xVxjT/WqylPxZlA9aqqTrMQo5TqcnIaUqmMv+cRvJL2ddGm599emC55L+
         7hcDC7EVQveTc70So0Hfw0Npdwkiws50/yMy0oObfE5gI/BFDemygbuvgCzGcsH/Ug6k
         lpLiugHWEHM3nA34FiFU1ET5ziYjxanTXAKw+TfXLA68ztZpDk8V5A2+9U2jUsD5O3uT
         yJQqBF9aGk+BL3GCFci7/Aw+md4IW5Hegwo0mialfXOHsO9sWQyKejVuo7SpKt9zGTCo
         kt4AGo0KAPKb+WVsK84UV+UQijj6s2jlI4gf8lVsXvqwmjUv2CNA+R/WKe0mBv0Jm8bT
         O3RA==
X-Gm-Message-State: AC+VfDwv2wRMYfzwNbQY0j+dL3fsQTcjmFyGsfr0r66uZHmRUY/jXd5c
	C3KmpL/KcZUNeEVh1g7yrVUrvA==
X-Google-Smtp-Source: ACHHUZ77emXs2qY5hJbkaw4QdG4z/fhkFI9yDwthU1rJMFKAS4uSsRHEyPr8bu5eCkCBd3t0b1IODQ==
X-Received: by 2002:a5d:5689:0:b0:304:8149:239b with SMTP id f9-20020a5d5689000000b003048149239bmr2316908wrv.50.1683201752212;
        Thu, 04 May 2023 05:02:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t10-20020a05600001ca00b002fab755e10bsm36415873wrx.68.2023.05.04.05.02.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 05:02:31 -0700 (PDT)
Date: Thu, 4 May 2023 14:02:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZFOe1sMFtAOwSXuO@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-2-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:02AM CEST, vadfed@meta.com wrote:
>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>Add a protocol spec for DPLL.
>Add code generated from the spec.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Michal Michalik <michal.michalik@intel.com>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>---
> Documentation/netlink/specs/dpll.yaml | 472 ++++++++++++++++++++++++++
> drivers/dpll/dpll_nl.c                | 126 +++++++
> drivers/dpll/dpll_nl.h                |  42 +++
> include/uapi/linux/dpll.h             | 202 +++++++++++
> 4 files changed, 842 insertions(+)
> create mode 100644 Documentation/netlink/specs/dpll.yaml
> create mode 100644 drivers/dpll/dpll_nl.c
> create mode 100644 drivers/dpll/dpll_nl.h
> create mode 100644 include/uapi/linux/dpll.h
>
>diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
>new file mode 100644
>index 000000000000..67ca0f6cf2d5
>--- /dev/null
>+++ b/Documentation/netlink/specs/dpll.yaml
>@@ -0,0 +1,472 @@
>+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>+
>+name: dpll
>+
>+doc: DPLL subsystem.
>+
>+definitions:
>+  -
>+    type: enum
>+    name: mode
>+    doc: |
>+      working-modes a dpll can support, differentiate if and how dpll selects
>+      one of its sources to syntonize with it, valid values for DPLL_A_MODE
>+      attribute
>+    entries:
>+      -
>+        name: unspec

In general, why exactly do we need unspec values in enums and CMDs?
What is the usecase. If there isn't please remove.


>+        doc: unspecified value
>+      -
>+        name: manual
>+        doc: source can be only selected by sending a request to dpll
>+      -
>+        name: automatic
>+        doc: highest prio, valid source, auto selected by dpll
>+      -
>+        name: holdover
>+        doc: dpll forced into holdover mode
>+      -
>+        name: freerun
>+        doc: dpll driven on system clk, no holdover available

Remove "no holdover available". This is not a state, this is a mode
configuration. If holdover is or isn't available, is a runtime info.


>+      -
>+        name: nco
>+        doc: dpll driven by Numerically Controlled Oscillator
>+    render-max: true
>+  -
>+    type: enum
>+    name: lock-status
>+    doc: |
>+      provides information of dpll device lock status, valid values for
>+      DPLL_A_LOCK_STATUS attribute
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: unlocked
>+        doc: |
>+          dpll was not yet locked to any valid source (or is in one of
>+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>+      -
>+        name: calibrating
>+        doc: dpll is trying to lock to a valid signal
>+      -
>+        name: locked
>+        doc: dpll is locked
>+      -
>+        name: holdover
>+        doc: |
>+          dpll is in holdover state - lost a valid lock or was forced by
>+          selecting DPLL_MODE_HOLDOVER mode

Is it needed to mention the holdover mode. It's slightly confusing,
because user might understand that the lock-status is always "holdover"
in case of "holdover" mode. But it could be "unlocked", can't it?
Perhaps I don't understand the flows there correctly :/


>+    render-max: true
>+  -
>+    type: const
>+    name: temp-divider
>+    value: 10
>+    doc: |
>+      temperature divider allowing userspace to calculate the
>+      temperature as float with single digit precision.
>+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
>+      tempearture value.

s/tempearture/temperature/

Didn't checkpatch warn you?


>+      Value of (DPLL_A_TEMP % DPLL_TEMP_DIVIDER) is fractional part of
>+      temperature value.
>+  -
>+    type: enum
>+    name: type
>+    doc: type of dpll, valid values for DPLL_A_TYPE attribute
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: pps
>+        doc: dpll produces Pulse-Per-Second signal
>+      -
>+        name: eec
>+        doc: dpll drives the Ethernet Equipment Clock
>+    render-max: true
>+  -
>+    type: enum
>+    name: pin-type
>+    doc: |
>+      defines possible types of a pin, valid values for DPLL_A_PIN_TYPE
>+      attribute
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: mux
>+        doc: aggregates another layer of selectable pins
>+      -
>+        name: ext
>+        doc: external source
>+      -
>+        name: synce-eth-port
>+        doc: ethernet port PHY's recovered clock
>+      -
>+        name: int-oscillator
>+        doc: device internal oscillator

Is this somehow related to the mode "nco" (Numerically Controlled
Oscillator)?



>+      -
>+        name: gnss
>+        doc: GNSS recovered clock
>+    render-max: true
>+  -
>+    type: enum
>+    name: pin-direction
>+    doc: |
>+      defines possible direction of a pin, valid values for
>+      DPLL_A_PIN_DIRECTION attribute
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: source
>+        doc: pin used as a source of a signal
>+      -
>+        name: output
>+        doc: pin used to output the signal
>+    render-max: true
>+  -
>+    type: const
>+    name: pin-frequency-1-hz
>+    value: 1
>+  -
>+    type: const
>+    name: pin-frequency-10-mhz
>+    value: 10000000
>+  -
>+    type: enum
>+    name: pin-state
>+    doc: |
>+      defines possible states of a pin, valid values for
>+      DPLL_A_PIN_STATE attribute
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: connected
>+        doc: pin connected, active source of phase locked loop
>+      -
>+        name: disconnected
>+        doc: pin disconnected, not considered as a valid source
>+      -
>+        name: selectable
>+        doc: pin enabled for automatic source selection
>+    render-max: true
>+  -
>+    type: flags
>+    name: pin-caps
>+    doc: |
>+      defines possible capabilities of a pin, valid flags on
>+      DPLL_A_PIN_CAPS attribute
>+    entries:
>+      -
>+        name: direction-can-change
>+      -
>+        name: priority-can-change
>+      -
>+        name: state-can-change
>+  -
>+    type: enum
>+    name: event
>+    doc: events of dpll generic netlink family
>+    entries:
>+      -
>+        name: unspec
>+        doc: invalid event type
>+      -
>+        name: device-create
>+        doc: dpll device created
>+      -
>+        name: device-delete
>+        doc: dpll device deleted
>+      -
>+        name: device-change

Please have a separate create/delete/change values for pins.


>+        doc: |
>+          attribute of dpll device or pin changed, reason is to be found with
>+          an attribute type (DPLL_A_*) received with the event
>+
>+
>+attribute-sets:
>+  -
>+    name: dpll
>+    enum-name: dplla
>+    attributes:
>+      -
>+        name: device
>+        type: nest
>+        value: 1

Why not 0?

Also, Plese don't have this attr as a first one. It is related to
PIN_GET/SET cmd, it should be somewhere among related attributes.

Definitelly, the handle ATTR/ATTTs should be the first one/ones.



>+        multi-attr: true
>+        nested-attributes: device
>+      -
>+        name: id
>+        type: u32
>+      -
>+        name: dev-name
>+        type: string
>+      -
>+        name: bus-name
>+        type: string
>+      -
>+        name: mode
>+        type: u8
>+        enum: mode
>+      -
>+        name: mode-supported
>+        type: u8
>+        enum: mode
>+        multi-attr: true
>+      -
>+        name: lock-status
>+        type: u8
>+        enum: lock-status
>+      -
>+        name: temp
>+        type: s32
>+      -
>+        name: clock-id
>+        type: u64
>+      -
>+        name: type
>+        type: u8
>+        enum: type
>+      -
>+        name: pin-idx
>+        type: u32
>+      -
>+        name: pin-label
>+        type: string
>+      -
>+        name: pin-type
>+        type: u8
>+        enum: pin-type
>+      -
>+        name: pin-direction
>+        type: u8
>+        enum: pin-direction
>+      -
>+        name: pin-frequency
>+        type: u64
>+      -
>+        name: pin-frequency-supported
>+        type: nest
>+        multi-attr: true
>+        nested-attributes: pin-frequency-range
>+      -
>+        name: pin-frequency-min
>+        type: u64
>+      -
>+        name: pin-frequency-max
>+        type: u64
>+      -
>+        name: pin-prio
>+        type: u32
>+      -
>+        name: pin-state
>+        type: u8
>+        enum: pin-state
>+      -
>+        name: pin-parent
>+        type: nest
>+        multi-attr: true
>+        nested-attributes: pin-parent
>+      -
>+        name: pin-parent-idx
>+        type: u32
>+      -
>+        name: pin-rclk-device
>+        type: string
>+      -
>+        name: pin-dpll-caps
>+        type: u32
>+  -
>+    name: device
>+    subset-of: dpll
>+    attributes:
>+      -
>+        name: id
>+        type: u32
>+        value: 2
>+      -
>+        name: dev-name
>+        type: string
>+      -
>+        name: bus-name
>+        type: string
>+      -
>+        name: mode
>+        type: u8
>+        enum: mode
>+      -
>+        name: mode-supported
>+        type: u8
>+        enum: mode
>+        multi-attr: true
>+      -
>+        name: lock-status
>+        type: u8
>+        enum: lock-status
>+      -
>+        name: temp
>+        type: s32
>+      -
>+        name: clock-id
>+        type: u64
>+      -
>+        name: type
>+        type: u8
>+        enum: type
>+      -
>+        name: pin-prio
>+        type: u32
>+        value: 19

Do you still need to pass values for a subset? That is odd. Well, I
think is is odd to pass anything other than names in subset definition,
the rest of the info is in the original attribute set definition,
isn't it?
Jakub?


>+      -
>+        name: pin-state
>+        type: u8
>+        enum: pin-state
>+  -
>+    name: pin-parent
>+    subset-of: dpll
>+    attributes:
>+      -
>+        name: pin-state
>+        type: u8
>+        value: 20
>+        enum: pin-state
>+      -
>+        name: pin-parent-idx
>+        type: u32
>+        value: 22
>+      -
>+        name: pin-rclk-device
>+        type: string
>+  -
>+    name: pin-frequency-range
>+    subset-of: dpll
>+    attributes:
>+      -
>+        name: pin-frequency-min
>+        type: u64
>+        value: 17
>+      -
>+        name: pin-frequency-max
>+        type: u64
>+
>+operations:
>+  list:
>+    -
>+      name: unspec
>+      doc: unused
>+
>+    -
>+      name: device-get
>+      doc: |
>+        Get list of DPLL devices (dump) or attributes of a single dpll device
>+      attribute-set: dpll
>+      flags: [ admin-perm ]

I may be missing something, but why do you enforce adming perm for
get/dump cmds?


>+
>+      do:
>+        pre: dpll-pre-doit
>+        post: dpll-post-doit
>+        request:
>+          attributes:
>+            - id
>+            - bus-name
>+            - dev-name
>+        reply:
>+          attributes:
>+            - device
>+
>+      dump:
>+        pre: dpll-pre-dumpit
>+        post: dpll-post-dumpit
>+        reply:
>+          attributes:
>+            - device

I might be missing something, but this means "device" netdev attribute
DPLL_A_DEVICE, right? If yes, that is incorrect and you should list all
the device attrs.


>+
>+    -
>+      name: device-set
>+      doc: Set attributes for a DPLL device
>+      attribute-set: dpll
>+      flags: [ admin-perm ]
>+
>+      do:
>+        pre: dpll-pre-doit
>+        post: dpll-post-doit
>+        request:
>+          attributes:
>+            - id
>+            - bus-name
>+            - dev-name
>+            - mode
>+
>+    -
>+      name: pin-get
>+      doc: |
>+        Get list of pins and its attributes.
>+        - dump request without any attributes given - list all the pins in the system
>+        - dump request with target dpll - list all the pins registered with a given dpll device
>+        - do request with target dpll and target pin - single pin attributes
>+      attribute-set: dpll
>+      flags: [ admin-perm ]
>+
>+      do:
>+        pre: dpll-pin-pre-doit
>+        post: dpll-pin-post-doit
>+        request:
>+          attributes:
>+            - id
>+            - bus-name
>+            - dev-name
>+            - pin-idx
>+        reply: &pin-attrs
>+          attributes:
>+            - pin-idx
>+            - pin-label
>+            - pin-type
>+            - pin-direction
>+            - pin-frequency
>+            - pin-frequency-supported
>+            - pin-parent
>+            - pin-rclk-device
>+            - pin-dpll-caps
>+            - device
>+
>+      dump:
>+        pre: dpll-pin-pre-dumpit
>+        post: dpll-pin-post-dumpit
>+        request:
>+          attributes:
>+            - id
>+            - bus-name
>+            - dev-name
>+        reply: *pin-attrs
>+
>+    -
>+      name: pin-set
>+      doc: Set attributes of a target pin
>+      attribute-set: dpll
>+      flags: [ admin-perm ]
>+
>+      do:
>+        pre: dpll-pin-pre-doit
>+        post: dpll-pin-post-doit
>+        request:
>+          attributes:
>+            - id
>+            - bus-name
>+            - dev-name
>+            - pin-idx
>+            - pin-frequency
>+            - pin-direction
>+            - pin-prio
>+            - pin-state
>+            - pin-parent-idx
>+
>+mcast-groups:
>+  list:
>+    -
>+      name: monitor
>diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
>new file mode 100644
>index 000000000000..2f8643f401b0
>--- /dev/null
>+++ b/drivers/dpll/dpll_nl.c
>@@ -0,0 +1,126 @@
>+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
>+/* Do not edit directly, auto-generated from: */
>+/*	Documentation/netlink/specs/dpll.yaml */
>+/* YNL-GEN kernel source */
>+
>+#include <net/netlink.h>
>+#include <net/genetlink.h>
>+
>+#include "dpll_nl.h"
>+
>+#include <linux/dpll.h>
>+
>+/* DPLL_CMD_DEVICE_GET - do */
>+static const struct nla_policy dpll_device_get_nl_policy[DPLL_A_BUS_NAME + 1] = {
>+	[DPLL_A_ID] = { .type = NLA_U32, },
>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>+};
>+
>+/* DPLL_CMD_DEVICE_SET - do */
>+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE + 1] = {
>+	[DPLL_A_ID] = { .type = NLA_U32, },
>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_MODE] = NLA_POLICY_MAX(NLA_U8, 5),

I know it is a matter of the generator script, still have to note it
hurts my eyes to see "5" here :)


>+};
>+
>+/* DPLL_CMD_PIN_GET - do */
>+static const struct nla_policy dpll_pin_get_do_nl_policy[DPLL_A_PIN_IDX + 1] = {
>+	[DPLL_A_ID] = { .type = NLA_U32, },
>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_PIN_IDX] = { .type = NLA_U32, },
>+};
>+
>+/* DPLL_CMD_PIN_GET - dump */
>+static const struct nla_policy dpll_pin_get_dump_nl_policy[DPLL_A_BUS_NAME + 1] = {
>+	[DPLL_A_ID] = { .type = NLA_U32, },
>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>+};
>+
>+/* DPLL_CMD_PIN_SET - do */
>+static const struct nla_policy dpll_pin_set_nl_policy[DPLL_A_PIN_PARENT_IDX + 1] = {
>+	[DPLL_A_ID] = { .type = NLA_U32, },
>+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
>+	[DPLL_A_PIN_IDX] = { .type = NLA_U32, },
>+	[DPLL_A_PIN_FREQUENCY] = { .type = NLA_U64, },
>+	[DPLL_A_PIN_DIRECTION] = NLA_POLICY_MAX(NLA_U8, 2),
>+	[DPLL_A_PIN_PRIO] = { .type = NLA_U32, },
>+	[DPLL_A_PIN_STATE] = NLA_POLICY_MAX(NLA_U8, 3),
>+	[DPLL_A_PIN_PARENT_IDX] = { .type = NLA_U32, },
>+};
>+
>+/* Ops table for dpll */
>+static const struct genl_split_ops dpll_nl_ops[] = {
>+	{
>+		.cmd		= DPLL_CMD_DEVICE_GET,
>+		.pre_doit	= dpll_pre_doit,
>+		.doit		= dpll_nl_device_get_doit,
>+		.post_doit	= dpll_post_doit,
>+		.policy		= dpll_device_get_nl_policy,
>+		.maxattr	= DPLL_A_BUS_NAME,
>+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>+	},
>+	{
>+		.cmd	= DPLL_CMD_DEVICE_GET,
>+		.start	= dpll_pre_dumpit,
>+		.dumpit	= dpll_nl_device_get_dumpit,
>+		.done	= dpll_post_dumpit,
>+		.flags	= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
>+	},
>+	{
>+		.cmd		= DPLL_CMD_DEVICE_SET,
>+		.pre_doit	= dpll_pre_doit,
>+		.doit		= dpll_nl_device_set_doit,
>+		.post_doit	= dpll_post_doit,
>+		.policy		= dpll_device_set_nl_policy,
>+		.maxattr	= DPLL_A_MODE,
>+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>+	},
>+	{
>+		.cmd		= DPLL_CMD_PIN_GET,
>+		.pre_doit	= dpll_pin_pre_doit,
>+		.doit		= dpll_nl_pin_get_doit,
>+		.post_doit	= dpll_pin_post_doit,
>+		.policy		= dpll_pin_get_do_nl_policy,
>+		.maxattr	= DPLL_A_PIN_IDX,
>+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>+	},
>+	{
>+		.cmd		= DPLL_CMD_PIN_GET,
>+		.start		= dpll_pin_pre_dumpit,
>+		.dumpit		= dpll_nl_pin_get_dumpit,
>+		.done		= dpll_pin_post_dumpit,
>+		.policy		= dpll_pin_get_dump_nl_policy,
>+		.maxattr	= DPLL_A_BUS_NAME,
>+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
>+	},
>+	{
>+		.cmd		= DPLL_CMD_PIN_SET,
>+		.pre_doit	= dpll_pin_pre_doit,
>+		.doit		= dpll_nl_pin_set_doit,
>+		.post_doit	= dpll_pin_post_doit,
>+		.policy		= dpll_pin_set_nl_policy,
>+		.maxattr	= DPLL_A_PIN_PARENT_IDX,
>+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>+	},
>+};
>+
>+static const struct genl_multicast_group dpll_nl_mcgrps[] = {
>+	[DPLL_NLGRP_MONITOR] = { "monitor", },
>+};
>+
>+struct genl_family dpll_nl_family __ro_after_init = {
>+	.name		= DPLL_FAMILY_NAME,
>+	.version	= DPLL_FAMILY_VERSION,
>+	.netnsok	= true,
>+	.parallel_ops	= true,
>+	.module		= THIS_MODULE,
>+	.split_ops	= dpll_nl_ops,
>+	.n_split_ops	= ARRAY_SIZE(dpll_nl_ops),
>+	.mcgrps		= dpll_nl_mcgrps,
>+	.n_mcgrps	= ARRAY_SIZE(dpll_nl_mcgrps),
>+};
>diff --git a/drivers/dpll/dpll_nl.h b/drivers/dpll/dpll_nl.h
>new file mode 100644
>index 000000000000..57ab2da562ba
>--- /dev/null
>+++ b/drivers/dpll/dpll_nl.h
>@@ -0,0 +1,42 @@
>+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
>+/* Do not edit directly, auto-generated from: */
>+/*	Documentation/netlink/specs/dpll.yaml */
>+/* YNL-GEN kernel header */
>+
>+#ifndef _LINUX_DPLL_GEN_H
>+#define _LINUX_DPLL_GEN_H
>+
>+#include <net/netlink.h>
>+#include <net/genetlink.h>
>+
>+#include <linux/dpll.h>
>+
>+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		  struct genl_info *info);
>+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		      struct genl_info *info);
>+void
>+dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+	       struct genl_info *info);
>+void
>+dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
>+		   struct genl_info *info);
>+int dpll_pre_dumpit(struct netlink_callback *cb);
>+int dpll_pin_pre_dumpit(struct netlink_callback *cb);
>+int dpll_post_dumpit(struct netlink_callback *cb);
>+int dpll_pin_post_dumpit(struct netlink_callback *cb);
>+
>+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info);
>+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
>+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info);
>+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info);
>+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
>+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info);
>+
>+enum {
>+	DPLL_NLGRP_MONITOR,
>+};
>+
>+extern struct genl_family dpll_nl_family;
>+
>+#endif /* _LINUX_DPLL_GEN_H */
>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>new file mode 100644
>index 000000000000..e188bc189754
>--- /dev/null
>+++ b/include/uapi/linux/dpll.h
>@@ -0,0 +1,202 @@
>+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
>+/* Do not edit directly, auto-generated from: */
>+/*	Documentation/netlink/specs/dpll.yaml */
>+/* YNL-GEN uapi header */
>+
>+#ifndef _UAPI_LINUX_DPLL_H
>+#define _UAPI_LINUX_DPLL_H
>+
>+#define DPLL_FAMILY_NAME	"dpll"
>+#define DPLL_FAMILY_VERSION	1
>+
>+/**
>+ * enum dpll_mode - working-modes a dpll can support, differentiate if and how
>+ *   dpll selects one of its sources to syntonize with it, valid values for
>+ *   DPLL_A_MODE attribute
>+ * @DPLL_MODE_UNSPEC: unspecified value
>+ * @DPLL_MODE_MANUAL: source can be only selected by sending a request to dpll
>+ * @DPLL_MODE_AUTOMATIC: highest prio, valid source, auto selected by dpll
>+ * @DPLL_MODE_HOLDOVER: dpll forced into holdover mode
>+ * @DPLL_MODE_FREERUN: dpll driven on system clk, no holdover available
>+ * @DPLL_MODE_NCO: dpll driven by Numerically Controlled Oscillator
>+ */
>+enum dpll_mode {
>+	DPLL_MODE_UNSPEC,
>+	DPLL_MODE_MANUAL,
>+	DPLL_MODE_AUTOMATIC,
>+	DPLL_MODE_HOLDOVER,
>+	DPLL_MODE_FREERUN,
>+	DPLL_MODE_NCO,
>+
>+	__DPLL_MODE_MAX,
>+	DPLL_MODE_MAX = (__DPLL_MODE_MAX - 1)
>+};
>+
>+/**
>+ * enum dpll_lock_status - provides information of dpll device lock status,
>+ *   valid values for DPLL_A_LOCK_STATUS attribute
>+ * @DPLL_LOCK_STATUS_UNSPEC: unspecified value
>+ * @DPLL_LOCK_STATUS_UNLOCKED: dpll was not yet locked to any valid source (or
>+ *   is in one of modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
>+ * @DPLL_LOCK_STATUS_CALIBRATING: dpll is trying to lock to a valid signal
>+ * @DPLL_LOCK_STATUS_LOCKED: dpll is locked
>+ * @DPLL_LOCK_STATUS_HOLDOVER: dpll is in holdover state - lost a valid lock or
>+ *   was forced by selecting DPLL_MODE_HOLDOVER mode
>+ */
>+enum dpll_lock_status {
>+	DPLL_LOCK_STATUS_UNSPEC,
>+	DPLL_LOCK_STATUS_UNLOCKED,
>+	DPLL_LOCK_STATUS_CALIBRATING,
>+	DPLL_LOCK_STATUS_LOCKED,
>+	DPLL_LOCK_STATUS_HOLDOVER,
>+
>+	__DPLL_LOCK_STATUS_MAX,
>+	DPLL_LOCK_STATUS_MAX = (__DPLL_LOCK_STATUS_MAX - 1)
>+};
>+
>+#define DPLL_TEMP_DIVIDER	10
>+
>+/**
>+ * enum dpll_type - type of dpll, valid values for DPLL_A_TYPE attribute
>+ * @DPLL_TYPE_UNSPEC: unspecified value
>+ * @DPLL_TYPE_PPS: dpll produces Pulse-Per-Second signal
>+ * @DPLL_TYPE_EEC: dpll drives the Ethernet Equipment Clock
>+ */
>+enum dpll_type {
>+	DPLL_TYPE_UNSPEC,
>+	DPLL_TYPE_PPS,
>+	DPLL_TYPE_EEC,
>+
>+	__DPLL_TYPE_MAX,
>+	DPLL_TYPE_MAX = (__DPLL_TYPE_MAX - 1)
>+};
>+
>+/**
>+ * enum dpll_pin_type - defines possible types of a pin, valid values for
>+ *   DPLL_A_PIN_TYPE attribute
>+ * @DPLL_PIN_TYPE_UNSPEC: unspecified value
>+ * @DPLL_PIN_TYPE_MUX: aggregates another layer of selectable pins
>+ * @DPLL_PIN_TYPE_EXT: external source
>+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT: ethernet port PHY's recovered clock
>+ * @DPLL_PIN_TYPE_INT_OSCILLATOR: device internal oscillator
>+ * @DPLL_PIN_TYPE_GNSS: GNSS recovered clock
>+ */
>+enum dpll_pin_type {
>+	DPLL_PIN_TYPE_UNSPEC,
>+	DPLL_PIN_TYPE_MUX,
>+	DPLL_PIN_TYPE_EXT,
>+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
>+	DPLL_PIN_TYPE_INT_OSCILLATOR,
>+	DPLL_PIN_TYPE_GNSS,
>+
>+	__DPLL_PIN_TYPE_MAX,
>+	DPLL_PIN_TYPE_MAX = (__DPLL_PIN_TYPE_MAX - 1)
>+};
>+
>+/**
>+ * enum dpll_pin_direction - defines possible direction of a pin, valid values
>+ *   for DPLL_A_PIN_DIRECTION attribute
>+ * @DPLL_PIN_DIRECTION_UNSPEC: unspecified value
>+ * @DPLL_PIN_DIRECTION_SOURCE: pin used as a source of a signal
>+ * @DPLL_PIN_DIRECTION_OUTPUT: pin used to output the signal
>+ */
>+enum dpll_pin_direction {
>+	DPLL_PIN_DIRECTION_UNSPEC,
>+	DPLL_PIN_DIRECTION_SOURCE,
>+	DPLL_PIN_DIRECTION_OUTPUT,
>+
>+	__DPLL_PIN_DIRECTION_MAX,
>+	DPLL_PIN_DIRECTION_MAX = (__DPLL_PIN_DIRECTION_MAX - 1)
>+};
>+
>+#define DPLL_PIN_FREQUENCY_1_HZ		1
>+#define DPLL_PIN_FREQUENCY_10_MHZ	10000000
>+
>+/**
>+ * enum dpll_pin_state - defines possible states of a pin, valid values for
>+ *   DPLL_A_PIN_STATE attribute
>+ * @DPLL_PIN_STATE_UNSPEC: unspecified value
>+ * @DPLL_PIN_STATE_CONNECTED: pin connected, active source of phase locked loop
>+ * @DPLL_PIN_STATE_DISCONNECTED: pin disconnected, not considered as a valid
>+ *   source
>+ * @DPLL_PIN_STATE_SELECTABLE: pin enabled for automatic source selection
>+ */
>+enum dpll_pin_state {
>+	DPLL_PIN_STATE_UNSPEC,
>+	DPLL_PIN_STATE_CONNECTED,
>+	DPLL_PIN_STATE_DISCONNECTED,
>+	DPLL_PIN_STATE_SELECTABLE,
>+
>+	__DPLL_PIN_STATE_MAX,
>+	DPLL_PIN_STATE_MAX = (__DPLL_PIN_STATE_MAX - 1)
>+};
>+
>+/**
>+ * enum dpll_pin_caps - defines possible capabilities of a pin, valid flags on
>+ *   DPLL_A_PIN_CAPS attribute
>+ */
>+enum dpll_pin_caps {
>+	DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE = 1,
>+	DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE = 2,
>+	DPLL_PIN_CAPS_STATE_CAN_CHANGE = 4,
>+};
>+
>+/**
>+ * enum dpll_event - events of dpll generic netlink family
>+ * @DPLL_EVENT_UNSPEC: invalid event type
>+ * @DPLL_EVENT_DEVICE_CREATE: dpll device created
>+ * @DPLL_EVENT_DEVICE_DELETE: dpll device deleted
>+ * @DPLL_EVENT_DEVICE_CHANGE: attribute of dpll device or pin changed, reason
>+ *   is to be found with an attribute type (DPLL_A_*) received with the event
>+ */
>+enum dpll_event {
>+	DPLL_EVENT_UNSPEC,
>+	DPLL_EVENT_DEVICE_CREATE,
>+	DPLL_EVENT_DEVICE_DELETE,
>+	DPLL_EVENT_DEVICE_CHANGE,
>+};
>+
>+enum dplla {
>+	DPLL_A_DEVICE = 1,
>+	DPLL_A_ID,
>+	DPLL_A_DEV_NAME,
>+	DPLL_A_BUS_NAME,
>+	DPLL_A_MODE,
>+	DPLL_A_MODE_SUPPORTED,
>+	DPLL_A_LOCK_STATUS,
>+	DPLL_A_TEMP,
>+	DPLL_A_CLOCK_ID,
>+	DPLL_A_TYPE,
>+	DPLL_A_PIN_IDX,
>+	DPLL_A_PIN_LABEL,
>+	DPLL_A_PIN_TYPE,
>+	DPLL_A_PIN_DIRECTION,
>+	DPLL_A_PIN_FREQUENCY,
>+	DPLL_A_PIN_FREQUENCY_SUPPORTED,
>+	DPLL_A_PIN_FREQUENCY_MIN,
>+	DPLL_A_PIN_FREQUENCY_MAX,
>+	DPLL_A_PIN_PRIO,
>+	DPLL_A_PIN_STATE,
>+	DPLL_A_PIN_PARENT,
>+	DPLL_A_PIN_PARENT_IDX,
>+	DPLL_A_PIN_RCLK_DEVICE,
>+	DPLL_A_PIN_DPLL_CAPS,
>+
>+	__DPLL_A_MAX,
>+	DPLL_A_MAX = (__DPLL_A_MAX - 1)
>+};
>+
>+enum {
>+	DPLL_CMD_UNSPEC = 1,
>+	DPLL_CMD_DEVICE_GET,
>+	DPLL_CMD_DEVICE_SET,
>+	DPLL_CMD_PIN_GET,
>+	DPLL_CMD_PIN_SET,
>+
>+	__DPLL_CMD_MAX,
>+	DPLL_CMD_MAX = (__DPLL_CMD_MAX - 1)
>+};
>+
>+#define DPLL_MCGRP_MONITOR	"monitor"
>+
>+#endif /* _UAPI_LINUX_DPLL_H */
>-- 
>2.34.1
>

