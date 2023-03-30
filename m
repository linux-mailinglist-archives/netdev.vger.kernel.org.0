Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EFA6D0E07
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjC3SpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjC3SpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:45:05 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2109.outbound.protection.outlook.com [40.107.20.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F6EB47F;
        Thu, 30 Mar 2023 11:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpHAGJDyFIBhUHuvcfyFnHDCKaQvvW/8cP7aMVAz0UwpbhTy4mfdbmKmK5oAk8MOmDKGkWzRPyH8qSI96Ix0AyvDC7E8yyHnoQWkiZ7G7r/myesVN8MuxFZx+IBokbCOTXhhylPvCRry2BGLwgy0Dw9C+mhfOXiPhyWJy02Req+kM0ClV6OztGGLH3+mc1KEcwduAfoJgx0qlFjeeJP3HjHZGff7aTDVls/Iphq2S1YjbWOlwWogNEtS3FBuOWmQyCuyksglqJuiMQ3Fosm91NXBaD5mZ7b/4hTHNqVidgSVYI9TEIIEO4zgKQBV6Xg4y+W/D6dCdQIRc2GoExeBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lXP6130WUEDWyBIhEjdhpaQ2JobBbDafyi4XRQ/dIc=;
 b=kO7mELR2KBBkamacYBOtbc/K4murOtbBupDHL12A6vpE27Z1sI00c0qVs2GTHhSC1z0ryn3rdCqmkzhoJttN91rlYmdzsir9moRG2ukhfj9GKChHwDm2Wi3EK3vY0uAbbJldj1yN0VjFfGTjWAnDemA+a2QlI5GvIIMSRScdRNnVo1YNeyo1gZ+jhnMZ3vRVOEYDwitLPQoPmwSPg1vVX/VsOBB1Yqh6my4JQS81LWuNW7r2wOPu8l4NC8pK3FUTFyf1CvyheKPupbqILNIAzpmQTsUZmM8HPopdju+Q1CxtzsHG+yup5fc+tagfKZNvdlcmiYiTFA+yrPlhg4XPkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lXP6130WUEDWyBIhEjdhpaQ2JobBbDafyi4XRQ/dIc=;
 b=jTo9pCRaMM5EhyMEVdl0nTYLRFLEIobgNhOUe6kwNAsyDzE1vES/yNeSuDd+x8zKdp+8p+zgLTfnvAdBCPaIvFiTa24UblG3f9RwMc1sXQqjn3tHSBpju5v+YHL5/RuJD5Hmu+yshES2ExFSwposQ540XNeuIyiJeWZn+qS+0ok=
Received: from ZR0P278CA0182.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:44::15)
 by DU0PR03MB9079.eurprd03.prod.outlook.com (2603:10a6:10:466::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Thu, 30 Mar
 2023 18:44:59 +0000
Received: from VI1EUR06FT055.eop-eur06.prod.protection.outlook.com
 (2603:10a6:910:44:cafe::bd) by ZR0P278CA0182.outlook.office365.com
 (2603:10a6:910:44::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 18:44:57 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT055.mail.protection.outlook.com (10.13.6.226) with Microsoft SMTP
 Server id 15.20.6222.22 via Frontend Transport; Thu, 30 Mar 2023 18:44:57
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 93AD47C1635;
        Thu, 30 Mar 2023 20:44:57 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 7C3292E0158; Thu, 30 Mar 2023 20:44:57 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH] can: esd_usb: Add support for CAN_CTRLMODE_BERR_REPORTING
Date:   Thu, 30 Mar 2023 20:44:46 +0200
Message-Id: <20230330184446.2802135-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT055:EE_|DU0PR03MB9079:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 750108e8-1343-4610-26c7-08db314edc73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9t/507usxWORTmYEQq7LjXxW4qLQF9L5UakPnlxhgtNlsDZvOJa/iSwrw34f93pFFZlG7gQLpXyt+8plWqrjDYo13rsAbML+vvZkDDqExmAbc1fX8MsoiSxTVXiVNekZycVmkqoun/Cnv4wWYU+l/d5AkfiiZULdKfsoWhzmJfv6gXmwE1oyIhuhMhhxxtz/P+JKOyix9LI5E/WLrZ5AV+reO089E84O3qh+3se73BvtKrxvQQNzvuEI7JsrYD0l3HoEFhs6K6ssMC1cf3+qAcA4wHTg5VqfDMsv0qqFnDvOQvvJf5dLDKUBUtj/NsiiLb4QclCl1CiqPh5bvvdfrvzqQrlnxIJ5BWXaLjHhw5nY+tKYAfgLJ81ZqGqC2fi9OpvhJUjl/tXD7kB/3/oyRWrQyXdUzfDUYiajXCZLgfvL7a3F54mkBy3d+yvlGfmaWEu6Ralmr3ZSnLJaQYiRjbJumO2xn4pgJ0UfHu1r5f8bCbM/W9eAr6jIBGFkkksW7w0EyIduw9/7t6fycEQTLA7GB/o6KMyDx3Z6lFkyDbewCQgxxW/kZvnEyEV1CDeFf2ZEEXEKhXTn93us0EwpdW4plB8CSQYFD8IVQClBMHLVOrLaV4J96gSJ0gE0w9Wqi3PSTqxs2i4mYm3rp/0f5Kp0ev+Lu6c5t5OAFlfyex0=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39840400004)(376002)(346002)(451199021)(46966006)(36840700001)(6266002)(26005)(41300700001)(186003)(1076003)(40480700001)(6666004)(83380400001)(2616005)(336012)(47076005)(478600001)(42186006)(54906003)(316002)(110136005)(36860700001)(44832011)(70206006)(4326008)(70586007)(2906002)(8676002)(86362001)(81166007)(356005)(82310400005)(36756003)(5660300002)(8936002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 18:44:57.7863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 750108e8-1343-4610-26c7-08db314edc73
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT055.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9079
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Announce that the driver supports CAN_CTRLMODE_BERR_REPORTING by means
of priv->can.ctrlmode_supported. Until now berr reporting always has
been active without taking care of the berr-reporting parameter given
to an "ip link set ..." command.

Additionally apply some changes to function esd_usb_rx_event():
- If berr reporting is off and it is also no state change, then
immediately return.
- Unconditionally (even in case of the above "immediate return") store
tx- and rx-error counters, so directly use priv->bec.txerr and
priv->bec.rxerr instead of intermediate variables.
- Not directly related, but to better point out the linkage between a
failed alloc_can_err_skb() and stats->rx_dropped++:
Move the increment of the rx_dropped statistic counter (back) to
directly behind the err_skb allocation.

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index e78bb468115a..d33bac3a6c10 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -237,14 +237,23 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->rx.ev_can_err_ext.status;
 		u8 ecc = msg->rx.ev_can_err_ext.ecc;
-		u8 rxerr = msg->rx.ev_can_err_ext.rec;
-		u8 txerr = msg->rx.ev_can_err_ext.tec;
+
+		priv->bec.rxerr = msg->rx.ev_can_err_ext.rec;
+		priv->bec.txerr = msg->rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-			   msg->rx.dlc, state, ecc, rxerr, txerr);
+			   msg->rx.dlc, state, ecc,
+			   priv->bec.rxerr, priv->bec.txerr);
+
+		/* if berr-reporting is off, only pass through on state change ... */
+		if (!(priv->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
+		    state == priv->old_state)
+			return;
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
+		if (!skb)
+			stats->rx_dropped++;
 
 		if (state != priv->old_state) {
 			enum can_state tx_state, rx_state;
@@ -265,14 +274,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				break;
 			default:
 				new_state = CAN_STATE_ERROR_ACTIVE;
-				txerr = 0;
-				rxerr = 0;
+				priv->bec.txerr = 0;
+				priv->bec.rxerr = 0;
 				break;
 			}
 
 			if (new_state != priv->can.state) {
-				tx_state = (txerr >= rxerr) ? new_state : 0;
-				rx_state = (txerr <= rxerr) ? new_state : 0;
+				tx_state = (priv->bec.txerr >= priv->bec.rxerr) ? new_state : 0;
+				rx_state = (priv->bec.txerr <= priv->bec.rxerr) ? new_state : 0;
 				can_change_state(priv->netdev, cf,
 						 tx_state, rx_state);
 			}
@@ -304,17 +313,12 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
 		}
 
-		priv->bec.txerr = txerr;
-		priv->bec.rxerr = rxerr;
-
 		if (skb) {
 			cf->can_id |= CAN_ERR_CNT;
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
+			cf->data[6] = priv->bec.txerr;
+			cf->data[7] = priv->bec.rxerr;
 
 			netif_rx(skb);
-		} else {
-			stats->rx_dropped++;
 		}
 	}
 }
@@ -1016,7 +1020,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 
 	priv->can.state = CAN_STATE_STOPPED;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
-		CAN_CTRLMODE_CC_LEN8_DLC;
+		CAN_CTRLMODE_CC_LEN8_DLC |
+		CAN_CTRLMODE_BERR_REPORTING;
 
 	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)

base-commit: db88681c4885b8f2f07241c6f3f1fcf2d773754e
-- 
2.25.1

