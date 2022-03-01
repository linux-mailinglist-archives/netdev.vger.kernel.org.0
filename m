Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379244C82D0
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiCAFGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiCAFGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:16 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D7171CAB
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCOCpKG1+z0yjtzm6aksMppDH+geiYdVP514YCVPXkfVm7+1rw8mNuSSn0fPFWEbk3Gp+YYhV+Mk3kjskCTugoeJyqfxMeFZMnJFtn21S4BLzJ8HQgQnnZkUJJ2aRtS9s/eyEfsyqmr1VEt2cIqoh8AyIgIFiDPZ0yjmkMaEtG4sE9y3Lz2UAZyNDRjytWcyKrlUt6o6ehb5IhuUDV7cb69VNVEwKnRB7lkbBMXOpJRzfWCz/7n3Xlru9wmG2HVNxf9osKj/u3Czn5i0yvhY+JQg96bLgJINilgRMBWun2E6yhwu4XiEY3rTochwYQ8F66YpjmGp5wYBWQfjCWuEqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuB5nm25zYj0n+RHNIUs4fSZSJeP2Og712s3uYpuGJw=;
 b=NqM3nlhnOwp++hnGDnyU6jZ1MugUFPicmaaLCJm1IV7NKTrbrfgjPfZRyOCAfuPqSpGyXHeJswbOlUhbgZQUJuAkzVrUBFM7QqUab0anTn2cxDpomYORPwfV7+1EQn1snRlVvEGCeWu2G9ijhrxAezPTFCeVCJIXnb3f9Ngw1mhrvfg8WGk9JjQnEbKeozkGwEw5iS/2GTtEoaUOozsQNsDYSpPq9kyFnbMq8zBwIdsHPTx+WfC9OgTNAjciBiF8G+kLOsOhBIXl2isr+D/7YEpXCMG8XqCBaR6YJSuDb0K8aI0AXHp1cVm426yohXuMStmgIgrDRBAeZ3q5tvUncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuB5nm25zYj0n+RHNIUs4fSZSJeP2Og712s3uYpuGJw=;
 b=TsSE3uKsSiaPC0h2IVNna72k/OhTTo5O0JP+NYKmmXwhL6h5e4xeIpqsuYeaOxBqBZO+C64EaryNPaOLk4IdLZ+CR8Cjd16Xku5Q9xRbZZV4DqKbekBNUUwT1TyQ6vnxS0mu6j4T2FRUZUiGFEFJUEiRUeUFosovEKrtC8h0p7aYroj27lYJU8DoPSKOZMZJbomxmx1zmOhCPUW0yZcsUuNyvoJWRA7B1y2t+C/Rgewk5vkq7BUdWApPhM9oFPbyo25cFvGjiqKw9aLPmgNkBdS+fEJ+ooW9HM3fOiyPC11GZaS3UBRNHcTjUX1sAD04tbaEsDVRED1HtkKqbQWivg==
Received: from MWHPR17CA0071.namprd17.prod.outlook.com (2603:10b6:300:93::33)
 by CY4PR12MB1686.namprd12.prod.outlook.com (2603:10b6:910:c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 05:04:47 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::87) by MWHPR17CA0071.outlook.office365.com
 (2603:10b6:300:93::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:46 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:45 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:45 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 07/12] rtnetlink: add new rtm tunnel api for tunnel id filtering
Date:   Tue, 1 Mar 2022 05:04:34 +0000
Message-ID: <20220301050439.31785-8-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f05166a-fccd-4df6-39f8-08d9fb4101c5
X-MS-TrafficTypeDiagnostic: CY4PR12MB1686:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1686CDC6A0F02FD4D64491BFCB029@CY4PR12MB1686.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T19eITufTCw5z7g1J20ZwEJjR6yvYsTpUQsEX8X4R/hCOedLfw6OGNeE7bLufpn65HTmyq0DWQAaYHQ5foQMjehOrAWWai46bcc65gHpeOeMJi5tfDMAo4KjvSIAXYQqPDFhlAMy+/N9sNJifHbW+IWAjH8W+KGUF6FyB8REJCmIehL+g1ocfrtqk65b/NozNwPOwDZnxTcJKXuvH4JGWlUjNkwo+wWQJXgEbmp1FECMQJnorhTg2iymktSYmFlpokuMofsf2ql2busvzRxqN3clcXqt0dmzttNPXI0vK/PBdkjRJ5drh1/9nm+5Zj8Tc0vr9F5eiJWeG4X/NIYuIJqX/GsmWuJVmNlieOClxyJWFdajDcDe95zqzFF6d51WKIfWsykSBXl2crwLcw811PDTdUmpE3nhg2NG/APBDMX1gUucpjAejAyPE0ulObk00biv2crRn4ZI8GXKgZ/bTS26PpmQa58umRr2B+Q8/t+0Ac8u81HQMtA6Kat7twQ5PTT1HLlUqiultRc45QtERa20+IqPpqKxJjlux7gvLd8c9/F/jVRdgXwzSdNmbcf/BH99UUb6n3B9GN/hPK9y21IaKMRfF8m3RNKE8MjNfCChK0soGN4oykKkqz8j5w7xjjK/W8zNWu5u81NNJEogW5wy/7p/VX9hE6NnlDUWpLgf1lyPxPLj+XW8WTas4PFgSPAoqFz9NdcdDOW674ofaA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(54906003)(5660300002)(508600001)(8936002)(316002)(2906002)(36860700001)(356005)(110136005)(40460700003)(186003)(82310400004)(1076003)(426003)(2616005)(107886003)(336012)(86362001)(83380400001)(8676002)(26005)(47076005)(4326008)(36756003)(6666004)(70586007)(70206006)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:46.9690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f05166a-fccd-4df6-39f8-08d9fb4101c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1686
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
index be09d2ad4b5d..3dfc9ff2ec9b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -713,7 +713,32 @@ enum ipvlan_mode {
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
@@ -745,6 +770,7 @@ enum {
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

