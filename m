Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795354B7C2E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 02:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245352AbiBPBJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 20:09:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245455AbiBPBJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 20:09:41 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10111.outbound.protection.outlook.com [40.107.1.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619AFF956C;
        Tue, 15 Feb 2022 17:07:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kwvn0Rx7oGkhmusgnzDqlIZxj3yxb8NqtV/dQiXD+poBP1/FZz4pmrxwWFq42pH2JYgdSWxFhgPbjETQNsUI7gs4agjBmbgOZvkNRxs8+/0OILrjrymPKzkHqWnGqKNGYd+KSe01jgzOVUvDlUlQ2Mu2lnQiRBKVWV++pbw/b+fT9P6PDuykSlYPYehHyopGLZyloF7vU+zFVTXJcbHRNj0kWUXHVysAdTlSsi5ntRHQM81GHShWVh/lNEkyt/qw+86mj3D2YALgefcYdO21oTmlXbAN0u66TX2cGGP4RthPISX9nze87y38YfbDO/gE3A6ehYVl7Zhnm+mhN/yxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ftz9xdn1M/uesl1QFsDsPJPtnIrvpgjlMsjM6YnusxA=;
 b=CMW+RXEh8qSrNQaW+qU/siyykQ5SDh0W50Ah1EcfhHUXRvZIMLW0kosyaa2Qs0t0kmFlNtSzeXX20aA7U3YDjOhAMAtrWTM5JpU8qm0b+/qU3AeCv+xe5L0y+B6ahOQ2pnLR03uDDj52SANr+aFsvwOxkGH8aXSPoKPq3mXqQSGBTdjm490y0JlfIkmcHomH9vsupZlgyhoBGTaiLJt+xZNcToOKiyFKq8j4QKvuVGsy80hrXqpMh7guqX48HqXM807HS+3aT+fdHsRHgMj3nlL2tJs/P6oy4LudJwBGXB0ww7o1yvRx7ch3aVyY0CxG+icqAfoq/Ofasn1nda0+eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ftz9xdn1M/uesl1QFsDsPJPtnIrvpgjlMsjM6YnusxA=;
 b=CiCxFADaea6ptl7EryC6WlgUt2NhuGMg2d5vBu36dgA9sgGhs+3A5H/Ds3tT3yPziyFKVGlhLueAoxNQ/rJjmKUITEJhZqTEmrJYltQQUpb5+Sz3a6G9j/3gotw96pQ+0Pt4k35Gr8WAGFYv1Nu/cgBi5y+qCV3RzQv0hTZWt2g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1169.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:266::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 01:07:38 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::c93a:58e1:db16:e117%5]) with mapi id 15.20.4995.014; Wed, 16 Feb 2022
 01:07:38 +0000
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
Subject: [PATCH net-next 3/3] net: marvell: prestera: handle fib notifications
Date:   Wed, 16 Feb 2022 03:05:57 +0200
Message-Id: <20220216010557.11483-4-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
References: <20220216010557.11483-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0078.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::19) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b190159f-b38c-4019-a405-08d9f0e8b936
X-MS-TrafficTypeDiagnostic: AM9P190MB1169:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1169A3B4DFD85E0EAE227CEF93359@AM9P190MB1169.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3WRGHZ70t3O/0n5vXCNv4IeWMJNqfD9gM0v0qvRKk4VSV5XcoPvnO2fiFesylSkv/ns7gWpiw8qnK3G4NUC5BYnLi7Oy/pqGB79TOpzI9dwph29OXktLPiHotTX4JmMpagFJblhHFytCMSxExN3I5a9ebx8sJ+IU2+ZQQf/Yh+jMse6YcQBCGoSTVkyCNHX4jzF7f9IK6qRFZy4Pfu0R5x51suE7VvzmithLRmkdLALu+8yammHDVcklvC9gv9bVxOmRtKbG2okDLmrULMBa1M/EyXlZtxD1+dpcIj0gZzwPJoHF3EyfqhWnoKpe+V9i8a21hXNgBe5YEYbMWoBggfFyenYPXTimqfkEZifvJaEoYFoRtiKwm2thUfK64lK8MTfFwnadfKSl8uwRjPQxoEeTsoNjiZRvnCeUtEUhq92EtIZMfr8OVCaD8r+XOfGh3bHx5n4Zee+OAWP09+7ty2nifufxn5QjKjGjdC3I/Ympuz3PdFxP6SFd/ELum5qDo7KpqVpHMrNaWihDCN7ZNwuXVgSHO6+JErjIicPefK40IbyPk/Je2VxNa25NhU43NJlKvQ1GzXeblPUCbcS3hqWxlWYDsG/jHfGd8CIhjaaH+ULJc4540YFGhpzBYJ/nWEwLVnw54ZRQQwWunpB7utUGNRwBs7+EVYesAV/ogzNMESQ15K8itgUgCwd7WBNMYa3IPyfpAvZcxhGmTVjwWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(346002)(366004)(136003)(6666004)(5660300002)(44832011)(66574015)(36756003)(38350700002)(86362001)(52116002)(6506007)(8936002)(66556008)(66476007)(66946007)(38100700002)(30864003)(8676002)(54906003)(6916009)(316002)(4326008)(6486002)(508600001)(2616005)(2906002)(83380400001)(186003)(26005)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GQQzDwawQrAJLKQwl9A6wQhjr+WlLSwiyRL9p9maDpNDmpWUD3vp6cCkAL9x?=
 =?us-ascii?Q?+vpYNZOx7BclvZkyfKz4dNLoVR4WRJLUeQfkawY+3ZaRFrfqm+2jX71iAvNu?=
 =?us-ascii?Q?1QoZrKgdoWwNjyvg5MMLDgYL487UnvN5AEemZe0xo8gsctEN5i0P6EOI+12c?=
 =?us-ascii?Q?9qPjq1IFsNkuvx7l4XEDtQM5YMUYtfx+TlzkxLzNsOg+4shhCyXX+mqL/WH3?=
 =?us-ascii?Q?pSQiu+ZO8YQ+X14FO0wtfFWitbgvt7zPzmbq6Vzgj7ZnnXRmFiLx6LbKbnGk?=
 =?us-ascii?Q?yKyug0GrtktIit19emG/2QCSVUzK99pr+0j9XoJt14Xn+MCn+oKj/sOBWFE4?=
 =?us-ascii?Q?GKVahDQumGxtCboJI3oXhPkcCQpAFxQO6WyMdgncNLkQay/D+uD8F9XCF2cf?=
 =?us-ascii?Q?ZVNYYP10BSVMp8gFCbgBRUsj6yTtMQTbJzQa5aLgD0BofEMF+7L+wId5QcGV?=
 =?us-ascii?Q?6i58QPKSsh7bcX2DWAV7DK5mVFOXvt+tsQfjOmRBzmYN5iCqc5v65DVpHATx?=
 =?us-ascii?Q?ysDh4bCaC9n/VwGAI9xbtWR9jF04t8lvi+d5K03aAH1rdbAEHd3ALcs9R2WP?=
 =?us-ascii?Q?oSh/yh/zqsxbNUCeyFD+prEffYehKvyftMWDQiuxtCNrpvNmpXHVABh4P4Vm?=
 =?us-ascii?Q?mLgvk0FU29LeOQq6h8hNeum2Jpx2AOwRxTlAHUBpQGd0mLKeVzJDcGeY1a3W?=
 =?us-ascii?Q?y1mFFEi0WnJGVdDku5RXpMAD9zf83ebbFxxKNaL//yeCB9GGW3urYFsybLBU?=
 =?us-ascii?Q?JNcqS/+ZqqRIeHLRCJ2S1xOEfjKeSqiAVxKiTfaYXUPd085PhAL6L96J/t63?=
 =?us-ascii?Q?AZOIM+B/A877wwgB0uIzQlo/VkyQccPqFIIZaODArswplgNjcqsqQIStItmi?=
 =?us-ascii?Q?DzJKbb7N5Y7qROGWgczdc0v5FujdN+ZsxL6xrKHoHT0JlZRbuL/BCTn10ybm?=
 =?us-ascii?Q?4JOCao8pBM7N92MHQcfyU8ilTeeqiZLpGqJC0X3xsV3KSu1/iSwA2hdDHoz+?=
 =?us-ascii?Q?/zXP+JIEJ2dCbg1h8z9VGvLyN3DEh0Lr3/ya+1Y/lxq0+XCXc6sYgp3VRq/h?=
 =?us-ascii?Q?NDY2S79HT6qdS90+dL7ytj9Rkltlb1Ku20snASfZ34lIV8zOXs/V1wBQHvGM?=
 =?us-ascii?Q?VohATEiQ/ym4Kflm49m+X3KKHWbvAGJtBVjkkE5OZmH8pNtIta5OUfxl/v4h?=
 =?us-ascii?Q?NoPJbzHVX6UUFxn+hm24owgATSFtFPsFwUKZnUV85Btqy3go2/LJrxT2QRc5?=
 =?us-ascii?Q?UY1G0M7o8xbNmc8504H3wcRBQQx9S7nI/gdEfvMFnKbi727CZ7WLaZe7dg3p?=
 =?us-ascii?Q?2ZCPOFQ0ycmc8Oayh6QxgEBbJ+7IJYmzLDyTUYVox6EaeoJLL8vMuTgnMdXV?=
 =?us-ascii?Q?7n+7r733iL3JtfPXgVTtiy4c3CD1eiP8EY3wuLWu382qEqHflyHCQIRcVnCF?=
 =?us-ascii?Q?wMFxjM6YKzUxmROu7Y0mneSuBxCsJ1VWdH7CiQFwG/Ppt8V0mdJqsq+/tilN?=
 =?us-ascii?Q?l6CsD5tWOUjaR3ABjeBM+Hy25ee7sPUwodfxUiBzg6lKqtZbGmxexGRioucV?=
 =?us-ascii?Q?JQRTK00IuOj07SZQpN+Ize6wCMKFDzZjppLPuIOspJz/QqJd7BNKINNVPha1?=
 =?us-ascii?Q?XvckiJiYgsD03hpnK7U06wXVQwXMyLLP5gAzE8ONgoG0UGMkYpZXl/uOJYYY?=
 =?us-ascii?Q?MxISDTzDcp+IExCafHJgpCOMnXI=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b190159f-b38c-4019-a405-08d9f0e8b936
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 01:07:38.1487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1f2jZs7LWC+X1YlhL7TdFTZT4FwVjUvsRQkvOuY89AtTVRi74lUtxGvLcFIReV/ujUmnwptyVZEFovdJMo64+eFfuyBcELZsckzSiyTTsfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1169
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For now we support only TRAP or DROP, so we can offload only "local" or
"blackhole" routes.
Nexthop routes is TRAP for now. Will be implemented soon.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   4 +
 .../ethernet/marvell/prestera/prestera_main.c |  11 +
 .../marvell/prestera/prestera_router.c        | 412 ++++++++++++++++++
 3 files changed, 427 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index dcaddf685d21..6f754ae2a584 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -282,8 +282,10 @@ struct prestera_router {
 	struct list_head vr_list;
 	struct list_head rif_entry_list;
 	struct rhashtable fib_ht;
+	struct rhashtable kern_fib_cache_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
+	struct notifier_block fib_nb;
 };
 
 struct prestera_rxtx_params {
@@ -326,6 +328,8 @@ int prestera_port_cfg_mac_write(struct prestera_port *port,
 
 struct prestera_port *prestera_port_dev_lower_find(struct net_device *dev);
 
+void prestera_queue_work(struct work_struct *work);
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index cad93f747d0c..a180b6812e54 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -28,6 +28,12 @@
 #define PRESTERA_MAC_ADDR_NUM_MAX	255
 
 static struct workqueue_struct *prestera_wq;
+static struct workqueue_struct *prestera_owq;
+
+void prestera_queue_work(struct work_struct *work)
+{
+	queue_work(prestera_owq, work);
+}
 
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
@@ -1024,12 +1030,17 @@ static int __init prestera_module_init(void)
 	if (!prestera_wq)
 		return -ENOMEM;
 
+	prestera_owq = alloc_ordered_workqueue("prestera_ordered", 0);
+	if (!prestera_owq)
+		return -ENOMEM;
+
 	return 0;
 }
 
 static void __exit prestera_module_exit(void)
 {
 	destroy_workqueue(prestera_wq);
+	destroy_workqueue(prestera_owq);
 }
 
 module_init(prestera_module_init);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 6ef4d32b8fdd..54ebda61bfea 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -5,10 +5,39 @@
 #include <linux/types.h>
 #include <linux/inetdevice.h>
 #include <net/switchdev.h>
+#include <linux/rhashtable.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+struct prestera_kern_fib_cache_key {
+	struct prestera_ip_addr addr;
+	u32 prefix_len;
+	u32 kern_tb_id; /* tb_id from kernel (not fixed) */
+};
+
+/* Subscribing on neighbours in kernel */
+struct prestera_kern_fib_cache {
+	struct prestera_kern_fib_cache_key key;
+	struct {
+		struct prestera_fib_key fib_key;
+		enum prestera_fib_type fib_type;
+	} lpm_info; /* hold prepared lpm info */
+	/* Indicate if route is not overlapped by another table */
+	struct rhash_head ht_node; /* node of prestera_router */
+	struct fib_info *fi;
+	u8 kern_tos;
+	u8 kern_type;
+	bool reachable;
+};
+
+static const struct rhashtable_params __prestera_kern_fib_cache_ht_params = {
+	.key_offset  = offsetof(struct prestera_kern_fib_cache, key),
+	.head_offset = offsetof(struct prestera_kern_fib_cache, ht_node),
+	.key_len     = sizeof(struct prestera_kern_fib_cache_key),
+	.automatic_shrinking = true,
+};
+
 /* This util to be used, to convert kernel rules for default vr in hw_vr */
 static u32 prestera_fix_tb_id(u32 tb_id)
 {
@@ -20,6 +49,290 @@ static u32 prestera_fix_tb_id(u32 tb_id)
 	return tb_id;
 }
 
+static void
+prestera_util_fen_info2fib_cache_key(struct fib_entry_notifier_info *fen_info,
+				     struct prestera_kern_fib_cache_key *key)
+{
+	memset(key, 0, sizeof(*key));
+	key->addr.u.ipv4 = cpu_to_be32(fen_info->dst);
+	key->prefix_len = fen_info->dst_len;
+	key->kern_tb_id = fen_info->tb_id;
+}
+
+static struct prestera_kern_fib_cache *
+prestera_kern_fib_cache_find(struct prestera_switch *sw,
+			     struct prestera_kern_fib_cache_key *key)
+{
+	struct prestera_kern_fib_cache *fib_cache;
+
+	fib_cache =
+	 rhashtable_lookup_fast(&sw->router->kern_fib_cache_ht, key,
+				__prestera_kern_fib_cache_ht_params);
+	return IS_ERR(fib_cache) ? NULL : fib_cache;
+}
+
+static void
+prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
+				struct prestera_kern_fib_cache *fib_cache)
+{
+	fib_info_put(fib_cache->fi);
+	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
+			       &fib_cache->ht_node,
+			       __prestera_kern_fib_cache_ht_params);
+	kfree(fib_cache);
+}
+
+/* Operations on fi (offload, etc) must be wrapped in utils.
+ * This function just create storage.
+ */
+static struct prestera_kern_fib_cache *
+prestera_kern_fib_cache_create(struct prestera_switch *sw,
+			       struct prestera_kern_fib_cache_key *key,
+			       struct fib_info *fi, u8 tos, u8 type)
+{
+	struct prestera_kern_fib_cache *fib_cache;
+	int err;
+
+	fib_cache = kzalloc(sizeof(*fib_cache), GFP_KERNEL);
+	if (!fib_cache)
+		goto err_kzalloc;
+
+	memcpy(&fib_cache->key, key, sizeof(*key));
+	fib_info_hold(fi);
+	fib_cache->fi = fi;
+	fib_cache->kern_tos = tos;
+	fib_cache->kern_type = type;
+
+	err = rhashtable_insert_fast(&sw->router->kern_fib_cache_ht,
+				     &fib_cache->ht_node,
+				     __prestera_kern_fib_cache_ht_params);
+	if (err)
+		goto err_ht_insert;
+
+	return fib_cache;
+
+err_ht_insert:
+	fib_info_put(fi);
+	kfree(fib_cache);
+err_kzalloc:
+	return NULL;
+}
+
+static void
+__prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
+				     struct prestera_kern_fib_cache *fc,
+				     bool fail, bool offload, bool trap)
+{
+	struct fib_rt_info fri;
+
+	if (fc->key.addr.v != PRESTERA_IPV4)
+		return;
+
+	fri.fi = fc->fi;
+	fri.tb_id = fc->key.kern_tb_id;
+	fri.dst = fc->key.addr.u.ipv4;
+	fri.dst_len = fc->key.prefix_len;
+	fri.tos = fc->kern_tos;
+	fri.type = fc->kern_type;
+	/* flags begin */
+	fri.offload = offload;
+	fri.trap = trap;
+	fri.offload_failed = fail;
+	/* flags end */
+	fib_alias_hw_flags_set(&init_net, &fri);
+}
+
+static int
+__prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
+				     struct prestera_kern_fib_cache *fc)
+{
+	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
+
+	switch (fc->fi->fib_type) {
+	case RTN_UNICAST:
+		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
+		break;
+	/* Unsupported. Leave it for kernel: */
+	case RTN_BROADCAST:
+	case RTN_MULTICAST:
+	/* Routes we must trap by design: */
+	case RTN_LOCAL:
+	case RTN_UNREACHABLE:
+	case RTN_PROHIBIT:
+		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
+		break;
+	case RTN_BLACKHOLE:
+		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_DROP;
+		break;
+	default:
+		dev_err(sw->dev->dev, "Unsupported fib_type");
+		return -EOPNOTSUPP;
+	}
+
+	fc->lpm_info.fib_key.addr = fc->key.addr;
+	fc->lpm_info.fib_key.prefix_len = fc->key.prefix_len;
+	fc->lpm_info.fib_key.tb_id = prestera_fix_tb_id(fc->key.kern_tb_id);
+
+	return 0;
+}
+
+static int __prestera_k_arb_f_lpm_set(struct prestera_switch *sw,
+				      struct prestera_kern_fib_cache *fc,
+				      bool enabled)
+{
+	struct prestera_fib_node *fib_node;
+
+	fib_node = prestera_fib_node_find(sw, &fc->lpm_info.fib_key);
+	if (fib_node)
+		prestera_fib_node_destroy(sw, fib_node);
+
+	if (!enabled)
+		return 0;
+
+	fib_node = prestera_fib_node_create(sw, &fc->lpm_info.fib_key,
+					    fc->lpm_info.fib_type);
+
+	if (!fib_node) {
+		dev_err(sw->dev->dev, "fib_node=NULL %pI4n/%d kern_tb_id = %d",
+			&fc->key.addr.u.ipv4, fc->key.prefix_len,
+			fc->key.kern_tb_id);
+		return -ENOENT;
+	}
+
+	return 0;
+}
+
+static int __prestera_k_arb_fc_apply(struct prestera_switch *sw,
+				     struct prestera_kern_fib_cache *fc)
+{
+	int err;
+
+	err = __prestera_pr_k_arb_fc_lpm_info_calc(sw, fc);
+	if (err)
+		return err;
+
+	err = __prestera_k_arb_f_lpm_set(sw, fc, fc->reachable);
+	if (err) {
+		__prestera_k_arb_fib_lpm_offload_set(sw, fc,
+						     true, false, false);
+		return err;
+	}
+
+	switch (fc->lpm_info.fib_type) {
+	case PRESTERA_FIB_TYPE_TRAP:
+		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
+						     false, fc->reachable);
+		break;
+	case PRESTERA_FIB_TYPE_DROP:
+		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false, true,
+						     fc->reachable);
+		break;
+	case PRESTERA_FIB_TYPE_INVALID:
+		break;
+	}
+
+	return 0;
+}
+
+static struct prestera_kern_fib_cache *
+__prestera_k_arb_util_fib_overlaps(struct prestera_switch *sw,
+				   struct prestera_kern_fib_cache *fc)
+{
+	struct prestera_kern_fib_cache_key fc_key;
+	struct prestera_kern_fib_cache *rfc;
+
+	/* TODO: parse kernel rules */
+	rfc = NULL;
+	if (fc->key.kern_tb_id == RT_TABLE_LOCAL) {
+		memcpy(&fc_key, &fc->key, sizeof(fc_key));
+		fc_key.kern_tb_id = RT_TABLE_MAIN;
+		rfc = prestera_kern_fib_cache_find(sw, &fc_key);
+	}
+
+	return rfc;
+}
+
+static struct prestera_kern_fib_cache *
+__prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
+				     struct prestera_kern_fib_cache *fc)
+{
+	struct prestera_kern_fib_cache_key fc_key;
+	struct prestera_kern_fib_cache *rfc;
+
+	/* TODO: parse kernel rules */
+	rfc = NULL;
+	if (fc->key.kern_tb_id == RT_TABLE_MAIN) {
+		memcpy(&fc_key, &fc->key, sizeof(fc_key));
+		fc_key.kern_tb_id = RT_TABLE_LOCAL;
+		rfc = prestera_kern_fib_cache_find(sw, &fc_key);
+	}
+
+	return rfc;
+}
+
+static int
+prestera_k_arb_fib_evt(struct prestera_switch *sw,
+		       bool replace, /* replace or del */
+		       struct fib_entry_notifier_info *fen_info)
+{
+	struct prestera_kern_fib_cache *tfib_cache, *bfib_cache; /* top/btm */
+	struct prestera_kern_fib_cache_key fc_key;
+	struct prestera_kern_fib_cache *fib_cache;
+	int err;
+
+	prestera_util_fen_info2fib_cache_key(fen_info, &fc_key);
+	fib_cache = prestera_kern_fib_cache_find(sw, &fc_key);
+	if (fib_cache) {
+		fib_cache->reachable = false;
+		err = __prestera_k_arb_fc_apply(sw, fib_cache);
+		if (err)
+			dev_err(sw->dev->dev,
+				"Applying destroyed fib_cache failed");
+
+		bfib_cache = __prestera_k_arb_util_fib_overlaps(sw, fib_cache);
+		tfib_cache = __prestera_k_arb_util_fib_overlapped(sw, fib_cache);
+		if (!tfib_cache && bfib_cache) {
+			bfib_cache->reachable = true;
+			err = __prestera_k_arb_fc_apply(sw, bfib_cache);
+			if (err)
+				dev_err(sw->dev->dev,
+					"Applying fib_cache btm failed");
+		}
+
+		prestera_kern_fib_cache_destroy(sw, fib_cache);
+	}
+
+	if (replace) {
+		fib_cache = prestera_kern_fib_cache_create(sw, &fc_key,
+							   fen_info->fi,
+							   fen_info->tos,
+							   fen_info->type);
+		if (!fib_cache) {
+			dev_err(sw->dev->dev, "fib_cache == NULL");
+			return -ENOENT;
+		}
+
+		bfib_cache = __prestera_k_arb_util_fib_overlaps(sw, fib_cache);
+		tfib_cache = __prestera_k_arb_util_fib_overlapped(sw, fib_cache);
+		if (!tfib_cache)
+			fib_cache->reachable = true;
+
+		if (bfib_cache) {
+			bfib_cache->reachable = false;
+			err = __prestera_k_arb_fc_apply(sw, bfib_cache);
+			if (err)
+				dev_err(sw->dev->dev,
+					"Applying fib_cache btm failed");
+		}
+
+		err = __prestera_k_arb_fc_apply(sw, fib_cache);
+		if (err)
+			dev_err(sw->dev->dev, "Applying fib_cache failed");
+	}
+
+	return 0;
+}
+
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
 					  unsigned long event,
 					  struct netlink_ext_ack *extack)
@@ -137,6 +450,89 @@ static int __prestera_inetaddr_valid_cb(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+struct prestera_fib_event_work {
+	struct work_struct work;
+	struct prestera_switch *sw;
+	struct fib_entry_notifier_info fen_info;
+	unsigned long event;
+};
+
+static void __prestera_router_fib_event_work(struct work_struct *work)
+{
+	struct prestera_fib_event_work *fib_work =
+			container_of(work, struct prestera_fib_event_work, work);
+	struct prestera_switch *sw = fib_work->sw;
+	int err;
+
+	rtnl_lock();
+
+	switch (fib_work->event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+		err = prestera_k_arb_fib_evt(sw, true, &fib_work->fen_info);
+		if (err)
+			goto err_out;
+
+		break;
+	case FIB_EVENT_ENTRY_DEL:
+		err = prestera_k_arb_fib_evt(sw, false, &fib_work->fen_info);
+		if (err)
+			goto err_out;
+
+		break;
+	}
+
+	goto out;
+
+err_out:
+	dev_err(sw->dev->dev, "Error when processing %pI4h/%d",
+		&fib_work->fen_info.dst,
+		fib_work->fen_info.dst_len);
+out:
+	fib_info_put(fib_work->fen_info.fi);
+	rtnl_unlock();
+	kfree(fib_work);
+}
+
+/* Called with rcu_read_lock() */
+static int __prestera_router_fib_event(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	struct prestera_fib_event_work *fib_work;
+	struct fib_entry_notifier_info *fen_info;
+	struct fib_notifier_info *info = ptr;
+	struct prestera_router *router;
+
+	if (info->family != AF_INET)
+		return NOTIFY_DONE;
+
+	router = container_of(nb, struct prestera_router, fib_nb);
+
+	switch (event) {
+	case FIB_EVENT_ENTRY_REPLACE:
+	case FIB_EVENT_ENTRY_DEL:
+		fen_info = container_of(info, struct fib_entry_notifier_info,
+					info);
+		if (!fen_info->fi)
+			return NOTIFY_DONE;
+
+		fib_work = kzalloc(sizeof(*fib_work), GFP_ATOMIC);
+		if (WARN_ON(!fib_work))
+			return NOTIFY_BAD;
+
+		fib_info_hold(fen_info->fi);
+		fib_work->fen_info = *fen_info;
+		fib_work->event = event;
+		fib_work->sw = router->sw;
+		INIT_WORK(&fib_work->work, __prestera_router_fib_event_work);
+		prestera_queue_work(&fib_work->work);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_DONE;
+}
+
 int prestera_router_init(struct prestera_switch *sw)
 {
 	struct prestera_router *router;
@@ -153,6 +549,11 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_router_lib_init;
 
+	err = rhashtable_init(&router->kern_fib_cache_ht,
+			      &__prestera_kern_fib_cache_ht_params);
+	if (err)
+		goto err_kern_fib_cache_ht_init;
+
 	router->inetaddr_valid_nb.notifier_call = __prestera_inetaddr_valid_cb;
 	err = register_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 	if (err)
@@ -163,11 +564,21 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_register_inetaddr_notifier;
 
+	router->fib_nb.notifier_call = __prestera_router_fib_event;
+	err = register_fib_notifier(&init_net, &router->fib_nb,
+				    /* TODO: flush fib entries */ NULL, NULL);
+	if (err)
+		goto err_register_fib_notifier;
+
 	return 0;
 
+err_register_fib_notifier:
+	unregister_inetaddr_notifier(&router->inetaddr_nb);
 err_register_inetaddr_notifier:
 	unregister_inetaddr_validator_notifier(&router->inetaddr_valid_nb);
 err_register_inetaddr_validator_notifier:
+	rhashtable_destroy(&router->kern_fib_cache_ht);
+err_kern_fib_cache_ht_init:
 	prestera_router_hw_fini(sw);
 err_router_lib_init:
 	kfree(sw->router);
@@ -178,6 +589,7 @@ void prestera_router_fini(struct prestera_switch *sw)
 {
 	unregister_inetaddr_notifier(&sw->router->inetaddr_nb);
 	unregister_inetaddr_validator_notifier(&sw->router->inetaddr_valid_nb);
+	rhashtable_destroy(&sw->router->kern_fib_cache_ht);
 	prestera_router_hw_fini(sw);
 	kfree(sw->router);
 	sw->router = NULL;
-- 
2.17.1

