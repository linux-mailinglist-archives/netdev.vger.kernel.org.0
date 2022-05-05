Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE151B792
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243838AbiEEFsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243693AbiEEFsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:48:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2132.outbound.protection.outlook.com [40.107.101.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478E03668C
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wvi4uvm54966WL3aygk9FIv3RDsIndkdyzlyK9z1wsoeFzlqzh1bCMZr7Oz+b5C+zM+z0UyI1Wj64XcOG6Mh4+L7e20linRdkxV3SxNr7y0lTNpYKm4HhePVk54YUKat9Whg68fVSbQcSvURkvfNm2Mk30dtndSCxlVrtB/OaUJ7Adt1h2A+0eHV/raWeEMltJ5VSFXzopIWqG1bhXSncqe++Hl2cQI7dH2qdDFvf1UdOTNGyFYSLSvEkMneaIr3Nt3s0ZC0csdLCPYIp/lkW9KQyMzoqNaqFFJQ0kBIYberCdsdveuil3hEAAVmUyp7/hNIIf/2tXkKKCy4agc7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y6aVqBVuhRwfmRvLArZDnJwXNj5RM8fqRI9nPobCLao=;
 b=T95knBMeyqwX+GCPnuFVP7fOm2SD7k1SnuYbmHOu+wT7/yL/dq0sqXQZ+WgYYVXL2wmGMqlk7WbqifCQUxwGNVSW0tH9WlkI1mRMKUZZfzmnzkykGJi/+ocjff3o61pANp1parjBwsv5qX5G1loGWBCKP12Dc94gNQCTMiFSzZ6fckkuzy3vUXpbWYaEkFyBXrVBUs7GUEVJ13vSJfNKpuXd9MSUbGDjNDswuMRN3WKCRATJL6KUDkflfgroEPEASikR3dyGS3iOZbxWCZ9IE+fL3xCXu/EMXAu11vzw4hPxA0dIMY+09fwpZFuosPq9Pcr850uIWKbl40Lma+j5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y6aVqBVuhRwfmRvLArZDnJwXNj5RM8fqRI9nPobCLao=;
 b=kWMKVKtigYcsjp9J3j0LhdGqY+yQEzd0ESxoSkG0f9IE94WpWYljl1/Zcdx9UHd3p7uon0oVM7EClJtvKVcp+JofpsrAd7LHnPkdAFBNPIWUeohASFzoXO271eG7sRnW3De2015UL+KbKmcyM2UnQF46onVfRmHUjkOcHRXXZTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2609.namprd13.prod.outlook.com (2603:10b6:408:82::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14; Thu, 5 May
 2022 05:44:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:14 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 8/9] nfp: flower: remove unused neighbour cache
Date:   Thu,  5 May 2022 14:43:47 +0900
Message-Id: <20220505054348.269511-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63c8fe05-352f-4e0c-2142-08da2e5a499c
X-MS-TrafficTypeDiagnostic: BN8PR13MB2609:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB260946D0AE2FEFDB6147C7D7E8C29@BN8PR13MB2609.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vG3LFtOIPkgG6lDVYgfJzbpXe1QmKQIOnaSicFUeJd1m4GW9T1Cc1E7A95sRtoHN/LJwrrfIwyVb4OfRwp1JBsZc/l2etWx4MWU/2EuWW0+la8jIWz6yYsBUuXPRc2PNNDNA/NTcVnXFAaXJC8+wpQHQ9Lm7JYXE67RTzVyzCag/Z8HpzS0TmePdL/A7FCfrTF615crenO40enVjVBPDKKewSKz71PHDHLzjp/YJ01YX/tgVQnH2uv3jJvpiOeEGrJ5GufHg0xfR7nl1c00yewlInkMBXlcX2dHNT90HT5d9aj5UZVIi4oNgI4Z+pDzXFbHxD57JB5oXTKKPXLlqUUcDYYo2s7alxSJMQHq4cPKTvvC9KO7JuxgtNNIeyY2AZiNG7rGqB3jgjLaYcO34+lg3KLRDOTHeGzus894DSxSgwQ77K4ZSKBV1M7ifFPxEwJwdWagFz7zUB5WdF0yR7iwby8S5UWGVJrKpAO2/IlHgpdJCzDsZt9u+OQyT78GO6soIG39k8ETtBzcNPcyjI7B1mHMksrGP9i7b8uoZvYgx2JvrZ2P1McsbSUqTibGAZsdEoQkhM0lEoaV2bnrts2bXA2naXgGjSO5pxWTQsuiSJRAsK7M6x9rII3tvHYFhlAyi0RwJJYjzMsNP0tVNPXhjMN2IUI9WBUvJCHwVyQ8x4dygmbmwUR6ikw6QnZAHXW7nKb51mLIu8XUzHTShBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(346002)(136003)(39830400003)(6666004)(6486002)(38100700002)(38350700002)(44832011)(5660300002)(316002)(508600001)(2906002)(36756003)(86362001)(186003)(52116002)(2616005)(6506007)(6512007)(26005)(83380400001)(8936002)(66476007)(66556008)(66946007)(8676002)(4326008)(1076003)(107886003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sl4zT6eI+HbzEJGQU8N0X4Y5sy4xXyEt0P0INN9ZknnrXPBOb27fsNKSgOdy?=
 =?us-ascii?Q?epwDe5/G+7dNgqNDPvqfxFgg6LD2LgoLnztxWN5B2QJBUdsnP9hL5icI8sTn?=
 =?us-ascii?Q?TyHSFJyvtjOXSWr+bMvtbHaRNutmOen//eX736JWAK9hnGxPDF7Eto2YS3SK?=
 =?us-ascii?Q?DR/bbkQURBtp83v13K5AZyS95nyJVSRNxfn9wLnpSkq4eNiwgcjD2VTqZ7o2?=
 =?us-ascii?Q?9IZR0Wbp/4BjMTKuRH6Co/IGPUmKBcfzjwdRKUyb/c3b9RLUSyWH7qo/Wr3z?=
 =?us-ascii?Q?IZd+ZCk75USwQXPgUNRjqXQybIpA9stQjcvJJRt8NLkc2epmi/DUac6oW0Km?=
 =?us-ascii?Q?Kdypzu8NPrZC+nqE/BxJDnEGZs1ckJHWuA1qV1NRq9/zYdwp4h+CKl3r0rVM?=
 =?us-ascii?Q?/P/ke1ihN1fza5KUSukAvNcq6YQomhF4WugBdYQ82LoXehRFNlo+w6jRtLOn?=
 =?us-ascii?Q?pgiPgF/rDk8TmwV/xoD33bAojU5GCqaQEE4x4KWXBa/0CmI2ZIpsHzdt4Uqq?=
 =?us-ascii?Q?zDlf+OJvN5HynnbFQYOjknz0pOhsDA62oKYhvxSROGz21G7hvkgFD2HIpOZ2?=
 =?us-ascii?Q?wRbc5wS50isXgsFJcVL0wPCYmOsdxCs0WAqt59R8OSVV6j/HRZVCo5WU4a6D?=
 =?us-ascii?Q?7WJCf4Gs2WYw6YOZ4rDnnU8fxfoeyw/l5tFmNCR+0mIRDrao5sG9ZbLy7gf3?=
 =?us-ascii?Q?Lf2nup6Q6aPUHeugN6+LDEsVhyJH9Gi7r1XEDRQEbEmI4lpz/v2MD+J3AgBE?=
 =?us-ascii?Q?uXv+mkvyEGA5Wb8gISADnHPctYoKmnWSAbUwh+pGaDlG6oFtC0r1tecpEmaJ?=
 =?us-ascii?Q?0G1JUyI1Gsg9aqAHHDMAlvhop8w3XbvOwZ+twFnj1w5iQU2uUGeSoaNd8VCY?=
 =?us-ascii?Q?bsw/JbrcV14WoPW+lt/Scr4cRM7kTpviXjWs6pBxpjpmluKJ9eX5Vugv9zxJ?=
 =?us-ascii?Q?5j+TFsdpxzhBUVsM2rqVu7WkCDdzt9aN/ONcJ9CAGC7g1lIWlaer/Fw5WFrB?=
 =?us-ascii?Q?z27ljMoVcDB3Wf+zZoPSHHz8hSGskhF4LTzhffuTojYSz0f5nZOuU++jtpBa?=
 =?us-ascii?Q?+rmXB5dZDokyAuBzNjDC/qhyb7ta7C9KDTvhTxLCKnJoAeWZrEdtU6bQnFs8?=
 =?us-ascii?Q?7UA95xLMb69v677TO3DTTOZeDw01UaKAiAjH2DiLcb/WNrq2SuLJUU/U9Wet?=
 =?us-ascii?Q?HrzS72zfebdx8xRnD3SFb8hm9zplNFw8+z3SpiK532jQDi9ZC8oE8rSR2RaB?=
 =?us-ascii?Q?LK9+QimKQMilSUd1EW+RsVBQlERVskPLz3M0R9KG+lEm6ddiRtCKVoIdtI5T?=
 =?us-ascii?Q?RLQqgcz1/h7WLw9leVlMO8ERtkC69D1yimY1Z2oqgVq7obr4y2T58Saw30JP?=
 =?us-ascii?Q?Nfc4NmpcuoCNyV3X9ATqnI1ULOMhtUOYr3pi7TFNrtuTDDDdxVk1ByAF2Xi6?=
 =?us-ascii?Q?ZZdj/SFd1HUgiLLLaGGJ/ANEYsgwT2yRq+ntRUK7Z64spQyl52pB+79rfLnF?=
 =?us-ascii?Q?9S+21SlF65BSyBHvp4yzCyeu06U4AeMuk5J+jXsNz1z8iitQ8/hfHYmCThRW?=
 =?us-ascii?Q?JlHpAfbV4SogsZK1lExPC9aWMmG5sqt/EhepKeKa0HE7bt/tks/vzu5r8gmn?=
 =?us-ascii?Q?LHe79BVOsW0aIBStY3eUOnNMdQgJ63V10bAp7H0fwu2G3qa0u23BcrH1HM1A?=
 =?us-ascii?Q?ydo5sUriXxcqHfciWNnrN0mKYFTZVS61LfUsm12Z+VUrrvi8SI0Q3yS88kAh?=
 =?us-ascii?Q?mixU6ZasJvm3Zfo5dAZYa5oB8t9jHhw=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c8fe05-352f-4e0c-2142-08da2e5a499c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:14.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FppAl52WoUFznMphKXmNuGHGFNu7g9DoCilrzjT7KcqtUc3V7fmLEgjLv4TQ9ahBUfxQtBNHc6LEkRQU4jZpKwZbQbyDrxerO7DbEMS6FGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

With the neighbour entries now stored in a dedicated table there
is no use to make use of the tunnel route cache anymore, so remove
this.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  |   8 -
 .../netronome/nfp/flower/tunnel_conf.c        | 175 ------------------
 2 files changed, 183 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 6bc7a9cbf131..66f847414693 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -87,12 +87,8 @@ struct nfp_fl_stats_id {
  * @offloaded_macs:	Hashtable of the offloaded MAC addresses
  * @ipv4_off_list:	List of IPv4 addresses to offload
  * @ipv6_off_list:	List of IPv6 addresses to offload
- * @neigh_off_list_v4:	List of IPv4 neighbour offloads
- * @neigh_off_list_v6:	List of IPv6 neighbour offloads
  * @ipv4_off_lock:	Lock for the IPv4 address list
  * @ipv6_off_lock:	Lock for the IPv6 address list
- * @neigh_off_lock_v4:	Lock for the IPv4 neighbour address list
- * @neigh_off_lock_v6:	Lock for the IPv6 neighbour address list
  * @mac_off_ids:	IDA to manage id assignment for offloaded MACs
  * @neigh_nb:		Notifier to monitor neighbour state
  */
@@ -100,12 +96,8 @@ struct nfp_fl_tunnel_offloads {
 	struct rhashtable offloaded_macs;
 	struct list_head ipv4_off_list;
 	struct list_head ipv6_off_list;
-	struct list_head neigh_off_list_v4;
-	struct list_head neigh_off_list_v6;
 	struct mutex ipv4_off_lock;
 	struct mutex ipv6_off_lock;
-	spinlock_t neigh_off_lock_v4;
-	spinlock_t neigh_off_lock_v6;
 	struct ida mac_off_ids;
 	struct notifier_block neigh_nb;
 };
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index fa9df24bec27..9c37ed6943d0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -445,123 +445,6 @@ void nfp_tun_unlink_and_update_nn_entries(struct nfp_app *app,
 	}
 }
 
-static bool
-__nfp_tun_has_route(struct list_head *route_list, spinlock_t *list_lock,
-		    void *add, int add_len)
-{
-	struct nfp_offloaded_route *entry;
-
-	spin_lock_bh(list_lock);
-	list_for_each_entry(entry, route_list, list)
-		if (!memcmp(entry->ip_add, add, add_len)) {
-			spin_unlock_bh(list_lock);
-			return true;
-		}
-	spin_unlock_bh(list_lock);
-	return false;
-}
-
-static int
-__nfp_tun_add_route_to_cache(struct list_head *route_list,
-			     spinlock_t *list_lock, void *add, int add_len)
-{
-	struct nfp_offloaded_route *entry;
-
-	spin_lock_bh(list_lock);
-	list_for_each_entry(entry, route_list, list)
-		if (!memcmp(entry->ip_add, add, add_len)) {
-			spin_unlock_bh(list_lock);
-			return 0;
-		}
-
-	entry = kmalloc(struct_size(entry, ip_add, add_len), GFP_ATOMIC);
-	if (!entry) {
-		spin_unlock_bh(list_lock);
-		return -ENOMEM;
-	}
-
-	memcpy(entry->ip_add, add, add_len);
-	list_add_tail(&entry->list, route_list);
-	spin_unlock_bh(list_lock);
-
-	return 0;
-}
-
-static void
-__nfp_tun_del_route_from_cache(struct list_head *route_list,
-			       spinlock_t *list_lock, void *add, int add_len)
-{
-	struct nfp_offloaded_route *entry;
-
-	spin_lock_bh(list_lock);
-	list_for_each_entry(entry, route_list, list)
-		if (!memcmp(entry->ip_add, add, add_len)) {
-			list_del(&entry->list);
-			kfree(entry);
-			break;
-		}
-	spin_unlock_bh(list_lock);
-}
-
-static bool nfp_tun_has_route_v4(struct nfp_app *app, __be32 *ipv4_addr)
-{
-	struct nfp_flower_priv *priv = app->priv;
-
-	return __nfp_tun_has_route(&priv->tun.neigh_off_list_v4,
-				   &priv->tun.neigh_off_lock_v4, ipv4_addr,
-				   sizeof(*ipv4_addr));
-}
-
-static bool
-nfp_tun_has_route_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
-{
-	struct nfp_flower_priv *priv = app->priv;
-
-	return __nfp_tun_has_route(&priv->tun.neigh_off_list_v6,
-				   &priv->tun.neigh_off_lock_v6, ipv6_addr,
-				   sizeof(*ipv6_addr));
-}
-
-static void
-nfp_tun_add_route_to_cache_v4(struct nfp_app *app, __be32 *ipv4_addr)
-{
-	struct nfp_flower_priv *priv = app->priv;
-
-	__nfp_tun_add_route_to_cache(&priv->tun.neigh_off_list_v4,
-				     &priv->tun.neigh_off_lock_v4, ipv4_addr,
-				     sizeof(*ipv4_addr));
-}
-
-static void
-nfp_tun_add_route_to_cache_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
-{
-	struct nfp_flower_priv *priv = app->priv;
-
-	__nfp_tun_add_route_to_cache(&priv->tun.neigh_off_list_v6,
-				     &priv->tun.neigh_off_lock_v6, ipv6_addr,
-				     sizeof(*ipv6_addr));
-}
-
-static void
-nfp_tun_del_route_from_cache_v4(struct nfp_app *app, __be32 *ipv4_addr)
-{
-	struct nfp_flower_priv *priv = app->priv;
-
-	__nfp_tun_del_route_from_cache(&priv->tun.neigh_off_list_v4,
-				       &priv->tun.neigh_off_lock_v4, ipv4_addr,
-				       sizeof(*ipv4_addr));
-}
-
-static void
-nfp_tun_del_route_from_cache_v6(struct nfp_app *app, struct in6_addr *ipv6_addr)
-{
-	struct nfp_flower_priv *priv = app->priv;
-
-	__nfp_tun_del_route_from_cache(&priv->tun.neigh_off_list_v6,
-				       &priv->tun.neigh_off_lock_v6, ipv6_addr,
-				       sizeof(*ipv6_addr));
-}
-
 static void
 nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 		    void *flow, struct neighbour *neigh, bool is_ipv6)
@@ -628,19 +511,6 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 					   neigh_table_params))
 			goto err;
 
-		/* Add entries to the relevant route cache */
-		if (is_ipv6) {
-			struct nfp_tun_neigh_v6 *payload;
-
-			payload = (struct nfp_tun_neigh_v6 *)nn_entry->payload;
-			nfp_tun_add_route_to_cache_v6(app, &payload->dst_ipv6);
-		} else {
-			struct nfp_tun_neigh_v4 *payload;
-
-			payload = (struct nfp_tun_neigh_v4 *)nn_entry->payload;
-			nfp_tun_add_route_to_cache_v4(app, &payload->dst_ipv4);
-		}
-
 		nfp_tun_link_predt_entries(app, nn_entry);
 		nfp_flower_xmit_tun_conf(app, mtype, neigh_size,
 					 nn_entry->payload,
@@ -654,8 +524,6 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 			memset(payload, 0, sizeof(struct nfp_tun_neigh_v6));
 			payload->dst_ipv6 = flowi6->daddr;
 			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6;
-			nfp_tun_del_route_from_cache_v6(app,
-							&payload->dst_ipv6);
 		} else {
 			struct flowi4 *flowi4 = (struct flowi4 *)flow;
 			struct nfp_tun_neigh_v4 *payload;
@@ -664,8 +532,6 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
 			memset(payload, 0, sizeof(struct nfp_tun_neigh_v4));
 			payload->dst_ipv4 = flowi4->daddr;
 			mtype = NFP_FLOWER_CMSG_TYPE_TUN_NEIGH;
-			nfp_tun_del_route_from_cache_v4(app,
-							&payload->dst_ipv4);
 		}
 		/* Trigger ARP to verify invalid neighbour state. */
 		neigh_event_send(neigh, NULL);
@@ -734,11 +600,6 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 	    !nfp_flower_internal_port_can_offload(app, n->dev))
 		return NOTIFY_DONE;
 
-	/* Only concerned with changes to routes already added to NFP. */
-	if ((ipv6 && !nfp_tun_has_route_v6(app, &flow6.daddr)) ||
-	    (!ipv6 && !nfp_tun_has_route_v4(app, &flow4.daddr)))
-		return NOTIFY_DONE;
-
 #if IS_ENABLED(CONFIG_INET)
 	if (ipv6) {
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1557,10 +1418,6 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 	INIT_LIST_HEAD(&priv->tun.ipv6_off_list);
 
 	/* Initialise priv data for neighbour offloading. */
-	spin_lock_init(&priv->tun.neigh_off_lock_v4);
-	INIT_LIST_HEAD(&priv->tun.neigh_off_list_v4);
-	spin_lock_init(&priv->tun.neigh_off_lock_v6);
-	INIT_LIST_HEAD(&priv->tun.neigh_off_list_v6);
 	priv->tun.neigh_nb.notifier_call = nfp_tun_neigh_event_handler;
 
 	err = register_netevent_notifier(&priv->tun.neigh_nb);
@@ -1575,11 +1432,8 @@ int nfp_tunnel_config_start(struct nfp_app *app)
 
 void nfp_tunnel_config_stop(struct nfp_app *app)
 {
-	struct nfp_offloaded_route *route_entry, *temp;
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_ipv4_addr_entry *ip_entry;
-	struct nfp_tun_neigh_v6 ipv6_route;
-	struct nfp_tun_neigh_v4 ipv4_route;
 	struct list_head *ptr, *storage;
 
 	unregister_netevent_notifier(&priv->tun.neigh_nb);
@@ -1595,35 +1449,6 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 
 	mutex_destroy(&priv->tun.ipv6_off_lock);
 
-	/* Free memory in the route list and remove entries from fw cache. */
-	list_for_each_entry_safe(route_entry, temp,
-				 &priv->tun.neigh_off_list_v4, list) {
-		memset(&ipv4_route, 0, sizeof(ipv4_route));
-		memcpy(&ipv4_route.dst_ipv4, &route_entry->ip_add,
-		       sizeof(ipv4_route.dst_ipv4));
-		list_del(&route_entry->list);
-		kfree(route_entry);
-
-		nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH,
-					 sizeof(struct nfp_tun_neigh_v4),
-					 (unsigned char *)&ipv4_route,
-					 GFP_KERNEL);
-	}
-
-	list_for_each_entry_safe(route_entry, temp,
-				 &priv->tun.neigh_off_list_v6, list) {
-		memset(&ipv6_route, 0, sizeof(ipv6_route));
-		memcpy(&ipv6_route.dst_ipv6, &route_entry->ip_add,
-		       sizeof(ipv6_route.dst_ipv6));
-		list_del(&route_entry->list);
-		kfree(route_entry);
-
-		nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6,
-					 sizeof(struct nfp_tun_neigh_v6),
-					 (unsigned char *)&ipv6_route,
-					 GFP_KERNEL);
-	}
-
 	/* Destroy rhash. Entries should be cleaned on netdev notifier unreg. */
 	rhashtable_free_and_destroy(&priv->tun.offloaded_macs,
 				    nfp_check_rhashtable_empty, NULL);
-- 
2.30.2

