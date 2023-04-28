Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625276F0F7B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 02:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344363AbjD1AVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 20:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344362AbjD1AVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 20:21:18 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E933AAC;
        Thu, 27 Apr 2023 17:20:48 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33RMmU8S005049;
        Thu, 27 Apr 2023 17:20:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=P99O37rx1nM3CVlJZ+xDyBfDmug/YyX04UDQK0XlRj8=;
 b=iIXbjOXh/goWDh/tjleOzndeM9u5gzBTTcWbul4w3L+dyKo3WCINaQ4NQxOlbIHFPY4B
 D+HFaVZOyWCnc05eUEulx014xnkMfXejHwmcpLbDd88jbhHqHWrodQFcjANRcgoJoQe6
 42Cxq6IrdIUwWHxnNANxRVcN7jHJ+AeLDTVhMD0bp5+JfMDRveq3KRivDK7Wcs+vAdC5
 bHOPMiqP9iwdoubk6VEAnkh9VpK2eYeIOWt2anLWiSsuPIoK+QoU+wmR28OzreF4DO6c
 Q7XJoq1U3kUVohqCWDNTmczIf63sX7i1TC6CcbaPgeScde4xNOXPDZ7ZcD//admH7O8j dg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q825urexd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 27 Apr 2023 17:20:26 -0700
Received: from devvm1736.cln0.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server id
 15.1.2507.23; Thu, 27 Apr 2023 17:20:23 -0700
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-clk@vger.kernel.org>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Date:   Thu, 27 Apr 2023 17:20:02 -0700
Message-ID: <20230428002009.2948020-2-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230428002009.2948020-1-vadfed@meta.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::4]
X-Proofpoint-GUID: w2sZxsjX2J9MX6xp92YCvRxtJqilui-i
X-Proofpoint-ORIG-GUID: w2sZxsjX2J9MX6xp92YCvRxtJqilui-i
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

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Add a protocol spec for DPLL.
Add code generated from the spec.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
---
 Documentation/netlink/specs/dpll.yaml | 472 ++++++++++++++++++++++++++
 drivers/dpll/dpll_nl.c                | 126 +++++++
 drivers/dpll/dpll_nl.h                |  42 +++
 include/uapi/linux/dpll.h             | 202 +++++++++++
 4 files changed, 842 insertions(+)
 create mode 100644 Documentation/netlink/specs/dpll.yaml
 create mode 100644 drivers/dpll/dpll_nl.c
 create mode 100644 drivers/dpll/dpll_nl.h
 create mode 100644 include/uapi/linux/dpll.h

diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
new file mode 100644
index 000000000000..67ca0f6cf2d5
--- /dev/null
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -0,0 +1,472 @@
+# SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+
+name: dpll
+
+doc: DPLL subsystem.
+
+definitions:
+  -
+    type: enum
+    name: mode
+    doc: |
+      working-modes a dpll can support, differentiate if and how dpll selects
+      one of its sources to syntonize with it, valid values for DPLL_A_MODE
+      attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: manual
+        doc: source can be only selected by sending a request to dpll
+      -
+        name: automatic
+        doc: highest prio, valid source, auto selected by dpll
+      -
+        name: holdover
+        doc: dpll forced into holdover mode
+      -
+        name: freerun
+        doc: dpll driven on system clk, no holdover available
+      -
+        name: nco
+        doc: dpll driven by Numerically Controlled Oscillator
+    render-max: true
+  -
+    type: enum
+    name: lock-status
+    doc: |
+      provides information of dpll device lock status, valid values for
+      DPLL_A_LOCK_STATUS attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: unlocked
+        doc: |
+          dpll was not yet locked to any valid source (or is in one of
+          modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
+      -
+        name: calibrating
+        doc: dpll is trying to lock to a valid signal
+      -
+        name: locked
+        doc: dpll is locked
+      -
+        name: holdover
+        doc: |
+          dpll is in holdover state - lost a valid lock or was forced by
+          selecting DPLL_MODE_HOLDOVER mode
+    render-max: true
+  -
+    type: const
+    name: temp-divider
+    value: 10
+    doc: |
+      temperature divider allowing userspace to calculate the
+      temperature as float with single digit precision.
+      Value of (DPLL_A_TEMP / DPLL_TEMP_DIVIDER) is integer part of
+      tempearture value.
+      Value of (DPLL_A_TEMP % DPLL_TEMP_DIVIDER) is fractional part of
+      temperature value.
+  -
+    type: enum
+    name: type
+    doc: type of dpll, valid values for DPLL_A_TYPE attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: pps
+        doc: dpll produces Pulse-Per-Second signal
+      -
+        name: eec
+        doc: dpll drives the Ethernet Equipment Clock
+    render-max: true
+  -
+    type: enum
+    name: pin-type
+    doc: |
+      defines possible types of a pin, valid values for DPLL_A_PIN_TYPE
+      attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: mux
+        doc: aggregates another layer of selectable pins
+      -
+        name: ext
+        doc: external source
+      -
+        name: synce-eth-port
+        doc: ethernet port PHY's recovered clock
+      -
+        name: int-oscillator
+        doc: device internal oscillator
+      -
+        name: gnss
+        doc: GNSS recovered clock
+    render-max: true
+  -
+    type: enum
+    name: pin-direction
+    doc: |
+      defines possible direction of a pin, valid values for
+      DPLL_A_PIN_DIRECTION attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: source
+        doc: pin used as a source of a signal
+      -
+        name: output
+        doc: pin used to output the signal
+    render-max: true
+  -
+    type: const
+    name: pin-frequency-1-hz
+    value: 1
+  -
+    type: const
+    name: pin-frequency-10-mhz
+    value: 10000000
+  -
+    type: enum
+    name: pin-state
+    doc: |
+      defines possible states of a pin, valid values for
+      DPLL_A_PIN_STATE attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: connected
+        doc: pin connected, active source of phase locked loop
+      -
+        name: disconnected
+        doc: pin disconnected, not considered as a valid source
+      -
+        name: selectable
+        doc: pin enabled for automatic source selection
+    render-max: true
+  -
+    type: flags
+    name: pin-caps
+    doc: |
+      defines possible capabilities of a pin, valid flags on
+      DPLL_A_PIN_CAPS attribute
+    entries:
+      -
+        name: direction-can-change
+      -
+        name: priority-can-change
+      -
+        name: state-can-change
+  -
+    type: enum
+    name: event
+    doc: events of dpll generic netlink family
+    entries:
+      -
+        name: unspec
+        doc: invalid event type
+      -
+        name: device-create
+        doc: dpll device created
+      -
+        name: device-delete
+        doc: dpll device deleted
+      -
+        name: device-change
+        doc: |
+          attribute of dpll device or pin changed, reason is to be found with
+          an attribute type (DPLL_A_*) received with the event
+
+
+attribute-sets:
+  -
+    name: dpll
+    enum-name: dplla
+    attributes:
+      -
+        name: device
+        type: nest
+        value: 1
+        multi-attr: true
+        nested-attributes: device
+      -
+        name: id
+        type: u32
+      -
+        name: dev-name
+        type: string
+      -
+        name: bus-name
+        type: string
+      -
+        name: mode
+        type: u8
+        enum: mode
+      -
+        name: mode-supported
+        type: u8
+        enum: mode
+        multi-attr: true
+      -
+        name: lock-status
+        type: u8
+        enum: lock-status
+      -
+        name: temp
+        type: s32
+      -
+        name: clock-id
+        type: u64
+      -
+        name: type
+        type: u8
+        enum: type
+      -
+        name: pin-idx
+        type: u32
+      -
+        name: pin-label
+        type: string
+      -
+        name: pin-type
+        type: u8
+        enum: pin-type
+      -
+        name: pin-direction
+        type: u8
+        enum: pin-direction
+      -
+        name: pin-frequency
+        type: u64
+      -
+        name: pin-frequency-supported
+        type: nest
+        multi-attr: true
+        nested-attributes: pin-frequency-range
+      -
+        name: pin-frequency-min
+        type: u64
+      -
+        name: pin-frequency-max
+        type: u64
+      -
+        name: pin-prio
+        type: u32
+      -
+        name: pin-state
+        type: u8
+        enum: pin-state
+      -
+        name: pin-parent
+        type: nest
+        multi-attr: true
+        nested-attributes: pin-parent
+      -
+        name: pin-parent-idx
+        type: u32
+      -
+        name: pin-rclk-device
+        type: string
+      -
+        name: pin-dpll-caps
+        type: u32
+  -
+    name: device
+    subset-of: dpll
+    attributes:
+      -
+        name: id
+        type: u32
+        value: 2
+      -
+        name: dev-name
+        type: string
+      -
+        name: bus-name
+        type: string
+      -
+        name: mode
+        type: u8
+        enum: mode
+      -
+        name: mode-supported
+        type: u8
+        enum: mode
+        multi-attr: true
+      -
+        name: lock-status
+        type: u8
+        enum: lock-status
+      -
+        name: temp
+        type: s32
+      -
+        name: clock-id
+        type: u64
+      -
+        name: type
+        type: u8
+        enum: type
+      -
+        name: pin-prio
+        type: u32
+        value: 19
+      -
+        name: pin-state
+        type: u8
+        enum: pin-state
+  -
+    name: pin-parent
+    subset-of: dpll
+    attributes:
+      -
+        name: pin-state
+        type: u8
+        value: 20
+        enum: pin-state
+      -
+        name: pin-parent-idx
+        type: u32
+        value: 22
+      -
+        name: pin-rclk-device
+        type: string
+  -
+    name: pin-frequency-range
+    subset-of: dpll
+    attributes:
+      -
+        name: pin-frequency-min
+        type: u64
+        value: 17
+      -
+        name: pin-frequency-max
+        type: u64
+
+operations:
+  list:
+    -
+      name: unspec
+      doc: unused
+
+    -
+      name: device-get
+      doc: |
+        Get list of DPLL devices (dump) or attributes of a single dpll device
+      attribute-set: dpll
+      flags: [ admin-perm ]
+
+      do:
+        pre: dpll-pre-doit
+        post: dpll-post-doit
+        request:
+          attributes:
+            - id
+            - bus-name
+            - dev-name
+        reply:
+          attributes:
+            - device
+
+      dump:
+        pre: dpll-pre-dumpit
+        post: dpll-post-dumpit
+        reply:
+          attributes:
+            - device
+
+    -
+      name: device-set
+      doc: Set attributes for a DPLL device
+      attribute-set: dpll
+      flags: [ admin-perm ]
+
+      do:
+        pre: dpll-pre-doit
+        post: dpll-post-doit
+        request:
+          attributes:
+            - id
+            - bus-name
+            - dev-name
+            - mode
+
+    -
+      name: pin-get
+      doc: |
+        Get list of pins and its attributes.
+        - dump request without any attributes given - list all the pins in the system
+        - dump request with target dpll - list all the pins registered with a given dpll device
+        - do request with target dpll and target pin - single pin attributes
+      attribute-set: dpll
+      flags: [ admin-perm ]
+
+      do:
+        pre: dpll-pin-pre-doit
+        post: dpll-pin-post-doit
+        request:
+          attributes:
+            - id
+            - bus-name
+            - dev-name
+            - pin-idx
+        reply: &pin-attrs
+          attributes:
+            - pin-idx
+            - pin-label
+            - pin-type
+            - pin-direction
+            - pin-frequency
+            - pin-frequency-supported
+            - pin-parent
+            - pin-rclk-device
+            - pin-dpll-caps
+            - device
+
+      dump:
+        pre: dpll-pin-pre-dumpit
+        post: dpll-pin-post-dumpit
+        request:
+          attributes:
+            - id
+            - bus-name
+            - dev-name
+        reply: *pin-attrs
+
+    -
+      name: pin-set
+      doc: Set attributes of a target pin
+      attribute-set: dpll
+      flags: [ admin-perm ]
+
+      do:
+        pre: dpll-pin-pre-doit
+        post: dpll-pin-post-doit
+        request:
+          attributes:
+            - id
+            - bus-name
+            - dev-name
+            - pin-idx
+            - pin-frequency
+            - pin-direction
+            - pin-prio
+            - pin-state
+            - pin-parent-idx
+
+mcast-groups:
+  list:
+    -
+      name: monitor
diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
new file mode 100644
index 000000000000..2f8643f401b0
--- /dev/null
+++ b/drivers/dpll/dpll_nl.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause)
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/dpll.yaml */
+/* YNL-GEN kernel source */
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include "dpll_nl.h"
+
+#include <linux/dpll.h>
+
+/* DPLL_CMD_DEVICE_GET - do */
+static const struct nla_policy dpll_device_get_nl_policy[DPLL_A_BUS_NAME + 1] = {
+	[DPLL_A_ID] = { .type = NLA_U32, },
+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
+};
+
+/* DPLL_CMD_DEVICE_SET - do */
+static const struct nla_policy dpll_device_set_nl_policy[DPLL_A_MODE + 1] = {
+	[DPLL_A_ID] = { .type = NLA_U32, },
+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_MODE] = NLA_POLICY_MAX(NLA_U8, 5),
+};
+
+/* DPLL_CMD_PIN_GET - do */
+static const struct nla_policy dpll_pin_get_do_nl_policy[DPLL_A_PIN_IDX + 1] = {
+	[DPLL_A_ID] = { .type = NLA_U32, },
+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_PIN_IDX] = { .type = NLA_U32, },
+};
+
+/* DPLL_CMD_PIN_GET - dump */
+static const struct nla_policy dpll_pin_get_dump_nl_policy[DPLL_A_BUS_NAME + 1] = {
+	[DPLL_A_ID] = { .type = NLA_U32, },
+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
+};
+
+/* DPLL_CMD_PIN_SET - do */
+static const struct nla_policy dpll_pin_set_nl_policy[DPLL_A_PIN_PARENT_IDX + 1] = {
+	[DPLL_A_ID] = { .type = NLA_U32, },
+	[DPLL_A_BUS_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_DEV_NAME] = { .type = NLA_NUL_STRING, },
+	[DPLL_A_PIN_IDX] = { .type = NLA_U32, },
+	[DPLL_A_PIN_FREQUENCY] = { .type = NLA_U64, },
+	[DPLL_A_PIN_DIRECTION] = NLA_POLICY_MAX(NLA_U8, 2),
+	[DPLL_A_PIN_PRIO] = { .type = NLA_U32, },
+	[DPLL_A_PIN_STATE] = NLA_POLICY_MAX(NLA_U8, 3),
+	[DPLL_A_PIN_PARENT_IDX] = { .type = NLA_U32, },
+};
+
+/* Ops table for dpll */
+static const struct genl_split_ops dpll_nl_ops[] = {
+	{
+		.cmd		= DPLL_CMD_DEVICE_GET,
+		.pre_doit	= dpll_pre_doit,
+		.doit		= dpll_nl_device_get_doit,
+		.post_doit	= dpll_post_doit,
+		.policy		= dpll_device_get_nl_policy,
+		.maxattr	= DPLL_A_BUS_NAME,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd	= DPLL_CMD_DEVICE_GET,
+		.start	= dpll_pre_dumpit,
+		.dumpit	= dpll_nl_device_get_dumpit,
+		.done	= dpll_post_dumpit,
+		.flags	= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= DPLL_CMD_DEVICE_SET,
+		.pre_doit	= dpll_pre_doit,
+		.doit		= dpll_nl_device_set_doit,
+		.post_doit	= dpll_post_doit,
+		.policy		= dpll_device_set_nl_policy,
+		.maxattr	= DPLL_A_MODE,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= DPLL_CMD_PIN_GET,
+		.pre_doit	= dpll_pin_pre_doit,
+		.doit		= dpll_nl_pin_get_doit,
+		.post_doit	= dpll_pin_post_doit,
+		.policy		= dpll_pin_get_do_nl_policy,
+		.maxattr	= DPLL_A_PIN_IDX,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= DPLL_CMD_PIN_GET,
+		.start		= dpll_pin_pre_dumpit,
+		.dumpit		= dpll_nl_pin_get_dumpit,
+		.done		= dpll_pin_post_dumpit,
+		.policy		= dpll_pin_get_dump_nl_policy,
+		.maxattr	= DPLL_A_BUS_NAME,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DUMP,
+	},
+	{
+		.cmd		= DPLL_CMD_PIN_SET,
+		.pre_doit	= dpll_pin_pre_doit,
+		.doit		= dpll_nl_pin_set_doit,
+		.post_doit	= dpll_pin_post_doit,
+		.policy		= dpll_pin_set_nl_policy,
+		.maxattr	= DPLL_A_PIN_PARENT_IDX,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
+	},
+};
+
+static const struct genl_multicast_group dpll_nl_mcgrps[] = {
+	[DPLL_NLGRP_MONITOR] = { "monitor", },
+};
+
+struct genl_family dpll_nl_family __ro_after_init = {
+	.name		= DPLL_FAMILY_NAME,
+	.version	= DPLL_FAMILY_VERSION,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.module		= THIS_MODULE,
+	.split_ops	= dpll_nl_ops,
+	.n_split_ops	= ARRAY_SIZE(dpll_nl_ops),
+	.mcgrps		= dpll_nl_mcgrps,
+	.n_mcgrps	= ARRAY_SIZE(dpll_nl_mcgrps),
+};
diff --git a/drivers/dpll/dpll_nl.h b/drivers/dpll/dpll_nl.h
new file mode 100644
index 000000000000..57ab2da562ba
--- /dev/null
+++ b/drivers/dpll/dpll_nl.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/dpll.yaml */
+/* YNL-GEN kernel header */
+
+#ifndef _LINUX_DPLL_GEN_H
+#define _LINUX_DPLL_GEN_H
+
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+#include <linux/dpll.h>
+
+int dpll_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		  struct genl_info *info);
+int dpll_pin_pre_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		      struct genl_info *info);
+void
+dpll_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+	       struct genl_info *info);
+void
+dpll_pin_post_doit(const struct genl_split_ops *ops, struct sk_buff *skb,
+		   struct genl_info *info);
+int dpll_pre_dumpit(struct netlink_callback *cb);
+int dpll_pin_pre_dumpit(struct netlink_callback *cb);
+int dpll_post_dumpit(struct netlink_callback *cb);
+int dpll_pin_post_dumpit(struct netlink_callback *cb);
+
+int dpll_nl_device_get_doit(struct sk_buff *skb, struct genl_info *info);
+int dpll_nl_device_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int dpll_nl_device_set_doit(struct sk_buff *skb, struct genl_info *info);
+int dpll_nl_pin_get_doit(struct sk_buff *skb, struct genl_info *info);
+int dpll_nl_pin_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
+int dpll_nl_pin_set_doit(struct sk_buff *skb, struct genl_info *info);
+
+enum {
+	DPLL_NLGRP_MONITOR,
+};
+
+extern struct genl_family dpll_nl_family;
+
+#endif /* _LINUX_DPLL_GEN_H */
diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
new file mode 100644
index 000000000000..e188bc189754
--- /dev/null
+++ b/include/uapi/linux/dpll.h
@@ -0,0 +1,202 @@
+/* SPDX-License-Identifier: ((GPL-2.0 WITH Linux-syscall-note) OR BSD-3-Clause) */
+/* Do not edit directly, auto-generated from: */
+/*	Documentation/netlink/specs/dpll.yaml */
+/* YNL-GEN uapi header */
+
+#ifndef _UAPI_LINUX_DPLL_H
+#define _UAPI_LINUX_DPLL_H
+
+#define DPLL_FAMILY_NAME	"dpll"
+#define DPLL_FAMILY_VERSION	1
+
+/**
+ * enum dpll_mode - working-modes a dpll can support, differentiate if and how
+ *   dpll selects one of its sources to syntonize with it, valid values for
+ *   DPLL_A_MODE attribute
+ * @DPLL_MODE_UNSPEC: unspecified value
+ * @DPLL_MODE_MANUAL: source can be only selected by sending a request to dpll
+ * @DPLL_MODE_AUTOMATIC: highest prio, valid source, auto selected by dpll
+ * @DPLL_MODE_HOLDOVER: dpll forced into holdover mode
+ * @DPLL_MODE_FREERUN: dpll driven on system clk, no holdover available
+ * @DPLL_MODE_NCO: dpll driven by Numerically Controlled Oscillator
+ */
+enum dpll_mode {
+	DPLL_MODE_UNSPEC,
+	DPLL_MODE_MANUAL,
+	DPLL_MODE_AUTOMATIC,
+	DPLL_MODE_HOLDOVER,
+	DPLL_MODE_FREERUN,
+	DPLL_MODE_NCO,
+
+	__DPLL_MODE_MAX,
+	DPLL_MODE_MAX = (__DPLL_MODE_MAX - 1)
+};
+
+/**
+ * enum dpll_lock_status - provides information of dpll device lock status,
+ *   valid values for DPLL_A_LOCK_STATUS attribute
+ * @DPLL_LOCK_STATUS_UNSPEC: unspecified value
+ * @DPLL_LOCK_STATUS_UNLOCKED: dpll was not yet locked to any valid source (or
+ *   is in one of modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
+ * @DPLL_LOCK_STATUS_CALIBRATING: dpll is trying to lock to a valid signal
+ * @DPLL_LOCK_STATUS_LOCKED: dpll is locked
+ * @DPLL_LOCK_STATUS_HOLDOVER: dpll is in holdover state - lost a valid lock or
+ *   was forced by selecting DPLL_MODE_HOLDOVER mode
+ */
+enum dpll_lock_status {
+	DPLL_LOCK_STATUS_UNSPEC,
+	DPLL_LOCK_STATUS_UNLOCKED,
+	DPLL_LOCK_STATUS_CALIBRATING,
+	DPLL_LOCK_STATUS_LOCKED,
+	DPLL_LOCK_STATUS_HOLDOVER,
+
+	__DPLL_LOCK_STATUS_MAX,
+	DPLL_LOCK_STATUS_MAX = (__DPLL_LOCK_STATUS_MAX - 1)
+};
+
+#define DPLL_TEMP_DIVIDER	10
+
+/**
+ * enum dpll_type - type of dpll, valid values for DPLL_A_TYPE attribute
+ * @DPLL_TYPE_UNSPEC: unspecified value
+ * @DPLL_TYPE_PPS: dpll produces Pulse-Per-Second signal
+ * @DPLL_TYPE_EEC: dpll drives the Ethernet Equipment Clock
+ */
+enum dpll_type {
+	DPLL_TYPE_UNSPEC,
+	DPLL_TYPE_PPS,
+	DPLL_TYPE_EEC,
+
+	__DPLL_TYPE_MAX,
+	DPLL_TYPE_MAX = (__DPLL_TYPE_MAX - 1)
+};
+
+/**
+ * enum dpll_pin_type - defines possible types of a pin, valid values for
+ *   DPLL_A_PIN_TYPE attribute
+ * @DPLL_PIN_TYPE_UNSPEC: unspecified value
+ * @DPLL_PIN_TYPE_MUX: aggregates another layer of selectable pins
+ * @DPLL_PIN_TYPE_EXT: external source
+ * @DPLL_PIN_TYPE_SYNCE_ETH_PORT: ethernet port PHY's recovered clock
+ * @DPLL_PIN_TYPE_INT_OSCILLATOR: device internal oscillator
+ * @DPLL_PIN_TYPE_GNSS: GNSS recovered clock
+ */
+enum dpll_pin_type {
+	DPLL_PIN_TYPE_UNSPEC,
+	DPLL_PIN_TYPE_MUX,
+	DPLL_PIN_TYPE_EXT,
+	DPLL_PIN_TYPE_SYNCE_ETH_PORT,
+	DPLL_PIN_TYPE_INT_OSCILLATOR,
+	DPLL_PIN_TYPE_GNSS,
+
+	__DPLL_PIN_TYPE_MAX,
+	DPLL_PIN_TYPE_MAX = (__DPLL_PIN_TYPE_MAX - 1)
+};
+
+/**
+ * enum dpll_pin_direction - defines possible direction of a pin, valid values
+ *   for DPLL_A_PIN_DIRECTION attribute
+ * @DPLL_PIN_DIRECTION_UNSPEC: unspecified value
+ * @DPLL_PIN_DIRECTION_SOURCE: pin used as a source of a signal
+ * @DPLL_PIN_DIRECTION_OUTPUT: pin used to output the signal
+ */
+enum dpll_pin_direction {
+	DPLL_PIN_DIRECTION_UNSPEC,
+	DPLL_PIN_DIRECTION_SOURCE,
+	DPLL_PIN_DIRECTION_OUTPUT,
+
+	__DPLL_PIN_DIRECTION_MAX,
+	DPLL_PIN_DIRECTION_MAX = (__DPLL_PIN_DIRECTION_MAX - 1)
+};
+
+#define DPLL_PIN_FREQUENCY_1_HZ		1
+#define DPLL_PIN_FREQUENCY_10_MHZ	10000000
+
+/**
+ * enum dpll_pin_state - defines possible states of a pin, valid values for
+ *   DPLL_A_PIN_STATE attribute
+ * @DPLL_PIN_STATE_UNSPEC: unspecified value
+ * @DPLL_PIN_STATE_CONNECTED: pin connected, active source of phase locked loop
+ * @DPLL_PIN_STATE_DISCONNECTED: pin disconnected, not considered as a valid
+ *   source
+ * @DPLL_PIN_STATE_SELECTABLE: pin enabled for automatic source selection
+ */
+enum dpll_pin_state {
+	DPLL_PIN_STATE_UNSPEC,
+	DPLL_PIN_STATE_CONNECTED,
+	DPLL_PIN_STATE_DISCONNECTED,
+	DPLL_PIN_STATE_SELECTABLE,
+
+	__DPLL_PIN_STATE_MAX,
+	DPLL_PIN_STATE_MAX = (__DPLL_PIN_STATE_MAX - 1)
+};
+
+/**
+ * enum dpll_pin_caps - defines possible capabilities of a pin, valid flags on
+ *   DPLL_A_PIN_CAPS attribute
+ */
+enum dpll_pin_caps {
+	DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE = 1,
+	DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE = 2,
+	DPLL_PIN_CAPS_STATE_CAN_CHANGE = 4,
+};
+
+/**
+ * enum dpll_event - events of dpll generic netlink family
+ * @DPLL_EVENT_UNSPEC: invalid event type
+ * @DPLL_EVENT_DEVICE_CREATE: dpll device created
+ * @DPLL_EVENT_DEVICE_DELETE: dpll device deleted
+ * @DPLL_EVENT_DEVICE_CHANGE: attribute of dpll device or pin changed, reason
+ *   is to be found with an attribute type (DPLL_A_*) received with the event
+ */
+enum dpll_event {
+	DPLL_EVENT_UNSPEC,
+	DPLL_EVENT_DEVICE_CREATE,
+	DPLL_EVENT_DEVICE_DELETE,
+	DPLL_EVENT_DEVICE_CHANGE,
+};
+
+enum dplla {
+	DPLL_A_DEVICE = 1,
+	DPLL_A_ID,
+	DPLL_A_DEV_NAME,
+	DPLL_A_BUS_NAME,
+	DPLL_A_MODE,
+	DPLL_A_MODE_SUPPORTED,
+	DPLL_A_LOCK_STATUS,
+	DPLL_A_TEMP,
+	DPLL_A_CLOCK_ID,
+	DPLL_A_TYPE,
+	DPLL_A_PIN_IDX,
+	DPLL_A_PIN_LABEL,
+	DPLL_A_PIN_TYPE,
+	DPLL_A_PIN_DIRECTION,
+	DPLL_A_PIN_FREQUENCY,
+	DPLL_A_PIN_FREQUENCY_SUPPORTED,
+	DPLL_A_PIN_FREQUENCY_MIN,
+	DPLL_A_PIN_FREQUENCY_MAX,
+	DPLL_A_PIN_PRIO,
+	DPLL_A_PIN_STATE,
+	DPLL_A_PIN_PARENT,
+	DPLL_A_PIN_PARENT_IDX,
+	DPLL_A_PIN_RCLK_DEVICE,
+	DPLL_A_PIN_DPLL_CAPS,
+
+	__DPLL_A_MAX,
+	DPLL_A_MAX = (__DPLL_A_MAX - 1)
+};
+
+enum {
+	DPLL_CMD_UNSPEC = 1,
+	DPLL_CMD_DEVICE_GET,
+	DPLL_CMD_DEVICE_SET,
+	DPLL_CMD_PIN_GET,
+	DPLL_CMD_PIN_SET,
+
+	__DPLL_CMD_MAX,
+	DPLL_CMD_MAX = (__DPLL_CMD_MAX - 1)
+};
+
+#define DPLL_MCGRP_MONITOR	"monitor"
+
+#endif /* _UAPI_LINUX_DPLL_H */
-- 
2.34.1

