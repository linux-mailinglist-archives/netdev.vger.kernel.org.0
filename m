Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B087B479524
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240644AbhLQTz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:55:58 -0500
Received: from mail-db8eur05on2110.outbound.protection.outlook.com ([40.107.20.110]:21601
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240731AbhLQTzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:55:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJCq5R0OWS+otF+PwkmlX7Zl9inPODbOJkuREYo4ta+uz2Ia06vQ/07ymdQxci/91WPJT+/hs7zNHrF9MNX40xK16zn6FT62Op/64QUVPepgLZTQ8DedjT6wq8xpEjlydpPsUdawyjsuLlpnSb3ltt6VEIQD66koMyJdXyTw2fBTRBN+SpJsCmz2Cxi4Tymll5EV0FuqSDrH4fGKzFxc6DGei6lH8KwzFwcOVTn528Wya/j/+qZGjM4hZ7ADjuQqscQW8FXdbPwImWC9LBi4tnWLui9lQ3aSjDMRlqV0plijULoFK91tXmmOTrFQb8X8gm9KxMHj4JzvN4vjgY7v4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Y9t2fCUDc8T9WUbGGt+FTFOhdDwwXed648V7PQJUis=;
 b=ah6mgv/yA+b/5YbO8sJ8PYzZ2qMSMm52K7iutYFvXEQEHT/+a5zBIj0cVDnAT2iARtQdDy58cHiRz1Tl2F6Q4L6RZ35pwV0EpRtqKN7kT61Q7zVFR9aMUSge86bsIDW03e2dtp4DgPkhq1e9rMvv38Im3IXM74cMJIdUtnRbCoBTdQNEEZqUVMH6HJbsLq23Bx0p/s7+C++rwiE59dc/YNpkofQacQOmcMWnsUWMup/3Qm00yHdYZEqc23ELtlE0bFqoXG6wh4Ra5G5f/5Bn4cef02JZUw4u6X+zzjrawiIIUdBDojjJiED66QigEhL5znDSifZNqkPL2Svq6LlJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y9t2fCUDc8T9WUbGGt+FTFOhdDwwXed648V7PQJUis=;
 b=rBOel5sMCAgKCg0EmuvFHFwLAP3f6fqdxImPHScQkstjKmTUIbaKqFsQN8NKvRO0Mo1z3o01Hxup2AoVdzTXIsd122SULbTHd4g0B2vXI7RhqD7r00zVGqwxBcnMKD3yeLr3H91pErwQFwG6Em3ikHjGOdL8zz8ORi1wBOZ/+sU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:55:53 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:55:53 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: marvell: prestera: add hardware router objects accounting
Date:   Fri, 17 Dec 2021 21:54:36 +0200
Message-Id: <20211217195440.29838-5-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0debe85d-43d0-4e7d-0b47-08d9c1973b5b
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB10584F22128A49384F3644EF93789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGbhHOJyt0AVzxKuSdZTUoRJnOA7jkzaffsZNUGNuTLoLxtigb11zvauRsjfhASay8y6xV9oE9p5C74asFYmEB/8hI7wXOxSJn5hxNSXsc61tf163PAP9jDG7B89MTxyZcU7cnm7J9K6QJ77punJLRFUCnGn8Cu9MbJ6emD0ITmc+lXbTJ5tcrom5qL3QuohMXJuJ5AuY7ghqbtvLHImcImesekivIiGWDubWXUlvn+1RgeqEwwGB1MAxVQkK36vleblUhRqjBzY/eXkDxGY/4huDh+Cu845DDQur5UmhBJQWy1V3DVjtnMZvrCZPaMhRJ4F04FMk2FeeBhGZLcb7P2OqKwdr2aKUHoL28HrRkRhbKfGudpuJL9/ETgL6unxid/cHMQWdKF//j0Hyzt4oaAZ/GmkEuBpKwIgkb9B0JCN7ZVzwNSF1M/TCplWhvsvzrx2JOF3jprPQXsIOb1WoYKoX+RerpJgIVDh7qMerSnhl/+6hh36nZSEFWEgzNLN+SpCbD/ZXD3TOEpkc2J4Dfm9BFASv44pa7l/JaJklo+kej0nOsxjV7GPOh80C1VF6mGVdD+IBan4oDgeZPolZ4yVvForuahQpybpMz+BVWUg4+aN2gbdywRG5g4Ppq2or8vcyqIp6nfDFqTNj0BLBYzfpt2htzymQlGMi5oI1OvX8RJX6b2tpNxEUWvQZtsnOepFOEnohlsTJ92yH4ixPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39840400004)(136003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(6666004)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?86Khl7IwLkZ7yKZ8rMLUsEwKJ3h1DAd0RVyl+Ef834ms9hc88AYzHEIWv8ay?=
 =?us-ascii?Q?kAptJnd/UTiq/ufhP9u9+t9CpbHFKlPfOWh+MZDMqZpuAZ8BGtExXo/ck2iJ?=
 =?us-ascii?Q?UecnpAXugQLpWngkMWBLr4nosoD8AyGrs4obSqgHoqxtSLsE40IlkfyoC8w5?=
 =?us-ascii?Q?bgFQ/8ClPohQ7+IGAv/x6ZgmkZpFOAyWAQjDWrEHy4EjfYK4iRAqfwiPbcP0?=
 =?us-ascii?Q?F4R7XS9t4n9jbHVGQG62x7c0y4fj9sIWVw92kl4alxUQw5vvjQi0xLrfEXwZ?=
 =?us-ascii?Q?ZlBxLsC2KVlC4tAgKIGtUKQfxcynZmmXNOtDN0jXcg0xEjEVUYb+5fxB4Azu?=
 =?us-ascii?Q?RAt5YZPBIYlkZ+46Y1HfiQwEBItqSwA+V/dbbzrGyl73Dl/ZsgF2FW8fMS+3?=
 =?us-ascii?Q?Xq89+Z8okmLo7KZPlObinSYU0l5LJYu2yvcEUBQpxlQJyPNeG9ZfwtzhSu/a?=
 =?us-ascii?Q?r3ZwcdVZ1r+UFBKM/tdveslkSn28dsECh6f5KNVcVNRNtAVhZDO0yMutgXsr?=
 =?us-ascii?Q?PmH0b53v2CWiysrfdY2MY3pYBqpt9RRhmkSdvM/14vJqgyLsHPguIg2vrE37?=
 =?us-ascii?Q?1ZCE6mmpFbOmcvcpYAv1zEb5uf66aJ4Mto1wmWoe/hskjDpfH232qC+r8Hpe?=
 =?us-ascii?Q?jiJvuSDJGgZff5kRKDGXNv+7loQMfh49Wjcaf27mYJUmP4tFEVz4cWLJNJAX?=
 =?us-ascii?Q?U1fZ7zj0z7R8/7V9lSLuv/ltcaSiuUkucfgO9HraAa4nrHX+nXhJa5qILYGl?=
 =?us-ascii?Q?Bp4Rpde0RI+sL4jiMlCwrKacHLhEPEuMazGrSSTznpRlUae2ODJ057L0tR+A?=
 =?us-ascii?Q?o/8k48j1sCJXEE+aSxrdt5AOc9bXrRw1xhA6pOg9yYJZdfXKJt6ts2cjJpU4?=
 =?us-ascii?Q?lTajPERv4/OdRgkI9kqOuAQzGhg22owNL0mOlrOc1iaWQ+RJPKIN9C81C8/d?=
 =?us-ascii?Q?3FLLuhQlK/N9EdtGmO3X5plXIlXcMXZHf1GYxaKhz9gHJHyxQm9fVzyW818e?=
 =?us-ascii?Q?/b5tUp4RhczXGXFUyECLKj9fcbtDXKDcwc1PSzy0eLHPa6fchjar3SToeb8y?=
 =?us-ascii?Q?/orkyLH08W5SZh8No6JvjQKgvlIegxdETKtGdOjUL6YHnICc12HzNArz5pLU?=
 =?us-ascii?Q?/fzF4YqOtVReni/DncObWRvLKs0xrN9YesCC7wjxg7awJYsQZIAupmJTgyCW?=
 =?us-ascii?Q?Fhe0ENOfRGZTyiWGg0D0PqOB1fjcqBHBdS2aAsGlcgsqi6/6XH60qeJN+wz+?=
 =?us-ascii?Q?q/VVvGStw16lV4mVITpPZUgrYvfXU5TNRfT0WVYuhXoKavP6CBY1PA9brg0L?=
 =?us-ascii?Q?LVJ5MuVz/ic2uEuI/h0ut60QltjgNhE6+n8bp6AEa1mhXVysj4tUcujgPgwC?=
 =?us-ascii?Q?dxR8/QVGb5pv/WGvZfgt7PplzY30PDu3fFEdF4+q0wfxTZr62kZjWtEk/KYc?=
 =?us-ascii?Q?sY7AX3cbN3vLgOV7dsSx5oUXyUBjKC8/G6dyWe6Vpuavu57mZwhdeMA18PFv?=
 =?us-ascii?Q?ehe0BamGWrhJo68CtuumPancSu1+2mAqT/JASJcEwz76z5RY0mUF2GJrfjEt?=
 =?us-ascii?Q?tmQJRGGvdq8BIn8Zab4chOEL7tnzpMlyr9ZBVHHLMqaqNzCTdKNtrhEGlUuU?=
 =?us-ascii?Q?SCMeKV6rxTLbKjSR6yLfJ5xj/Q897F3ASw7V9DfHmo0B0Qa8cOs62EjnosrO?=
 =?us-ascii?Q?7mUyKA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0debe85d-43d0-4e7d-0b47-08d9c1973b5b
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:55:53.0930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWJeX+eK35xoxmtdWqrABBvmQMQE2bOpgEhbygjrR+56y9k/DXPXRDKYNfuZ9qZ7f2dbp+ZHL2eWxV2zSpPTG/Jjp/K4v0Don0WRPTUroGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
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

