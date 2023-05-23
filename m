Return-Path: <netdev+bounces-4777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4A570E2C3
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2E062813C2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 17:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B09621065;
	Tue, 23 May 2023 17:31:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ACD21061
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 17:31:51 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20707.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::707])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFFB10EA;
	Tue, 23 May 2023 10:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqg0aTWdBjAS/MtGIGFfDVjaxn28JBYQy90Rhlmk2n6MtYNLoCMjpYCyvsvlSwTYKqwklqHV1l2pEHlTnr+yqviLF7X30wSXZWUqJPiOjtTCvSiW8yOa9OWveiuKIcFpsY0t2LNoDyJO2sDicWQJBZe0ThGUcZok9JvPRfr40hsVd+dUleuvCaEjJmUWoQs9Kt9hN626bRGAXoAS9iAZF4OxCbyM4+EwelUQXKl4AEiG96Qk+sK84du9NAJXXz5bi5arOT4Tts/hILMwSHUtNQjYbWKPdwzjakXXhfg5fpuh6PKMdY5/aqiRHSiaF+Jg19m1NIw+lGB0IYvCjw0yAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfJRPzi2hkbffzi6LCRoAYKv7B2ODW65P9OLf03cknE=;
 b=hW0NsLGmEhXIRWRoKp6XPv2ugIbrRu308Ci6fpB7SI6uVXBPI7W7S/L4fy+VV5RnTjTAPu+dZe9syjD1PwPwaPT+k4XSs38ky3UErx5mjCDqsEccwe+Dy+mXkxURCtDiCfcsKKkXiDxgEBZVwJCz/v9QS/gWSX0rpA2Q0c43qLDCh3WB/rWB5BsjonhX0Wh1xx0sxYe9jltRis002tmi9dQclBLf4uy6iWQ7hHaRpgWMYpfECiBw0GQ1MVuXMyKNdpBBCU2KDZJKxNuYiCWhpaoN87J6kQaSP+ronmuMz8j2SSP0KzfGR0AaoNoSck2zUAnyNTDsZfEkR3/hpndkhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfJRPzi2hkbffzi6LCRoAYKv7B2ODW65P9OLf03cknE=;
 b=IrOtSE+ZPEy+Sy7nIlGx1D8497gyT8vG22WmPcUgBak+D9U5mdwTa8msz1I/DQdUpWPcYymq0LupimTYFxQ6+ruFVczSDdeSzKa0Tq7CNVW255lgTHmSYvdt1Cv3+L0cCc3NCGs/KNQ5lCXglfYkMIKmfniLQUm4geEMmupMYZU=
Received: from AM0PR03CA0061.eurprd03.prod.outlook.com (2603:10a6:208::38) by
 AS8PR03MB7477.eurprd03.prod.outlook.com (2603:10a6:20b:2b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.29; Tue, 23 May 2023 17:31:07 +0000
Received: from AM7EUR06FT063.eop-eur06.prod.protection.outlook.com
 (2603:10a6:208:0:cafe::66) by AM0PR03CA0061.outlook.office365.com
 (2603:10a6:208::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29 via Frontend
 Transport; Tue, 23 May 2023 17:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT063.mail.protection.outlook.com (10.233.255.147) with Microsoft
 SMTP Server id 15.20.6433.14 via Frontend Transport; Tue, 23 May 2023
 17:31:07 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id 03EDE7C16E3;
	Tue, 23 May 2023 19:31:07 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id EC1E42E1806; Tue, 23 May 2023 19:31:06 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 2/2] can: esd_usb: Use consistent prefix ESD_USB_ for macros
Date: Tue, 23 May 2023 19:31:05 +0200
Message-Id: <20230523173105.3175086-3-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
References: <20230523173105.3175086-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7EUR06FT063:EE_|AS8PR03MB7477:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: ce9ae933-4035-4392-f8ea-08db5bb37e1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1BupReRPjtI9hZzcaN6gC5LDbZllAaMg7Kv8cbpDIrJ0XH6rNc+ixSqNzmIlUDnS14ipMu+BpHFZZRZHsAI2uyYdOSnzc7Cf//ITZab/uiJw3OGtEMINvB5M+fF4/bV1s/3IGK9OAKl0oXdYGly9qxQ7e6ijPPYefSGNnNBWkHnnXbs5O0gSOI1Q4KDILIOZtfLiXKisE+n0vuCiDbwCEAGM8v9f/eLAjNftW0TvPZm8YzHKtI5j9YE8XLSWiDN9fLbpnAxCqqH7zyzZjrW9VtDpDnBIQYIQgD/uHC55Bgx1JMAQunxwDpM17r0W+5uqFT6CHxPLBwDfBCjKGWgCTD84IpCqRzajmp+DIDXG0jXuAgxa2mo8Dsw4mDLvodq+gEV8cmtah9TNYnHnzi/U3sm5xNdpQEQWYVI9Lgdn8Jh1mKwQnm1aAXBn4CnSn2WC84sGR53PIi2pgddDfyIIVBY7XyI1IgErDZFkdAQSqYVM2ObPUUPtdmRdW2ys21sauzq64lRt3CMeMKPlvQryRXo94kYKPNRmUBqNWJ2lzH1a+jehLPPnyAez6bslLP0/fGHHjogXatPew8NFBfh90Y9MuQawdTQ2d4pOWvuvlAcGxn5qJ7TKiH6x0Kh/3GV68w/u7emjqoScvZRFi0asTyLaXS23iBKHhNpbGuUtpDVxvW/FDUFeYk2UMQdGsxWZredzkZC5dU08mDiVQS/cYQ==
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(376002)(346002)(136003)(451199021)(46966006)(36840700001)(54906003)(42186006)(110136005)(70586007)(70206006)(82310400005)(478600001)(86362001)(4326008)(316002)(36860700001)(81166007)(47076005)(356005)(83380400001)(41300700001)(336012)(186003)(2616005)(36756003)(6266002)(44832011)(2906002)(1076003)(26005)(5660300002)(40480700001)(8676002)(8936002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 17:31:07.5574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce9ae933-4035-4392-f8ea-08db5bb37e1f
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	AM7EUR06FT063.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7477
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Rename the following macros:
- ESD_RTR to ESD_USB_RTR
- ESD_EV_CAN_ERROR_EXT to ESD_USB_EV_CAN_ERROR_EXT

Additionally remove the double newline trailing to definition
of ESD_USB_RTR.

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index d40a04db7458..6201637ac0ff 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -43,8 +43,7 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_CMD_IDADD		6 /* also used for IDADD_REPLY */
 
 /* esd CAN message flags - dlc field */
-#define ESD_RTR	BIT(4)
-
+#define ESD_USB_RTR	BIT(4)
 
 /* esd CAN message flags - id field */
 #define ESD_USB_EXTID	BIT(29)
@@ -52,7 +51,7 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB_IDMASK	GENMASK(28, 0)
 
 /* esd CAN event ids */
-#define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
+#define ESD_USB_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
 
 /* baudrate message flags */
 #define ESD_USB_LOM	BIT(30) /* Listen Only Mode */
@@ -228,7 +227,7 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 	struct sk_buff *skb;
 	u32 id = le32_to_cpu(msg->rx.id) & ESD_USB_IDMASK;
 
-	if (id == ESD_EV_CAN_ERROR_EXT) {
+	if (id == ESD_USB_EV_CAN_ERROR_EXT) {
 		u8 state = msg->rx.ev_can_err_ext.status;
 		u8 ecc = msg->rx.ev_can_err_ext.ecc;
 
@@ -341,13 +340,13 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_USB_IDMASK;
-		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_RTR,
+		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_USB_RTR,
 				     priv->can.ctrlmode);
 
 		if (id & ESD_USB_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
-		if (msg->rx.dlc & ESD_RTR) {
+		if (msg->rx.dlc & ESD_USB_RTR) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
 			for (i = 0; i < cf->len; i++)
@@ -767,7 +766,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
-		msg->tx.dlc |= ESD_RTR;
+		msg->tx.dlc |= ESD_USB_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->tx.id |= cpu_to_le32(ESD_USB_EXTID);
-- 
2.25.1


