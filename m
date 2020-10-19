Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF2329233B
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728509AbgJSH6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:58:12 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:54662
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728482AbgJSH6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 03:58:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=go51YaqPCxq6lmBXprpVZ6WRCm6Mceq/VDDcg5MlbUp33yfh0oDDn9ci/dXfDWfWjn6Q0TM/7WspBkTUnN30tcdJofVpUQhioK2NsL3vwdpVMSI6aSYAX5T+QgWGm1sC/zPL8hwgcatFxWpNYbjLm4d8wS8p4AZSrEAAc6kK9iUnG/uWUz/gz9kDAecdRCvfszut4He3Yyj89XWahanJYtYjxOIK/NPmrPNd+2pAYHFiJ9GaNsA69P45OIWCF4fo5gA/xgFQvFmrmSVD6tmxbkULPVNtVv3h8X1MlsgefXFD5iYmTF/3uWYe/zZ7KhpCfEr7o99E0vSNiDktwdzrng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWusqq3PDt6IZ6JfY6g1vhBAugxrktpiIQky12TlL6o=;
 b=S3vW2m/1b98/sPunxu9/uNgBSBevNZKNllSyzHo3tSDL2B4nfot1Ht6FwL/PQRzMSBb5ScI/zHgVpohfYqZVPu8E4ifb7yhguFRNAKvJr/dHpUZCNKFuignrctBdkZqkd4CUKgw5SBX/GO1E7OfArmqvulHtHy7uNzYf+VDbLKIEv3M3JNEyjIgRzHn6uMKstmASolZrPqx75DecCHqhDHinrD7iTkPY6GOGIDaXUj91dI9d8rgcf5n8t8FiW7HSHxb2QCad7M9ayDZKihzp0FjYOLKou6Bi6S8T12wBRYmhbdaYK4cH5t+MO9CZtyBasIMJcfupV9xxoEWjC+eddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWusqq3PDt6IZ6JfY6g1vhBAugxrktpiIQky12TlL6o=;
 b=YAwDNVgd2aP4eglnArYG8sgPt3avBoNaeUr/5E+zIJcFoD4Bs5ym6PbxLYY0LM7cDMWOtDs1ff7rgbCnXDHWg2hlMgIa9/dR6CM0mYEL+DSxFYOIP0CRRXdscOEJHvbLz/Ob9ow10PjPvEqkRRZlsIGhf4hkJeCyWV1Zap+Hr1A=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB3963.eurprd04.prod.outlook.com (2603:10a6:5:1c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 19 Oct
 2020 07:58:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 07:58:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 7/8] can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
Date:   Mon, 19 Oct 2020 23:57:36 +0800
Message-Id: <20201019155737.26577-8-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
References: <20201019155737.26577-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0107.apcprd02.prod.outlook.com
 (2603:1096:4:92::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0107.apcprd02.prod.outlook.com (2603:1096:4:92::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Mon, 19 Oct 2020 07:58:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7866f728-2dae-49aa-d363-08d87404b6e6
X-MS-TrafficTypeDiagnostic: DB7PR04MB3963:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB3963B5813AF6A85AE43DC3A8E61E0@DB7PR04MB3963.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNi1LeNcReue3GDh23L6/Rtw+4S7zPQGzR70eOQb2l9hyGosJybYvpczD/HRCjIpnDzkU+PLEF9i8Fr2p/zLw17v2hXXa6q8mhkT+cBi4WVMyhIbnaFOgxPIUoJdw6eVh3g+1FhnnFspj7qtNdKh7jBTC+ecER8s5Ot8U6QqA6DkIgzhzjod6VvIcgRskasI9/Sf4A29wP6QUEdKSGzXT4xzJHzMUjYjNs/fufjSWt91NLH1wpPPxhqld7JnQgq5jzkCI8Q+zp22+6f3UGA1RhLnY0wS2QvZeD/Sq0XNOsCekR2s8r+NSTedybQRe15Y30cx6o5k9ccfKJmfXDixYHyfpsPuvu1PQh9NMEL35NsCw4GS9AwPoSWaXMzelgmo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(69590400008)(86362001)(6512007)(478600001)(2906002)(316002)(5660300002)(36756003)(1076003)(83380400001)(186003)(16526019)(956004)(2616005)(8676002)(8936002)(26005)(66556008)(66946007)(66476007)(6486002)(52116002)(6666004)(6506007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cG7wSpuGWTdfs/VS7TLwlRXHE3ToQISZO0JZ8Rk01xWO2xc7KHFHEKg6+Xqo7MGXaqiezH15/FDqwbVgw+ewcGVCdksVA/GAWms3AKEe+Dr9z5hD+I/uodFZkB7mwZzjKw3P3d7Zaa5h8O050f5VeU9n0ic6xw5vZan6NxCQAvlMSW8ouQPzU6Vcj/+CKlcNpRojSm54NPbzK0Pb2ZAC1SkIWwLfzwM3dugF+sTdbxJ6CP4IAJWYdyqe4dFkGgoY9KxZgTNsoXI0cYvsqjOdV5L7ArJ8W6arNp0FP/gm75NbD+aGq8N7AvV6/8GuH3wZP4EkgWprALFdykqeZRhgEqyVMFHUHnfHua1K5y14iqTnJjogYNxj1HGbnJuBHE2PwhOxwhbpd2jrUPafK6bmmKhUogXI3Qng7dTVauufZZ+b5HajzJ4S2ZeQzTh4THrVc/gGMzxYVosZVkZmiJRtunIYR4g/ATW7xlBUqo1lZ6LeS89lvuPRZW4sZcqqqQeFV0Jjf1ZUVGwN5u1vTCHZe3UJWRG0V/PXhk6/6EImVFeLsCjpWqbnegy8XUTP9E1zSMDvWgGLwdigv0svVR+y4DP0iqLrJvLIUuEF89ZqYuCyOGb0myJAgaACIAqdJJYQvulWOXtviK6idzIrIow2yA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7866f728-2dae-49aa-d363-08d87404b6e6
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2020 07:58:07.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6TD6MGn7qrGmxRrWjuDGuXFDQIOIWNso6qi189Z0EcwfE69JfBuHQfdzZjS5dE/3UXrA1i2Tdyc308Dsl2+IA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB3963
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to rename FLEXCAN_QUIRK_SETUP_STOP_MODE quirk
to FLEXCAN_QUIRK_SETUP_STOP_MODE_GRP for non-scu SoCs, coming patch will
add quirk for scu SoCs.

For non-scu SoCs, setup stop mode with GPR register.
For scu SoCs, setup stop mode with SCU firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 06f94b6f0ebe..c0cdee904ca7 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -236,8 +236,8 @@
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE BIT(6)
 /* default to BE register access */
 #define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN BIT(7)
-/* Setup stop mode to support wakeup */
-#define FLEXCAN_QUIRK_SETUP_STOP_MODE BIT(8)
+/* Setup stop mode with GPR to support wakeup */
+#define FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR BIT(8)
 /* Support CAN-FD mode */
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
 /* support memory detection and correction */
@@ -381,7 +381,7 @@ static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SETUP_STOP_MODE,
+		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR,
 };
 
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
@@ -393,7 +393,7 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
 		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
@@ -2043,7 +2043,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	of_can_transceiver(dev);
 	devm_can_led_init(dev);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {
 		err = flexcan_setup_stop_mode(pdev);
 		if (err)
 			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
-- 
2.17.1

