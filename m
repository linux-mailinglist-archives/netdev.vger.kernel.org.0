Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB70A56BEBC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbiGHSOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238970AbiGHSOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:14:00 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80111.outbound.protection.outlook.com [40.107.8.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0035F9E;
        Fri,  8 Jul 2022 11:13:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFwWeQSkUMVQWtdrnT28X5OvCpKV4UhOUnnkipBUv1r7PTkZqD8gxU1p5Z07fJrNw9DDbMma2gl/CrR+BO6eEJQooMb2RFgRgneprFAJz26rTDvKQ9kLuVDf4zouM3UzjJwOm3cjxbUtPuDryyZhO9YTlFuOJFAEPLgcUS6jMWZGmdD4QgGy+ttafIoyoI94Rg2kRz/n6nQzFwUIwLJfEXBIA/vM1xUe8ZUYwJObXxwJETaF5AkSmOiPzahut8DetoGaAqQbjkhKpFNQ8CAen0H7WS9uGRsHz9rmAvuPI5vL9/D4cLidBTSHWqEbww4x7oy8fHLyBx98JeHB6suSEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9NqPmP7WGzHIQn4XyWfha2Si/1vITyeN4aZWuQ9hNM=;
 b=RYCEVqJU/ZWcXazVbXkplwquvgbGczQ79a70b4WBADrSd5HeB7PQ4AFzCOj8GAKClvD2o5tmqusG0EK5hj83OBK9Tk7LIM9wJoV67yG51mjuLPaJ/LXgonRny7OQXV8TZT61ckdVUiN88iT+z2pHsEkohjCfyIOdqrt4D1w3hHx86XTXjTbvHHv1HjFjLFuQFrA8KscmLnK0P/AxAwwQTnPdis/N5x+RKqJ6CdHtfNMf3/Bhrp8T58psgTEO2PK09UiNLVSk6iEgYQrymQWbTMPzTBKjwjm9LAqRPGZOugnz6C/CO/Tw+pl1PUuDzm7Alt/COgyWSn8V8A8oIP78aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9NqPmP7WGzHIQn4XyWfha2Si/1vITyeN4aZWuQ9hNM=;
 b=grAN8tfHDhRZ1z82fqN6vpeDGwP0aZ58klIzvofX+optqJViCaeUbIU9g2v9HYXjVloG0U/75mradbs9MuPpTl7IfPltfUVcofPMxZmQHsI8hieGo0aSj78W9I/fMq6sIYeANPvnwCYMc0giYBLMhD5iUzSY+pPN2/HdYT4hM58=
Received: from FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::11)
 by AM4PR0302MB2722.eurprd03.prod.outlook.com (2603:10a6:200:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.21; Fri, 8 Jul
 2022 18:13:55 +0000
Received: from VI1EUR06FT058.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:1c:cafe::e7) by FR3P281CA0021.outlook.office365.com
 (2603:10a6:d10:1c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.6 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT058.mail.protection.outlook.com (10.13.6.196) with Microsoft SMTP
 Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:55
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id BE11D7C16C5;
        Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 6DA1F2E01E2; Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/6] can: esd_usb: Allow REC and TEC to return to zero
Date:   Fri,  8 Jul 2022 20:12:32 +0200
Message-Id: <20220708181235.4104943-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6320a449-7063-413b-02bd-08da610d9eb5
X-MS-TrafficTypeDiagnostic: AM4PR0302MB2722:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wz96wnd7GwaL6dL/Jugh5lwA+CTsA4Q8WurmHhID1kwjVBAkoenmQRoq2mNjmFxEWFBFcWGSwyG4uxyco22yCkfsOP8EPB+YPKA4yChBDC6qsiiYqXkj0yntMHI/+hdbHzcItDUO0qmiKnSHiq3fFp//tsp3Bv7PTmkkczeSPmZjw3aojyhyMzjPw92qbdlDNgb0KrN70AaWLiLsxyt2Hp/MgkEcBkUzNT2W925EPr2QYNlX1na4KFjEhxNP6uWRowuyUYUDZCROI1SEJxBx3xjBoGHQeSmJF7eNo7lPbLLL2A99rObOZO535+dIiwFkOHFypGgrMDhZJ3s6PeOqjJqvL41+wn/YdeRwuUOHBxyh0VunlXzze1kDCewOnYNMStgmQSiup0GwkUXC33RJOOiU1t10F4MLpzT4401F9vpUkAgXMBAYr2E3rheGYE1O78Owk4sfUkegC3AIY4dZ7sJRagRHO4okHptHj7T7rzP3TgY3MpJGF/WQH25oVygwWLFLuiToOWeQmyz6rWWHqSX5mBZlEyNQ45CXf4khf5AgiYhRlsY9SQa+J58jnk88jHZTeSVkTUamwejxjN6QKxSu2NK6XPUFhVi5jRU2fPCyyk8x/gBDqyrw9wGvVPItH82UxIz6zsFJ4zeQoFFNiwkDI6U7sueXmc4v5mARJ0PiYbhESEri5g+VZXjgzLPtAYBe5Q7wqZ4pnf0FvzuCpKVVOGHQIaDHk+UTjvXQR+bwYrNtyjUc371a6uthjNy+6533KplIzxl3niP1+Cylijf4Dyvl3t3FGzfgZsevH8I=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(376002)(39830400003)(396003)(346002)(136003)(36840700001)(46966006)(36860700001)(86362001)(5660300002)(186003)(47076005)(336012)(83380400001)(2616005)(26005)(6266002)(36756003)(356005)(1076003)(81166007)(54906003)(41300700001)(70586007)(478600001)(110136005)(6666004)(316002)(42186006)(70206006)(4326008)(8676002)(2906002)(44832011)(40480700001)(8936002)(82310400005);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:55.0541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6320a449-7063-413b-02bd-08da610d9eb5
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT058.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0302MB2722
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't get any further EVENT from an esd CAN USB device for changes
on REC or TEC while those counters converge to 0 (with ecc == 0).
So when handling the "Back to ACTIVE"-event force txerr =
rxerr = 0, otherwise the berr-counters might stay on values like 95
forever ...

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 8a4bf2961f3d..0b907bc54b70 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -229,10 +229,14 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
-		u8 ecc = msg->msg.rx.data[1];
+		u8 ecc   = msg->msg.rx.data[1];
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -259,6 +263,15 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				/* We don't get any further EVENT for changes on
+				 * REC or TEC while converging to 0, once we are
+				 * back on ACTIVE.
+				 * So force txerr = rxerr = 0, otherwise the
+				 * berr-counters might stay on values like
+				 * 95 forever ...
+				 */
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {
@@ -292,6 +305,7 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 					CAN_ERR_CRTL_TX_PASSIVE :
 					CAN_ERR_CRTL_RX_PASSIVE;
 			}
+
 			cf->data[6] = txerr;
 			cf->data[7] = rxerr;
 		}
-- 
2.25.1

