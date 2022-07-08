Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D7156BF43
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbiGHSOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbiGHSN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:13:58 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70095.outbound.protection.outlook.com [40.107.7.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB312F387;
        Fri,  8 Jul 2022 11:13:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5dXarpGEJQtlFYuQ4UmZ0xLoz37tNLHJHnq76jg0sPzAkdLC+95emCxriEk0OJrC2oC7yK69JOOUH6Mp0QNnupHvRhJWkCtrxNmA4Hwlw5xFURTWvf9p9H9xGmr4wnfdTtbCY4JFA3SnBjtLgZFjY6xa/sjy66M87Mdzu2SBVC7EF6GvVgPx6aQgLtNz9qfArNB9B4riJI0HZisg+UkOLnMPUGWwf9hAyX5S9LQeENuf5qjcU4ICAxaoVN5PbZchb+nmYAkFAmdKK2tmCTFhRUC4iCzj7lrg/+HQoOGVRk3YP4PqeygbPqlcawjKFD6cw/jTZKmhZBgBKfvwMGsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0uDN6neqQhx3Jl7waytD+xB7bKspOHXX6fz/0UdFZ4=;
 b=AdBVCRi2BdyNmDm/mCnzfUIUysD8S1/DKp1L/+1RSzW7Lt5ZrOxMytACTyy/oq9rIOC3jx4ALd046Nj/uvUR7h+mFvXu4XuvT8w101j+aunrwlxBL6+5edzMaAnpn6zdMV9iaJEPhncxVzy/SRCZHDV95CBsA7wEdPaOTCVdhcKRLt0obwMDgz8DkLyMizURepq9DsVxakTOzkWJGYuIRtu6UbbWK131/fuwboQs1eWj86jK4s3yqLxPDLCWDt6mRQE8Gj2QjmO2KlEoA3fxA7O3Gr9wrAeBNVgjSlSFrErqAWbE0XTParWke5Bzy8zueYfdAlAAhsuWX5VOc5XJLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0uDN6neqQhx3Jl7waytD+xB7bKspOHXX6fz/0UdFZ4=;
 b=Cp6JwKp58h1JDs4A/SemlOYZEhpunmkCdnzTIPaPtA5FhvfWhujGpEakeaVdONwy4R0mHpgk++fJmq5FbRJucwZr5pNL7WId8Vjhpf54pFL3DPeNuvRuKjhO5Jy6tV4gHbYOg96pmEq8l6hhmqmmrtPCF2yO6Ir1FmER7FZQtMk=
Received: from AM6PR10CA0093.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::34)
 by AM0PR03MB4306.eurprd03.prod.outlook.com (2603:10a6:208:c3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 18:13:55 +0000
Received: from VI1EUR06FT062.eop-eur06.prod.protection.outlook.com
 (2603:10a6:209:8c:cafe::8a) by AM6PR10CA0093.outlook.office365.com
 (2603:10a6:209:8c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.17 via Frontend
 Transport; Fri, 8 Jul 2022 18:13:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT062.mail.protection.outlook.com (10.13.6.85) with Microsoft SMTP
 Server id 15.20.5417.15 via Frontend Transport; Fri, 8 Jul 2022 18:13:55
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id C9B807C16CA;
        Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 74C8D2E01E5; Fri,  8 Jul 2022 20:13:54 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 4/6] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (3)
Date:   Fri,  8 Jul 2022 20:12:35 +0200
Message-Id: <20220708181235.4104943-5-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
References: <20220708181235.4104943-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 9ff8c9d4-ad0a-4e8d-4a7a-08da610d9eb1
X-MS-TrafficTypeDiagnostic: AM0PR03MB4306:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L6VPCi5dvgMtVelmpodRxbsfSDb8g9YYXDibMfjPCAPBiKKDsXj/e178Cv097IKpjmtEggLMtjqDOTMPv47+89fv87a3+6wjEVHQDsugumtDEbQ4eGzAUtAIotF0hkPPWgeAxvuYpqB5CLGOtIIafLm5ty/zg/sB+mkQ7Ao7qLE07LFE8IW9X6i9b+0WdFd02OCsywlCfHP+Qvc3xxIZBNr/yadc5wp8wunh886NAT0tO27kVQT6xeeR7zcvLgX9IcBqnv7chlcgHJgt25Nia/jyBbJLGuqsIAiLFl2ExBWnLZ56RBAiHvGRSnpGwEo8d/KUFEaRKFbgdRS+34qxJDKN8Nh/7Dv/uw600gnXkdCC1KdUHee5gIMFonczQgTir92bZ/BfA+mhlVbNQLJVUdIWaO3y9UmpzI2wyagVZlV8RcJWIOYyWUkFIGu14SAz4YKUm9hKQuFkK0pbVCA5aCseDCA13KvJQDjrjc9FqAbfMXSfCTjJuWDpOj3YsstJTn4egUteBOofErZNf6BRcWeGisHq8Wz5ulwTE7/CjLlIITHR67h3GrhMdrSs1gKZ7Qn9FrxdKFw9+l1o+F1zCbqEeRqvOvDLo30N+v7VVFBeUA7W/8N5VpLR4ka0WGt4NGvOqqCtl0qukJJMvNei80NCpWQ/iH72N7SBOYzbrEpYAkQSkjfFoaIg3UXm3kwXuX1taT9dFFjag60EZWIFZDrG6BNfJVVyfoIvYRxzLjT16na3WRDKDRORVdblJmSPCUDl/QDgFhzilOMFwf/DxIqLJioEzUyj9OvFk0hPle0=
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39830400003)(136003)(346002)(36840700001)(46966006)(82310400005)(2616005)(70206006)(42186006)(2906002)(81166007)(186003)(6666004)(336012)(26005)(70586007)(1076003)(356005)(86362001)(36756003)(6266002)(4326008)(8676002)(478600001)(40480700001)(47076005)(5660300002)(316002)(83380400001)(41300700001)(8936002)(44832011)(110136005)(54906003)(36860700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 18:13:55.0297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff8c9d4-ad0a-4e8d-4a7a-08da610d9eb1
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT062.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4306
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Started a rework initiated by Vincents remark about "You should not
report the greatest of txerr and rxerr but the one which actually
increased." Now setting CAN_ERR_CRTL_[RT]X_WARNING and
CAN_ERR_CRTL_[RT]X_PASSIVE depending on REC and TEC

Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 0a402a23d7ac..588caba1453b 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -304,11 +304,17 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			/* Store error in CAN protocol (location) in data[3] */
 			cf->data[3] = ecc & SJA1000_ECC_SEG;
 
-			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
-				cf->data[1] = (txerr > rxerr) ?
-					CAN_ERR_CRTL_TX_PASSIVE :
-					CAN_ERR_CRTL_RX_PASSIVE;
+			/* Store error status of CAN-controller in data[1] */
+			if (priv->can.state == CAN_STATE_ERROR_WARNING) {
+				if (txerr >= 96)
+					cf->data[1] |= CAN_ERR_CRTL_TX_WARNING;
+				if (rxerr >= 96)
+					cf->data[1] |= CAN_ERR_CRTL_RX_WARNING;
+			} else if (priv->can.state == CAN_STATE_ERROR_PASSIVE) {
+				if (txerr >= 128)
+					cf->data[1] |= CAN_ERR_CRTL_TX_PASSIVE;
+				if (rxerr >= 128)
+					cf->data[1] |= CAN_ERR_CRTL_RX_PASSIVE;
 			}
 
 			cf->data[6] = txerr;
-- 
2.25.1

