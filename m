Return-Path: <netdev+bounces-3443-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 780D4707201
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 345BB28166E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3D2B449C3;
	Wed, 17 May 2023 19:23:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED40449BE
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 19:23:15 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2112.outbound.protection.outlook.com [40.107.8.112])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA9170E;
	Wed, 17 May 2023 12:23:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCfc7hkdBtNRTqXfPSXvWVO2j82omUHa861o+NIR6z4NaJcwx0xMYQDOH+VqxTPBd4NAgG0uPgIrR9U7FXT51A908Gk6glhqrmtzBRJT5t4X80DKTFn8VS7hmySXz7KLJoABG+NJmhw9kcEYM1CobEVcHKvgbKTYXT64fExVjVhnxr6IYz3He6So0qtWdas/YXlTmjf5YEixhwbqaDz3B4a51NfoVO4cEWsXx9Jbm0+rLQibeqs1g+7Npm02KZuvPkR4u6wPa3wcydf9WAMFtqy/V5rhXg85KLcteM6BIhNHQrBkAJl8PNEcGpUlqCJ64fCH5C+I+H9UM+hZmGuN/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sKspe6hRay20hMky2zp3NpwEURiCoflHTDXOqADBNw=;
 b=llUWfSItqvhIM+bGveqU9anZ5VlrIHdF0X0ouvkJprOYdyUOxaJvKz1ioINXUMb1Q/m4Uxv3mLvpUAxv1H8YNyWqP5a0zBSCg1hTja+RY67PoYMtaWfCnQP4bBa/ZXRLPkxriWOjb0nLNbeKMD9f+ovhmYetN6ke61QDLMVqX/Uj0aqE3oBcx9bR2XDXwAokxvtbIFI3oPcJgegygoL+dizrVzTbduaJnwq4lWcLEgIGVHjauzpMhzQsAHirzZTjkcazoLmYX7uczrNALhSBpq+Afy6xiZ2+/q5gBr8W5Q1fl+lgNVMHku7U2+zqHlB1WFxjcqiZYYrxOWTiW4F2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 80.151.164.27) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu; dmarc=none
 action=none header.from=esd.eu; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sKspe6hRay20hMky2zp3NpwEURiCoflHTDXOqADBNw=;
 b=WD98Kg1rUrLp7reEPpz7CVXCdtjIbzQjGKypPWqCZwxpG7UQg0ROcdG16vqQl6HG3EqkN0jOLBRHCktEtmfrvEDF6J41+MBdzVVHGo9qzZeS8qLR9QRamrjLz/8zjbiry06fDnXZXIPyObywjGAxIg2LbH0HOiCNhpJUoP5tNPg=
Received: from DBBPR09CA0028.eurprd09.prod.outlook.com (2603:10a6:10:d4::16)
 by PAVPR03MB9847.eurprd03.prod.outlook.com (2603:10a6:102:31b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Wed, 17 May
 2023 19:22:57 +0000
Received: from DB8EUR06FT044.eop-eur06.prod.protection.outlook.com
 (2603:10a6:10:d4:cafe::9f) by DBBPR09CA0028.outlook.office365.com
 (2603:10a6:10:d4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33 via Frontend
 Transport; Wed, 17 May 2023 19:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 80.151.164.27) smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning esd.eu
 discourages use of 80.151.164.27 as permitted sender)
Received: from esd-s7.esd (80.151.164.27) by
 DB8EUR06FT044.mail.protection.outlook.com (10.233.253.24) with Microsoft SMTP
 Server id 15.20.6411.17 via Frontend Transport; Wed, 17 May 2023 19:22:56
 +0000
Received: from esd-s20.esd.local (jenkins.esd.local [10.0.0.190])
	by esd-s7.esd (Postfix) with ESMTPS id E59C87C16CE;
	Wed, 17 May 2023 21:22:55 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
	id E2B0E2E1801; Wed, 17 May 2023 21:22:55 +0200 (CEST)
From: Frank Jungclaus <frank.jungclaus@esd.eu>
To: linux-can@vger.kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc: =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 6/6] can: esd_usb: Don't bother the user with nonessential log message
Date: Wed, 17 May 2023 21:22:51 +0200
Message-Id: <20230517192251.2405290-7-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
References: <20230517192251.2405290-1-frank.jungclaus@esd.eu>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8EUR06FT044:EE_|PAVPR03MB9847:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: f6bff02e-5d47-487a-ae22-08db570c1ec5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+oNUHNtQ08g6Lzd1/mF2yCy+cQXW/8XM1RLYOY4ZD7IcSokNz/gRBDAwvw5UCj+F0/jVVI60MTnwCVwXStz6QXX35b8t8YmpSopvBavEkx3hDQsG6oWvYQLdjPadyoYzBpybgKNrbbk2d/AS5e4ED1F7Yfs4jwPB6N5g1EMs8IwoKsCLbkPuRVSYw7YR3VuCSfEDy+RnhaRq4NZiJUxLxl9oy9cN84asxtka0AxFtc80lc6lVIxtvDgXXxnSECMMe4VXYTnydL+7ZvN6ta5SXXZoS257QFdQU5VEvHCN9RyvDbROKXZL7Y8oXv4QJ0yjxk/zkhN+4Db8shRlFa2kr3QmkyEnND5VQ2WO+GUbUhxhhJyn1r1ygCec6hWqiSLhktPncKCCLMWPTgmyUos1w3JeYiGBGiKiBzzTQWJWxBtfSrF/r1v/+GqOGY51kv8sFlbHfoI6uaUPod+UFrdDevHlevnCmtyPcZaPfmifsGiD6fG3IfxCIN/qrfWGGfuWQOP0Xj/diJmZGA12J7YfEGyULdmkCeZ6lrDGkjzbMPvZfeOHrHPgfR163MnQBX0No3dQa1yylcAh6Pr/hLkSl8D9uxRbqWLPcVXykBrhmsRNXnrBAsZbjYSCNKnXGxzcQggaI4iq0NLsv462Q+cLbB2X67QUU12xH3GvMXkAJbS87dM8/noKiVkrLONqHuF8/cxzN34q2ILHVWtsyFUGxg==
X-Forefront-Antispam-Report:
	CIP:80.151.164.27;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:p5097a41b.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(346002)(376002)(396003)(451199021)(46966006)(36840700001)(36756003)(42186006)(86362001)(70586007)(54906003)(110136005)(316002)(478600001)(70206006)(966005)(4326008)(82310400005)(81166007)(40480700001)(15650500001)(8676002)(8936002)(2906002)(44832011)(2616005)(6666004)(356005)(41300700001)(5660300002)(36860700001)(336012)(186003)(1076003)(26005)(47076005)(6266002)(83380400001);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 19:22:56.9459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6bff02e-5d47-487a-ae22-08db570c1ec5
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[80.151.164.27];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource:
	DB8EUR06FT044.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR03MB9847
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Initiated by a comment from Vincent Mailhol and suggested by Marc
Kleine-Budde replace a netdev_info(), emitting an informational
message about the BTR value to be send to the controller, with a debug
message by means of netdev_dbg().

Link: https://lore.kernel.org/all/20230509-superglue-hazy-38108aa66bfa-mkl@pengutronix.de/
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
---
 drivers/net/can/usb/esd_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 9053a338eb88..38212330cf50 100644
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


