Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051EF4804FB
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 22:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhL0VyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 16:54:00 -0500
Received: from mail-eopbgr80131.outbound.protection.outlook.com ([40.107.8.131]:62808
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233671AbhL0Vx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 16:53:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UCBVt4dd+QfwQVaTxqBIdhPMK410MVIJHZ2uWuiaI9oi9OlCIyeY/Klhu8olFbqRJ8P0corsZqIOY29iV2cNEVP/5fIvyk5lBZhghrccCXwhVM6UIvU7izCCVzRcvmRVD9aoWu8zfgvUvT6BjqyrLRgTKkWBlPdxDg0xs/JI8fL/LLaMf5VbPjRUpnSEcRMNNkVd5C1x6GZNIXFhzvtl7oL7bqNatJ5AWTVp7stDK0LmOmPn2O8wU+z4oa1GxwQ5iElKL6OgKxGvYmpGRXTczzDnz802r5+oT2XTRWH4jRCMVLGCg6kKL6H81xys505wBAR8utcvd5RRkMe0WPE7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1+W2NTZ5kJmblHNx9FOC76h4Nudu3umSbfDsCLXzH0=;
 b=U2WowN0V66zx0Un+UNrNMGPP71d/HBGQVsIcdUUGbBBrVjdNFIujeWEzuFKiBWGjiZF4o6FATPf30FM8XHYBHDfu9xBKd9V25xNrpgfAMOQhOmvCaO8LC5V+bX55VerKv/2FTTfUnyAS417LLGi64qQ7TtViRRJk86dXkRAEsdVE4Sukdtx9X0QPnB6KxS5NLZFcwvi5W32/tvPJ6kpfzApwOnaC0kr7J7+3L3Mhn/SyJK+NaAx/GW4nlSTm5AClzJslJYaUYzyqkwVCDRehfuiki2mWalw/KdjvzzffAxFdYR7mr31pASgFs5GNMlVgAyXailOL5UHpk0GIGttjbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1+W2NTZ5kJmblHNx9FOC76h4Nudu3umSbfDsCLXzH0=;
 b=hvl+xLZN1kfaqaGtW4nSQTndGHqBB8lfw3FVuwQGFohiKafA1SaBd5EhE9D+A/OU+tQmsk0d/So+NP+/ABtU7vOUPJRiNCxgd7ZsankTSsjvbXZd/2jPblqj1ZWNVyTQ6WmxLN/+bpZ+k1bq1Uv+JO5E/75R+t0vgstSyXYV4b8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0145.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 21:53:56 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 21:53:56 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org, stephen@networkplumber.org, andrew@lunn.ch
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] net: marvell: prestera: add hardware router objects accounting
Date:   Mon, 27 Dec 2021 23:52:29 +0200
Message-Id: <20211227215233.31220-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::8) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e152b76-135f-4fda-3717-08d9c9836156
X-MS-TrafficTypeDiagnostic: AM4P190MB0145:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0145F4F4C68AA92F712943F193429@AM4P190MB0145.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvKEI0UThZhVUwUuZ+upPIZeNwP7yDPviLdwqWjmpw6Z9/3fUxraqw5QmbGq5ViEjFjoMrRWFk7uALy3y3Co94URGkwLHCmFtpdLsDjlRfmqRSRUS5M4CUiajVvds7eWBWswQ/sbtCHgEQT4RN+3UzOfzYl7CtZ+a35C50ssGo8+LaYYdA5w5etvHTnlA64WfezfyiMkG1Ac3FDIhgvCxsRQwlxeDLmu1prXfEatIWwAOjEanOfD8H35yXdFB4zY4ahgLPLcVBMXqHPYeERsaBCo+qYnNWimyT4vSEjzYAC2vFer46OlJWEgJBqvxleDhyGroJ8cA/VXC52l1SnsG/musNE/uHt+vUQm+TKkuosNKN7AXVNqrKUzJJfd3e2efr0O+ETlfpH95QMw3AZ7uS1EEsKLJ3fYd1QchNuQwjkPel2cUq1HQh8vy9jo0HMiSqtFFfgB8HETd6+krHzXfd95zmcMGpNOdmpRSxns1XbrOsh8kvisEDC0cW2Lc+q72mHXZ65ttg/3xaOFqZagHt8lj0qKhUV3Rxwt9Fy+83NKPYVQbmGPC9gCq9kfrs6NtcOEIqWBw0ketXLXSaKFQb2u513BPOe2EduWdjO0GuG+j2Y2zdLXNKw/MoBtcSvxPadAFHtxJFKu640/lEYQGGv1A12P1oSW7nzYqZU6Rcx5NDViBbVrNCPg3/PwKLo7PKUYLeLgxBhgGL0hlBVRJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(346002)(376002)(39830400003)(5660300002)(83380400001)(26005)(1076003)(54906003)(316002)(186003)(2906002)(6506007)(8936002)(4326008)(8676002)(2616005)(508600001)(38350700002)(38100700002)(66574015)(36756003)(6666004)(52116002)(86362001)(6486002)(6512007)(66556008)(66476007)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IPKvXc0Vv/neRcwhTuT7RyrSWx404OXIBgwJf/k29UEIAed2DbQAZmTgg1Mx?=
 =?us-ascii?Q?F4BXf7io5yso6x8lx9+CGNYYGYqvwuQQGQutb7d97fn3pBOk4EPgxTzVTV7j?=
 =?us-ascii?Q?EDhf+XNsjsleVB9yAbQ5v7FmN/ZPpAdwa8zWyrEBFn0gxbtuByN4BVUKkxyh?=
 =?us-ascii?Q?nX9+U4k3HkL03EHDl0td0A6WuLEpKD1bLNSQEADSb9pNVDuIclyjDJFuJDso?=
 =?us-ascii?Q?XOezEPXEPsJCSM2T5Kxvy7O+DVxSq990/6AN9VeN2lHafg5pWdvvAXLZKm7c?=
 =?us-ascii?Q?hkmYHTbd86cwFPx5UXQFJdFZ5QbaoE19zW8LM4clQ2YPh48iNe834EHl7hNU?=
 =?us-ascii?Q?KF76UbN4hnrsRFXU4o4VtNKbqlD4Rsx40J6q4asmjp/P1ugL2JY37VhFxgg5?=
 =?us-ascii?Q?FAJqCaPuaLVULdw4BKzXLVmobSi6KXHyw50D19EVL7D5B1no9EmSBG+DnGTT?=
 =?us-ascii?Q?qO4ddTeZ7mH7wECsAaGI4K/KaoN+bmVslGkXJwHog6coobCszxUqvQgFCN7D?=
 =?us-ascii?Q?oBlGy5yok80VzPGANppx0FxsaEV3XCAbuHeUFnoFszAJ37CEFxwBOK2iuaDT?=
 =?us-ascii?Q?OxVsIFmVKRhIKlsHMCJQLLx0NFouO4OcI42hpvisjPnPrZ4j+sH6UmNbT9m7?=
 =?us-ascii?Q?YQNgmbT2SeHZwQSaSIkPZy7lm+qd3PsAFgOiwCXIWWkWuEQeggy7GKUOSkaB?=
 =?us-ascii?Q?pIma4YdXLKIq5lx34rFOaDJynAhWqLHsc6Gu9eBss8nVFFiVMTBY1vlExiWA?=
 =?us-ascii?Q?S4305tNCRI0N3xhx2d7C/q+ARv9sOGiG0XTHgCb8Y7buwme3n6EkPL4OPLiR?=
 =?us-ascii?Q?xctGcMOM7KI7AkIoW86ZvBhuov7rnm0oh6jfNa26h7zLGqDlIkQ6ZaEblvx8?=
 =?us-ascii?Q?sKV/rPYzsFHQkcVhD6JPJr7DY6+qjmR0qSg5DJv0U/VQ4RnYYGbYTOkVD4FK?=
 =?us-ascii?Q?qcWQzVvatP9R0eCy5BQ4gBrX6iHHp5TRZKgNijB0AYpFIFPPlHBc3jWyO6xI?=
 =?us-ascii?Q?yjSua8FU+FJTVaI8+NfEYvCeF6qqM2xqqCcstkHXccxcJvQJjAC1yUFpreKE?=
 =?us-ascii?Q?piyKTR/MjHEkULhRptuEX3JfoJNPvsbi+J9VxarJafp5GtonxMQ5FXKLZ+pW?=
 =?us-ascii?Q?s4Ab+oDMGKmUUgpUdzZOisB+sxpRf8vLZl8wGdh5tCqaz8MLRjt7TYRdEqP7?=
 =?us-ascii?Q?alE/Bg7R/gw2iMCZtqvZE6m77O2kqT0NjM/U5n+ADDDvKF/axyrSVP0n1XRh?=
 =?us-ascii?Q?XdEdyd3Yzo4T0Zl4N14VaVrN9cTVRYXx/aPRY8TSliLjr2AWRSgL+JpVrog/?=
 =?us-ascii?Q?8eg63QeV0yWNrtJzXnKlgVMTlGgy+eouaid/I3wUoeXQ7tVKOpKMNSrKYqIS?=
 =?us-ascii?Q?fLzPIWTIUpCnNMFuXRIFep5p4VpmscHmkjYJX832APXTWrEnwK86ky+LCU0a?=
 =?us-ascii?Q?aRGXSLbeDgLgcMN8Ov3ZtoArhIPAuqy1gMBINwg4NXtm0Qdx0e4/SO3ainnO?=
 =?us-ascii?Q?OTkTe/zYqv9pkjh3DQdmavHuAuYCSRXzfKLaPeM1+qww+KImZk35MuHDK2qV?=
 =?us-ascii?Q?MjYa4Ti9krZNNmYaUm2fSuJIlk0I7SS98rNZMLnQYQzRdyLYvB5oyGSea29V?=
 =?us-ascii?Q?tNVjMLFAnnGcRFJNhtBp6brjm6ZA/f2sTuSo3U5DyzDfyu5WYJlKzbql+Hwv?=
 =?us-ascii?Q?o205eA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e152b76-135f-4fda-3717-08d9c9836156
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 21:53:56.1825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fYMXK7xmIsCipUbCKkq8HNSQbJTT8pCXtX4jNdvCHEK3X4YhhoVkuXRF5aFEfF4SwxtsYGxSzRLKEZd09JewQFAPvv/mc5P1CwfyyqSwIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0145
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
---
v1-->v2
* No changes
---
 .../net/ethernet/marvell/prestera/Makefile    |   2 +-
 .../marvell/prestera/prestera_router.c        |  10 +
 .../marvell/prestera/prestera_router_hw.c     | 209 ++++++++++++++++++
 .../marvell/prestera/prestera_router_hw.h     |  36 +++
 4 files changed, 256 insertions(+), 1 deletion(-)
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
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index f3980d10eb29..2a32831df40f 100644
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
@@ -17,7 +19,15 @@ int prestera_router_init(struct prestera_switch *sw)
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
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
new file mode 100644
index 000000000000..4f66fb21a299
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -0,0 +1,209 @@
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
+	u16 hw_vr_id;
+	int err;
+
+	err = prestera_hw_vr_create(sw, &hw_vr_id);
+	if (err)
+		return ERR_PTR(-ENOMEM);
+
+	vr = kzalloc(sizeof(*vr), GFP_KERNEL);
+	if (!vr) {
+		err = -ENOMEM;
+		goto err_alloc_vr;
+	}
+
+	vr->tb_id = tb_id;
+	vr->hw_vr_id = hw_vr_id;
+
+	list_add(&vr->router_node, &sw->router->vr_list);
+
+	return vr;
+
+err_alloc_vr:
+	prestera_hw_vr_delete(sw, hw_vr_id);
+	kfree(vr);
+	return ERR_PTR(err);
+}
+
+static void __prestera_vr_destroy(struct prestera_switch *sw,
+				  struct prestera_vr *vr)
+{
+	prestera_hw_vr_delete(sw, vr->hw_vr_id);
+	list_del(&vr->router_node);
+	kfree(vr);
+}
+
+static struct prestera_vr *prestera_vr_get(struct prestera_switch *sw, u32 tb_id,
+					   struct netlink_ext_ack *extack)
+{
+	struct prestera_vr *vr;
+
+	vr = __prestera_vr_find(sw, tb_id);
+	if (!vr)
+		vr = __prestera_vr_create(sw, tb_id, extack);
+	if (IS_ERR(vr))
+		return ERR_CAST(vr);
+
+	return vr;
+}
+
+static void prestera_vr_put(struct prestera_switch *sw, struct prestera_vr *vr)
+{
+	if (!vr->ref_cnt)
+		__prestera_vr_destroy(sw, vr);
+}
+
+/* iface is overhead struct. vr_id also can be removed. */
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
+		pr_err("Unsupported iface type");
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
+	e->vr->ref_cnt--;
+	prestera_vr_put(sw, e->vr);
+	kfree(e);
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
+	e->vr->ref_cnt++;
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
+	e->vr->ref_cnt--;
+	prestera_vr_put(sw, e->vr);
+err_vr_get:
+err_key_copy:
+	kfree(e);
+err_kzalloc:
+	return NULL;
+}
+
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
new file mode 100644
index 000000000000..fed53595f7bb
--- /dev/null
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0 */
+/* Copyright (c) 2019-2021 Marvell International Ltd. All rights reserved. */
+
+#ifndef _PRESTERA_ROUTER_HW_H_
+#define _PRESTERA_ROUTER_HW_H_
+
+struct prestera_vr {
+	struct list_head router_node;
+	unsigned int ref_cnt;
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
+
+#endif /* _PRESTERA_ROUTER_HW_H_ */
-- 
2.17.1

