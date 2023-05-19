Return-Path: <netdev+bounces-3998-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CAB870A027
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 107F11C2134E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D75017AB5;
	Fri, 19 May 2023 19:56:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAF417AB1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:11 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2095.outbound.protection.outlook.com [40.107.8.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3271B7;
	Fri, 19 May 2023 12:56:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUTJ9oAc5oY2lxSMdAghNgP9NsD96mRm/IvN4Qv2wz3HXmb63cJngdZiu3VpBas1KkY68NNqFan9fNE/4I29uF5hV5Kh69HzcMRKeR9bc4I1erVRAKeiLS8X7Zqo5Xg/fNCr03NpAD0T3umSdbonP8teG3I1iiv2zqFeH6qBErfqt8gw+qmh7QR0eCJ8XwvmByFIVv7YI0ShSzRFvkOSZUOzCLLMZgN79BEMkNEOdlho8HJzhooaGejviBLZuOAbS0UN1dCOumc6j4HKZJfAVTKBWqc9L4J9s9pv35jLPPsiLN7JSq+qTf7MKc8OO2cgriM95B2q/l9KKGuafPOEcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pg5KLyGNcqquZBgTVZpaUWi1hgGzCWeIUtx4oZetMkA=;
 b=lfaO452Ye33V/jNEwWnEFXNCWbEINQ5UlFYh5BjGA5/TgcBuJ/hn1aZeMI8IGequzTeC7+PUpt4TL8dy03ZQBGNx/SVgoYL2AnHWyQtby4zMD8MIUyzN3IsBUSsAv5dMiLVG8aSnG09k6A3YV1OVVFkJwXVKzZtNlYtH7D7zLYtFGjWgDiyvaLPPWSO8opo9Cy7nvGhg1KU0+4Rk1E7IDEYQRTmcs/fCFG7a8bTQ5rc2HzFMwC7dPxFWegd4+25JcckcKrwTSSl+oTySN11E8wohMzsbY8P64F0/6szm+WumbkLa1FwybcM7f0RIEQ/4fhBsX4z181Lzi34q1OpZxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pg5KLyGNcqquZBgTVZpaUWi1hgGzCWeIUtx4oZetMkA=;
 b=IHAOHv9IwXrcwmD2Wb1HspSWfFwCSVup4EyDrt33GpsbcyjILzcexFYUtZd+/EF2Avxsdvs8CNbPvN26Tdu/YNf8mHTVUCfQAYtbzBba+/BCiN/PesiwVb6z2KVo68mOeOuHu5rRvmu8vKaMT4jOvLJok5xiakPQaIdfNTs3zxU=
Received: from DUZPR01CA0257.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::29) by AM7PR03MB6216.eurprd03.prod.outlook.com
 (2603:10a6:20b:137::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 19:56:04 +0000
Received: from DB8EUR06FT018.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:4b5:cafe::87) by DUZPR01CA0257.outlook.office365.com
 (2603:10a6:10:4b5::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 19:56:04 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT018.mail.protection.outlook.com (10.233.252.132) with Microsoft
 SMTP Server id 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023
 19:56:04 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E3B177C16CA;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id D2E8B2E1804; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 2/6] can: esd_usb: Replace initializer macros used for struct can_bittiming_const
Date: Fri, 19 May 2023 21:55:56 +0200
Message-Id: <20230519195600.420644-3-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: DB8EUR06FT018:EE_|AM7PR03MB6216:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 9038160e-f3c4-45e1-0ef3-08db58a31414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zl1pSjDI4qe8edalMysUkXm4elrHhQpQsOQ502W57LIm1u7Cl6//Ztl31HzZOWQ3+KMVxuqaKvFC67qTFK0LjL0wPL1IPvt8ZPbiK4zcDLrN+2LFF2+x3WlHMTE01Q2HrxegzViK9BEXP1M8mjojyw5S8p/ZDhGBcyZBz52VBIOl8hJ90nQr2wFX7cvU/h2mW+B9OuiGJUSKgiHWhCWa3aE7qQYm3/nRrA/y31SnvQf2RH2JZNxeLuQ/SPjSoMZO6wkKBSovzFt/tNJBVPTbxibkicN5+R+V1D4MejeM7rXVbVZ+1c6UGASPjT859JFZakom/O2YozfEud6VeTfSMGkv+BwDzWQ0acfxFg7E7z8CUqneXyo5WApPxymgKqd/bj4ecDMD6v1GMKGs3l3WX8YIvaoPwN92BsIdKC46Yhi/VgMokti2H0wMGZCoNahc3RMWUeysgM6iQ7onn/5ANQ0trdZHkp+wfJVVVrXl7LqtXVVUOtBcMts/CatmF164z5v9naDO6sLoKpMvLOd0GjduZmtaq5Y+DGirHr84kwnQmNw5cxfnD+0vbLoLYmrzW15l7HxqlG+VZQdV88qHvqDCl6xb1feKS+VAA2r82KOgcYYy7UhzfbUlEsy1QJVyAdhrAE+yK98mfwJSFTCeBe9Yyry8mFH5EBwl1I5BQm9y7YhiAF6gntgnZg6Si6wX
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(346002)(39830400003)(451199021)(46966006)(36840700001)(42186006)(478600001)(70206006)(70586007)(966005)(4326008)(316002)(54906003)(110136005)(86362001)(36756003)(66574015)(26005)(2616005)(336012)(186003)(1076003)(47076005)(83380400001)(6266002)(8936002)(40480700001)(8676002)(2906002)(44832011)(5660300002)(82310400005)(6666004)(41300700001)(81166007)(356005)(36860700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:04.1735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9038160e-f3c4-45e1-0ef3-08db58a31414
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT018.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6216
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace the macros used to initialize the members of struct
can_bittiming_const with direct values. Then also use those struct
members to do the calculations in esd_usb2_set_bittiming().

Link: https://lore.kernel.org/all/CAMZ6RqLaDNy-fZ2G0+QMhUEckkXLL+ZyELVSDFmqpd++aBzZQg@mail.gmail.com/
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 32354cfdf151..2eecf352ec47 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -60,18 +60,10 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_NO_BAUDRATE	GENMASK(30, 0) /* bit rate unconfigured */
 
 /* bit timing CAN-USB/2 */
-#define ESD_USB2_TSEG1_MIN	1
-#define ESD_USB2_TSEG1_MAX	16
 #define ESD_USB2_TSEG1_SHIFT	16
-#define ESD_USB2_TSEG2_MIN	1
-#define ESD_USB2_TSEG2_MAX	8
 #define ESD_USB2_TSEG2_SHIFT	20
-#define ESD_USB2_SJW_MAX	4
 #define ESD_USB2_SJW_SHIFT	14
 #define ESD_USBM_SJW_SHIFT	24
-#define ESD_USB2_BRP_MIN	1
-#define ESD_USB2_BRP_MAX	1024
-#define ESD_USB2_BRP_INC	1
 #define ESD_USB2_3_SAMPLES	BIT(23)
 
 /* esd IDADD message */
@@ -909,19 +901,20 @@ static const struct ethtool_ops esd_usb_ethtool_ops = {
 
 static const struct can_bittiming_const esd_usb2_bittiming_const = {
 	.name = "esd_usb2",
-	.tseg1_min = ESD_USB2_TSEG1_MIN,
-	.tseg1_max = ESD_USB2_TSEG1_MAX,
-	.tseg2_min = ESD_USB2_TSEG2_MIN,
-	.tseg2_max = ESD_USB2_TSEG2_MAX,
-	.sjw_max = ESD_USB2_SJW_MAX,
-	.brp_min = ESD_USB2_BRP_MIN,
-	.brp_max = ESD_USB2_BRP_MAX,
-	.brp_inc = ESD_USB2_BRP_INC,
+	.tseg1_min = 1,
+	.tseg1_max = 16,
+	.tseg2_min = 1,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
 };
 
 static int esd_usb2_set_bittiming(struct net_device *netdev)
 {
 	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	const struct can_bittiming_const *btc = priv->can.bittiming_const;
 	struct can_bittiming *bt = &priv->can.bittiming;
 	union esd_usb_msg *msg;
 	int err;
@@ -932,7 +925,7 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
 		canbtr |= ESD_USB_LOM;
 
-	canbtr |= (bt->brp - 1) & (ESD_USB2_BRP_MAX - 1);
+	canbtr |= (bt->brp - 1) & (btc->brp_max - 1);
 
 	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) ==
 	    USB_CANUSBM_PRODUCT_ID)
@@ -940,12 +933,12 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	else
 		sjw_shift = ESD_USB2_SJW_SHIFT;
 
-	canbtr |= ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1))
+	canbtr |= ((bt->sjw - 1) & (btc->sjw_max - 1))
 		<< sjw_shift;
 	canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1)
-		   & (ESD_USB2_TSEG1_MAX - 1))
+		   & (btc->tseg1_max - 1))
 		<< ESD_USB2_TSEG1_SHIFT;
-	canbtr |= ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1))
+	canbtr |= ((bt->phase_seg2 - 1) & (btc->tseg2_max - 1))
 		<< ESD_USB2_TSEG2_SHIFT;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
 		canbtr |= ESD_USB2_3_SAMPLES;
-- 
2.25.1


