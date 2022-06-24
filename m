Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA2C955A1B3
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiFXTF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 15:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiFXTFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 15:05:52 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80122.outbound.protection.outlook.com [40.107.8.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153F181D84;
        Fri, 24 Jun 2022 12:05:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVnEeGnRAhr5k9igcROSZG8wvuxr5b3EbkJ5OZEAAZbaySTFaJ+eIt4TpvQG8XpB4TVMsvh/1MZznfFQI/OoNIcmN8+NNjkR4JRWn5ri4zaxJdSLVMyxYWEQ3dNMcO+dBeSuDmTFepzBvOccUBzpz83jteIqGFU5CbRiDNMmRmHVW9GTn/JylZYTIpcZAT2ly6BbCelt6F6T3DECTj2j6gAwbiuQTe0HIHyV5aeoahvxazfD+QE52VFfvnMlmbtH485XVgUaIZyMW8Sp89YMZFvWWVNlTdNkaKZ0eOUnopTu7N6wceE++ny75pVc2kGaUwJN6rf6h+QRiEtfs/CxFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=phX3IWb8xUL4cfFDdjgmDOI4fjXXaD4MUbNxvxi9flw=;
 b=kvw77Z0frjYeurImypJfFbgF5BgaV1Uy2axEkaYsX0/dXnyhdxPw3qAA4c5hif+45VdMOQvxr6HzHJpU39kLsBxaC3rUYzjIr9seLRZZ0yPlqcKWs/0JaiYmWs8ZKUPxRavi+lJz+Q6prTC4jW6WSOJ7cSP4mz/9OHcVFlYuFyZfn935tZPLp3acPiwEAYocDcuBOJKmbs3dRNETx7Zqz4dtzBZmrhj3W/8NRtsWCfNK0qlMf3LbraxoUXTHKSH5gK55F5pYOnX2/a9AxAGnbG/0obCBumE88O1hYOdsiQtuUYkMlt5G5ZN1KSrNwWVUOq8SLWusi/+H6pYEJX0B0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phX3IWb8xUL4cfFDdjgmDOI4fjXXaD4MUbNxvxi9flw=;
 b=vVdbJ7sX2wVeIcQtGSZbv5oqGjzzMlonbuMI8R3oZJwNp7//sw0uhO7MhNWkSOZVOB6b8paku1xQ44YGKC0/aablJv9xAQYTKZiwUIK8fRvefTVPCo9xxYZ8Dt12VBPXx0CHD681eurUqkuvXmmlu2Jnnr+G0PD8Bw3kv2+ueJw=
Received: from AS9PR06CA0043.eurprd06.prod.outlook.com (2603:10a6:20b:463::19)
 by PA4PR03MB6894.eurprd03.prod.outlook.com (2603:10a6:102:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Fri, 24 Jun
 2022 19:05:48 +0000
Received: from VI1EUR06FT044.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:463:cafe::b4) by AS9PR06CA0043.outlook.office365.com
 (2603:10a6:20b:463::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Fri, 24 Jun 2022 19:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT044.mail.protection.outlook.com (10.13.6.117) with Microsoft SMTP
 Server id 15.20.5373.15 via Frontend Transport; Fri, 24 Jun 2022 19:05:47
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 7A3D67C16CA;
        Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 607AF2E4AF3; Fri, 24 Jun 2022 21:05:47 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 4/5] can/esd_usb: Fixed some checkpatch.pl warnings
Date:   Fri, 24 Jun 2022 21:05:18 +0200
Message-Id: <20220624190517.2299701-5-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
References: <20220624190517.2299701-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 3370a31c-8bc2-4dc6-0db8-08da56148c37
X-MS-TrafficTypeDiagnostic: PA4PR03MB6894:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3g1SqXAJ0Yb9BQXxMyEXn52u88jcK2pSugsvRFmkneYngWkTvThM12PLdX0jLnAwytdFncjYklnGh4sCqEJiLv+U4dXun6/kpRyVWuUqUFFECPxec7HGB4u8uR7qDrv2Hq5QqjOxwW2/SjTmfKUcAuqpmRuzYcoygKvBlnWWA+NPNQ3cvzzGK1jUPu5naJ2JM3kbOgy/JSUzLHdbPlcnJal0RB2D40aUUFLmeMxyL/E23TONR4Lvg41hYuCVe80BB/Hxy9q3fGoV0V7lT2SsvVCKieMZ932sRAjNLGst07BVnkELKLwInnxfVkaKrQqcmbihD0fRdEGD+xJCrhuyOhhiOAbdAt8IXjt+2L3swljKSg5Ybf6OPPZgxkonGnkD98iHliHGlKXlZEMEY+xMg70pJ95kJbIhOTSNenPIRmBZThJXgYuUlWrG+2DyvvB1z7VwpJKmODSCNSq8G20IyYHw7EmjkhVLIN54ti/hbTCbq96FuVaaWh00BfCiE/9z13x4yBjn9NYcfLlgYNe5bjzuULkcRWPayyUHk1N0ynZeA5F/rCBoFqYRbZtx/BRMpRgXoG0n6b4V17Zd9CpyOCSWC+aoi2chiAhT662GTJkCiosW80RIMrPSDJVN3Lf5M3I/y8iLdn/hQIEhddgmmt4X54723z5TmIJaM5Q+p6yI/0aKAD8X85VlZ1q8kdoi0BgVJ020wZLWFQVrrN9nIZJsV0y7LgjEwAHQiSII1CBwSxFJ5isuEHfCru9MxpHvkrGEoE1HTmowLQs6HslApA==
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(396003)(39830400003)(346002)(376002)(136003)(46966006)(36840700001)(83380400001)(8676002)(5660300002)(6666004)(336012)(1076003)(82310400005)(70206006)(2616005)(4326008)(86362001)(40480700001)(70586007)(8936002)(44832011)(186003)(47076005)(6266002)(478600001)(316002)(41300700001)(356005)(110136005)(26005)(81166007)(2906002)(36860700001)(36756003)(42186006)(54906003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 19:05:47.7161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3370a31c-8bc2-4dc6-0db8-08da56148c37
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT044.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6894
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index befd570018d7..e23dce3db55a 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -163,7 +163,7 @@ struct set_baudrate_msg {
 };
 
 /* Main message type used between library and application */
-struct __attribute__ ((packed)) esd_usb_msg {
+struct __packed esd_usb_msg {
 	union {
 		struct header_msg hdr;
 		struct version_msg version;
@@ -343,8 +343,6 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 
 		netif_rx(skb);
 	}
-
-	return;
 }
 
 static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv,
@@ -447,13 +445,9 @@ static void esd_usb_read_bulk_callback(struct urb *urb)
 		dev_err(dev->udev->dev.parent,
 			"failed resubmitting read bulk urb: %d\n", retval);
 	}
-
-	return;
 }
 
-/*
- * callback for bulk IN urb
- */
+/* callback for bulk IN urb */
 static void esd_usb_write_bulk_callback(struct urb *urb)
 {
 	struct esd_tx_urb_context *context = urb->context;
@@ -611,9 +605,7 @@ static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 	return 0;
 }
 
-/*
- * Start interface
- */
+/* Start interface */
 static int esd_usb_start(struct esd_usb_net_priv *priv)
 {
 	struct esd_usb *dev = priv->usb;
@@ -627,8 +619,7 @@ static int esd_usb_start(struct esd_usb_net_priv *priv)
 		goto out;
 	}
 
-	/*
-	 * Enable all IDs
+	/* Enable all IDs
 	 * The IDADD message takes up to 64 32 bit bitmasks (2048 bits).
 	 * Each bit represents one 11 bit CAN identifier. A set bit
 	 * enables reception of the corresponding CAN identifier. A cleared
@@ -776,9 +767,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 		}
 	}
 
-	/*
-	 * This may never happen.
-	 */
+	/* This may never happen */
 	if (!context) {
 		netdev_warn(netdev, "couldn't find free context\n");
 		ret = NETDEV_TX_BUSY;
@@ -826,8 +815,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 
 	netif_trans_update(netdev);
 
-	/*
-	 * Release our reference to this URB, the USB core will eventually free
+	/* Release our reference to this URB, the USB core will eventually free
 	 * it entirely.
 	 */
 	usb_free_urb(urb);
@@ -1043,8 +1031,7 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 	return err;
 }
 
-/*
- * probe function for new USB devices
+/* probe function for new USB devices
  *
  * check version information and number of available
  * CAN interfaces
@@ -1120,9 +1107,7 @@ static int esd_usb_probe(struct usb_interface *intf,
 	return err;
 }
 
-/*
- * called by the usb core when the device is removed from the system
- */
+/* called by the usb core when the device is removed from the system */
 static void esd_usb_disconnect(struct usb_interface *intf)
 {
 	struct esd_usb *dev = usb_get_intfdata(intf);
-- 
2.25.1

