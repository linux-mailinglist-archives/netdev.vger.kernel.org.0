Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E10955212E
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbiFTPge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiFTPgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:36:25 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD53913F43
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxNn3R6jh6PwyOCFXfe+lHrSkK7SPmNZ2tZEuB4Iled/rH+jLCUBrbERr1eMMdIhqog2oeEUU2S2mguHIYld/0T5QCnj13AYuDe+0EIxbKQJcsCBZcfjRpOA4nVOiwxFZBkqDrmMR1H+BuEycYWKq7YBnf/qSIqyNYXIInwY50rKqSTPOMy3bMcJf3iHXrNDcevAILInvbORoZjIVKliF+1qP+nZ+gw2Wxvuj6fsM5SY2GOweGto8HqaQZpyGBN0vjVj6lgmV2MhHfueXFZEiz6Pj0y2/oLlo5fq4IFyusdjqha0/xQU8hUv6agR0F2UswzGY32xgqoiNDANIRU6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW7Yl72yK7Mpb9wp0Yn8PWOANqCLlAcbUZh3v2tCEJU=;
 b=BZeWcY5ZQlWPdMwNjXniiY+ZDaGUQsZIEuqDGdNatSzqy+ESlPtNdhJbMot/r8VND3rLjIHQmrkkvM95JohDXE/Qcx785wTilwtjyc+MTkQK7D10DMMzB9ZgxWhHDiKRLiGHu93QGDiDSlPmf0d3PtvzVtyNnpSJ624ccypdMs7EvtS6vdHfm+ZIxMRMNSRT3Ib1KobETDZjwwoCRl59YActQcSKGpm0eINTMoUdBvX5+kvRsNN9MQcOjdRG17TrsdmKn9bV3B7yEyRL3j166mv1hTst0cLVxBm6SiANqArNROCIvzKade9GntdiN1JxQZFiKJjueiBVnQ0kF+Zdkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW7Yl72yK7Mpb9wp0Yn8PWOANqCLlAcbUZh3v2tCEJU=;
 b=Wfb5uzm9dkogxedcDw9+NmEWAUBlecBfu4KjJDX6TwHkQKL7nXU42F9MUcc63irhwifUpBMEMkBBJL9yq0UE/d2e7C4wwSfVzZ5Jzb8zY7gGVH939DP8gOiFdZ97Sy2WZkd4fnEcJp1hi3Ll6tiDr5D68+07eCaWG2UpAH50zgyqmSdPrA2lOMtutMQP1Lf+akNLiUeUU95UnRgA86MyiOpGmG7nWQpAvkCcDmeqbE1T+JKsb6LGKlyohBScsesEKxyXiMts72iMpnAjBsgG3dy6PYA9QHLY3F+5SgfXzGjUHnNQ8CyW0mlcK6rFIfyANSekBfCpfB3wdocef6w5Ng==
Received: from DS7PR03CA0016.namprd03.prod.outlook.com (2603:10b6:5:3b8::21)
 by DM6PR12MB3081.namprd12.prod.outlook.com (2603:10b6:5:38::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Mon, 20 Jun
 2022 15:36:23 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::9c) by DS7PR03CA0016.outlook.office365.com
 (2603:10b6:5:3b8::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18 via Frontend
 Transport; Mon, 20 Jun 2022 15:36:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:36:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:36:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:36:22 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:36:19 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 4/5] uapi: devlink.h DEVLINK_RATE_LIMIT_TYPE_POLICE
Date:   Mon, 20 Jun 2022 18:35:54 +0300
Message-ID: <20220620153555.2504178-4-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f22a9d80-cad8-42d1-bc47-08da52d2a171
X-MS-TrafficTypeDiagnostic: DM6PR12MB3081:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3081CEEE3A8BECB0958A4210D5B09@DM6PR12MB3081.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GX8JLxb1489s/W+E36dLWS0ujxhcr2bRIWZXIpXr4XTuqpguh6C0+NAeqxjGK36kIbAjFaZHlR7qKgBh88MWZ5aqK8N9NhMuh9TnSBemNlS7lavnzKfi4F+DVYimTM07ltGsFs9mQen9UtCeU9i+TaDYmGD8liwxrbT2CHEoy+Ejo6RJmKMIGFw/6KgUzCVNprOvvtEBJXh1MT2d9HcxKBTNf5pqB7EKxo22Z2+EY4/aZMLt5U/0eNyJ/QGV0f+cgW06TV/fVURmom9tLkKP5Bd5jCQGoxpHA1vByn5/Krrt8pGigraI4R0x/wb+aYMNEK7Oc0fF2zc1d47Y7Zcs9ZXVW6rpcfPfrn53HAoJMv9loxeqSU3rzz2whOeYPO5+34jrXmF0PzD4/CcnYwUJFkvXczxJ3kTTuc38ZUu+u+E6j+ACNxHaEr1oRrmH4fwfkZql4PiZliJQqOvxBUONxp5i8psTx4lmLCyEpQv3dvDQ2hYJKCqhmrDOat3IfapwpHcAHd+LLBrXxe7iuaS3bZ6MqHButBQK5RFsQbW+grhUahkN3xT4k37HUNa4fNhSpSvttXeCUEbMj/WTNMpS63vt3hL3xItVZwwkP2wScmGNgzKgl1zQqQ/wy7aajp6hhLtAc9GVa3zxbdtn03S75RHVZnICJKU3p93GbNRWzI+IdajKxfND55AX7KUYK7Nxq1AeT4u1a8evFiGG+o4/RgYVzV8MSLu46IGpqQ+Mmw9pUQOlseAybdqqztGnV0GC
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(40470700004)(36840700001)(46966006)(47076005)(426003)(336012)(40460700003)(83380400001)(36860700001)(186003)(8936002)(36756003)(4326008)(8676002)(2906002)(70586007)(70206006)(5660300002)(82740400003)(107886003)(40480700001)(26005)(478600001)(86362001)(1076003)(110136005)(316002)(41300700001)(2616005)(81166007)(6666004)(7696005)(54906003)(82310400005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:36:23.0448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f22a9d80-cad8-42d1-bc47-08da52d2a171
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3081
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 include/uapi/linux/devlink.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 4b2653b1c11c..b9d22448c563 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -224,6 +224,7 @@ enum devlink_rate_type {
 enum devlink_rate_limit_type {
 	DEVLINK_RATE_LIMIT_TYPE_UNSET,
 	DEVLINK_RATE_LIMIT_TYPE_SHAPING,
+	DEVLINK_RATE_LIMIT_TYPE_POLICE,
 };
 
 enum devlink_param_cmode {
@@ -582,6 +583,13 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
 	DEVLINK_ATTR_RATE_LIMIT_TYPE,		/* u16 */
+	DEVLINK_ATTR_RATE_TX_BURST,		/* u64 */
+	DEVLINK_ATTR_RATE_RX_MAX,		/* u64 */
+	DEVLINK_ATTR_RATE_RX_BURST,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_PKTS,		/* u64 */
+	DEVLINK_ATTR_RATE_TX_PKTS_BURST,	/* u64 */
+	DEVLINK_ATTR_RATE_RX_PKTS,		/* u64 */
+	DEVLINK_ATTR_RATE_RX_PKTS_BURST,	/* u64 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
-- 
2.36.1

