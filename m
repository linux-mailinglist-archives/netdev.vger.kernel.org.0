Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1568C525
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBFRvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjBFRvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:51:08 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07482E0FC
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:51:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SshYReUsd3EnXF4TdUaC6RcLYOsW3+nn3s/+iL7aMoTupm9QgBW/pEUxMF8L1j63U7n6hgI+Qk9j0mtJCbPtOZzy+AQHP47lJyumRXTVuJt7guYNxMqcxJqvq3HQRtcU2E3HHQN7CLe+4KQEp1HMsOYTzzdBV3to5BPfTxO2UnGHCZJFAp1AnU91OIYy+nFNpCmd3h3W6uiBdstmHMKPVgRnxsSP0C34UahIojlvhhg/LRhXlrtYioGcHxb34M4avD+WQO8DUwgrdHSmzruw7PTelhbIsPtPKprQdsjnKJOudhZOzSlth63Ml0PPcWSkpLR5AxiD9Bg2L1HlNafjrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vryAOzvIRcDP8TIvjX5MdJHMuh1HXfIn70sAZqhu2wo=;
 b=IN9Qxw2/2GFA0gKXsJSAsnxsV35vkEo3Fyjn4v7IC85K3hmIJtfEvKbZ84cc9q529UU3oQzNy+h07Lag6rP3kqyavwt96ICXYwa7qw3xjXEHb/8VMaWp1uT3uuKOZk/RnFZZn4JdJFvWtSIns7n1fOQDXOGd92j1R5UyfRAsXwHIY4gV5toFfrHuBczcARSyghNRqANdmGv3lFcgUeinc9MmQbDvK4Dyqm2nmIlrTESOp3YYQBuyTCmFPvIwfIbPrK0MGCqx9aiJ06+A761T7uZCZYFe+r4fU8zE8eFDYMCwz93FIkDPiz1w91hvK1VFfCxuUBqgqcx4gNnJn5ohoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vryAOzvIRcDP8TIvjX5MdJHMuh1HXfIn70sAZqhu2wo=;
 b=jtqkKSWnZ1wmO6hoiDDMjhMLhW0jAAwxNkTKNYQvCP0jyBgvzDdJWaIdN5Ex2Y7Y4ANLjuiKbRJTI6O+zNUyzRStYGwHnOUmjUB06aj20Oac2qCMwXvKASrOkHxLINvWwafg0Yn6YPg2r1V/vbI/bsGtZ1itepSYmvFH+Bx1jVTOD5dFnQKQu3iB4cC4YorGl+SyKV7GK5hLrWtxR2jmJsfJJl9rujeKpGsufx8Z2T32Hlj2XgNmJVHatHvBQTY8ktoQKZWkhV2qoByYeStcwSMlMxgDD4AkYLFDSo9O0pRhP+A4mDhqcGF3NQcUG03gTQdcEdAm6QIG0ASUEmUlpQ==
Received: from BN7PR06CA0059.namprd06.prod.outlook.com (2603:10b6:408:34::36)
 by SJ0PR12MB5421.namprd12.prod.outlook.com (2603:10b6:a03:3bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 17:51:00 +0000
Received: from BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::51) by BN7PR06CA0059.outlook.office365.com
 (2603:10b6:408:34::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 17:51:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT034.mail.protection.outlook.com (10.13.176.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Mon, 6 Feb 2023 17:51:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:49 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:50:47 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next 3/3] man: man8: bridge: Describe mcast_max_groups
Date:   Mon, 6 Feb 2023 18:50:27 +0100
Message-ID: <924ecbb716124faa45ffb204b68b679634839293.1675705077.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT034:EE_|SJ0PR12MB5421:EE_
X-MS-Office365-Filtering-Correlation-Id: 45238537-46f9-4ae7-8eac-08db086ab56f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ls4jrJT/w1fqoKAI7p/PB6PLIoD0oLM5r3RaHaVpk/pv5+wiIwe0eX1pxkXeQSCtU+ZPYwCxLvmytmU/t8qVNUuXIclgeyPFzQebI0cRB1+RNerrkNanHu0UtQExypRCQN0pj0/td+cwPOKi7ka1zI1LE3tIaI3NCZkyuM79leUws+OYJiIsAu/LpfzicWZ/Y4wn0Zl6Rb/T0uvZkpIg6L1MHYuurGIyIicj6BeS5wp6cVWUbkWo9QvOydm802olr9G0aYQbZqVoKhiqpi0l4MQOYXdVGc0/KENsysPPtkQ+q+xpFgEyJhhfOMORl5TGNN6WtRTQ4QsYnXV3wmWcN4Xzex9F0KWc+E2dymoc90p2/YXGfVQkfirHK0pgZkXWFdmB0ZcEZLkWJVzF6oWuI/XIsJnZcjPmwrfBR3w2raop4yXAl/bgTdnAHG+ZQKJMQ6zdsm5JEA7jus6/Wijro8pjRXyV8fWWAJnRMaiI70J0Q3T3DPxs85TxOQixQjAKaEg83QG7rnpiNnOHqK4Zj7ZnRzgMfuaM7bkYz/QepfthacpJwx+POi4Ad+LmauKQw/4tUKHjPke6ekSBbtaxEOtjiqiF9iSWOQKtSp8v5oCzBIOxoTYTah4n35vsipW1sihWcEHtsaMMQyXvT8mRreyIq5Co41+KkdeP65Z/pZO96ZEjqZBmylGJtqI6QNSlZSMKy6gGGaQR0XBKiQczLw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(40460700003)(36860700001)(82740400003)(7636003)(83380400001)(356005)(70206006)(70586007)(5660300002)(8936002)(4326008)(41300700001)(2906002)(8676002)(107886003)(478600001)(2616005)(16526019)(6666004)(186003)(54906003)(26005)(47076005)(82310400005)(316002)(110136005)(426003)(36756003)(66574015)(40480700001)(86362001)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:51:00.4568
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45238537-46f9-4ae7-8eac-08db086ab56f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5421
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for per-port and port-port-vlan option mcast_max_groups.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 man/man8/bridge.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index f73e538a3536..7075eab283fa 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -47,6 +47,8 @@ bridge \- show / manipulate bridge addresses and devices
 .BR hwmode " { " vepa " | " veb " } ] [ "
 .BR bcast_flood " { " on " | " off " } ] [ "
 .BR mcast_flood " { " on " | " off " } ] [ "
+.BR mcast_max_groups
+.IR MAX_GROUPS " ] ["
 .BR mcast_router
 .IR MULTICAST_ROUTER " ] ["
 .BR mcast_to_unicast " { " on " | " off " } ] [ "
@@ -169,6 +171,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VID " [ "
 .B state
 .IR STP_STATE " ] [ "
+.B mcast_max_groups
+.IR MAX_GROUPS " ] [ "
 .B mcast_router
 .IR MULTICAST_ROUTER " ]"
 
@@ -517,6 +521,15 @@ By default this flag is on.
 Controls whether multicast traffic for which there is no MDB entry will be
 flooded towards this given port. By default this flag is on.
 
+.TP
+.BI mcast_max_groups " MAX_GROUPS "
+Sets the maximum number of MDB entries that can be registered for a given
+port. Attempts to register more MDB entries at the port than this limit
+allows will be rejected, whether they are done through netlink (e.g. the
+\fBbridge\fR tool), or IGMP or MLD membership reports. Setting a limit to 0
+has the effect of disabling the limit. See also the \fBip link\fR option
+\fBmcast_hash_max\fR.
+
 .TP
 .BI mcast_router " MULTICAST_ROUTER "
 This flag is almost the same as the per-VLAN flag, see below, except its
@@ -1107,6 +1120,15 @@ is used during the STP election process. In this state, the vlan will only proce
 STP BPDUs.
 .sp
 
+.TP
+.BI mcast_max_groups " MAX_GROUPS "
+Sets the maximum number of MDB entries that can be registered for a given
+VLAN on a given port. A VLAN-specific equivalent of the per-port option of
+the same name, see above for details.
+
+Note that this option is only available when \fBip link\fR option
+\fBmcast_vlan_snooping\fR is enabled.
+
 .TP
 .BI mcast_router " MULTICAST_ROUTER "
 configure this vlan and interface's multicast router mode, note that only modes
-- 
2.39.0

