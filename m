Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96888688233
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjBBP3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjBBP2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:28:51 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6A768AF2;
        Thu,  2 Feb 2023 07:28:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvIRJPDGDyaJMGt/aImKtuH+jih0G6SxzXTWqZ/s8p0xYMYWYJbQH+pcmAyDFnE0DE3Exn1Q8NerKb4ftn4bf0zCgAZosz7aQMEbl7vBGmgrSfyMTnLZR7gfryNUTQmqKdgoFVIAmLrU80vZCDe3D3ao94ueiFUia37C1MOKRJWc/xa3kgUgmHArgm2yFHTLz8srEkBHBz/wuPlDZV0zLoMpZ6nEnSYKKShiTAVNsszppsuAQblqYyC1MA94OBH/S2R5PwL506ZXeOXKCTd4XPlh/O870wXfyS70LDVapIF+tej9ASINNGaHHHZojckF0gGyiV9kIUazHvpfo3YENw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgO4Y1hQP6qJn0ylulPlZiAg4zwkUsqUf66sHia2XoM=;
 b=SHqwLJinHa/UvT2SxjfaIKmkQWZUxWi7IjSyHgG64nwceXOP4s8ws4J9cp2Y0jnXBXcAaph2sAEtp4TVSmNLpztQj/8PkR1OKwVSM+9zaxPNbzRWwpOJPZhVTxArI7LFGiZC1VqO62GefOl3Mqv/Ql4vPr15kOhBDyp/a7J0Tb7GHoEfY0J/jcmWl2zYu/lcqbSmYJ6ThnPIMrHUGtoUn/MXbAZMHQKLsRsyBd2oUB04n5dH8KVkqWz1HKJ6b65/3+QW29jKCdZLKrZEL+iH+lTMl+tKOostrglNx9riPp7yArrx0bCZ7w1LyIm5ttzpu5LvDMoXGdtGfcvlndypbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgO4Y1hQP6qJn0ylulPlZiAg4zwkUsqUf66sHia2XoM=;
 b=xHnH7xmXKhj/qcmqwxQOPbeApls1ySrjzCpXIvCdOQ0d+EfZ3SlP7HvTdIrUB0eVYna+aaoH039HZ9I3ZIaZF/WWSIpTwmhfpRU3HHUM8u7COwQamtKT/lPcAAOU1EiW6/VhKzJW7Xbttm5AmelDSFwoMoGr4ZzRpZq61QkL50A=
Received: from DM6PR06CA0016.namprd06.prod.outlook.com (2603:10b6:5:120::29)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 15:27:20 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::bf) by DM6PR06CA0016.outlook.office365.com
 (2603:10b6:5:120::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 15:27:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.28 via Frontend Transport; Thu, 2 Feb 2023 15:27:20 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:27:18 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:27:18 -0600
Received: from xhdsgoud40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 2 Feb 2023 09:26:55 -0600
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
        <kvalo@kernel.org>
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
        <amitrkcian2002@gmail.com>,
        "Amit Kumar Mahapatra" <amit.kumar-mahapatra@amd.com>
Subject: [PATCH v3 10/13] mtd: spi-nor: Add stacked memories support in spi-nor
Date:   Thu, 2 Feb 2023 20:52:55 +0530
Message-ID: <20230202152258.512973-11-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
References: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT048:EE_|DM4PR12MB5311:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e7cf23-09c7-4fe5-17aa-08db0531f9a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z5AK6wdJSBJt27NPedjzcM2hduvrYRUQusL7hjtoc9wnhrQucYeHE8o5qzMpSBlCLe1TSQiNjwZQAgJ38Oi53Dx1uB5Hby9kL/qmo7noIfyqDHSL+QzwCdKD6ihJPdya9iTM4Y2P914ksmdcCjhpJu60oHOPetS18xMz6CC6xjDXBnACLhPhO53BAmP9oFP4bLXJB2hH68FGQEU7TudOdk6yVvHtrhk0kVjGMWK7qmuzcOaEVO2guSU8Zg7lt07kRCnZBcge4fmDWhvofDUw7WHr3fDJ1IIwjLGL7dIXQ/a5gUUrGaHT+tuX04bvtleh7ZlF7XrmTDEMp81ihXWKIOL3aJzBQJtBVeuRpsGGCY9NbYaGi4HREgE+AyKLdEYFe2HDYQ43wgiBJEB3ziTKktnt0FgdXRt12F4b8a/922rU2RO5GEVyXqb81Q6z/QBki3QZvmuShYbph4IygInOHEMoNA6eSa8EJs3WqiXP47j2xYFNv2gSVj0pIljtkIVfVrGoKMTyEUp7Lf1iBc5TrAPZ7XqRpz/zyYloVCLRgupqJ3e4AT95XVGVI4b5iSC7C7nTAq6ZQ24N0dymrw7jBfwniuMd166RqdsBrAgsX3dARZ7zpy0mOtoRJydozrdEFeu7fNOh/8X9Ip8MvXiNKFLz5G2/WSS0LCFoXh/I3IC+SpWu28jr1d7eNe8oLf7kkf0toCsjFk2VyPB06FQABdiYYsHaVYXOU2INd2ZJtUkQdJ6JIKMiKz1C5Q/tNDjMOpsu9cZ/dBKMeyQKVJmSqPDnUjH8C392fE4XuLU++0rlU3mxoBa6KIgCxPMafZTpVhgWhLR0x8gqRILH+ibQzg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199018)(36840700001)(40470700004)(46966006)(70206006)(478600001)(86362001)(8936002)(4326008)(41300700001)(47076005)(8676002)(36860700001)(70586007)(83380400001)(336012)(426003)(2906002)(26005)(186003)(356005)(82740400003)(921005)(81166007)(7406005)(7276002)(7366002)(7416002)(7336002)(5660300002)(30864003)(40460700003)(36756003)(1076003)(40480700001)(2616005)(54906003)(110136005)(82310400005)(316002)(83996005)(2101003)(41080700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:27:20.1508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e7cf23-09c7-4fe5-17aa-08db0531f9a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each flash that is connected in stacked mode should have a separate
parameter structure. So, the flash parameter member(*params) of the spi_nor
structure is changed to an array (*params[2]). The array is used to store
the parameters of each flash connected in stacked configuration.

The current implementation assumes that a maximum of two flashes are
connected in stacked mode and both the flashes are of same make but can
differ in sizes. So, except the sizes all other flash parameters of both
the flashes are identical.

SPI-NOR is not aware of the chip_select values, for any incoming request
SPI-NOR will decide the flash index with the help of individual flash size
and the configuration type (single/stacked). SPI-NOR will pass on the flash
index information to the SPI core & SPI driver by setting the appropriate
bit in nor->spimem->spi->cs_index_mask. For example, if nth bit of
nor->spimem->spi->cs_index_mask is set then the driver would
assert/de-assert spi->chip_slect[n].

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/mtd/spi-nor/core.c  | 282 +++++++++++++++++++++++++++++-------
 drivers/mtd/spi-nor/core.h  |   4 +
 include/linux/mtd/spi-nor.h |  12 +-
 3 files changed, 244 insertions(+), 54 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 8a4a54bf2d0e..bb7326dc8b70 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1441,13 +1441,18 @@ static int spi_nor_erase_multi_sectors(struct spi_nor *nor, u64 addr, u32 len)
 static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	u32 addr, len;
+	struct spi_nor_flash_parameter *params;
+	u32 addr, len, offset, cur_cs_num = 0;
 	uint32_t rem;
 	int ret;
+	u64 sz;
 
 	dev_dbg(nor->dev, "at 0x%llx, len %lld\n", (long long)instr->addr,
 			(long long)instr->len);
 
+	params = spi_nor_get_params(nor, 0);
+	sz = params->size;
+
 	if (spi_nor_has_uniform_erase(nor)) {
 		div_u64_rem(instr->len, mtd->erasesize, &rem);
 		if (rem)
@@ -1465,26 +1470,30 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 	if (len == mtd->size && !(nor->flags & SNOR_F_NO_OP_CHIP_ERASE)) {
 		unsigned long timeout;
 
-		ret = spi_nor_write_enable(nor);
-		if (ret)
-			goto erase_err;
+		while (cur_cs_num < SNOR_FLASH_CNT_MAX && params) {
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+			ret = spi_nor_write_enable(nor);
+			if (ret)
+				goto erase_err;
 
-		ret = spi_nor_erase_chip(nor);
-		if (ret)
-			goto erase_err;
+			ret = spi_nor_erase_chip(nor);
+			if (ret)
+				goto erase_err;
 
-		/*
-		 * Scale the timeout linearly with the size of the flash, with
-		 * a minimum calibrated to an old 2MB flash. We could try to
-		 * pull these from CFI/SFDP, but these values should be good
-		 * enough for now.
-		 */
-		timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
-			      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
-			      (unsigned long)(mtd->size / SZ_2M));
-		ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
-		if (ret)
-			goto erase_err;
+			/*
+			 * Scale the timeout linearly with the size of the flash, with
+			 * a minimum calibrated to an old 2MB flash. We could try to
+			 * pull these from CFI/SFDP, but these values should be good
+			 * enough for now.
+			 */
+			timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
+				      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
+				      (unsigned long)(params->size / SZ_2M));
+			ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
+			if (ret)
+				goto erase_err;
+			cur_cs_num++;
+		}
 
 	/* REVISIT in some cases we could speed up erasing large regions
 	 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
@@ -1493,12 +1502,26 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 
 	/* "sector"-at-a-time erase */
 	} else if (spi_nor_has_uniform_erase(nor)) {
+		/* Determine the flash from which the operation need to start */
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (addr > sz - 1) && params) {
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
+
 		while (len) {
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
 			ret = spi_nor_write_enable(nor);
 			if (ret)
 				goto erase_err;
 
-			ret = spi_nor_erase_sector(nor, addr);
+			offset = addr;
+			if (nor->flags & SNOR_F_HAS_STACKED) {
+				params = spi_nor_get_params(nor, cur_cs_num);
+				offset -= (sz - params->size);
+			}
+
+			ret = spi_nor_erase_sector(nor, offset);
 			if (ret)
 				goto erase_err;
 
@@ -1508,13 +1531,45 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 
 			addr += mtd->erasesize;
 			len -= mtd->erasesize;
+
+			/*
+			 * Flash cross over condition in stacked mode.
+			 */
+			if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1)) {
+				cur_cs_num++;
+				params = spi_nor_get_params(nor, cur_cs_num);
+				sz += params->size;
+			}
 		}
 
 	/* erase multiple sectors */
 	} else {
-		ret = spi_nor_erase_multi_sectors(nor, addr, len);
-		if (ret)
-			goto erase_err;
+		u64 erase_len = 0;
+
+		/* Determine the flash from which the operation need to start */
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (addr > sz - 1) && params) {
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
+		/* perform multi sector erase onec per Flash*/
+		while (len) {
+			erase_len = (len > (sz - addr)) ? (sz - addr) : len;
+			offset = addr;
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+			if (nor->flags & SNOR_F_HAS_STACKED) {
+				params = spi_nor_get_params(nor, cur_cs_num);
+				offset -= (sz - params->size);
+			}
+			ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
+			if (ret)
+				goto erase_err;
+			len -= erase_len;
+			addr += erase_len;
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
 	}
 
 	ret = spi_nor_write_disable(nor);
@@ -1713,7 +1768,10 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t *retlen, u_char *buf)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	ssize_t ret;
+	struct spi_nor_flash_parameter *params;
+	ssize_t ret, read_len;
+	u32 cur_cs_num = 0;
+	u64 sz;
 
 	dev_dbg(nor->dev, "from 0x%08x, len %zd\n", (u32)from, len);
 
@@ -1721,9 +1779,23 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 	if (ret)
 		return ret;
 
+	params = spi_nor_get_params(nor, 0);
+	sz = params->size;
+
+	/* Determine the flash from which the operation need to start */
+	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) && params) {
+		cur_cs_num++;
+		params = spi_nor_get_params(nor, cur_cs_num);
+		sz += params->size;
+	}
 	while (len) {
 		loff_t addr = from;
 
+		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+		read_len = (len > (sz - addr)) ? (sz - addr) : len;
+		params = spi_nor_get_params(nor, cur_cs_num);
+		addr -= (sz - params->size);
+
 		addr = spi_nor_convert_addr(nor, addr);
 
 		ret = spi_nor_read_data(nor, addr, len, buf);
@@ -1735,11 +1807,22 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 		if (ret < 0)
 			goto read_err;
 
-		WARN_ON(ret > len);
+		WARN_ON(ret > read_len);
 		*retlen += ret;
 		buf += ret;
 		from += ret;
 		len -= ret;
+
+		/*
+		 * Flash cross over condition in stacked mode.
+		 *
+		 */
+		if ((nor->flags & SNOR_F_HAS_STACKED) && (from > sz - 1)) {
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
+
 	}
 	ret = 0;
 
@@ -1759,13 +1842,22 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
 	struct spi_nor_flash_parameter *params;
 	size_t page_offset, page_remain, i;
+	u32 page_size, cur_cs_num = 0;
 	ssize_t ret;
-	u32 page_size;
+	u64 sz;
 
 	dev_dbg(nor->dev, "to 0x%08x, len %zd\n", (u32)to, len);
 
 	params = spi_nor_get_params(nor, 0);
 	page_size = params->page_size;
+	sz = params->size;
+
+	/* Determine the flash from which the operation need to start */
+	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) && params) {
+		cur_cs_num++;
+		params = spi_nor_get_params(nor, cur_cs_num);
+		sz += params->size;
+	}
 
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
@@ -1790,6 +1882,10 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* the size of data remaining on the first page */
 		page_remain = min_t(size_t, page_size - page_offset, len - i);
 
+		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+		params = spi_nor_get_params(nor, cur_cs_num);
+		addr -= (sz - params->size);
+
 		addr = spi_nor_convert_addr(nor, addr);
 
 		ret = spi_nor_write_enable(nor);
@@ -1806,6 +1902,15 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 			goto write_err;
 		*retlen += written;
 		i += written;
+
+		/*
+		 * Flash cross over condition in stacked mode.
+		 */
+		if ((nor->flags & SNOR_F_HAS_STACKED) && ((to + i) > sz - 1)) {
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
 	}
 
 write_err:
@@ -1918,8 +2023,6 @@ int spi_nor_hwcaps_pp2cmd(u32 hwcaps)
 static int spi_nor_spimem_check_op(struct spi_nor *nor,
 				   struct spi_mem_op *op)
 {
-	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
-
 	/*
 	 * First test with 4 address bytes. The opcode itself might
 	 * be a 3B addressing opcode but we don't care, because
@@ -1928,7 +2031,7 @@ static int spi_nor_spimem_check_op(struct spi_nor *nor,
 	 */
 	op->addr.nbytes = 4;
 	if (!spi_mem_supports_op(nor->spimem, op)) {
-		if (params->size > SZ_16M)
+		if (nor->mtd.size > SZ_16M)
 			return -EOPNOTSUPP;
 
 		/* If flash size <= 16MB, 3 address bytes are sufficient */
@@ -2516,6 +2619,10 @@ static void spi_nor_init_fixup_flags(struct spi_nor *nor)
 static void spi_nor_late_init_params(struct spi_nor *nor)
 {
 	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	struct device_node *np = spi_nor_get_flash_node(nor);
+	u64 flash_size[SNOR_FLASH_CNT_MAX];
+	u32 idx = 0, i = 0;
+	int rc;
 
 	if (nor->manufacturer && nor->manufacturer->fixups &&
 	    nor->manufacturer->fixups->late_init)
@@ -2533,6 +2640,36 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
 	 */
 	if (nor->flags & SNOR_F_HAS_LOCK && !params->locking_ops)
 		spi_nor_init_default_locking_ops(nor);
+	/*
+	 * The flashes that are connected in stacked mode should be of same make.
+	 * Except the flash size all other properties are identical for all the
+	 * flashes connected in stacked mode.
+	 * The flashes that are connected in parallel mode should be identical.
+	 */
+	while (i < SNOR_FLASH_CNT_MAX) {
+		rc = of_property_read_u64_index(np, "stacked-memories", idx, &flash_size[i]);
+		if (rc == -EINVAL) {
+			break;
+		} else if (rc == -EOVERFLOW) {
+			idx++;
+		} else {
+			idx++;
+			i++;
+			if (!(nor->flags & SNOR_F_HAS_STACKED))
+				nor->flags |= SNOR_F_HAS_STACKED;
+		}
+	}
+	if (nor->flags & SNOR_F_HAS_STACKED) {
+		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			params = spi_nor_get_params(nor, idx);
+			params = devm_kzalloc(nor->dev, sizeof(*params), GFP_KERNEL);
+			if (params) {
+				memcpy(params, spi_nor_get_params(nor, 0), sizeof(*params));
+				params->size = flash_size[idx];
+				spi_nor_set_params(nor, idx, params);
+			}
+		}
+	}
 }
 
 /**
@@ -2741,22 +2878,36 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
  */
 static int spi_nor_quad_enable(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	struct spi_nor_flash_parameter *params;
+	int err, idx;
 
-	if (!params->quad_enable)
-		return 0;
+	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+		params = spi_nor_get_params(nor, idx);
+		if (params) {
+			if (!params->quad_enable)
+				return 0;
 
-	if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
-	      spi_nor_get_protocol_width(nor->write_proto) == 4))
-		return 0;
+			if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
+			      spi_nor_get_protocol_width(nor->write_proto) == 4))
+				return 0;
+			/*
+			 * Set the appropriate CS index before
+			 * issuing the command.
+			 */
+			nor->spimem->spi->cs_index_mask = 0x01 << idx;
 
-	return params->quad_enable(nor);
+			err = params->quad_enable(nor);
+			if (err)
+				return err;
+		}
+	}
+	return err;
 }
 
 static int spi_nor_init(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
-	int err;
+	struct spi_nor_flash_parameter *params;
+	int err, idx;
 
 	err = spi_nor_octal_dtr_enable(nor, true);
 	if (err) {
@@ -2797,9 +2948,19 @@ static int spi_nor_init(struct spi_nor *nor)
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		err = params->set_4byte_addr_mode(nor, true);
-		if (err && err != -ENOTSUPP)
-			return err;
+		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			params = spi_nor_get_params(nor, idx);
+			if (params) {
+				/*
+				 * Select the appropriate CS index before
+				 * issuing the command.
+				 */
+				nor->spimem->spi->cs_index_mask = 0x01 << idx;
+				err = params->set_4byte_addr_mode(nor, true);
+				if (err && err != -ENOTSUPP)
+					return err;
+			}
+		}
 	}
 
 	return 0;
@@ -2915,19 +3076,31 @@ void spi_nor_restore(struct spi_nor *nor)
 {
 	struct spi_nor_flash_parameter *params;
 	int ret;
+	int idx;
 
 	/* restore the addressing mode */
 	if (nor->addr_nbytes == 4 && !(nor->flags & SNOR_F_4B_OPCODES) &&
 	    nor->flags & SNOR_F_BROKEN_RESET) {
-		params = spi_nor_get_params(nor, 0);
-		ret = params->set_4byte_addr_mode(nor, false);
-		if (ret)
-			/*
-			 * Do not stop the execution in the hope that the flash
-			 * will default to the 3-byte address mode after the
-			 * software reset.
-			 */
-			dev_err(nor->dev, "Failed to exit 4-byte address mode, err = %d\n", ret);
+		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			params = spi_nor_get_params(nor, idx);
+			if (params) {
+				/*
+				 * Select the appropriate CS index before
+				 * issuing the command.
+				 */
+				nor->spimem->spi->cs_index_mask = 0x01 << idx;
+				ret = params->set_4byte_addr_mode(nor, false);
+				if (ret)
+					/*
+					 * Do not stop the execution in the hope that the flash
+					 * will default to the 3-byte address mode after the
+					 * software reset.
+					 */
+					dev_err(nor->dev,
+						"Failed to exit 4-byte address mode, err = %d\n",
+						ret);
+			}
+		}
 	}
 
 	if (nor->flags & SNOR_F_SOFT_RESET)
@@ -2995,6 +3168,8 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct mtd_info *mtd = &nor->mtd;
 	struct device *dev = nor->dev;
+	u64 total_sz = 0;
+	int idx;
 
 	spi_nor_set_mtd_locking_ops(nor);
 	spi_nor_set_mtd_otp_ops(nor);
@@ -3010,7 +3185,12 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 		mtd->_erase = spi_nor_erase;
 	mtd->writesize = params->writesize;
 	mtd->writebufsize = params->page_size;
-	mtd->size = params->size;
+	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+		params = spi_nor_get_params(nor, idx);
+		if (params)
+			total_sz += params->size;
+	}
+	mtd->size = total_sz;
 	mtd->_read = spi_nor_read;
 	/* Might be already set by some SST flashes. */
 	if (!mtd->_write)
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index f03b55cf7e6f..e94107cc465e 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -11,6 +11,9 @@
 
 #define SPI_NOR_MAX_ID_LEN	6
 
+/* In single configuration enable CS0 */
+#define SPI_NOR_ENABLE_CS0     BIT(0)
+
 /* Standard SPI NOR flash operations. */
 #define SPI_NOR_READID_OP(naddr, ndummy, buf, len)			\
 	SPI_MEM_OP(SPI_MEM_OP_CMD(SPINOR_OP_RDID, 0),			\
@@ -130,6 +133,7 @@ enum spi_nor_option_flags {
 	SNOR_F_IO_MODE_EN_VOLATILE = BIT(11),
 	SNOR_F_SOFT_RESET	= BIT(12),
 	SNOR_F_SWP_IS_VOLATILE	= BIT(13),
+	SNOR_F_HAS_STACKED      = BIT(14),
 };
 
 struct spi_nor_read_command {
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 728674ea3c22..79be5d50a509 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -128,6 +128,12 @@
 #define SR2_LB3			BIT(5)	/* Security Register Lock Bit 3 */
 #define SR2_QUAD_EN_BIT7	BIT(7)
 
+/*
+ * Maximum number of flashes that can be connected
+ * in stacked/parallel configuration
+ */
+#define	SNOR_FLASH_CNT_MAX	2
+
 /* Supported SPI protocols */
 #define SNOR_PROTO_INST_MASK	GENMASK(23, 16)
 #define SNOR_PROTO_INST_SHIFT	16
@@ -400,7 +406,7 @@ struct spi_nor {
 
 	const struct spi_nor_controller_ops *controller_ops;
 
-	struct spi_nor_flash_parameter *params;
+	struct spi_nor_flash_parameter *params[SNOR_FLASH_CNT_MAX];
 
 	struct {
 		struct spi_mem_dirmap_desc *rdesc;
@@ -423,13 +429,13 @@ static inline struct device_node *spi_nor_get_flash_node(struct spi_nor *nor)
 
 static inline struct spi_nor_flash_parameter *spi_nor_get_params(const struct spi_nor *nor, u8 idx)
 {
-	return nor->params;
+	return nor->params[idx];
 }
 
 static inline void spi_nor_set_params(struct spi_nor *nor, u8 idx,
 				      struct spi_nor_flash_parameter *params)
 {
-	nor->params = params;
+	nor->params[idx] = params;
 }
 /**
  * spi_nor_scan() - scan the SPI NOR
-- 
2.25.1

