Return-Path: <netdev+bounces-301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50A406F6F4C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4668280D7B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9B0A943;
	Thu,  4 May 2023 15:44:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57075A942
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:44:30 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2115.outbound.protection.outlook.com [40.107.21.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A703588;
	Thu,  4 May 2023 08:44:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/Qm2V1GjT2rKkDhNqLIO8fBq3Hn/6hrvx1WRz509bPYGhGn1DgggF+4Js6OFaaqkDpEPgHfHUNUNjUgo6jlHwk1sDXZ+sj7yn6l0Xfz1npPkx7MMOCou/GZK3ZEgFcAn+hvYhof15XSlKcwOEzri4wRSyRknK3Vgamw4V5huqLXbyci/joloGTj24NX43nu+CmibYAgGni86VsaOzffDFuu9m225Y551PF5iSNaCzYWTKJZi4lX4hI9fW65CbqbeUdKza9viS/FcQ8R+LVBKufSqwtZCU81fAjArKEelE74PKiDLuk8sBrYOM3Nvp7dB3mkoK5QPMcz6/7B/RCThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q3FFRqjYIz5bJPdrk5Xb8yocu8C//C5VjGDJIC1ks2w=;
 b=dfJlE7wRMLToDwnhuiZmFe55+4NJJFfrYphRxmX5Piu/rABsF45k3u3ljPXfkBG/mLB8CGhWKvAkno579DiCZ4i5XjF/pqvzpxbB96jFgPRqP16lotdmU/G3Np0el08dwbAhH7FKXpgDg+/6FVB8kDuud5Hpjb1wBWgXR4Zz3agoNdbrVulChO+rSaNM06SBoG2yIn6Gek0xbHAKhX9ByzlryLD9JMuU0wDLVr2n1QPmk7v1HiZ+zJXpCTci08fbNgxeZNDjX5Kz00ScpsUJHtlC3m2Mr2Pwgssp7fZYnLA2mxTDS1lWiKgmBjEdXMlrlMU4aQTu0DXcal2/JOlF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3FFRqjYIz5bJPdrk5Xb8yocu8C//C5VjGDJIC1ks2w=;
 b=nqSFSkquIIrF8c6rrlSlRBB2oQCuFXHt4JcefyAWyG1AqfLaZIAOtiSCnoY54haK04KojBwd9FpMPZzlAMwApO0qgcZsgBjurT6KqmR8nbk+W00y6yxEC6kfsH5xbln8x+oZXgrTn2ZmR1zOzHb0HW0j4WzN3kFkDOZ3m85QGAU=
Received: from DUZPR01CA0208.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::6) by PAXPR03MB7951.eurprd03.prod.outlook.com
 (2603:10a6:102:21a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 15:44:23 +0000
Received: from DB8EUR06FT027.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:4b6:cafe::9d) by DUZPR01CA0208.outlook.office365.com
 (2603:10a6:10:4b6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 15:44:23 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT027.mail.protection.outlook.com (10.233.253.49) with Microsoft SMTP
 Server id 15.20.6363.22 via Frontend Transport; Thu, 4 May 2023 15:44:23
 +0000
Received: from esd-s20.esd.local (jenkins.esd [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E6EFC7C16CA;
	Thu,  4 May 2023 17:44:22 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id DC5652E1787; Thu,  4 May 2023 17:44:22 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/2] can: esd_usb: Apply some small changes before adding esd CAN-USB/3 support
Date: Thu,  4 May 2023 17:44:13 +0200
Message-Id: <20230504154414.1864615-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230504154414.1864615-1-frank.jungclaus@esd.eu>
References: <20230504154414.1864615-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT027:EE_|PAXPR03MB7951:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0322c343-f769-4f24-4055-08db4cb66ef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qPes0FcqFv6j07TcwxDPMG9DVNINh6isIXXcnQSRIjkKmzZowM+8s15pw/XZ06DYYhD+OlHZvw7pySplMlRb1WcbgKjhbjacI2zpk9QxDFxZaMLrttYBT6rWaOJxJfPYwKWq0yZLVvaXL3xJ/heEJOK3J9NLvUx/aE+AT7uNx6Z9pHXwy2+TqUJ2c/+hdolSTgMKBg+DizyYmLTtw8oIbBKPkBO+a9kXmal6IyePnDMtuJXJR1YrcadEWk1P+eSPCjBHEgeZsoonGN1eNzctqU04qvaVA4ylb/cmT2jr8beJthdj3Eq3o1jFT3BDUGe8T221w9Z4T0DG3xpht7CaiES0s96vqe1853nhG53rXyG+sAcfRkHh0aGZgLxgiOD1fTCJKvEQueKBib3r9Xqd9i3r0Y/tcg7Ip8r4A9KiTG4TuWHOEjWcdtACqA1EgH2EOxX7yz4BzuWFXCQSUdud1llrgTPjT0C1RrlB/g6INGrepnp5r/h7H9heA7HVDcbs3MLCPEgK42FABUR+bRvIoOrUa2k/UbPOuFR3AdkM8BSTw0P9G67HsXyf4eDc4YTymSkOMePGpZEu4JW3b0om58Yxoy3OWIkJvvwJYDLXj7w0BtnpMV6mPo917VCFugX3fmMAlHZQSixNcUtS7EgZc4SEDgHlKCFkVCKabB29IXs=
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(376002)(346002)(136003)(451199021)(36840700001)(46966006)(41300700001)(1076003)(26005)(44832011)(478600001)(336012)(6666004)(40480700001)(86362001)(36860700001)(4326008)(2616005)(36756003)(82310400005)(70586007)(70206006)(2906002)(356005)(81166007)(316002)(47076005)(54906003)(42186006)(110136005)(5660300002)(186003)(83380400001)(6266002)(8936002)(8676002);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 15:44:23.1223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0322c343-f769-4f24-4055-08db4cb66ef4
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT027.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7951
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

* Add current year to copyright notice
* For reasons of orthogonality rename all occurrences of ESD_RTR to
  ESD_DLC_RTR

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index d33bac3a6c10..e24fa48b9b42 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -3,7 +3,7 @@
  * CAN driver for esd electronics gmbh CAN-USB/2 and CAN-USB/Micro
  *
  * Copyright (C) 2010-2012 esd electronic system design gmbh, Matthias Fuchs <socketcan@esd.eu>
- * Copyright (C) 2022 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
+ * Copyright (C) 2022-2023 esd electronics gmbh, Frank Jungclaus <frank.jungclaus@esd.eu>
  */
 #include <linux/ethtool.h>
 #include <linux/signal.h>
@@ -42,7 +42,7 @@ MODULE_LICENSE("GPL v2");
 #define CMD_IDADD		6 /* also used for IDADD_REPLY */
 
 /* esd CAN message flags - dlc field */
-#define ESD_RTR			0x10
+#define ESD_DLC_RTR		0x10
 
 /* esd CAN message flags - id field */
 #define ESD_EXTID		0x20000000
@@ -347,13 +347,13 @@ static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv,
 		}
 
 		cf->can_id = id & ESD_IDMASK;
-		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_RTR,
+		can_frame_set_cc_len(cf, msg->rx.dlc & ~ESD_DLC_RTR,
 				     priv->can.ctrlmode);
 
 		if (id & ESD_EXTID)
 			cf->can_id |= CAN_EFF_FLAG;
 
-		if (msg->rx.dlc & ESD_RTR) {
+		if (msg->rx.dlc & ESD_DLC_RTR) {
 			cf->can_id |= CAN_RTR_FLAG;
 		} else {
 			for (i = 0; i < cf->len; i++)
@@ -772,7 +772,7 @@ static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb,
 	msg->tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
 	if (cf->can_id & CAN_RTR_FLAG)
-		msg->tx.dlc |= ESD_RTR;
+		msg->tx.dlc |= ESD_DLC_RTR;
 
 	if (cf->can_id & CAN_EFF_FLAG)
 		msg->tx.id |= cpu_to_le32(ESD_EXTID);
-- 
2.25.1


