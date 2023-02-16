Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC2F699CCD
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjBPTFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPTFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:05:02 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2094.outbound.protection.outlook.com [40.107.241.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87ED505E7;
        Thu, 16 Feb 2023 11:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQyYdRo9u3P+HRDx5QFNBfuktumqUMZpEW11zd2EHP54mtNZzyFmMBVtA4X4PWx1tQzkTEjP0wHGcOwTke+ATGxco0ARV28bXBc5bqJpTJk/2AXDv8VmQlUg1AsBp6LXz0vPSmNa4Oq0nExBLAt9buCa9dYfbYprMjM3aZ18uyNh2YzJf8lzFRVQOieZlToipPe4ksxRO0JJQ+Ie/u5lRgWe/Oh141v5UAdiH5/hXFXZd5rmBWkdvSXCXCl7V8P4bJeDysH/fqbCjpD32xFsGx5yd5qGGYoJ+5rKPZz+j/uPYyKfkM1X20iMeffwVz7rm4wvV4Zpd1Z9sBeTQ278Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4xNZXOC847rRbcRynunWhQwNs149/QXtpGCFyXtcH0=;
 b=dW9hTMTk1RD128oSVV17vFl5qscqEzVgFGAS/uNf/q1xb3+KE+dh3yGCvtUVUU88oFhsqTgFj9ZxCZCgJjgI7N9+YBtS9thsWahi+REtakUaMMSVOW8qdwanMnucasFTlRt0Czr6cTKBaLqWcplxUW+stDaaVNowTclwaNDloStSdCkxlo8qlEk/NMKU11ZNS4xFqV0hwJ92dLXqo3rZi5aR0sGCIxNocsflXjuRDQoLV55o1P3NoWri1oY3qWHBW15+gsoSrdJEpMTjvbuDbnccp+yh+RFJy27p4Wo5E71hf4C43GZvjs+HnVwHXoJYWH5cE0WWUDiZ8UT8qv1diw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4xNZXOC847rRbcRynunWhQwNs149/QXtpGCFyXtcH0=;
 b=LVpKwOVBd+4TM8lQ9VK/0ccMeS1qaqIL5hFudUShlLa8U77E1EUtYUKFGM+Y29nVj5mpkp1jogYHXN5lv8beotaknOTEs9wSoqsdXCFdPdaE+alLReHSDoQ49zX2ACTjKPfDbBdZw02WhAcq18d0pys6b9Cz3+7aedO5e+e77yo=
Received: from AM5P194CA0021.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::31)
 by DB9PR03MB7626.eurprd03.prod.outlook.com (2603:10a6:10:2bd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 19:04:54 +0000
Received: from VI1EUR06FT012.eop-eur06.prod.protection.outlook.com
 (2603:10a6:203:8f:cafe::3b) by AM5P194CA0021.outlook.office365.com
 (2603:10a6:203:8f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Thu, 16 Feb 2023 19:04:54 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT012.mail.protection.outlook.com (10.13.6.164) with Microsoft SMTP
 Server id 15.20.6086.24 via Frontend Transport; Thu, 16 Feb 2023 19:04:53
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 80A7E7C16C8;
        Thu, 16 Feb 2023 20:04:53 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 726612E447F; Thu, 16 Feb 2023 20:04:53 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v3 1/3] can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error
Date:   Thu, 16 Feb 2023 20:04:48 +0100
Message-Id: <20230216190450.3901254-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
References: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT012:EE_|DB9PR03MB7626:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 5400aec8-b850-4788-f372-08db1050b002
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5w3mxrEOS6dDDC8B/J1x9ZIxvAHkFZoqxE8up4TfBaz8XRkT8sLWiMQiFdL1I16oWbA0VEOKq79Z3PizeGaP91qrNKavXt2RagEtoubkO+o/R/iqYoawnhoCylqe9qKK5lewKSKyVwHopV3NxsdIEFMmrwWZ+KNsBZ2KI0l8RbMww456O62V0Wssu7q0xjhF6XY/Ms/lkr/RSREiZVqphAFUosl5+BhOeBLmkCJrP/ZRpRPvmI+NOWZl57SJfevAEyHi2bAUuP1LQCa9zfrezx2mNaDAN1mzXAuMrjA6KQZo+W98CN7vovIEuUpBGFyBOIxco1X0Wrfb/vL8saE6MtYy4Epd5VG1y8GvvCaC1iB47/1LIr/2TSSudYVj78ArKu5lPx10raENNv4dxyGWOlurwVR23Ar/LWK9jUiaUVDSY7X6Q1F6hAv4e/zCMW9XAdUfWjtCsbh5F22TgjIdGxkPa3UBvQztC1srF1zHDCsVmByEGPjB+AyrTGS1KjOdecRdhLOLEJmylsqadci1Jk7cy+ttlcU745G9neJPxsbvglqj37zKCSLMR6FYT7jw+rieOHFsm6fq/AyC+OT69eF/ajeKEoJpl+wzFarWW/OdrEXqA0B7xVC6R8ogPAS4/aGqGdTfxNzmuq0h2c/kdiMbsaN++x2sKWJM/tBcilw=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39840400004)(136003)(376002)(451199018)(36840700001)(46966006)(86362001)(336012)(2616005)(8936002)(186003)(6266002)(47076005)(26005)(36860700001)(83380400001)(81166007)(70206006)(42186006)(54906003)(70586007)(8676002)(4326008)(41300700001)(316002)(40480700001)(356005)(110136005)(1076003)(6666004)(82310400005)(478600001)(36756003)(2906002)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 19:04:53.8531
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5400aec8-b850-4788-f372-08db1050b002
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT012.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7626
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the supply for cf->data[3] (bit stream position of CAN error), in
case of a bus- or protocol-error, outside of the "switch (ecc &
SJA1000_ECC_MASK){}"-statement, because this bit stream position is
independent of the error type.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 42323f5e6f3a..5e182fadd875 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -286,7 +286,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -294,6 +293,9 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
-- 
2.25.1

