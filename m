Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D26926E0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbjBJTky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbjBJTkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:40:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20626.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::626])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ABE7E8E6;
        Fri, 10 Feb 2023 11:40:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YMlWfvImcIGA2kbuo1qXAZXn/u8QL3KjvC7kYjUUhmwIhcDxd5aYBOIGH2Hp+mx3G98SyLYQM5EdNJbbkk2R57wel/wDP5yaug9BklqnRLtXJjCwEa3ed3X0vGxnhFo+hlqgrzqyAUAnGdVCrEhdZyblVE4IQdqxsJYLDVMIAtIQoN94lmIA8bWzJQGBYZZ1HsG4MGOL8H7Jl3PdbmZ4Ibksw1BrrxAMdKvymdgoBm4U5ucIRV6Ys0U7xK4Ovum/M86OxAPTrQxe1IOWRDk5VL5wggcGiea4GyZ/bltSZQNA5svVxtw7ZFJccTEATz2ptxzrgLPMotng/LCzO3XZ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JrN+S0no9tJJWOPy0MesAGh9gOiwa6v7pOuBcPHrftY=;
 b=G4F4fCBPFC37XTdRQO4nGmxF+YQxSLhO+wmqn0cJz4v2pTw2not7Ui+xOZvWexOsx6RmZM5Qa8XD7zOLwBv7mhe3eoU8EHUQdw1S+qPqIwFVHa83a4oyYVmwFr99sXJSGwCmbQZCK+eX+Ds7GPhBD8W4Imp0OmAO9KNP0/cMWE07ph2dZLu8hSJ42kclZxhTXCueZM7CF3qNKs6UN8XUnuQaRIAtLAe2L+XYLqj1pYDjpdiwADjNsaAWr1ALV5MvEJGR/HgDeJsmvBmiRHjb8cdwRgvUmQALyRWmDuzhsnBJPp9A7AabkaCb3UkihCiKigePrir8L95JbauwIWn6tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JrN+S0no9tJJWOPy0MesAGh9gOiwa6v7pOuBcPHrftY=;
 b=YJlsLKb7eGG7oSEd4K2q5Cf7eDlW1wCkYKb304Vh+GE/ksg+Up9ezoZNlfKYFKYkbPpwCDRN8ClwympNYPwBv1HfteTJyNT67t7RgTeC/NJD/kZyFU9eqbrTqhLU4ZvKsP8G0BAWBeG5+ow3xqsYI81YPYkNMEqcQXp8UCXTcqM=
Received: from MW4PR04CA0346.namprd04.prod.outlook.com (2603:10b6:303:8a::21)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 19:39:31 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8a:cafe::56) by MW4PR04CA0346.outlook.office365.com
 (2603:10b6:303:8a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Fri, 10 Feb 2023 19:39:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.21 via Frontend Transport; Fri, 10 Feb 2023 19:39:30 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 13:39:29 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 11:39:29 -0800
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Feb 2023 13:39:03 -0600
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
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v4 05/15] staging: Replace all spi->chip_select and spi->cs_gpiod references with function call
Date:   Sat, 11 Feb 2023 01:06:36 +0530
Message-ID: <20230210193647.4159467-6-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
References: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT015:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: 722dab13-7337-458a-f83b-08db0b9e8782
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFFwgZ014xQUf2nEmJ0W7s76ApWpw3rm7FHvNt5oSFt0D4ZWWDPd50+zlPrtuyC7/r0NFNI1qbH0oviTdUxW8/4DymRJo+bDz2PXeEYtz02ujmrtM+wBZgpWFpsGhBAHmdCWYJi2S20MH2Liw1IRY7Vd5Ps7FyC1dhe8dkQz43MdhdLQ+B/Crka4G17kc6VPWqmItE0PnJ5qaBue8VZQ86R76q28ttKx3iweZkCjNhhU0l/GiFJjQxEZOErE4NZpOm6CvBW6gW3MsXxxJMNn1kaJokSbb/P2IBgI1vgOfVGAvbuLCFXS2HpdcykBzQf9nJ4O+SXqUVw6ZtTdHYXPezRIufz4zYlV/bbKI+8MtCU3PbkN0FvooGubqxjcBq5hKWfM3HUq7woXHhfVwkrbbZS74k5NAu9tfSmlSc85EWXbBCVGo0SGQ8Lx7n9i+x+1jelvulYW799XHTrAMwz24HkOXi3+9pf3MtUoSfJdxl11QSMBhL0WkYgMMWBPiSSf1z7jo/jBjrgIDF0L5gzfRQ9TnjYg17Iw+jDk6a1pMdNAWpt6kGg6Vx84xmnGpYSQvGpYX0hQbdl+YGFZ+dIKb14YdVTtExV1/mDU7EkOM0hyMEDJ8IUwMDH/j3gpr57raR6cjIusjN3oAfb079oAlC0jOQboJzpXsuKlt19eqz5AQxMPb2wODM7LjFYUts8+lDjny1cYUsRxIbRG7kqwX8vx/vrBM/dQn7g719vM2g7WW8CHGdjZPQoI/Ck6LfZHhh77P6hzceLSnZx4C35hIFVVrFWTg/hX0ck0NEibYTNFzYhqFpHIjfuC7KF2svOhCzC266QJjFbuemh6Paf38pNImyeRt5KWoTagootS6eI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(7416002)(7406005)(8936002)(7276002)(7336002)(7366002)(2906002)(2616005)(426003)(336012)(186003)(83380400001)(40460700003)(47076005)(1191002)(478600001)(316002)(54906003)(8676002)(4326008)(70206006)(70586007)(26005)(40480700001)(1076003)(6666004)(110136005)(41300700001)(5660300002)(921005)(82740400003)(36756003)(356005)(86362001)(82310400005)(36860700001)(81166007)(41080700001)(36900700001)(84006005)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 19:39:30.6802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 722dab13-7337-458a-f83b-08db0b9e8782
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
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
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Michal Simek <michal.simek@amd.com>
---
 drivers/staging/fbtft/fbtft-core.c | 2 +-
 drivers/staging/greybus/spilib.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fbtft/fbtft-core.c b/drivers/staging/fbtft/fbtft-core.c
index afaba94d1d1c..3a4abf3bae40 100644
--- a/drivers/staging/fbtft/fbtft-core.c
+++ b/drivers/staging/fbtft/fbtft-core.c
@@ -840,7 +840,7 @@ int fbtft_register_framebuffer(struct fb_info *fb_info)
 		sprintf(text1, ", %zu KiB buffer memory", par->txbuf.len >> 10);
 	if (spi)
 		sprintf(text2, ", spi%d.%d at %d MHz", spi->master->bus_num,
-			spi->chip_select, spi->max_speed_hz / 1000000);
+			spi_get_chipselect(spi, 0), spi->max_speed_hz / 1000000);
 	dev_info(fb_info->dev,
 		 "%s frame buffer, %dx%d, %d KiB video memory%s, fps=%lu%s\n",
 		 fb_info->fix.id, fb_info->var.xres, fb_info->var.yres,
diff --git a/drivers/staging/greybus/spilib.c b/drivers/staging/greybus/spilib.c
index ad0700a0bb81..efb3bec58e15 100644
--- a/drivers/staging/greybus/spilib.c
+++ b/drivers/staging/greybus/spilib.c
@@ -237,7 +237,7 @@ static struct gb_operation *gb_spi_operation_create(struct gb_spilib *spi,
 	request = operation->request->payload;
 	request->count = cpu_to_le16(count);
 	request->mode = dev->mode;
-	request->chip_select = dev->chip_select;
+	request->chip_select = spi_get_chipselect(dev, 0);
 
 	gb_xfer = &request->transfers[0];
 	tx_data = gb_xfer + count;	/* place tx data after last gb_xfer */
-- 
2.25.1

