Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB61F4789A1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 12:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhLQLQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 06:16:54 -0500
Received: from mail-bn7nam10on2056.outbound.protection.outlook.com ([40.107.92.56]:55776
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235300AbhLQLQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 06:16:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=So80DVLlnrwMZGYItTz1NzqAIsw9mdtEfmFwrIKPwZyi2zVOfpL/D6yenPfVj10YcFofDhvkipDIgDW9/8DgPDUUO2ztTByXSW177r0Mr29EJbs+cRozh5OrGfP9gkekRnKQyUtTmqpycjoa13j9/iRlOMgU7iLPOUxN0fdwBx8ZB4XhXr2wjXbPntZNmybmQYnV7MqM+Mk1MGc/6XTT+KVBcNrBwtAxt50BIsOn87ekye2ZelDYOQtYKbJfIfWsjdVo8u/kwro6H4CFbptQKqPvfJstQ9WsHXqnfhW1+KA52fkljHLoTtZVpB1z+/gk7STiYUCA2YvuOJxDahkZoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hebZJGVvOIPHnOVl0a4tXBg6sQmEL8J0ztsSeOdZICo=;
 b=CteOvmZrQItCXW2vY4HnI3AY45moEoNNiBYuc/hb8vL7OiEvcr3B0Yblr20yQaUCRADmNlFKJcavhfj/Ybftpka+7q/CugUzteHSphP1Eahxx7a9TfCLx3xoBC7glrDz8uKED/uQzzrIgOtkXIqIRbTcCyE6LAufdicPH12aOSbNaH+W8AJO43LOuy25RSK+n131M5S7DUJZarwFn6/VC12yCwBoqULaOq9Zgfdkc+uREcrlHlB0yZVwY/uB4NLW8wZuCuVlfXf9YNGN6yX2p2G3WJqljn1JLzI6yCCwSHbRnUDzN0jWHykXYMjGCxmnjysLKfiPIPu4g9XjNPc3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hebZJGVvOIPHnOVl0a4tXBg6sQmEL8J0ztsSeOdZICo=;
 b=di1gqgtN16bi0aR46n7CeuEcnrzmHiQ3OpUFjWpWv4KDQrYjEx7GIVF4+wALaVZUe25ikvnK7mctD6i86T0tOCXt6NMzWZ8NLeRxmVXWVbTP+8BWATR1Ub69R5m3Gwory1Dd8qeTS8INKwnzpAewX34rwoLsnNh9/3a4RxotLUg=
Received: from DM6PR06CA0019.namprd06.prod.outlook.com (2603:10b6:5:120::32)
 by BN6PR1201MB0020.namprd12.prod.outlook.com (2603:10b6:405:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 11:16:40 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::7a) by DM6PR06CA0019.outlook.office365.com
 (2603:10b6:5:120::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15 via Frontend
 Transport; Fri, 17 Dec 2021 11:16:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 11:16:40 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 05:16:37 -0600
From:   Raju Rangoju <rrangoju@amd.com>
To:     <thomas.lendacky@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Shyam-sundar.S-k@amd.com>,
        <Sudheesh.Mavila@amd.com>, <Raju.Rangoju@amd.com>
Subject: [PATCH net-next 2/3] net: amd-xgbe: Alter the port speed bit range
Date:   Fri, 17 Dec 2021 16:45:56 +0530
Message-ID: <20211217111557.1099919-3-rrangoju@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211217111557.1099919-1-rrangoju@amd.com>
References: <20211217111557.1099919-1-rrangoju@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25a393c9-90b1-4e51-7665-08d9c14eb2fe
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0020:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB00203B2248BD65544A24966F95789@BN6PR1201MB0020.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9opLrRuzaAzCc07vdmmo75YsuD3vcBc+Dozep6CFO7uObwFy5cg9pEORX9aWoIla4Tk7vBZdQGzjVzfDiljwRfY5tQ7wIYgGDcHMJnU0XDsPOIBWTHprMniIl7YSSGl+O+Tw2euQdW1G0CVg5OptztWJkHAbHYQE/6ZSzx2AZdDnI1VzD+mFs0hwbLhGkndHY5yCyDgkdSCsfhtWcY17V2mL7orsMbMWSASLNkx8yA7/KNcUx/6PPtinul0cbfx6C449IRCMZH6s0uZ9dsYvcJuoHRi5MkFjVl+7N0GELbNeXFFXvqcO2AiezHHFo38sI/58WdLA+pPa0C/3RQry/fuVldgHCdfberbcHefYEEJ3xbTWtql0uDhHQJ8dhF/4X0KtJ+FpdmoOdj20tKM+9OIgGncAN/zy1k5mzTTOfbpFj9E25SaXkLw80IMsii2ltt5F6thDptsu3OvLW48VYQ/85KecMHy5T7rQwtsvhazb/U82iiejcNsGxpcPqvrAiZgHiVSoAbRDXMVXfS/0naHQb0UX80gzmSW9ybKdSuV3EZU0Xpy5E4vndW4wD7wGW/+FiEw1BM5B+TyJx2jmLRCqIsgDzx19d7M877EGL1aqoICHyT5+ZFiG3EREyRAQtel+/ID8bXcI8+p6lEpi5yfb/9cpIdj6l0y2V8Tv0zciMQKoj+iM0/UonnCm3/yfOgdighceLPquEF5Qn+UUVLQyatcqvbgiN0fvyqY0omGYru2K+UlwOqf+C0I1T/ewppUBUrbdHUu2lKLyUy9ttmL48F/mXizt4EJug9qnVJQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(8676002)(5660300002)(8936002)(81166007)(40460700001)(7696005)(356005)(2906002)(36860700001)(70206006)(508600001)(316002)(47076005)(70586007)(36756003)(336012)(110136005)(54906003)(426003)(83380400001)(186003)(26005)(16526019)(1076003)(2616005)(4326008)(82310400004)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 11:16:40.3485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a393c9-90b1-4e51-7665-08d9c14eb2fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0020
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

