Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B19421726
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbhJDTRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:17:49 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238664AbhJDTRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:17:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJynDbyzYcWmVoypoUqDzN4m08JgJvkx/8/6kF9AhFFmzkZHbj9SUeEQSLnL/BxkKlBr1DY8Co1Zj2O5sqsnM8fGETyCDGl1PQ2wg71sl5rUHz+gvujsXbxfnNyQtH1yGZLYdJpHKpa9/bgjX8HIeY8LUoFr1l5x09C68vOrpq1jbmn+pQrcEiC2G+bdUIkB50HPr6yX8EQuc3dp/Sq/U4tRxbhcqwnrOGrBAHosxJarQF0JXQxL9SnZwrBg2sJDdKm3Pv1iOOEJY9OthHZEIfUQ5rb/JpqcMJY3mRo1+glsIUGDzTSQZJaYWwAVMFr/AVGe9yaW81ucaPX+GuyXiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCIe0IukDIjAiicnw2Cbu3bzzlO0kk7AeA7piE7rXEo=;
 b=c1BYt3l4ArzvRchDfDZVOVcxtjUCw8948d9DHfyOei8raNKVYj3IAaWIr8Tm8t4Q+c3d4WT9ROWAXYoeUsvE2Krk4B24pAFBlUF7CjSNMcn0PRW99SeVh+oFqE5N6uN8uiwt1jeTjjjQKfx7rOHLeskEve7hSllVg8S9o4hpiKtg2D9G2GvxhQQJrq7PGWCnxktKR3y3BGtdHneE7a5VZDq9F5pe5cplAJb2dx0C2jcEtU8eFWJZSRRLjjBDAnh4wlgsjjxyLFP5jOqXrclbKy6VnvOPTNQ3c8m8U1XCjvEraumkVwAWH3xTS+HBhlbJ+APSXXV+NfN58QJKI2KSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCIe0IukDIjAiicnw2Cbu3bzzlO0kk7AeA7piE7rXEo=;
 b=Dn+DykDJ/QxwCgOGG8J+Y7joyPXayu50+jwB+vK1D9SX87Ue410f0QzPdMJJx7eZL3fcF2Wba+hOPrMpjZiEMf+Y0E71D+7ikoQzJxZMEIOsaW5Zd++QIuZzy0rwxLXA4gjm0elBNwcBzu4mw3+GXsfzNI1IvIDfbT5poX2px0o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:15:51 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:15:51 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 03/16] net: sfp: Fix typo in state machine debug string
Date:   Mon,  4 Oct 2021 15:15:14 -0400
Message-Id: <20211004191527.1610759-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:15:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8df990f-5ff9-47ae-e8a9-08d9876b6160
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB74341144DB3CC5E7BF24217996AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:612;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfBUDOaoeUL6NdDmxAusbPyFMdsxezcIuX43pZImETBDnzHC8X+gW6K3K0GoIV4uN2TRBWcZrhTzndD7RfIgY0m7qal30aW53YzRrvQ9SSj2umtqBej4BAS2+6dpeFujPciuZwkkM0goMIcwBk4YSJdvVo1MF8wqZ6EUfC9rG8FfsPeV31irUZg38/l5cvwauxjMrZoMeUr8oE8RYlnCAF9UEar0EYtQignaqo2PMHM7NXrg2SIv7iRlbUmQkDBwdtUMUGwbF+P3WKvFxDYgjeLcDyN50JDSsQ+LFIGXGj9Lk9qsO4fD1Gm8Mks2F3I+wjQwAM4hrOuARMYRjlp+QUMOfmg8ubqyALqVMx0A80AzzrNRvyIfDfBsnNS/+b0T9Pqyv+KUHUJ/oKxgiah4vTiLleGqeQgHNWRNNrtDJh6412SIP+taqOY6QQivlLvOHmVzvDbg02dRofrKeL9rFmJLKqMMTvblcZcWMOdEIIfVBxIh/+d0k7qhoWNiWRm0sKuRKoJkjnukbIYlfDef9wPUUKJA35MqzYs9xUn+tZgjoh2YHFPDbB1i+83zbPOnDsJh8t4N6vNze4+BNJatcHy2C2DKPMG6mEzeA/Nzy9sV/+paq7xOEiJVHsITCBG5ImEyfbjipUGxLcakNWyCoB5YdmZ2ZxgH7ePENqnK+Z+BhCk99mD8GsFiAgy5rrU643UuArR/K+PH+VoUDcmj6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(4744005)(2616005)(54906003)(26005)(6666004)(107886003)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nwrz9QETLIgdxkc7z1kauugPf0c907lft2KcZdtfq+Lq25I8MYb/KWECh9oQ?=
 =?us-ascii?Q?5Hx+nYlDVoqJJq4ClWKU40rx1rDpQQfrGEuzAgqg7iQBEcL7t780y0XE/1Wi?=
 =?us-ascii?Q?0xLHQIzZYs/qC90zbYr2y1quiaCVKUwSrO13l3rjOv2BXa4DL/2VvD8WBZOA?=
 =?us-ascii?Q?6XO5oRbiZfZjlWKU3pMWz3RTjxVteA/Y+Urq625rJM2xU1VELNI1m/mDddG7?=
 =?us-ascii?Q?8wWGYe4WXI2fxn3NAKXSQuRMNBLnWXL9xKCqp7dSrSHx4cl9gNBGVYzcfYWg?=
 =?us-ascii?Q?wPY28m8KBKT0t4LUQmJr6B/DYxj/Cf+r2JXulFHyhdJVEaKGs0jIxCU7M/0v?=
 =?us-ascii?Q?n90v/3t20owYq/h9mwvSopwEWj/TArT9Yy65qT7sakH8SvzlpQw5JL+SRHvS?=
 =?us-ascii?Q?aNEx5P7x4B/N9wpfxLJGsXiJkfyyEF79z57BQnN6qlzul+2R2sxXHfBp1bIS?=
 =?us-ascii?Q?gZTbIziQzbWCqRRsSK4nJ6CttEZWnLZKSHFDUjlSherQvLMfgOtte/EO0Gsn?=
 =?us-ascii?Q?oRmKUWE7z6gXlvLjbG1VqzcwLW/pgfYVMrxEFFyZ8RrWT9GuKEXrtCZlbQPD?=
 =?us-ascii?Q?o8jp9kKhVXOOHBkf7oG9DT6VOwSq1kHGTqoG3SI33c0h6hyFQrlWpD3Fgfhh?=
 =?us-ascii?Q?z+R9yPfH6N6S+eQA2tVmuO9BOHMXQE9+KvadYdVtmbU1gVYhdfMp90JLzlOQ?=
 =?us-ascii?Q?kHxI2hy1M1dA4cNNOypULBfvGqPBpQPMK6j7UYv6WuLPGIWRnQj52oVj5MmQ?=
 =?us-ascii?Q?fsgUkpWRLTJtc6RnsbYeTYb8GFcocR6NeiIe/sv7Qu6OJKwAJ7V0ZucbEjCQ?=
 =?us-ascii?Q?Jwubab4SPnc29IczxNcP4XKfreWwpRXOcBqvL8kxJEpKvw41eZzXLn+3XxV7?=
 =?us-ascii?Q?hk3QiKrWZVrxZ8Dcg/q/D36pLkKvjfUYGkU6ZEFsWvVUnpBqfTgHhwhLQ5W/?=
 =?us-ascii?Q?WmFwChUBJInr6hmb5RSUO7tRWIPtkIWD4Q+S1AIkkbpTiHpzIi5QQ98N8ga5?=
 =?us-ascii?Q?X9IOkcS5UVv2nlmNLeZUInb+bP8smVjMQaZ7DMKCOJKcmLVGmtHqiW6Mc7dX?=
 =?us-ascii?Q?S0lL9//bAz7NjK45v+HHGWY+xQpRM9toPgz7fl3SMPgnlYxkKsLicpCHwnMZ?=
 =?us-ascii?Q?TVgrtx0pGRE9A++VyypFAUJdANuM9CmObOPaTj7DXcWqYPpSF+0yMVqiiYZb?=
 =?us-ascii?Q?a9a2A04NQxNsR+CE5GyUN1Ui7EWBflXN21Lw4rJNgsjkP7/9eMFsx3k5rwt4?=
 =?us-ascii?Q?J9NbNhC3i3qMBB89NZfU5M2bSt2LBH/mraglpkAl3ldWH4Bn/H56TTn4l3tk?=
 =?us-ascii?Q?eEEnn5w5xluWtMoGMDYCWTT1?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8df990f-5ff9-47ae-e8a9-08d9876b6160
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:15:51.6438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mKx57bO6yE99WIhEGcZyLXuPvn3LwM6GTIKDRg7MeNlZ2IEbVvEhHD0+gat+k99+KqtdxvwqwgpHgvvRIPxeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The string should be "tx_disable" to match the state enum.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 34e90216bd2c..ab77a9f439ef 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -134,7 +134,7 @@ static const char * const sm_state_strings[] = {
 	[SFP_S_LINK_UP] = "link_up",
 	[SFP_S_TX_FAULT] = "tx_fault",
 	[SFP_S_REINIT] = "reinit",
-	[SFP_S_TX_DISABLE] = "rx_disable",
+	[SFP_S_TX_DISABLE] = "tx_disable",
 };
 
 static const char *sm_state_to_str(unsigned short sm_state)
-- 
2.25.1

