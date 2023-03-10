Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054CC6B4EAB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjCJRfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCJRft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:35:49 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D62F7DD11;
        Fri, 10 Mar 2023 09:35:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aanLT9ZFyPF0DDqLmeuL5c/vsUTAGsCQ3ZjoxPyse5CGNgpWY1fiAAjKliqoQ/6TrrCEq2jIcZ0BHZwf+o8a7yq/o0mVjuhhNw4DEvlts1aTH9pnYCfkcr/CvHZBcCXIu1AH7zTUNdh63xR/LyjRBfkw+oSMGEmP/beM3NAb4UiKRSdCAHqvX4+txixXULnuhkcko2RVRrYQFGEa1eCUft3YzLuG2av0030S9TwcrxqUJgYwcHb5D/hAlx0rYM2PVVXBipS/zHLvJv3i0q1rA9z8NHp0yYH3MCs4qkO/4ewuU4bfA612BwohsKCmSxpZ7Lq8UQ1ExwA6bvO6tVZ7lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0SjpM/Jdk6oe9dWyUvfwsJIXdYePKsDAv1sJ/FnmC8=;
 b=JyacWG5WtzaPNa5hoA0hONjTIO78vXfhwmhq+tpLzslDPv5KsKNrg6MIgJQFDHdd0tpuR+QkARQQd9OEmsaCFFi0e7lKB2iWm000i7bOLlTv0WVoLmX/leGg/37khxRPHUqJxCE9fMizfoASjQCkGgaWHcMiRUu08yYTY0XJ7+dL+0WOTwWOrXgeyL9SqSFWYJeIlM3NQvUxoEmMEQcji9UT7u36TqwGo6zVtUAT+L8nOkYERa3juCHAE3zsZ7LUHZJN3KtYfDBviiL4WnqU2gjg8eJRMQsADrSF6Ns3GP65Y5oF8THHIm1obIM6Oky/vJVFhWgKNjEcHHf8adzshg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0SjpM/Jdk6oe9dWyUvfwsJIXdYePKsDAv1sJ/FnmC8=;
 b=VCdj2ugvSmUu9IJxoKaKFzgXsZBhpz+LLKzsyO8nHJPUd67MZmoPWOlUATLPIHXO5+j6gF3IJQa87G2+rhrpSnz6I4+w/aO+gmMntfFY78q+P2QR7N8/KswEyqmdv0MCajO7frqWb12doDu+iadcx30yAIc9G/p855tRJUI6iAg=
Received: from BN1PR10CA0027.namprd10.prod.outlook.com (2603:10b6:408:e0::32)
 by MN0PR12MB5978.namprd12.prod.outlook.com (2603:10b6:208:37d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 17:35:02 +0000
Received: from BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::44) by BN1PR10CA0027.outlook.office365.com
 (2603:10b6:408:e0::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20 via Frontend
 Transport; Fri, 10 Mar 2023 17:35:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT116.mail.protection.outlook.com (10.13.176.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.21 via Frontend Transport; Fri, 10 Mar 2023 17:35:02 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:35:01 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 09:35:00 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Mar 2023 11:34:34 -0600
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <Sanju.Mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
        <clg@kaod.org>, <kdasu.kdev@gmail.com>, <f.fainelli@gmail.com>,
        <rjui@broadcom.com>, <sbranden@broadcom.com>,
        <eajames@linux.ibm.com>, <olteanv@gmail.com>, <han.xu@nxp.com>,
        <john.garry@huawei.com>, <shawnguo@kernel.org>,
        <s.hauer@pengutronix.de>, <narmstrong@baylibre.com>,
        <khilman@baylibre.com>, <matthias.bgg@gmail.com>,
        <haibo.chen@nxp.com>, <linus.walleij@linaro.org>,
        <daniel@zonque.org>, <haojian.zhuang@gmail.com>,
        <robert.jarzmik@free.fr>, <agross@kernel.org>,
        <bjorn.andersson@linaro.org>, <heiko@sntech.de>,
        <krzysztof.kozlowski@linaro.org>, <andi@etezian.org>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>,
        <masahisa.kojima@linaro.org>, <jaswinder.singh@linaro.org>,
        <rostedt@goodmis.org>, <mingo@redhat.com>,
        <l.stelmach@samsung.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <alex.aring@gmail.com>, <stefan@datenfreihafen.org>,
        <kvalo@kernel.org>, <james.schulman@cirrus.com>,
        <david.rhodes@cirrus.com>, <tanureal@opensource.cirrus.com>,
        <rf@opensource.cirrus.com>, <perex@perex.cz>, <tiwai@suse.com>,
        <npiggin@gmail.com>, <christophe.leroy@csgroup.eu>,
        <mpe@ellerman.id.au>, <oss@buserror.net>, <windhl@126.com>,
        <yangyingliang@huawei.com>, <william.zhang@broadcom.com>,
        <kursad.oney@broadcom.com>, <jonas.gorski@gmail.com>,
        <anand.gore@broadcom.com>, <rafal@milecki.pl>
CC:     <git@amd.com>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <joel@jms.id.au>,
        <andrew@aj.id.au>, <radu_nicolae.pirea@upb.ro>,
        <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <claudiu.beznea@microchip.com>,
        <bcm-kernel-feedback-list@broadcom.com>, <fancer.lancer@gmail.com>,
        <kernel@pengutronix.de>, <festevam@gmail.com>, <linux-imx@nxp.com>,
        <jbrunet@baylibre.com>, <martin.blumenstingl@googlemail.com>,
        <avifishman70@gmail.com>, <tmaimon77@gmail.com>,
        <tali.perry1@gmail.com>, <venture@google.com>, <yuenn@google.com>,
        <benjaminfair@google.com>, <yogeshgaur.83@gmail.com>,
        <konrad.dybcio@somainline.org>, <alim.akhtar@samsung.com>,
        <ldewangan@nvidia.com>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <michal.simek@amd.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-amlogic@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-sunxi@lists.linux.dev>, <linux-tegra@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wpan@vger.kernel.org>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <lars@metafoo.de>, <Michael.Hennerich@analog.com>,
        <linux-iio@vger.kernel.org>, <michael@walle.cc>,
        <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>,
        <alsa-devel@alsa-project.org>, <patches@opensource.cirrus.com>,
        <linuxppc-dev@lists.ozlabs.org>, <amitrkcian2002@gmail.com>,
        <amit.kumar-mahapatra@amd.com>
Subject: [PATCH V6 04/15] mtd: devices: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Fri, 10 Mar 2023 23:02:06 +0530
Message-ID: <20230310173217.3429788-5-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
References: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT116:EE_|MN0PR12MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: e8a39af0-74f8-46ad-0166-08db218dc75a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUo5uxVLV/Gkgn5tSJnXpvfgI4bFJyRIlwHXRA1t5VMN0fYyIIN7b3nkSQcayiKIttv5+dT72BT19z4z1yGHCL1hhoJzPK7DQskIewn6iGTOQecmoJe1rSGWd3Z//7JHk0nqogqaxjj3+Sl3xkASiteyKc0TZL9aZcnPHuAO5jofaqhZjr/jKbYoj3pkoUrEWzlmyaCHUJicch7fB+94cYIxZfMf6dtBPpviZn/lygCu325qZHvhPogTV/51T771gb51UvTSGJJ5ELcy83SD16XKZSqWCHWsssUFjNi62KWQeFrieN9vaRyyOPm5X0OcntCUc6c3DKkq0jG1wmRVk5wZZ0z6IVNKyc5J6IZ4xIqYrNrZx8FYXI4OseC70k0azP7AAYNMXd5xO9xX2PxnMfYN+iLTJFh7FkicG993tzvCEPQE86Y75Ph3dlPowyexKVlZ66CMYy47qJNmF7CBZaA67Ose4APLnR8+lu9A/g7TsQl0I0wXhmaOKLlcFa4P0/kLzw5ji9sC+t2t7CY8q55P7jQumx6B6/Tj9UOgU/kGXKCMLsWhIGnXae5F3DVvQf3DZJlzHdBKC3JL5kCK5y2mLUr8x/3viLPc8fbMp3nUwIm3VL+/18bAzJ6cfnz1/OmwrfpRdI//5c0UdLcR/5We9eBO3TGU7jZUBKnoT7uO/K70t4BwmorP5fPKPAosAFh3GOnDxlr+c4AtitrxeaI7ABkARABvA4ImB+xym5WFMu0dxp5avkmgqsX7+oaceC/b/04OCPn/6ZNJYButBfwGSOWvCZRGJxSFIYjrEXr+2VfKOiwhDsRfnyTNppSyUBJ097nlNlTBihEkFrHvhrJXjNYmyvyOZNW1RKkXer8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199018)(46966006)(36840700001)(40470700004)(336012)(47076005)(426003)(921005)(110136005)(186003)(40460700003)(36756003)(54906003)(81166007)(40480700001)(356005)(86362001)(36860700001)(1076003)(26005)(83380400001)(82310400005)(82740400003)(6666004)(7416002)(2616005)(1191002)(8936002)(2906002)(7276002)(5660300002)(316002)(7336002)(478600001)(70206006)(7366002)(7406005)(4326008)(41300700001)(8676002)(70586007)(36900700001)(83996005)(2101003)(41080700001)(84006005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:35:02.0320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a39af0-74f8-46ad-0166-08db218dc75a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5978
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting multi-cs in spi drivers would require the chip_select & cs_gpiod
members of struct spi_device to be an array. But changing the type of these
members to array would break the spi driver functionality. To make the
transition smoother introduced four new APIs to get/set the
spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
spi->cs_gpiod references with get or set API calls.
While adding multi-cs support in further patches the chip_select & cs_gpiod
members of the spi_device structure would be converted to arrays & the
"idx" parameter of the APIs would be used as array index i.e.,
spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Reviewed-by: Michal Simek <michal.simek@amd.com>
---
 drivers/mtd/devices/mtd_dataflash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 3bbaa590c768..1d3b2a94581f 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -639,7 +639,7 @@ static int add_dataflash_otp(struct spi_device *spi, char *name, int nr_pages,
 
 	/* name must be usable with cmdlinepart */
 	sprintf(priv->name, "spi%d.%d-%s",
-			spi->master->bus_num, spi->chip_select,
+			spi->master->bus_num, spi_get_chipselect(spi, 0),
 			name);
 
 	device = &priv->mtd;
-- 
2.25.1

