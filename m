Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4A96514B7
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 22:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiLSVU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 16:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiLSVUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 16:20:55 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2118.outbound.protection.outlook.com [40.107.22.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20D764D1;
        Mon, 19 Dec 2022 13:20:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lnas/Ei5LpXYNSAGuaR60BOH0sdBPciffqdJcSi1REfxWVp7eRhSqhbBSKsBxPYkIMWAxszZJ4lCC+fvUR05HxqCnEiHwrAhiXrJujKvqINhmITCMxwPisHkIi6GORMEQKt4GsQ3z5eFMDJa8/EW2G+rwjfaXS72cAgM/Iq06LejoWm4ACBNV72dK4RnsrfpnzbldnLsQnqPuHLdlk0h1BnIX7E/Wi0FDjLiT4vezAOAuAmYmcgVQljCriij80PxwS7DuiQDpXMIO20SGzovURZARXGIreQNlD4YDCm1VtDgTkY/RTI4guXhuOfpfxIMnCs0I3i1OY3IisZnftMtZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySpz1nlgcq/mVnqqCPG7zzsJF94xzgLeBnibFVWUUbs=;
 b=X9W5k/52LPPUx48eAnTXCbjnXBTHUQGvHNmGSyIGyYlE9aZG1tPr8iryMv3FLRYg//1CrKlZLeALo02QBVG801xaOoLlTNnW+xLViKj2nndL3RYAUQcRX2AtaQNZqPRtvD7bTP3r6P7uWS6PMA201uTf2pe6Lkf2UhHJUgnoOyyE+bgUxLg4738ltdW0rgnJ3UiAz8pcuvpH/3hCtxC7VzFohFr84aL6ciz6DRkkHztWxbzRO0I12aP2buXAUj1IcugAfQpAxmge1FYc9y2OCo1AKHWVsDILDacEKnz65I5jj7FMO9iVxKPGuiv70tikURoh1daGmA4ep33xSEqpSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySpz1nlgcq/mVnqqCPG7zzsJF94xzgLeBnibFVWUUbs=;
 b=ferSbRDnt7pMME2ZMLo995J3V3C+cuFqXe2mhv+A3kPBzV3bTOzEUiJYOeaWPrQT3w6dD2oBNzy50FVLcjEFn6VkyYQbtmAIJEp3xVZqe6EyHI3DBjsZuMnBUfoIOJuu8swj3ccqfKpX0YnE6ZVekMIdd7+uqo7if3qn/bXudsE=
Received: from ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::22)
 by AM7PR03MB6232.eurprd03.prod.outlook.com (2603:10a6:20b:13b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 21:20:50 +0000
Received: from VI1EUR06FT067.eop-eur06.prod.protection.outlook.com
 (2603:10a6:910:1d:cafe::99) by ZR0P278CA0053.outlook.office365.com
 (2603:10a6:910:1d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.20 via Frontend
 Transport; Mon, 19 Dec 2022 21:20:50 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT067.mail.protection.outlook.com (10.13.6.78) with Microsoft SMTP
 Server id 15.20.5924.16 via Frontend Transport; Mon, 19 Dec 2022 21:20:49
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id 4AD3C7C16C8;
        Mon, 19 Dec 2022 22:20:49 +0100 (CET)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id 3F9E72E1DC1; Mon, 19 Dec 2022 22:20:49 +0100 (CET)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/3] can: esd_usb: Improved behavior on esd CAN_ERROR_EXT event (1)
Date:   Mon, 19 Dec 2022 22:20:12 +0100
Message-Id: <20221219212013.1294820-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221219212013.1294820-1-frank.jungclaus@esd.eu>
References: <20221219212013.1294820-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR06FT067:EE_|AM7PR03MB6232:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: cd797964-2040-4923-17d0-08dae206e6f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /x5HfrvrFergW/ATbm2GhQfYnetiOiJTOpURBDZQBh9Jml4ApOLUy2Jw7KW1tOIfO9RHuRdSE3h0oit+bRZ159PXmaXTYxL35aASUDwaCh87ravkDsT7Jmn3oBO0FC1INT+KWeNy+2UvTD3NQGqv5FMpZLv8mqtyEcG7q3EcX23lXbYWS1hV41wTfmnCLDvYHjKXizThFQfojPhFuSMnmclKMsFFU2nft+N5APXVQ4E3xK1kx6s5FRpvzMl/mDE3d+WhxwsUrtZ94UQlIcZ/TYdi5O5hN0UyjkINr54pDJHL9z722ket2+CtXmmA0GUTkjy9rW7dnviGj8SM0hqLwj7rO4MPuvNep4LqXV9gCuhzSKaOBY1hziPYA294Nxda0cTYaXTthfISNswNi3wqhtVR88/ZUGB/rL8kED1QdikCQesMAy3et2i4ZEFaSKFypF2ps76T6WjIRiGvE6CqeW7wD7uB5LoUQxzw/eYyHZuirQ1hscMUXJkFqpiE8+B0tYIwqJBzFCidoGlp7hR72ZF5DvesDohgkwoaYx+Yzxmr02BGTSU4LKYskOWjDVo0gMtw++RYAPy2Z2AxCDng3IiKdJ9YyA6wgYQsIpH0GdTxLaoSz6Uyux3DwOGoMwQwW5/MQORFsKLcZJgewbNuM8Sy6xgWnaSYIgr8UiM8TP0=
X-Forefront-Antispam-Report: CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39830400003)(376002)(451199015)(36840700001)(46966006)(8936002)(8676002)(70586007)(70206006)(5660300002)(4326008)(44832011)(36860700001)(41300700001)(42186006)(316002)(40480700001)(2906002)(54906003)(110136005)(86362001)(2616005)(1076003)(356005)(83380400001)(26005)(186003)(6266002)(82310400005)(336012)(47076005)(81166007)(478600001)(36756003)(6666004);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 21:20:49.7846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd797964-2040-4923-17d0-08dae206e6f4
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT067.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6232
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moved the supply for cf->data[3] (bit stream position of CAN error)
outside of the "switch (ecc & SJA1000_ECC_MASK){}"-statement, because
this position is independent of the error type.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 42323f5e6f3a..5e182fadd875 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -286,7 +286,6 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -294,6 +293,9 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
-- 
2.25.1

