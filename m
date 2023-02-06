Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F9068C523
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjBFRvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjBFRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:50:56 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515832E0C0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:50:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbv2UCjMM/8vqOlNNtYPBvkEQnNxHlkkB1jMywNrIi87kCWr5R8ts9hTfytXI6gSQE39AEOF21k/rPjek4KaSJH7BShDPSRmqsM0/VZ5IeO3YVUB1zBL7JsueKK5f1W4PW/JDSQPxN+Z/CV21A6p/gHM1DKyyH7yBeFAYc1MxGXpRPj6Xsw59cvdRuOkeg56+J3XQAl9wElSa+138Q74gjJGaSTqfTrEbnj55tiVNx1PU0iwa9snVwoojQUIirrT4s4VwlpgA0gqq9SDq2EJcnyi8rAkQEjb1sQCAYYPQf3yAwn98hKzLdROvBjxeXLRwOZdaLYEfcvrSuFjzoMgUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sycdtrdtE6Jds7xxXHQuf5xuybQO8LXQsAcmWWcam80=;
 b=bFp6jikrA76zlabLgjxfIg1Hqfy/4rc+rL+7ppW2QcM5u3S7MJjtmU6LgK3r25w8DYktBAarw8S/JKjlmzW5TXjc8zft7wsAsT0NBn69tc0QUDOrkMDLU1aX4m3X2tiPH/6Bb94+D4jYC07u46f/gmj1ktzNBl4GizrAbvlRMzvTcZdSINGt6gz8eVElXyaeRade4gIe7L75eO2lVk944w2AawwSTZTicHjV+MDx8/sE5cba4TQd4Vn6SWb3olDZyVYhRIU5xDlTkc2j8cLdY/1JojuDp1lV9+4Kqwmi5Rs+egRiJMlE4whny/IUnvmE8ZrZKWNbOofQD1/svUDMnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sycdtrdtE6Jds7xxXHQuf5xuybQO8LXQsAcmWWcam80=;
 b=HglVHImg5KfGMvBimLTizp7d5HafY2JbCbrH3bNtHqpMsFCPWaB+NI5jctRKTq/Mkx+G0dEzPlzQL8ZGEiFcLzwp9SXbj7jlcGPWdQXDTXQxmhmpX0EtPvdAL9YsjVQCoBlauvzoK8S3Q4iCBD916+88Hiex9Ltt0OZgM3dl5w5mhQAqpxqgCG6WYfCzkHL3tMWH07BLrk5pZOu5WBxvNg+t7cwlj1Rr3wsTjrSzOo2vyR2VYShgNhY4Lwot0e1TqsoyPiOhc+2Psa7/J0rU+yfv82O7BNPngNHus1tvuAtlse3l+tB/KA1Gx5DJa4TUJ444XnGUO7m4dmO+Zqv7WA==
Received: from BN0PR03CA0018.namprd03.prod.outlook.com (2603:10b6:408:e6::23)
 by PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:50:53 +0000
Received: from BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::55) by BN0PR03CA0018.outlook.office365.com
 (2603:10b6:408:e6::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 17:50:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT075.mail.protection.outlook.com (10.13.176.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35 via Frontend Transport; Mon, 6 Feb 2023 17:50:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:45 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:43 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 1/3] uapi: Update if_bridge, if_link
Date:   Mon, 6 Feb 2023 18:50:25 +0100
Message-ID: <82b5a04f69bd4fd4b6cea9d8d418fc321d506913.1675705077.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT075:EE_|PH8PR12MB7207:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ec67c39-b130-487d-37bf-08db086ab10c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NWQG6z4v5FpjJYE+kNX6vOGtN3OFWfdH+xH1+DO8vhfASgLO9YoJzqqWNZi+MpCpy2l5Y3ApAOS5Qn/PCCeDSdJGENn4sYHuuKiYwXNctPrnLAaftLsuL/Ti3E9CRcFepv5v/vFEEfG+KCU+CKZ7bctFrjqeN/NcwIZAT4sDtbpC/cjDG5VlNASh9svRkhPG85bj13QqYsZ38U0+oFOnKpxvUtN8FLs+pRfcJGJumzhjMUFA5woYRK9Jv+0M6FA44YG/ffmSNF1Jasv1KigOGzw27JlyVEcIU4ACz6/IFhCAFhJ6tLMRa4L1aLDK1qk+JAIDNXQbLDDBO43JtPHSpiGvHX93lA8c0RbjGFQlO6U6tm0kvf6dRl8gZL1RaEouU/8LdH6Tr7F0REZO89f82K3rbfRPbJYj67T1gNtC6w8qUsJlC61nWX/Q9eDW98gQ1MChaqdUnj/Sxs5cXfnpx7gqf9laxj6+oullDvaDohxqLjML46hILzvgny9HrcFE2bN/KbiRxIBQECNaQ/WJhLZ6QX5VVLmBhYJUZjdPNCP1u29Ltus+cBR5/QWxakAdz7nkpbsXyvIApQhmmOdxxsi52VxP4dXv4qk9cMwHFtdqWd7xA0JYL/tr48/ByztByRgSbA22LqXs4X7G/YKKOy5BUMSCdPYUY2XM+bjiAeeNPb7A9ejsqfBWd/Zn267YdVlEmKW116YeXD79axopew==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199018)(46966006)(40470700004)(36840700001)(40480700001)(47076005)(70206006)(83380400001)(426003)(66574015)(82740400003)(7636003)(40460700003)(336012)(8936002)(41300700001)(36860700001)(70586007)(4326008)(8676002)(356005)(2906002)(186003)(26005)(6666004)(82310400005)(16526019)(2616005)(316002)(54906003)(110136005)(478600001)(36756003)(107886003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:50:53.0793
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec67c39-b130-487d-37bf-08db086ab10c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/uapi/linux/if_bridge.h | 2 ++
 include/uapi/linux/if_link.h   | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 4a887cf43774..921b212d9cd0 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -523,6 +523,8 @@ enum {
 	BRIDGE_VLANDB_ENTRY_TUNNEL_INFO,
 	BRIDGE_VLANDB_ENTRY_STATS,
 	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
+	BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
+	BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 147ad0a39d3b..d61bd32deedb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -374,6 +374,9 @@ enum {
 
 	IFLA_DEVLINK_PORT,
 
+	IFLA_GSO_IPV4_MAX_SIZE,
+	IFLA_GRO_IPV4_MAX_SIZE,
+
 	__IFLA_MAX
 };
 
@@ -562,6 +565,8 @@ enum {
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	IFLA_BRPORT_LOCKED,
 	IFLA_BRPORT_MAB,
+	IFLA_BRPORT_MCAST_N_GROUPS,
+	IFLA_BRPORT_MCAST_MAX_GROUPS,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
-- 
2.39.0

