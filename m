Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABAE5F1B70
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 11:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJAJg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 05:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJAJgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 05:36:20 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60127.outbound.protection.outlook.com [40.107.6.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6162B628;
        Sat,  1 Oct 2022 02:35:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8ONU/VOZcDaHY/nqIWswd8/ehm998UObHyy6tgn3ZItoOywE0rT1T/5WgtHCEwBsicCpjMXh1SQoleyTGiuPTtEKXh2Rzm3ZPQFnJBSfkTzMI2fGrqjLy54K3ybNVcoatF4iDI2m+MwSiXdf2i2TEQDG962ywTbBx44Ru9jnOXUtKEMa4Y0fW/PCadONjC02PyPn0i5LB2JkLBAiBRTc02AWNSUlD3YMminpwdBGiqf5XslfCaIGMQRJR2VWq+TO/rHb0JuRl7ZV9OIQMvPMzD8CqxUjdnyQ2JbIs9zAFv5jm5fL2Pq3G6L/RmKBBoeevmmgXGQKJv9SPInp9RGbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Wkg9eRaMG+wABUSfDhVwFUTz9DJjp4BT1+QMhlShHE=;
 b=AS5ZigXYxTxkzOXCAQj0KTKAYhNC5NHP+d9IBDhsXm6QwawZLPNFvuAvAm1YZUE7CS+RlfhE9eQ1epXuG8efAogyUuOKpw1d717Sy3MU4GV7N/C3qtK/0qJcDHptlPlk77ss/XzawpZpioy+OH3O7+SoErMkb8Mvoa7KGNZpkZSyhdxQYV1Yc6PTAvcYajjZ7y7GfUWEvEJv08jXvqRjkktPrd31fHJY95bzMkK3mUu1pk9h/aqHO9T4OixLwjeJ8xmJpfb4xN3vhBD/vpuSezMEkDF1/6Qd+oak+MwF1/SUJhjoaPQVPCdQQeAdhynrvbW/MVEkktG7aNEvoi5OhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Wkg9eRaMG+wABUSfDhVwFUTz9DJjp4BT1+QMhlShHE=;
 b=rMV/d34ULXin+It7e8fmp8Pof++PIacZpHl/SmKXl+YeAV/0aMT81EJ/9P6n6RkYLTzu8TOdUuQ6pZUC0ANIE+5EhoencPkx4Q7ddcI/ZiB4HaFQ0EXZrmhnuY4yMiFBONfZQUXJVn+G8e8jGqdMoY5svI4sFuphfx7+kWIypI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by VI1P190MB0733.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:34:36 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::8ee:1a5c:9187:3bc0%2]) with mapi id 15.20.5676.024; Sat, 1 Oct 2022
 09:34:36 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH net-next v7 8/9] net: marvell: prestera: Add neighbour cache accounting
Date:   Sat,  1 Oct 2022 12:34:16 +0300
Message-Id: <20221001093417.22388-9-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
References: <20221001093417.22388-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0696.eurprd06.prod.outlook.com
 (2603:10a6:20b:49f::13) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP190MB1789:EE_|VI1P190MB0733:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc1fce2-3f3e-4685-049c-08daa39027eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIhnVz/xaF3vm65WMB+XB+3VOlOW40BJopKV5LRbmuM+frCR5jLiiU6udCshoNid0L+czH+hC2AU4/I/8JxmooGxhSrjqGXhezqLLf716ERsddSaexgG/Irr78Hh4ej1tTgPuJq8F0n4i4ZcPOynA7coTJVs6gsOTw1EaOU3E+oTIVTzsIBsjbQmd8Dp93sdANxsg6vIWcZTWpExrBdKCrspEXmNTK2Go/pN/qwxGfWaNdzQevheTXhWGfbqjDIz7LgjEt1sv9HmaAPbqB+YRgwD7WrXgYS35kZt4D2amgrPOfvNvWJ65eO/hue2Xv44E0pXGVWHTuSLRQyDiA2YH4gA0i43uDI9WP6B+8LRouGUkaYtbIaGDdSG7PDLCRUuUOUGoPUcBnlf3bieXWBczLAF6PUjrylCKgTy+f7384LAdvU322U292L/aPp7/E/LMSWj1+Yc3QTs/XhiVLg4C/WfOcQwXzRH8RmzvXtUwiXLGc04Wv+k0nW3TOlaMDa8VHnh/QjI3BewPdpZKHkxeuo+u8m2hQkDLz41YGWv2wVp464WQbYgIDdhmiOLMWAQqBtqctn+4r4CO31pNneUnyPzSkN12i7bK+FIiWvhVaBA6aSPnZpbjAw8syJte3Cm1OLt2P/Sq3OuPoEsejmDkamhXrmqH4gqVULnRo/f8dU9AXkcW1NKFK8LUeU5jCLEqbZycsaS6bhgr8jL0FEPxZxjJJJX0J40sQX3ogGkVPyxJ/iJEU8PkdhpkvJeXrBZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39830400003)(366004)(346002)(136003)(451199015)(66574015)(38350700002)(38100700002)(5660300002)(86362001)(26005)(7416002)(15650500001)(8936002)(6506007)(6512007)(36756003)(8676002)(52116002)(4326008)(66946007)(66476007)(66556008)(6666004)(83380400001)(107886003)(30864003)(41300700001)(44832011)(1076003)(186003)(6916009)(2616005)(2906002)(478600001)(316002)(6486002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tw2y2m9FKydlo7ZtbNJQgNCsHA4SY+57hoAEvU07MrB+PeB7KtY6rjlWqS8L?=
 =?us-ascii?Q?rA3S+1j8zx91UlawoiTfkJ80KN4rLICPLc1PUiJT+G+H9VE07Rk+mqr9e4hF?=
 =?us-ascii?Q?/iSX4O549BJyvnLmTc55BAwhJPetAxNRddRmJl9QdH7aYyP7fJfqJi7+Ax9T?=
 =?us-ascii?Q?DuYFxOhfVwdUq0niqahiNj2pwlpqUS/wuYwo5Fw2zsmM8zAmJAohuQv29lle?=
 =?us-ascii?Q?tt2XOvOwieBGOcOW8z4kEdEmHer6YDu5/Yms6Um1XBeIrWqm11tCViiw0cf1?=
 =?us-ascii?Q?ucmnjVXVgk3J0LFh/5P9rSjEy2zUnoN7vX5YSseZI5oyt+XPYuNjPgpo0Pse?=
 =?us-ascii?Q?pAHncx+cVEKj7oQpf/Z/zkstZiJAnaEQiiSfKQ0WIDLkD3B5mxN14EnhH4bz?=
 =?us-ascii?Q?Kixf7wy45tNiqzOUJtgw9HTsRem3ho4/PtOYa6JhALEr2C9agRrbMaoRZC3S?=
 =?us-ascii?Q?tF1ZBn9jDDzqOb05NAZ1xCoe1ItV30nRH8iP//5xGv2y1bOw7uLACeXJy3W1?=
 =?us-ascii?Q?KYdiHbZyVf42WVX/U7auqXp+wi72Kt51NVdu2O8nFi6om6ggIMiBcZ4cSwJV?=
 =?us-ascii?Q?l8R7a/b3kqvmFzfT4E9ktD6gmkeV3VmuiNouT0SXdHxw6RR2ZNV83lk3rbXM?=
 =?us-ascii?Q?9kfv/TJyjegqZqIyAlYw9nmepLgsGDmT+0CXdaMV/gNx2nUICnXBkAQj9WB4?=
 =?us-ascii?Q?P0VJR6Y/4k5vYt0G9b/hW6H8ooROe2t8N0/vaw7YlsUwz+XUabl7Q0npy0j4?=
 =?us-ascii?Q?uyRwQ9EuUJJjel3NC/yKcwwM6N6aGkX+1Itrhcol0mKPaSgjCyJKdqWPsHP+?=
 =?us-ascii?Q?wSg/TLl+069tDJC7XXD9g+ZekUJ5OownrFdtqFzMQUcqszyI9DdgUQqiapIZ?=
 =?us-ascii?Q?+HVXRFVfpRfkSKJ+6Rgrv1UUWBAC5tlan6WPV8dRGB8jpNYNfblGGe3EycPI?=
 =?us-ascii?Q?DxE5s9Wl3VwaDUji9iYfYOCCkByuJoWOduoIL5ZeC0ep1xaiznID1WmMxQZN?=
 =?us-ascii?Q?9uIgUbuvWutghaLSEKq3RnRwQIV7RCTLIIZTzZrpZ3IpYph6nQUh47Krthms?=
 =?us-ascii?Q?vS3pjJ0yFAUkbujfCunffgh/5vxS/MVJNBX4E3PTqbusg9UDVxvAe5y6iWcy?=
 =?us-ascii?Q?jLQDnf4el52/i6M2R37fr7Ocfu34F/axCQ19APjmpwGO1PMpWA64j2poUyRC?=
 =?us-ascii?Q?csGSsdziNJZpCTPHSuUG7WnjgDj3ArnnBqKEHi82VibZgS7cnohd4L0xWdnI?=
 =?us-ascii?Q?XI7ircFgdV6GCDmeFb6E6+ZT/FMCQbkbN9GLVv+h0VsyyOirqL6AUkso+65x?=
 =?us-ascii?Q?4u9v9ZOMVQ2PWCZQCTgJtpEBUMBlmCV3JJbZ/HsdaBa540gRkzxOBW4oI1Z3?=
 =?us-ascii?Q?t6IXsEAZmDBAHojXBD2KovkPmaKk1GT/2qu6v1UbxqvfhBK8nVKy+yspvdv7?=
 =?us-ascii?Q?nBXf+9yP4jhYSpDbf6O2LbfVs+wNAiVusCapqSDJGkxVzXUH8pM1swngKkEt?=
 =?us-ascii?Q?tpb9b6OHXHRZBABGf0w+zG7GCcewToLHy7izDD5Inc9TPezDnkrEmfBCiHUj?=
 =?us-ascii?Q?0duNEFYA/E7ZJ9SFjWtY1P0ncR8UJ//ZC7QFxgcQH0ffYLYdzjMJwe0rMw0l?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc1fce2-3f3e-4685-049c-08daa39027eb
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:34:36.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffrl01gHQVp7va9UUcc9DtGoZTICW8fsB3lEC39ayKahAx8sVUpWINi4x82GHMrAyJFH/G9zel5sasx+X1R8+hzPYiGJF6O1J0W5jCj/8Yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move forward and use new PRESTERA_FIB_TYPE_UC_NH to provide basic
nexthop routes support.
Provide deinitialization sequence for all created router objects.

Limitations:
- Only "local" and "main" tables supported
- Only generic interfaces supported for router (no bridges or vlans)

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../net/ethernet/marvell/prestera/prestera.h  |   1 +
 .../marvell/prestera/prestera_router.c        | 799 +++++++++++++++++-
 2 files changed, 797 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2f2f80e7e358..540a36069b79 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -316,6 +316,7 @@ struct prestera_router {
 	struct rhashtable nh_neigh_ht;
 	struct rhashtable nexthop_group_ht;
 	struct rhashtable fib_ht;
+	struct rhashtable kern_neigh_cache_ht;
 	struct rhashtable kern_fib_cache_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index d31dd1fe6633..af7d24390d2e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router.c
@@ -8,11 +8,30 @@
 #include <net/switchdev.h>
 #include <linux/rhashtable.h>
 #include <net/nexthop.h>
+#include <net/arp.h>
+#include <linux/if_vlan.h>
+#include <linux/if_macvlan.h>
 #include <net/netevent.h>
 
 #include "prestera.h"
 #include "prestera_router_hw.h"
 
+struct prestera_kern_neigh_cache_key {
+	struct prestera_ip_addr addr;
+	struct net_device *dev;
+};
+
+struct prestera_kern_neigh_cache {
+	struct prestera_kern_neigh_cache_key key;
+	struct rhash_head ht_node;
+	struct list_head kern_fib_cache_list;
+	/* Hold prepared nh_neigh info if is in_kernel */
+	struct prestera_neigh_info nh_neigh_info;
+	/* Indicate if neighbour is reachable by direct route */
+	bool reachable;
+	/* Lock cache if neigh is present in kernel */
+	bool in_kernel;
+};
 struct prestera_kern_fib_cache_key {
 	struct prestera_ip_addr addr;
 	u32 prefix_len;
@@ -25,9 +44,15 @@ struct prestera_kern_fib_cache {
 	struct {
 		struct prestera_fib_key fib_key;
 		enum prestera_fib_type fib_type;
+		struct prestera_nexthop_group_key nh_grp_key;
 	} lpm_info; /* hold prepared lpm info */
 	/* Indicate if route is not overlapped by another table */
 	struct rhash_head ht_node; /* node of prestera_router */
+	struct prestera_kern_neigh_cache_head {
+		struct prestera_kern_fib_cache *this;
+		struct list_head head;
+		struct prestera_kern_neigh_cache *n_cache;
+	} kern_neigh_cache_head[PRESTERA_NHGR_SIZE_MAX];
 	union {
 		struct fib_notifier_info info; /* point to any of 4/6 */
 		struct fib_entry_notifier_info fen4_info;
@@ -35,6 +60,13 @@ struct prestera_kern_fib_cache {
 	bool reachable;
 };
 
+static const struct rhashtable_params __prestera_kern_neigh_cache_ht_params = {
+	.key_offset  = offsetof(struct prestera_kern_neigh_cache, key),
+	.head_offset = offsetof(struct prestera_kern_neigh_cache, ht_node),
+	.key_len     = sizeof(struct prestera_kern_neigh_cache_key),
+	.automatic_shrinking = true,
+};
+
 static const struct rhashtable_params __prestera_kern_fib_cache_ht_params = {
 	.key_offset  = offsetof(struct prestera_kern_fib_cache, key),
 	.head_offset = offsetof(struct prestera_kern_fib_cache, ht_node),
@@ -67,6 +99,268 @@ prestera_util_fen_info2fib_cache_key(struct fib_notifier_info *info,
 	key->kern_tb_id = fen_info->tb_id;
 }
 
+static int prestera_util_nhc2nc_key(struct prestera_switch *sw,
+				    struct fib_nh_common *nhc,
+				    struct prestera_kern_neigh_cache_key *nk)
+{
+	memset(nk, 0, sizeof(*nk));
+	if (nhc->nhc_gw_family == AF_INET) {
+		nk->addr.v = PRESTERA_IPV4;
+		nk->addr.u.ipv4 = nhc->nhc_gw.ipv4;
+	} else {
+		nk->addr.v = PRESTERA_IPV6;
+		nk->addr.u.ipv6 = nhc->nhc_gw.ipv6;
+	}
+
+	nk->dev = nhc->nhc_dev;
+	return 0;
+}
+
+static void
+prestera_util_nc_key2nh_key(struct prestera_kern_neigh_cache_key *ck,
+			    struct prestera_nh_neigh_key *nk)
+{
+	memset(nk, 0, sizeof(*nk));
+	nk->addr = ck->addr;
+	nk->rif = (void *)ck->dev;
+}
+
+static bool
+prestera_util_nhc_eq_n_cache_key(struct prestera_switch *sw,
+				 struct fib_nh_common *nhc,
+				 struct prestera_kern_neigh_cache_key *nk)
+{
+	struct prestera_kern_neigh_cache_key tk;
+	int err;
+
+	err = prestera_util_nhc2nc_key(sw, nhc, &tk);
+	if (err)
+		return false;
+
+	if (memcmp(&tk, nk, sizeof(tk)))
+		return false;
+
+	return true;
+}
+
+static int
+prestera_util_neigh2nc_key(struct prestera_switch *sw, struct neighbour *n,
+			   struct prestera_kern_neigh_cache_key *key)
+{
+	memset(key, 0, sizeof(*key));
+	if (n->tbl->family == AF_INET) {
+		key->addr.v = PRESTERA_IPV4;
+		key->addr.u.ipv4 = *(__be32 *)n->primary_key;
+	} else {
+		return -ENOENT;
+	}
+
+	key->dev = n->dev;
+
+	return 0;
+}
+
+static bool __prestera_fi_is_direct(struct fib_info *fi)
+{
+	struct fib_nh *fib_nh;
+
+	if (fib_info_num_path(fi) == 1) {
+		fib_nh = fib_info_nh(fi, 0);
+		if (fib_nh->fib_nh_gw_family == AF_UNSPEC)
+			return true;
+	}
+
+	return false;
+}
+
+static bool prestera_fi_is_direct(struct fib_info *fi)
+{
+	if (fi->fib_type != RTN_UNICAST)
+		return false;
+
+	return __prestera_fi_is_direct(fi);
+}
+
+static bool prestera_fi_is_nh(struct fib_info *fi)
+{
+	if (fi->fib_type != RTN_UNICAST)
+		return false;
+
+	return !__prestera_fi_is_direct(fi);
+}
+
+static bool __prestera_fi6_is_direct(struct fib6_info *fi)
+{
+	if (!fi->fib6_nh->nh_common.nhc_gw_family)
+		return true;
+
+	return false;
+}
+
+static bool prestera_fi6_is_direct(struct fib6_info *fi)
+{
+	if (fi->fib6_type != RTN_UNICAST)
+		return false;
+
+	return __prestera_fi6_is_direct(fi);
+}
+
+static bool prestera_fi6_is_nh(struct fib6_info *fi)
+{
+	if (fi->fib6_type != RTN_UNICAST)
+		return false;
+
+	return !__prestera_fi6_is_direct(fi);
+}
+
+static bool prestera_fib_info_is_direct(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		return prestera_fi_is_direct(fen_info->fi);
+	else
+		return prestera_fi6_is_direct(fen6_info->rt);
+}
+
+static bool prestera_fib_info_is_nh(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info =
+		container_of(info, struct fib6_entry_notifier_info, info);
+	struct fib_entry_notifier_info *fen_info =
+		container_of(info, struct fib_entry_notifier_info, info);
+
+	if (info->family == AF_INET)
+		return prestera_fi_is_nh(fen_info->fi);
+	else
+		return prestera_fi6_is_nh(fen6_info->rt);
+}
+
+/* must be called with rcu_read_lock() */
+static int prestera_util_kern_get_route(struct fib_result *res, u32 tb_id,
+					__be32 *addr)
+{
+	struct flowi4 fl4;
+
+	/* TODO: walkthrough appropriate tables in kernel
+	 * to know if the same prefix exists in several tables
+	 */
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.daddr = *addr;
+	return fib_lookup(&init_net, &fl4, res, 0 /* FIB_LOOKUP_NOREF */);
+}
+
+static bool
+__prestera_util_kern_n_is_reachable_v4(u32 tb_id, __be32 *addr,
+				       struct net_device *dev)
+{
+	struct fib_nh *fib_nh;
+	struct fib_result res;
+	bool reachable;
+
+	reachable = false;
+
+	if (!prestera_util_kern_get_route(&res, tb_id, addr))
+		if (prestera_fi_is_direct(res.fi)) {
+			fib_nh = fib_info_nh(res.fi, 0);
+			if (dev == fib_nh->fib_nh_dev)
+				reachable = true;
+		}
+
+	return reachable;
+}
+
+/* Check if neigh route is reachable */
+static bool
+prestera_util_kern_n_is_reachable(u32 tb_id,
+				  struct prestera_ip_addr *addr,
+				  struct net_device *dev)
+{
+	if (addr->v == PRESTERA_IPV4)
+		return __prestera_util_kern_n_is_reachable_v4(tb_id,
+							      &addr->u.ipv4,
+							      dev);
+	else
+		return false;
+}
+
+static void prestera_util_kern_set_neigh_offload(struct neighbour *n,
+						 bool offloaded)
+{
+	if (offloaded)
+		n->flags |= NTF_OFFLOADED;
+	else
+		n->flags &= ~NTF_OFFLOADED;
+}
+
+static void
+prestera_util_kern_set_nh_offload(struct fib_nh_common *nhc, bool offloaded, bool trap)
+{
+		if (offloaded)
+			nhc->nhc_flags |= RTNH_F_OFFLOAD;
+		else
+			nhc->nhc_flags &= ~RTNH_F_OFFLOAD;
+
+		if (trap)
+			nhc->nhc_flags |= RTNH_F_TRAP;
+		else
+			nhc->nhc_flags &= ~RTNH_F_TRAP;
+}
+
+static struct fib_nh_common *
+prestera_kern_fib_info_nhc(struct fib_notifier_info *info, int n)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+	struct fib6_info *iter;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return &fib_info_nh(fen4_info->fi, n)->nh_common;
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		if (!n)
+			return &fen6_info->rt->fib6_nh->nh_common;
+
+		list_for_each_entry(iter, &fen6_info->rt->fib6_siblings,
+				    fib6_siblings) {
+			if (!--n)
+				return &iter->fib6_nh->nh_common;
+		}
+	}
+
+	/* if family is incorrect - than upper functions has BUG */
+	/* if doesn't find requested index - there is alsi bug, because
+	 * valid index must be produced by nhs, which checks list length
+	 */
+	WARN(1, "Invalid parameters passed to %s n=%d i=%p",
+	     __func__, n, info);
+	return NULL;
+}
+
+static int prestera_kern_fib_info_nhs(struct fib_notifier_info *info)
+{
+	struct fib6_entry_notifier_info *fen6_info;
+	struct fib_entry_notifier_info *fen4_info;
+
+	if (info->family == AF_INET) {
+		fen4_info = container_of(info, struct fib_entry_notifier_info,
+					 info);
+		return fib_info_num_path(fen4_info->fi);
+	} else if (info->family == AF_INET6) {
+		fen6_info = container_of(info, struct fib6_entry_notifier_info,
+					 info);
+		return fen6_info->rt->fib6_nsiblings + 1;
+	}
+
+	return 0;
+}
+
 static unsigned char
 prestera_kern_fib_info_type(struct fib_notifier_info *info)
 {
@@ -89,6 +383,153 @@ prestera_kern_fib_info_type(struct fib_notifier_info *info)
 	return RTN_UNSPEC;
 }
 
+/* Decided, that uc_nh route with key==nh is obviously neighbour route */
+static bool
+prestera_fib_node_util_is_neighbour(struct prestera_fib_node *fib_node)
+{
+	if (fib_node->info.type != PRESTERA_FIB_TYPE_UC_NH)
+		return false;
+
+	if (fib_node->info.nh_grp->nh_neigh_head[1].neigh)
+		return false;
+
+	if (!fib_node->info.nh_grp->nh_neigh_head[0].neigh)
+		return false;
+
+	if (memcmp(&fib_node->info.nh_grp->nh_neigh_head[0].neigh->key.addr,
+		   &fib_node->key.addr, sizeof(struct prestera_ip_addr)))
+		return false;
+
+	return true;
+}
+
+static int prestera_dev_if_type(const struct net_device *dev)
+{
+	struct macvlan_dev *vlan;
+
+	if (is_vlan_dev(dev) &&
+	    netif_is_bridge_master(vlan_dev_real_dev(dev))) {
+		return PRESTERA_IF_VID_E;
+	} else if (netif_is_bridge_master(dev)) {
+		return PRESTERA_IF_VID_E;
+	} else if (netif_is_lag_master(dev)) {
+		return PRESTERA_IF_LAG_E;
+	} else if (netif_is_macvlan(dev)) {
+		vlan = netdev_priv(dev);
+		return prestera_dev_if_type(vlan->lowerdev);
+	} else {
+		return PRESTERA_IF_PORT_E;
+	}
+}
+
+static int
+prestera_neigh_iface_init(struct prestera_switch *sw,
+			  struct prestera_iface *iface,
+			  struct neighbour *n)
+{
+	struct prestera_port *port;
+
+	iface->vlan_id = 0; /* TODO: vlan egress */
+	iface->type = prestera_dev_if_type(n->dev);
+	if (iface->type != PRESTERA_IF_PORT_E)
+		return -EINVAL;
+
+	if (!prestera_netdev_check(n->dev))
+		return -EINVAL;
+
+	port = netdev_priv(n->dev);
+	iface->dev_port.hw_dev_num = port->dev_id;
+	iface->dev_port.port_num = port->hw_id;
+
+	return 0;
+}
+
+static struct prestera_kern_neigh_cache *
+prestera_kern_neigh_cache_find(struct prestera_switch *sw,
+			       struct prestera_kern_neigh_cache_key *key)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+
+	n_cache =
+	 rhashtable_lookup_fast(&sw->router->kern_neigh_cache_ht, key,
+				__prestera_kern_neigh_cache_ht_params);
+	return IS_ERR(n_cache) ? NULL : n_cache;
+}
+
+static void
+__prestera_kern_neigh_cache_destruct(struct prestera_switch *sw,
+				     struct prestera_kern_neigh_cache *n_cache)
+{
+	dev_put(n_cache->key.dev);
+}
+
+static void
+__prestera_kern_neigh_cache_destroy(struct prestera_switch *sw,
+				    struct prestera_kern_neigh_cache *n_cache)
+{
+	rhashtable_remove_fast(&sw->router->kern_neigh_cache_ht,
+			       &n_cache->ht_node,
+			       __prestera_kern_neigh_cache_ht_params);
+	__prestera_kern_neigh_cache_destruct(sw, n_cache);
+	kfree(n_cache);
+}
+
+static struct prestera_kern_neigh_cache *
+__prestera_kern_neigh_cache_create(struct prestera_switch *sw,
+				   struct prestera_kern_neigh_cache_key *key)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	int err;
+
+	n_cache = kzalloc(sizeof(*n_cache), GFP_KERNEL);
+	if (!n_cache)
+		goto err_kzalloc;
+
+	memcpy(&n_cache->key, key, sizeof(*key));
+	dev_hold(n_cache->key.dev);
+
+	INIT_LIST_HEAD(&n_cache->kern_fib_cache_list);
+	err = rhashtable_insert_fast(&sw->router->kern_neigh_cache_ht,
+				     &n_cache->ht_node,
+				     __prestera_kern_neigh_cache_ht_params);
+	if (err)
+		goto err_ht_insert;
+
+	return n_cache;
+
+err_ht_insert:
+	dev_put(n_cache->key.dev);
+	kfree(n_cache);
+err_kzalloc:
+	return NULL;
+}
+
+static struct prestera_kern_neigh_cache *
+prestera_kern_neigh_cache_get(struct prestera_switch *sw,
+			      struct prestera_kern_neigh_cache_key *key)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+
+	n_cache = prestera_kern_neigh_cache_find(sw, key);
+	if (!n_cache)
+		n_cache = __prestera_kern_neigh_cache_create(sw, key);
+
+	return n_cache;
+}
+
+static struct prestera_kern_neigh_cache *
+prestera_kern_neigh_cache_put(struct prestera_switch *sw,
+			      struct prestera_kern_neigh_cache *n_cache)
+{
+	if (!n_cache->in_kernel &&
+	    list_empty(&n_cache->kern_fib_cache_list)) {
+		__prestera_kern_neigh_cache_destroy(sw, n_cache);
+		return NULL;
+	}
+
+	return n_cache;
+}
+
 static struct prestera_kern_fib_cache *
 prestera_kern_fib_cache_find(struct prestera_switch *sw,
 			     struct prestera_kern_fib_cache_key *key)
@@ -105,6 +546,17 @@ static void
 __prestera_kern_fib_cache_destruct(struct prestera_switch *sw,
 				   struct prestera_kern_fib_cache *fib_cache)
 {
+	struct prestera_kern_neigh_cache *n_cache;
+	int i;
+
+	for (i = 0; i < PRESTERA_NHGR_SIZE_MAX; i++) {
+		n_cache = fib_cache->kern_neigh_cache_head[i].n_cache;
+		if (n_cache) {
+			list_del(&fib_cache->kern_neigh_cache_head[i].head);
+			prestera_kern_neigh_cache_put(sw, n_cache);
+		}
+	}
+
 	fib_info_put(fib_cache->fen4_info.fi);
 }
 
@@ -119,6 +571,41 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
 	kfree(fib_cache);
 }
 
+static int
+__prestera_kern_fib_cache_create_nhs(struct prestera_switch *sw,
+				     struct prestera_kern_fib_cache *fc)
+{
+	struct prestera_kern_neigh_cache_key nc_key;
+	struct prestera_kern_neigh_cache *n_cache;
+	struct fib_nh_common *nhc;
+	int i, nhs, err;
+
+	if (!prestera_fib_info_is_nh(&fc->info))
+		return 0;
+
+	nhs = prestera_kern_fib_info_nhs(&fc->info);
+	if (nhs > PRESTERA_NHGR_SIZE_MAX)
+		return 0;
+
+	for (i = 0; i < nhs; i++) {
+		nhc = prestera_kern_fib_info_nhc(&fc->fen4_info.info, i);
+		err = prestera_util_nhc2nc_key(sw, nhc, &nc_key);
+		if (err)
+			return 0;
+
+		n_cache = prestera_kern_neigh_cache_get(sw, &nc_key);
+		if (!n_cache)
+			return 0;
+
+		fc->kern_neigh_cache_head[i].this = fc;
+		fc->kern_neigh_cache_head[i].n_cache = n_cache;
+		list_add(&fc->kern_neigh_cache_head[i].head,
+			 &n_cache->kern_fib_cache_list);
+	}
+
+	return 0;
+}
+
 /* Operations on fi (offload, etc) must be wrapped in utils.
  * This function just create storage.
  */
@@ -146,6 +633,12 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	if (err)
 		goto err_ht_insert;
 
+	/* Handle nexthops */
+	err = __prestera_kern_fib_cache_create_nhs(sw, fib_cache);
+	if (err)
+		goto out; /* Not critical */
+
+out:
 	return fib_cache;
 
 err_ht_insert:
@@ -155,6 +648,46 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
 	return NULL;
 }
 
+static void
+__prestera_k_arb_fib_nh_offload_set(struct prestera_switch *sw,
+				    struct prestera_kern_fib_cache *fibc,
+				    struct prestera_kern_neigh_cache *nc,
+				    bool offloaded, bool trap)
+{
+	struct fib_nh_common *nhc;
+	int i, nhs;
+
+	nhs = prestera_kern_fib_info_nhs(&fibc->info);
+	for (i = 0; i < nhs; i++) {
+		nhc = prestera_kern_fib_info_nhc(&fibc->info, i);
+		if (!nc) {
+			prestera_util_kern_set_nh_offload(nhc, offloaded, trap);
+			continue;
+		}
+
+		if (prestera_util_nhc_eq_n_cache_key(sw, nhc, &nc->key)) {
+			prestera_util_kern_set_nh_offload(nhc, offloaded, trap);
+			break;
+		}
+	}
+}
+
+static void
+__prestera_k_arb_n_offload_set(struct prestera_switch *sw,
+			       struct prestera_kern_neigh_cache *nc,
+			       bool offloaded)
+{
+	struct neighbour *n;
+
+	n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4,
+			 nc->key.dev);
+	if (!n)
+		return;
+
+	prestera_util_kern_set_neigh_offload(n, offloaded);
+	neigh_release(n);
+}
+
 static void
 __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 				     struct prestera_kern_fib_cache *fc,
@@ -183,15 +716,187 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
 	}
 }
 
+static void
+__prestera_k_arb_n_lpm_set(struct prestera_switch *sw,
+			   struct prestera_kern_neigh_cache *n_cache,
+			   bool enabled)
+{
+	struct prestera_nexthop_group_key nh_grp_key;
+	struct prestera_kern_fib_cache_key fc_key;
+	struct prestera_kern_fib_cache *fib_cache;
+	struct prestera_fib_node *fib_node;
+	struct prestera_fib_key fib_key;
+
+	/* Exception for fc with prefix 32: LPM entry is already used by fib */
+	memset(&fc_key, 0, sizeof(fc_key));
+	fc_key.addr = n_cache->key.addr;
+	fc_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
+	/* But better to use tb_id of route, which pointed to this neighbour. */
+	/* We take it from rif, because rif inconsistent.
+	 * Must be separated in_rif and out_rif.
+	 * Also note: for each fib pointed to this neigh should be separated
+	 *            neigh lpm entry (for each ingress vr)
+	 */
+	fc_key.kern_tb_id = l3mdev_fib_table(n_cache->key.dev);
+	fib_cache = prestera_kern_fib_cache_find(sw, &fc_key);
+	memset(&fib_key, 0, sizeof(fib_key));
+	fib_key.addr = n_cache->key.addr;
+	fib_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
+	fib_key.tb_id = prestera_fix_tb_id(fc_key.kern_tb_id);
+	fib_node = prestera_fib_node_find(sw, &fib_key);
+	if (!fib_cache || !fib_cache->reachable) {
+		if (!enabled && fib_node) {
+			if (prestera_fib_node_util_is_neighbour(fib_node))
+				prestera_fib_node_destroy(sw, fib_node);
+			return;
+		}
+	}
+
+	if (enabled && !fib_node) {
+		memset(&nh_grp_key, 0, sizeof(nh_grp_key));
+		prestera_util_nc_key2nh_key(&n_cache->key,
+					    &nh_grp_key.neigh[0]);
+		fib_node = prestera_fib_node_create(sw, &fib_key,
+						    PRESTERA_FIB_TYPE_UC_NH,
+						    &nh_grp_key);
+		if (!fib_node)
+			pr_err("%s failed ip=%pI4n", "prestera_fib_node_create",
+			       &fib_key.addr.u.ipv4);
+		return;
+	}
+}
+
+static void
+__prestera_k_arb_nc_kern_fib_fetch(struct prestera_switch *sw,
+				   struct prestera_kern_neigh_cache *nc)
+{
+	if (prestera_util_kern_n_is_reachable(l3mdev_fib_table(nc->key.dev),
+					      &nc->key.addr, nc->key.dev))
+		nc->reachable = true;
+	else
+		nc->reachable = false;
+}
+
+/* Kernel neighbour -> neigh_cache info */
+static void
+__prestera_k_arb_nc_kern_n_fetch(struct prestera_switch *sw,
+				 struct prestera_kern_neigh_cache *nc)
+{
+	struct neighbour *n;
+	int err;
+
+	memset(&nc->nh_neigh_info, 0, sizeof(nc->nh_neigh_info));
+	n = neigh_lookup(&arp_tbl, &nc->key.addr.u.ipv4, nc->key.dev);
+	if (!n)
+		goto out;
+
+	read_lock_bh(&n->lock);
+	if (n->nud_state & NUD_VALID && !n->dead) {
+		err = prestera_neigh_iface_init(sw, &nc->nh_neigh_info.iface,
+						n);
+		if (err)
+			goto n_read_out;
+
+		memcpy(&nc->nh_neigh_info.ha[0], &n->ha[0], ETH_ALEN);
+		nc->nh_neigh_info.connected = true;
+	}
+n_read_out:
+	read_unlock_bh(&n->lock);
+out:
+	nc->in_kernel = nc->nh_neigh_info.connected;
+	if (n)
+		neigh_release(n);
+}
+
+/* neigh_cache info -> lpm update */
+static void
+__prestera_k_arb_nc_apply(struct prestera_switch *sw,
+			  struct prestera_kern_neigh_cache *nc)
+{
+	struct prestera_kern_neigh_cache_head *nhead;
+	struct prestera_nh_neigh_key nh_key;
+	struct prestera_nh_neigh *nh_neigh;
+	int err;
+
+	__prestera_k_arb_n_lpm_set(sw, nc, nc->reachable && nc->in_kernel);
+	__prestera_k_arb_n_offload_set(sw, nc, nc->reachable && nc->in_kernel);
+
+	prestera_util_nc_key2nh_key(&nc->key, &nh_key);
+	nh_neigh = prestera_nh_neigh_find(sw, &nh_key);
+	if (!nh_neigh)
+		goto out;
+
+	/* Do hw update only if something changed to prevent nh flap */
+	if (memcmp(&nc->nh_neigh_info, &nh_neigh->info,
+		   sizeof(nh_neigh->info))) {
+		memcpy(&nh_neigh->info, &nc->nh_neigh_info,
+		       sizeof(nh_neigh->info));
+		err = prestera_nh_neigh_set(sw, nh_neigh);
+		if (err) {
+			pr_err("%s failed with err=%d ip=%pI4n mac=%pM",
+			       "prestera_nh_neigh_set", err,
+			       &nh_neigh->key.addr.u.ipv4,
+			       &nh_neigh->info.ha[0]);
+			goto out;
+		}
+	}
+
+out:
+	list_for_each_entry(nhead, &nc->kern_fib_cache_list, head) {
+		__prestera_k_arb_fib_nh_offload_set(sw, nhead->this, nc,
+						    nc->in_kernel,
+						    !nc->in_kernel);
+	}
+}
+
 static int
 __prestera_pr_k_arb_fc_lpm_info_calc(struct prestera_switch *sw,
 				     struct prestera_kern_fib_cache *fc)
 {
+	struct fib_nh_common *nhc;
+	int nh_cnt;
+
 	memset(&fc->lpm_info, 0, sizeof(fc->lpm_info));
 
 	switch (prestera_kern_fib_info_type(&fc->info)) {
 	case RTN_UNICAST:
-		fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_TRAP;
+		if (prestera_fib_info_is_direct(&fc->info) &&
+		    fc->key.prefix_len ==
+			PRESTERA_IP_ADDR_PLEN(fc->key.addr.v)) {
+			/* This is special case.
+			 * When prefix is 32. Than we will have conflict in lpm
+			 * for direct route - once TRAP added, there is no
+			 * place for neighbour entry. So represent direct route
+			 * with prefix 32, as NH. So neighbour will be resolved
+			 * as nexthop of this route.
+			 */
+			nhc = prestera_kern_fib_info_nhc(&fc->info, 0);
+			fc->lpm_info.fib_type = PRESTERA_FIB_TYPE_UC_NH;
+			fc->lpm_info.nh_grp_key.neigh[0].addr =
+				fc->key.addr;
+			fc->lpm_info.nh_grp_key.neigh[0].rif =
+				nhc->nhc_dev;
+
+			break;
+		}
+
+		/* We can also get nh_grp_key from fi. This will be correct to
+		 * because cache not always represent, what actually written to
+		 * lpm. But we use nh cache, as well for now (for this case).
+		 */
+		for (nh_cnt = 0; nh_cnt < PRESTERA_NHGR_SIZE_MAX; nh_cnt++) {
+			if (!fc->kern_neigh_cache_head[nh_cnt].n_cache)
+				break;
+
+			fc->lpm_info.nh_grp_key.neigh[nh_cnt].addr =
+				fc->kern_neigh_cache_head[nh_cnt].n_cache->key.addr;
+			fc->lpm_info.nh_grp_key.neigh[nh_cnt].rif =
+				fc->kern_neigh_cache_head[nh_cnt].n_cache->key.dev;
+		}
+
+		fc->lpm_info.fib_type = nh_cnt ?
+					PRESTERA_FIB_TYPE_UC_NH :
+					PRESTERA_FIB_TYPE_TRAP;
 		break;
 	/* Unsupported. Leave it for kernel: */
 	case RTN_BROADCAST:
@@ -231,7 +936,8 @@ static int __prestera_k_arb_f_lpm_set(struct prestera_switch *sw,
 		return 0;
 
 	fib_node = prestera_fib_node_create(sw, &fc->lpm_info.fib_key,
-					    fc->lpm_info.fib_type, NULL);
+					    fc->lpm_info.fib_type,
+					    &fc->lpm_info.nh_grp_key);
 
 	if (!fib_node) {
 		dev_err(sw->dev->dev, "fib_node=NULL %pI4n/%d kern_tb_id = %d",
@@ -261,6 +967,8 @@ static int __prestera_k_arb_fc_apply(struct prestera_switch *sw,
 
 	switch (fc->lpm_info.fib_type) {
 	case PRESTERA_FIB_TYPE_UC_NH:
+		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
+						     fc->reachable, false);
 		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
@@ -313,6 +1021,57 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
 	return rfc;
 }
 
+/* Propagate kernel event to hw */
+static void prestera_k_arb_n_evt(struct prestera_switch *sw,
+				 struct neighbour *n)
+{
+	struct prestera_kern_neigh_cache_key n_key;
+	struct prestera_kern_neigh_cache *n_cache;
+	int err;
+
+	err = prestera_util_neigh2nc_key(sw, n, &n_key);
+	if (err)
+		return;
+
+	n_cache = prestera_kern_neigh_cache_find(sw, &n_key);
+	if (!n_cache) {
+		n_cache = prestera_kern_neigh_cache_get(sw, &n_key);
+		if (!n_cache)
+			return;
+		__prestera_k_arb_nc_kern_fib_fetch(sw, n_cache);
+	}
+
+	__prestera_k_arb_nc_kern_n_fetch(sw, n_cache);
+	__prestera_k_arb_nc_apply(sw, n_cache);
+
+	prestera_kern_neigh_cache_put(sw, n_cache);
+}
+
+static void __prestera_k_arb_fib_evt2nc(struct prestera_switch *sw)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	struct rhashtable_iter iter;
+
+	rhashtable_walk_enter(&sw->router->kern_neigh_cache_ht, &iter);
+	rhashtable_walk_start(&iter);
+	while (1) {
+		n_cache = rhashtable_walk_next(&iter);
+
+		if (!n_cache)
+			break;
+
+		if (IS_ERR(n_cache))
+			continue;
+
+		rhashtable_walk_stop(&iter);
+		__prestera_k_arb_nc_kern_fib_fetch(sw, n_cache);
+		__prestera_k_arb_nc_apply(sw, n_cache);
+		rhashtable_walk_start(&iter);
+	}
+	rhashtable_walk_stop(&iter);
+	rhashtable_walk_exit(&iter);
+}
+
 static int
 prestera_k_arb_fib_evt(struct prestera_switch *sw,
 		       bool replace, /* replace or del */
@@ -370,9 +1129,30 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 			dev_err(sw->dev->dev, "Applying fib_cache failed");
 	}
 
+	/* Update all neighs to resolve overlapped and apply related */
+	__prestera_k_arb_fib_evt2nc(sw);
+
 	return 0;
 }
 
+static void __prestera_k_arb_abort_neigh_ht_cb(void *ptr, void *arg)
+{
+	struct prestera_kern_neigh_cache *n_cache = ptr;
+	struct prestera_switch *sw = arg;
+
+	if (!list_empty(&n_cache->kern_fib_cache_list)) {
+		WARN_ON(1); /* BUG */
+		return;
+	}
+	__prestera_k_arb_n_offload_set(sw, n_cache, false);
+	n_cache->in_kernel = false;
+	/* No need to destroy lpm.
+	 * It will be aborted by destroy_ht
+	 */
+	__prestera_kern_neigh_cache_destruct(sw, n_cache);
+	kfree(n_cache);
+}
+
 static void __prestera_k_arb_abort_fib_ht_cb(void *ptr, void *arg)
 {
 	struct prestera_kern_fib_cache *fib_cache = ptr;
@@ -381,6 +1161,8 @@ static void __prestera_k_arb_abort_fib_ht_cb(void *ptr, void *arg)
 	__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
 					     false, false,
 					     false);
+	__prestera_k_arb_fib_nh_offload_set(sw, fib_cache, NULL,
+					    false, false);
 	/* No need to destroy lpm.
 	 * It will be aborted by destroy_ht
 	 */
@@ -401,6 +1183,9 @@ static void prestera_k_arb_abort(struct prestera_switch *sw)
 	rhashtable_free_and_destroy(&sw->router->kern_fib_cache_ht,
 				    __prestera_k_arb_abort_fib_ht_cb,
 				    sw);
+	rhashtable_free_and_destroy(&sw->router->kern_neigh_cache_ht,
+				    __prestera_k_arb_abort_neigh_ht_cb,
+				    sw);
 }
 
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
@@ -615,12 +1400,13 @@ static void prestera_router_neigh_event_work(struct work_struct *work)
 {
 	struct prestera_netevent_work *net_work =
 		container_of(work, struct prestera_netevent_work, work);
+	struct prestera_switch *sw = net_work->sw;
 	struct neighbour *n = net_work->n;
 
 	/* neigh - its not hw related object. It stored only in kernel. So... */
 	rtnl_lock();
 
-	/* TODO: handler */
+	prestera_k_arb_n_evt(sw, n);
 
 	neigh_release(n);
 	rtnl_unlock();
@@ -676,6 +1462,11 @@ int prestera_router_init(struct prestera_switch *sw)
 	if (err)
 		goto err_kern_fib_cache_ht_init;
 
+	err = rhashtable_init(&router->kern_neigh_cache_ht,
+			      &__prestera_kern_neigh_cache_ht_params);
+	if (err)
+		goto err_kern_neigh_cache_ht_init;
+
 	nhgrp_cache_bytes = sw->size_tbl_router_nexthop / 8 + 1;
 	router->nhgrp_hw_state_cache = kzalloc(nhgrp_cache_bytes, GFP_KERNEL);
 	if (!router->nhgrp_hw_state_cache) {
@@ -715,6 +1506,8 @@ int prestera_router_init(struct prestera_switch *sw)
 err_register_inetaddr_validator_notifier:
 	kfree(router->nhgrp_hw_state_cache);
 err_nh_state_cache_alloc:
+	rhashtable_destroy(&router->kern_neigh_cache_ht);
+err_kern_neigh_cache_ht_init:
 	rhashtable_destroy(&router->kern_fib_cache_ht);
 err_kern_fib_cache_ht_init:
 	prestera_router_hw_fini(sw);
-- 
2.17.1

