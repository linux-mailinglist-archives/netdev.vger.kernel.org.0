Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0194870DC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345659AbiAGDCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:02:48 -0500
Received: from mail-eopbgr80102.outbound.protection.outlook.com ([40.107.8.102]:24869
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345648AbiAGDCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 22:02:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBioSj40nNbBWAQM3peAAdRC/5m2tZpU4M4rnJc9QjDjmI8RuzE1pw8UEI6XCy/tge67yUndUTStAgb7uWu225L5pF/4V9+8TY8twgbgvRXmsNBUWHOhRZaPTBAJq8S9d16izcdE+zOmQPfhG7ScKZJxXkhNH8+srREtq/luedD6hq8WAKe/z3Vf/2jByk4US4rCK+qC57yTdSfBNOG7qlTGLxrfsyG4omuFBZhzBZAkgzyQlQRvCNS8KA3b+qeHP+r/dhTeZluCYDbrqBsjZUhjN+QM8o90hE67fg8/bH6ZLgOL0UeeKVPWvgzUmFtm/+fCx1P8JCXHQOniboUbfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wScunyYe7FW53yN4bxTA939JoDYEOhDFkNzzkjT2OQY=;
 b=VOEVlwc2qLOWy7BSVGUil5sZXwzAdcg4h6zXKZPnARJTv4dm/U9dQAK0QthAacdyJTB16hDPzlHWkGVaBAi6a8/FqDD/JHyaJanJAaXUPnCFeeeu+lrL741E/ud0S5ACpUklerUSkuuAq3yKA1N6XSC8RPRH5dxjWMXLDTUnbxO2DL6KUPVtqTK+c4Sx2JWw+WCEl1RDParGpNAlnXETuWm2gMZxbuPVJfTTJhNdw73FpaqGsVz0/QnSi/FNaUlXZZtdLxhsGH4MMVS1cdv48CvdH8htJZL1hPQaI+irbOKZAempwb5yrIlaKI1m2HY5NaQUCYOZuxoildTzgZHdUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wScunyYe7FW53yN4bxTA939JoDYEOhDFkNzzkjT2OQY=;
 b=sF305NZA955IoUSgGbtbt0UxE4kfF90ZvRVTOKT0Wyoba8JOE/MD4/AFwY1r09SNs0BbMIFS0iw+YKY9mO9J/KkvzREDdqMg+kOvWfbmwsSrYxklRkoV5Fi0DaAY6kHRrTy5m2YHxzC10g5ny/55/Lt/1+Ea/3Z9Hngz9jLBTMs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM8P190MB0834.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:1d8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 03:02:34 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 03:02:34 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch,
        idosch@idosch.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/6] net: marvell: prestera: add hardware router objects accounting
Date:   Fri,  7 Jan 2022 05:01:34 +0200
Message-Id: <20220107030139.8486-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
References: <20220107030139.8486-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7ba9ace-a281-4697-a647-08d9d18a2721
X-MS-TrafficTypeDiagnostic: AM8P190MB0834:EE_
X-Microsoft-Antispam-PRVS: <AM8P190MB0834BE3CA89769DFB40EDF56934D9@AM8P190MB0834.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N2j8pm16ZBirBMfhwgo7hqBj5DgnkczXUskfkqRVBeT52wNCMDqEhNAjlNdqmmtTZ1vA9zap+XFIlbEQyIA5+jHbYv6n5v+yfRD8Ur78zDlgeY4bkOuJZrPMIesSSmyKZotbhYp85vQX1XnC6BA5i4C5JpGtSStNhEgynZeh/cS98XPF/PBIqgIGnU06nKuWoTM+G1xeTB78JiV9+H83uPx4FmgHTJvdYr05z2jGoZUYwAk2NJdBaZUbjzTqZjEXAPfjonW6lwyY/qrOkdPCnXKTjtUush+dolXNAlwnJXmAviPaQGlsx1bSVcuNA6ic9WLAEXjWw3m2TA/EhsBi7rAJ+PPHR2ZCAvFtdzfTfJQc+deUdjO5mDRkCwbJ7XaMwnpxYAXi2kKNnoY09BTuMxRTcYXnSlvIUd69aj524uyXFu/dh+8dNkD1LiY673ka0uLeBwRcJtwlEKWMi0QeFKcGzkAVeEj0y7ueQETBAPvSqOi1RFn5ggOoBImMaqQHCU4M2OxEHue4xDxetfgQVZWM5JRKEtKQZJo/v2QZlGch/WEqsykb2W1dnVbRmMu4EizPeFR1TNOY69uAqousY4JOeIfwyuRWvzTg9cOBu2NBBl1tEm05vPSQ4ez0xU0Pn9zsjIceWPPWUIpKQ38s1LvnL9h6fjNLS0eIfliibW86cPJq1NktNX35qRPc2Z+jM+ftl5JsayDVpu6QP23dKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(38350700002)(66946007)(316002)(6512007)(86362001)(38100700002)(1076003)(66574015)(8936002)(508600001)(186003)(54906003)(2906002)(8676002)(83380400001)(52116002)(6506007)(26005)(66556008)(66476007)(6486002)(2616005)(5660300002)(44832011)(36756003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E7MoQAqSDNi0qYMkHVa1Y/14uPE6apqhAgtOYdyTxDsuOeF5t7MOxkAXt92B?=
 =?us-ascii?Q?diTb+VTj0M6aO4z3mBizYFQ/7Dw/39yyCUY2UIyOo+GTqpzULbPsPoi56T1G?=
 =?us-ascii?Q?SYzfC/8WgmOtVOSCJb3U8sjXD5LeEQ6HS+bA4LL/kgu/OTXpTbiWRys5i7Tu?=
 =?us-ascii?Q?xVbvM4giGswq2u3bAHkLbNC7+pnUwPdBPbgKK0j4VEdg6cTD+yxhnXyCrJxL?=
 =?us-ascii?Q?Zj7k8qIhxr4ay/8rfwYnLJPujPVNKg+bIA8OFyVh0u0pBR2pDd10mxZySvKp?=
 =?us-ascii?Q?jL1oWjNKXK9DzMWOrv6Ei3q13HRta/c+LvIN/WKEYfx+pI1FtugtkgfD8ndM?=
 =?us-ascii?Q?YC/wv5zSNJOuxuwIrEiWDrwOUh4FQVJ/LA4VGeUHklziLrPueIM6+gRV6UVz?=
 =?us-ascii?Q?khp741jZd8XbScbPic/7f9aAwPkn3nDYM9+G/OJIzydngEPwMGraub2Ndtvr?=
 =?us-ascii?Q?lyKvVmrOpW1jRCulcUwX2Rmz4BN07fgtjojEBsZ8bsYgbHly2Kxq5Yoz0fHu?=
 =?us-ascii?Q?chMlDAdTGiqD2KjVJT5ZOoPzC4eIyYUGQSDNqk0fL9QALc0yd+QUtF0bOFgH?=
 =?us-ascii?Q?TRyvMwGT4u55NTzxtOlCarDUROghWAIX07f7jOZHA8vAaZwcH/J1D5FfNThC?=
 =?us-ascii?Q?F42cD3x7OHjJ5w9qmrnRQqw6td5d+0Q19NNy08n4sQSLfODg5Cx6D4fysIaA?=
 =?us-ascii?Q?kZs4I1CTrpm/k4LwA2wsWuT68cl9oagTlNkV0/QN12iLp8CC3EH4hxLdsYuA?=
 =?us-ascii?Q?ExeVFZaK+VJoYlc2xFAhF1yciMZ2/5TwchgXs9bkzrFUHHd1WlrqT6kdKa/S?=
 =?us-ascii?Q?TmShFAyIm2pbnjpF/j8D/l09MgCK/85yrQoBwlbB8MW2W8KaEqyfpTYzZ0EX?=
 =?us-ascii?Q?9REtpHMZ6JmaokDs+eI/d5N+Pn3Ae9L4R8AP3KA4bmrC0PoF8aSv4XQ93jAi?=
 =?us-ascii?Q?e/y540I5nJF57sHhKNRoxg9QnF0MJu8pKDe8j9q3DKB84/MTYaUFMJZXuj7R?=
 =?us-ascii?Q?mYsEdFmzZ9cP8PQT7OVKWQiWbROsrWaOECIMXPmMmZ6eZXtkP4KY+US/tjC5?=
 =?us-ascii?Q?OtxNQt2ILzYI+sYCY2FhPghQrh0MW5DPlNIZmFOQYgxNKBF1s1TCAKFVPmew?=
 =?us-ascii?Q?MMd62NUHyV7zUzjn9KRux4guM1VVuUr7i4gj4/CcaerOCg3kfoMeeZCXzk6E?=
 =?us-ascii?Q?bKB5cmeY0KiSXIK270chLSJNPZhywt12rAZSQsTkpmgW1QH3Ik4j+0XxvzQN?=
 =?us-ascii?Q?i5eAqAfGeTJ9EWebs4hhLFPlpmrgr5DZVDQtx712+99/H9CPrAetrcQzz5ll?=
 =?us-ascii?Q?R0RfuRnHtxeQHlejtyncyXf1Ba35VRnqiU8FYuNjZ11oiJzpZssD2HzkdbLd?=
 =?us-ascii?Q?4u/JGU4GQeNH9wbk7Rg8TbgLjF7MxTpy9q8hoN3HZcN9gob6jIp0PlSI56bU?=
 =?us-ascii?Q?O4P7ouEl3LjxRgBmLlekRxHCUWsijd3MSFB/3in0CXraTiiP+ksu0xj1zXDM?=
 =?us-ascii?Q?gSq9Ujiw3bvRRgdviRQmjx2N71iO8hD4Pf52mpSpULrWdXkh3cP4p4apG8m/?=
 =?us-ascii?Q?sgQ7GWyi+fsSe5pfz4pSrP//ZCE2nWgRjXQ/lIUhucGDekRl1EgFtfE5F+0n?=
 =?us-ascii?Q?SITLr0GpPvmkds3BqeI6+0mKgv8xtH337q0uUBoYPIm/Wn+tUXk945pUxJ65?=
 =?us-ascii?Q?IyT8hQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ba9ace-a281-4697-a647-08d9d18a2721
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 03:02:34.3249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /NAA2tfMQYC8EeAUG845d9kB+38LAydD2/LlbBBFVowu3ymP7Ogry+S4acs48gJP4zK44/4IiN4sp9Id46YmtP2JuruBNOXJtUEgxufeZeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P190MB0834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add prestera_router_hw.c. This file contains functions, which track HW
objects relations and links. This include implicity creation of objects,
that needed by requested one and implicity removing of objects, which
reference counter is became zero.

We need this layer, because kernel callbacks not always mapped to
creation of single HW object. So let it be two different layers - one
for subscribing and parsing kernel structures, and another
(prestera_router_hw.c) for HW objects relations tracking.

There is two types of objects on router_hw layer:
 - Explicit objects (rif_entry) : created by higher layer.
 - Implicit objects (vr) : created on demand by explicit objects.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Change-Id: Idc9245380fdf314e679244461875ca057b5e3372
---
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   2 +
 .../marvell/prestera/prestera_router.c        |  11 +
 .../marvell/prestera/prestera_router_hw.c     | 214 ++++++++++++++++++
 .../marvell/prestera/prestera_router_hw.h     |  37 +++
 5 files changed, 265 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h

diff --git a/drivers/net/ethernet/marvell/prestera/Makefile b/drivers/net/ethernet/marvell/prestera/Makefile
index ec69fc564a9f..d395f4131648 100644
--- a/drivers/net/ethernet/marvell/prestera/Makefile
+++ b/drivers/net/ethernet/marvell/prestera/Makefile
@@ -4,6 +4,6 @@ prestera-objs		:= prestera_main.o prestera_hw.o prestera_dsa.o \
 			   prestera_rxtx.o prestera_devlink.o prestera_ethtool.o \
 			   prestera_switchdev.o prestera_acl.o prestera_flow.o \
 			   prestera_flower.o prestera_span.o prestera_counter.o \
-			   prestera_router.o
+			   prestera_router.o prestera_router_hw.o
 
 obj-$(CONFIG_PRESTERA_PCI)	+= prestera_pci.o
diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 412b45ec2b30..a70ee6d2d446 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -279,6 +279,8 @@ struct prestera_switch {
 
 struct prestera_router {
 	struct prestera_switch *sw;
+	struct list_head vr_list;
+	struct list_head rif_entry_list;
 };
 
 struct prestera_rxtx_params {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index f3980d10eb29..b5bd853d4279 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -5,10 +5,12 @@
 #include <linux/types.h>
 
 #include "prestera.h"
+#include "prestera_router_hw.h"
 
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
+	int err;
 
 	router = kzalloc(sizeof(*sw->router), GFP_KERNEL);
 	if (!router)
@@ -17,11 +19,20 @@ int prestera_router_init(struct prestera_switch *sw)
 	sw->router = router;
 	router->sw = sw;
 
+	err = prestera_router_hw_init(sw);
+	if (err)
+		goto err_router_lib_init;
+
 	return 0;
+
+err_router_lib_init:
+	kfree(sw->router);
+	return err;
 }
 
 void prestera_router_fini(struct prestera_switch *sw)
 {
+	prestera_router_hw_fini(sw);
 	kfree(sw->router);
 	sw->router = NULL;
 }
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
new file mode 100644
index 000000000000..de8c3095e3aa
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved */
+
+#include <linux/rhashtable.h>
+
+#include "prestera.h"
+#include "prestera_hw.h"
+#include "prestera_router_hw.h"
+#include "prestera_acl.h"
+
+/*            +--+
+ *   +------->|vr|
+ *   |        +--+
+ *   |
+ * +-+-------+
+ * |rif_entry|
+ * +---------+
+ *  Rif is
+ *  used as
+ *  entry point
+ *  for vr in hw
+ */
+
+int prestera_router_hw_init(struct prestera_switch *sw)
+{
+	INIT_LIST_HEAD(&sw->router->vr_list);
+	INIT_LIST_HEAD(&sw->router->rif_entry_list);
+
+	return 0;
+}
+
+void prestera_router_hw_fini(struct prestera_switch *sw)
+{
+	WARN_ON(!list_empty(&sw->router->vr_list));
+	WARN_ON(!list_empty(&sw->router->rif_entry_list));
+}
+
+static struct prestera_vr *__prestera_vr_find(struct prestera_switch *sw,
+					      u32 tb_id)
+{
+	struct prestera_vr *vr;
+
+	list_for_each_entry(vr, &sw->router->vr_list, router_node) {
+		if (vr->tb_id == tb_id)
+			return vr;
+	}
+
+	return NULL;
+}
+
+static struct prestera_vr *__prestera_vr_create(struct prestera_switch *sw,
+						u32 tb_id,
+						struct netlink_ext_ack *extack)
+{
+	struct prestera_vr *vr;
+	int err;
+
+	vr = kzalloc(sizeof(*vr), GFP_KERNEL);
+	if (!vr) {
+		err = -ENOMEM;
+		goto err_alloc_vr;
+	}
+
+	vr->tb_id = tb_id;
+
+	err = prestera_hw_vr_create(sw, &vr->hw_vr_id);
+	if (err)
+		goto err_hw_create;
+
+	list_add(&vr->router_node, &sw->router->vr_list);
+
+	return vr;
+
+err_hw_create:
+	kfree(vr);
+err_alloc_vr:
+	return ERR_PTR(err);
+}
+
+static void __prestera_vr_destroy(struct prestera_switch *sw,
+				  struct prestera_vr *vr)
+{
+	list_del(&vr->router_node);
+	prestera_hw_vr_delete(sw, vr->hw_vr_id);
+	kfree(vr);
+}
+
+static struct prestera_vr *prestera_vr_get(struct prestera_switch *sw,
+					   u32 tb_id,
+					   struct netlink_ext_ack *extack)
+{
+	struct prestera_vr *vr;
+
+	vr = __prestera_vr_find(sw, tb_id);
+	if (vr) {
+		refcount_inc(&vr->refcount);
+	} else {
+		vr = __prestera_vr_create(sw, tb_id, extack);
+		if (IS_ERR(vr))
+			return ERR_CAST(vr);
+
+		refcount_set(&vr->refcount, 1);
+	}
+
+	return vr;
+}
+
+static void prestera_vr_put(struct prestera_switch *sw, struct prestera_vr *vr)
+{
+	if (refcount_dec_and_test(&vr->refcount))
+		__prestera_vr_destroy(sw, vr);
+}
+
+static int
+__prestera_rif_entry_key_copy(const struct prestera_rif_entry_key *in,
+			      struct prestera_rif_entry_key *out)
+{
+	memset(out, 0, sizeof(*out));
+
+	switch (in->iface.type) {
+	case PRESTERA_IF_PORT_E:
+		out->iface.dev_port.hw_dev_num = in->iface.dev_port.hw_dev_num;
+		out->iface.dev_port.port_num = in->iface.dev_port.port_num;
+		break;
+	case PRESTERA_IF_LAG_E:
+		out->iface.lag_id = in->iface.lag_id;
+		break;
+	case PRESTERA_IF_VID_E:
+		out->iface.vlan_id = in->iface.vlan_id;
+		break;
+	default:
+		WARN(1, "Unsupported iface type");
+		return -EINVAL;
+	}
+
+	out->iface.type = in->iface.type;
+	return 0;
+}
+
+struct prestera_rif_entry *
+prestera_rif_entry_find(const struct prestera_switch *sw,
+			const struct prestera_rif_entry_key *k)
+{
+	struct prestera_rif_entry *rif_entry;
+	struct prestera_rif_entry_key lk; /* lookup key */
+
+	if (__prestera_rif_entry_key_copy(k, &lk))
+		return NULL;
+
+	list_for_each_entry(rif_entry, &sw->router->rif_entry_list,
+			    router_node) {
+		if (!memcmp(k, &rif_entry->key, sizeof(*k)))
+			return rif_entry;
+	}
+
+	return NULL;
+}
+
+struct prestera_rif_entry *
+prestera_rif_entry_create(struct prestera_switch *sw,
+			  struct prestera_rif_entry_key *k,
+			  u32 tb_id, const unsigned char *addr)
+{
+	int err;
+	struct prestera_rif_entry *e;
+	struct prestera_iface iface;
+
+	e = kzalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		goto err_kzalloc;
+
+	if (__prestera_rif_entry_key_copy(k, &e->key))
+		goto err_key_copy;
+
+	e->vr = prestera_vr_get(sw, tb_id, NULL);
+	if (IS_ERR(e->vr))
+		goto err_vr_get;
+
+	memcpy(&e->addr, addr, sizeof(e->addr));
+
+	/* HW */
+	memcpy(&iface, &e->key.iface, sizeof(iface));
+	iface.vr_id = e->vr->hw_vr_id;
+	err = prestera_hw_rif_create(sw, &iface, e->addr, &e->hw_id);
+	if (err)
+		goto err_hw_create;
+
+	list_add(&e->router_node, &sw->router->rif_entry_list);
+
+	return e;
+
+err_hw_create:
+	prestera_vr_put(sw, e->vr);
+err_vr_get:
+err_key_copy:
+	kfree(e);
+err_kzalloc:
+	return NULL;
+}
+
+void prestera_rif_entry_destroy(struct prestera_switch *sw,
+				struct prestera_rif_entry *e)
+{
+	struct prestera_iface iface;
+
+	list_del(&e->router_node);
+
+	memcpy(&iface, &e->key.iface, sizeof(iface));
+	iface.vr_id = e->vr->hw_vr_id;
+	prestera_hw_rif_delete(sw, e->hw_id, &iface);
+
+	prestera_vr_put(sw, e->vr);
+	kfree(e);
+}
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
new file mode 100644
index 000000000000..b6b028551868
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_ROUTER_HW_H_
+#define _PRESTERA_ROUTER_HW_H_
+
+struct prestera_vr {
+	struct list_head router_node;
+	refcount_t refcount;
+	u32 tb_id;			/* key (kernel fib table id) */
+	u16 hw_vr_id;			/* virtual router ID */
+	u8 __pad[2];
+};
+
+struct prestera_rif_entry {
+	struct prestera_rif_entry_key {
+		struct prestera_iface iface;
+	} key;
+	struct prestera_vr *vr;
+	unsigned char addr[ETH_ALEN];
+	u16 hw_id; /* rif_id */
+	struct list_head router_node; /* ht */
+};
+
+struct prestera_rif_entry *
+prestera_rif_entry_find(const struct prestera_switch *sw,
+			const struct prestera_rif_entry_key *k);
+void prestera_rif_entry_destroy(struct prestera_switch *sw,
+				struct prestera_rif_entry *e);
+struct prestera_rif_entry *
+prestera_rif_entry_create(struct prestera_switch *sw,
+			  struct prestera_rif_entry_key *k,
+			  u32 tb_id, const unsigned char *addr);
+int prestera_router_hw_init(struct prestera_switch *sw);
+void prestera_router_hw_fini(struct prestera_switch *sw);
+
+#endif /* _PRESTERA_ROUTER_HW_H_ */
-- 
2.17.1

