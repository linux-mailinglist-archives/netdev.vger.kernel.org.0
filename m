Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416712947CA
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 07:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440510AbgJUFYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 01:24:15 -0400
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:43649
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2440488AbgJUFYO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 01:24:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luPLObe0PXWkBUEtkw9OY422I9QG0rpWlBXoDsapn1ms9kPcXNqwehM/9gvF0rKJMvKyI5Rv34Jj3kqy/6Qn+AxMYiVfyptDf8YhZ/QMfsM+9VE4y59kSHDMyGQW/IvAuc3JmGBfsFpHiUTI+cpA9M/bDMrVFFTxKYv6w9uIyZr8DnqS7ybXv2NAI8Z5XBbgIpiwvNC+oZPtKFuh7rd2PjKZZ03lLEkyTKoMp4tEbuEp20cgU2baUvLhxVUcprd4EccDCSVf7L8dI2MjPHdOMh2kY6MrmHjqQJYX0s9FCian/Ah+oCMy7jNxedzc/3B6TOwRe61t6iw+8ineLAuCKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GuCOGLBfr2TyjQ6iQxEv4ZcuLpQAskKQm+SwOKA27A=;
 b=MqXltYlcvmFLHRTNumbsa9kUrOgrckbI8VZK65HtnHUydec6DNs2K+yUPOYaum0GnWucrT/o7vu3Eb3rbnTSoioC+NWoUxTyxd3TMs+DpJA+/cNnKShzUpppHGHbX5wVziOv2ZFpLRCxqvDNX8YRmkynVw6S101IL/BLw5HzKM7wxMH4/6JMd+UVxVrkGzulO+g2HiFWhlH2umS7woEYj2i6i8EyOvcJ8o5q/RY/jJCMy+fHxFIr1rSYe41MK69/EviCCiOTaVK6f3eADQ5VQYhRLOcTr770vjcJkT2sSIhq6vfjxPYNQstSNCBn3vcI/A0sSZTGCQ7sKowvzCDOdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GuCOGLBfr2TyjQ6iQxEv4ZcuLpQAskKQm+SwOKA27A=;
 b=U+kEjI4gN5/QNZ/25coa1WcE9/aKewr+LslTz8FMhfyo3YNhBUTuTq/lk2Tu+Lor5augy+kBm4IisZrQg2Iw09hyvnFShbHRPbkvfM+0VOFQ9DTe0gwXVDJAN/zy44u2gmFBQba2hCDTRJsL+KOXrjO5YE68Ywx/9hQGkZMzW+Y=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Wed, 21 Oct
 2020 05:24:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 05:24:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V4 4/6] can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
Date:   Wed, 21 Oct 2020 13:24:35 +0800
Message-Id: <20201021052437.3763-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
References: <20201021052437.3763-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0157.apcprd03.prod.outlook.com
 (2603:1096:4:c9::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0157.apcprd03.prod.outlook.com (2603:1096:4:c9::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Wed, 21 Oct 2020 05:24:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5bc1f9e-1f7e-4f5e-0564-08d8758189bb
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2726:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB27262E684002280FA6AB40F1E61C0@DB6PR0402MB2726.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IsCF1hd3Q+mV4ErGchEASl/gqynIrxZuK0IJPz1tfG74euDIsxZ+SirEyRZmLTo6OsPDnMNv0d7zYh11r+oucxeuluYVbqmsKigmlZclI5ehfky0upb1wxbgVjuOkH63eHBMHkt9GyF8LSriroycQCmFM9cEMp/HEDq6KJLmddCUIvGKWXncU5e+tUcE0tWVBzmKIFIlXp1DaOufUuzzsHku16zbKoCwsOGkmdJFDji7BLMm1KGVh2KEv9eJyu4r1nSYGSAKoVvWA5uivH3iqf+ZYhZ5Krzqf+tCnEooxXe25V80UwQ8VoCea727hvO2CHAXrbszx05ciBLW9V/75KWqSSJ3HDOdN/oP3YXT/3Ir28q42iILqwuh3nW2V1yl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(478600001)(8676002)(186003)(16526019)(6506007)(316002)(26005)(52116002)(86362001)(36756003)(4326008)(66476007)(66946007)(66556008)(83380400001)(2616005)(5660300002)(6512007)(6486002)(2906002)(8936002)(6666004)(956004)(69590400008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HhK71kKMdFtV7yEXfKqZiKYQ1+U1ap5YNeVTuLzNgpvGBP6k78GbtegbUQPlW1+U2hH0c6fjodmVVLjRdiAQOFA4F07PtY7DiKAJX6xBoRtsO/XM6w4vzWgze4XvCICDVrEiVr+ATYGVtyAREyJmjZmODpwhhEX1R4d2dF5B+gzKDb0dWk5sW1FZT9Zjlo0KgnAawlkgnn0rJm7zr5ss9EbWcfxnP1vq1LLBI2El4dLZUjBBacF/rYPVUXPIEEOG8IbFLeaEscy9fx4Q2ZQuASxp1mWpeQW33znZdDo2d5KdOuhLrWMr3WZx3277WfIMGQl0cauf9vuxN9CakJ6SbR6DDfhDcr7073+7Nu9wX5frQDnyfhAqSVoM+Vl7ElDCPUm5mrCE0KVCql0g0Oo/q7ZBYLQw1jR6M9xYdByyRU6Vb4ky9yrscty3mHhsWU28yPFn1EYiCh45Y+if6ccNWc/GdrDK5p+0bNByzOm/PvYR9Qk50HfXaD1uhck2e4/T8UZsQArRfaEndeEKV6PGwXGQ51ifyFqJiOeyYslv8PkY4G33239h2vGIy6Wxt1h0nqufVOg2ZO3nfI0OsMmaRuE/tKaTaoz22vptAJMWPFdODUGGZGPWqErx/Y3L94CWtTAVOusoR5lSvHKLKIbiCg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5bc1f9e-1f7e-4f5e-0564-08d8758189bb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2020 05:24:09.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLXxP++h5saVBDYSFAKTzVo+cr35SAlZOuSDjQkEzuWp27TZa2nnJiwF4FPdoBae9CscQpzZzN6ouMz9jCBjfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
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
index 881799bd9c5e..8f578c867493 100644
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

