Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AC75886FC
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiHCFr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiHCFrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:47:52 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4053C8FB;
        Tue,  2 Aug 2022 22:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xz5glsx7Jz9CdvFcl+Rc9xu4kgDXcfhWQSVk5p0i2e+Y+faSgq717Gro2pnpjjbMQGBcPEVleEaBhxZW0wvBpCtKVNxhaWtRxDVP8zaU+8uGbgpG8OsAcwCidBcA7reMKUJpMXD87twWAJgk+i+8ZcJrEWPjzZ1Lew6BPF9z33IRhvrgbbK2F7JNy1q8D6DjAex95kJpiBAovn0H1etogW8RowBmtULvxgu7hsX5xbPZPyXBpC9JurRe4XQNajZg4PnoSsPROoW4kM3uFPM4Ii13cgUK++MFMQKCUoQSgmZtpkrpAUyDJ+HLvx7g89xqcqS7eaolr82/Xl6v0zLXZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQJjcp8DKF6pLkVeT7POjvJZIlNckNnBJ3zmE7qNBYA=;
 b=g1AV3OB7pXh/ammpFu+lNOSDJjSSPMVQLeuxfDI0UG8caMlXxnQorGpp0LfgYwnwmMQbgSQHsO+cDNzf3B6fL+FKFL+3ZYrnOzJLKmREhA1wie/3OeYtrt7nEmla0qeYcp+Z7dYEsApzr+MqQxSns63T86GQM3vbEO66ayE/UPSaFin7NzEUlxvhYHYe8rbii0sCThHI0A1thWgFw0C/Cs5yaLv8FFO368B59EY+VOyia2Ow4lwNQqqUix5CFWQbvPID8utLzG6JsW/AGTEUB/8lf8qJhg5XaTxYQEiXy3BoKn1EJAMcQBJQPygoVLM/eubfr9oS2kJKLPjIpH47xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQJjcp8DKF6pLkVeT7POjvJZIlNckNnBJ3zmE7qNBYA=;
 b=NLDWwSQSaBdNxV7wL2YCoLEtKbrxwch7G/l8kUzN20941gvfcuI1xBG0oCkL0tAd9y+wKkaJFpGh0RbgYlGAOAzS1PZfJ+3pYUuLOGNcogcv0APK7T8oQsEffqBWpzDWUUaHY1aC4gGWu2jDcqg7iBWpyHUH5p+sEPQLAddLQVM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:49 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v15 mfd 4/9] pinctrl: ocelot: add ability to be used in a non-mmio configuration
Date:   Tue,  2 Aug 2022 22:47:23 -0700
Message-Id: <20220803054728.1541104-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a520dbad-15f4-428d-4772-08da7513b2e6
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ofMeyDomJHUWqxkhiSg5FxSdLJ/nsHF+2rQvHwKRGR+Ck3DLI2No6FCAkObK7gGeiwZ1hFQ1b8z+L+jTuZhWcg6MiwSHZX/bDMgVjzar5nXCSbl+7WLBqriRVPoOS9J2Bb5vvE58/v3hPDwFruqXrwO4R73GvWLW/YGJF3O/Wf/xuFvBvj0Q0zfLVQ4YhxQVvS/spIW6g4BtRqAW856sC8u1vrfwWNEhseibjBg1ihmmxVah+IghUiFO2OLbycPYL67V1P5dfXt5bIUIcioE9xsjGLdkXIkSe9V/atLOo5rUMnyvYh5QryHHahOdym+zqBaB3smbtBZqyMjn14aCIQtxH4u4UdpLBPvbvplwwN/oXmbypAeLhOOeKztQPpnUS/ZYcHjlpaz5dwQDMHaFInzJKBKV4KXkRpavwnlJoo+fdMm4eQqeNfTGBu+Bq6T+Tpw1RCC9BCRRL2l/c6KasJGgF73Yzxo5rXNvXC6XuZ2tXU7dRRBHtZwBxyZ1yy2bg/btcrFhYpkH1XRTsgNebrDeFSBfs5DXCkFoTm1BKz0gYqnBPiOmfBoDyr/RC7RrCHMoC0me8UrK1PFibsyUl0w0anegrxYQqjam6utl2b0LQZbgwy7fyC3BrS3/OW21yCzpLLi3RpBrmbGoe+RlyUQ+QXyQLOmpfm07PLdLxSiZL+NF8DaoENmz/C8QGENAk8HFVPW63jB0TMfRVGGZku20Po+ZOIvul+ULCZKvKBRsqbTexeK6wQbdut41dYpDQo3WEFZcVNdPOCV3CblxMrFf6ErwnF+cAriTth569IQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4en16UqVG2wJOncM8uIMuy9blM9uSthyQwuJQA9m8vXIzo7U7xOU/pwWSv7?=
 =?us-ascii?Q?7JYG7JAP4Mlmr87pMBC6wcJmldwrEvUflJgJvE+pJJzDDYUed/IiQyKAvYHj?=
 =?us-ascii?Q?JPn/QG7KTrV+PznLzHBMlshddkzfmujpgC5CTRxFXlU39RKqmhy2G0lSETK6?=
 =?us-ascii?Q?Pq9AZ97OjdSiasHjGRvWs3hzNouQThHDxM1SHN/6RCVU0AP7693qI6yXFDxO?=
 =?us-ascii?Q?y6foXongVc2qR79k22fUNc7q60W9rjXggRvL3YCItShHajLaMsplRmWqKRU6?=
 =?us-ascii?Q?SGLSP7kSzduMw3FzBMKJ2q6yChb93v0W2MrOnI3S+rGAKgcGf+Uf4F4ubxSe?=
 =?us-ascii?Q?UhTmLzbwPm9SYuu1mlShXuxgzi6eo9mLRg9thzzgWsv1LUR2UZgAD0F/OxhL?=
 =?us-ascii?Q?ZFAl4o/urwkbqjZlmi5rw5zIrMNECXlwviwU9Qr/oODPCBbInd5ttagYcBLc?=
 =?us-ascii?Q?fxx9N5cZVLeTDrE9Gsbl3WNatW8K7Fwjpc22b12Az18k05mYDs+rVHyvtAh5?=
 =?us-ascii?Q?+22MLd+UCrZSJw92zYNm6gtPk2qRIQkyOqa32pThnYjpTxdm9TArI7JPKWfa?=
 =?us-ascii?Q?zjnU0yMwI+BeSrVHpwfaIagVBbEU7/Fnvw0rdIJFBzMEoT7M6KdohztdqxwW?=
 =?us-ascii?Q?Qz54/rFXrDeTzNpeDs3Hi1YZXKrHK8aHKKy0VQ/FhgWoPac2ciJsT9YzWpHm?=
 =?us-ascii?Q?fdTp1Ov7QCfd76D0TWPJuBSqrVOb6wqj86cLGMhcngS9fJbVH9tG2zurkP0s?=
 =?us-ascii?Q?ihkRVgCU2ltBSPxIPAmge+whD8YdHmSxj9fFBLyqt05Vw0k+CeTAKM7//oic?=
 =?us-ascii?Q?mJFxtsh8YOPQkiIHOJbm9yREvzE9IR8006cysDcfp6csXYUXD12n1Y+TOgvd?=
 =?us-ascii?Q?WtS6ueUoHCG+WYskHMpquMWTEjpvfGdMCElLQcU8ZRe+VEgTb86BhZE5Bfzh?=
 =?us-ascii?Q?11t6TfOJdy/vsGP3Mqh8BKwMinxE7pcb+6euFfD6JXPrh6MdFZDULJnVSz4B?=
 =?us-ascii?Q?0WkQ50rOu/93G8UFvPdrEw9ReXjeqPy8cW52UfMRPo4PsEyp5+jmXtRLdfVP?=
 =?us-ascii?Q?VYLWmMKAsGXuW2pkUeAVyhoOh1bK6ak5FbUnbEz0lqq7bP1IkZTnhBAgvF7o?=
 =?us-ascii?Q?cvykoLNk8TFnU1Mcupo5+oSU1dMp05TduwGh/pBLouEVf4H7CQSqoDZ+PLkr?=
 =?us-ascii?Q?qcgcvntnzBpOliGtOmjkqArxdPriIbPXMpZf1yps5n9KMap2Plf5nKxRlUh2?=
 =?us-ascii?Q?W3MuysH+KgLm0OBBjKOaXUiV9zrvmOgKur257kgQb50CH8iiLSmPPf7XYG/t?=
 =?us-ascii?Q?mqVYD+TykxyYpNPnIYteGG6UKN8IsdD/rlhKUA6Kod7kZFAiYjqMguBcjs3+?=
 =?us-ascii?Q?zrTxNavNY51Ce8rib7o8KJIMfr+/aTX1o8zg7X2W2/vCG4I3Atp8oqWhCGk5?=
 =?us-ascii?Q?2ZSLcR1q7BRCjEo5zeD15y/NZJQ3SH0dxHFvzf1QKYkP+2nBNqdxu05GGWUO?=
 =?us-ascii?Q?ZBt647Z5KVcuhw2IrlFDiYJTzJcyTmo3TQqSWP40B2+GVZw3WaaTBghpjkAJ?=
 =?us-ascii?Q?T9vTBhKwapx+UJccDZ7bwKqNSnBVF8etTMU+p+Ja593keBetrLG3R8Rom69m?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a520dbad-15f4-428d-4772-08da7513b2e6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:49.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +I41sEpjaPD7BKP8S0zgZV8ibqNuM5TMh+eKdBrJ7kNQTbPXs7KPJ+E2ghxQ9/OySXn1erMj8N0rhX20zp7Td3T3BljGlopYG+iaFDm43WE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few Ocelot chips that contain pinctrl logic, but can be
controlled externally. Specifically the VSC7511, 7512, 7513 and 7514. In
the externally controlled configurations these registers are not
memory-mapped.

Add support for these non-memory-mapped configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---

(No changes since v14)

v14
    * Add Reviewed and Acked tags

---
 drivers/pinctrl/pinctrl-ocelot.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index d18047d2306d..80a3bba520cb 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -10,6 +10,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/mfd/ocelot.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -1918,7 +1919,6 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 	struct ocelot_pinctrl *info;
 	struct reset_control *reset;
 	struct regmap *pincfg;
-	void __iomem *base;
 	int ret;
 	struct regmap_config regmap_config = {
 		.reg_bits = 32,
@@ -1938,20 +1938,14 @@ static int ocelot_pinctrl_probe(struct platform_device *pdev)
 				     "Failed to get reset\n");
 	reset_control_reset(reset);
 
-	base = devm_ioremap_resource(dev,
-			platform_get_resource(pdev, IORESOURCE_MEM, 0));
-	if (IS_ERR(base))
-		return PTR_ERR(base);
-
 	info->stride = 1 + (info->desc->npins - 1) / 32;
 
 	regmap_config.max_register = OCELOT_GPIO_SD_MAP * info->stride + 15 * 4;
 
-	info->map = devm_regmap_init_mmio(dev, base, &regmap_config);
-	if (IS_ERR(info->map)) {
-		dev_err(dev, "Failed to create regmap\n");
-		return PTR_ERR(info->map);
-	}
+	info->map = ocelot_regmap_from_resource(pdev, 0, &regmap_config);
+	if (IS_ERR(info->map))
+		return dev_err_probe(dev, PTR_ERR(info->map),
+				     "Failed to create regmap\n");
 	dev_set_drvdata(dev, info->map);
 	info->dev = dev;
 
-- 
2.25.1

