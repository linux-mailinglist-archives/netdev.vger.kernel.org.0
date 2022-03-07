Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38FD4CEF7D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiCGCOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbiCGCNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:42 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015B4193D1;
        Sun,  6 Mar 2022 18:12:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g8I8AeNF6AS92DXMLvT9G56z5zrgz6RS6Cpk1Pivaa5DY1QTYCosA3z5dqs7/axKsS8pATt8bJAHJ1XEuSzMJexXdfOB4pc+TKSYq4WyPCIz0WsCGkZqa3T8+fwOlw5rHPn4fFpudBQaGkUworQMVPjNyInwFEvyQ8cHOnqHXIks6JlOaBvbabnzEDPORoEkXdvK+3m206Ak+R4KhFXBAQykVy/UwfcK+4tSezBbjocERXpo5AhplpqM4eSuP++dK+1bfjA4ILPVxaHyfQd8IgCqFUEVhEXGk0iqs2oHuHBrl5ogl4Q++191pXmhKGikiRKFSlb0cy/KDBWdQaoYFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVQn+Rw6D1mIjHJMVvzs7nbOpOfnbt6zrqS/OU2FBPM=;
 b=Gr2ZBd26XUskL13Mi6ofA5QF3S5A4a1o0LSvLg1APSk2GqoaAKZgBC8oB2QUr8NRNHRyniYPHF6jmjnroZE9fpteulI4Ulrt1WzQIVA/Nh5+e42HqXVxSycOc9OJ71PVGx2++R0Ui4bByLWNxSVpvfK+2PlKkpmfvgqQrbopToTPOhzfmsDmnAi6hf1xXL3Qp34CKXA50C/NqEdbT5aWljwsWEnogwG9u8t4G8lI1pPMgz7vhswajpgEImzES1/mhOhHT20+1M+b7jfngCc0lRvjfqnweFc/xdTkC3d7YEULNi1LiHpN6GQw8T7wQfHBKSfWPSqfoNkxKt+iuIlLbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVQn+Rw6D1mIjHJMVvzs7nbOpOfnbt6zrqS/OU2FBPM=;
 b=zZJpCGmVjw072GKjQ+HV7RxoCj/9hF6TJ6Av+NEs05rrXh/8DcD2IDFcPFhKeMEcyeRpaifSdaU4FDrueD0uY+qmU7pP4n7I3TEtyccoArsIpV/lBVfGv8XyrTvGaMAEslBrpnG87Zlf8fMqpwjDiezHY9qUitFavBLmkfOloJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:31 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Angela Czubak <acz@semihalf.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v7 net-next 08/13] phy: ocelot-serdes: add ability to be used in mfd configuration
Date:   Sun,  6 Mar 2022 18:12:03 -0800
Message-Id: <20220307021208.2406741-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307021208.2406741-1-colin.foster@in-advantage.com>
References: <20220307021208.2406741-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:303:85::29) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a33735d7-3fb4-4091-1462-08d9ffdfef6d
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB455394C27CDFA65F742985B3A4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gnX+tkiKXRP6mh6WIY15dqjvA8pXVp1t9cwDzJHRAYyzWGXWziDvxnvvs/Q2dmPYAI5P14zURW+ICMhkWABXH4r/xbdOJt+qun6cPEUy7xBcfy5tZgrAKErQu9dl9XZKTj0BKkTHmEvkPc/yewJBXwD/dS1Vf3enPUlB3J8u2yjTMpvMCtVNXR5NNnBK88c088WGFIXeitvEGfJ+hR6WiX4Zha1+20I1FlDk9SFI8+6DR6KhKBFB4sfzVMh0/RT8DvPirUqHVsUo+g4gh2mbngHyy2d54hq0kBGbypl0AMO1LpbeBx+7RQnOiZGk6MHhvNAcpXlwj8qMwUwNP4pP3popwlYZlkGOjQt8q+7T3NYBnuZ2yLxmp3AYA/Z8w0Z0IREPxsb+Nefjur7mZLmG0FShRyt6rmwUtIMlqMn/74KNJ+DO/akoF6GATnCns0A7DuusI4xdUkcI232r5HlfBpNZztIUgUAqmITd67EkUKTfkN6oflR4hV9vRJXa9wr+hSizFoPsRJPrL9DRUnrmqcIvLfa4quaQIk0IHhAuNWn/P5ClgKlOnHcRjHaYY+6qRgeJRzKmg8LX+XO1kGol3Mz8LlwTP2wNH5ogG+UVuBoWc6wbuoWwahrOcAvI6jFETQftDJG2t9aR8XUrporYOSV9fV/8bxX940YfKUHW5hbcEuBOp5OHcFXoh9TP9xPw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(136003)(39840400004)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w3cX7L/KFh8QqTQ+6V6JR4ehmVI+u+Pvhjb5PISYye+BE11NrjyejurOnj60?=
 =?us-ascii?Q?JEV8/yyu4Gik4BeTNjpEYRaQjpGeWfTNfJ5ZRufPKxm/eIIk2Rs7n6thtJSJ?=
 =?us-ascii?Q?eOF/S2tRBTHo790g7kd6G/JSfpgKftGePjlsX+g8ygFI0IDz8OPjuANtH9mj?=
 =?us-ascii?Q?IXWEmqkVAL03/ySameNQbEC9HGFUQzBMZ4z96mHMWKK+C4Y5ltSsjjYeC2+x?=
 =?us-ascii?Q?aWDhWKqkXMsdOW+vJCxPLpriypFssdqxmVnzmr48LyGC2G63ouPGmzUsqG1M?=
 =?us-ascii?Q?FkaCG/+caH3VTJuV/R22L6yCyplGDXoyslz4nRsn7Lmbdwy+E3MAu12Ez+nO?=
 =?us-ascii?Q?G7cxRV601xWW903F/ZLX4mBoDnfBeYF5/LbnCGb2nDmjUVFA3aIl5SZ/ZaE/?=
 =?us-ascii?Q?TMrRJNf0xnVg965CaBRhdlKJOWJ2kANUJehR8mqAePWys0Bf7i/9hEI1idH8?=
 =?us-ascii?Q?3DxW1VIarmhOo7zOjQCH5Clvat2gEnQ7ra7x6l8MyChgTDtniENcsKbVc0Eu?=
 =?us-ascii?Q?cwHL0f/teCHkFh+0U3glocfTSkHC4N1QdbTkIAzxTEVpiuOjbmUcm5ryAvde?=
 =?us-ascii?Q?+mSila6gOljooV0eXySy7b/SNA/rSO87oOzDmnfB704MZSrl7FbFz04SxPi3?=
 =?us-ascii?Q?pj0g21z/JOMHU0ZFjgfGybhrLHlLPus68rdsa//5fUYb2o6zDuCLMYz2R5IV?=
 =?us-ascii?Q?SArZT7cFW2K1HOgBOartFmJNYQFlNHwxRmWPhvHzPoaVYLaoCqEOY2s/h9p6?=
 =?us-ascii?Q?pxo6DQGUVHxPNRhZtjWnXWzCE6xh+FIsX+eFUlWn1uGOCsMQOHAx/xykL1HT?=
 =?us-ascii?Q?mF52JX7jdsKDXSF0pieGbtowO1tGWT/CkoHo355HCg8oZXnLydY/JdsS4kvs?=
 =?us-ascii?Q?WHrDmtgr+zZevQz/ZmONngYpfp/72SW0aWesyPRYM6++Cf2MbeVM1GeNsXbS?=
 =?us-ascii?Q?40Fs9xNOHt0LXv57PLSWqYZPS2cPXB9kttNdP9DsgMfckuXZUoJu8bBLMMdL?=
 =?us-ascii?Q?ZULZS9ijjiSNNNNzl+GfZxBDM0dN2FJEKFytCQGFrdrxmks76f0XVjKc4Zp3?=
 =?us-ascii?Q?g24ks9Ie/1lXul43Qs6mhL1sv5z5vl4sc6jbLVKOChYflqoX9UA12csb5BtZ?=
 =?us-ascii?Q?OrMOzVgkgpo9c131/MCcAZ3YBEz2GkmDgMAduYlXcftbbFv7+HcVlCPLpyIL?=
 =?us-ascii?Q?T2qxZNQF8rxkRMya9dBBwJD82xMKaAaCzB/Uk/JzRBHK7XGZfOMsZ2nJavgQ?=
 =?us-ascii?Q?7942DEZ9DDIw/7svBFh0ZBIpSeBrR01Qp3B3ygwoVnT3feHFT8oD1SZ9UnfQ?=
 =?us-ascii?Q?Mof5E3Ai5nEy1/60JAPtA5qmNPxSLlVoHjDuQN1muOQpkMw6oQdLjisep+VL?=
 =?us-ascii?Q?KnVUnOaK7Wqb26gMFbs0QjWzJStIfIla5dyqEZDu9LH/Uogs1jwceASYf6iO?=
 =?us-ascii?Q?pU7HxdOIQdklBeIgsTL6EFHjiSfBBoqXkW5Y57WTNlFp6oH+jGXaQYFLroV5?=
 =?us-ascii?Q?k2JNDTKgi6P3WZ3OHl+HbbV4jH4QezEHFA3rMQu3kIZmz8DqgwaUe8PsH9iG?=
 =?us-ascii?Q?PrJfMOEfC/N0OJsoTMN/cJEgcdJq0DGJc4ZpdcNnp9OY+j5I1P5h3Bafn+nb?=
 =?us-ascii?Q?2QK328ReV5RgD4Bc5HjToNGqonJj0wQKAGfYiqpXfk2Tv/wvcKMkZDfi1ZUB?=
 =?us-ascii?Q?jknxWg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33735d7-3fb4-4091-1462-08d9ffdfef6d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:31.2141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tUgfQZmXF/07pqy9cC7888Hnmo5fODBOn3cCB0v4xCW5odIlHtpvfBSgfPxu8oxFsebabUsM1VvmAmu2PYDwRfTMxWaCZx/EVRPZrekFLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ocelot-serdes is used in an MFD configuration, it might need to get
regmaps from an mfd instead of syscon. Add this ability to be used in
either configuration.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/phy/mscc/phy-ocelot-serdes.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/phy/mscc/phy-ocelot-serdes.c b/drivers/phy/mscc/phy-ocelot-serdes.c
index 76f596365176..ae1284e356e7 100644
--- a/drivers/phy/mscc/phy-ocelot-serdes.c
+++ b/drivers/phy/mscc/phy-ocelot-serdes.c
@@ -15,6 +15,7 @@
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <soc/mscc/ocelot.h>
 #include <soc/mscc/ocelot_hsio.h>
 #include <dt-bindings/phy/phy-ocelot-serdes.h>
 
@@ -492,8 +493,10 @@ static int serdes_phy_create(struct serdes_ctrl *ctrl, u8 idx, struct phy **phy)
 
 static int serdes_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct phy_provider *provider;
 	struct serdes_ctrl *ctrl;
+	struct resource *res;
 	unsigned int i;
 	int ret;
 
@@ -502,7 +505,15 @@ static int serdes_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	ctrl->dev = &pdev->dev;
+
 	ctrl->regs = syscon_node_to_regmap(pdev->dev.parent->of_node);
+	if (IS_ERR(ctrl->regs)) {
+		/* Fall back to using IORESOURCE_REG, if possible */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (!res)
+			ctrl->regs = ocelot_get_regmap_from_resource(dev, res);
+	}
+
 	if (IS_ERR(ctrl->regs))
 		return PTR_ERR(ctrl->regs);
 
-- 
2.25.1

