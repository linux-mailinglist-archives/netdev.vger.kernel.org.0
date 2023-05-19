Return-Path: <netdev+bounces-3997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D2570A026
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B26AB281B7C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18A717AB2;
	Fri, 19 May 2023 19:56:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1A117AB0
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:11 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2117.outbound.protection.outlook.com [40.107.20.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEBF1BC;
	Fri, 19 May 2023 12:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUVpHJua0Z7fsZMfpfBnoncnSX+gxhb+mmCww+rUxr3I5hRH4TbHWH36gPpgb9Cxob2/fzoam95jK5QB4EypsxhoBrzz0/Ko6mEGIgYEIn/qPnju+HFWWWlKwZMP2Wa/4pUkaLfxJZH59Q+b13m/+ObnckfXRvyWaYv6LUna8WsHDispsb7fxtjfUUzmRm7PhJCd0CgSEUnu5nNX0NA/DOi8tzm2SaH4bczZsrlLY+3+OGV730geg5INodQEBYHb6EQy8hletJwbmSexbTUAFE0q/UZXMawOaZgzR489ORUlIWDQVel/Qy9GvSFZzInzo50EqB2JdLJjRpsj/D0fNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWPaKPvPmfPPuYmV9azX+/2AGvu/iMDViKWdkbJgO+8=;
 b=TFMmBAMwyclIjBce/D4Q1+aws77yahpuWVuli8Rq43LKd7C1w+YVu/NHNaiGW6d+l8K7K7gY5z8mYCufA6KQbuxjVlFwpd1fh9fX8WTePbm414zkE9mx/LLKFCcWVI3CmhUkgMXRQgD3B/mCe3a++EpmrLSdlJsgyJsRQjqc5hzAka55v9l/uZPE/jkhqA6/gdTL5NFGHKX1gSmSMd29AfjtrjsCeXJwFB0HzrpZjUWLywvEnrIElz0+fXSk7bCPldVjsilNkwfn/dlhCMGb6kMEWDhI/r1l7+Bblb348wDtQwh2E6yMaLUax75RlbrQ3SR9c+pne9PvZWXr8UIwYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWPaKPvPmfPPuYmV9azX+/2AGvu/iMDViKWdkbJgO+8=;
 b=f7xR8R5gLrA4pRyb2s8+cUUBxvBswWvNOroP7pwXTpgJut14Gv0qkwffjhmkapogI6FkFPtsBQbX6yDS9F1FBSMKxIYrMiiaCIN9nXP23SCcxv8X436F0j+y4uPYBzvYnSzXoDiZnzMFi1QtTdEOLm9zLFlhf0GimXn0+rwnrqo=
Received: from FR3P281CA0198.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a5::20)
 by DBBPR03MB6988.eurprd03.prod.outlook.com (2603:10a6:10:1f5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 19:56:05 +0000
Received: from VI1EUR06FT018.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:a5:cafe::b6) by FR3P281CA0198.outlook.office365.com
 (2603:10a6:d10:a5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.14 via Frontend
 Transport; Fri, 19 May 2023 19:56:05 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT018.mail.protection.outlook.com (10.13.6.215) with Microsoft SMTP
 Server id 15.20.6411.19 via Frontend Transport; Fri, 19 May 2023 19:56:04
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E4CE97C16CB;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id DAEC52E1806; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 4/6] can: esd_usb: Prefix all structures with the device name
Date: Fri, 19 May 2023 21:55:58 +0200
Message-Id: <20230519195600.420644-5-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230519195600.420644-1-frank.jungclaus@esd.eu>
References: <20230519195600.420644-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT018:EE_|DBBPR03MB6988:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 5f0f8acf-6dbf-4e33-627d-08db58a3143f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nZfsljIpssm+1i0kBvS8FYtMh9dBxHap9CWeD+6AyCtQOEPqts2bQFvD1fKGtTxBWZ/ib0zQC8mI94wBicpj70iiJMKvvjEWLIEURbRF07tPJ2wPL+dei/yanLQgFajedbxJHVsznCBTGBPzAT5juI/suPES8bqXVvi6CWVXfSep92lT/4AE+lqgTbB88rz8uZY5MZCUurnuRkMefx6kRaKAyKaFB9AqsdpobAglnVfJb3Xs5SWCZyxYKdhGQXyf+Q3+KO6WWEdTbV21UIw5aee8uHRPE6VtZjmOaEVLNm11Fwip8AqcgZdFBuiiOnLPzp3RniiRBV2wGeq0MchnhilcrWeeNaaGSXKwi8J+rW8iWK6QGluIk/uBOTzNKPg9arwgCoEBKUXgskx0Z1LoFjtk40rV3dR5JSgTHb3QxXkk2qcq3HbozgTczfPwQZTXhO3MaNnEkXIO3JTkZ4PtKUdjaMbcccwk9R8IhN3j7p+YCG2lVBdztcFPeUFYcob2WxR3HBlvYoYLmARs5BlW55AyXJIiTspPwtGXLUh3GS0UVweoELe2ZaPDFhB3Te2yANTfKq6WoLavXxoCtk1666F3Uc4aleakPc/iNVf79xOs2dv8qYhB0VfcObOjHLkYIFe1sgz20QheplcPC3xu+tAWkIwJ6YzD7gxDOdpJEj4DKjVWakvw6T3SvWDoowgZ25G4Zt4ew1vCbj7JxhpSG12MQGa/ZcJfXEON97WjASQ=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(396003)(39840400004)(451199021)(46966006)(36840700001)(82310400005)(40480700001)(43170500006)(336012)(2616005)(44832011)(8676002)(1076003)(26005)(5660300002)(8936002)(36756003)(86362001)(2906002)(83380400001)(47076005)(66574015)(36860700001)(41300700001)(478600001)(4326008)(316002)(110136005)(6266002)(186003)(70586007)(70206006)(42186006)(54906003)(966005)(356005)(6666004)(81166007);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:04.4887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0f8acf-6dbf-4e33-627d-08db58a3143f
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT018.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6988
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Prefix all the structures with the device name.
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
index 9b0ed07911e1..24eebb7ee5f1 100644
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


