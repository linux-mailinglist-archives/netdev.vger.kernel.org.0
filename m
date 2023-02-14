Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B0D696925
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 17:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbjBNQTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 11:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbjBNQS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 11:18:58 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2127.outbound.protection.outlook.com [40.107.104.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CE61F5EE;
        Tue, 14 Feb 2023 08:18:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePPgbbiKCSfhpt7N2GXknBAhVzEwBe0XvK2YIZRJndS/S3DxIqpT+gd2CLv+B9dSYo3j/wXnsKJhn/JcRw3PGe+Dr1jTcviPqakAYY0lIiHS9Pj0PXyCWcnVNjnlLI/OQWIxhSvs5S49aDone80+y4vhXkGyV7FP1KNTwWpkKlwG/6JTXXMW6caitb75S+T/nTQeFQBqJnsJnBuzHjsoYgE8Ug46i/+3qkehImM+BRymT3V5hF4TTQAshg3HqJ8eypc+SzxcxRG0qWjWnAjpa0h9JgBl7IOoJg/PKPeMxeba6Wfjj5qrXJnfS1PDfoNdWIlyxbw87XfnySYlzjJCSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JYZGgm1XYD1xLyWkBS3yOFOgCougyjas/xb0RdkIG4=;
 b=asTEoVqQiEayeKhSbMjnOA9GD00aDbhn+9g2OePa7NA8IVJzNLJm2vMyyBJAZB5pXAxef/dKSW+yFpcpLXJ94Kz4SRB52YpKcn6mBInaPgxy97bPADAjcLjDq/L7ZTl43c7fQhLoOZmtTOgnqXQOrK5imPPmZ7eHnUyAhP7bxuJ7FQ5tkLJf8KGZLQNiZKDaO21pOZrLWQu6ZtfnFI9DG0QKU3A1G6gmePYs7cpd3lT6UT8wo5Qq1glgiNw8zN9REdidGRJngey8kaZtQpdTI8OIFjCCN7LVm6BubGXoSAhWbTj/rlGdmP8KVkGeo71kvEGlD4vdTNfR5MpuZMfY3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JYZGgm1XYD1xLyWkBS3yOFOgCougyjas/xb0RdkIG4=;
 b=saWMhAuXKRnCUKRDbxqie1THvDAQ3BuZZM2JjMQhl41lqnMiEP4QoRPxT7CgtyHutTK01FC3/N38c+ASHgsVKC+v67zadJrJuunyEn+2bGkWy3m3bY95T3we/gghzHVVt4k6qwyxajnrmf+lYE1akiLIs7oBqS9fO42XF7OhXKg=
Received: from AM6PR0202CA0072.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::49) by DU0PR03MB8291.eurprd03.prod.outlook.com
 (2603:10a6:10:31f::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Tue, 14 Feb
 2023 16:18:37 +0000
Received: from VI1EUR06FT035.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:3a:cafe::de) by AM6PR0202CA0072.outlook.office365.com
 (2603:10a6:20b:3a::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 16:18:37 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT035.mail.protection.outlook.com (10.13.7.54) with Microsoft SMTP
 Server id 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 16:18:36
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 919187C1635;
        Tue, 14 Feb 2023 17:18:36 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 856C72E0125; Tue, 14 Feb 2023 17:18:36 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 3/3] can: esd_usb: Improved decoding for ESD_EV_CAN_ERROR_EXT messages
Date:   Tue, 14 Feb 2023 17:18:35 +0100
Message-Id: <20230214161835.1245274-1-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
References: <20230214160223.1199464-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT035:EE_|DU0PR03MB8291:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 0abe7c21-0f2e-4fd0-3feb-08db0ea7206f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqrFiRxULjtF/N0oh2zDZz6Lo4IunAxCkhh/ASAY1NsQze6aWj/pp1BGiYUDjlskvGO71D8fOUqw7YTz10lchJyr6UbjOSEL8G4AAiRQN24iul6MwvzSSqf9McDmDc8lMK1CA//YkJD9IAPE2lV/qj4thVtPnGf11s5BsW+YTiCF41uUdUstnv/tohjGLoJUImiZD+XYR1Cwqhc4wl1wXvHaNZ0CEL/8hLMIB471XfltDuyc38AZykt4UQ5NWdzb8C/rGx3AqJl39M2lHtsTkJV4LeAmbE9GirgEg6T0Rz6oYt+vhGxPp45to2DB/f2MLYhdWdP+FEzrc+zpnRVlgPIQuMTWAoMZCVqheOOJEhxJob5DJF+h7qCCl5AbSQKMSVPkp16mArA8yMpnuGzrKWmW7Fw/ao4vV+A6I+FTRCPOFSXlpNXY8NCT7afSo8U0Jaj+52xZgYrHnnNx0nU547TGmtJxhEC3zSR0c0AeVslhR26bUfxL9WuY1jGkola10tX/QCfNc6FavD85PsEbsJXniFqHdE4Wl66mGlNt0gOs0eHiWe6NtD3MMnZNDR9x3pmYhS5D2bgVvJKNVpLGN475Y2dhcoi15uM62U+25YVVz94I5eyNVBO/U9dqBkd68oH8chmGuBOTwkGWUL4g1nTO73FmGRlDTV1o2ZZA8xc=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(396003)(346002)(136003)(451199018)(36840700001)(46966006)(356005)(2616005)(110136005)(54906003)(316002)(40480700001)(2906002)(47076005)(478600001)(966005)(336012)(42186006)(15650500001)(83380400001)(26005)(6266002)(44832011)(8936002)(86362001)(41300700001)(186003)(5660300002)(70206006)(70586007)(36756003)(82310400005)(81166007)(8676002)(1076003)(36860700001)(4326008);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 16:18:36.8608
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abe7c21-0f2e-4fd0-3feb-08db0ea7206f
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT035.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8291
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
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

