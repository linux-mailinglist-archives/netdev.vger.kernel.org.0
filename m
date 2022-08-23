Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BE559CCF1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 02:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239050AbiHWAMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 20:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238991AbiHWALx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 20:11:53 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80134.outbound.protection.outlook.com [40.107.8.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D115723C;
        Mon, 22 Aug 2022 17:11:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2EtAgcRafZRLn4bX831Jjx7WTHiAgpwFHAlTK3xRV6Eq6PT43JCS98AGGixbk8MUa076IGD/Z9SlnnmXpWnvaMaXKqzlbuTUwBPDHeOEzbE1Yr1BMTtCMed7LBu5rGlDzt5xE7IY0EJzYf8lNJuMsliM9aSqnEdDV0fpl7NgArlfqCfx7jAgNU5vM2ElTSIRtyMcnbHETZGEHRJ0uErff1/T+AYeTSOzlA5el56lkihPujyOq4n0g3XXje1hwC1siFuc1YqZiGqUFY9WL0Ub/B62rIMTDbvbZFeqBexCLBVpYJzrIumWrYF1UB1BSRAAbtdD9gZF5qFP/TLd8K1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8ufrew8gXHNUGu4Ee9OzkQQQC3uRVWxFzmjuTv4Kro=;
 b=Eolx6y53OpxO8FEuTlVKOxcPiikrpnViV3Jj0wbxFsC7NLNAHQshoBteiVdzqjvbvaVooqA8g8YSj8k0LyJeqAuTbzGKn9JtMPyNJq1lBWVOBtMxgc7M5J1capYZHXkliv+Gqzu2ehMzJ4t0xxpS9Lu/rcjK6ItLBvDgyBEhRSGzy8roYbvHJGZbcWNrZ7KGR+QhML+sPdDJG5TG2nVfvnLCu+4KQb4SiOowoOEtAtTpcO7giB5hoWv5rWqsaCq+66U4+3+Jo0rSejPF3dEd0Q+llNCbcF7Zxxyei9DKc5ffudA7dSIj4mzNXZZOqoNeGXVpaZ81Zvhc+mdszbd8/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8ufrew8gXHNUGu4Ee9OzkQQQC3uRVWxFzmjuTv4Kro=;
 b=ie81xmfUr5L5VucQDOc7qlqHwJ3tmsPZOQ1JXaOkLQh+GUtGJtoxRvyDRVKkCKZ/V/qz/PpXfhgQrI8XXpDGN1Y2Iv8NTIuhTKxOtq2+awB99rU71RkNIpEXXOXrfZ9rDxOFGtYQhUOF1hvDd4mnW1xPnP4ERFSQ6FI2WTWdDEY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6)
 by PA4P190MB1072.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Tue, 23 Aug
 2022 00:11:35 +0000
Received: from PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5]) by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 ([fe80::6557:8bc5:e347:55d5%4]) with mapi id 15.20.5546.021; Tue, 23 Aug 2022
 00:11:35 +0000
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
Subject: [PATCH net-next v3 8/9] net: marvell: prestera: Add neighbour cache accounting
Date:   Tue, 23 Aug 2022 03:10:46 +0300
Message-Id: <20220823001047.24784-9-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
References: <20220823001047.24784-1-yevhen.orlov@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::10) To PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:102:283::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f20ec75-f9be-4391-9720-08da849c0a70
X-MS-TrafficTypeDiagnostic: PA4P190MB1072:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/U+qKZ1RV9Kst9XAmyxjZd9jIjPZ+XkMfe9/TBCGgUs3D4C+c1jLSnptAEnv/QIczx3qkX9Z5MS9UEZ3nfOTNlayKfRHAldHZLx9zWCkIuJgYQB/qpOL3xpU6l1HDGekPjo9KZKUs73/DE3sTep/wbgfRcAB3gwycxSGqI2JRkWNKYE50TUAXy0dNCOkfxQf/cBuu786zFPKdIRXzy6ugcjsm1I/owwmI23XbhkBTLNHk6WO3sNg8+eT0ftkoCRavM/nTAJYVUqJvUbhwKkYrHDzgYXLGEfWZ6NJ8NJ43UTms6nn9M6EjPGMGnkctqDv/WWJd50k+x71ZTPseYQ5VUBJsnYyfx5pV7CRXCQDKAzOspRncMvhixqxVFAro2GfnThwBqDcZHCdDOkYkju77cNIysjqKp+6nHgVIUfrDziCNRW09S3/kadbFyjLPoK/CDsbPQgc4fFcTP37H61obIzDf0IaIG8vMXSqSvpz4uYKcg7j9lWL7Ml20JhJ9hiPGjW46ybbTLQfwHBXQBcCDrDYaRijckvYi6REdHeJ4QF9sPDInE5vajI+xcz+Tf3wgbeE2w+SS55XfFr02paKp7taikX4rraQxJDkJwXG0FZzrgr9gkFY/Pj47N1eYWxAkTeKNGwmy77eOWD24Oo7jomHHVrjcI+c0HeXBHKaAN3sCckFt0xqMx2ADWteJ2ohJ2JKWqFYnSJaLROg6NjcqEI5UIWjq8ERdGTuDLBAB70/TpcxHBdCyJKGRQW0CGk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXP190MB1789.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(136003)(34036004)(39830400003)(346002)(376002)(83380400001)(38350700002)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(6916009)(316002)(15650500001)(2906002)(8936002)(30864003)(7416002)(44832011)(5660300002)(107886003)(6506007)(26005)(6512007)(52116002)(66574015)(1076003)(186003)(2616005)(6666004)(41300700001)(41320700001)(6486002)(508600001)(86362001)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vn8Pes2vDQyAbPAyzz9YkghOD0nhPgUtjJYQjBuhkEW4W8Vs5jpcEhrEdva8?=
 =?us-ascii?Q?IuRPmiK5UdEKTbjrU/X3RTEgWc/rxpJar+EcnCIErEr7Ywnrd3aPYonCa1Fj?=
 =?us-ascii?Q?84PqlMU1ZhuNLy3MH3up6+ndhQsBXuXxdP+4cfNOA4vesDp5xqxC2AjNqUtM?=
 =?us-ascii?Q?G354nFqNWNj3C7+ZdqQcVg7YHDzEOdZBrFg3pVIHSb70Yxy/vpx9rZM1kA9I?=
 =?us-ascii?Q?xK3lyHV0JcBfbG2UiLbH/DsiQ7F2mRnX7Ou/ZlCy8k7Yam/B+50RzXHw+i2j?=
 =?us-ascii?Q?B1ww3mvpE0dQdjinJ8F2VbwVjTVKwALVFAX4jomekeKP0yZYe/Nc/h6HbMQl?=
 =?us-ascii?Q?/6R8AgN50nHSa+WZVnM32u2AY+ebKzW48Ve9YYSrWFJF0/T2LBAgl1jdcBXM?=
 =?us-ascii?Q?L1cj/YvNR/fhppWjxh8hxNMA46Xx8+Qmd2e/QURan7cgs4eW+CzT3z9yo3Sr?=
 =?us-ascii?Q?1SIYY9ZK/juZc3fa47I38eZG4iylbFxRfXsLfoU5ZuwznH3mCoHypMsXzLB1?=
 =?us-ascii?Q?0eOSSq/Nn3Y9VBrQ0a7Ekcu0YdkVdecPWQh830Cq1V7/BTVhiaa2i/ZtjN/O?=
 =?us-ascii?Q?e3DW9fWvxr6sK1fuqtryMRTLJUCEvC0e2UiBkW1RRTGuDrASCeG579SrXuYb?=
 =?us-ascii?Q?hBibnJIZCO6h6JurhYso3KA0wTudG6GYg0V7Y2v7Sx2wJjLweIhwi527iV4T?=
 =?us-ascii?Q?qsvYw60Tg1uO8EOSOfZ+0MwEd8sV5lak6BJuWfrAHoiEs46hjqv93xFE3b4v?=
 =?us-ascii?Q?A3oQ9inSloHG9XpsTnFHERmCLqE2FlZBE3WyT+zACfsnY/xFaZ+sk9z5z5dG?=
 =?us-ascii?Q?o0P15lNrBrjgsouKj/OmTQdduCUxB+CvBxs26qojObNiex4il2qYDQbhaqK1?=
 =?us-ascii?Q?Raw1a6w2ONfdHoWhDKyzDruZG3SCeGHwDYKjQREF9onP0fLMhXADjegU63hV?=
 =?us-ascii?Q?rx582BfEyecSqwyhdy948Sx6mHhcuMnw8Y0o6Mlp6o1OZdEYSEj/+3POFd2W?=
 =?us-ascii?Q?k4xgNMRmfw2bSUg2BM9ThqP8qhujuIbQH8lGbCFdpL3oLmx+5zC+zNX4Spqa?=
 =?us-ascii?Q?e85I64KYigLvoaK3f+tPboVcspGc3yLgzOD4EgZDMBbFggebXJHCyQpwBYsr?=
 =?us-ascii?Q?UqGvHo7y1rzsbUeva9DbJ2a5fCLs65s8s+BUnwvOu82+9hg7JaN4RScyaM1s?=
 =?us-ascii?Q?lGUJMiSyh6bXcUiO+skw3orWVc69Obd8pPrauXKVmvnxb94Fh46u1Pdum6Jd?=
 =?us-ascii?Q?6h3QgrpyOo+u/FaTHt8pdfWV20D+bTxbQeQHSWkKCA2hN6Y85DYMqi8S/P/o?=
 =?us-ascii?Q?+VN5z/XyVxS2+sq8QqGPrpBFqnoTfMxxGjUQD2mkzVHrhV2diAitOlosjWN0?=
 =?us-ascii?Q?eRQJIpiaAo8xL/uT/Jm59wnpaN3LjrRN6FshvEsEGQKzMk6AsiKG/INS0D/j?=
 =?us-ascii?Q?HhWD8fz2ntZ9C6fJsdIAr06wyh4+PT8+snorprNvCn8BbOOxucwHbk65Gcmr?=
 =?us-ascii?Q?hPuWDgcbb3SDOUPMzAWO2D0z/07BgBcH5hc9GrGv28bKPzbC9fKstE4jqiXW?=
 =?us-ascii?Q?Sv64bj1XIXW/TutTmg4WPEunmi5tv02J21obo6xUjXcp2xCQUIpT+neS2EF1?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f20ec75-f9be-4391-9720-08da849c0a70
X-MS-Exchange-CrossTenant-AuthSource: PAXP190MB1789.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 00:11:35.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDvohImR+MBffbQ2HaB0Cvees123rDvc8+Kqke7Adzcv9n/RyIqLacJemVBbzMPzTRsbf3dNVWu3J+OjOOy3xe6AmXLaSRiQZeqVDgsInYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4P190MB1072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../marvell/prestera/prestera_router.c        | 813 +++++++++++++++++-
 2 files changed, 811 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 33a0add529ba..8cd934f7c458 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -306,6 +306,7 @@ struct prestera_router {
 	struct rhashtable nh_neigh_ht;
 	struct rhashtable nexthop_group_ht;
 	struct rhashtable fib_ht;
+	struct rhashtable kern_neigh_cache_ht;
 	struct rhashtable kern_fib_cache_ht;
 	struct notifier_block inetaddr_nb;
 	struct notifier_block inetaddr_valid_nb;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router.c b/drivers/net/ethernet/marvell/prestera/prestera_router.c
index 3e003b991a04..444032057c93 100644
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
+	/* Lock cache if neigh is present in kernel */
+	bool in_kernel;
+	/* Hold prepared nh_neigh info if is in_kernel */
+	struct prestera_neigh_info nh_neigh_info;
+	/* Indicate if neighbour is reachable by direct route */
+	bool reachable;
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
@@ -67,6 +99,278 @@ prestera_util_fen_info2fib_cache_key(struct fib_notifier_info *info,
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
+				 struct prestera_nh_neigh_key *nk)
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
+	struct fib_table *tb;
+	struct flowi4 fl4;
+	int ret;
+
+	/* TODO: walkthrough appropriate tables in kernel
+	 * to know if the same prefix exists in several tables
+	 */
+	tb = fib_new_table(&init_net, tb_id);
+	if (!tb)
+		return -ENOENT;
+
+	memset(&fl4, 0, sizeof(fl4));
+	fl4.daddr = *addr;
+	ret = fib_table_lookup(tb, &fl4, res, FIB_LOOKUP_NOREF);
+	if (ret)
+		return ret;
+
+	return 0;
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
@@ -89,6 +393,145 @@ prestera_kern_fib_info_type(struct fib_notifier_info *info)
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
+	if (is_vlan_dev(dev) && netif_is_bridge_master(vlan_dev_real_dev(dev)))
+		return PRESTERA_IF_VID_E;
+	else if (netif_is_bridge_master(dev))
+		return PRESTERA_IF_VID_E;
+	else if (netif_is_lag_master(dev))
+		return PRESTERA_IF_LAG_E;
+	else if (netif_is_macvlan(dev)) {
+		vlan = netdev_priv(dev);
+		return prestera_dev_if_type(vlan->lowerdev);
+	}
+	else
+		return PRESTERA_IF_PORT_E;
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
+__prestera_kern_neigh_cache_destroy(struct prestera_switch *sw,
+				    struct prestera_kern_neigh_cache *n_cache)
+{
+	dev_put(n_cache->key.dev);
+	rhashtable_remove_fast(&sw->router->kern_neigh_cache_ht,
+			       &n_cache->ht_node,
+			       __prestera_kern_neigh_cache_ht_params);
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
@@ -105,6 +548,17 @@ static void
 prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
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
 	rhashtable_remove_fast(&sw->router->kern_fib_cache_ht,
 			       &fib_cache->ht_node,
@@ -112,6 +566,41 @@ prestera_kern_fib_cache_destroy(struct prestera_switch *sw,
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
@@ -139,6 +628,12 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
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
@@ -148,6 +643,46 @@ prestera_kern_fib_cache_create(struct prestera_switch *sw,
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
@@ -176,15 +711,187 @@ __prestera_k_arb_fib_lpm_offload_set(struct prestera_switch *sw,
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
+	if (!fib_cache || !fib_cache->reachable) {
+		memset(&fib_key, 0, sizeof(fib_key));
+		fib_key.addr = n_cache->key.addr;
+		fib_key.prefix_len = PRESTERA_IP_ADDR_PLEN(n_cache->key.addr.v);
+		fib_key.tb_id = prestera_fix_tb_id(fc_key.kern_tb_id);
+		fib_node = prestera_fib_node_find(sw, &fib_key);
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
@@ -224,7 +931,8 @@ static int __prestera_k_arb_f_lpm_set(struct prestera_switch *sw,
 		return 0;
 
 	fib_node = prestera_fib_node_create(sw, &fc->lpm_info.fib_key,
-					    fc->lpm_info.fib_type, NULL);
+					    fc->lpm_info.fib_type,
+					    &fc->lpm_info.nh_grp_key);
 
 	if (!fib_node) {
 		dev_err(sw->dev->dev, "fib_node=NULL %pI4n/%d kern_tb_id = %d",
@@ -254,6 +962,8 @@ static int __prestera_k_arb_fc_apply(struct prestera_switch *sw,
 
 	switch (fc->lpm_info.fib_type) {
 	case PRESTERA_FIB_TYPE_UC_NH:
+		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
+						     fc->reachable, false);
 		break;
 	case PRESTERA_FIB_TYPE_TRAP:
 		__prestera_k_arb_fib_lpm_offload_set(sw, fc, false,
@@ -306,6 +1016,57 @@ __prestera_k_arb_util_fib_overlapped(struct prestera_switch *sw,
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
@@ -363,9 +1124,45 @@ prestera_k_arb_fib_evt(struct prestera_switch *sw,
 			dev_err(sw->dev->dev, "Applying fib_cache failed");
 	}
 
+	/* Update all neighs to resolve overlapped and apply related */
+	__prestera_k_arb_fib_evt2nc(sw);
+
 	return 0;
 }
 
+static void __prestera_k_arb_abort_neigh(struct prestera_switch *sw)
+{
+	struct prestera_kern_neigh_cache *n_cache;
+	struct rhashtable_iter iter;
+
+	while (1) {
+		rhashtable_walk_enter(&sw->router->kern_neigh_cache_ht, &iter);
+		rhashtable_walk_start(&iter);
+
+		n_cache = rhashtable_walk_next(&iter);
+
+		rhashtable_walk_stop(&iter);
+		rhashtable_walk_exit(&iter);
+
+		if (!n_cache) {
+			break;
+		} else if (IS_ERR(n_cache)) {
+			continue;
+		} else if (n_cache) {
+			if (!list_empty(&n_cache->kern_fib_cache_list)) {
+				WARN_ON(1); /* BUG */
+				continue;
+			}
+			__prestera_k_arb_n_offload_set(sw, n_cache, false);
+			n_cache->in_kernel = false;
+			/* No need to destroy lpm.
+			 * It will be aborted by destroy_ht
+			 */
+			__prestera_kern_neigh_cache_destroy(sw, n_cache);
+		}
+	}
+}
+
 static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
 {
 	struct prestera_kern_fib_cache *fib_cache;
@@ -388,6 +1185,8 @@ static void __prestera_k_arb_abort_fib(struct prestera_switch *sw)
 			__prestera_k_arb_fib_lpm_offload_set(sw, fib_cache,
 							     false, false,
 							     false);
+			__prestera_k_arb_fib_nh_offload_set(sw, fib_cache, NULL,
+							    false, false);
 			/* No need to destroy lpm.
 			 * It will be aborted by destroy_ht
 			 */
@@ -407,6 +1206,7 @@ static void prestera_k_arb_abort(struct prestera_switch *sw)
 	 * hw object (e.g. in case of overlapped routes).
 	 */
 	__prestera_k_arb_abort_fib(sw);
+	__prestera_k_arb_abort_neigh(sw);
 }
 
 static int __prestera_inetaddr_port_event(struct net_device *port_dev,
@@ -627,7 +1427,7 @@ static void prestera_router_neigh_event_work(struct work_struct *work)
 	/* neigh - its not hw related object. It stored only in kernel. So... */
 	rtnl_lock();
 
-	/* TODO: handler */
+	prestera_k_arb_n_evt(sw, n);
 
 	neigh_release(n);
 	rtnl_unlock();
@@ -683,6 +1483,11 @@ int prestera_router_init(struct prestera_switch *sw)
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
@@ -722,6 +1527,8 @@ int prestera_router_init(struct prestera_switch *sw)
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

