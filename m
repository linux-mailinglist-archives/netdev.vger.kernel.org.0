Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E4E47AAB9
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhLTN4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:56:11 -0500
Received: from mail-mw2nam10on2060.outbound.protection.outlook.com ([40.107.94.60]:19809
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232320AbhLTN4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 08:56:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIRyqbXf9bcYYGa8ba0TVG0KC4PBWVZEqM8CzTZlgYcVxf4rtfqTJVXXva9LL891wTQs6d5T44eIlwVnmqpAZT+6EtLW4tKvVKE+YLnbAkad7xwDfM4RIBH78/il4f1WQp3QTvkrgzB8FE9iRXt2gr2i0TNvpefOPzlK6ueAZEArg65/MVYs2Wlp7dtnDhF+E3oek35EZlIvSAmYrhtN52SF4evEznIiCrfeeCWgE8UuGclj3jktI+HqXXJE/qm9OzJFJBosiwmB6HskgHyyS0IIc1fGXLlxNZxXdSqLH/VQTLUH8vLO8onijDXVl30TKMzaEldpTvFI/reKtjIDwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hebZJGVvOIPHnOVl0a4tXBg6sQmEL8J0ztsSeOdZICo=;
 b=TQAB7Ukxuh7MFXFa9LUKl+U+VclrPhzwNcPTb+K2TelZtorqj1IZ99veLsomBOldjSC8vG6zKZOvVQ6rkW35S8rOQAiQrOYnIZW8R4KAtmDl2p6mapnA9/4hmsOVZ/++txejKVnVb0MroaqKaIKlolLjKV4Mysrn5ABc5igl5mnIYjK+TqihpeTJQh9CS1Oa1qYqRnr3RvQFKpmatw9yLAprM6IBC20wGkX59xdmyKvsyG5OsyrBwluJ+2jS0c2PwtIP2Spld7gYIeb4CrQFI5E7R19Aqk/hKVooUIOWdh4HlG54nwmk1xaN+i2gmnQFK5AjjS9q2rvdPpcSzvwW0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hebZJGVvOIPHnOVl0a4tXBg6sQmEL8J0ztsSeOdZICo=;
 b=P155a+EsyJKe5LqcmxHYVY89n+Gh1A5Jfgod7GYMbJl4QYr/L8cr1ea/ANduKg1uERgQjHVbC6nepCJMZMCDSWKuaYVDWbK65AGqKoALNUixdS5jcSSAJImlTv93dAmcvVr66UtPeJ+UzvQDIPVWi/SeQA5pZBsZ78LTFtUzNSQ=
Received: from MWHPR01CA0040.prod.exchangelabs.com (2603:10b6:300:101::26) by
 MWHPR12MB1328.namprd12.prod.outlook.com (2603:10b6:300:c::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4801.14; Mon, 20 Dec 2021 13:56:08 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:101:cafe::ef) by MWHPR01CA0040.outlook.office365.com
 (2603:10b6:300:101::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Mon, 20 Dec 2021 13:56:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Mon, 20 Dec 2021 13:56:08 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Mon, 20 Dec
 2021 07:56:05 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next v2 2/3] net: amd-xgbe: Alter the port speed bit range
Date:   Mon, 20 Dec 2021 19:24:27 +0530
Message-ID: <20211220135428.1123575-3-rrangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211220135428.1123575-1-rrangoju@amd.com>
References: <20211220135428.1123575-1-rrangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a018b96-60ae-4211-7bf8-08d9c3c0793f
X-MS-TrafficTypeDiagnostic: MWHPR12MB1328:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB13289000C277B663BFEED03D957B9@MWHPR12MB1328.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tkpNPGLKCNM8gl8hmEIqL4ce5rn+D33/U8zCMNiYNqlEYOMw9wEGFqv/JYDyevuLLqFpwt8eCrsQXhqTxiryUooxU3DJJ1Xb+jS5kQybK9m0azEj1Y8PAZhQrn5S7doiUsLpfdO/xR1Fu93rStINc4QukTI4S+EYo91zNKC/5dvg4Gykq/UiXLzzZz/Yoi9QFRexqS6PwpR8EhcD3qxcCdDRzuSVLOuwekS6WJmfIeVHWB3LGYS/uTZwU8SOqOvBKQYibGoqgievOK5utx4xtNO36e8qoYz+PmTCLcnnb8+8ZJLHHICZ7VGwan0TLKh4QC0U5I79ircBneHdSoD3ulSQoe/p7jqml5Uwwr31HkOIs2J/6uUZB7Aqq9PUBbOL2PCJk0T4ckuTT2LJ4HUx+0fbljx5wzcU8JC5g9GLN5crXHkHMsNLL1XupRSu/93M9DVLjM3RV43WTMJh2bTjaLqLqRPIUZwK7tEJAa5MZBi3lfh8IHfJRNSdKOPJoPKLtVOmoasitIr8nUmN/jklKfZkh0penyWHLoZcSVAu7x1UY2Of4HLSsvGV0WULrlY3XQ+YpZ63hx5hV1VzssqnJS5sCo99W2EEJ6R9lw4Ggcr5d3vrQQYW+BDw3tdiTu75BZbePVzWiN1IjHoA3vH3djE7Jw2wmjLCjKxuJJPEcqINRwl/gnQnibMW3aDMtkVolJqf05IzS2A/qCJ0SrKxVvYS2KL13DAsXytr+f6VKAnpJ3dkBNhZFmeb3PxkUunpDrubh9gWRS/XZ4bMfhUQzsRxEST1aIS7Zhb/x5B1KbE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(1076003)(110136005)(70206006)(40460700001)(508600001)(83380400001)(82310400004)(8936002)(47076005)(316002)(5660300002)(2906002)(186003)(16526019)(36756003)(26005)(36860700001)(7696005)(6666004)(4326008)(81166007)(356005)(70586007)(8676002)(54906003)(336012)(2616005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:56:08.3454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a018b96-60ae-4211-7bf8-08d9c3c0793f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

Newer generation Hardware uses the slightly different
port speed bit widths, so alter the existing port speed
bit range to extend support to the newer generation hardware
while maintaining the backward compatibility with older
generation hardware.

The previously reserved bits are now being used which
then requires the adjustment to the BIT values, e.g.:

Before:
   PORT_PROPERTY_0[22:21] - Reserved
   PORT_PROPERTY_0[26:23] - Supported Speeds

After:
   PORT_PROPERTY_0[21] - Reserved
   PORT_PROPERTY_0[26:22] - Supported Speeds

To make this backwards compatible, the existing BIT
definitions for the port speeds are incremented by one
to maintain the original position.

Co-developed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 4 ++--
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 0075939121d1..466273b22f0a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1032,8 +1032,8 @@
 #define XP_PROP_0_PORT_ID_WIDTH			8
 #define XP_PROP_0_PORT_MODE_INDEX		8
 #define XP_PROP_0_PORT_MODE_WIDTH		4
-#define XP_PROP_0_PORT_SPEEDS_INDEX		23
-#define XP_PROP_0_PORT_SPEEDS_WIDTH		4
+#define XP_PROP_0_PORT_SPEEDS_INDEX		22
+#define XP_PROP_0_PORT_SPEEDS_WIDTH		5
 #define XP_PROP_1_MAX_RX_DMA_INDEX		24
 #define XP_PROP_1_MAX_RX_DMA_WIDTH		5
 #define XP_PROP_1_MAX_RX_QUEUES_INDEX		8
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 213769054391..2156600641b6 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -124,10 +124,10 @@
 #include "xgbe.h"
 #include "xgbe-common.h"
 
-#define XGBE_PHY_PORT_SPEED_100		BIT(0)
-#define XGBE_PHY_PORT_SPEED_1000	BIT(1)
-#define XGBE_PHY_PORT_SPEED_2500	BIT(2)
-#define XGBE_PHY_PORT_SPEED_10000	BIT(3)
+#define XGBE_PHY_PORT_SPEED_100		BIT(1)
+#define XGBE_PHY_PORT_SPEED_1000	BIT(2)
+#define XGBE_PHY_PORT_SPEED_2500	BIT(3)
+#define XGBE_PHY_PORT_SPEED_10000	BIT(4)
 
 #define XGBE_MUTEX_RELEASE		0x80000000
 
-- 
2.25.1

