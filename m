Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1392699CCF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjBPTFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBPTFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:05:00 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2131.outbound.protection.outlook.com [40.107.249.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42180505D8;
        Thu, 16 Feb 2023 11:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4gBsM1tXz/J/s+N6k2YMIS9vZQg1uirvrpofEKC9FhmUaxDNeDx5ecLTDr8vjBNipOqJ1yA3ljkPBXTP+mI5zpJ+3K0TCuBc0Q9nYsyMXH3U7O2DikfQBlUEkmcXuTj0yS4wX2mVU4tfVQYgRFt5t1A7pgjq4JmyArheChDWukwgpV7M/v1KnBXhuFqKuOInfiQhVXPhtEUUV35Bq9sqvMXHf3NfUaS+MJ5IT23Pl3AYeIeZSWJ+k0MAiTN16JoEQD2eWa21e4hmC/coyo9lPb1jjGfUMwol9Uf/nW9ZTWM+gd1obGh+0o8WVyfoU1721hOcsDhFEi2CbWquRF0EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5p9oaC9ysELqUQEUHCq7WcRrA5JWUMDVBZ3g6GDdMSY=;
 b=DHRmrWrsCw8yqFZl38zG+n7ANPMu6Ubv86BhkExrhDeHmoBAYJmpJb3UZO39PVYAY6R/VR/BRskQABifqMXpfEuG2Q3f/41PDsVzMM5Dd+at6+DIvjHO3wYksRQLQcl5kzPw2SnjDpxC9LdshqRvICOTDYe2bjeO80n0hqhatv4ktBkrDsIpE9DYRqSUkVBp96FTn5DKsWspb9T9FHRmlgwdSigYw67T9L6QpsFa5aXvOQvg7qkTcg+Vkzn0w/I+wZw9/ILTZNtsl5w6tmJbCVUrWnpTGVc3s86z0GeEotfKqVfjjuHugXVX9yDvXkwoEETAcYiK/u8mpTarugAuQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5p9oaC9ysELqUQEUHCq7WcRrA5JWUMDVBZ3g6GDdMSY=;
 b=npSmvLkS01CQa1p6vOT3kUPuAKhHbUve2TEzTs4IF64mF2pGWHhYQ3eAt78Elt7zdKI+0w+zNdVeeK1nbnMYi9EElheXDNGNr2EgDUPmqULeAsh4QDPhKzUBAmfgl8varBtHGuIk5BFNrMCJdMJ7QSRhFGPWtuTtHumA7dnQTdk=
Received: from FR3P281CA0180.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a0::13)
 by GV1PR03MB9870.eurprd03.prod.outlook.com (2603:10a6:150:3d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 19:04:54 +0000
Received: from VI1EUR06FT024.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:a0:cafe::48) by FR3P281CA0180.outlook.office365.com
 (2603:10a6:d10:a0::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 19:04:54 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT024.mail.protection.outlook.com (10.13.7.235) with Microsoft SMTP
 Server id 15.20.6086.24 via Frontend Transport; Thu, 16 Feb 2023 19:04:54
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 83C067C16CA;
        Thu, 16 Feb 2023 20:04:53 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 763EB2E4481; Thu, 16 Feb 2023 20:04:53 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v3 2/3] can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL
Date:   Thu, 16 Feb 2023 20:04:49 +0100
Message-Id: <20230216190450.3901254-3-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
References: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT024:EE_|GV1PR03MB9870:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 52ea519a-7b09-401f-7609-08db1050b026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4ahGyqAIfu5aN/6b1SgAjP3LRZiiWFs1RElbP/qmwETA3vYkixEEGboOwVyPoRaDiYkNpK9cbpo6GehWgs0lLhRlOsypOwlZYjDMDRiM9gBoGOeo4jzEPF8uQEIpNJ1IRsw9MpROsqNmfGkdEXUwUj2aos1FI0qUPQJ5dCSJpozJQjHNDeBz1A3b7QTBFIjqP9hauVr/SodyoyFE2F4TzC4QKeb+HflghxeCiYHJ8AkETcEhQ6C7Vn//NVEWcE56jRqDUUktJgM8ajFtc8oR6IYfGD1w9MDlhnVcsWElK2KgzOrtbfDBihk6KitAKRAsna3lEL8mAvBOo3oNM29yiA6jyNS3dBS1IcrzDde32sMXKul2geAymgMct1qgjbObTikbCaFg02GbRoRZGwZyumbJWG2O7WJ5u3vMyUxSpe6FRThPLgVuhGqJj9ONRWC4IChHZsd5EqvJHDJtdchZkhJnYCUb92RB4l0P4GONn2oqtyaLUpu8z8Q1gCA0l2Tss2KHQ4OCgDxNvCX14ivarml0ywTsJaCMcANv0XVHCVNkauSlZLpD2qFLnQZ1ihzDPKFGkiFTFifwfSyfYIWuTQHhF+cLx9Mf28C6swjFebzvTAhS8D05pThsju1uQMl2ateaf3WlBIVzx9jTOvqJtzwYrLEi4sNnPhVbWZIZWBlcA7mkAlsKZCZXiL/tmwq
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(136003)(376002)(346002)(396003)(451199018)(36840700001)(46966006)(6266002)(2906002)(8676002)(356005)(83380400001)(81166007)(70586007)(8936002)(36756003)(41300700001)(1076003)(966005)(5660300002)(26005)(70206006)(36860700001)(47076005)(40480700001)(336012)(186003)(316002)(82310400005)(86362001)(54906003)(42186006)(110136005)(4326008)(44832011)(6666004)(2616005)(478600001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 19:04:54.0858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ea519a-7b09-401f-7609-08db1050b026
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT024.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB9870
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start a rework initiated by Vincents remarks "You should not report
the greatest of txerr and rxerr but the one which actually increased."
[1] and "As far as I understand, those flags should be set only when
the threshold is reached" [2] .

Therefore make use of can_change_state() to (among others) set the
flags CAN_ERR_CRTL_[RT]X_WARNING and CAN_ERR_CRTL_[RT]X_PASSIVE,
maintain CAN statistic counters for error_warning, error_passive and
bus_off.

Relocate testing alloc_can_err_skb() for NULL to the end of
esd_usb_rx_event(), to have things like can_bus_off(),
can_change_state() working even in out of memory conditions.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: [1] https://lore.kernel.org/all/CAMZ6RqKGBWe15aMkf8-QLf-cOQg99GQBebSm+1wEzTqHgvmNuw@mail.gmail.com/
Link: [2] https://lore.kernel.org/all/CAMZ6Rq+QBO1yTX_o6GV0yhdBj-RzZSRGWDZBS0fs7zbSTy4hmA@mail.gmail.com/
---
 drivers/net/can/usb/esd_usb.c | 50 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 5e182fadd875..578b25f873e5 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -239,41 +239,42 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
-		if (skb == NULL) {
-			stats->rx_dropped++;
-			return;
-		}
 
 		if (state != priv->old_state) {
+			enum can_state tx_state, rx_state;
+			enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
+
 			priv->old_state = state;
 
 			switch (state & ESD_BUSSTATE_MASK) {
 			case ESD_BUSSTATE_BUSOFF:
-				priv->can.state = CAN_STATE_BUS_OFF;
-				cf->can_id |= CAN_ERR_BUSOFF;
-				priv->can.can_stats.bus_off++;
+				new_state = CAN_STATE_BUS_OFF;
 				can_bus_off(priv->netdev);
 				break;
 			case ESD_BUSSTATE_WARN:
-				priv->can.state = CAN_STATE_ERROR_WARNING;
-				priv->can.can_stats.error_warning++;
+				new_state = CAN_STATE_ERROR_WARNING;
 				break;
 			case ESD_BUSSTATE_ERRPASSIVE:
-				priv->can.state = CAN_STATE_ERROR_PASSIVE;
-				priv->can.can_stats.error_passive++;
+				new_state = CAN_STATE_ERROR_PASSIVE;
 				break;
 			default:
-				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				new_state = CAN_STATE_ERROR_ACTIVE;
 				txerr = 0;
 				rxerr = 0;
 				break;
 			}
-		} else {
+
+			if (new_state != priv->can.state) {
+				tx_state = (txerr >= rxerr) ? new_state : 0;
+				rx_state = (txerr <= rxerr) ? new_state : 0;
+				can_change_state(priv->netdev, cf,
+						 tx_state, rx_state);
+			}
+		} else if (skb) {
 			priv->can.can_stats.bus_error++;
 			stats->rx_errors++;
 
-			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR |
-				      CAN_ERR_CNT;
+			cf->can_id |= CAN_ERR_PROT | CAN_ERR_BUSERROR;
 
 			switch (ecc & SJA1000_ECC_MASK) {
 			case SJA1000_ECC_BIT:
@@ -295,21 +296,20 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 			/* Bit stream position in CAN frame as the error was detected */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
-
-			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				cf->data[1] = (txerr > rxerr) ?
-					CAN_ERR_CRTL_TX_PASSIVE :
-					CAN_ERR_CRTL_RX_PASSIVE;
-			}
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
 		}
 
 		priv->bec.txerr = txerr;
 		priv->bec.rxerr = rxerr;
 
-		netif_rx(skb);
+		if (skb) {
+			cf->can_id |= CAN_ERR_CNT;
+			cf->data[6] = txerr;
+			cf->data[7] = rxerr;
+
+			netif_rx(skb);
+		} else {
+			stats->rx_dropped++;
+		}
 	}
 }
 
-- 
2.25.1

