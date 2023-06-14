Return-Path: <netdev+bounces-10684-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9662172FC36
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F4051C20C92
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 671837476;
	Wed, 14 Jun 2023 11:17:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561CB746A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:17:45 +0000 (UTC)
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2113.outbound.protection.outlook.com [40.107.135.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F70912E;
	Wed, 14 Jun 2023 04:17:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKsIIVIn6rxp/C6KHxMLLwAmMga2Y9lEvVEL/T3kKu3rjivsHoqWYY71ro2+ZeiMtostCpFqBp0Q5nvbZzsJ5XQSp8jpo4z2l7fMBjUvchSv0oNCpHbLWT3jem/vHga78F4fpqrWiefA9+jwV0Gh3Hvtynm7/CWu52I+iwkgXDmrtLU9UeTfL/VfEO2B8Up3334z8jpljKUr2USQJ8ioeTEUzZHuDef2CU9J1rmZOlluPNplFfeGkdXhaxCAPRwUEayi6mkF2FeARnh6VkQqLAx6beQpSsbWZ+sMh2L54AkTy/FysLW6OOhtdpjRUMUuduLwMLZHitmmfy8AQxKOsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BuFKAavu9Gaw8er8QX5n1p7ngeksXlmKevTZcTNhwCA=;
 b=IVBn3QJkVT0jname0oaFyT7fJJ1zBPMiO1j0ZFnlc44AFwtXbUWkMuZzDccRIBUA8hR4+QFIov2KHPGGhA6GWm0noCQwlnZyptzDUrd6TM716s75YqhRcwl9JwGueLq2Lc3awvsGwOu6PrmZqsYbLodmv+hQna/iJ+CxhDLoRUWaG98cLnXR2bkkdWxXwN1C3ScZ7ZZQ1oQ0GSmsxv36hUtKdjBRa7L6h1hUupJo+nLLX1A6UnCSSBdfKthLoeBx457Yj1Z3a3qvh+ko2ezFtRyvsgaV9lIym7C4HKVDM88GE0gpWf5EQ9Yn3k/g+zh0Yx0Ha0eyvWDyim2IjsfkJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 20.54.238.131) smtp.rcpttodomain=davemloft.net smtp.mailfrom=chargebyte.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=chargebyte.com;
 dkim=none (message not signed); arc=none
Received: from FR0P281CA0100.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a9::6) by
 BEZP281MB1976.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:5b::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Wed, 14 Jun 2023 11:17:26 +0000
Received: from FR2DEU01FT025.eop-deu01.prod.protection.outlook.com
 (2603:10a6:d10:a9:cafe::a1) by FR0P281CA0100.outlook.office365.com
 (2603:10a6:d10:a9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25 via Frontend
 Transport; Wed, 14 Jun 2023 11:17:26 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.54.238.131)
 smtp.mailfrom=chargebyte.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=chargebyte.com;
Received-SPF: Fail (protection.outlook.com: domain of chargebyte.com does not
 designate 20.54.238.131 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.54.238.131; helo=smtp.westeurope.signature365.net;
Received: from smtp.westeurope.signature365.net (20.54.238.131) by
 FR2DEU01FT025.mail.protection.outlook.com (20.128.124.172) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.10 via Frontend Transport; Wed, 14 Jun 2023 11:17:26 +0000
Received: from DEU01-FR2-obe.outbound.protection.outlook.com (10.240.0.195)
 by smtp.westeurope.signature365.net (20.54.238.131) over secure channel (protocol=Tls12, cipher=Aes256 [strength=256 bit])
 with Symprex Signature 365 SMTP Server (v2.1.1.232); Wed, 14 Jun 2023 11:17:25 +00:00
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=chargebyte.com;
Received: from BE1P281MB2097.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:3d::11)
 by BEZP281MB3010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:75::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 11:17:24 +0000
Received: from BE1P281MB2097.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6a58:36ff:9330:d4f1]) by BE1P281MB2097.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6a58:36ff:9330:d4f1%4]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 11:17:24 +0000
From: Stefan Wahren <stefan.wahren@chargebyte.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Stefan Wahren <stefan.wahren@i2se.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Wahren <stefan.wahren@chargebyte.com>
Subject: [PATCH net resend] net: qca_spi: Avoid high load if QCA7000 is not available
Date: Wed, 14 Jun 2023 13:17:14 +0200
Message-Id: <20230614111714.3612-1-stefan.wahren@chargebyte.com>
X-Mailer: git-send-email 2.34.1
X-ClientProxiedBy: FR3P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::10) To BE1P281MB2097.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:3d::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	BE1P281MB2097:EE_|BEZP281MB3010:EE_|FR2DEU01FT025:EE_|BEZP281MB1976:EE_
X-MS-Office365-Filtering-Correlation-Id: b8b7b394-78f8-4b17-12b6-08db6cc8ef17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 u6/8vANtMAOKxjumihzqRtsMiNi/FEbF9wg0ziz0x2BWWQzYpeY1H3FrFzbGmudnnOquVnoXQB4A93eIAcCvkxNSFdkS81Vdvx6VsgJnANhnpLWy27pTaNF9Ji4ag+N3Fp09wc8x6uHur+OZlXpuUPSjoqaqUrhjZMB5itazIN63wLEgIfy3YHfhqsWfUw7354cTYvKDUeVIa5UaqYEvBCVr0MVuBdu8S///VO/C4gEbpufPXDh37L0GL+TIemiutv4sVLkqgAa5tSaKcKix356jjZ7HEaQWteU2fQcW8dEATvlG8hlmWIuCBgtX8BRxNBCXjDIpdIHlaJjuk3WLTk3fgaWVcuxUMRydXg+F1LjOy0u8yjyOf29L0DNIQGiIv/2vHUW0k2iNiFfuT95d+dhjAwORUp25fcs3nJr+uaV/SYy+Upimt023DQqIzygjvsgxX5zoi/kMRPHB2XU++jhOVzOSUh32UWcthFQxvCOuf18Z7Yp4evM9hnywvKmgOEdCHxXU1yPyacWG/APkveloEcEobxE1Cj501u3wv5erHnrv3RwHgHYJXVyTfs9RiWj3H2R/lI9WWVrxHnpoiJGz/4fdLDkTfZFEFuy5BlvB1puLotOqgDc9qwhctCXWpSoqCggpiEOPgjfgtrzdP+9sa79cfqCZlbGcGojyiuU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB2097.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(39840400004)(346002)(376002)(451199021)(54906003)(110136005)(6666004)(86362001)(107886003)(2616005)(26005)(1076003)(6506007)(6512007)(36756003)(186003)(83380400001)(52116002)(6486002)(478600001)(41300700001)(38100700002)(316002)(38350700002)(2906002)(5660300002)(44832011)(8936002)(8676002)(4326008)(66556008)(66946007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB3010
X-Signature365-MessageProcessed: true
X-Signature365-MessageIdentifier: Y2hhcmdlYnl0ZS5jb20tMjAyMzA2MTQxMTE3MjUtezI2Q0NBNzNFLTI5ODMtNEI0QS1BNzk4LUQ0REExODM3RkIwNH0=
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 FR2DEU01FT025.eop-deu01.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1658d423-e10f-4082-6a77-08db6cc8ee04
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	D2PI3RIA+tA3HFsBO9QBFavUSXTncR+YaK1j3Ob9MCtrtPBy/DYEHd8qZx6SEvFdNTgGsDqWCWBjCRyV2P7GhI31ozTwx73wFDYOxiCavKwuiXjidRtjQbH/+m0K4Gbgqb2M6aE3i/JSzTwYYhoJGf6Xc6HvJLUb8j6B/Zt11QcrUcYtBsQ+n5nTcY7FFYhYW0mT5UdYtmUBvmzaZ+jUk6mL1f4OwPJzUNocOCSypZpcD6Odeh2YZjL7pn09J6GB5JeXDKkhb3zO+nepgAVN1a6foC6PI3IrWEFRwMVJERigs0L6P+hW6qEXewb6/WZhmLbFrcEjgvM0YtjMBBh7AW/jC0dg5AuUmqSsux7+JIlBgCobvUZZUQ6xvkkB/JkjJz3Na1+mXqUZnHcNpGhEmPZGMQ30LbMvIYzumYvBbtI56sVIl/kln8DFyYe3xtZE5qYRcz73QA+zbKOpokXLF2gLfGVgaY7k93jCHbKuDWe2vQOEIJxMINNcMw314pzocWNnL6SiyXayVhLh4L2drTGtW43rsyVzli3EKQS9QasZnojaFFMk9O/jq/tpvQQSmqRrAGL0eaoXcxFrG9Jze/egGjvtG+VF4aCLDcazEvgjFL1CGMO0RNWe07X6jdVZ6Kdu4Y3jT/bep1yyF2aDVFAQSyhy/FcPbLwgbJb9++sRjIgKq9HD4JgqlU1D5Uhz5HGhSIeb42wqCO8J6w1WJg==
X-Forefront-Antispam-Report:
	CIP:20.54.238.131;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:smtp.westeurope.signature365.net;PTR:smtp.westeurope.signature365.net;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39840400004)(396003)(136003)(451199021)(46966006)(36840700001)(107886003)(6486002)(6666004)(47076005)(36860700001)(336012)(83380400001)(2616005)(82310400005)(6506007)(86362001)(7636003)(6512007)(1076003)(26005)(7596003)(356005)(40480700001)(36756003)(186003)(2906002)(54906003)(110136005)(70206006)(44832011)(4326008)(316002)(70586007)(41300700001)(5660300002)(478600001)(8936002)(8676002);DIR:OUT;SFP:1102;
X-OriginatorOrg: chargebyte.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 11:17:26.2957
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b7b394-78f8-4b17-12b6-08db6cc8ef17
X-MS-Exchange-CrossTenant-Id: 3a1fd3d7-4c50-4e64-b28d-9f824bfbfcb6
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3a1fd3d7-4c50-4e64-b28d-9f824bfbfcb6;Ip=[20.54.238.131];Helo=[smtp.westeurope.signature365.net]
X-MS-Exchange-CrossTenant-AuthSource:
	FR2DEU01FT025.eop-deu01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB1976
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In case the QCA7000 is not available via SPI (e.g. in reset),
the driver will cause a high load. The reason for this is
that the synchronization is never finished and schedule()
is never called. Since the synchronization is not timing
critical, it's safe to drop this from the scheduling condition.

Signed-off-by: Stefan Wahren <stefan.wahren@chargebyte.com>
Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for
 QCA7000")
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c
 b/drivers/net/ethernet/qualcomm/qca_spi.c
index bba1947792ea16..90f18ea4c28ba1 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -582,8 +582,7 @@ qcaspi_spi_thread(void *data)
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if ((qca->intr_req == qca->intr_svc) &&
-		    (qca->txr.skb[qca->txr.head] == NULL) &&
-		    (qca->sync == QCASPI_SYNC_READY))
+		    !qca->txr.skb[qca->txr.head])
 			schedule();
 
 		set_current_state(TASK_RUNNING);

