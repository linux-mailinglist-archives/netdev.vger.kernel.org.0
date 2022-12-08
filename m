Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA076472F6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiLHP3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiLHP3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:29:39 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735E175BE1
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:29:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CX5WLbQpuSvJ+CU4F4f0Lh8rHGU3HskQjNH11RoNGsu00WJvsLU4ZYCkLYTJv+NPmfcs6p5FsyXxwCh1pReTV8DIyC7aRfeV+qxyLY9ncurDFKL+Q/stMiGsh7W9a0Kl1WMRwGGwnTbIxVSaxkkNNHtjdB6blWO7FUAWrpdacIrOqJrABcshFeSoHMetrrptoq4P7aTEJGPm+G0ScxBUVq/UVFoUbZWeOK7KVPVSdx4tTMvWVoK8tzPUI3JxshHWg7pod4icb4/pEtxX8SoSDZ8xkVnAnCNnoX0auhososKrlmn1+qe2PbUAJ1+FltZ3KFwmsjDMM6yJIiSttwlBmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PP7f+3IMbnf2HQwE4RvEho0oODh0ZQSUtULC6WZo7Lg=;
 b=JUZR7wC5WlHhQhM97yox/Sj/1tJthytebqqlLrrdDBR2FQ7oygxkz6CTy9JhTSpXV0LdjtG7fRtkbzPZn1TnEtheozO5VOattwUV57A7atbpSN556I1If5KD+sdSbCTeYgNgPjrZXa6MqDTB6pj2H96oSb7K0tvPeTscoFxNddG+ftxthI5VMRfgh2CQbN2++DRVmFiZ9YlVWVlGw/Hw7zWzS8Bdrfr/e4FpQF72x3sDiTrG8KivSzSkbsBe3XPMuGQ3GHDEw5Fg5OUNewY9c2XBjHzdj5txXPQwAM6Eh7TwS4zRYP9TEV9bXZfY/LgSHwv2fGdp49CBbjBoUVzb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PP7f+3IMbnf2HQwE4RvEho0oODh0ZQSUtULC6WZo7Lg=;
 b=Z02Nr9SXoMI5AkZY8i11gsMip6VVur+Bynh19XmSAPni9OdvQ6Y1/vDLUXAMMftGgCiX1r5csGfrdGdScrAHFn9eaeN7LE/uOPzVDxDBiP+i4gYfyimLcPFvCZR34cpvWZHSgKEJ23JiNR4rYRIUy+Qadeq35xHoB8+Qr2Y9ZOscBkiDnhKbhGKaFX6Ndbv+C6iqlHIzUkcVmuzw0mu+FGoqYCIK21OdCqxvP7RR/h7gSbvMLHTi/j8DCPOvNj9LolBh4o5x5Wk3XMUwctuMwPf0vYqJ1EHsD4LcVD6k/GbJZuxlXPOYgzHA66vyx0Cy4K0DAfIZ+FTYt/z6Wamkwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA0PR12MB8207.namprd12.prod.outlook.com (2603:10b6:208:401::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Thu, 8 Dec
 2022 15:29:37 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:29:37 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/14] bridge: mcast: Expose __br_multicast_del_group_src()
Date:   Thu,  8 Dec 2022 17:28:31 +0200
Message-Id: <20221208152839.1016350-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0038.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::9) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA0PR12MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: 08700fad-9675-4410-92ac-08dad93103d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBxy+qxOdl5AZ/XMBOLms5VuUCa/1hFtb5eSiJjWanVq2W2vv/1HbSjYc/6y5Rv4eRl7MEykMKHxUIdp4YN4qy0MINDEm5h3wsFTSsaWSKjKTGDV1Ka6ub+9H1T7P5CB1rSh6H0iacQX1NZdVuEkM9KqK42MLhdwmuSBmMrvtrnR6WGBJbbnHhvkzr6IhZi55YddywDFO+MqJQFGLNNmtgZHI/g1wmkX7+5nR6qRSeW4N6G/dd8Fj8C9nCSd8sb0/H2PYgZ8+YvjvfIDcdh+dY6n0JcMZ9WdWcUGfnS2zNigWg+EBcdHgRH1p+Izu6N29DL4epLJIT2Yxgq/e9fW60EVyITekze1DggZQQQbVzC3ukcclDof2eAm5qcAi5qg8zd+mUGo/59jiQP+1NyIcrXZwVS/2xfc0wgvi9XU/HelN3Y1kSZZx5Uj3+Lod8M14VNE8j0iS0HXxFUc6PEbsXXljk6+q6CFQmcTZ6LIysiYIfQ1FNXJs+yNjAoIDYDX+JSAy5ONa9v1+Ngn3yC3a7nxbcL51XGLTTBlz5AVWzIOyteJpZFj9yyfeWIG5R48xckPagjBf7avtk6myDnlJEEQ3cAVbCb7OM+Z5oY/aP1479W3vptbXYbRzvalUTN3x9H6TjCOe+wpssMDOmIGBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(2906002)(83380400001)(41300700001)(36756003)(1076003)(186003)(86362001)(5660300002)(38100700002)(8936002)(6666004)(316002)(6486002)(6512007)(478600001)(26005)(66476007)(2616005)(6506007)(107886003)(4326008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nbHWh64E/Rh6l5yJhDypW85QQ0e44+kakPQZ/04x+PE2CmarBjQYeFH+ZwjN?=
 =?us-ascii?Q?dup4r/zGFBCni1eJRrs7E8mp0+2USv+R/AhsHjuDpeZWXNzPAMKvglyjmrFg?=
 =?us-ascii?Q?r+pm6gKeN8C4NmNTJA3ibtju4OK/g686r1ABsexfmiXj1NxuWjpgvsbID9zI?=
 =?us-ascii?Q?ws0YbxngBAC26PwNxyllCjzMSOqaifMK8z6T/pAnej23J4W+CJyCgJA7YHtK?=
 =?us-ascii?Q?8v/pH3iZ6yNFk2woOKGcppcihzjJumQnOowyE4cUvfX8TfmVLjOhHCv0GGeq?=
 =?us-ascii?Q?3lCB6dY7Kg11bSpq71mPJvV3tefotlJrGjKzAZi/ORgP7hUXoZKHsq2udzPS?=
 =?us-ascii?Q?r/S2jhAEzGkQ6jWfOoYBYeqdEAdUcnCJG6i0833VpWt91yOsmXn0EE8pS+ob?=
 =?us-ascii?Q?y6M8VCtezUtXLC/RGCXrSmExdN5TN1oQCTCONd+70wrTL9kFU5YlhB+JI6an?=
 =?us-ascii?Q?u9wJXCf1k67GqxTeHFJJ7eTLJskEkCCpkmKjsR/E7AbDKre5x6x+7QJlARWK?=
 =?us-ascii?Q?/rF70ubVcVpqWYXadOA+YqCjvFwSz2qd4aFpn0whLzMUHl8iDdW3DwqnM/dv?=
 =?us-ascii?Q?z/zS+EfeDUkK+6elh+4Cms5hJ8cR7ycuCf7GocN5A7UFleLRRQDKno0OkBEq?=
 =?us-ascii?Q?2tIw1Zen6WcgIEOsN0bzjlSKqNtfGyzXXY9rcTUmqkqmj8P8SIC2D7+GvUyh?=
 =?us-ascii?Q?MFahg7cksytBpwE8zeDcrS4oqs9uMmVSz64InLYAwjn00ThLBjfHnckiFtnK?=
 =?us-ascii?Q?zHYf6AIUuzl+tVVCWB32bpQ/h47s0AtvsB5+i5th7TJScXdIowJ5IgYNxg09?=
 =?us-ascii?Q?zKyTPgh9RnjQkWrnYewoGcxuZJ9DR0rIvuodl1tQ//pN0erWBascJ9mNSzWR?=
 =?us-ascii?Q?3XL69iyMH/DsVSnRUwVnth9fS0hewxVAGvcTI3zktFQSyxBNCLoUFyzj8qRX?=
 =?us-ascii?Q?L0HZYq0/ycedkmUlGy9rOCJyaW9cOqVoWJXV1hNqsMU8oS+/w2y3iNC252ii?=
 =?us-ascii?Q?2YULBCa7OBw+zoWhjpNSmJUdFvxOOLB4dEuZsJILeNTsS78L36Plil0eeqZM?=
 =?us-ascii?Q?GcT+r/xHng40+DdH5HfFxjS1LYFGhdXRCbdIukxMH9kSxoOSleIU4NDq/rpJ?=
 =?us-ascii?Q?x0kDOzIcYWrZ4A9dnAPDN3OXkYY5Ck3pqa1h4MY7eHbzGyNyfzLOnDjbqZef?=
 =?us-ascii?Q?+MJrFOtIMJXyIaOgWcD+CfZVX4cs4TwAGjyvZVYh3ES5ZLdWn0VLSsrnJKaC?=
 =?us-ascii?Q?7ndndEeznrWNdbj+6dquxsGdRbLjVU/dWauzv6HF5lbsLxlKks4pzAmOGWPK?=
 =?us-ascii?Q?zIWwKt4Mqpi7Fy7JFoTxcgNtT/oIcTN3p2aU3WWVllIgLNfycvwcE6qRl/XN?=
 =?us-ascii?Q?ZvYhCpRyrixEgSqVt1kGRLuyJ0NjrPaKJl5IOAIQUvGUxApJik/DpQDZ2umb?=
 =?us-ascii?Q?xei/EjeT4j0VkASzQfxmXUNiQ2PvBHfd9XEWPiOhF606fTl9GooTXA/ZWSg7?=
 =?us-ascii?Q?qCJW7Ie/gXipfZPrEi0ZrX00NaZpwgVsWPb2mL9yKqnv3yaxlEg+wtHCvZTn?=
 =?us-ascii?Q?lQQQGFyRVzbcKSDQF13GhOug+sFMOaAVquFwB9TE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08700fad-9675-4410-92ac-08dad93103d0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:29:36.9159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrefQS0mFuwncvB3x6Dnd6Nqh5oej5EAlLq1RfmUXvLygEQ5TB46TXjwNHjjymhw4ae4N9vVa8Il3Tw6Pm7voA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8207
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose __br_multicast_del_group_src() which is symmetric to
br_multicast_new_group_src() and does not remove the installed {S, G}
forwarding entry, unlike br_multicast_del_group_src().

The function will be used in the error path when user space was able to
add a new source entry, but failed to install a corresponding forwarding
entry.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1:
    * New patch.

 net/bridge/br_multicast.c | 11 ++++++++---
 net/bridge/br_private.h   |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b2bc23fdcee5..8432b4ea7f28 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -650,18 +650,23 @@ static void br_multicast_destroy_group_src(struct net_bridge_mcast_gc *gc)
 	kfree_rcu(src, rcu);
 }
 
-void br_multicast_del_group_src(struct net_bridge_group_src *src,
-				bool fastleave)
+void __br_multicast_del_group_src(struct net_bridge_group_src *src)
 {
 	struct net_bridge *br = src->pg->key.port->br;
 
-	br_multicast_fwd_src_remove(src, fastleave);
 	hlist_del_init_rcu(&src->node);
 	src->pg->src_ents--;
 	hlist_add_head(&src->mcast_gc.gc_node, &br->mcast_gc_list);
 	queue_work(system_long_wq, &br->mcast_gc_work);
 }
 
+void br_multicast_del_group_src(struct net_bridge_group_src *src,
+				bool fastleave)
+{
+	br_multicast_fwd_src_remove(src, fastleave);
+	__br_multicast_del_group_src(src);
+}
+
 static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 {
 	struct net_bridge_port_group *pg;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 183de6c57d72..a3db99d79a3d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -977,6 +977,7 @@ br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip);
 struct net_bridge_group_src *
 br_multicast_new_group_src(struct net_bridge_port_group *pg,
 			   struct br_ip *src_ip);
+void __br_multicast_del_group_src(struct net_bridge_group_src *src);
 void br_multicast_del_group_src(struct net_bridge_group_src *src,
 				bool fastleave);
 void br_multicast_ctx_init(struct net_bridge *br,
-- 
2.37.3

