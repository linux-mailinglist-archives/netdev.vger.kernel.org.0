Return-Path: <netdev+bounces-4000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BA8770A031
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:57:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 837CD1C21154
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C204E17AD8;
	Fri, 19 May 2023 19:56:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA6917AD2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 19:56:12 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2138.outbound.protection.outlook.com [40.107.13.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D8CE46;
	Fri, 19 May 2023 12:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+r6YVTWc5cDvrzoD2wSWAxf51iFBc1gBLmO1RG9DnCztypLhUXyOPP8Wl7TFvv1iS3rhBioS4bgIDowLKsEINwdsStFCma6rIcivfkqBVfbNbirRusUaLAYk1UY2377DucseZ5SwMX1nYMcrxT9y/XaRx3DWInaQ2H3bou/a5rehBNLZb8qDK4vYTpys3vc5d1Lk8wnqzRNztlH+aniI0zlxV2/SwBfkW4nabFSTIh6OqWaFhy4TPChbjlWc2WfaJPZnDhV1tuwS504qn2CmfJFcGQy3CowYWss54DsqT6T/DWNd6mPbnohKwly8k3axocJn/RgPUjHdkjtEffGhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QWpBiDRmFm4yjR+LObQ0bmAXofs8H1x/5P3UBkH2oQ=;
 b=gtpRwKShScmkK2u78Hpx9+JjXdtWaWymT8zruRZAmYqtAvEfmIJnARlSqOKw7U0baDWwWzPQX79Ka0K1hRV4+lhdNpoWDZ6eUC0unH1tNbkf00uGU//DToD/T7yJAr2z4jRAwK/JH69/RtrALuCbWm2opJbKMvvtkgB43MkcxCYZks8v1eDbVQaAy/3QP1GJsrxdn3IPuvi8N+bzbTn1cUSkz7qoqaKWQzty1Q2EXii5rzTzqxy1KnTeCEfzbWb01zcRGCYlSV1HPk5p/SbjmpdN9mEZbfWpar/sd0RP20v2nZ9LDCs1IbxQqpZgKlgDW3wDngyPSQsKn8GX7vyIuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QWpBiDRmFm4yjR+LObQ0bmAXofs8H1x/5P3UBkH2oQ=;
 b=aKVE3X99P3DW7+TvDSRtlTKm679dcSuelu6rH2cWqshJETLHfUJUlQuiszRfl7JZ4HGULzriOiazsBd1aJFlR4Sc5KtCnj58Jr+tt9npiktErtn5t+ATPAvenQx9sZp6QUagDKjGVwAFs6yHCCL4UL3tYdkQI/YrgFZIOxV8fpM=
Received: from FR0P281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::7) by
 DU0PR03MB9518.eurprd03.prod.outlook.com (2603:10a6:10:41d::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.17; Fri, 19 May 2023 19:56:05 +0000
Received: from VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
 (2603:10a6:d10:15:cafe::2f) by FR0P281CA0002.outlook.office365.com
 (2603:10a6:d10:15::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.6 via Frontend
 Transport; Fri, 19 May 2023 19:56:05 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 VI1EUR06FT054.mail.protection.outlook.com (10.13.6.124) with Microsoft SMTP
 Server id 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 19:56:05
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E70DE7C16CE;
	Fri, 19 May 2023 21:56:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id E32DD2E1808; Fri, 19 May 2023 21:56:03 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH v2 6/6] can: esd_usb: Don't bother the user with nonessential log message
Date: Fri, 19 May 2023 21:56:00 +0200
Message-Id: <20230519195600.420644-7-frank.jungclaus@esd.eu>
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
X-MS-TrafficTypeDiagnostic: VI1EUR06FT054:EE_|DU0PR03MB9518:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 5bb73f85-4aea-4492-a684-08db58a314ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uC9cQuz7k9cLJtN4QD3Rc+Rwjkkq7R9fvWjAeZoc4FBcxpftiRUZsv4w5WnDzsUvMfcBsE5HItb5aqJiaOhasaa4H9VZK1xxC+Cx0OVC+9uBvNBi3k9YSOK7ymP4sguPrvL/JDm6NUczm++7uQSkUPZG6fzth2TmrllSdltTY48fBVmJY1ObSK8Rv07NY+OIsRotJ5KGqjeuXY9QOcoFa91H06CpS8jO+Qe2YSOqXJ6Mp/DUSjJIhfVxnBtai3lEeVcGkYOltjJUrA9NNeymRsI2U2cZRpR7Vc24SxBfu0fO8EZS83HUqgNJr2so2fGtfNha8qGCrpKDQQu97XQdXuK/pVdJ+bbKYXJ9ofTv+5mDupamOd+v9OYRaEMFs7cV+8mA8vnkUcUOqCdOBhjMVkcMomW+V40Ry+C2gYXYPJD0GPZ3OWR+uUadrrC6p9omKD4RC57QO9vQOyFMWTe1iRTiGZ9gku0Dfetzc/PyYMMeeu/T7aBhx6si7TFygkSXuqTih/eBwLotE2/fix9OvlA1lgIvIsS1A2nMe48C+Ldb6yjXIrY9NCF5rynb5zTC45RcCw7JiDGLcdXpESdGj1Oa9p45Im2zaacyW7G494KWypJhKDRliJ/qHZy7riI96YU2FoyjxyTjgt2nwtQFdaYCjy5Dq0nQuWBgD8PQ04S1JqVf0+WpjYqXF6nJGsES9by/xs3U58ZwEtLBEUrGNQ==
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39840400004)(346002)(396003)(451199021)(46966006)(36840700001)(36756003)(478600001)(86362001)(316002)(54906003)(110136005)(966005)(70586007)(4326008)(70206006)(42186006)(4744005)(356005)(82310400005)(8936002)(5660300002)(336012)(15650500001)(40480700001)(8676002)(2906002)(41300700001)(44832011)(81166007)(36860700001)(2616005)(26005)(6266002)(47076005)(1076003)(83380400001)(186003);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 19:56:05.4120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb73f85-4aea-4492-a684-08db58a314ce
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR06FT054.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9518
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Replace a netdev_info(), emitting an informational message about the
BTR value to be send to the controller, with a debug message by means
of netdev_dbg().

Link: https://lore.kernel.org/all/20230509-superglue-hazy-38108aa66bfa-mkl@pengutronix.de/
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index a6a3ecb6eac6..4c0da3ff3a9d 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -955,7 +955,7 @@ static int esd_usb_2_set_bittiming(struct net_device *netdev)
 	msg->setbaud.rsvd = 0;
 	msg->setbaud.baud = cpu_to_le32(canbtr);
 
-	netdev_info(netdev, "setting BTR=%#x\n", canbtr);
+	netdev_dbg(netdev, "setting BTR=%#x\n", canbtr);
 
 	err = esd_usb_send_msg(priv->usb, msg);
 
-- 
2.25.1


