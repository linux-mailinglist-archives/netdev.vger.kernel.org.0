Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129E06B9837
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCNOoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCNOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:44:22 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275D52F78E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:44:18 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso452678wmr.3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 07:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678805056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x9ObVWSw5s3TbffDqK+fnuQAnDa8FsYzSHNtDmAo9sA=;
        b=64YtWGHo4WAi4azlG42Grny6mv98LJ1ILgMLYJ71JsRf9NLbNDzl4ah331F6/rLLIq
         NRlis51JGaWDZMG8ogFzoXMVXBZq6dQboHM1p+vg20sXJyIANA7wErvRStsVWxYoEueo
         cUXTYlSum8GJM/0Yao28I6UBcc3zjI54BUB+xAtDuXgAOmWTpUW1YO3ygZKBHyaefw7/
         vzQ6n+FyahCNmbbo460vYqUOOWRR8t+RhPu6QOARkKS80vK8iIVcKsz+PTULWzGgyJnY
         yTMK7zEyHZRq+Y3rCbkAMy87NBVLo3if5VAwra7ui9lj3r72ouRp2BwGcFYHPOUqm1UB
         MtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678805056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x9ObVWSw5s3TbffDqK+fnuQAnDa8FsYzSHNtDmAo9sA=;
        b=28aKIFiZH6Rzu967+rq8bv/x9UTPpB7yAIR9Kt3C+XtxSXOvdkkRcQBnfv3gWR+XND
         vEJcPYbe6XH5txNWu3D4JQ2o4Bq+mV/cIYt0HKgSAXGLSvMgeSQuzoJ7LP/yb/HZbWt2
         H4/G3yUSSsUlKWpfA2wejc/GvDsHSXUopRtPIAnEau7PG3iheFwzAXbNjhj2d9nsARjb
         NsOjrSAPdLXuTz+fYRlttBJbgLwRWH1LUZaIgIsWO0qqUIH0HsFeEbwlE6iYdjf/i0bA
         mSCFbgefVI40V8S0PvKqSAUZVi5/gWI+ZlqnEQOu+Mjhiw+tZhPYxOxkk2tMFh5KbfLd
         mMPQ==
X-Gm-Message-State: AO0yUKWKLCh8aulaN8KbCEdEDkqnO0c2jG0tZ+R48eOd2bVv0iYmqN4x
        Hajafn+1k4ut6Rg2lHobXh5xIQ==
X-Google-Smtp-Source: AK7set/iyeyGAB7Xp8GnYrTVc4KorEiKnlJH9QXQXJDrQpZ3Bf0DzVnFideju/ufu9PqzgU3374a+w==
X-Received: by 2002:a05:600c:1d02:b0:3e9:c2f4:8ad4 with SMTP id l2-20020a05600c1d0200b003e9c2f48ad4mr14010815wms.8.1678805056418;
        Tue, 14 Mar 2023 07:44:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i5-20020a1c5405000000b003ed246f76a2sm3147540wmb.1.2023.03.14.07.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 07:44:15 -0700 (PDT)
Date:   Tue, 14 Mar 2023 15:44:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <ZBCIPg1u8UFugEFj@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-2-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-2-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:02AM CET, vadfed@meta.com wrote:
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
> Documentation/netlink/specs/dpll.yaml | 514 ++++++++++++++++++++++++++
> drivers/dpll/dpll_nl.c                | 126 +++++++
> drivers/dpll/dpll_nl.h                |  42 +++
> include/uapi/linux/dpll.h             | 196 ++++++++++
> 4 files changed, 878 insertions(+)
> create mode 100644 Documentation/netlink/specs/dpll.yaml
> create mode 100644 drivers/dpll/dpll_nl.c
> create mode 100644 drivers/dpll/dpll_nl.h
> create mode 100644 include/uapi/linux/dpll.h
>
>diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
>new file mode 100644
>index 000000000000..03e9f0e2d3d2
>--- /dev/null
>+++ b/Documentation/netlink/specs/dpll.yaml
>@@ -0,0 +1,514 @@
>+name: dpll
>+
>+doc: DPLL subsystem.
>+
>+definitions:
>+  -
>+    type: const
>+    name: temp-divider
>+    value: 10
>+  -
>+    type: const
>+    name: pin-freq-1-hz
>+    value: 1
>+  -
>+    type: const
>+    name: pin-freq-10-mhz
>+    value: 10000000
>+  -
>+    type: enum
>+    name: lock-status
>+    doc: |
>+      Provides information of dpll device lock status, valid values for
>+      DPLL_A_LOCK_STATUS attribute
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: unlocked
>+        doc: |
>+          dpll was not yet locked to any valid (or is in one of modes:
>+          DPLL_MODE_FREERUN, DPLL_MODE_NCO)
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
>+    render-max: true
>+  -
>+    type: enum
>+    name: pin-type
>+    doc: Enumerates types of a pin, valid values for DPLL_A_PIN_TYPE attribute
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
>+      -
>+        name: gnss
>+        doc: GNSS recovered clock
>+    render-max: true
>+  -
>+    type: enum
>+    name: pin-state
>+    doc: available pin modes
>+    entries:
>+      -
>+        name: unspec
>+        doc: unspecified value
>+      -
>+        name: connected
>+        doc: pin connected
>+      -
>+        name: disconnected
>+        doc: pin disconnected
>+    render-max: true
>+  -
>+    type: enum
>+    name: pin-direction
>+    doc: available pin direction
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
>+    type: enum
>+    name: mode

Could you please sort the enums so they are in the same order as the
attribute which carries them? That would also put the device and pin
enums together.


>+    doc: |
>+      working-modes a dpll can support, differentiate if and how dpll selects
>+      one of its sources to syntonize with it
>+    entries:
>+      -
>+        name: unspec
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
>+      -
>+        name: nco
>+        doc: dpll driven by Numerically Controlled Oscillator
>+    render-max: true
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
>+        doc: |
>+          attribute of dpll device or pin changed, reason is to be found with
>+          an attribute type (DPLL_A_*) received with the event
>+  -
>+    type: flags
>+    name: pin-caps
>+    doc: define capabilities of a pin
>+    entries:
>+      -
>+        name: direction-can-change
>+      -
>+        name: priority-can-change
>+      -
>+        name: state-can-change
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
>+        multi-attr: true
>+        nested-attributes: device

What is this "device" and what is it good for? Smells like some leftover
and with the nested scheme looks quite odd.


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
>+        name: source-pin-idx
>+        type: u32
>+      -
>+        name: lock-status
>+        type: u8
>+        enum: lock-status
>+      -
>+        name: temp

Could you put some comment regarding the divider here?


>+        type: s32
>+      -
>+        name: clock-id
>+        type: u64
>+      -
>+        name: type
>+        type: u8
>+        enum: type
>+      -
>+        name: pin
>+        type: nest
>+        multi-attr: true
>+        nested-attributes: pin
>+        value: 12
>+      -
>+        name: pin-idx
>+        type: u32
>+      -
>+        name: pin-description
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
>+        type: u32
>+      -
>+        name: pin-frequency-supported
>+        type: u32
>+        multi-attr: true
>+      -
>+        name: pin-any-frequency-min
>+        type: u32
>+      -
>+        name: pin-any-frequency-max
>+        type: u32

These 2 attrs somehow overlap with pin-frequency-supported,
which is a bit confusing, I think that pin-frequency-supported
should carry all supported frequencies. How about to have something
like:
        name: pin-frequency-supported
        type: nest
	multi-attr: true
        nested-attributes: pin-frequency-range

and then:
      name: pin-frequency-range
      subset-of: dpll
      attributes:
        -
          name: pin-frequency-min
          type: u32
        -
          name: pin-frequency-max
          type: u32
          doc: should be put only to specify range when value differs
	       from pin-frequency-min

That could carry list of frequencies and ranges, in this case multiple
ones if possibly needed.



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
>+        nested-attributes: pin
>+        value: 23

Value 23? What's this?
You have it specified for some attrs all over the place.
What is the reason for it?


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
>+        name: source-pin-idx
>+        type: u32
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
>+        name: pin
>+        type: nest
>+        value: 12
>+        multi-attr: true
>+        nested-attributes: pin

This does not belong here.


>+      -
>+        name: pin-prio
>+        type: u32
>+        value: 21
>+      -
>+        name: pin-state
>+        type: u8
>+        enum: pin-state
>+      -
>+        name: pin-dpll-caps
>+        type: u32
>+        value: 26

All these 3 do not belong here are well.



>+  -
>+    name: pin
>+    subset-of: dpll
>+    attributes:
>+      -
>+        name: device
>+        type: nest
>+        value: 1
>+        multi-attr: true
>+        nested-attributes: device
>+      -
>+        name: pin-idx
>+        type: u32
>+        value: 13
>+      -
>+        name: pin-description
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
>+        type: u32
>+      -
>+        name: pin-frequency-supported
>+        type: u32
>+        multi-attr: true
>+      -
>+        name: pin-any-frequency-min
>+        type: u32
>+      -
>+        name: pin-any-frequency-max
>+        type: u32
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

Multiple parents? How is that supposed to work?


>+        nested-attributes: pin-parent
>+        value: 23
>+      -
>+        name: pin-rclk-device
>+        type: string
>+        value: 25
>+      -
>+        name: pin-dpll-caps
>+        type: u32

Missing "enum: "


>+  -
>+    name: pin-parent
>+    subset-of: dpll
>+    attributes:
>+      -
>+        name: pin-state
>+        type: u8
>+        value: 22
>+        enum: pin-state
>+      -
>+        name: pin-parent-idx
>+        type: u32
>+        value: 24
>+      -
>+        name: pin-rclk-device
>+        type: string

Yeah, as I wrote in the other email, this really smells to
have like a simple string like this. What is it supposed to be?


>+
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

Shouldn't this be "device"?


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
>+
>+    -
>+      name: device-set
>+      doc: Set attributes for a DPLL device
>+      attribute-set: dpll

"device" here as well?


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

Hmm, shouldn't source-pin-index be here as well?

>+
>+    -
>+      name: pin-get
>+      doc: |
>+        Get list of pins and its attributes.
>+        - dump request without any attributes given - list all the pins in the system
>+        - dump request with target dpll - list all the pins registered with a given dpll device
>+        - do request with target dpll and target pin - single pin attributes
>+      attribute-set: dpll

"pin"?


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
>+        reply:
>+          attributes:
>+            - pin
>+
>+      dump:
>+        pre: dpll-pin-pre-dumpit
>+        post: dpll-pin-post-dumpit
>+        request:
>+          attributes:
>+            - id
>+            - bus-name
>+            - dev-name
>+        reply:
>+          attributes:
>+            - pin
>+
>+    -
>+      name: pin-set
>+      doc: Set attributes of a target pin
>+      attribute-set: dpll

"pin"?


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
>+            - pin-parent-idx
>+            - pin-state
>+
>+mcast-groups:
>+  list:
>+    -
>+      name: monitor
>diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
>new file mode 100644
>index 000000000000..099d1e30ca7c
>--- /dev/null
>+++ b/drivers/dpll/dpll_nl.c
>@@ -0,0 +1,126 @@
>+// SPDX-License-Identifier: BSD-3-Clause
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

Hmm, any idea why the generator does not put define name
here instead of "5"?


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
>+	[DPLL_A_PIN_FREQUENCY] = { .type = NLA_U32, },

4.3GHz would be the limit, isn't it future proof to make this rather u64?


>+	[DPLL_A_PIN_DIRECTION] = NLA_POLICY_MAX(NLA_U8, 2),
>+	[DPLL_A_PIN_PRIO] = { .type = NLA_U32, },
>+	[DPLL_A_PIN_PARENT_IDX] = { .type = NLA_U32, },

This is a bit odd. The size is DPLL_A_PIN_PARENT_IDX + 1, yet PIN_STATE
is last. I found that the order is not according to the enum in the yaml
operation definition. Perhaps the generator can sort this?


>+	[DPLL_A_PIN_STATE] = NLA_POLICY_MAX(NLA_U8, 2),
>+};
>+
>+/* Ops table for dpll */
>+static const struct genl_split_ops dpll_nl_ops[6] = {
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
>index 000000000000..3a354dfb9a31
>--- /dev/null
>+++ b/drivers/dpll/dpll_nl.h
>@@ -0,0 +1,42 @@
>+/* SPDX-License-Identifier: BSD-3-Clause */
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
>index 000000000000..ece6fe685d08
>--- /dev/null
>+++ b/include/uapi/linux/dpll.h
>@@ -0,0 +1,196 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
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
>+#define DPLL_TEMP_DIVIDER	10

Some comment to this define would be nice.


>+#define DPLL_PIN_FREQ_1_HZ	1
>+#define DPLL_PIN_FREQ_10_MHZ	10000000

Have this as enum. Spell out "frequency" to be consistent with the
related attribute name.


>+
>+/**
>+ * enum dpll_lock_status - Provides information of dpll device lock status,
>+ *   valid values for DPLL_A_LOCK_STATUS attribute
>+ * @DPLL_LOCK_STATUS_UNSPEC: unspecified value
>+ * @DPLL_LOCK_STATUS_UNLOCKED: dpll was not yet locked to any valid (or is in

"any valid source" perhaps?


>+ *   one of modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
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
>+/**
>+ * enum dpll_pin_type - Enumerates types of a pin, valid values for
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
>+ * enum dpll_pin_state - available pin modes

For some of the enums, you say for what attribute it serves as a value
set, for some you don't. Please unify the approach. I think it is
valuable to say that for every enum.


>+ * @DPLL_PIN_STATE_UNSPEC: unspecified value
>+ * @DPLL_PIN_STATE_CONNECTED: pin connected
>+ * @DPLL_PIN_STATE_DISCONNECTED: pin disconnected
>+ */
>+enum dpll_pin_state {
>+	DPLL_PIN_STATE_UNSPEC,
>+	DPLL_PIN_STATE_CONNECTED,
>+	DPLL_PIN_STATE_DISCONNECTED,
>+
>+	__DPLL_PIN_STATE_MAX,
>+	DPLL_PIN_STATE_MAX = (__DPLL_PIN_STATE_MAX - 1)
>+};
>+
>+/**
>+ * enum dpll_pin_direction - available pin direction
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
>+/**
>+ * enum dpll_mode - working-modes a dpll can support, differentiate if and how
>+ *   dpll selects one of its sources to syntonize with it
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
>+/**
>+ * enum dpll_pin_caps - define capabilities of a pin
>+ */
>+enum dpll_pin_caps {
>+	DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE = 1,
>+	DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE = 2,
>+	DPLL_PIN_CAPS_STATE_CAN_CHANGE = 4,
>+};
>+
>+enum dplla {
>+	DPLL_A_DEVICE = 1,
>+	DPLL_A_ID,
>+	DPLL_A_DEV_NAME,
>+	DPLL_A_BUS_NAME,
>+	DPLL_A_MODE,
>+	DPLL_A_MODE_SUPPORTED,
>+	DPLL_A_SOURCE_PIN_IDX,
>+	DPLL_A_LOCK_STATUS,
>+	DPLL_A_TEMP,
>+	DPLL_A_CLOCK_ID,
>+	DPLL_A_TYPE,
>+	DPLL_A_PIN,
>+	DPLL_A_PIN_IDX,
>+	DPLL_A_PIN_DESCRIPTION,

I commented this name in the other email. This does not describe
anything. It is a label on a connector, isn't it? Why don't to call it
"label"?


>+	DPLL_A_PIN_TYPE,
>+	DPLL_A_PIN_DIRECTION,
>+	DPLL_A_PIN_FREQUENCY,
>+	DPLL_A_PIN_FREQUENCY_SUPPORTED,
>+	DPLL_A_PIN_ANY_FREQUENCY_MIN,
>+	DPLL_A_PIN_ANY_FREQUENCY_MAX,

Drop "any". Not good for anything.


>+	DPLL_A_PIN_PRIO,
>+	DPLL_A_PIN_STATE,
>+	DPLL_A_PIN_PARENT,
>+	DPLL_A_PIN_PARENT_IDX,
>+	DPLL_A_PIN_RCLK_DEVICE,
>+	DPLL_A_PIN_DPLL_CAPS,

Just DPLL_A_PIN_CAPS is enough, that would be also consistent with the
enum name.

>+
>+	__DPLL_A_MAX,
>+	DPLL_A_MAX = (__DPLL_A_MAX - 1)
>+};
>+
>+enum {
>+	DPLL_CMD_UNSPEC,
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
