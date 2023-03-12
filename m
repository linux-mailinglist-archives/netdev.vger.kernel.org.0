Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7142A6B62E9
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 03:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjCLC2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 21:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjCLC2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 21:28:48 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA8A3402E;
        Sat, 11 Mar 2023 18:28:45 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C2HZfX000640;
        Sat, 11 Mar 2023 18:28:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=+y1+/RoW91etQaOVEUUeBRGbdv9GXi5UUEQ1ZDZIGbE=;
 b=HNw0Q7MAqIWon5VTY5iUYst9V4GZdzo0FTZPRpsldVl68qOwOS50Uxn4vEFtUY2M6I9E
 gPuCAH8zfEM7ivbuS7yvbrCXb+YP37NF4ylhoI37myKbZEl0ZYmw+6JFxbi12SY1ACka
 ra0Bk4gn9VSDHH5fQ+6ZM2xmLtqPqsfbPnSdOehu7r3Kn9RYxbIJIsKhMMybSHgjutKy
 fRWUiZgwGkVlC7G+0eXauDg2dUDp9AE2hvDORZeFjZ5cAw4L6iz6kOGEIWZk1pieroAa
 NdIWOqUgSflL9jpMOHvyIr/MGnjmPw3BX7UmApD6eZd8UAW+mbMyci8BnwJRZl2R8++/ gA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3p8pjst0vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Mar 2023 18:28:24 -0800
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:23 -0800
Received: from devvm1736.cln0.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server id
 15.1.2507.17; Sat, 11 Mar 2023 18:28:21 -0800
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        "Arkadiusz Kubalewski" <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Vadim Fedorenko <vadim.fedorenko@linux.dev>, <poros@redhat.com>,
        <mschmidt@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-clk@vger.kernel.org>,
        "Michal Michalik" <michal.michalik@intel.com>
Subject: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Date:   Sat, 11 Mar 2023 18:28:02 -0800
Message-ID: <20230312022807.278528-2-vadfed@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230312022807.278528-1-vadfed@meta.com>
References: <20230312022807.278528-1-vadfed@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c0a8:1b::d]
X-Proofpoint-ORIG-GUID: hfdvK4U4ARlPIW2UDiBgREACjjguKeOz
X-Proofpoint-GUID: hfdvK4U4ARlPIW2UDiBgREACjjguKeOz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/netlink/specs/dpll.yaml | 514 ++++++++++++++++++++++++++
 drivers/dpll/dpll_nl.c                | 126 +++++++
 drivers/dpll/dpll_nl.h                |  42 +++
 include/uapi/linux/dpll.h             | 196 ++++++++++
 4 files changed, 878 insertions(+)
 create mode 100644 Documentation/netlink/specs/dpll.yaml
 create mode 100644 drivers/dpll/dpll_nl.c
 create mode 100644 drivers/dpll/dpll_nl.h
 create mode 100644 include/uapi/linux/dpll.h

diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
new file mode 100644
index 000000000000..03e9f0e2d3d2
--- /dev/null
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -0,0 +1,514 @@
+name: dpll
+
+doc: DPLL subsystem.
+
+definitions:
+  -
+    type: const
+    name: temp-divider
+    value: 10
+  -
+    type: const
+    name: pin-freq-1-hz
+    value: 1
+  -
+    type: const
+    name: pin-freq-10-mhz
+    value: 10000000
+  -
+    type: enum
+    name: lock-status
+    doc: |
+      Provides information of dpll device lock status, valid values for
+      DPLL_A_LOCK_STATUS attribute
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: unlocked
+        doc: |
+          dpll was not yet locked to any valid (or is in one of modes:
+          DPLL_MODE_FREERUN, DPLL_MODE_NCO)
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
+    type: enum
+    name: pin-type
+    doc: Enumerates types of a pin, valid values for DPLL_A_PIN_TYPE attribute
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
+    name: pin-state
+    doc: available pin modes
+    entries:
+      -
+        name: unspec
+        doc: unspecified value
+      -
+        name: connected
+        doc: pin connected
+      -
+        name: disconnected
+        doc: pin disconnected
+    render-max: true
+  -
+    type: enum
+    name: pin-direction
+    doc: available pin direction
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
+    type: enum
+    name: mode
+    doc: |
+      working-modes a dpll can support, differentiate if and how dpll selects
+      one of its sources to syntonize with it
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
+  -
+    type: flags
+    name: pin-caps
+    doc: define capabilities of a pin
+    entries:
+      -
+        name: direction-can-change
+      -
+        name: priority-can-change
+      -
+        name: state-can-change
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
+        name: source-pin-idx
+        type: u32
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
+        name: pin
+        type: nest
+        multi-attr: true
+        nested-attributes: pin
+        value: 12
+      -
+        name: pin-idx
+        type: u32
+      -
+        name: pin-description
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
+        type: u32
+      -
+        name: pin-frequency-supported
+        type: u32
+        multi-attr: true
+      -
+        name: pin-any-frequency-min
+        type: u32
+      -
+        name: pin-any-frequency-max
+        type: u32
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
+        nested-attributes: pin
+        value: 23
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
+        name: source-pin-idx
+        type: u32
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
+        name: pin
+        type: nest
+        value: 12
+        multi-attr: true
+        nested-attributes: pin
+      -
+        name: pin-prio
+        type: u32
+        value: 21
+      -
+        name: pin-state
+        type: u8
+        enum: pin-state
+      -
+        name: pin-dpll-caps
+        type: u32
+        value: 26
+  -
+    name: pin
+    subset-of: dpll
+    attributes:
+      -
+        name: device
+        type: nest
+        value: 1
+        multi-attr: true
+        nested-attributes: device
+      -
+        name: pin-idx
+        type: u32
+        value: 13
+      -
+        name: pin-description
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
+        type: u32
+      -
+        name: pin-frequency-supported
+        type: u32
+        multi-attr: true
+      -
+        name: pin-any-frequency-min
+        type: u32
+      -
+        name: pin-any-frequency-max
+        type: u32
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
+        value: 23
+      -
+        name: pin-rclk-device
+        type: string
+        value: 25
+      -
+        name: pin-dpll-caps
+        type: u32
+  -
+    name: pin-parent
+    subset-of: dpll
+    attributes:
+      -
+        name: pin-state
+        type: u8
+        value: 22
+        enum: pin-state
+      -
+        name: pin-parent-idx
+        type: u32
+        value: 24
+      -
+        name: pin-rclk-device
+        type: string
+
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
+        reply:
+          attributes:
+            - pin
+
+      dump:
+        pre: dpll-pin-pre-dumpit
+        post: dpll-pin-post-dumpit
+        request:
+          attributes:
+            - id
+            - bus-name
+            - dev-name
+        reply:
+          attributes:
+            - pin
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
+            - pin-parent-idx
+            - pin-state
+
+mcast-groups:
+  list:
+    -
+      name: monitor
diff --git a/drivers/dpll/dpll_nl.c b/drivers/dpll/dpll_nl.c
new file mode 100644
index 000000000000..099d1e30ca7c
--- /dev/null
+++ b/drivers/dpll/dpll_nl.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: BSD-3-Clause
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
+	[DPLL_A_PIN_FREQUENCY] = { .type = NLA_U32, },
+	[DPLL_A_PIN_DIRECTION] = NLA_POLICY_MAX(NLA_U8, 2),
+	[DPLL_A_PIN_PRIO] = { .type = NLA_U32, },
+	[DPLL_A_PIN_PARENT_IDX] = { .type = NLA_U32, },
+	[DPLL_A_PIN_STATE] = NLA_POLICY_MAX(NLA_U8, 2),
+};
+
+/* Ops table for dpll */
+static const struct genl_split_ops dpll_nl_ops[6] = {
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
index 000000000000..3a354dfb9a31
--- /dev/null
+++ b/drivers/dpll/dpll_nl.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
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
index 000000000000..ece6fe685d08
--- /dev/null
+++ b/include/uapi/linux/dpll.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
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
+#define DPLL_TEMP_DIVIDER	10
+#define DPLL_PIN_FREQ_1_HZ	1
+#define DPLL_PIN_FREQ_10_MHZ	10000000
+
+/**
+ * enum dpll_lock_status - Provides information of dpll device lock status,
+ *   valid values for DPLL_A_LOCK_STATUS attribute
+ * @DPLL_LOCK_STATUS_UNSPEC: unspecified value
+ * @DPLL_LOCK_STATUS_UNLOCKED: dpll was not yet locked to any valid (or is in
+ *   one of modes: DPLL_MODE_FREERUN, DPLL_MODE_NCO)
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
+/**
+ * enum dpll_pin_type - Enumerates types of a pin, valid values for
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
+ * enum dpll_pin_state - available pin modes
+ * @DPLL_PIN_STATE_UNSPEC: unspecified value
+ * @DPLL_PIN_STATE_CONNECTED: pin connected
+ * @DPLL_PIN_STATE_DISCONNECTED: pin disconnected
+ */
+enum dpll_pin_state {
+	DPLL_PIN_STATE_UNSPEC,
+	DPLL_PIN_STATE_CONNECTED,
+	DPLL_PIN_STATE_DISCONNECTED,
+
+	__DPLL_PIN_STATE_MAX,
+	DPLL_PIN_STATE_MAX = (__DPLL_PIN_STATE_MAX - 1)
+};
+
+/**
+ * enum dpll_pin_direction - available pin direction
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
+/**
+ * enum dpll_mode - working-modes a dpll can support, differentiate if and how
+ *   dpll selects one of its sources to syntonize with it
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
+/**
+ * enum dpll_pin_caps - define capabilities of a pin
+ */
+enum dpll_pin_caps {
+	DPLL_PIN_CAPS_DIRECTION_CAN_CHANGE = 1,
+	DPLL_PIN_CAPS_PRIORITY_CAN_CHANGE = 2,
+	DPLL_PIN_CAPS_STATE_CAN_CHANGE = 4,
+};
+
+enum dplla {
+	DPLL_A_DEVICE = 1,
+	DPLL_A_ID,
+	DPLL_A_DEV_NAME,
+	DPLL_A_BUS_NAME,
+	DPLL_A_MODE,
+	DPLL_A_MODE_SUPPORTED,
+	DPLL_A_SOURCE_PIN_IDX,
+	DPLL_A_LOCK_STATUS,
+	DPLL_A_TEMP,
+	DPLL_A_CLOCK_ID,
+	DPLL_A_TYPE,
+	DPLL_A_PIN,
+	DPLL_A_PIN_IDX,
+	DPLL_A_PIN_DESCRIPTION,
+	DPLL_A_PIN_TYPE,
+	DPLL_A_PIN_DIRECTION,
+	DPLL_A_PIN_FREQUENCY,
+	DPLL_A_PIN_FREQUENCY_SUPPORTED,
+	DPLL_A_PIN_ANY_FREQUENCY_MIN,
+	DPLL_A_PIN_ANY_FREQUENCY_MAX,
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
+	DPLL_CMD_UNSPEC,
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

