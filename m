Return-Path: <netdev+bounces-11464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E47B77332B1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9922C281808
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413DF1D2C8;
	Fri, 16 Jun 2023 13:54:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD761C74A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:54:26 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1756635A4;
	Fri, 16 Jun 2023 06:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdydosE+Sv1RpFhIYNnzxRpAnNwTpGq1NchOOEaNJ4ZxtykcJ20PngrP9trJfwSmYqcQbGumE/TLC6+rCNTu26IIpQy6RIKaovuZIfltqSccGl91OAWtefhhfEqBIG02dQPK5pSCgjwADc0ba+qKPTMAaxOTi0nJoZLp2ZiXazhm1nQvBVdpUTan97HdqCZs/X10q+7W3blpNXj9pIe5fAmfKNNR6M6rKk7yhE19HUEpztsquiwd0KyrLm8dQLGc+hHnhEC+8YsrMziRzQi1d+xM9k39qBet2KR+/1D5ty4xWkMRXdaD6mWvt+41JlkFVrNux3IVJ6+BmP7XhG+QnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YyDnqErlZIqP8i9PhBawGwqTPTvxzVv1OFQGxn2Uh1o=;
 b=QViJ+MtVV3XcukrwXHYxztDIB2PzbpCTk46GFMZC5qTWvuFDsxYZazMmcApJko05wBefwgBHYJ5NQ0Fum4NVEhOeeali/25cow5rQTtSzQ7Sf/yBVKUT+Mi2n61BhDFRKSy9UNkb9Q+FQz3BjPJxPMZBc0G7c/vkAIwIS29wcvGxuPRnq5pakRjEcjKjx/3QIEJdZd54XxNFjFFAftWYOY5Yt3krOaMXcohWTKFhejuK4Fv4EZF21GO2brBC/ZjKxZfhIoEmfKPdcKN0Zd4/d4dwfrrsSPV4nHpcXwT3sIDNcrOy91eqQUKmvjuGb5gxwHEXkZe3imITyyFwJJvnVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyDnqErlZIqP8i9PhBawGwqTPTvxzVv1OFQGxn2Uh1o=;
 b=d+XQbLAGkbcOTZ7+RhjrqU5KU/A05oqf3Ix38JbZ2Ox+NAXlcnovXXmwSY5fNfmDkii2IwBlC8EPtqavuokE48bPZNg6AQpkZ9VZOcyKTz1PW3p1tqcX5ckaffZYv6PqzAeri04yogNAkcTNqE/1Gj3yQXzrlKUhBAC5P/woYP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9318.eurprd04.prod.outlook.com (2603:10a6:102:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 13:54:04 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::5356:c79f:ef9f:dc29%4]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 13:54:04 +0000
From: "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To: andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	richardcochran@gmail.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sebastian.tobuschat@nxp.com,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH net-next v1 11/14] net: phy: nxp-c45-tja11xx: run cable test with the PHY in test mode
Date: Fri, 16 Jun 2023 16:53:20 +0300
Message-Id: <20230616135323.98215-12-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
References: <20230616135323.98215-1-radu-nicolae.pirea@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0106.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::47) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9318:EE_
X-MS-Office365-Filtering-Correlation-Id: 04b6e420-d219-426b-a05f-08db6e7125ae
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nqMwuUQnJds52XOriuOgyOgOErzKtAyutPFor2ydnMpDVlSq47XOZXR8ssLzyzVPWwytT4aC2kuXCL7f8pZHc+pZXnJAH5s/7mXv9F8n7vg/0ZzOsLij2E5vB6EJBpn5hjBjUFhl5v7qPKQyzlfMNlz4NiYTHiqgoa+NUgYBmvyPCI7XMMib07RKe9FDeIuBLNlD+J+I8b4oVF82BwKkm5m6guBJE/sWXXmMCr8gPRFx+HI2YABPwAx/L8LEuQN3K5rkmprgw2UroWW/mSUUPUCGdI+Av3WYjU4ZyAdlYQiWtNGBkuW0hiWSimc2pK82zg7z957x+djowXdrEzfMtVdTAi04NAZ/wQFbJQcpRgJGAh6ivHosj2OmhndhPbKlbC9sSC0IhUku/18JyfgMDQDvJ9MKdzuw7MDLl0ka+uFrP8RwYofbZIvqK3ZEKsjW1R1r7Ff/rwJmZnGIXqW+7410+wL6U0Y2XEddNWaSwR9kg9TJL+XrB9Po/Vhvz4ZN6z7mwuLUruxnv4BjD91EB0ubb+TX/sSUm/Og1qRzNknZ5TIDhGucdqvFSd7GbOk1DbFzy1DxlHQz2Ev9ITPIF4by9Qmx+teL8obH1IewhVY5uE1ySkNnMBaJ603QxQqh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199021)(41300700001)(52116002)(86362001)(66556008)(66946007)(316002)(6486002)(8676002)(8936002)(6666004)(66476007)(4326008)(478600001)(7416002)(6512007)(5660300002)(26005)(6506007)(1076003)(2906002)(186003)(38350700002)(2616005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RutDbpx7w+icFRfFYKfSjAxifx+xxu4sNCJcHCz9ecvasH7OUEZ+DfDhETA6?=
 =?us-ascii?Q?+spoZfoPJj9kLX2iD1PadOu0m07gnvwfGefiDu0XqLZuudKwEKqLAyWaHkQF?=
 =?us-ascii?Q?tv+NNgOVsDpcU0CADdWTICOjO5u7gG8Ez1VdDN1WOA0J0Ia6KbJITHWOTGol?=
 =?us-ascii?Q?lhpujxS8TvCvV+a63aqR7Mp9joOgH0V/UwntKr+GSTvAmFmtDB0WJnX4W4yy?=
 =?us-ascii?Q?Axt7k7MDx3HIDvtQGK7hSgiRzHSuljihR5FD9nULdB6K7S4HR2j1E1CXNZWt?=
 =?us-ascii?Q?MUbmH1kL4sPUaYPWMSbs3MYBtbuWQG3m2ingiOpWm3ngi3GenZrgPk5inSN7?=
 =?us-ascii?Q?CI13Q26p03hPIJYr2akG4De7Ojpk+GacrbdFYoVjAceFyrCsV3U0Mj+XC/q8?=
 =?us-ascii?Q?R/IYWF1gcdnb/HwvxUNjsNCITlKOUpiynklVzjuwj9pfIU/bomGazRHpuOEW?=
 =?us-ascii?Q?vc3mxDYyBtd84vJZqSSDKOB5bNhr7OB1vP4rgvZYyux55ubCeA3MgOYsbWgD?=
 =?us-ascii?Q?LaqQplpu6xLfbnFTTb6BxLPOP3dGFPZaEbpeXumrempg0/99UOtVZaRywm6N?=
 =?us-ascii?Q?FTKLAAVJJRYQ57Cgqn0CW5fB9OxkdZHCQCalSzKropMo7AgbHsSC1zkfEYOB?=
 =?us-ascii?Q?5WOVgTETKiXWF/hCIVz9f6bTZRgnA2sAyOkAFOSP+su2N4dqGwWM7nbjmjwZ?=
 =?us-ascii?Q?aS/pyyMTpZvCcSgfJiDWaYMFa7LVVrJZWZbW3TFv45ChAefgtEcf58To59GB?=
 =?us-ascii?Q?Sx4fFQUu+d3LV8pI9ij2U76J7sfY/+0c1eZyW6Vw9DB5FUwZ94c/OTwbEwYs?=
 =?us-ascii?Q?rECNOmjXeLi8oUDczuuMPZFCc5gDPDxnG3/p5aFSP5MMyveBuisHKGU6me35?=
 =?us-ascii?Q?g57paQJX2ZgmATVZkOAmBeLL/fZa3gbJ9CWB+Qf83h2rhcSmPKozwBq50wLO?=
 =?us-ascii?Q?Sp/QATa/zmzUH9Cr4DhvtOzqL386VVSpjfG7OqloxCH9o9DRSgJs862D6T1n?=
 =?us-ascii?Q?zmka14aH3ICAaWTCevFYx6yvRGnoj7khEP6FL1eXRw3rfVZCqfaAn8tunje7?=
 =?us-ascii?Q?qA/Jgm1uPlppnacMvod/MNVV0wIbzbmgAuocFjUUh73SeGJiZO1M+N0kEz11?=
 =?us-ascii?Q?zGjfjE7pJLMInpLpF2f65JCaLrMOM+/Sju6AENYduiu1NiO9L0yHsBF2ZGev?=
 =?us-ascii?Q?gWiAWyUxAl1Hpu0WaVQPMvNkm5FlsFCb7+VOXJERT7g9MWazDYdLCuR0Ujmi?=
 =?us-ascii?Q?GszBPxxVIZeAg+WEc6Huez6eNxceLru3nQpHZPno4jlEU0Zko4MXZ5MzkS0w?=
 =?us-ascii?Q?LEwKmJh1/nPoDP3+dX1SWk2QS/5cke6hFxYi8bHpXah0hQU+3Hby2g943bIg?=
 =?us-ascii?Q?edMtXm/RiIt4fDOozJW5qA5RFxyjpnysDuu1+iX6C7uzzBeoA360zjV5D6Xf?=
 =?us-ascii?Q?3oNKGRsKdmWb+lclbcsQJREQSWweyrxvtxoYc7VU7FktETkI9LNvHwlzq4wx?=
 =?us-ascii?Q?j1ySJnIIhiH+6rv48lG8MpuEjMuDUUxAfdLbSTZ/1ya6Q2T8WHJkyUt0hVRm?=
 =?us-ascii?Q?pqfw+ZzgxVJDKFiWSkABLLGk/iuu5fOhLWpzTuNZhUPnaiRjfTE+pYLKaOmi?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04b6e420-d219-426b-a05f-08db6e7125ae
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 13:54:04.6957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x5z/xCRTQ6q/bz1ZL+v8gctrMcv5RoffIdw+Ksw3DUW1tn6mraGwlGJ3QBrs2Jc1fQoTKAPMqk+GjAlYhHg6C64/czcG9cSAyI8CiK85jQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For TJA1120, the enable bit for cable test is not writable if the PHY is
not in test mode.

Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 0a17a1e80a2b..4b40be45c955 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -144,6 +144,7 @@
 
 #define VEND1_PORT_FUNC_ENABLES		0x8048
 #define PTP_ENABLE			BIT(3)
+#define PHY_TEST_ENABLE			BIT(0)
 
 #define VEND1_PORT_PTP_CONTROL		0x9000
 #define PORT_PTP_CONTROL_BYPASS		BIT(11)
@@ -1242,6 +1243,8 @@ static int nxp_c45_cable_test_start(struct phy_device *phydev)
 {
 	const struct nxp_c45_regmap *regmap = nxp_c45_get_regmap(phydev);
 
+	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1,
+			 VEND1_PORT_FUNC_ENABLES, PHY_TEST_ENABLE);
 	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, regmap->cable_test,
 				CABLE_TEST_ENABLE | CABLE_TEST_START);
 }
@@ -1283,6 +1286,8 @@ static int nxp_c45_cable_test_get_status(struct phy_device *phydev,
 
 	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1, regmap->cable_test,
 			   CABLE_TEST_ENABLE);
+	phy_clear_bits_mmd(phydev, MDIO_MMD_VEND1,
+			   VEND1_PORT_FUNC_ENABLES, PHY_TEST_ENABLE);
 
 	return nxp_c45_start_op(phydev);
 }
-- 
2.34.1


