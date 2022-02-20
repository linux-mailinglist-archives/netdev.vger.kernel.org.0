Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A85A4BCEF2
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiBTOGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238302AbiBTOGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:04 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452B235858
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao8XsJ5wL5ZppRMpo5fpfrnJQg2VPUUVVRe8Z8SUuU7hEc91s2SSVYk0FLB8jM6jDqXDgo8zmjCXgHPKQnqNHQtQE0jboA2yROa/SexFTy9eJfcmeCKuB+EHJsN4ZcKbrTerRRFxjtM2uM6wxb+jcHQxQV1KXYWWgRfzeegoehoW3YWQwCjVYjCodhu/DO4FZRf9fBt9r4wE2+/VYEXWSAWp4PEp552REkWPSyBkD50EJV4X7K0UNFO+m55f/P0iBznXt+iqNiaQIk+1NfgRj9RSLor+gX/O32ZNtgO+LqQe8Edlh/Ox6+sEvvTAhJi7A42eI9Ir0JgFiax62hkyBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOurojyazr7V8OJHmmXydPKV3O4i6H/Jsi7QS2tq4Ew=;
 b=mfo6dsYel0br/hLEoA0tuMkvOUv55Id5XKtXhxiDcxHpGkClciHZ5XmfFrPCQ9f/a45BsY5+/p0o/TU/ZcUir/kgBBYC1Ee/s/rholEC7M77HRkIj4oyrC87hn0dLS1L97pgiT3Zqss9iNS1VsDSJHS/7o8KhYoHqhO0Iap/OJ4UXgm9wei1veAZDgNPV5a23ib5SbDDYFxQtybH8whf5cGkJCupEmHFshXNVNLDYJvRBm5IamDjJ1LKraZUVV9Knr/b/8KX1Ex62/tIK2ilxa9fgIUump2LvvUrw7W0/PUWT2Woijlj6PKfYLnD4kne5AV8UwZaYT6h+YLaMQDlrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOurojyazr7V8OJHmmXydPKV3O4i6H/Jsi7QS2tq4Ew=;
 b=b/WuuEHw5qQ95n6tZ7sGgrBc5C1YgbIPrtn7LcaJT6Xc5e7yhXVWIR2MNq4Y4oeaLH8lFG4gQ4taNm7NLRXIuqKVk3mYDZ8paBQI7k8676mEAhIO9E43IzEZoU5+6vJlBEBVJl7Ynv04iIks8/92vi+7Q0d9FT9I4IgTSC2DF0cLLMu2fOH/UM4RAOjK2BMMVGJGC6KsomPL3zWIfAjkHagcaK97J4tWum/OKuJC6zyEa5lIyET7BWHdk8kv3ZLP3FUH75wktgISLWe7YFFu4gKRnJraIQFOUbMGgTiKWj1VGKkkuwjuwuTA5ltXp2Liny8MviB8LuenFfMRiPyDaQ==
Received: from BN6PR16CA0023.namprd16.prod.outlook.com (2603:10b6:404:f5::33)
 by BYAPR12MB2933.namprd12.prod.outlook.com (2603:10b6:a03:138::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 14:05:40 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::30) by BN6PR16CA0023.outlook.office365.com
 (2603:10b6:404:f5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:38 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:37 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:36 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 06/12] rtnetlink: add new rtm tunnel api for tunnel id filtering
Date:   Sun, 20 Feb 2022 14:03:59 +0000
Message-ID: <20220220140405.1646839-7-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d75b995-9b90-4bba-ada0-08d9f47a1378
X-MS-TrafficTypeDiagnostic: BYAPR12MB2933:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2933CD8A29C582EA748208D9CB399@BYAPR12MB2933.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2pvr32SIufc2xEVnbtU424QSZPVAkJgeUmsZVns30CvQ+MWszdf/fRV0Ei5QZJZfQNG6F9YUoXt2ObLzCFc9ZJA0DekKQEpxjeC1YjBdW3vA0XHETv1axBB5S0L3yInauCsId4+IeVYJhvOJyhVYKr50u0twRqFfepwclW1BCzRdaAfUPOPJDT83rRqTze2gxwzhyPibkpXMdQinIrsZhOK+Z23CIVtmD05RpQwx+xqtcsXOOP2EEbskj8B86/v3y709ROhkAvX+xcyj8djxN6MS2hCGsV5d3Wy4i9i+whXNWqcy7VaFMzYdTdAgCJ0gwGBsq1gY0GY3YC7BRh9OWttBw2XV/+krbf4hBfyWx391CQ7A50ACCZMjtHi33QVDcnFwBdgD6oTmid6kc4rcQkmQOITVYyvChscxwqnBrpKtw5LIqQ8R5PWR3XE22MzZXE4cgqxiM/b/j5+WFTCmLu6sM1sewFhPF5d9wmRQ2Yh/hYlN6mGS2jgKULe17LF6u3EgzxlOFMLjtXQdFoezFORzi9E+RgCwsZjH/8w/7364106sW82umwtdW0/1077Z9wPMi2MZ3EdbQgghxbJnWC/milLFUqz2EDckaZek/bcgWf61+5lP56PuSrwP5iNTxIFkUhWkGWNWwte2MrHwoyP93m/wxhjioXmsYrcCOyKKqPgBxDfNJ0z7zEuOciL1pXO5DHshjkZXvKsLkD1eYA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36860700001)(81166007)(356005)(86362001)(40460700003)(70206006)(4326008)(8676002)(70586007)(110136005)(54906003)(316002)(2906002)(5660300002)(8936002)(426003)(336012)(1076003)(186003)(2616005)(47076005)(26005)(508600001)(6666004)(36756003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:39.7780
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d75b995-9b90-4bba-ada0-08d9f47a1378
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2933
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 include/uapi/linux/if_link.h   | 26 ++++++++++++++++++++++++++
 include/uapi/linux/rtnetlink.h |  9 +++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6218f93f5c1a..eb046a82188d 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -712,6 +712,31 @@ enum ipvlan_mode {
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
 /* VXLAN section */
 enum {
 	IFLA_VXLAN_UNSPEC,
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
-- 
2.25.1

