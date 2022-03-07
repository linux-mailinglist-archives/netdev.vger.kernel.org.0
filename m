Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0574CEF5E
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 03:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiCGCNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 21:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234689AbiCGCNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 21:13:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7160E5FD5;
        Sun,  6 Mar 2022 18:12:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp5in53jzu3wnn/BdskwppXLK5zC1hLjwSi+XzYnXJttrVA/to2DcNE93nJuOzh+KdihQg1aY3KhNoKbc3mCanwpRte+rPcUPSgNUeJBpY/cW8JZNS/0PTbjbExzcm1CHaWyczCo3L2EUc/4oDpRO5iqxVDpDafMKK+QfBeJjLFQEPcpPJiquKomB4osWrCepz6ZgE1zSmZtiDyyWKr//2+gCUfE4Agw7xOmi/576twnOZ4m7Ngp6JKWtETM1ESXw2JKa1V5ukSYMpzLn9KhMQ9eMBwTV8j9G1Ma1Vwxz+Sbyv/dNeIhBtdHcFtFZjNuoSDT0ewLoNUeoQLcWJUcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hJjodq4GG2vfBpX7f0GbXAm1LzTx1uG4qV88Nu7HeQ=;
 b=SUr4K5r8pOKnOTR60BJagQwDsnRWR5Lgjomris4x4Ob+EXvMcVV1niExf3r2DjUHK1aYqtFHn3P8ao1s2T3ai9p70R4BIgtszy2uwnQFZ1D/1sweuJpfDTOJwXjWTpxSimH0QJfg0JXlcP0YFQi5LCAluYeDyEvzdbjNA2Nmfiw9ZpYxywJUkCkky2KUDr30ExDwxeGTD8ZdFUOCpNilcFxRi8lmamE1COuWZisZzpqQzVENRez3eHwmMYAETHZJBzbI7NRMRrhJVMy/mnloC4FggNc3fC1t4ocnk/Ld1lNZN2TD9QHo2WwBcElYKWX+RW6N3ccbUAnGvoQot1JKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hJjodq4GG2vfBpX7f0GbXAm1LzTx1uG4qV88Nu7HeQ=;
 b=gqsP51+Zjnbe3bv5+1Ub96PkqRTXZzM75QTroBJeZ06PnobUEuh8poNK/JcxcLtS6bwIvjmaDTXQfEGFq53F5owCENA4nYwKR944L7degzv35rD+JCX36jigfDN8phZ+m/7p+XD/X2WwY6IuJVoULyxLBUWL/VKq1hzR4bz48wI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4553.namprd10.prod.outlook.com
 (2603:10b6:806:11a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 02:12:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::7c:dc80:7f24:67c5%6]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 02:12:24 +0000
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
Subject: [RFC v7 net-next 01/13] pinctrl: ocelot: allow pinctrl-ocelot to be loaded as a module
Date:   Sun,  6 Mar 2022 18:11:56 -0800
Message-Id: <20220307021208.2406741-2-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 368ea0e2-ea74-4207-f379-08d9ffdfeb6b
X-MS-TrafficTypeDiagnostic: SA2PR10MB4553:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB45535A41F853FF5EFD33E98AA4089@SA2PR10MB4553.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UUbaUn/JSdyNFaOwC0O8EbloTeF5ay9WEMpLR/pXyAZLtjiSSJQ/KgEKS4Fwkrg8Qm9ziRY8oANLflgZrkR54mkUyCW1k8mSpR6SgoD0X4ymQ1kePu6mkyv4tVbeQl6k+j7urV/DT7OXfMUngPi7U7dARFmLwfDmWGvLwkAUir+3YT9+9jU79Y5cCX4NMNv10dvlL4dr3hLWJixM0WDwcuY4m+ULM1eFn7R3ZLMQew6ZfR2LCWv7znJFDMd8m1St6QelsiiadalbzPaW0IpEWZnekW+i0TnDjMw40YBOL7QIGj+T5ZK7GXzCIZHkpafZfESL/ACHkYY36Qr9yFjJq+swJa3q4SRChUdw88ByyPGE06i+oMQYrlLjeDjtr34OyOGNYzwlHHzI/xwMvigcfvEALJFlLFX+2+VIDDxCPiDQVqC0ohetpDNKjNerldpDTizOi+yXJNAUTk687V5O64dvwcaoPBbfNsHA6+XMhJaMw103gXH3R7yY3cuNWejJvQNr8TVAV2Q0EinSVyiDFT3yLNMY2EotedJz1rbuZo9G/CYVS/pWOSV3DK0IbT4m72uM2CwRWdxIRI1/Ip08cXKx84wDLCYirKkUSHkcpcJz6oJelr2vxOqPbEzM5UZXjPLg8AIGnMMLaCUlEWsmpABp80+7KXTenWi+4QqyF6a6ae8qx1APiAeEhZIVRozNwxg5EL27xllpt0AHqWFmbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(42606007)(396003)(39830400003)(136003)(346002)(38350700002)(86362001)(508600001)(107886003)(38100700002)(6486002)(54906003)(36756003)(44832011)(6666004)(6506007)(66556008)(66946007)(4326008)(316002)(66476007)(8676002)(6512007)(26005)(186003)(8936002)(83380400001)(52116002)(1076003)(5660300002)(7416002)(2616005)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3qzHTuRyKd1Gm2tnhmtNWP3uve3W0JA1up2TqRyWG+n4XIEceUu362Nn2aUV?=
 =?us-ascii?Q?FLAMU8x/AFC//eOvodPPBwEGxIt8YCmFG97W2e7fm9Pw+X+F3XItLfsYa3Av?=
 =?us-ascii?Q?0HEJSO+jixoUoU4Hp2QSHa5s5ql7ROrvb1QFaqCxLfXazBvPCRLNwSNcYk7P?=
 =?us-ascii?Q?afZMS9hxtFow9Uso1waViy6zlxeRn9BbXbHRYlBJsiv0j0Od+ddoN2SDb5Wb?=
 =?us-ascii?Q?IpbNGaK8nX1EmnwR4TW4K2nfbpnA03E0WGpWsebHFmNNy7Hu8PG9/SnYMbN6?=
 =?us-ascii?Q?UFV5mQLGAWD/FdJbqe5WWvEIwg0JRcpyqAzbd2UK9hdIIfg/Bec/OiO+fnV8?=
 =?us-ascii?Q?pGGwjizDv1iGFvgPgMeKFw/b6e5XqFnRcy0DEARGD/HgCD+DzvRfz+uNsUHt?=
 =?us-ascii?Q?3pyliewWW2ZWfmjph448Pss1lE9WHGXCzHH/3KKN0XpLZBqRc+Z76/utfaD4?=
 =?us-ascii?Q?eCc7mZLAgHI+oahAlHBbNZSHWpHj+nl4nFhBy4aKHSm9gAni4nyU+0JGi0y/?=
 =?us-ascii?Q?YnnPwR3K34UMMYjFDqiIT5PRps+Yvd5sNrespOrtQEFaMH7s5ISX/0eYUqBV?=
 =?us-ascii?Q?mz7rwCgcamLew3PEzprLQy1xk1DzGtNktWkfOAqBGa1JEjrNkC6ot7wFe43C?=
 =?us-ascii?Q?JjhdBrzL29AGLVDRUyQepyjUUdcrr0EBnPPzVRt9LbTzKLxUDeHW0pBsYtG/?=
 =?us-ascii?Q?LYEndrzkA70cNurmbB1/OrnIOAxbXukMmKsH85UsS6GwNBhJWE6iiFBimGDl?=
 =?us-ascii?Q?Iv1VIL2o9h9jRxdrBZBzk2QZPnT7gXglEUbdmQ0C0MVyOns86afHUwqZDY66?=
 =?us-ascii?Q?cO9ngu4Jn5sgPsSH1RP/z3mJ5z+hXf6GbriMr1pz9zB2y+xHpZtFzFmn1yoQ?=
 =?us-ascii?Q?JlQgopNEhAOXR1CoNpxzHUklFVBIb1VNEsjDXD4ezAXLA8hTSjSuY5uTiAPX?=
 =?us-ascii?Q?x80u9HHK/vVEedk5CM21GaViQIsiyT168g38KebXTGNLqOOAe220lvA9KVch?=
 =?us-ascii?Q?DrSpId4gQvq922n1KPE6jAD5pVDTHIMpXmffYAaw+2/RwLPXB5BzLuwC0UcC?=
 =?us-ascii?Q?Qd1lunTE8dQxBdTNs92JiemjFXyrOAslU76mnxvmGc2dTQ5fKkoHAcBJUR+c?=
 =?us-ascii?Q?2MZIqUM6g0i8AFQsUwRXDqWfR04enbh7/IBGHV3YwxkbprgIDho3I3PwScCj?=
 =?us-ascii?Q?6gAF3n/PL6dbOaxmmSafm9Hufo9ttxKoCOH7QHqUPVIuE9NepUvmlD/geCC8?=
 =?us-ascii?Q?Gyr+aw7fNfZQ9YAcDA+ceq3kOrZg6wAjryvZm15+DcE3dXwKskYuZCTz4/cx?=
 =?us-ascii?Q?8u5+MrMXkKku0J6k7hXl3IUQobtz/YrglG/Vpf7nVkQVl+a0CZrhkUCGuzq6?=
 =?us-ascii?Q?qvd47N1ciUttdVCVjhbGAxpB+6GhUypN02eG/oZrC4DSUlG6w5Q7pchRivr2?=
 =?us-ascii?Q?X0gZTBPZgxg+SJGtQCZntkbqO8qipR9XVzq8znOJ+TQOWGUCYtPs097NPJOi?=
 =?us-ascii?Q?Rstx1I4x8aYhOtSR2EkG4WUlGPPk3UVOL/nDP//E5HqZcmiVcyM6JqOdXpq5?=
 =?us-ascii?Q?CxjBuzjqBCTl1axiaGqeCnHCVi5OmQYaOIsMSku/jcDJjcfkdanxS9E1XMDh?=
 =?us-ascii?Q?BPuVV8uyl15Le2WqVAkiTgGbHkjqgsYNXYLVAiupX3P/aXbOKNDWhPwSWRs+?=
 =?us-ascii?Q?vPx76g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368ea0e2-ea74-4207-f379-08d9ffdfeb6b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 02:12:24.6833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0QwxKWa/0jf93JCN0Q+CuiEt6GXQA4TNzwF9q76J+ScUYMNdu3yHwbLDefdbBT+gu+Osux7/322sAbXOiMPSxQbaRokVuHyu3j2duDdc+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4553
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Work is being done to allow external control of Ocelot chips. When pinctrl
drivers are used internally, it wouldn't make much sense to allow them to
be loaded as modules. In the case where the Ocelot chip is controlled
externally, this scenario becomes practical.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/pinctrl/Kconfig          | 2 +-
 drivers/pinctrl/pinctrl-ocelot.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 6fc56d6598e2..1b367f423ceb 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -311,7 +311,7 @@ config PINCTRL_MICROCHIP_SGPIO
 	  LED controller.
 
 config PINCTRL_OCELOT
-	bool "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
+	tristate "Pinctrl driver for the Microsemi Ocelot and Jaguar2 SoCs"
 	depends on OF
 	depends on HAS_IOMEM
 	select GPIOLIB
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index fc969208d904..b6ad3ffb4596 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1778,6 +1778,7 @@ static const struct of_device_id ocelot_pinctrl_of_match[] = {
 	{ .compatible = "microchip,lan966x-pinctrl", .data = &lan966x_desc },
 	{},
 };
+MODULE_DEVICE_TABLE(of, ocelot_pinctrl_of_match);
 
 static struct regmap *ocelot_pinctrl_create_pincfg(struct platform_device *pdev)
 {
@@ -1866,3 +1867,6 @@ static struct platform_driver ocelot_pinctrl_driver = {
 	.probe = ocelot_pinctrl_probe,
 };
 builtin_platform_driver(ocelot_pinctrl_driver);
+
+MODULE_DESCRIPTION("Ocelot Chip Pinctrl Driver");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.25.1

