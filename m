Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6946514DD
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 22:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiLSV1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 16:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiLSV1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 16:27:36 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2098.outbound.protection.outlook.com [40.107.7.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BDF646A;
        Mon, 19 Dec 2022 13:27:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dFAUZGYVG46C8RhHEWX0IeFCT5fZcfMwZZdVx8VgUKelBUv23NzwiKKtnrlbNRTXDjLG/SvECkIr1WkLw17JEyB2FMPhABc/alVtMuxXbH+1rFCd2tBYcjzCzRaEX/4s4az24NMG5xJilB/Y7WADB1Ruy0ct1T7Bh2oHLLmq65Lh3UINlYf3gfhysx43GIsdDJe7McnuzeCFXiEK1zpFHk/Zzfa/sCTStUh+aKl96vg532n/XuN+MvZWZ4af+FQ8BXsvXW9uRJUUM9OSun/ZPDOTQGLHF0W4hwEyCABjO8VtUhP+gc0tbnMHEwRRlbcx5pk+2O9eXL11IvEBC2i/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH4Epp4GyGuEC6gorfLFdD6vqnNWemsv/uQaT6+AYik=;
 b=Oiq6VM3xcn+4BpYYbv6HQgOjFtKc5TknN02f4fB1Vij2JsD6hRvCGkYP3YjETVpXRLmI6LakGGA2z+ujBoC6Zb1KG3cZFuoDMc7TUbNo6FVAgfWCKIDfMC7FCjkhTeFpoZSc9e+4QGRmURrYIX4PyD/vqHrhMGtDQNRNJ8IhAX/hflVFivAMXCWmGeDJLnqrFI2xFI1PSS6h8OI5VFY544yCXv/c+Rhx7pZVwbjPXvdjN2Jgwi4Nb/00p0fAFrodD2i65e4TcAik5aG9t/4X2kU7PUnhduEdlS0jx98Y98KwbdzPGzzxxIj+Wyzggwm3RvU12ATKrlt5WlQs2KxYrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH4Epp4GyGuEC6gorfLFdD6vqnNWemsv/uQaT6+AYik=;
 b=CA3IFhpBTrIr1v0GnQD9G1dr3PwWNYe29FbJn86cdctrwGbSMHM9WNudxpXT3rP7jQwrM/D7eWZweZo5edJNzdLmTkFdynu0tFz2tLOpeDZfhCzcHCXXn3yTiSWEciidtj77pymvKFIUckHOlK5wBlnuDHmJ69lxzlP5o6lJs1M=
Received: from AM5PR0402CA0018.eurprd04.prod.outlook.com
 (2603:10a6:203:90::28) by PAWPR03MB10089.eurprd03.prod.outlook.com
 (2603:10a6:102:360::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 21:27:30 +0000
Received: from AM7EUR06FT021.eop-eur06.prod.protection.outlook.com
 (2603:10a6:203:90:cafe::28) by AM5PR0402CA0018.outlook.office365.com
 (2603:10a6:203:90::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.18 via Frontend
 Transport; Mon, 19 Dec 2022 21:27:30 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT021.mail.protection.outlook.com (10.233.255.227) with Microsoft
 SMTP Server id 15.20.5924.16 via Frontend Transport; Mon, 19 Dec 2022
 21:27:29 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 522427C16C9;
        Mon, 19 Dec 2022 22:27:29 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 482F62E1DC1; Mon, 19 Dec 2022 22:27:29 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 3/3] can: esd_usb: Improved decoding for ESD_EV_CAN_ERROR_EXT messages
Date:   Mon, 19 Dec 2022 22:27:17 +0100
Message-Id: <20221219212717.1298282-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
References: <20221219212717.1298282-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7EUR06FT021:EE_|PAWPR03MB10089:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: adeb51a5-21de-4151-4296-08dae207d570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRlsG70RyeU1m0paW1nmLq597/n1aNfmNJAe0NrLOfXm8xaLaU8HEvb5FAMfiQY5f6854fSHDzp8IfMwF4FbUqMGY/LM5vXsZdacVlGjvL3v5xE6mt1oCSjqOhA2+YIxIM+Vf6mSRb7Z4OJh4MQYE+SRqc4TGh7r7/HrE7+dS1z0x7uXPy9YK/9mIHvRRyWXEC6WjGjhq7WOvyPnHlrkmZBTlkhDdyHbZ8kqUjGGt/01ygvOjgNd8XjSs7kfVWwQZueIwxx4d79UIn9yZStax9JZfaJBtfF8Gn3a6Lyi/PZE1jyLuLWwLJd10CGotpXmEg2kHT8KXR0H94wD3We7leyckvGdkGS8jC7KKljfcxdrRMGPn7Wifn+F2DUmoplsT7Wxq3GFJc3qlUnfBMGC5DeBnosiFwEh4L+KKm64snrzGBqAbZtQ3p1SGiSoNvOgeg4uxFp7bYkhjH0TjgI229d0wdRh56xvbhVW3cYmFO3Mmck9KQxTd8Cp/Jpu5VCyZCy6fk798E6E1UwQ9zzOHYf+U/JR3/ku/1eaLtKQkMcnoQIviboZ49i+RJWLZOdBvsmFgS1WwCUeWmVMa+/PXDal0tNx14w8Ighr6RlTNf3BLk6skvPJYBQBv/GlICRCLqjMM/gMaruMOq0Dw01h0QlAVIKTU5ZoAZRrZ0gIwUXDQgbcxS1gAZKc6j15Uu7gbOzcUvVYp6zwGGK2Ei2hFw==
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(396003)(346002)(136003)(376002)(451199015)(46966006)(36840700001)(36860700001)(86362001)(6666004)(2616005)(26005)(6266002)(2906002)(336012)(81166007)(186003)(966005)(36756003)(478600001)(110136005)(316002)(8936002)(44832011)(15650500001)(356005)(54906003)(40480700001)(70206006)(8676002)(82310400005)(41300700001)(1076003)(42186006)(83380400001)(5660300002)(47076005)(4326008)(70586007);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 21:27:29.9117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: adeb51a5-21de-4151-4296-08dae207d570
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR06FT021.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB10089
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Marc there now is a union plus a struct ev_can_err_ext
for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
simply is a rx_msg with some dedicated data).

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de/
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 09745751f168..f90bb2c0ba15 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -127,7 +127,15 @@ struct rx_msg {
 	u8 dlc;
 	__le32 ts;
 	__le32 id; /* upper 3 bits contain flags */
-	u8 data[8];
+	union {
+		u8 data[8];
+		struct {
+			u8 status; /* CAN Controller Status */
+			u8 ecc;    /* Error Capture Register */
+			u8 rec;    /* RX Error Counter */
+			u8 tec;    /* TX Error Counter */
+		} ev_can_err_ext;  /* For ESD_EV_CAN_ERROR_EXT */
+	};
 };
 
 struct tx_msg {
@@ -229,10 +237,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
-		u8 state = msg->msg.rx.data[0];
-		u8 ecc = msg->msg.rx.data[1];
-		u8 rxerr = msg->msg.rx.data[2];
-		u8 txerr = msg->msg.rx.data[3];
+		u8 state = msg->msg.rx.ev_can_err_ext.status;
+		u8 ecc = msg->msg.rx.ev_can_err_ext.ecc;
+		u8 rxerr = msg->msg.rx.ev_can_err_ext.rec;
+		u8 txerr = msg->msg.rx.ev_can_err_ext.tec;
 
 		netdev_dbg(priv->netdev,
 			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
-- 
2.25.1

