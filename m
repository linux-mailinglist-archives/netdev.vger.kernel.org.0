Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3362A94E6
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgKFK43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:56:29 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:41045
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727181AbgKFK41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 05:56:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3ZVftPxDIxYNJlx4csAKoyLz8LP7MRXbZA8ydumFxcGMUrMu8hpVc8fNvhlq7dXiyo3IwfNBFVzezXNSTMKdCwQgqiPWatRHlL6y5DldqOknnzN9dieARuton58DWL8GcM87yur8WNRuX3IZCBaQHgsc/WOQMRLyFz6YMcggLJ0MyFgDI+wwc7qLr9Ci+bK4hO8rnrxgAkOKfjuybMdVGfANKQXNpkKjo58GEmGG48GI3+NQyH0p2MOeQNJEk0K9gN6924I/1Bot80FwH2RRT1x3YNYGwsExkfF0rI9/hppzKQGnkRmgT1maLAIb9pTdj5KiNPZlJLk2XtAfxpaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAughEQriLoeVF7POJYJTCDzVsU/ISYfe3FkoWWq07k=;
 b=MIC7mZOlozZMl4Uqkmo/HrMlLE6KK5W34K5sbZ8oTMup3YmXWbq0Db1DcCJIa/QxdiCmzTmGtVOPP+lo/ZALzBMU1t4JUBY6wmYhm/1HxVP9UHYu62UqRTbQ0E7R438zBWcsL60pD205KtbyCQZNLWSawHexSUJ87sruRZFGmrkT5PLu0plr0IRUpoECehpyZCPwdJPfa2QoWlGYuTbw65TL8Cy6cjfckRgdCbyxRYWNhbrim+TJRKDEfzC78xyzSQbzY9x/1t1Qy7QEKtpsD/q44EI2nJLqNH0EGmICNC7Nax8ZIM3y89XYM3AnN5+lYELmbhc42RgxqwA16D6Krw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oAughEQriLoeVF7POJYJTCDzVsU/ISYfe3FkoWWq07k=;
 b=KV6I+fiiRhAJE0oamD/g4nJRb4AFmwjkbRqohB+v1sAhZFItJPkkp6CUM1WYLASAkt7V1KVwYyDdwu3e89jDzuh+FdUrqbK4gPW/AhWM79lYXZDYpX1CNqKsPZ76eMraChfgMR6b4XlY5x7pvwbfp+npa5PO851WGZTaVElVYCI=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 10:56:17 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 10:56:17 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 4/5] dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
Date:   Fri,  6 Nov 2020 18:56:26 +0800
Message-Id: <20201106105627.31061-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
References: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 10:56:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ac539bbd-44b1-466a-c954-08d882429627
X-MS-TrafficTypeDiagnostic: DB7PR04MB4282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB42822D3199C69418E7C8B0D1E6ED0@DB7PR04MB4282.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFp99Rqh+UOogj65JjFqQwvYDAJ1S98iccs7/Uw1MGu/y4PkXHCIe1TJQtbbtdX2EVWxGWgkZMHsyjHf9jbUdIb9AzKb1d8nLHnmGCpK7ZZ+rllRx5ix0XATCxPwk1vLniSEruIqWb3c3MlpS4mpHVghOFM21TQGv4osi/L/kVbvj/jQW6owib4T4cZzHK9Gt4gc887GTQhxQxkr0omnNJC+YCmy3lF84jP8WSlqLaq2EmI6UB4GvKAvSQixiRd5r6UutYeZkJuAomIwHwkulKq6d8RM8qZvXp8z5SxL1jVhjVT16wN9v5k0jGs44ZZf4bMGdcCYvxbgsqzQi1xpV3iXHnTddsSRlnZ6Gr/3WAss62JlOsOsV3nNm/6nlG7J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6486002)(5660300002)(478600001)(6666004)(26005)(4326008)(6506007)(956004)(36756003)(66476007)(66946007)(8676002)(69590400008)(52116002)(6512007)(86362001)(186003)(1076003)(2906002)(2616005)(8936002)(16526019)(4744005)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QFiF+LtLTNQdenDdrChkDqQszwoadFamHL4kx2tr1FBA+T1U8VdYdPIpIFt+5+m9zTlz7819GmTSzldE4n4xJdC4pOH6GwfxWE6NZ+0VYrl8tNMkSDeWEPw5nuyPZ7eXM0J2frcqIAqc0eL+Lo4XKEtt5Lw+v3AHlU8OIWiSeYoo+N8FlqceV0dQwsEU1ELmT9BP9u6x8IdNOMRCT1LJushIwVfj2prwR+oUrNZrl4vHL3iyqJlCeuRLQqxEtqOcfrKiz0V9qTCGJjoLQ7mleFsisXJIi74600QUcrjAx79nHFGaTcS7oMloQUibrCqMKlfkB4wAaRBX1t52BkCJEfWj+dIgYhPjhKzGk0xdNkWqwUrPoYoTjESsIi22MvHlSWtUwAzJKmpgbINJJ8yUsYmIMahYi8Y3wUTw8BUWnNMD+2wD79s39d9DYAD5gll5heoJRULQTd2JqZPMC/3LfRwYz54zScRviW2UC7bn//r3k8LlZoWGJqN8LKH/2y7Peg48E8XYoEbLX7UdmuxvkzUM/PdxmxJ8PaD/9jtRdsZUYpuzPt3u5e0WPt3uf5kzBWWCh3jGPyf0RZDmFSIkcfdvOhtRmZfjyM7H0OVGzXW1PZHGtCBbABQXFh3rfNaFHZbUg69eQurfNr7m0GDeqg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac539bbd-44b1-466a-c954-08d882429627
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 10:56:17.4504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wWws5AGs1a4BJeubfaTTG2luSsh2bSmRKenL4+o4ChmxR84RyCZsr+7db2JzTi/jF9TqQbioMflpr/6jU80k5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add IMX_SC_R_CAN(x) macro for CAN.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Acked-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 include/dt-bindings/firmware/imx/rsrc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/firmware/imx/rsrc.h b/include/dt-bindings/firmware/imx/rsrc.h
index 54278d5c1856..43885056557c 100644
--- a/include/dt-bindings/firmware/imx/rsrc.h
+++ b/include/dt-bindings/firmware/imx/rsrc.h
@@ -111,6 +111,7 @@
 #define IMX_SC_R_CAN_0			105
 #define IMX_SC_R_CAN_1			106
 #define IMX_SC_R_CAN_2			107
+#define IMX_SC_R_CAN(x)			(IMX_SC_R_CAN_0 + (x))
 #define IMX_SC_R_DMA_1_CH0		108
 #define IMX_SC_R_DMA_1_CH1		109
 #define IMX_SC_R_DMA_1_CH2		110
-- 
2.17.1

