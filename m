Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D646ACA79
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCFRaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjCFRaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:30:12 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085344C04;
        Mon,  6 Mar 2023 09:29:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE+6jGtt9K/KGNtW9rCo6vHf7ZErleLB//ttOMuolNS3LLvwQ+stYDCF4nUtfp4yAaRtvmYqC4qct5WW5/X7/0W+Ala9ZXAAGkvMTzTLKxbc1vACJyxfCirIl36Ft76dnHWzTn2b93xHTt/y7AlenleF9bAXZvBhv9kxUQXdTvL2eSvvYLGIilpQkUU/jRf/bsVFmmMfurbq2gouGh+spoG/mwlh5ZD1bv3i/e+ImUeyLfY53Z48gDkR0QWUwdA1rF6esDSOkKsN6F/hskS+h66Mw0JQjYB40yHjfTKg2qXYHCTJ0itjU3fiHoKsM+G0GrErM6ttowVCBdX176uCcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjJw4Ews/fFST2W29oEA8nKlTYGBH/MUSfqfglbjQRc=;
 b=Mloa4wL5OsqbaxMR0npASGiCK5ZRXIJ8Q86Ex0ySf6ntHArQpwu2fDXHo1E1DKmhhrpBOhIXBHNQZN71UnHbLkLC/GVPFUw5WcNxqudqTHC2rSuQ8fu4CIOi+cEL5GR+vOz9P0QEOQoj4oPs2Gbbm1rw1IWJ0L0uwavGEBvd4Ex1itkVqTxZWnyEfqgJUNTBjfeS8nAYXUex8e8YVQqmzYy+ISkl6KZccNvisrclbQsUsJjYPETtSti5fQLXxQl5vRiKPQJT+7QSxQs/Iq017KMgSlk0GOQZ1yPynM841EpByU89z/npDR1KmaQSKIFJHF4t5EctGhotn0HAh+KhZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjJw4Ews/fFST2W29oEA8nKlTYGBH/MUSfqfglbjQRc=;
 b=CqmvLfpsQYAEnP0qKgXDtME3ETtBorBHCLUGomGF17OvyAbNa1GJVlBkUOFzWYBtgo6OA6f4CbM64Pic/BnMDIArxE0ciSy2wu9KqU/CtqLCO2bVjVForaYfWZyVBeOz8560C6pbQwHo4LuCA3Suqj32k3RUsnjPfIbbov/cqHo=
Received: from DM6PR18CA0009.namprd18.prod.outlook.com (2603:10b6:5:15b::22)
 by PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:29:13 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:5:15b:cafe::44) by DM6PR18CA0009.outlook.office365.com
 (2603:10b6:5:15b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 17:29:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.4 via Frontend Transport; Mon, 6 Mar 2023 17:29:12 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:29:11 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 6 Mar 2023 11:28:44 -0600
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
Subject: [PATCH V5 14/15] mtd: spi-nor: Add parallel memories support in spi-nor
Date:   Mon, 6 Mar 2023 22:51:08 +0530
Message-ID: <20230306172109.595464-15-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|PH7PR12MB5685:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f4d31e-4041-4ab3-a484-08db1e684ddd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qcZGAE+Q/a89mkr9bFVlG6WGzJd9+s7/Dvd4Iwon1jefC1Q38an94UBfE/dcrPYv5ThLk5AiTjEOzXIFuWwpr3iZO683BTIqyvgNhv/HuWucc21U22FIQ2K2i1djxE/AKncYwl3inCezmsha5QscOHJvDCReFXJRRsHNXb1Hhb2HbEemyhvWWruk1ZXWAmAMwT3BYqjt47PcqheyXqUyORVpla4ll/KjXaNzs+HpG+GXwQRNzevLkcO+c1XpH/9EeQnoWFVkLUGGDhbkFo97sRG7vXqPM2CysbEvPFDBkR4fY7S0CY7Bt1VgoQk5I2UyqS5ntXLM2vFFIZkGz8DICh6Gj5s0s9Iac7wYe98zBaA6TQKZ1Pv5VCsJsVf6GCer4hNu08rMED5f1OZ8EQdZC6g6tYR4pjPEwYtOGPedkmlqLvfDotWFNGGQkKVPfzEH27aki0xCalp4oBUwzdPz1CfrH47AXm3a+DpnEMbCeHhY8M5p+OEwg4GRhiRTenmAm/UmkHKHcGviigsoD38rUQwuggVXXin/GXAvyGnOpEzl2cpPL7obSsC9K5OnwY4k4zA9U6BzhW13vL5C3bimKTEYbusDVVqlpoh/4rExZdli1O2MAtNg+3Xj9cC77dJHg65Iy1Hi8FWnoJr1wp9exS3G9N+h5Y+GZKQzuFnwvuCODzdYdqLOfC5tcluiQYVbx/QwTRQ3sWJ4GugEv8zrhThHuomHYgH49GCVcxknzxgbMJVdytrZVW6vzIXQjOBHFv8IdBnmXbQnthFZD9RtnbYZ5x+E25G1YYA2yoDKxvEBVDhD9nXN7uhlqShwnMGYnrs+bsh3rRxfoDwSjCwh2VLvdih7AX+9Q1kKARNZkzo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(1076003)(26005)(6666004)(36756003)(36860700001)(47076005)(426003)(82310400005)(921005)(356005)(40460700003)(86362001)(81166007)(40480700001)(1191002)(82740400003)(83380400001)(186003)(2616005)(336012)(70206006)(70586007)(41300700001)(8676002)(4326008)(2906002)(30864003)(8936002)(7276002)(7336002)(7366002)(7406005)(7416002)(5660300002)(478600001)(316002)(110136005)(54906003)(2101003)(36900700001)(84006005)(83996005)(41080700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:29:12.9391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f4d31e-4041-4ab3-a484-08db1e684ddd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5685
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current implementation assumes that a maximum of two flashes are
connected in parallel mode. The QSPI controller splits the data evenly
between both the flashes so, both the flashes that are connected in
parallel mode should be identical.
During each operation SPI-NOR sets 0th bit for CS0 & 1st bit for CS1 in
nor->spimem->spi->cs_index_mask. The QSPI driver will then assert/de-assert
CS0 & CS1.
Write operation in parallel mode are performed in page size * 2 chunks as
each write operation results in writing both the flashes. For doubling the
address space each operation is performed at addr/2 flash offset, where
addr is the address specified by the user.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/mtd/spi-nor/core.c      | 514 +++++++++++++++++++++++---------
 drivers/mtd/spi-nor/core.h      |   4 +
 drivers/mtd/spi-nor/micron-st.c |   5 +
 3 files changed, 384 insertions(+), 139 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index bb7326dc8b70..367cbb36ef69 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -464,17 +464,29 @@ int spi_nor_read_sr(struct spi_nor *nor, u8 *sr)
 			op.data.nbytes = 2;
 		}
 
+		if (nor->flags & SNOR_F_HAS_PARALLEL)
+			op.data.nbytes = 2;
+
 		spi_nor_spimem_setup_op(nor, &op, nor->reg_proto);
 
 		ret = spi_mem_exec_op(nor->spimem, &op);
 	} else {
-		ret = spi_nor_controller_ops_read_reg(nor, SPINOR_OP_RDSR, sr,
-						      1);
+		if (nor->flags & SNOR_F_HAS_PARALLEL)
+			ret = spi_nor_controller_ops_read_reg(nor,
+							      SPINOR_OP_RDSR,
+							      sr, 2);
+		else
+			ret = spi_nor_controller_ops_read_reg(nor,
+							      SPINOR_OP_RDSR,
+							      sr, 1);
 	}
 
 	if (ret)
 		dev_dbg(nor->dev, "error %d reading SR\n", ret);
 
+	if (nor->flags & SNOR_F_HAS_PARALLEL)
+		sr[0] |= sr[1];
+
 	return ret;
 }
 
@@ -1466,12 +1478,122 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 	if (ret)
 		return ret;
 
-	/* whole-chip erase? */
-	if (len == mtd->size && !(nor->flags & SNOR_F_NO_OP_CHIP_ERASE)) {
-		unsigned long timeout;
+	if (!(nor->flags & SNOR_F_HAS_PARALLEL)) {
+		/* whole-chip erase? */
+		if (len == mtd->size && !(nor->flags & SNOR_F_NO_OP_CHIP_ERASE)) {
+			unsigned long timeout;
+
+			while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && params) {
+				nor->spimem->spi->cs_index_mask = 1 << cur_cs_num;
+				ret = spi_nor_write_enable(nor);
+				if (ret)
+					goto erase_err;
+
+				ret = spi_nor_erase_chip(nor);
+				if (ret)
+					goto erase_err;
+
+				/*
+				 * Scale the timeout linearly with the size of the flash, with
+				 * a minimum calibrated to an old 2MB flash. We could try to
+				 * pull these from CFI/SFDP, but these values should be good
+				 * enough for now.
+				 */
+				timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
+					      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
+					      (unsigned long)(params->size /
+							      SZ_2M));
+				ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
+				if (ret)
+					goto erase_err;
+
+				cur_cs_num++;
+				params = spi_nor_get_params(nor, cur_cs_num);
+			}
+
+		/* REVISIT in some cases we could speed up erasing large regions
+		 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
+		 * to use "small sector erase", but that's not always optimal.
+		 */
+
+		/* "sector"-at-a-time erase */
+		} else if (spi_nor_has_uniform_erase(nor)) {
+			/* Determine the flash from which the operation need to start */
+			while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
+			       (addr > sz - 1) && params) {
+				cur_cs_num++;
+				params = spi_nor_get_params(nor, cur_cs_num);
+				sz += params->size;
+			}
+			while (len) {
+				nor->spimem->spi->cs_index_mask = 1 << cur_cs_num;
+				ret = spi_nor_write_enable(nor);
+				if (ret)
+					goto erase_err;
+
+				offset = addr;
+				if (nor->flags & SNOR_F_HAS_STACKED) {
+					params = spi_nor_get_params(nor, cur_cs_num);
+					offset -= (sz - params->size);
+				}
+				ret = spi_nor_erase_sector(nor, offset);
+				if (ret)
+					goto erase_err;
+
+				ret = spi_nor_wait_till_ready(nor);
+				if (ret)
+					goto erase_err;
+
+				addr += mtd->erasesize;
+				len -= mtd->erasesize;
+
+				/*
+				 * Flash cross over condition in stacked mode.
+				 */
+				if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1)) {
+					cur_cs_num++;
+					params = spi_nor_get_params(nor, cur_cs_num);
+					sz += params->size;
+				}
+			}
+
+		/* erase multiple sectors */
+		} else {
+			u64 erase_len = 0;
+
+			/* Determine the flash from which the operation need to start */
+			while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
+			       (addr > sz - 1) && params) {
+				cur_cs_num++;
+				params = spi_nor_get_params(nor, cur_cs_num);
+				sz += params->size;
+			}
+			/* perform multi sector erase onec per Flash*/
+			while (len) {
+				erase_len = (len > (sz - addr)) ? (sz - addr) : len;
+				offset = addr;
+				nor->spimem->spi->cs_index_mask = 1 << cur_cs_num;
+				if (nor->flags & SNOR_F_HAS_STACKED) {
+					params = spi_nor_get_params(nor, cur_cs_num);
+					offset -= (sz - params->size);
+				}
+				ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
+				if (ret)
+					goto erase_err;
+				len -= erase_len;
+				addr += erase_len;
+				params = spi_nor_get_params(nor, cur_cs_num);
+				sz += params->size;
+			}
+		}
+	} else {
+		nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+
+		/* whole-chip erase? */
+		if (len == mtd->size && !(nor->flags &
+					  SNOR_F_NO_OP_CHIP_ERASE)) {
+			unsigned long timeout;
 
-		while (cur_cs_num < SNOR_FLASH_CNT_MAX && params) {
-			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
 			ret = spi_nor_write_enable(nor);
 			if (ret)
 				goto erase_err;
@@ -1488,90 +1610,45 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 			 */
 			timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
 				      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
-				      (unsigned long)(params->size / SZ_2M));
+				      (unsigned long)(mtd->size / SZ_2M));
 			ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
 			if (ret)
 				goto erase_err;
-			cur_cs_num++;
-		}
-
-	/* REVISIT in some cases we could speed up erasing large regions
-	 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
-	 * to use "small sector erase", but that's not always optimal.
-	 */
 
-	/* "sector"-at-a-time erase */
-	} else if (spi_nor_has_uniform_erase(nor)) {
-		/* Determine the flash from which the operation need to start */
-		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (addr > sz - 1) && params) {
-			cur_cs_num++;
-			params = spi_nor_get_params(nor, cur_cs_num);
-			sz += params->size;
-		}
+		/* REVISIT in some cases we could speed up erasing large regions
+		 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
+		 * to use "small sector erase", but that's not always optimal.
+		 */
 
-		while (len) {
-			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-			ret = spi_nor_write_enable(nor);
-			if (ret)
-				goto erase_err;
+		/* "sector"-at-a-time erase */
+		} else if (spi_nor_has_uniform_erase(nor)) {
+			while (len) {
+				ret = spi_nor_write_enable(nor);
+				if (ret)
+					goto erase_err;
 
-			offset = addr;
-			if (nor->flags & SNOR_F_HAS_STACKED) {
-				params = spi_nor_get_params(nor, cur_cs_num);
-				offset -= (sz - params->size);
-			}
+				offset = addr / 2;
 
-			ret = spi_nor_erase_sector(nor, offset);
-			if (ret)
-				goto erase_err;
-
-			ret = spi_nor_wait_till_ready(nor);
-			if (ret)
-				goto erase_err;
+				ret = spi_nor_erase_sector(nor, offset);
+				if (ret)
+					goto erase_err;
 
-			addr += mtd->erasesize;
-			len -= mtd->erasesize;
+				ret = spi_nor_wait_till_ready(nor);
+				if (ret)
+					goto erase_err;
 
-			/*
-			 * Flash cross over condition in stacked mode.
-			 */
-			if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1)) {
-				cur_cs_num++;
-				params = spi_nor_get_params(nor, cur_cs_num);
-				sz += params->size;
+				addr += mtd->erasesize;
+				len -= mtd->erasesize;
 			}
-		}
-
-	/* erase multiple sectors */
-	} else {
-		u64 erase_len = 0;
 
-		/* Determine the flash from which the operation need to start */
-		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (addr > sz - 1) && params) {
-			cur_cs_num++;
-			params = spi_nor_get_params(nor, cur_cs_num);
-			sz += params->size;
-		}
-		/* perform multi sector erase onec per Flash*/
-		while (len) {
-			erase_len = (len > (sz - addr)) ? (sz - addr) : len;
-			offset = addr;
-			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-			if (nor->flags & SNOR_F_HAS_STACKED) {
-				params = spi_nor_get_params(nor, cur_cs_num);
-				offset -= (sz - params->size);
-			}
-			ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
+		/* erase multiple sectors */
+		} else {
+			offset = addr / 2;
+			ret = spi_nor_erase_multi_sectors(nor, offset, len);
 			if (ret)
 				goto erase_err;
-			len -= erase_len;
-			addr += erase_len;
-			cur_cs_num++;
-			params = spi_nor_get_params(nor, cur_cs_num);
-			sz += params->size;
 		}
 	}
-
 	ret = spi_nor_write_disable(nor);
 
 erase_err:
@@ -1771,34 +1848,59 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 	struct spi_nor_flash_parameter *params;
 	ssize_t ret, read_len;
 	u32 cur_cs_num = 0;
-	u64 sz;
+	u_char *readbuf;
+	bool is_ofst_odd = false;
+	u64 sz = 0;
 
 	dev_dbg(nor->dev, "from 0x%08x, len %zd\n", (u32)from, len);
 
-	ret = spi_nor_lock_and_prep(nor);
-	if (ret)
-		return ret;
-
 	params = spi_nor_get_params(nor, 0);
 	sz = params->size;
 
-	/* Determine the flash from which the operation need to start */
-	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) && params) {
-		cur_cs_num++;
-		params = spi_nor_get_params(nor, cur_cs_num);
-		sz += params->size;
+	/*
+	 * Cannot read from odd offset in parallel mode, so read
+	 * len + 1 from offset + 1 and ignore offset[0] data.
+	 */
+	if ((nor->flags & SNOR_F_HAS_PARALLEL) && (from & 0x01)) {
+		from = (loff_t)(from - 1);
+		len = (size_t)(len + 1);
+		is_ofst_odd = true;
+		readbuf = kmalloc(len, GFP_KERNEL);
+		if (!readbuf)
+			return -ENOMEM;
+	} else {
+		readbuf = buf;
+	}
+
+	if (!(nor->flags & SNOR_F_HAS_PARALLEL)) {
+		/* Determine the flash from which the operation need to start */
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) && params) {
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
 	}
+	ret = spi_nor_lock_and_prep(nor);
+	if (ret)
+		return ret;
+
 	while (len) {
 		loff_t addr = from;
 
-		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-		read_len = (len > (sz - addr)) ? (sz - addr) : len;
-		params = spi_nor_get_params(nor, cur_cs_num);
-		addr -= (sz - params->size);
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			read_len = len;
+			addr /= 2;
+		} else {
+			nor->spimem->spi->cs_index_mask = 1 << cur_cs_num;
+			read_len = (len > (sz - addr)) ? (sz - addr) : len;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			addr -= (sz - params->size);
+		}
 
 		addr = spi_nor_convert_addr(nor, addr);
 
-		ret = spi_nor_read_data(nor, addr, len, buf);
+		ret = spi_nor_read_data(nor, addr, read_len, readbuf);
 		if (ret == 0) {
 			/* We shouldn't see 0-length reads */
 			ret = -EIO;
@@ -1808,8 +1910,20 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 			goto read_err;
 
 		WARN_ON(ret > read_len);
-		*retlen += ret;
+		if (is_ofst_odd) {
+			/*
+			 * Cannot read from odd offset in parallel mode.
+			 * So read len + 1 from offset + 1 from the flash
+			 * and copy len data from readbuf[1].
+			 */
+			memcpy(buf, (readbuf + 1), (len - 1));
+			*retlen += (ret - 1);
+		} else {
+			*retlen += ret;
+		}
 		buf += ret;
+		if (!is_ofst_odd)
+			readbuf += ret;
 		from += ret;
 		len -= ret;
 
@@ -1827,6 +1941,9 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 	ret = 0;
 
 read_err:
+	if (is_ofst_odd)
+		kfree(readbuf);
+
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
 }
@@ -1852,13 +1969,38 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 	page_size = params->page_size;
 	sz = params->size;
 
-	/* Determine the flash from which the operation need to start */
-	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) && params) {
-		cur_cs_num++;
-		params = spi_nor_get_params(nor, cur_cs_num);
-		sz += params->size;
-	}
+	if (nor->flags & SNOR_F_HAS_PARALLEL) {
+		/*
+		 * Cannot write to odd offset in parallel mode,
+		 * so write 2 byte first.
+		 */
+		if (to & 0x01) {
+			u8 two[2] = {0xff, buf[0]};
+			size_t written_len;
+
+			ret = spi_nor_write(mtd, to & ~1, 2, &written_len, two);
+			if (ret < 0)
+				return ret;
+			*retlen += 1; /* We've written only one actual byte */
+			++buf;
+			--len;
+			++to;
+		}
+		/*
+		 * Write operation are performed in page size chunks and in
+		 * parallel memories both the flashes are written simultaneously,
+		 * hence doubled the page_size.
+		 */
+		page_size <<= 1;
 
+	} else {
+		/* Determine the flash from which the operation need to start */
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) && params) {
+			cur_cs_num++;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			sz += params->size;
+		}
+	}
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
 		return ret;
@@ -1882,9 +2024,14 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* the size of data remaining on the first page */
 		page_remain = min_t(size_t, page_size - page_offset, len - i);
 
-		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-		params = spi_nor_get_params(nor, cur_cs_num);
-		addr -= (sz - params->size);
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			addr /= 2;
+		} else {
+			nor->spimem->spi->cs_index_mask = 1 << cur_cs_num;
+			params = spi_nor_get_params(nor, cur_cs_num);
+			addr -= (sz - params->size);
+		}
 
 		addr = spi_nor_convert_addr(nor, addr);
 
@@ -2323,7 +2470,15 @@ static int spi_nor_select_erase(struct spi_nor *nor)
 		if (!erase)
 			return -EINVAL;
 		nor->erase_opcode = erase->opcode;
-		mtd->erasesize = erase->size;
+		/*
+		 * In parallel-memories the erase operation is
+		 * performed on both the flashes simultaneously
+		 * so, double the erasesize.
+		 */
+		if (nor->flags & SNOR_F_HAS_PARALLEL)
+			mtd->erasesize = erase->size * 2;
+		else
+			mtd->erasesize = erase->size;
 		return 0;
 	}
 
@@ -2341,7 +2496,15 @@ static int spi_nor_select_erase(struct spi_nor *nor)
 	if (!erase)
 		return -EINVAL;
 
-	mtd->erasesize = erase->size;
+	/*
+	 * In parallel-memories the erase operation is
+	 * performed on both the flashes simultaneously
+	 * so, double the erasesize.
+	 */
+	if (nor->flags & SNOR_F_HAS_PARALLEL)
+		mtd->erasesize = erase->size * 2;
+	else
+		mtd->erasesize = erase->size;
 	return 0;
 }
 
@@ -2659,7 +2822,22 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
 				nor->flags |= SNOR_F_HAS_STACKED;
 		}
 	}
-	if (nor->flags & SNOR_F_HAS_STACKED) {
+	i = 0;
+	idx = 0;
+	while (i < SNOR_FLASH_CNT_MAX) {
+		rc = of_property_read_u64_index(np, "parallel-memories", idx, &flash_size[i]);
+		if (rc == -EINVAL) {
+			break;
+		} else if (rc == -EOVERFLOW) {
+			idx++;
+		} else {
+			idx++;
+			i++;
+			if (!(nor->flags & SNOR_F_HAS_PARALLEL))
+				nor->flags |= SNOR_F_HAS_PARALLEL;
+		}
+	}
+	if (nor->flags & (SNOR_F_HAS_STACKED | SNOR_F_HAS_PARALLEL)) {
 		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++) {
 			params = spi_nor_get_params(nor, idx);
 			params = devm_kzalloc(nor->dev, sizeof(*params), GFP_KERNEL);
@@ -2881,24 +3059,42 @@ static int spi_nor_quad_enable(struct spi_nor *nor)
 	struct spi_nor_flash_parameter *params;
 	int err, idx;
 
-	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
-		params = spi_nor_get_params(nor, idx);
-		if (params) {
-			if (!params->quad_enable)
-				return 0;
+	if (nor->flags & SNOR_F_HAS_PARALLEL) {
+		params = spi_nor_get_params(nor, 0);
+		if (!params->quad_enable)
+			return 0;
 
-			if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
-			      spi_nor_get_protocol_width(nor->write_proto) == 4))
-				return 0;
-			/*
-			 * Set the appropriate CS index before
-			 * issuing the command.
-			 */
-			nor->spimem->spi->cs_index_mask = 0x01 << idx;
+		if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
+		      spi_nor_get_protocol_width(nor->write_proto) == 4))
+			return 0;
+		/*
+		 * In parallel mode both chip selects i.e., CS0 &
+		 * CS1 need to be asserted simulatneously.
+		 */
+		nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+		err = params->quad_enable(nor);
+		if (err)
+			return err;
+	} else {
+		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			params = spi_nor_get_params(nor, idx);
+			if (params) {
+				if (!params->quad_enable)
+					return 0;
 
-			err = params->quad_enable(nor);
-			if (err)
-				return err;
+				if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
+				      spi_nor_get_protocol_width(nor->write_proto) == 4))
+					return 0;
+				/*
+				 * Set the appropriate CS index before
+				 * issuing the command.
+				 */
+				nor->spimem->spi->cs_index_mask = 1 << idx;
+
+				err = params->quad_enable(nor);
+				if (err)
+					return err;
+			}
 		}
 	}
 	return err;
@@ -2948,17 +3144,29 @@ static int spi_nor_init(struct spi_nor *nor)
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
-			params = spi_nor_get_params(nor, idx);
-			if (params) {
-				/*
-				 * Select the appropriate CS index before
-				 * issuing the command.
-				 */
-				nor->spimem->spi->cs_index_mask = 0x01 << idx;
-				err = params->set_4byte_addr_mode(nor, true);
-				if (err && err != -ENOTSUPP)
-					return err;
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			/*
+			 * In parallel mode both chip selects i.e., CS0 &
+			 * CS1 need to be asserted simulatneously.
+			 */
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			params = spi_nor_get_params(nor, 0);
+			err = params->set_4byte_addr_mode(nor, true);
+			if (err && err != -ENOTSUPP)
+				return err;
+		} else {
+			for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+				params = spi_nor_get_params(nor, idx);
+				if (params) {
+					/*
+					 * Select the appropriate CS index before
+					 * issuing the command.
+					 */
+					nor->spimem->spi->cs_index_mask = 1 << idx;
+					err = params->set_4byte_addr_mode(nor, true);
+					if (err && err != -ENOTSUPP)
+						return err;
+				}
 			}
 		}
 	}
@@ -3081,20 +3289,39 @@ void spi_nor_restore(struct spi_nor *nor)
 	/* restore the addressing mode */
 	if (nor->addr_nbytes == 4 && !(nor->flags & SNOR_F_4B_OPCODES) &&
 	    nor->flags & SNOR_F_BROKEN_RESET) {
-		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
-			params = spi_nor_get_params(nor, idx);
-			if (params) {
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			/*
+			 * In parallel mode both chip selects i.e., CS0 &
+			 * CS1 need to be asserted simulatneously.
+			 */
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			params = spi_nor_get_params(nor, 0);
+			ret = params->set_4byte_addr_mode(nor, false);
+			if (ret)
+				/*
+				 * Do not stop the execution in the hope that the flash
+				 * will default to the 3-byte address mode after the
+				 * software reset.
+				 */
+				dev_err(nor->dev,
+					"Failed to exit 4-byte address mode, err = %d\n",
+					ret);
+		} else {
+			for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+				params = spi_nor_get_params(nor, idx);
+				if (!params)
+					break;
 				/*
 				 * Select the appropriate CS index before
 				 * issuing the command.
 				 */
-				nor->spimem->spi->cs_index_mask = 0x01 << idx;
+				nor->spimem->spi->cs_index_mask = 1 << idx;
 				ret = params->set_4byte_addr_mode(nor, false);
 				if (ret)
 					/*
-					 * Do not stop the execution in the hope that the flash
-					 * will default to the 3-byte address mode after the
-					 * software reset.
+					 * Do not stop the execution in the hope that the
+					 * flash will default to the 3-byte address mode
+					 * after the software reset.
 					 */
 					dev_err(nor->dev,
 						"Failed to exit 4-byte address mode, err = %d\n",
@@ -3184,7 +3411,16 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 	else
 		mtd->_erase = spi_nor_erase;
 	mtd->writesize = params->writesize;
-	mtd->writebufsize = params->page_size;
+	/*
+	 * In parallel-memories the write operation is
+	 * performed on both the flashes simultaneously
+	 * one page per flash, so double the writebufsize.
+	 */
+	if (nor->flags & SNOR_F_HAS_PARALLEL)
+		mtd->writebufsize = params->page_size << 1;
+	else
+		mtd->writebufsize = params->page_size;
+
 	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
 		params = spi_nor_get_params(nor, idx);
 		if (params)
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index e94107cc465e..4aedc9fbef32 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -14,6 +14,9 @@
 /* In single configuration enable CS0 */
 #define SPI_NOR_ENABLE_CS0     BIT(0)
 
+/* In parallel configuration enable multiple CS */
+#define SPI_NOR_ENABLE_MULTI_CS	(BIT(0) | BIT(1))
+
 /* Standard SPI NOR flash operations. */
 #define SPI_NOR_READID_OP(naddr, ndummy, buf, len)			\
 	SPI_MEM_OP(SPI_MEM_OP_CMD(SPINOR_OP_RDID, 0),			\
@@ -134,6 +137,7 @@ enum spi_nor_option_flags {
 	SNOR_F_SOFT_RESET	= BIT(12),
 	SNOR_F_SWP_IS_VOLATILE	= BIT(13),
 	SNOR_F_HAS_STACKED      = BIT(14),
+	SNOR_F_HAS_PARALLEL	= BIT(15),
 };
 
 struct spi_nor_read_command {
diff --git a/drivers/mtd/spi-nor/micron-st.c b/drivers/mtd/spi-nor/micron-st.c
index b93e16094b6c..9be39f237dfc 100644
--- a/drivers/mtd/spi-nor/micron-st.c
+++ b/drivers/mtd/spi-nor/micron-st.c
@@ -357,6 +357,9 @@ static int micron_st_nor_read_fsr(struct spi_nor *nor, u8 *fsr)
 			op.data.nbytes = 2;
 		}
 
+		if (nor->flags & SNOR_F_HAS_PARALLEL)
+			op.data.nbytes = 2;
+
 		spi_nor_spimem_setup_op(nor, &op, nor->reg_proto);
 
 		ret = spi_mem_exec_op(nor->spimem, &op);
@@ -368,6 +371,8 @@ static int micron_st_nor_read_fsr(struct spi_nor *nor, u8 *fsr)
 	if (ret)
 		dev_dbg(nor->dev, "error %d reading FSR\n", ret);
 
+	if (nor->flags & SNOR_F_HAS_PARALLEL)
+		fsr[0] &= fsr[1];
 	return ret;
 }
 
-- 
2.25.1

