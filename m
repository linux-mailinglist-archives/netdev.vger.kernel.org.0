Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F406ED229
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 18:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjDXQKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 12:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjDXQKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 12:10:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F67E83DB
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 09:10:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COMhF3b1m8/xnBkEXCJMBWl70cD4g5aB8uOmkoy28+DounZhGEeSktxGHmyKero/iMYSBgBXqcfohFKRCnmHKy8ECISw3otfPM6NVisv2IWu9g6n9+xYRJjKeP4gHcw02yeKqBMHbyPNPJhDm4iAlLfHQKsO1d8SiN8MGdC8IVcGCDIJLfe32n2k+2hgOuj7Bth0sXMHGJcU3wouRRdtOWYo/41nhK9PfGuFKiuS6C5uiWk+t6DRoOGTXlytt8adr+nOTJqItAWvnMoggwE7oNiDfu1lusoN1YaLPdIy6u4NMcUNt9zeglR5wXdoTn/5UcuUGU/AUKmu/0R0KMVaAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dR4cYxxiMXrkAP8z+JS5WavRAs6c640bwFJzA0kxt9E=;
 b=EzosKGiUz/rlefAS/oxLlpX7S4dY2e55xmER+7niFv21waiS79C/HbMDAC4ld5+mx6AIsSttZnMx44mZg1npfq8zjuE3L9f7d+tDYDTnGlR1JWLSFANd8hhDmM2PLJlGJd1mX5uhzIzN+HZZ5dp9BW7ABlBW3rsW/otDFt8IHsvWK/XMqDscslrvukBZk9ZyC0rgMtH9uVJHYNJtefWCV4HGyQoxntcQeVo1Rg3mYmRT4aBneVDCS+XURrZhrn2YBjGHBUtPDMr2TmvDzTXOPq8XqSdALeXX8G/Y7rEM5UgrYP43CEsAiLUuXI1rseatsJ/LfW70kFyGhWiWUldumQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dR4cYxxiMXrkAP8z+JS5WavRAs6c640bwFJzA0kxt9E=;
 b=DRpg0zLU+Go7PwCsjkJIwI25op/UxyAcM4XqSxTXb1WpJnNUo7yYcppiHA397aleQmxj9Hx3/o5utecdo6kiUY2WHHorwrn5qb6dnGPF9QUi/Tn1PYYJqo3NXUv+r68qXOrJVVcpHR+wuQFAj4gb5t6Njo+yZm6Q+ggB+1E9TOeHezD+ieCZ2/WbHRDfzlav5CxLo77CYBBA2muedtafv6ZW+f4Cb81R/0z8IJZQgazjeOP1OVwssH71t/iJn0ZUXfIYYrCMSbOwqD968hQr8xL5WTU0O8Jff2NmsOiCZR0YvFXO/JHQ/MMp+P3xGghOjeEOeNixJURNLcdgiHtJ/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:10:30 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%3]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 16:10:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, razor@blackwall.org,
        liuhangbin@gmail.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 2/2] bridge: link: Add support for neigh_vlan_suppress option
Date:   Mon, 24 Apr 2023 19:09:51 +0300
Message-Id: <20230424160951.232878-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424160951.232878-1-idosch@nvidia.com>
References: <20230424160951.232878-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0085.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7d63d2-2a8f-45ed-e41e-08db44de6cd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9HbQTxHX0cZ+rCxAFMf7adD/2DGt/rS5kmXec1ipxxFcQ3VfnHDIuuDsfrdFEpjprXB7rAGQvk+RoAbyYTSIcL8fGpxyGefbcCins36Ofl0O06ryEjfpF81v8uXwoYPE+qSIHfcFcib4IZ6IgZ/xZ5F+OVGbMUuIIfQ4xFRy/5DB0EEuB3027+9+HTYjp3QvpKkZzA3l1Wd+QGTQB8J7DeIby7Jo5qHo/ULopIeyZ47JWVmQaqrccCqNkhmjkfBw+TDJs2jki/T3Q3SKwiyYg4r2+2zynjO2vwe+PoljYiR6QGmNtA3Kg5rFepGfzYgc5j9FBMmBQ8IW7ceUhLeEAqfB25qqt0s6sjgKMHSGb41hZK46atcANv3iCbDT3jUH5tEHGNKTwYef9fM8KkPFX7izEMZEvEl/JZ3Hk3MwC+5zz7l3E0xHsftUH3SUSIWyNdpgtrdPGlWzLnmkIWKRL+Xt7kmTC0y7CsrBWhTAFpuadJaiCQUdTJMju13CumF9PuqO+Hd0tf+JEPxvacVsBu4vcCyToURhMrhyN7DkKvl5ESyukCMskaRDXWt1i4I5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(36756003)(478600001)(316002)(4326008)(6916009)(66476007)(66556008)(66946007)(41300700001)(2906002)(8936002)(8676002)(5660300002)(38100700002)(2616005)(6512007)(6506007)(1076003)(26005)(86362001)(186003)(107886003)(6666004)(83380400001)(66574015)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zIRjH8plfYvikP8BxPGkGbR9z8N/fN2k1ERbCocHL57fZbABe0FJIT+Uu7zh?=
 =?us-ascii?Q?YaRB5ZiAb+kDLoWhki+Iv0yqGiLzqoVbnsPwGu13j35D6hcRADSKs2v5tr2l?=
 =?us-ascii?Q?91TeQoV/Fd3NoZSubza9sBvBIayG3lpeTZWza5Br86SkLxtnMRguCkdS77tN?=
 =?us-ascii?Q?If1ui65ecTJgkWT0wAtUmBrva3CLHJkPDfqxN92wQJuxhSnWCz4SjX2uSAZA?=
 =?us-ascii?Q?f19ce4vbisKENWKNN6pwjSAqrdrJhQN6gkjjJooL2zPWI4ZA8nj8j07uDYqj?=
 =?us-ascii?Q?s40cJvHK8d+dCM0S8cMtq0emXWZ8iBxI/1MCFdI48T2IhQTRVcf4bpFCBb9X?=
 =?us-ascii?Q?lrMrV3EhfRb3YrGuaWK2YcaZH0vH3j8dh1fOaxXnHMA0Wi/0WZB1EGpvfxnw?=
 =?us-ascii?Q?ecxVWv+bzmzaRX5FFrJprCJRjHS7C5cZaPmrBlPBwSvmqHb2KsFri1/EU9I1?=
 =?us-ascii?Q?dBR1hLYHRADP0dzmrwPUv6BCrNWEqKyZiZbJ6OulwS3Z7VLiF3IoQQ4/cHkz?=
 =?us-ascii?Q?SztwR0japxjzGlxdSGZCFVD000cOUteig6NTUTmPBLqWn23h8fDPom0TH6+Q?=
 =?us-ascii?Q?bespQGrQ0yCfxEdmyNctbLRIhmpE3brN9pRDHqiynMFf8mZr5IRwlrulOKHl?=
 =?us-ascii?Q?Y02IUEAGlERvfYF4MagtdLkioBWkILchY25jwPtCfZxYBC0IKTDQsOMFMKy5?=
 =?us-ascii?Q?vG/NjsErFgEvgjE78nMsaIiKFilP1Rg4TfE9LRSScnzA7p0dhD+a9Azna6Ft?=
 =?us-ascii?Q?3Ue1/XrErN8ZS//WdKC5CKGtPp0ezScQhnDyk9/yo3zWSNtby6eUZWdXU9uJ?=
 =?us-ascii?Q?StrbnUwqltn356u0CZiZMHjKMUThSDXrY356z1zoebH4zJRYXE636fri5NY9?=
 =?us-ascii?Q?zpy66FwbYK6/ED3GbdLt8YP825P/sqmNi0RvJPPWhUccZL8Jx8lIwIsHlM1N?=
 =?us-ascii?Q?te+F6oubmBvJCnwIvT5PKpHkU50U/oxurBtVY9/TKpDlDmyPnsYwuO4zeH0Q?=
 =?us-ascii?Q?OhTYBk9+btimyM1XTX8qzyDHYC3TF3CVP331RVLkNpOkx8y/UHJVm7JH9IP4?=
 =?us-ascii?Q?jarfGIMbxk7iXCbS2HUzRpISuX3SAtPD3Xmt2eTrJJRXmU0k3bQr7X6BWaN7?=
 =?us-ascii?Q?kDCBiEzEngco4d9YBQhhrsqzX6aqb+7YPlNf3bqN2/ldDBlUflyNqCvVCR+K?=
 =?us-ascii?Q?TQU7uF6LMKh3Wvm6tX07aaP0atwUZncULoo/2GgDO8K1G0hg/VX/tCuaMonv?=
 =?us-ascii?Q?Kv4H8kdsPuRdNHoKMkLk6d8mgcVzdQFNTFrLx50tExaXO6fuKlF0tYAd1S+5?=
 =?us-ascii?Q?kcYiOhOU903HmvS+XfPm+B1FlGdkYd8i1sJtNpbI0rohY9eSyDH4djj9nwh8?=
 =?us-ascii?Q?vxzb9TUmEcfv5vTReQaaxZz5NtZCUU/htdV/oFRWAOhelpZB46MClWrabAZB?=
 =?us-ascii?Q?Ps5qwB6kYGLSscSswPLCB6oLwyHWpGk2T2e8aof7EZqWUm21Qz4ZpDgRgM2A?=
 =?us-ascii?Q?QJHYJjCp5ZwR4qqfVl+hmmo+QvbCwozlPcaUgfoXIyhiupGTKzvWIqkDK+kg?=
 =?us-ascii?Q?mEvQlGlgCZUpidVelp4KneKlaS8aWU1YDtV4YSKm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7d63d2-2a8f-45ed-e41e-08db44de6cd2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:10:30.4821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuzPDCU6uB6EMjNAMbxUTDpva3ja+tJ+UdhHkJ0R3wnpqki6yD0x+5mpVmlT6yXd6SBjDiRdy2pfhankyQEGRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the per-port neigh_vlan_suppress option. Example:

 # bridge link set dev swp1 neigh_vlan_suppress on
 # bridge -d -j -p link show dev swp1
 [ {
         "ifindex": 62,
         "ifname": "swp1",
         "flags": [ "BROADCAST","NOARP","UP","LOWER_UP" ],
         "mtu": 1500,
         "master": "br0",
         "state": "forwarding",
         "priority": 32,
         "cost": 100,
         "hairpin": false,
         "guard": false,
         "root_block": false,
         "fastleave": false,
         "learning": true,
         "flood": true,
         "mcast_flood": true,
         "bcast_flood": true,
         "mcast_router": 1,
         "mcast_to_unicast": false,
         "neigh_suppress": false,
         "neigh_vlan_suppress": true,
         "vlan_tunnel": false,
         "isolated": false,
         "locked": false,
         "mab": false,
         "mcast_n_groups": 0,
         "mcast_max_groups": 0
     } ]
 # bridge -d link show dev swp1
 62: swp1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 100
     hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on bcast_flood on mcast_router 1 mcast_to_unicast off neigh_suppress off neigh_vlan_suppress on vlan_tunnel off isolated off locked off mab off mcast_n_groups 0 mcast_max_groups 0

 # bridge link set dev swp1 neigh_vlan_suppress off
 # bridge -d -j -p link show dev swp1
 [ {
         "ifindex": 62,
         "ifname": "swp1",
         "flags": [ "BROADCAST","NOARP","UP","LOWER_UP" ],
         "mtu": 1500,
         "master": "br0",
         "state": "forwarding",
         "priority": 32,
         "cost": 100,
         "hairpin": false,
         "guard": false,
         "root_block": false,
         "fastleave": false,
         "learning": true,
         "flood": true,
         "mcast_flood": true,
         "bcast_flood": true,
         "mcast_router": 1,
         "mcast_to_unicast": false,
         "neigh_suppress": false,
         "neigh_vlan_suppress": false,
         "vlan_tunnel": false,
         "isolated": false,
         "locked": false,
         "mab": false,
         "mcast_n_groups": 0,
         "mcast_max_groups": 0
     } ]
 # bridge -d link show dev swp1
 62: swp1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 100
     hairpin off guard off root_block off fastleave off learning on flood on mcast_flood on bcast_flood on mcast_router 1 mcast_to_unicast off neigh_suppress off neigh_vlan_suppress off vlan_tunnel off isolated off locked off mab off mcast_n_groups 0 mcast_max_groups 0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/link.c            | 19 +++++++++++++++++++
 ip/iplink_bridge_slave.c | 10 ++++++++++
 man/man8/bridge.8        |  8 ++++++++
 man/man8/ip-link.8.in    |  8 ++++++++
 4 files changed, 45 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index 9dd7475d6e4a..b35429866f52 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -165,6 +165,14 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_NEIGH_SUPPRESS])
 			print_on_off(PRINT_ANY, "neigh_suppress", "neigh_suppress %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_NEIGH_SUPPRESS]));
+		if (prtb[IFLA_BRPORT_NEIGH_VLAN_SUPPRESS]) {
+			struct rtattr *at;
+
+			at = prtb[IFLA_BRPORT_NEIGH_VLAN_SUPPRESS];
+			print_on_off(PRINT_ANY, "neigh_vlan_suppress",
+				     "neigh_vlan_suppress %s ",
+				     rta_getattr_u8(at));
+		}
 		if (prtb[IFLA_BRPORT_VLAN_TUNNEL])
 			print_on_off(PRINT_ANY, "vlan_tunnel", "vlan_tunnel %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_VLAN_TUNNEL]));
@@ -296,6 +304,7 @@ static void usage(void)
 		"                               [ mcast_to_unicast {on | off} ]\n"
 		"                               [ mcast_max_groups MAX_GROUPS ]\n"
 		"                               [ neigh_suppress {on | off} ]\n"
+		"                               [ neigh_vlan_suppress {on | off} ]\n"
 		"                               [ vlan_tunnel {on | off} ]\n"
 		"                               [ isolated {on | off} ]\n"
 		"                               [ locked {on | off} ]\n"
@@ -322,6 +331,7 @@ static int brlink_modify(int argc, char **argv)
 	char *d = NULL;
 	int backup_port_idx = -1;
 	__s8 neigh_suppress = -1;
+	__s8 neigh_vlan_suppress = -1;
 	__s8 learning = -1;
 	__s8 learning_sync = -1;
 	__s8 flood = -1;
@@ -447,6 +457,12 @@ static int brlink_modify(int argc, char **argv)
 			neigh_suppress = parse_on_off("neigh_suppress", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "neigh_vlan_suppress") == 0) {
+			NEXT_ARG();
+			neigh_vlan_suppress = parse_on_off("neigh_vlan_suppress",
+							   *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "vlan_tunnel") == 0) {
 			NEXT_ARG();
 			vlan_tunnel = parse_on_off("vlan_tunnel", *argv, &ret);
@@ -544,6 +560,9 @@ static int brlink_modify(int argc, char **argv)
 	if (neigh_suppress != -1)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_NEIGH_SUPPRESS,
 			 neigh_suppress);
+	if (neigh_vlan_suppress != -1)
+		addattr8(&req.n, sizeof(req), IFLA_BRPORT_NEIGH_VLAN_SUPPRESS,
+			 neigh_vlan_suppress);
 	if (vlan_tunnel != -1)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_VLAN_TUNNEL,
 			 vlan_tunnel);
diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index 66a67961957f..11ab2113fe96 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -37,6 +37,7 @@ static void print_explain(FILE *f)
 		"			[ mcast_to_unicast {on | off} ]\n"
 		"			[ group_fwd_mask MASK ]\n"
 		"			[ neigh_suppress {on | off} ]\n"
+		"			[ neigh_vlan_suppress {on | off} ]\n"
 		"			[ vlan_tunnel {on | off} ]\n"
 		"			[ isolated {on | off} ]\n"
 		"			[ locked {on | off} ]\n"
@@ -261,6 +262,11 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 		print_on_off(PRINT_ANY, "neigh_suppress", "neigh_suppress %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_NEIGH_SUPPRESS]));
 
+	if (tb[IFLA_BRPORT_NEIGH_VLAN_SUPPRESS])
+		print_on_off(PRINT_ANY, "neigh_vlan_suppress",
+			     "neigh_vlan_suppress %s ",
+			     rta_getattr_u8(tb[IFLA_BRPORT_NEIGH_VLAN_SUPPRESS]));
+
 	if (tb[IFLA_BRPORT_GROUP_FWD_MASK]) {
 		char convbuf[256];
 		__u16 fwd_mask;
@@ -393,6 +399,10 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			bridge_slave_parse_on_off("neigh_suppress", *argv, n,
 						  IFLA_BRPORT_NEIGH_SUPPRESS);
+		} else if (strcmp(*argv, "neigh_vlan_suppress") == 0) {
+			NEXT_ARG();
+			bridge_slave_parse_on_off("neigh_vlan_suppress", *argv,
+						  n, IFLA_BRPORT_NEIGH_VLAN_SUPPRESS);
 		} else if (matches(*argv, "group_fwd_mask") == 0) {
 			__u16 mask;
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 3bda6dbd61d0..e05528199eab 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -53,6 +53,7 @@ bridge \- show / manipulate bridge addresses and devices
 .IR MULTICAST_ROUTER " ] ["
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
 .BR neigh_suppress " { " on " | " off " } ] [ "
+.BR neigh_vlan_suppress " { " on " | " off " } ] [ "
 .BR vlan_tunnel " { " on " | " off " } ] [ "
 .BR isolated " { " on " | " off " } ] [ "
 .BR locked " { " on " | " off " } ] [ "
@@ -590,6 +591,13 @@ only deliver reports to STAs running a multicast router.
 Controls whether neigh discovery (arp and nd) proxy and suppression is
 enabled on the port. By default this flag is off.
 
+.TP
+.BR "neigh_vlan_suppress on " or " neigh_vlan_suppress off "
+Controls whether per-VLAN neigh discovery (arp and nd) proxy and suppression is
+enabled on the port. When on, the \fBbridge link\fR option \fBneigh_suppress\fR
+has no effect and the per-VLAN state is set using the \fBbridge vlan\fR option
+\fBneigh_suppress\fR. By default this flag is off.
+
 .TP
 .BR "vlan_tunnel on " or " vlan_tunnel off "
 Controls whether vlan to tunnel mapping is enabled on the port. By
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 8cec5fe36761..bf3605a9fa2e 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2517,6 +2517,8 @@ the following additional arguments are supported:
 ] [
 .BR neigh_suppress " { " on " | " off " }"
 ] [
+.BR neigh_vlan_suppress " { " on " | " off " }"
+] [
 .BR vlan_tunnel " { " on " | " off " }"
 ] [
 .BR isolated " { " on " | " off " }"
@@ -2622,6 +2624,12 @@ this port).
 - controls whether neigh discovery (arp and nd) proxy and suppression
 is enabled on the port. By default this flag is off.
 
+.BR neigh_vlan_suppress " { " on " | " off " }"
+- controls whether per-VLAN neigh discovery (arp and nd) proxy and suppression
+is enabled on the port. When on, the \fBbridge link\fR option
+\fBneigh_suppress\fR has no effect and the per-VLAN state is set using the
+\fBbridge vlan\fR option \fBneigh_suppress\fR. By default this flag is off.
+
 .BR vlan_tunnel " { " on " | " off " }"
 - controls whether vlan to tunnel mapping is enabled on the port. By
 default this flag is off.
-- 
2.40.0

