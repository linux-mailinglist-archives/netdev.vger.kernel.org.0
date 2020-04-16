Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14DE1ABCDC
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503677AbgDPJeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:34:21 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:59648
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2503009AbgDPJeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 05:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHcpbYefbBDZzbyiHMItn5th3P6yzTzjzr5bruWEsm6HAJO/1chKMQJXU6mGYzqnMWebI9L4NdRRCJfu8yW/u6JYQptJSDtqSnbSkfjKWlYZeJISlM1XJwEb/uE0lheFnktlbjj1DaLzNL4Hstp1MB/9SJlELzXS3W2aBrjdwQQ/7uKvvEKiusqvoAgWkOB+x9/egOmHF6l8N1tPRAPRPAKrFUVA1Hy+f98KHQ/gXqCsxK9u9u317V4VP4Qr+YvLI1e0qCrryHEyvpL5BQvLSziykCmg7a8eErEzED5gPgXIkSCq2OrQmIPVovSZv/33etzg6v4bnLDQ7wCSWZKw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpivK3RpgvofkwZyVenihhJsrmt5f48FTn0HQpqg0lw=;
 b=B15fWVyVPUFB874elJ9GdrhQj9qa4spba8jqQWn3pdqWOFzMH7XRd3AtlHVVc8r7bjrJC8VYAk23a4bwfAbItmA7xZwavYzx4htHPNUtanl8wAJpXRgFEC7pVLcbReERxmZoRqVnzdyZpTkFbgg7TZWgFdYWTmf/7es1jt4EJ3MMhl0qMwPuQMNdsZXoF9RKOPfqGfXiXopIx2kLIUvY1baP8QAvIRJJYQbbzIDzlR1Z3dckfStcLEcGpiHbAxxsNm8W3R3SsNvd6qm6cquCFyhE19wHTBYRZxuT7qmWzH9uXw9zGbCPlzGapz3eterxopk0rPrwO26PlfnhIL0zUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpivK3RpgvofkwZyVenihhJsrmt5f48FTn0HQpqg0lw=;
 b=s01l2beJSdnNsQsbffUUCbYPfPjAGIXvOPbagrjIWBxfiuuz/QSeYDml/CnqCDdd9nS2VaNr3/Z94MB0aj/eQS4kdIzUn09/c1Fsi4IM3p/mQCsqmaDDmxu+sY4Huykq3nZg1Kqcdz7pmJQBFZvozgN6dnlfVl/h3ylCGrB2a7s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6969.eurprd04.prod.outlook.com (2603:10a6:10:11b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Thu, 16 Apr
 2020 09:34:06 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::2924:94ba:2206:216e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::2924:94ba:2206:216e%8]) with mapi id 15.20.2921.027; Thu, 16 Apr 2020
 09:34:06 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, linux-can@vger.kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH Resend linux-can-next/testing] can: flexcan: add correctable errors correction when HW supports ECC
Date:   Thu, 16 Apr 2020 17:31:25 +0800
Message-Id: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) To
 DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0015.APCP153.PROD.OUTLOOK.COM (2603:1096::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.3 via Frontend Transport; Thu, 16 Apr 2020 09:34:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.71]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4aa929b5-de3c-451b-2353-08d7e1e94e97
X-MS-TrafficTypeDiagnostic: DB8PR04MB6969:|DB8PR04MB6969:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB69696316CDFA2284DB6D311AE6D80@DB8PR04MB6969.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-Forefront-PRVS: 0375972289
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(956004)(66556008)(6512007)(36756003)(478600001)(66946007)(2616005)(69590400007)(2906002)(66476007)(1076003)(6486002)(5660300002)(52116002)(4326008)(316002)(86362001)(6506007)(16526019)(26005)(186003)(6666004)(81156014)(8676002)(8936002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +o1U97Cic2AyLDMcNYi0ZdJjuzEIK46ga/YNbUQPsA7mVV7z56tiqORNmwWBLE7L5lP7URGhTJV767Ev1jxccm43BkirdO0rkeoVkTkfkRF+uCzIVd2yqus3Wevrv4f4M6dhA3hg7c4Yz5PIe0W9o41pOUEWPlUT3yKNUYiuYww37svISEnSYxou/knrXtEVjzzTJuKguth7J2GGjXkLB09APTnWLumUs1++pI22CgGv2QutMV7glMPxp369G1O3PjeN2wcEYRgCemhzbKCnF+yIUjUTwXK7JzAZGdi1GWa2sd0Ujka+Mj41o06Gp3Y8jDplD4ModzuWKo88eNJR56xnVgGk4hdj/jPymSMK9UUtDkwA/vwebFRZ9vmsk1vDr9BrmvDJbQLsM1yEUK1Mqy7nuOaq6b9JhB7WNxjluPG9tblm3pGr64iv5l5Ct76JrfHwt8WCkFpL+J08Mjt/tjuS+F8DLU6YqLp8DMX6t3KsAQOsCKTU3zygp+/XHyB1
X-MS-Exchange-AntiSpam-MessageData: 0uS701RysSFsglbX3JR/3iPkhx2GommRVgKhP1ZAtJ1FOzuYBVI+t/blPdGESZ/FoHMaUwfHmjB6cCiVFuPzCbmqDRN99dV++2SYVjWGGdPoDycvFXze7NAAZ4feV5KGZAswSWMeewyueDKqtkbvmA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa929b5-de3c-451b-2353-08d7e1e94e97
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2020 09:34:06.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VoixXLB6ZjGE+L5enYeYslI2vWuA67dbGlk1cde7o3HRcswDORtWl/YzMnqLwisLAkbUJqOgnBtAu4zZzT8VRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6969
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
From above commit by Stefan Agner, the patch just disables
non-correctable errors interrupt and freeze mode. It still can correct
the correctable errors since ECC enabled by default after reset (MECR[ECCDIS]=0,
enable memory error correct) if HW supports ECC.

commit 5e269324db5a ("can: flexcan: disable completely the ECC mechanism")
From above commit by Joakim Zhang, the patch disables ECC completely (assert
MECR[ECCDIS]) according to the explanation of FLEXCAN_QUIRK_DISABLE_MECR that
disable memory error detection. This cause correctable errors cannot be
corrected even HW supports ECC.

The error correction mechanism ensures that in this 13-bit word, errors
in one bit can be corrected (correctable errors) and errors in two bits can
be detected but not corrected (non-correctable errors). Errors in more than
two bits may not be detected.

If HW supports ECC, we can use this to correct the correctable errors detected
from FlexCAN memory. Then disable non-correctable errors interrupt and freeze
mode to avoid that put FlexCAN in freeze mode.

This patch adds correctable errors correction when HW supports ECC, and
modify explanation for FLEXCAN_QUIRK_DISABLE_MECR.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 3a754355ebe6..aa871953003a 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -187,7 +187,7 @@
 #define FLEXCAN_QUIRK_BROKEN_WERR_STATE	BIT(1) /* [TR]WRN_INT not connected */
 #define FLEXCAN_QUIRK_DISABLE_RXFG	BIT(2) /* Disable RX FIFO Global mask */
 #define FLEXCAN_QUIRK_ENABLE_EACEN_RRS	BIT(3) /* Enable EACEN and RRS bit in ctrl2 */
-#define FLEXCAN_QUIRK_DISABLE_MECR	BIT(4) /* Disable Memory error detection */
+#define FLEXCAN_QUIRK_DISABLE_MECR	BIT(4) /* Disable non-correctable errors interrupt and freeze mode */
 #define FLEXCAN_QUIRK_USE_OFF_TIMESTAMP	BIT(5) /* Use timestamp based offloading */
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE	BIT(6) /* No interrupt for error passive */
 #define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN	BIT(7) /* default to BE register access */
@@ -1203,8 +1203,8 @@ static int flexcan_chip_start(struct net_device *dev)
 	for (i = 0; i < priv->mb_count; i++)
 		priv->write(0, &regs->rximr[i]);
 
-	/* On Vybrid, disable memory error detection interrupts
-	 * and freeze mode.
+	/* On Vybrid, disable non-correctable errors interrupt and freeze
+	 * mode. It still can correct the correctable errors when HW supports ECC.
 	 * This also works around errata e5295 which generates
 	 * false positive memory errors and put the device in
 	 * freeze mode.
@@ -1212,19 +1212,32 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_DISABLE_MECR) {
 		/* Follow the protocol as described in "Detection
 		 * and Correction of Memory Errors" to write to
-		 * MECR register
+		 * MECR register (step 1 - 5)
+		 * 1. By default, CTRL2[ECRWRE] = 0, MECR[ECRWRDIS] = 1
+		 * 2. set CTRL2[ECRWRE]
 		 */
 		reg_ctrl2 = priv->read(&regs->ctrl2);
 		reg_ctrl2 |= FLEXCAN_CTRL2_ECRWRE;
 		priv->write(reg_ctrl2, &regs->ctrl2);
 
+		/* 3. clear MECR[ECRWRDIS] */
 		reg_mecr = priv->read(&regs->mecr);
 		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
 		priv->write(reg_mecr, &regs->mecr);
-		reg_mecr |= FLEXCAN_MECR_ECCDIS;
+
+		/* 4. all writes to MECR must keep MECR[ECRWRDIS] cleared */
 		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		priv->write(reg_mecr, &regs->mecr);
+
+		/* 5. after configuration done, lock MECR by either setting
+		 * MECR[ECRWRDIS] or clearing CTRL2[ECRWRE]
+		 */
+		reg_mecr |= FLEXCAN_MECR_ECRWRDIS;
+		priv->write(reg_mecr, &regs->mecr);
+		reg_ctrl2 &= ~FLEXCAN_CTRL2_ECRWRE;
+		priv->write(reg_ctrl2, &regs->ctrl2);
+
 	}
 
 	err = flexcan_transceiver_enable(priv);
-- 
2.17.1

