Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235F456BFD8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238917AbiGHSOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238544AbiGHSN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:13:58 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30117.outbound.protection.outlook.com [40.107.3.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBCC5F9E;
        Fri,  8 Jul 2022 11:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3Zf4GHd86PcC3u/zvMsKVDRxzglbMtgpl/ZhC9HyxQRoN7Ja1bacG0bofyEmf4Cb4P1z/7u0Jns53uwFm3di+ffF9ounH+NBFr3mVI88e04mKC7B8jZvhB/uIwi4AsIIVLSmfH4cgB41YIuqEyHbIUg+TwkzgWp7/xsWgWHopXii/ltdiThftCNAA0cGFt6LKqgJfNagvVB7Co0GlsvNjL7Y1cPsIdW30OFRZCz6BnwirL4djwi4gQASoz7XgaqmOpBBpkh9zZ/9czgHZ4Xdzkxwt36yWWZDPXRG0wAjkeeP/kAhJglHBSju+L566GoEUpFb94k5Ti3z5km1c0TFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=49S1Kkf0CYngJdNekyjy20D/G1UCSrwpzPLPvtp+OQ4=;
 b=N9TEJLVFeb6uQUavazJVaWIfcONXXjkfOp0qgoFndGMAAXHq4SHyAj3fS7YcmC28gXy9zTrREsxqoYQOc7g14rBwu95eSg/8oPDNozuUPJyEKBCRnnFrZXdgO+l1S9eqYfKmpGM3/7v4HuFaWaHlR+/jXosV7QqvSBLBsnUicGXCaazCDdWE7FvHrYncX2/cjkokcquonEjYepIEHdv4y2hIU9xr8GzOfnDP//OTuryIqmQD28bURoVS+2ifITHelYLOcSKL+YTRKK6DvSfABfYtij4krLqOWY/X5MFensipG1qbH1CXE/2WitV3pEUpazL/AA5OT0wVw203atTxrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49S1Kkf0CYngJdNekyjy20D/G1UCSrwpzPLPvtp+OQ4=;
 b=BArh7nez5ldwVBut+90M3mX3nu8pidpAC3CtmHhOXMD9/A7BAvig249l612klCW0WhXHN+oE0LEOygS1DgDyks9NvZ7D9eTukjDu/tu/DFr+E4uvn8eaK7cfk+V3fa/qYgJ5D2sOtgzDaTT36B2CxeyQ1yhDjDYoaRNR4TfDoAw=
Received: from AS9PR06CA0094.eurprd06.prod.outlook.com (2603:10a6:20b:465::7)
 by AM6PR03MB3992.eurprd03.prod.outlook.com (2603:10a6:20b:20::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 18:13:55 +0000
Received: from VI1EUR06FT034.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:465:cafe::98) by AS9PR06CA0094.outlook.office365.com
 (2603:10a6:20b:465::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.17 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT034.mail.protection.outlook.com (10.13.6.148) with Microsoft SMTP
 Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:55
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id C05057C16C9;
        Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 771E62E4AF7; Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 5/6] can: esd_usb: Improved support for CAN_CTRLMODE_BERR_REPORTING
Date:   Fri,  8 Jul 2022 20:12:36 +0200
Message-Id: <20220708181235.4104943-6-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: cd9c6883-5385-44df-a7d3-08da610d9eb3
X-MS-TrafficTypeDiagnostic: AM6PR03MB3992:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Siqpsmome+svwPutO9puNb/gKKdYbDGikL5crd4LIM7N7MiF+mVaz9VG0RrrD4r1HzDFLOqiQTzYtVk5VE+1dpo42EgXrGi0Z+9u6zubyF6fIAJ8S29om9UnNiJGRwP7/VzcFcRyQUcvHDTYHSWZ8hftaqdGgVlf20U0AOB5YD9h4CsP3scUp+VknTvFkEfa9bDYpk5AXHwpJ5T7BHB8oOaf/1UmxwqBevL8Qt2QcgkcomMejK6bRyvSPLygfSmBsBzKsYH7WFAWRECSEDwmBS8UAXq1h/CtuTkxSV5Qz2yo4z9wSkLWdSjKn7CXVV8QCEQvCkQTMQSCTd1JP8gpL/jJdgoBy4XJr4QahDnJy/j8F3AYaY0nr9E+CgYBwtiQ8X5t4sfoKxn9L+DNaCGFIfsEH3EKACcbegGWPTPubvZQp7ZPzmpM9lNu0Ok3DRCMEGgJnjC/9A1WBJly6nesgbaYuvnebD4ag9TzJUShAfX37uFm9DZN+G92TrKCZeLxEje/wzqvu2AevIb7/xqu9wmM47uH90+YFmIZNe56cxyZSAoGNsEDYxz8W1FNeJmJj/hCIJIekHc775EpnSziKFiOBGyWhD6vpWr9ydMlBL97Z7LUBtkVZ2KwShK2ir8H5owOnaiodDKmBfZubmNZOzdq279LuV/cFhIHbah56P5Chtx7hWvgvgvOTsLxTHfGvOp0gYAIzhCbzu0512nREPM5jI9iiYrYO1NVTtRzXlqz3rV3FCjkMXPbsG32ILqSwuh5tvSjpvXt0ujh9W3X7O4DTHxj7oTcz3ccN4NPA9E=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(396003)(39830400003)(36840700001)(46966006)(356005)(83380400001)(44832011)(186003)(47076005)(336012)(8676002)(1076003)(81166007)(5660300002)(36860700001)(8936002)(40480700001)(82310400005)(2906002)(2616005)(478600001)(70586007)(4326008)(70206006)(41300700001)(6666004)(6266002)(316002)(110136005)(26005)(54906003)(42186006)(36756003)(86362001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:55.0452
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9c6883-5385-44df-a7d3-08da610d9eb3
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT034.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3992
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bus error reporting has already been implemented for a long time, but
before it was always active! Now it's user controllable by means off the
"berr-reporting" parameter given to "ip link set ... ", which sets
CAN_CTRLMODE_BERR_REPORTING within priv->can.ctrlmode.

In case of an ESD_EV_CAN_ERROR_EXT now unconditionally supply
priv->bec.rxerr and priv->bec.txerr with REC and TEC.

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 47 ++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 588caba1453b..09649a45d6ff 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -230,12 +230,23 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc   = msg->msg.rx.data[1];
-		u8 rxerr = msg->msg.rx.data[2];
-		u8 txerr = msg->msg.rx.data[3];
+
+		priv->bec.rxerr = msg->msg.rx.data[2];
+		priv->bec.txerr = msg->msg.rx.data[3];
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+			   msg->msg.rx.dlc, state, ecc, priv->bec.rxerr, priv->bec.txerr);
+
+		if (ecc) {
+			priv->can.can_stats.bus_error++;
+			stats->rx_errors++;
+		}
+
+		if (state == priv->old_state &&
+		    !(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING))
+			/* Neither a state change nor active bus error reporting */
+			return;
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
@@ -270,16 +281,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				 * berr-counters might stay on values like
 				 * 95 forever ...
 				 */
-				txerr = 0;
-				rxerr = 0;
+				priv->bec.txerr = 0;
+				priv->bec.rxerr = 0;
 				break;
 			}
 		}
 
-		if (ecc) {
-			priv->can.can_stats.bus_error++;
-			stats->rx_errors++;
-
+		if (ecc && (priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING)) {
+			/* Only if bus error reporting is active ... */
 			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 			/* Store error in CAN protocol (type) in data[2] */
@@ -301,29 +310,26 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
-			/* Store error in CAN protocol (location) in data[3] */
+			/* Store error position in the bit stream of the CAN frame in data[3] */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
 
 			/* Store error status of CAN-controller in data[1] */
 			if (priv->can.state == CAN_STATE_ERROR_WARNING) {
-				if (txerr >= 96)
+				if (priv->bec.txerr >= 96)
 					cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;
-				if (rxerr >= 96)
+				if (priv->bec.rxerr >= 96)
 					cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
 			} else if (priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				if (txerr >= 128)
+				if (priv->bec.txerr >= 128)
 					cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
-				if (rxerr >= 128)
+				if (priv->bec.rxerr >= 128)
 					cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
 			}
 
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
+			cf->data[6] = priv->bec.txerr;
+			cf->data[7] = priv->bec.rxerr;
 		}
 
-		priv->bec.txerr = txerr;
-		priv->bec.rxerr = rxerr;
-
 		netif_rx(skb);
 	}
 }
@@ -1021,7 +1027,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 
 	priv->can.state = CAN_STATE_STOPPED;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
-		CAN_CTRLMODE_CC_LEN8_DLC;
+				       CAN_CTRLMODE_CC_LEN8_DLC |
+				       CAN_CTRLMODE_BERR_REPORTING;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)
-- 
2.25.1

