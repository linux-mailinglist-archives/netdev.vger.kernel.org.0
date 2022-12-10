Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5680648F4E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLJO6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiLJO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B91706F
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:57:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6XmCEt7mwApgoKRFYLnxJYHy9q+W+Vwu1Ikk5Ak6bCpdJVkRd4GOH/+6X0UhTNFeEeVRoCpScLINxfC/1LeTU50xk+WybhAh831KJtO95ONblN3rOw8NN2WtLLAl1do9bEfIw9fZN011HjW3TA8GQmdRO7FkHqX7g8orCw282RGS+WSQejD1bJ8WsGrEafurrEJ3nFvzchwtapmGrunEBTWzyy8QH1HZ88sxaGqu1pA7CMCFrOQ1od5m5qwA0lanczg8kG1H0mr+SJDM2ZuGw0GE+HahFzOB0wc/N+ALqnHAKghYfQo+xewXmAQXCUYhNwDePBjslbERANkuspTIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvCiINSgInnpIymRGCEhRqVBUTuaGlTHULAaBfYIF2M=;
 b=QxuxWPPL4QdJRy10jj/uNKfSD25vAMlO1zsP7dEBaNE0IUBuTBHStIXYNj+X1C80K7iZixbr+QNwCyTMiA0Vz9BDJRltZXrDTb4IE/EgSUriPg2dyTu+ZRs76p8aWX+E9d3hSA9SMmd2EueWGQv0N524byS9jS14pznDHx0R1wvr3GeszsmpWspcP0DQFFg7rw/sp+9R1BWCv67xa541M6gr3S1LEdoC66RwDPf3cCRKegM+V68rUv1styPKfA+EpRUC3gzQODMGTAbOJ7O+NzxqODvywpOrgq2bwxB0RBauIsYG/6Wp+WCIsMIDTCy1GFHzEA8Qv9Gk+h1rtR+L/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvCiINSgInnpIymRGCEhRqVBUTuaGlTHULAaBfYIF2M=;
 b=e5/1XUw27ciuZ4Ef3a2cZfUd9B2XtpgMdJSYDsxPteWQDn28AcSYZX6wlKCRbBEjl+WXVgjhgI0xoETOWOZZPBcyrjWf864VCojN00VUmshR/NUbJswfa6muhi8vpVFzHJTkwef0p4xDnf5uIy/P6FktCCy22pCtl1GyPBCsCH4sp51vnV9GpkEZk+tGgK0LSXI2VVrcx4mHI8bTZgu6epUYBaAU0ulYHdLI0CYX7fE7TAlQe6uiBkQj7caUUe2bVrgubI8qsnQYn52+rmqGa4RTsvGpKPO82o0Daj4CNsx9H57t4ktoEMuaQfoLciHjMrCd4xdQVj5/U5WyTkZIxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:57:56 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:57:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 06/14] bridge: mcast: Expose __br_multicast_del_group_src()
Date:   Sat, 10 Dec 2022 16:56:25 +0200
Message-Id: <20221210145633.1328511-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0210.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: c977ed35-c83c-4389-8b9a-08dadabeebe2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EftOba9gGrGvlJ1SrA1OzlTebGAr5o3psJ4DwKL3rKIqShDvnFbS9d372SeSXFoZtLw0DVk4Na+boQ8BsPhYfppmigntXZnIe7TqW8h33c7+WssjBbHTL26vWOyGmnUzAdAR90YsK7228NHP+Z7jp7Czeyn7CtAssed2KcvMuMhS3DCFsFHEa/bTXzdQ7xIJQdfYotaSJnpql8iDksNABHfonW+nP6v+6+7doZ/BDX0ww3zdWi/fBFXCO+Q+yBbHCtlJp8bpFm2FXSXztqzSxQQp8xyq+iKV4mTZ8jJ8fIdzNHT8xg8YutxQoaYV/mx6b5QPZLDjF3aJUN+LEikOKTo9YG86v3+ePG5dRuCpFj6HfyAENYy+On4deaZtgec9Lrte5MEE+/xFTa4yCWxu+4v6hGO6riknwUg0w1c2wm1dJtVO9R9rmmKCXlVAD6XWV6pdPX1SY4yLHOhAhopeamzRTuuOKU8Dg/6oYdmuQ9PgPN5ItRXalfcTAID6n0iM4xi6A74lAk0IOzt2b5wZ0tmyPbumBOXLlWK8khAnbIzxLzecSMtmbVo5IHEPfhrf4IClqHCPSYQBUvPjFQX0q+/laZQyrSv0cdoVEWtsPvZJHqkTRE1JoK7pK1RFyR0+79eR/UkDsQcR6XFoij/n3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TL+ULLHfVMfAXaOTzVpKefn7ih9wLz2x17OnKEEzZ9wzXqiGYL+OUkSXjzWn?=
 =?us-ascii?Q?/ts1bi6wyxsRRqsM4nOe9znFfPwd7pT/uNUptBQnBQS14wTUKhHwvFGut8yD?=
 =?us-ascii?Q?bb+FfN1upo9GFoz4U1Eq71oq0AVc5PBaQ3udhsPWWjAGkNIZsqrzCFTYt4if?=
 =?us-ascii?Q?LC3biZyjxNi68Z/GM/pLlk8yiQM5CHtaq4TzNwyPWNLo5LClzlCBN1PdqWtQ?=
 =?us-ascii?Q?2U6wkltHjlfmYbrLg7ODDbSUqrMI3HhPcH4HxxUPU5NNX9rRgtOAuFoGpFbW?=
 =?us-ascii?Q?pS+PfnSJIF49Akx83ZymZyFUOGxSvz0zz3LrCSre2o70GEQiqE4yWZkuvfVN?=
 =?us-ascii?Q?VASSYfk9Es7XwI4UorYOH+JR+ri4GRtbMri4c8lKSbbsPhXZ9B9Tn3Zb5mi5?=
 =?us-ascii?Q?BDRM71BV/eiDLNky1Vw6LY3+E2NnOtV7Z2ySeZvwYLmaaOLgYDJQ4zxYIlLt?=
 =?us-ascii?Q?IweJjCpa95KZaVLFxcYljYTSwLjUYph8I7swehMx6Yf95TPdvzZGrbH04cBF?=
 =?us-ascii?Q?x2e7DJMeL/8f+0g33lFzrin2btcv82S9J95kGFz7KvQhzHBmVRQA55gwJVdm?=
 =?us-ascii?Q?7nw6/u4wW1ZYxqtmofldVt4j1f312X9EDfDKtiRW37bgqS4rLCQS0LvX3GtI?=
 =?us-ascii?Q?uVQe9rFELvvgjdW8IFEGGmL7M9Sux6tkmZAvqb9j/Sw6zGo6g+smWo4rW/ex?=
 =?us-ascii?Q?RshO1sPk4tgeMD6NsOC3LCSpWVWP4fpaeFCYFfH4bEac5h1TaUBO1gV/02ki?=
 =?us-ascii?Q?IYkLZJUID6K/+SF+emF3+kVJfBVWa3KPxEZ8PcTkpjsx07+jpewC7q1/cvAr?=
 =?us-ascii?Q?jBbJZpZYcXI/6sOONw0flF2DL77m4eB9h63Z0B2niwNoQ9RLRtPqYRXKQNA8?=
 =?us-ascii?Q?6gHCc8Ha/BYXEfzg/gkskiiHUi5Jp8n9lRln0CDgqEZB1pJHNTUslbQOqeRy?=
 =?us-ascii?Q?77EE8z+2v9s3gXIjh9xSopzdXZVC7AuUYUarcO8Judx0rtiEhlQF8ffqcFD1?=
 =?us-ascii?Q?VywWru1BmgF60c0DI2JY7Du7CW6pzDzwYW4pMelHwwWVr5bMrSv2vE/0789M?=
 =?us-ascii?Q?/+Rhipppl0luS9BPxXWAWoCKOrK9ADnP3xC2CnSalu/VbRGZhnO3FHn/oJWI?=
 =?us-ascii?Q?6X4BUxOFb8sf9Wj6zTRH2BMMWTCDj9WmAO2/0ie/emVryS1EzssXilJxlN6S?=
 =?us-ascii?Q?52EjaIl8vyilzh+YqBUd1r5cQLr/ypZoG0VzrdoF4EsanSGYOqJg0tuV3cVQ?=
 =?us-ascii?Q?vT6aogoaGg249ZxgdoZt5yEAhQDPUpjiV6FmgDsGMy3D0JRF/5xavQvQlBOL?=
 =?us-ascii?Q?xL9duloD2Zch/bC5ImYDa/kV0bwkWOHkyH6gV5drqA0ByKdlOsP7ABzssCpY?=
 =?us-ascii?Q?6o4Zec3nDteQrKX0EepgphkEFCKZXNDiCy5UBkMC9aYPz/9PT2feu3JFRdbU?=
 =?us-ascii?Q?xZ2fFsqVRLCeomK4o1jScin1k64KoHlPSynGb3XLtieK5frWDJLvIfR+pUaO?=
 =?us-ascii?Q?lrBgEFk+Uc3cVmSBH6oT7COwP08lxb1XTQr8ftfxQTEGBIQTaeGW2BHJcRAQ?=
 =?us-ascii?Q?z31oZneNtu/9yQwg+ERBSgc/5i7nZAhHFeDSfxSO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c977ed35-c83c-4389-8b9a-08dadabeebe2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:57:56.4667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJrmCEKUtN3VFKlw4w0g/UAHP/XDijKi2KnomHkkAKOX+7Xsn8EpCS+5D23cJxj4xUWTMyYNhHlLbtgMs5BijA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
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

