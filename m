Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E08B6926D7
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbjBJTke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233468AbjBJTkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:40:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B451E1E4;
        Fri, 10 Feb 2023 11:39:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEM0GqYxPEEgYGpyY8wE9n2pGwS4za05rK6zd3C1Y1xVDhOZ1ulJsrmo/eGsLEM6ycGYmywUtw0nuOf1odnSOSUFH5lbGxlQj8+ERiUhPPuwY3zVrejo4R9bzBQOtTliHqTJnfXKt1zBhOBffWvb4D0w/zYdzqIRfRrKVG7Hcivws3JbG0nNrHIss60iRqi0iokyAeRiB1lI28V2KXPMKhpPvANL2CPNpeZDo1fzJUez+l0q1+vT75ygj3zSGEW7Ri2xFQzHLWwGxUXBOuZSrYowuBj7p6SeIKYALdz3KpzIKlSFYcYYmtkS1nEcamdb4BIEu3mEhBf8vh5f6Lr0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/Yet+5rsiDfnRUIoBGZ5uihYT2ozvs6P0wK1Jad2Yk=;
 b=m8sgUV+rF+aTC0MMxdTelf9tJ44xpydla7AwnmBsIXLXrgqR9ybjXGrHvHrGPEGY3lTaRcifYQxGKlrBW+sBEs/mB21bR9QziZaVfBwBNyMYPBBNgFlT52q12RZe8bBP9D1oR45i9EXdlVmHZK+hWtjl56Ga3e8Dq0zvzkUgzK6gn8o2xTozUEQql2P2LislzmkniOPrFW2XLer5n/CgoPQCNknQpeaJyJrTNGFe3Ai2wexDJ0qnCxMNiZJG6Sk/fqs+yA8RwKk69doNy5NN6PsznbJTkd8lVFtexuvdHHl+MrII7ERHTFg/V22kAdb+Z1dr0rzDfWJGUaQfSE9SPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/Yet+5rsiDfnRUIoBGZ5uihYT2ozvs6P0wK1Jad2Yk=;
 b=oiBk0psCAuZiF0ORJT/9xVFgqadWZX3vxS0aco+PEqQ+zvipVJjLvrZvNXn+dtFemX/PhKfUsgfw94bORpMZaP0aqWftN0kfxGWbFepjTy/ReWYBAbZ5Ffu06efbGrwh+JnglnHuOVyEHwwptmNebQxEalc94/2s/N27RAOBXvY=
Received: from MN2PR01CA0045.prod.exchangelabs.com (2603:10b6:208:23f::14) by
 DM4PR12MB5055.namprd12.prod.outlook.com (2603:10b6:5:39a::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21; Fri, 10 Feb 2023 19:39:03 +0000
Received: from BL02EPF000108EB.namprd05.prod.outlook.com
 (2603:10b6:208:23f:cafe::55) by MN2PR01CA0045.outlook.office365.com
 (2603:10b6:208:23f::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Fri, 10 Feb 2023 19:39:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EB.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Fri, 10 Feb 2023 19:39:03 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:39:02 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 13:38:36 -0600
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <miquel.raynal@bootlin.com>,
        <richard@nod.at>, <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>,
        <sanju.mehta@amd.com>, <chin-ting_kuo@aspeedtech.com>,
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
        <yangyingliang@huawei.com>
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
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Subject: [PATCH v4 04/15] mtd: devices: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Sat, 11 Feb 2023 01:06:35 +0530
Message-ID: <20230210193647.4159467-5-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
References: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EB:EE_|DM4PR12MB5055:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b4d6be9-e351-404b-144f-08db0b9e7745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7xqAle4mN/Sk3BVccIHKOd3B6kfj4us4KYxRAII9XdtcZVLnBdabFcFqfwjoDKryaP3VGRiB8EtY06AXBgWbNAYbpjfjZEkh6PExI8J+y8KFJ/ephHCCTvxZ1UWHPmLF4OI7NAZ8/0Zh/dYTXH3+x16V9Z50ncpIi7CRrAgwKFcDxpT2Zg4ArHuF21Wi7QTN7MTWS7C6eiPYg4MZ8kj1TzI86Om1zxc/jdwJZRTmGxMn0EWNigeggv0SBppx1fgClLV+zrC/Hd+mwvvrwvdn10UEVNedam0o2UrQc1SeuCgCpiqSULBmzFUvL8dA2+Ec+BYXOSSoGlcUgHB312acm0gkkW/7mx4LLmfermfgLfk4Spe7o3qs7ycvxAGDOtVXfIJ2OSxm7e2eXytUT6vw9CSJPlw8ZojkYbs/fIkWlCYgTxc9FSm0XdAXqdufNihIE2Zeigw/1DtkDuygkZhNgT3I/0KvBzl5x8onQuTxsuFaN0yaGn14Q/803UJ0BCzw1X5AlAHl2weL50TObTH3kpVc2zNhyPaTIi4dkY6O3wr5IgNZTTNdfUL2cHLq2eA3wY31KCBzjXicHSgB/NSjff0c3v4XC+CCLLeK49jIjH3YLdTvsrTKhTKJeZ533TfqKpktcPyfShikzAX7ikZWLiVTr+GIucrFiQFMhc37D35iPqv4aGUk/bHJm0tuPh4kivEvHKnMAZPnzcCILKOIkJGRrA+cMd8L+wJDdBnXYj/VWM29ZlhgpohIG+OIx59b7oUZA/3x/CbqNGt/6Z+nAAPt5V40rPl87gaUWHaRW/Eups20Q/2/vrzEjut2pw/rmZpWnssW8gpIWyiGocWK2+H2SDALdIl1pwdae5Qvafo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(46966006)(40470700004)(36840700001)(36756003)(356005)(82740400003)(86362001)(921005)(81166007)(54906003)(41300700001)(70586007)(70206006)(8936002)(4326008)(8676002)(110136005)(316002)(40480700001)(82310400005)(1191002)(7336002)(7366002)(5660300002)(7276002)(2906002)(40460700003)(47076005)(83380400001)(336012)(7406005)(426003)(36860700001)(7416002)(478600001)(2616005)(26005)(186003)(1076003)(83996005)(2101003)(84006005)(36900700001)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:39:03.5092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4d6be9-e351-404b-144f-08db0b9e7745
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5055
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 25bad4318305..34d7a0c4807b 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -646,7 +646,7 @@ static int add_dataflash_otp(struct spi_device *spi, char *name, int nr_pages,
 
 	/* name must be usable with cmdlinepart */
 	sprintf(priv->name, "spi%d.%d-%s",
-			spi->master->bus_num, spi->chip_select,
+			spi->master->bus_num, spi_get_chipselect(spi, 0),
 			name);
 
 	device = &priv->mtd;
-- 
2.25.1

