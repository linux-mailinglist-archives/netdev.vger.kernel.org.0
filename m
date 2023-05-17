Return-Path: <netdev+bounces-3439-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E25A57071FA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88784280BE2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:23:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6632931F1D;
	Wed, 17 May 2023 19:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2D34CFA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:12 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2092.outbound.protection.outlook.com [40.107.8.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C8D55B3;
	Wed, 17 May 2023 12:23:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYzy5kZNLP3m7FuzFjwEiBR1wTbDYT+3tuB86xG2GdBaSRNfNDq3fym6rWScU2yR0Zc/9qfLWp1JJstEgOKX90PMUt3LAOCzowil6GYmKEwLQl5kvZhIwFIVnAEmYp/QjvbkQXkBWUqeGIW1HSvFVOZjeIZYXUnxz9NXHHYNsY2Cyz1t1jucfzObTDYt7CMWE90rxjTsN1CnBrYhcdH/+mTxVBXldNELgX7m7s7h8Dv7YS2KnzKQ3UJMCLeW4Xctkz31czOx+5JxGhdV344Kf3gf7NU3E2DjUlChW4UcGoY9dzfsVd2COd9eiv7VhmWHy2XrhIhp4YhteW8WrIMcgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIBaIuCZHHN+URf33tUXG+aW7GVOm8HnxPLxte2Sxh8=;
 b=R283vVGX6pJbg9scP8Ib9W1gLop5TKFkMnsAJKFM2jXrWxqZwQ5yaphJxGFfdy3YQQTj3OdypgLRwQxxURXawsOif1m/vhRLPKS0fW4oFggcaonJSa6qKaYNLgj2+ZdzUl/Rj0hlsYIqpL+ZKhFSSklSJJ6k54aFxtVDFvHRkk8hsyOJD7lsFHMzSY0mUJY37bJUz3o2R87/MLfXwlaGopuux2DB8derToMw87qn/Hpk7LPbZXdUcW9k4GOJRdJM+U5sLAlZsNfrq9MF29qHd0P6hrFpAAc7ib5xLVAG3Gl84mq2NBzxUQEBgWQ7VOiSHWV+6NukRlEHoqdbrRnDpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIBaIuCZHHN+URf33tUXG+aW7GVOm8HnxPLxte2Sxh8=;
 b=rLGLXd51an1Qbl4HBi6B1UaokH1XmH4AbzF7z7A+HBkBwFAUHKWt7CqB7z0hHfiUWSK1P7tmhQGjrQ1SjEdtH9ZkXu5RaMxlBM34byQXcOY63Vs6n5OlCqS56E+CPPVqFHmoom+GGilEyX98c/iKBl78YuXiij1MpzB22eIwX7I=
Received: from AS9PR06CA0012.eurprd06.prod.outlook.com (2603:10a6:20b:462::34)
 by AS8PR03MB7816.eurprd03.prod.outlook.com (2603:10a6:20b:34e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 19:22:57 +0000
Received: from AM7EUR06FT010.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:462:cafe::45) by AS9PR06CA0012.outlook.office365.com
 (2603:10a6:20b:462::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17 via Frontend
 Transport; Wed, 17 May 2023 19:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT010.mail.protection.outlook.com (10.233.255.222) with Microsoft
 SMTP Server id 15.20.6411.18 via Frontend Transport; Wed, 17 May 2023
 19:22:57 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E1D547C16CD;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id DAD5B2E1806; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 4/6] can: esd_usb: Prefix all structures with the device name
Date: Wed, 17 May 2023 21:22:49 +0200
Message-Id: <20230517192251.2405290-5-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
References: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7EUR06FT010:EE_|AS8PR03MB7816:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 03e5afbb-336e-40a8-9e24-08db570c1ed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IGPS6w5hGrJgrkCyJ+0Kp6VUc9ty9jbuMGSbjpf9ZmtYfrOGofv/HUx5PMRvSAqi5comWfoP/af7e4JXhu4mWBQgpIKTW5/WPxuE4NG838+tGB0mvM37yn1bXkxDcQId63jg4KQWlUeLXryMeCdkhAJM4CgRPyT13NEySB+aIDDkhq78/KO3zdt9yvgj/X5LdtNrwzWmoRregJn6W2iqRE6SyiCeoZy2wAvEgdKRZRZzin2MWvDIBV/t0ZgSFL0NeYqwHXKwy4V/nAvbVXe4k8C/49o3WChuaGuYknJkAkKuB28GsvIvpFL+RWkvAnm1Js4zQbAtvQ74SOq9Qbv17IgxI1QkmuAi9Fea0J44dW60a/vdaNv4nZwdd4N9Oe4FoR/I9/sJJE6klZ2+9iSiEGud1LzIC0HWfXSCVqKhYW1AWuOIz9hmRPNb16hxIdjTA0T9QsN12xdvm8tVRnI2EXBgrZVZJyOiINcXQhB8iGlEqGb8GadXViIhcdvRH+KaVNSVTZPF+k40JWhiOEbNDM6Qj2JmXVZy82Go1E0wbBH+Ju5BkDekFMi7e/6ewNPBGP0S5QAh6wbafvGKNs7XfPR9LSq9hX5V/66EFwaRRG5qDcCWHv1r3yIt1Qp9LrI3p3wuWipw1xDddLN0vNikWOn8JtFhu+WpSg/JL/dAJdsa4/OPw99f5b75JjoN4ud1ut2s30+ImI3lgZgBCVcwNH4roYwqLM9jfXJvtx0SpnE=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(136003)(376002)(346002)(451199021)(36840700001)(46966006)(83380400001)(6266002)(186003)(26005)(1076003)(36756003)(40480700001)(6666004)(36860700001)(43170500006)(336012)(966005)(2616005)(4326008)(316002)(47076005)(66574015)(2906002)(70206006)(82310400005)(70586007)(8936002)(8676002)(86362001)(44832011)(5660300002)(41300700001)(54906003)(42186006)(478600001)(110136005)(81166007)(356005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:57.0790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e5afbb-336e-40a8-9e24-08db570c1ed7
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR06FT010.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7816
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As suggested by Vincent Mailhol prefix all the structures with the
device name.
For commonly used structures make use of (the module name) esd_usb_.
For esd CAN-USB/2 and CAN-USB/Micro specific structures use
esd_usb_2_ and esd_usb_m.

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 42 +++++++++++++++++------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 23a568bfcdc2..1a51a8541bdd 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -89,13 +89,13 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_MAX_RX_URBS		4
 #define ESD_USB_MAX_TX_URBS		16 /* must be power of 2 */
 
-struct header_msg {
+struct esd_usb_header_msg {
 	u8 len; /* len is always the total message length in 32bit words */
 	u8 cmd;
 	u8 rsvd[2];
 };
 
-struct version_msg {
+struct esd_usb_version_msg {
 	u8 len;
 	u8 cmd;
 	u8 rsvd;
@@ -103,7 +103,7 @@ struct version_msg {
 	__le32 drv_version;
 };
 
-struct version_reply_msg {
+struct esd_usb_version_reply_msg {
 	u8 len;
 	u8 cmd;
 	u8 nets;
@@ -114,7 +114,7 @@ struct version_reply_msg {
 	__le32 ts;
 };
 
-struct rx_msg {
+struct esd_usb_rx_msg {
 	u8 len;
 	u8 cmd;
 	u8 net;
@@ -132,7 +132,7 @@ struct rx_msg {
 	};
 };
 
-struct tx_msg {
+struct esd_usb_tx_msg {
 	u8 len;
 	u8 cmd;
 	u8 net;
@@ -142,7 +142,7 @@ struct tx_msg {
 	u8 data[CAN_MAX_DLEN];
 };
 
-struct tx_done_msg {
+struct esd_usb_tx_done_msg {
 	u8 len;
 	u8 cmd;
 	u8 net;
@@ -151,7 +151,7 @@ struct tx_done_msg {
 	__le32 ts;
 };
 
-struct id_filter_msg {
+struct esd_usb_id_filter_msg {
 	u8 len;
 	u8 cmd;
 	u8 net;
@@ -159,7 +159,7 @@ struct id_filter_msg {
 	__le32 mask[ESD_USB_MAX_ID_SEGMENT + 1];
 };
 
-struct set_baudrate_msg {
+struct esd_usb_set_baudrate_msg {
 	u8 len;
 	u8 cmd;
 	u8 net;
@@ -169,14 +169,14 @@ struct set_baudrate_msg {
 
 /* Main message type used between library and application */
 union __packed esd_usb_msg {
-	struct header_msg hdr;
-	struct version_msg version;
-	struct version_reply_msg version_reply;
-	struct rx_msg rx;
-	struct tx_msg tx;
-	struct tx_done_msg txdone;
-	struct set_baudrate_msg setbaud;
-	struct id_filter_msg filter;
+	struct esd_usb_header_msg hdr;
+	struct esd_usb_version_msg version;
+	struct esd_usb_version_reply_msg version_reply;
+	struct esd_usb_rx_msg rx;
+	struct esd_usb_tx_msg tx;
+	struct esd_usb_tx_done_msg txdone;
+	struct esd_usb_set_baudrate_msg setbaud;
+	struct esd_usb_id_filter_msg filter;
 };
 
 static struct usb_device_id esd_usb_table[] = {
@@ -899,8 +899,8 @@ static const struct ethtool_ops esd_usb_ethtool_ops = {
 	.get_ts_info = ethtool_op_get_ts_info,
 };
 
-static const struct can_bittiming_const esd_usb2_bittiming_const = {
-	.name = "esd_usb2",
+static const struct can_bittiming_const esd_usb_2_bittiming_const = {
+	.name = "esd_usb_2",
 	.tseg1_min = 1,
 	.tseg1_max = 16,
 	.tseg2_min = 1,
@@ -911,7 +911,7 @@ static const struct can_bittiming_const esd_usb2_bittiming_const = {
 	.brp_inc = 1,
 };
 
-static int esd_usb2_set_bittiming(struct net_device *netdev)
+static int esd_usb_2_set_bittiming(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	const struct can_bittiming_const *btc = priv->can.bittiming_const;
@@ -1026,8 +1026,8 @@ static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 	}
 
-	priv->can.bittiming_const = &esd_usb2_bittiming_const;
-	priv->can.do_set_bittiming = esd_usb2_set_bittiming;
+	priv->can.bittiming_const = &esd_usb_2_bittiming_const;
+	priv->can.do_set_bittiming = esd_usb_2_set_bittiming;
 	priv->can.do_set_mode = esd_usb_set_mode;
 	priv->can.do_get_berr_counter = esd_usb_get_berr_counter;
 
-- 
2.25.1


