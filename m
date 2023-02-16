Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22038699CC8
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjBPTFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBPTFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:05:00 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2134.outbound.protection.outlook.com [40.107.14.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C63505CB;
        Thu, 16 Feb 2023 11:04:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1qeiCicgnJ/IrOPaZXTdhuHhEbAzjAx4hI1p6+GbcszcHQmA4QSsgbP0I/t5Q8HdipP5ELpcb0n6BbnKxtadI3VwD1C4Trf7DXuK/sl+o+VI6IlSkqKxYuiyRy/u9DkqRjJ8SBxi87Ef9e9BB3Vc0vIpW4Sn2JcStkxA8y5WkmxZUVlCOe7I0ucc/OKNTRBvpm7shxOupHq+49Z1/DMKGpldfJ4xWezTO1tkXQLKBg8I2T/ckoBBMjhfQ92gEwP6I81fjJA0aTVra1bTP7hVh+buIy8jn7jKIufWPIZCkhFZYZBwMvpXzeiaf5zPW5Z0u5m/CS23fa/Q7CcqfLWxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zj0xEqtN+H4EOpEipAM2uHPkvagu++x98/5zi+k5RMQ=;
 b=QENOYB611p39e3lgHleKwPPha8/ATuGpnxRQMLaaEpSltE//EKWNJQMBQIc9PUlupMoiCmOxgNQ2nBW8ZLv30LR3I3qxy6OYHEF7MVpEaKiyO4tH0Mvt0SpZOTdJSdt4FwDwHArgDjZoiymzIRpSOUHpTzsWNfMBaxOIWRUtJq4gIQvfzTupGlTThqJcZ6lmnSYJIBLebensVQD+578vS7XZeePyKwgqZtKttALOi85S6RDYyHmhFg17pN8ZuiQzDrpbhNCzzvnTaebJOdWmeROvE3NQDPaaMkamV57ndg0zUyA8vaYHeUp7aixuE+sS0DUwnpH6CDivGqnkAxExaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zj0xEqtN+H4EOpEipAM2uHPkvagu++x98/5zi+k5RMQ=;
 b=W7esTjcT4g/XcKqqRILOwx5+gvf1EfvCLTvBoYYDS2yu/rBMCzuYD/oxhgQL89/QhgIXkfYqCNBdvLvPU8cEdudBkHMxOHjaYqe47Q4lQPlMAsBmSzPyy73JxlAhTISQDnccf1a/1rWP/sj2GxE2nEKx0uTle7iGEuB6CoX/JsQ=
Received: from AS9PR05CA0321.eurprd05.prod.outlook.com (2603:10a6:20b:491::14)
 by DB3PR03MB10129.eurprd03.prod.outlook.com (2603:10a6:10:43c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 19:04:54 +0000
Received: from AM7EUR06FT054.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:491:cafe::5a) by AS9PR05CA0321.outlook.office365.com
 (2603:10a6:20b:491::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 19:04:54 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 AM7EUR06FT054.mail.protection.outlook.com (10.233.255.151) with Microsoft
 SMTP Server id 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023
 19:04:53 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 828A67C16C9;
        Thu, 16 Feb 2023 20:04:53 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 7BE462E4482; Thu, 16 Feb 2023 20:04:53 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v3 3/3] can: esd_usb: Improve readability on decoding ESD_EV_CAN_ERROR_EXT messages
Date:   Thu, 16 Feb 2023 20:04:50 +0100
Message-Id: <20230216190450.3901254-4-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
References: <20230216190450.3901254-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7EUR06FT054:EE_|DB3PR03MB10129:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 280cbcd3-5b1d-4a27-6aed-08db1050b005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVntUMeOFbVyd5KtrZckguUpnRgokem2xJWsHBgY7ZFmG65LAC+4p7VMVl+FU85PT65MZ6S8uUDD6cVHXAlcnAF5dUVTKlby2bgmPXoNxzenz3Xg3y3JR8iVt2rZLw9OZWTqQi8TVOZ3jJRDHCO+04gx8sRyeClZz388wjB9K7IC/G1UTMO02NERG3FiFyTkaILkjNRoEvIb4dJk27b5IShJGgHowbzt0fLmyTXG1W3bR7+EF+iJNFn5f3rw72tRGKw+ga5V0SJhngVb9rr9UbpZEipIGv7f2J3ZT60PkqCzU4Pjm5fpg51ahRULPqlV6X9xLFS7Qhqh+FBsly06NHLvBInXtBMVci2rPaC0+q8NgK7646lCDjEd/E/CO0zxQqAIGV0WNzNlB0RKq5trLO4nnRK5R2RQonfNyi0PGpeLbjVg0e1Etx63ReW0+XnJ6wCTjgBcMe+hVW+xmC4UY+dSm+elTvHQe7ajPfq8xbuFW5qXvlfMsbUOI3WpIvVOjBP3s4xPosaDr196ZcYqs/89cL60nqDEI0gSpCRHIRdds/ooI+OOydIq8MzYuZRCTSaRgFhJ56yDj8t5gfTmeoruZS1HQvGL4Fa+qMBo4ku8BmFAqRIv0yLS2aVUK5If5n5mG2ZlHOp/7MI/S/C7qfCdAxCc09u0YGir2AANE3I=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(346002)(39830400003)(376002)(396003)(136003)(451199018)(46966006)(36840700001)(36756003)(186003)(44832011)(2906002)(15650500001)(5660300002)(2616005)(26005)(6266002)(83380400001)(47076005)(356005)(336012)(478600001)(36860700001)(42186006)(4326008)(70206006)(70586007)(8936002)(8676002)(81166007)(41300700001)(40480700001)(1076003)(86362001)(82310400005)(966005)(316002)(54906003)(110136005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 19:04:53.9005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 280cbcd3-5b1d-4a27-6aed-08db1050b005
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR06FT054.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR03MB10129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As suggested by Marc introduce a union plus a struct ev_can_err_ext
for easier decoding of an ESD_EV_CAN_ERROR_EXT event message (which
simply is a rx_msg with some dedicated data).

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/linux-can/20220621071152.ggyhrr5sbzvwpkpx@pengutronix.de/
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 578b25f873e5..55b36973952d 100644
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

