Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC574BEFB4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiBVCx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239383AbiBVCxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:22 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2056.outbound.protection.outlook.com [40.107.96.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C2125C7D
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbScok4ylClkd+647pKjsDpSn5vDGvP1V2rlNjspLrcKcmoZY6OAx1LTrBdbhUGKRtSzXcFaDsDJ3PY++nCytjI/WZjaadWnTyIVZNS6iUnAkLhtMphIg4WV+TUUh3NW5ysi1YhpPTfNzY9DkFqscfo0ANCNHv370ZQAMKv3UB95+jP+QpHZPAMAUqUZnLm/kmbLDbvZhfikI8JKur7grHpBLflss9lB1512H5JJ7XXkQBDqEI2cDw3LPCzcu8t5XYlKWIGwCEGdTo2opfJm645H2cd3SludrFlR5XCi1jgIcmGBzpaNpEd8EnRpQvrB3E+FYNxV3PWmPpSagF3Rdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eK7jhTWWRtS2cdO5b8tS6YkVyZwvF5WvXtDDmmyXSmA=;
 b=Tup0YjCJkP3DZ4KSCH4SpAIs8d5nZb4OInHHfI8ellbS/eg2QyTFZcOSZY+CMjyhN0kdrfcaEXM5jpWjuz5FJrJh69tH7G0bMZJgAYtMC3SWl7t2iRohWX9wYiY1DNb54YHaZ83CyWBYXO60tXzkfVDmOILPmyE/u8MbamB9kkGNBgKm0n7jw2lamg08s8FsNrvcpWvgFOWYdLHCn7lgqtvu+KMM3CBMk47xrk5vurngG/EdRPVjE0W9cVO589f/dzFmQe5imxhEDiw8ttJFS+53k8sE2cCLOwst7DDNk7MuOtoxCLcR3sh51BF4YuVByScpYboeQwUJQK/hUez/pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eK7jhTWWRtS2cdO5b8tS6YkVyZwvF5WvXtDDmmyXSmA=;
 b=J5/k72iP1Ppc7RcaWdrFYpsT4BirUaZDtWhy3emgydO3ts+mFYDqHOLu0o2Q37+DPkvlNihY8LEzkfZ9kH2tI88BGJiazRDHxmSdinQXs8uZ0Eyj2GA6zW/dKbzhHXxDFrF6fIJJ1UHZFKQyaVfAFHrs2x4vclKuLA5UJFGqnoCJhhgf8LkllCMGCT5IpTUzDW2IM92/eBR3Czh+/0qsRXfeHW/Glt1apPw+H599mM3U1gtXeeE/j54QVCPtbFKPrdpn4pYlLE3e27pQyUJfyuitwHo1Eggz8z1B4pwpodvraHBBVP8gMR1m67Tu8VPHAqP5eQ3pYs4D2fWGJYVbNg==
Received: from DS7PR05CA0072.namprd05.prod.outlook.com (2603:10b6:8:57::7) by
 DM6PR12MB2811.namprd12.prod.outlook.com (2603:10b6:5:45::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.24; Tue, 22 Feb 2022 02:52:54 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::33) by DS7PR05CA0072.outlook.office365.com
 (2603:10b6:8:57::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:53 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:52 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 07/12] rtnetlink: add new rtm tunnel api for tunnel id filtering
Date:   Tue, 22 Feb 2022 02:52:25 +0000
Message-ID: <20220222025230.2119189-8-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 066c42da-8f1c-42e7-eae8-08d9f5ae6cdd
X-MS-TrafficTypeDiagnostic: DM6PR12MB2811:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB28110EB4E805BFAA96AD4027CB3B9@DM6PR12MB2811.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/KzzuHZeU7tlxNCa/okr1FUqYsqRcOMFxmNVpWpIowL8TCQIZIBFJ/LvynLtcXQJZ+sfFMPq8rhmuAfoZuM83210G9HD1OS1S0HDn0395I6t2rNrUHWuMzOmLtjIy/9CTxfl9EG7pKpRAJ9q8ylXc2ctdsN8BApb1/ZOPgvCMadTD3VuBSUWMGH5K3iZz/jpb060v5hcfGD7bTEWAvSkRq4NKwuHxdXoQHjwx/LnAHUr4d3C3/o/IrNQRTceGMk5jNrQXde8aRxLW1rgOuP3bV32O1R0OpPH4HPivSZXaDLyV40+jhuYsWKS68usxgqI1Q6WWLsUVHoVCfAM6Lq/hdYWtzLanF8NAOAwSfCcDV8DIgrznzK3V8S1iYv48xQAwVSLjmNWMuMn3zpHMlRdwhnqvcm3TK8AHb7eyPd5fo5AUKoUarJSrHN14gz2sS8b1NDKdubK85ffgiIetzUI2oaaG+vJT0V3lUv8g2bGhqw+2T2vlY8/Lhobu1spQr1SpFKRiPmZNUn+8f7w8mnqegRdeITktPz9Dj4uFEeUxjTl6G1fHrqvgxkRy6r8BFwIdaxKupOGCcRmM4BSzFBWV9Je/h9kWCfA25v5uTm7+6nVZbB1ZO4UxeZ6P3LIfLVZ/F+kih2xub8Casghsq4JTxhfjeAJSRMZThigSGuWTK6FotexntDNoBCb8Ohf/IJhhnTB34AcYezuH3ZqkQWCw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(508600001)(8936002)(82310400004)(356005)(86362001)(1076003)(54906003)(110136005)(40460700003)(83380400001)(2906002)(316002)(5660300002)(2616005)(107886003)(81166007)(8676002)(186003)(426003)(70586007)(336012)(70206006)(36860700001)(4326008)(26005)(6666004)(47076005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:54.7983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 066c42da-8f1c-42e7-eae8-08d9f5ae6cdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2811
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds new rtm tunnel msg and api for tunnel id
filtering in dst_metadata devices. First dst_metadata
device to use the api is vxlan driver with AF_BRIDGE
family.

This and later changes add ability in vxlan driver to do
tunnel id filtering (or vni filtering) on dst_metadata
devices. This is similar to vlan api in the vlan filtering bridge.

this patch includes selinux nlmsg_route_perms support for RTM_*TUNNEL
api from Benjamin Poirier.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 include/uapi/linux/if_link.h   | 26 ++++++++++++++++++++++++++
 include/uapi/linux/rtnetlink.h |  9 +++++++++
 security/selinux/nlmsgtab.c    |  5 ++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e1ba2d51b717..3343514db47d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -712,7 +712,32 @@ enum ipvlan_mode {
 #define IPVLAN_F_PRIVATE	0x01
 #define IPVLAN_F_VEPA		0x02
 
+/* Tunnel RTM header */
+struct tunnel_msg {
+	__u8 family;
+	__u8 reserved1;
+	__u16 reserved2;
+	__u32 ifindex;
+};
+
 /* VXLAN section */
+enum {
+	VXLAN_VNIFILTER_ENTRY_UNSPEC,
+	VXLAN_VNIFILTER_ENTRY_START,
+	VXLAN_VNIFILTER_ENTRY_END,
+	VXLAN_VNIFILTER_ENTRY_GROUP,
+	VXLAN_VNIFILTER_ENTRY_GROUP6,
+	__VXLAN_VNIFILTER_ENTRY_MAX
+};
+#define VXLAN_VNIFILTER_ENTRY_MAX	(__VXLAN_VNIFILTER_ENTRY_MAX - 1)
+
+enum {
+	VXLAN_VNIFILTER_UNSPEC,
+	VXLAN_VNIFILTER_ENTRY,
+	__VXLAN_VNIFILTER_MAX
+};
+#define VXLAN_VNIFILTER_MAX	(__VXLAN_VNIFILTER_MAX - 1)
+
 enum {
 	IFLA_VXLAN_UNSPEC,
 	IFLA_VXLAN_ID,
@@ -744,6 +769,7 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 93d934cc4613..0970cb4b1b88 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -185,6 +185,13 @@ enum {
 	RTM_GETNEXTHOPBUCKET,
 #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
 
+	RTM_NEWTUNNEL = 120,
+#define RTM_NEWTUNNEL	RTM_NEWTUNNEL
+	RTM_DELTUNNEL,
+#define RTM_DELTUNNEL	RTM_DELTUNNEL
+	RTM_GETTUNNEL,
+#define RTM_GETTUNNEL	RTM_GETTUNNEL
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
@@ -756,6 +763,8 @@ enum rtnetlink_groups {
 #define RTNLGRP_BRVLAN		RTNLGRP_BRVLAN
 	RTNLGRP_MCTP_IFADDR,
 #define RTNLGRP_MCTP_IFADDR	RTNLGRP_MCTP_IFADDR
+	RTNLGRP_TUNNEL,
+#define RTNLGRP_TUNNEL		RTNLGRP_TUNNEL
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 94ea2a8b2bb7..6ad3ee02e023 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -91,6 +91,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -176,7 +179,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOPBUCKET + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWTUNNEL + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.25.1

