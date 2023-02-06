Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043F368C524
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBFRvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBFRvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:51:01 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472922E0E3
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:50:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOZ5+2nujUjlff0FL+N1shoWn6DOBnpYtIZHC8tL4VN7egrrxGSvbQFpEfaHML61pM3NXy23LOjq/iD33uIoIzM2i5BJtraLciMycuWzaavocx26QS5zksz5vVHVfraUd1v9lbXzd7thDzChiK9ub6sP44emdXtoGU7OPqjE13QhxLsXBOnY4IbeSFY9N4z8KBbnj46CQupDEF1kffHAE3EwqCv7bmylbffCxHdAuZ2zCsfM6aeEoqTlrokSsB9gjYIs+CfQhfO0rW5Ao41EhiVSyJH4PMPsx9t2NO6Ys9Ml18v6+DAtQC+TLimVCHBPwhbNAWhJgGurHeCXlsj/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpT4kkm3NHM8vG68Vt592WTUNhScSUEjindiSmFTkx8=;
 b=Wzq0Jxs311k1FXg4l7joHD6AbPHgVGUaqGNG3bXjna6mWo240eDtYPCiyfjy6fA+y8H41dmF9DR/j/Htr26VN8BciDklewpFCtPW09wx/JhSQ3Wr9dWP1CqAKBUt5er5TH+2mUSzjfzlsSs1qqLVMv41a4M2M8+mjH49/qpWWoGIhvy+22iQqzL2YAGXQYVEz09Ig9VUlS0aL7BkHiSwV0u+K/83FegatPqy4ezlQlAkck6DXO1wslnOT8OwC6iw91S9AtLLkdSD4sR8Dgo7IRprrXmRPtDRkWn0EOii83nwUdwcRkRzyagpS3HumUIyNXVMkTISie8Uxzx2gENr/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpT4kkm3NHM8vG68Vt592WTUNhScSUEjindiSmFTkx8=;
 b=WpbqO4TLTynBqs4a8Am8FKhzmrj3C8S2bNI+49GgjU5dtR7oT48D3MEx1FTmzPtqXfSO0J7CoJBmst67l039yXtLaVJa6y87iG5SESOvGh3mJNp72Ms8cxRWsCnJCeXU1u7laF5bIK7MZHLZ+N4mF+ZODlNWR69sAJ+BK8cuUiLegsgKky6Fd1VMHX0sLcbP9OWudKLZQyvG22b3i41+wJxvnXW0MhuOtg4GB2uHzW+moaO/y6yvtMk/LuBlkgsQ2iow0w4EsPlmgGVOEE8QEcf643xPUh850fqdjLr765a8pZSS/AB4ul8pHDOuamNMDFoCtxzcjNZgj7Jh3/zjQQ==
Received: from CY5PR22CA0062.namprd22.prod.outlook.com (2603:10b6:930:80::7)
 by IA1PR12MB6162.namprd12.prod.outlook.com (2603:10b6:208:3ea::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Mon, 6 Feb
 2023 17:50:56 +0000
Received: from CY4PEPF0000C981.namprd02.prod.outlook.com
 (2603:10b6:930:80:cafe::2b) by CY5PR22CA0062.outlook.office365.com
 (2603:10b6:930:80::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 17:50:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000C981.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Mon, 6 Feb 2023 17:50:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:47 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:45 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 2/3] bridge: Add support for mcast_n_groups, mcast_max_groups
Date:   Mon, 6 Feb 2023 18:50:26 +0100
Message-ID: <82cb1211d85e02e6247cb9a141aad68027cbefac.1675705077.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675705077.git.petrm@nvidia.com>
References: <cover.1675705077.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C981:EE_|IA1PR12MB6162:EE_
X-MS-Office365-Filtering-Correlation-Id: 85855641-8ba2-4362-d90f-08db086ab25a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99EoIHZA+oU/E/mswEpJNhajChmtDqn18QQ2lqRZnq/LR5UwvUOh3lJjghQ0g2+TBt3rVSM6bymPPQMS3wBirrTSEBMz0QumnUmlMAGZuoqMWPrLCqB9f0fkI9Bvl0xo34s3528Q2/djnUKg9R569qVZjiG2gDJkE3P8KQLVhUPJdyRSxakr+fQVidlFJhueyzUnbWGZhBXsQkul1e+6UDUlkQqfLLWD2VgMf1LXiQXlcJ5dJgXF9pboO8ENi5CU2/SzuThNMUluoK36pVUWIz2ZGvrMkWQe5jIlVKWFotKPFNUU+9EMXleRcXoAXoRzhvSTrMcykJ8VRSvovOa5uEQ9yn/ZWpiJmE+RTKgIFVxqsJAWR7nfPGVAouJU/eZlUSzwLRv+0mluA1UNdgJ4RIaPv/zlnWv18c//sdNlvbP5oiIx1yPelaQ2OdVF5yrCKT1Eo5duyKA8gjrtSJkTymkeDIDALwlDQw01h4D11dqpPpeW+xQOKJaOn7aXkIzY+mJhazbCnWJx96SkWuLcA9c8sq5UusYhK9p5D4xARwu9nRTVXoM8h1zlL2gGnIg8o3tN/MicrQVwbY26SeDzEI/5PNRBgfeiLWb2dXAi+a+jc76Y57qvMRK2OvA5mYPIFtYZynVtIIbsKd5Qa+ukYTwdj8qxpP0b6rQbsW3FD0SqM0uQl7y+N4+tvwdZFWKzziE83eZAMRt8DuXA9lMFlQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(26005)(70586007)(426003)(83380400001)(336012)(70206006)(40460700003)(36756003)(86362001)(356005)(82310400005)(186003)(40480700001)(36860700001)(47076005)(8936002)(54906003)(41300700001)(6666004)(110136005)(4326008)(66574015)(8676002)(2616005)(316002)(16526019)(7636003)(107886003)(2906002)(478600001)(82740400003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:50:55.3817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85855641-8ba2-4362-d90f-08db086ab25a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C981.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6162
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A total of four new bridge attributes are being added to the kernel:
mcast_n_groups and mcast_max_groups, as link and vlan attributes. Add
to the bridge tool the support code to enable setting and querying
these attributes. Example usage:

 # ip link add name br up type bridge vlan_filtering 1 mcast_snooping 1 \
                                      mcast_vlan_snooping 1 mcast_querier 1
 # ip link set dev v1 master br
 # bridge vlan add dev v1 vid 2

 # bridge vlan set dev v1 vid 1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 1
 # bridge mdb add dev br port v1 grp 230.1.2.4 temp vid 1
 Error: bridge: Port-VLAN is already in 1 groups, and mcast_max_groups=1.

 # bridge link set dev v1 mcast_max_groups 1
 # bridge mdb add dev br port v1 grp 230.1.2.3 temp vid 2
 Error: bridge: Port is already in 1 groups, and mcast_max_groups=1.

 # bridge -d link show
 5: v1@v2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br [...]
     [...] mcast_n_groups 1 mcast_max_groups 1

 # bridge -d vlan show
 port              vlan-id
 br                1 PVID Egress Untagged
                     state forwarding mcast_router 1
 v1                1 PVID Egress Untagged
                     [...] mcast_n_groups 1 mcast_max_groups 1
                   2
                     [...] mcast_n_groups 0 mcast_max_groups 0

This is how the JSON dump looks like:

 # bridge -j -d link show dev v1 | jq
 [
   {
     "ifindex": 4,
     "link": "v2",
     "ifname": "v1",
     "flags": [
       "BROADCAST",
       "MULTICAST"
     ],
     "mtu": 1500,
     "master": "br",
     "state": "disabled",
     "priority": 32,
     "cost": 2,
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
     "vlan_tunnel": false,
     "isolated": false,
     "locked": false,
     "mab": false,
     "mcast_n_groups": 0,
     "mcast_max_groups": 0
   }
 ]

 # bridge -j -d vlan show dev v1 | jq
 [
   {
     "ifname": "v1",
     "vlans": [
       {
         "vlan": 1,
         "flags": [
           "PVID",
           "Egress Untagged"
         ],
         "state": "forwarding",
         "mcast_router": 1,
         "mcast_n_groups": 0,
         "mcast_max_groups": 1
       }
     ]
   }
 ]

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 bridge/link.c | 21 +++++++++++++++++++++
 bridge/vlan.c | 20 ++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index 337731dff26b..9dd7475d6e4a 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -187,6 +187,18 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_MAB])
 			print_on_off(PRINT_ANY, "mab", "mab %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_MAB]));
+		if (prtb[IFLA_BRPORT_MCAST_N_GROUPS]) {
+			struct rtattr *at = prtb[IFLA_BRPORT_MCAST_N_GROUPS];
+
+			print_uint(PRINT_ANY, "mcast_n_groups",
+				   "mcast_n_groups %u ", rta_getattr_u32(at));
+		}
+		if (prtb[IFLA_BRPORT_MCAST_MAX_GROUPS]) {
+			struct rtattr *at = prtb[IFLA_BRPORT_MCAST_MAX_GROUPS];
+
+			print_uint(PRINT_ANY, "mcast_max_groups",
+				   "mcast_max_groups %u ", rta_getattr_u32(at));
+		}
 	} else
 		print_stp_state(rta_getattr_u8(attr));
 }
@@ -282,6 +294,7 @@ static void usage(void)
 		"                               [ mcast_flood {on | off} ]\n"
 		"                               [ bcast_flood {on | off} ]\n"
 		"                               [ mcast_to_unicast {on | off} ]\n"
+		"                               [ mcast_max_groups MAX_GROUPS ]\n"
 		"                               [ neigh_suppress {on | off} ]\n"
 		"                               [ vlan_tunnel {on | off} ]\n"
 		"                               [ isolated {on | off} ]\n"
@@ -317,6 +330,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 mcast_flood = -1;
 	__s8 bcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
+	__s32 max_groups = -1;
 	__s8 locked = -1;
 	__s8 macauth = -1;
 	__s8 isolated = -1;
@@ -389,6 +403,10 @@ static int brlink_modify(int argc, char **argv)
 			mcast_to_unicast = parse_on_off("mcast_to_unicast", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "mcast_max_groups") == 0) {
+			NEXT_ARG();
+			if (get_s32(&max_groups, *argv, 0))
+				invarg("invalid mcast_max_groups", *argv);
 		} else if (strcmp(*argv, "cost") == 0) {
 			NEXT_ARG();
 			cost = atoi(*argv);
@@ -505,6 +523,9 @@ static int brlink_modify(int argc, char **argv)
 	if (mcast_to_unicast >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MCAST_TO_UCAST,
 			 mcast_to_unicast);
+	if (max_groups >= 0)
+		addattr32(&req.n, sizeof(req), IFLA_BRPORT_MCAST_MAX_GROUPS,
+			  max_groups);
 	if (learning >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_LEARNING, learning);
 	if (learning_sync >= 0)
diff --git a/bridge/vlan.c b/bridge/vlan.c
index 13df1e845ea5..44e1ba39f01d 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -37,6 +37,7 @@ static void usage(void)
 		"                                                     [ self ] [ master ]\n"
 		"       bridge vlan { set } vid VLAN_ID dev DEV [ state STP_STATE ]\n"
 		"                                               [ mcast_router MULTICAST_ROUTER ]\n"
+		"                                               [ mcast_max_groups MAX_GROUPS ]\n"
 		"       bridge vlan { show } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan { tunnelshow } [ dev DEV ] [ vid VLAN_ID ]\n"
 		"       bridge vlan global { set } vid VLAN_ID dev DEV\n"
@@ -344,6 +345,15 @@ static int vlan_option_set(int argc, char **argv)
 			addattr8(&req.n, sizeof(req),
 				 BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
 				 mcast_router);
+		} else if (strcmp(*argv, "mcast_max_groups") == 0) {
+			__u32 max_groups;
+
+			NEXT_ARG();
+			if (get_u32(&max_groups, *argv, 0))
+				invarg("invalid mcast_max_groups", *argv);
+			addattr32(&req.n, sizeof(req),
+				  BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
+				  max_groups);
 		} else {
 			if (matches(*argv, "help") == 0)
 				NEXT_ARG();
@@ -1021,6 +1031,16 @@ static void print_vlan_opts(struct rtattr *a, int ifindex)
 		print_uint(PRINT_ANY, "mcast_router", "mcast_router %u ",
 			   rta_getattr_u8(vattr));
 	}
+	if (vtb[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS]) {
+		vattr = vtb[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS];
+		print_uint(PRINT_ANY, "mcast_n_groups", "mcast_n_groups %u ",
+			   rta_getattr_u32(vattr));
+	}
+	if (vtb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]) {
+		vattr = vtb[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS];
+		print_uint(PRINT_ANY, "mcast_max_groups", "mcast_max_groups %u ",
+			   rta_getattr_u32(vattr));
+	}
 	print_nl();
 	if (show_stats)
 		__print_one_vlan_stats(&vstats);
-- 
2.39.0

