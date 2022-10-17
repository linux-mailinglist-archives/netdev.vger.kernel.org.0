Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A78600ED0
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiJQMQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiJQMQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:16:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C787667;
        Mon, 17 Oct 2022 05:15:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K550IbePMD53psVPeNtzirtVZGz+lZZmMaCYLlT5EkBDFTRJbg2X1J4eD/4HfVdt5baSd0jxku2Pp2iN6rI/4JF/pOxCxFYVVZIP1F4+S21Yg0NiAejrccKU8Lbi31RQVZUhlYxrLDbWOs1KYxuCaILx3p03OeNkVQ2mMHVhZG//Q1BOUhpEBSw4T9EU+GFIbCrNA7L1oFuIK/qDvCho86Nmr25jL6GeHekpU1DBnoCnw2n2tFs5rhS/+06MQ0iHk2rS13gA4LHKLJVjaiQ8IQW4wKGi5/jGtlg2A75Fu4hH+Ht6H24jw5DS8r5tz9z0AAPQKUTnEebsfJcc4/D9hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIsZLFiNchdVq35KM86b2NrTwUr2/0k4ECWsHcMF/ns=;
 b=eSB+t59DFAYjjbvAH196TUd5IBCNsyZokMB4+UFJyYKQiGU+f0I5PY/GZvkSBWiVjHUoy4OaVNnfYoYNyqkXgWqgnQ/TLqtWz5Lbvf3WBnQVX91ZpwFYtzPmL9UirGwyVchWqKpkVIAU9RdA1u9SWDWgBDo8EQL8n8opSYQ6uk0qihH81YUYmVjWKHWNKEU15aRYNryYkU/GIT32xTWqHKHA3O8jAfrlukwQJDCCOvlAXLpaQzqiVYKZpYgdw4AFkOkfcBB30tQkK8JaT2qbtQlS7fIHRZXlExEysbAlnV7uMCBGAwytFYZrjSH9RejeTdKd0acAvUyLOYLOul6yeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIsZLFiNchdVq35KM86b2NrTwUr2/0k4ECWsHcMF/ns=;
 b=wDUE/oBBPXuP0aRvVSHZtHTHJu9ZPcCW2Me3rY38kiABXxhU7wtSfNAYV0NX1jpwy7HQOcbkJpYWffsENppQMPe97JoKad7tv7JG/P4npQnwbWIu1ej6kK01rI5qykpX8sHlg263ae6lc4K8PIi+fNTUu/Rcu1SZXJca2uVRrsU=
Received: from MW4PR03CA0057.namprd03.prod.outlook.com (2603:10b6:303:8e::32)
 by DM4PR12MB5868.namprd12.prod.outlook.com (2603:10b6:8:67::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 12:15:45 +0000
Received: from CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::38) by MW4PR03CA0057.outlook.office365.com
 (2603:10b6:303:8e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Mon, 17 Oct 2022 12:15:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT111.mail.protection.outlook.com (10.13.174.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 12:15:45 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:15:44 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 05:15:43 -0700
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 07:15:20 -0500
From:   Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
To:     <broonie@kernel.org>, <sanju.mehta@amd.com>,
        <chin-ting_kuo@aspeedtech.com>, <clg@kaod.org>,
        <kdasu.kdev@gmail.com>, <f.fainelli@gmail.com>,
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
        <kvalo@kernel.org>, <miquel.raynal@bootlin.com>, <richard@nod.at>,
        <vigneshr@ti.com>, <jic23@kernel.org>,
        <tudor.ambarus@microchip.com>, <pratyush@kernel.org>
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
        <akumarma@amd.com>, <amitrkcian2002@gmail.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Subject: [PATCH 06/10] mtd: spi-nor: Add stacked memories support in spi-nor
Date:   Mon, 17 Oct 2022 17:42:45 +0530
Message-ID: <20221017121249.19061-7-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
References: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT111:EE_|DM4PR12MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: cc0df7c3-0ae4-4090-7b96-08dab0395171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APCY7yIipJtMdKoCtAY+NAJJW5hwjhmGepo8HO4/OqKBvIOJk1sD9As6ZQQGHs1MzoetLbofx0Cs/maApbqGvXvz7HnZ+FS6eP5UfVlcOSru5rK7bwu1VMUnAapV785PEhXUqr0W1qAuVFAa9RBnicysh2+8LRpYdgurY9WyN4CP8Ji/v3Ut8ulx+uOD00carUlrUPTUqrdIjkNffz8W463jyAMcrNy2CWzhkogLnzYezPrni2cT/DXNwk48VLR/u7GtnIhQ+5GApLtNu19j2VphcwwibE2sIIiQWnuYVQcen6mo+swsFG1Ib2loDds4npraHSRY734/UdRLYgdCsgh1TEzpS3IX8jO+aTYTdUep1kdVJw24apLNc/gGgnfFbYIlrSIf646lD9ZUpn21Doxjb/mAMnAIVxw2Pvh8xZV7NMPC223m4InIsqrKK2SfcaFeB84juhKmjt6/LMKscby47gFN1HRHnEWssSI3LtsOdMYkH1R+up0CTcxqSme00r9UUBVT157sk2dlvCfKEMvg5qpVxzQ7xI8hQmytGScpDaNhcy1Ty6sEldnhoxvmWDvP6tpa/xdsWLkYqYIMLUIIi1p3lUlIGIW8tUuBZu4kLLkr3uzxLW7ivE3PntjjEHICClchy9tGXdzF2b/mNO9B19ANQ9EwT5r5cRc281Yk2PAw+rp5VEqUi6Sj3zvFkxeDh4EbzkXvi4NhsuJENYgTlrc6AUaBSRaDjfDXhc90ta86JmUthHF6iyU3mhgcDeTy4fX1MLrnL3POGdniT5giKbtE1oLkKemjovBsNtNuAl1JHOSFtL5mkMMIqUUgL85ZzKcQXCLIgNBv/mHBRYfRdOSJ9zvWrMTyfV2rnaNaAnXpSxFSv8lqcH686BjUwgKOtMpkxUDf7cG/2p03ILn2Rev1RRwu6GABclt4LBg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(86362001)(36756003)(81166007)(356005)(921005)(82740400003)(40480700001)(41300700001)(70586007)(40460700003)(2906002)(8676002)(4326008)(8936002)(70206006)(82310400005)(26005)(426003)(1076003)(186003)(336012)(47076005)(36860700001)(2616005)(7366002)(478600001)(83380400001)(30864003)(6666004)(7406005)(7336002)(5660300002)(7416002)(110136005)(54906003)(316002)(36900700001)(41080700001)(2101003)(83996005)(559001)(579004)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 12:15:45.0487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0df7c3-0ae4-4090-7b96-08dab0395171
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5868
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/mtd/spi-nor/atmel.c      |  10 +-
 drivers/mtd/spi-nor/core.c       | 308 +++++++++++++++++++++++--------
 drivers/mtd/spi-nor/core.h       |   4 +
 drivers/mtd/spi-nor/debugfs.c    |   4 +-
 drivers/mtd/spi-nor/gigadevice.c |   2 +-
 drivers/mtd/spi-nor/issi.c       |   6 +-
 drivers/mtd/spi-nor/macronix.c   |   4 +-
 drivers/mtd/spi-nor/micron-st.c  |  22 +--
 drivers/mtd/spi-nor/otp.c        |  18 +-
 drivers/mtd/spi-nor/sfdp.c       |  20 +-
 drivers/mtd/spi-nor/spansion.c   |  32 ++--
 drivers/mtd/spi-nor/sst.c        |   4 +-
 drivers/mtd/spi-nor/swp.c        |  12 +-
 drivers/mtd/spi-nor/winbond.c    |   6 +-
 drivers/mtd/spi-nor/xilinx.c     |  14 +-
 include/linux/mtd/spi-nor.h      |   8 +-
 16 files changed, 323 insertions(+), 151 deletions(-)

diff --git a/drivers/mtd/spi-nor/atmel.c b/drivers/mtd/spi-nor/atmel.c
index 656dd80a0be7..897d1b85ee4a 100644
--- a/drivers/mtd/spi-nor/atmel.c
+++ b/drivers/mtd/spi-nor/atmel.c
@@ -26,7 +26,7 @@ static int at25fs_nor_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 	int ret;
 
 	/* We only support unlocking the whole flash array */
-	if (ofs || len != nor->params->size)
+	if (ofs || len != nor->params[0]->size)
 		return -EINVAL;
 
 	/* Write 0x00 to the status register to disable write protection */
@@ -50,7 +50,7 @@ static const struct spi_nor_locking_ops at25fs_nor_locking_ops = {
 
 static void at25fs_nor_late_init(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &at25fs_nor_locking_ops;
+	nor->params[0]->locking_ops = &at25fs_nor_locking_ops;
 }
 
 static const struct spi_nor_fixups at25fs_nor_fixups = {
@@ -73,7 +73,7 @@ static int atmel_nor_set_global_protection(struct spi_nor *nor, loff_t ofs,
 	u8 sr;
 
 	/* We only support locking the whole flash array */
-	if (ofs || len != nor->params->size)
+	if (ofs || len != nor->params[0]->size)
 		return -EINVAL;
 
 	ret = spi_nor_read_sr(nor, nor->bouncebuf);
@@ -133,7 +133,7 @@ static int atmel_nor_is_global_protected(struct spi_nor *nor, loff_t ofs,
 {
 	int ret;
 
-	if (ofs >= nor->params->size || (ofs + len) > nor->params->size)
+	if (ofs >= nor->params[0]->size || (ofs + len) > nor->params[0]->size)
 		return -EINVAL;
 
 	ret = spi_nor_read_sr(nor, nor->bouncebuf);
@@ -151,7 +151,7 @@ static const struct spi_nor_locking_ops atmel_nor_global_protection_ops = {
 
 static void atmel_nor_global_protection_late_init(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &atmel_nor_global_protection_ops;
+	nor->params[0]->locking_ops = &atmel_nor_global_protection_ops;
 }
 
 static const struct spi_nor_fixups atmel_nor_global_protection_fixups = {
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index f2c64006f8d7..3801890c17e6 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -454,8 +454,8 @@ int spi_nor_read_sr(struct spi_nor *nor, u8 *sr)
 		struct spi_mem_op op = SPI_NOR_RDSR_OP(sr);
 
 		if (nor->reg_proto == SNOR_PROTO_8_8_8_DTR) {
-			op.addr.nbytes = nor->params->rdsr_addr_nbytes;
-			op.dummy.nbytes = nor->params->rdsr_dummy;
+			op.addr.nbytes = nor->params[0]->rdsr_addr_nbytes;
+			op.dummy.nbytes = nor->params[0]->rdsr_dummy;
 			/*
 			 * We don't want to read only one byte in DTR mode. So,
 			 * read 2 and then discard the second byte.
@@ -597,8 +597,8 @@ int spi_nor_sr_ready(struct spi_nor *nor)
 static int spi_nor_ready(struct spi_nor *nor)
 {
 	/* Flashes might override the standard routine. */
-	if (nor->params->ready)
-		return nor->params->ready(nor);
+	if (nor->params[0]->ready)
+		return nor->params[0]->ready(nor);
 
 	return spi_nor_sr_ready(nor);
 }
@@ -769,7 +769,7 @@ static int spi_nor_write_16bit_sr_and_check(struct spi_nor *nor, u8 sr1)
 		ret = spi_nor_read_cr(nor, &sr_cr[1]);
 		if (ret)
 			return ret;
-	} else if (nor->params->quad_enable) {
+	} else if (nor->params[0]->quad_enable) {
 		/*
 		 * If the Status Register 2 Read command (35h) is not
 		 * supported, we should at least be sure we don't
@@ -1048,7 +1048,7 @@ static u8 spi_nor_convert_3to4_erase(u8 opcode)
 
 static bool spi_nor_has_uniform_erase(const struct spi_nor *nor)
 {
-	return !!nor->params->erase_map.uniform_erase_type;
+	return !!nor->params[0]->erase_map.uniform_erase_type;
 }
 
 static void spi_nor_set_4byte_opcodes(struct spi_nor *nor)
@@ -1058,7 +1058,7 @@ static void spi_nor_set_4byte_opcodes(struct spi_nor *nor)
 	nor->erase_opcode = spi_nor_convert_3to4_erase(nor->erase_opcode);
 
 	if (!spi_nor_has_uniform_erase(nor)) {
-		struct spi_nor_erase_map *map = &nor->params->erase_map;
+		struct spi_nor_erase_map *map = &nor->params[0]->erase_map;
 		struct spi_nor_erase_type *erase;
 		int i;
 
@@ -1095,10 +1095,10 @@ void spi_nor_unlock_and_unprep(struct spi_nor *nor)
 
 static u32 spi_nor_convert_addr(struct spi_nor *nor, loff_t addr)
 {
-	if (!nor->params->convert_addr)
+	if (!nor->params[0]->convert_addr)
 		return addr;
 
-	return nor->params->convert_addr(nor, addr);
+	return nor->params[0]->convert_addr(nor, addr);
 }
 
 /*
@@ -1316,7 +1316,7 @@ static int spi_nor_init_erase_cmd_list(struct spi_nor *nor,
 				       struct list_head *erase_list,
 				       u64 addr, u32 len)
 {
-	const struct spi_nor_erase_map *map = &nor->params->erase_map;
+	const struct spi_nor_erase_map *map = &nor->params[0]->erase_map;
 	const struct spi_nor_erase_type *erase, *prev_erase = NULL;
 	struct spi_nor_erase_region *region;
 	struct spi_nor_erase_command *cmd = NULL;
@@ -1428,9 +1428,11 @@ static int spi_nor_erase_multi_sectors(struct spi_nor *nor, u64 addr, u32 len)
 static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	u32 addr, len;
+	u32 addr, len, offset;
 	uint32_t rem;
 	int ret;
+	u32 cur_cs_num = 0;
+	u64 sz = nor->params[cur_cs_num]->size;
 
 	dev_dbg(nor->dev, "at 0x%llx, len %lld\n", (long long)instr->addr,
 			(long long)instr->len);
@@ -1452,26 +1454,30 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 	if (len == mtd->size && !(nor->flags & SNOR_F_NO_OP_CHIP_ERASE)) {
 		unsigned long timeout;
 
-		ret = spi_nor_write_enable(nor);
-		if (ret)
-			goto erase_err;
+		while (cur_cs_num < SNOR_FLASH_CNT_MAX && (nor->params[cur_cs_num])) {
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
+				      (unsigned long)(nor->params[cur_cs_num]->size / SZ_2M));
+			ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
+			if (ret)
+				goto erase_err;
+			cur_cs_num++;
+		}
 
 	/* REVISIT in some cases we could speed up erasing large regions
 	 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
@@ -1480,12 +1486,22 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 
 	/* "sector"-at-a-time erase */
 	} else if (spi_nor_has_uniform_erase(nor)) {
+		/* Determine the flash from which the operation need to start */
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
+		       (addr > sz - 1) && (nor->params[cur_cs_num]))
+			sz += nor->params[++cur_cs_num]->size;
+
 		while (len) {
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
 			ret = spi_nor_write_enable(nor);
 			if (ret)
 				goto erase_err;
 
-			ret = spi_nor_erase_sector(nor, addr);
+			offset = addr;
+			if (nor->flags & SNOR_F_HAS_STACKED)
+				offset -= (sz - nor->params[cur_cs_num]->size);
+
+			ret = spi_nor_erase_sector(nor, offset);
 			if (ret)
 				goto erase_err;
 
@@ -1495,13 +1511,36 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 
 			addr += mtd->erasesize;
 			len -= mtd->erasesize;
+
+			/*
+			 * Flash cross over condition in stacked mode.
+			 */
+			if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1))
+				sz += nor->params[++cur_cs_num]->size;
 		}
 
 	/* erase multiple sectors */
 	} else {
-		ret = spi_nor_erase_multi_sectors(nor, addr, len);
-		if (ret)
-			goto erase_err;
+		u64 erase_len = 0;
+
+		/* Determine the flash from which the operation need to start */
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
+		       (addr > sz - 1) && (nor->params[cur_cs_num]))
+			sz += nor->params[++cur_cs_num]->size;
+		/* perform multi sector erase onec per Flash*/
+		while (len) {
+			erase_len = (len > (sz - addr)) ? (sz - addr) : len;
+			offset = addr;
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+			if (nor->flags & SNOR_F_HAS_STACKED)
+				offset -= (sz - nor->params[cur_cs_num]->size);
+			ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
+			if (ret)
+				goto erase_err;
+			len -= erase_len;
+			addr += erase_len;
+			sz += nor->params[++cur_cs_num]->size;
+		}
 	}
 
 	ret = spi_nor_write_disable(nor);
@@ -1677,7 +1716,9 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t *retlen, u_char *buf)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	ssize_t ret;
+	ssize_t ret, read_len;
+	u32 cur_cs_num = 0;
+	u64 sz = nor->params[cur_cs_num]->size;
 
 	dev_dbg(nor->dev, "from 0x%08x, len %zd\n", (u32)from, len);
 
@@ -1685,9 +1726,17 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 	if (ret)
 		return ret;
 
+	/* Determine the flash from which the operation need to start */
+	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) &&
+	       (nor->params[cur_cs_num]))
+		sz += nor->params[++cur_cs_num]->size;
 	while (len) {
 		loff_t addr = from;
 
+		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+		read_len = (len > (sz - addr)) ? (sz - addr) : len;
+		addr -= (sz - nor->params[cur_cs_num]->size);
+
 		addr = spi_nor_convert_addr(nor, addr);
 
 		ret = spi_nor_read_data(nor, addr, len, buf);
@@ -1699,11 +1748,19 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
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
+		if ((nor->flags & SNOR_F_HAS_STACKED) && (from > sz - 1))
+			sz += nor->params[++cur_cs_num]->size;
+
 	}
 	ret = 0;
 
@@ -1723,10 +1780,17 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
 	size_t page_offset, page_remain, i;
 	ssize_t ret;
-	u32 page_size = nor->params->page_size;
+	u32 cur_cs_num = 0;
+	u32 page_size = nor->params[0]->page_size;
+	u64 sz = nor->params[cur_cs_num]->size;
 
 	dev_dbg(nor->dev, "to 0x%08x, len %zd\n", (u32)to, len);
 
+	/* Determine the flash from which the operation need to start */
+	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) &&
+	       (nor->params[cur_cs_num]))
+		sz += nor->params[++cur_cs_num]->size;
+
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
 		return ret;
@@ -1750,6 +1814,9 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* the size of data remaining on the first page */
 		page_remain = min_t(size_t, page_size - page_offset, len - i);
 
+		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+		addr -= (sz - nor->params[cur_cs_num]->size);
+
 		addr = spi_nor_convert_addr(nor, addr);
 
 		ret = spi_nor_write_enable(nor);
@@ -1766,6 +1833,13 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 			goto write_err;
 		*retlen += written;
 		i += written;
+
+		/*
+		 * Flash cross over condition in stacked mode.
+		 */
+		if ((nor->flags & SNOR_F_HAS_STACKED) &&
+		    ((to + i) > sz - 1))
+			sz += nor->params[++cur_cs_num]->size;
 	}
 
 write_err:
@@ -1886,7 +1960,7 @@ static int spi_nor_spimem_check_op(struct spi_nor *nor,
 	 */
 	op->addr.nbytes = 4;
 	if (!spi_mem_supports_op(nor->spimem, op)) {
-		if (nor->params->size > SZ_16M)
+		if (nor->params[0]->size > SZ_16M)
 			return -EOPNOTSUPP;
 
 		/* If flash size <= 16MB, 3 address bytes are sufficient */
@@ -1949,7 +2023,7 @@ static int spi_nor_spimem_check_pp(struct spi_nor *nor,
 static void
 spi_nor_spimem_adjust_hwcaps(struct spi_nor *nor, u32 *hwcaps)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	unsigned int cap;
 
 	/* X-X-X modes are not supported yet, mask them all. */
@@ -2050,7 +2124,7 @@ static int spi_nor_select_read(struct spi_nor *nor,
 	if (cmd < 0)
 		return -EINVAL;
 
-	read = &nor->params->reads[cmd];
+	read = &nor->params[0]->reads[cmd];
 	nor->read_opcode = read->opcode;
 	nor->read_proto = read->proto;
 
@@ -2081,7 +2155,7 @@ static int spi_nor_select_pp(struct spi_nor *nor,
 	if (cmd < 0)
 		return -EINVAL;
 
-	pp = &nor->params->page_programs[cmd];
+	pp = &nor->params[0]->page_programs[cmd];
 	nor->program_opcode = pp->opcode;
 	nor->write_proto = pp->proto;
 	return 0;
@@ -2142,7 +2216,7 @@ spi_nor_select_uniform_erase(struct spi_nor_erase_map *map,
 
 static int spi_nor_select_erase(struct spi_nor *nor)
 {
-	struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_erase_map *map = &nor->params[0]->erase_map;
 	const struct spi_nor_erase_type *erase = NULL;
 	struct mtd_info *mtd = &nor->mtd;
 	u32 wanted_size = nor->info->sector_size;
@@ -2191,7 +2265,7 @@ static int spi_nor_select_erase(struct spi_nor *nor)
 static int spi_nor_default_setup(struct spi_nor *nor,
 				 const struct spi_nor_hwcaps *hwcaps)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	u32 ignored_mask, shared_mask;
 	int err;
 
@@ -2251,8 +2325,8 @@ static int spi_nor_default_setup(struct spi_nor *nor,
 
 static int spi_nor_set_addr_nbytes(struct spi_nor *nor)
 {
-	if (nor->params->addr_nbytes) {
-		nor->addr_nbytes = nor->params->addr_nbytes;
+	if (nor->params[0]->addr_nbytes) {
+		nor->addr_nbytes = nor->params[0]->addr_nbytes;
 	} else if (nor->read_proto == SNOR_PROTO_8_8_8_DTR) {
 		/*
 		 * In 8D-8D-8D mode, one byte takes half a cycle to transfer. So
@@ -2273,7 +2347,7 @@ static int spi_nor_set_addr_nbytes(struct spi_nor *nor)
 		nor->addr_nbytes = 3;
 	}
 
-	if (nor->addr_nbytes == 3 && nor->params->size > 0x1000000) {
+	if (nor->addr_nbytes == 3 && nor->params[0]->size > 0x1000000) {
 		/* enable 4-byte addressing if the device exceeds 16MiB */
 		nor->addr_nbytes = 4;
 	}
@@ -2297,8 +2371,8 @@ static int spi_nor_setup(struct spi_nor *nor,
 {
 	int ret;
 
-	if (nor->params->setup)
-		ret = nor->params->setup(nor, hwcaps);
+	if (nor->params[0]->setup)
+		ret = nor->params[0]->setup(nor, hwcaps);
 	else
 		ret = spi_nor_default_setup(nor, hwcaps);
 	if (ret)
@@ -2333,7 +2407,7 @@ static void spi_nor_manufacturer_init_params(struct spi_nor *nor)
  */
 static void spi_nor_no_sfdp_init_params(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	struct spi_nor_erase_map *map = &params->erase_map;
 	const u8 no_sfdp_flags = nor->info->no_sfdp_flags;
 	u8 i, erase_mask;
@@ -2458,6 +2532,11 @@ static void spi_nor_init_fixup_flags(struct spi_nor *nor)
  */
 static void spi_nor_late_init_params(struct spi_nor *nor)
 {
+	struct device_node *np = spi_nor_get_flash_node(nor);
+	u64 flash_size[SNOR_FLASH_CNT_MAX];
+	u32 idx = 0, i = 0;
+	int rc;
+
 	if (nor->manufacturer && nor->manufacturer->fixups &&
 	    nor->manufacturer->fixups->late_init)
 		nor->manufacturer->fixups->late_init(nor);
@@ -2472,8 +2551,38 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
 	 * NOR protection support. When locking_ops are not provided, we pick
 	 * the default ones.
 	 */
-	if (nor->flags & SNOR_F_HAS_LOCK && !nor->params->locking_ops)
+	if (nor->flags & SNOR_F_HAS_LOCK && !nor->params[0]->locking_ops)
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
+			nor->params[idx] = devm_kzalloc(nor->dev,
+							sizeof(*nor->params[0]),
+							GFP_KERNEL);
+			if (nor->params[idx]) {
+				memcpy(nor->params[idx], nor->params[0], sizeof(*nor->params[0]));
+				nor->params[idx]->size = flash_size[idx];
+			}
+		}
+	}
 }
 
 /**
@@ -2488,10 +2597,10 @@ static void spi_nor_sfdp_init_params_deprecated(struct spi_nor *nor)
 {
 	struct spi_nor_flash_parameter sfdp_params;
 
-	memcpy(&sfdp_params, nor->params, sizeof(sfdp_params));
+	memcpy(&sfdp_params, nor->params[0], sizeof(sfdp_params));
 
 	if (spi_nor_parse_sfdp(nor)) {
-		memcpy(nor->params, &sfdp_params, sizeof(*nor->params));
+		memcpy(nor->params[0], &sfdp_params, sizeof(*nor->params[0]));
 		nor->flags &= ~SNOR_F_4B_OPCODES;
 	}
 }
@@ -2526,7 +2635,7 @@ static void spi_nor_init_params_deprecated(struct spi_nor *nor)
  */
 static void spi_nor_init_default_params(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	const struct flash_info *info = nor->info;
 	struct device_node *np = spi_nor_get_flash_node(nor);
 
@@ -2608,8 +2717,8 @@ static int spi_nor_init_params(struct spi_nor *nor)
 {
 	int ret;
 
-	nor->params = devm_kzalloc(nor->dev, sizeof(*nor->params), GFP_KERNEL);
-	if (!nor->params)
+	nor->params[0] = devm_kzalloc(nor->dev, sizeof(*nor->params[0]), GFP_KERNEL);
+	if (!nor->params[0])
 		return -ENOMEM;
 
 	spi_nor_init_default_params(nor);
@@ -2641,7 +2750,7 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 {
 	int ret;
 
-	if (!nor->params->octal_dtr_enable)
+	if (!nor->params[0]->octal_dtr_enable)
 		return 0;
 
 	if (!(nor->read_proto == SNOR_PROTO_8_8_8_DTR &&
@@ -2651,7 +2760,7 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 	if (!(nor->flags & SNOR_F_IO_MODE_EN_VOLATILE))
 		return 0;
 
-	ret = nor->params->octal_dtr_enable(nor, enable);
+	ret = nor->params[0]->octal_dtr_enable(nor, enable);
 	if (ret)
 		return ret;
 
@@ -2671,19 +2780,33 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
  */
 static int spi_nor_quad_enable(struct spi_nor *nor)
 {
-	if (!nor->params->quad_enable)
-		return 0;
+	int err, idx;
 
-	if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
-	      spi_nor_get_protocol_width(nor->write_proto) == 4))
-		return 0;
+	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+		if (nor->params[idx]) {
+			if (!nor->params[idx]->quad_enable)
+				return 0;
+
+			if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
+			      spi_nor_get_protocol_width(nor->write_proto) == 4))
+				return 0;
+			/*
+			 * Set the appropriate CS index before
+			 * issuing the command.
+			 */
+			nor->spimem->spi->cs_index_mask = 0x01 << idx;
 
-	return nor->params->quad_enable(nor);
+			err = nor->params[idx]->quad_enable(nor);
+			if (err)
+				return err;
+		}
+	}
+	return err;
 }
 
 static int spi_nor_init(struct spi_nor *nor)
 {
-	int err;
+	int err, idx;
 
 	err = spi_nor_octal_dtr_enable(nor, true);
 	if (err) {
@@ -2724,7 +2847,18 @@ static int spi_nor_init(struct spi_nor *nor)
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		return nor->params->set_4byte_addr_mode(nor, true);
+		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			if (nor->params[idx]) {
+				/*
+				 * Select the appropriate CS index before
+				 * issuing the command.
+				 */
+				nor->spimem->spi->cs_index_mask = 0x01 << idx;
+				err = nor->params[idx]->set_4byte_addr_mode(nor, true);
+				if (err)
+					return err;
+			}
+		}
 	}
 
 	return 0;
@@ -2838,10 +2972,22 @@ static void spi_nor_put_device(struct mtd_info *mtd)
 
 void spi_nor_restore(struct spi_nor *nor)
 {
+	int idx;
+
 	/* restore the addressing mode */
 	if (nor->addr_nbytes == 4 && !(nor->flags & SNOR_F_4B_OPCODES) &&
-	    nor->flags & SNOR_F_BROKEN_RESET)
-		nor->params->set_4byte_addr_mode(nor, false);
+	    nor->flags & SNOR_F_BROKEN_RESET) {
+		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			if (nor->params[idx]) {
+				/*
+				 * Select the appropriate CS index before
+				 * issuing the command.
+				 */
+				nor->spimem->spi->cs_index_mask = 0x01 << idx;
+				nor->params[idx]->set_4byte_addr_mode(nor, false);
+			}
+		}
+	}
 
 	if (nor->flags & SNOR_F_SOFT_RESET)
 		spi_nor_soft_reset(nor);
@@ -2907,6 +3053,8 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 {
 	struct mtd_info *mtd = &nor->mtd;
 	struct device *dev = nor->dev;
+	u64 total_sz = 0;
+	int idx;
 
 	spi_nor_set_mtd_locking_ops(nor);
 	spi_nor_set_mtd_otp_ops(nor);
@@ -2920,9 +3068,13 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 		mtd->flags |= MTD_NO_ERASE;
 	else
 		mtd->_erase = spi_nor_erase;
-	mtd->writesize = nor->params->writesize;
-	mtd->writebufsize = nor->params->page_size;
-	mtd->size = nor->params->size;
+	mtd->writesize = nor->params[0]->writesize;
+	mtd->writebufsize = nor->params[0]->page_size;
+	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+		if (nor->params[idx])
+			total_sz += nor->params[idx]->size;
+	}
+	mtd->size = total_sz;
 	mtd->_read = spi_nor_read;
 	/* Might be already set by some SST flashes. */
 	if (!mtd->_write)
@@ -3022,16 +3174,21 @@ EXPORT_SYMBOL_GPL(spi_nor_scan);
 
 static int spi_nor_create_read_dirmap(struct spi_nor *nor)
 {
+	int idx;
 	struct spi_mem_dirmap_info info = {
 		.op_tmpl = SPI_MEM_OP(SPI_MEM_OP_CMD(nor->read_opcode, 0),
 				      SPI_MEM_OP_ADDR(nor->addr_nbytes, 0, 0),
 				      SPI_MEM_OP_DUMMY(nor->read_dummy, 0),
 				      SPI_MEM_OP_DATA_IN(0, NULL, 0)),
 		.offset = 0,
-		.length = nor->params->size,
+		.length = nor->params[0]->size,
 	};
 	struct spi_mem_op *op = &info.op_tmpl;
 
+	if (nor->flags & SNOR_F_HAS_STACKED) {
+		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++)
+			info.length += nor->params[idx]->size;
+	}
 	spi_nor_spimem_setup_op(nor, op, nor->read_proto);
 
 	/* convert the dummy cycles to the number of bytes */
@@ -3053,16 +3210,21 @@ static int spi_nor_create_read_dirmap(struct spi_nor *nor)
 
 static int spi_nor_create_write_dirmap(struct spi_nor *nor)
 {
+	int idx;
 	struct spi_mem_dirmap_info info = {
 		.op_tmpl = SPI_MEM_OP(SPI_MEM_OP_CMD(nor->program_opcode, 0),
 				      SPI_MEM_OP_ADDR(nor->addr_nbytes, 0, 0),
 				      SPI_MEM_OP_NO_DUMMY,
 				      SPI_MEM_OP_DATA_OUT(0, NULL, 0)),
 		.offset = 0,
-		.length = nor->params->size,
+		.length = nor->params[0]->size,
 	};
 	struct spi_mem_op *op = &info.op_tmpl;
 
+	if (nor->flags & SNOR_F_HAS_STACKED) {
+		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++)
+			info.length += nor->params[idx]->size;
+	}
 	if (nor->program_opcode == SPINOR_OP_AAI_WP && nor->sst_write_second)
 		op->addr.nbytes = 0;
 
@@ -3133,8 +3295,8 @@ static int spi_nor_probe(struct spi_mem *spimem)
 	 * and add this logic so that if anyone ever adds support for such
 	 * a NOR we don't end up with buffer overflows.
 	 */
-	if (nor->params->page_size > PAGE_SIZE) {
-		nor->bouncebuf_size = nor->params->page_size;
+	if (nor->params[0]->page_size > PAGE_SIZE) {
+		nor->bouncebuf_size = nor->params[0]->page_size;
 		devm_kfree(nor->dev, nor->bouncebuf);
 		nor->bouncebuf = devm_kmalloc(nor->dev,
 					      nor->bouncebuf_size,
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 85b0cf254e97..285b7a46a1da 100644
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
diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index df76cb5de3f9..551496e7a3bd 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -73,7 +73,7 @@ static void spi_nor_print_flags(struct seq_file *s, unsigned long flags,
 static int spi_nor_params_show(struct seq_file *s, void *data)
 {
 	struct spi_nor *nor = s->private;
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	struct spi_nor_erase_map *erase_map = &params->erase_map;
 	struct spi_nor_erase_region *region;
 	const struct flash_info *info = nor->info;
@@ -181,7 +181,7 @@ static void spi_nor_print_pp_cmd(struct seq_file *s,
 static int spi_nor_capabilities_show(struct seq_file *s, void *data)
 {
 	struct spi_nor *nor = s->private;
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	u32 hwcaps = params->hwcaps.mask;
 	int i, cmd;
 
diff --git a/drivers/mtd/spi-nor/gigadevice.c b/drivers/mtd/spi-nor/gigadevice.c
index 119b38e6fc2a..fc8e21045e6e 100644
--- a/drivers/mtd/spi-nor/gigadevice.c
+++ b/drivers/mtd/spi-nor/gigadevice.c
@@ -16,7 +16,7 @@ static void gd25q256_default_init(struct spi_nor *nor)
 	 * indicate the quad_enable method for this case, we need
 	 * to set it in the default_init fixup hook.
 	 */
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	nor->params[0]->quad_enable = spi_nor_sr1_bit6_quad_enable;
 }
 
 static const struct spi_nor_fixups gd25q256_fixups = {
diff --git a/drivers/mtd/spi-nor/issi.c b/drivers/mtd/spi-nor/issi.c
index 89a66a19d754..c95792dcf61f 100644
--- a/drivers/mtd/spi-nor/issi.c
+++ b/drivers/mtd/spi-nor/issi.c
@@ -20,7 +20,7 @@ is25lp256_post_bfpt_fixups(struct spi_nor *nor,
 	 */
 	if ((bfpt->dwords[BFPT_DWORD(1)] & BFPT_DWORD1_ADDRESS_BYTES_MASK) ==
 		BFPT_DWORD1_ADDRESS_BYTES_3_ONLY)
-		nor->params->addr_nbytes = 4;
+		nor->params[0]->addr_nbytes = 4;
 
 	return 0;
 }
@@ -31,7 +31,7 @@ static const struct spi_nor_fixups is25lp256_fixups = {
 
 static void pm25lv_nor_late_init(struct spi_nor *nor)
 {
-	struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_erase_map *map = &nor->params[0]->erase_map;
 	int i;
 
 	/* The PM25LV series has a different 4k sector erase opcode */
@@ -90,7 +90,7 @@ static const struct flash_info issi_nor_parts[] = {
 
 static void issi_nor_default_init(struct spi_nor *nor)
 {
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	nor->params[0]->quad_enable = spi_nor_sr1_bit6_quad_enable;
 }
 
 static const struct spi_nor_fixups issi_fixups = {
diff --git a/drivers/mtd/spi-nor/macronix.c b/drivers/mtd/spi-nor/macronix.c
index d81a4cb2812b..7e7ab293f626 100644
--- a/drivers/mtd/spi-nor/macronix.c
+++ b/drivers/mtd/spi-nor/macronix.c
@@ -104,8 +104,8 @@ static const struct flash_info macronix_nor_parts[] = {
 
 static void macronix_nor_default_init(struct spi_nor *nor)
 {
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
-	nor->params->set_4byte_addr_mode = spi_nor_set_4byte_addr_mode;
+	nor->params[0]->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	nor->params[0]->set_4byte_addr_mode = spi_nor_set_4byte_addr_mode;
 }
 
 static const struct spi_nor_fixups macronix_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/micron-st.c b/drivers/mtd/spi-nor/micron-st.c
index 3c9681a3f7a3..ad2a2e126c4a 100644
--- a/drivers/mtd/spi-nor/micron-st.c
+++ b/drivers/mtd/spi-nor/micron-st.c
@@ -124,27 +124,27 @@ static int micron_st_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 
 static void mt35xu512aba_default_init(struct spi_nor *nor)
 {
-	nor->params->octal_dtr_enable = micron_st_nor_octal_dtr_enable;
+	nor->params[0]->octal_dtr_enable = micron_st_nor_octal_dtr_enable;
 }
 
 static void mt35xu512aba_post_sfdp_fixup(struct spi_nor *nor)
 {
 	/* Set the Fast Read settings. */
-	nor->params->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
-	spi_nor_set_read_settings(&nor->params->reads[SNOR_CMD_READ_8_8_8_DTR],
+	nor->params[0]->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
+	spi_nor_set_read_settings(&nor->params[0]->reads[SNOR_CMD_READ_8_8_8_DTR],
 				  0, 20, SPINOR_OP_MT_DTR_RD,
 				  SNOR_PROTO_8_8_8_DTR);
 
 	nor->cmd_ext_type = SPI_NOR_EXT_REPEAT;
-	nor->params->rdsr_dummy = 8;
-	nor->params->rdsr_addr_nbytes = 0;
+	nor->params[0]->rdsr_dummy = 8;
+	nor->params[0]->rdsr_addr_nbytes = 0;
 
 	/*
 	 * The BFPT quad enable field is set to a reserved value so the quad
 	 * enable function is ignored by spi_nor_parse_bfpt(). Make sure we
 	 * disable it.
 	 */
-	nor->params->quad_enable = NULL;
+	nor->params[0]->quad_enable = NULL;
 }
 
 static const struct spi_nor_fixups mt35xu512aba_fixups = {
@@ -336,8 +336,8 @@ static int micron_st_nor_read_fsr(struct spi_nor *nor, u8 *fsr)
 		struct spi_mem_op op = MICRON_ST_RDFSR_OP(fsr);
 
 		if (nor->reg_proto == SNOR_PROTO_8_8_8_DTR) {
-			op.addr.nbytes = nor->params->rdsr_addr_nbytes;
-			op.dummy.nbytes = nor->params->rdsr_dummy;
+			op.addr.nbytes = nor->params[0]->rdsr_addr_nbytes;
+			op.dummy.nbytes = nor->params[0]->rdsr_dummy;
 			/*
 			 * We don't want to read only one byte in DTR mode. So,
 			 * read 2 and then discard the second byte.
@@ -442,14 +442,14 @@ static void micron_st_nor_default_init(struct spi_nor *nor)
 {
 	nor->flags |= SNOR_F_HAS_LOCK;
 	nor->flags &= ~SNOR_F_HAS_16BIT_SR;
-	nor->params->quad_enable = NULL;
-	nor->params->set_4byte_addr_mode = micron_st_nor_set_4byte_addr_mode;
+	nor->params[0]->quad_enable = NULL;
+	nor->params[0]->set_4byte_addr_mode = micron_st_nor_set_4byte_addr_mode;
 }
 
 static void micron_st_nor_late_init(struct spi_nor *nor)
 {
 	if (nor->info->mfr_flags & USE_FSR)
-		nor->params->ready = micron_st_nor_ready;
+		nor->params[0]->ready = micron_st_nor_ready;
 }
 
 static const struct spi_nor_fixups micron_st_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/otp.c b/drivers/mtd/spi-nor/otp.c
index 00ab0d2d6d2f..fc5d85652b59 100644
--- a/drivers/mtd/spi-nor/otp.c
+++ b/drivers/mtd/spi-nor/otp.c
@@ -11,8 +11,8 @@
 
 #include "core.h"
 
-#define spi_nor_otp_region_len(nor) ((nor)->params->otp.org->len)
-#define spi_nor_otp_n_regions(nor) ((nor)->params->otp.org->n_regions)
+#define spi_nor_otp_region_len(nor) ((nor)->params[0]->otp.org->len)
+#define spi_nor_otp_n_regions(nor) ((nor)->params[0]->otp.org->n_regions)
 
 /**
  * spi_nor_otp_read_secr() - read security register
@@ -222,7 +222,7 @@ int spi_nor_otp_is_locked_sr2(struct spi_nor *nor, unsigned int region)
 
 static loff_t spi_nor_otp_region_start(const struct spi_nor *nor, unsigned int region)
 {
-	const struct spi_nor_otp_organization *org = nor->params->otp.org;
+	const struct spi_nor_otp_organization *org = nor->params[0]->otp.org;
 
 	return org->base + region * org->offset;
 }
@@ -247,7 +247,7 @@ static int spi_nor_mtd_otp_info(struct mtd_info *mtd, size_t len,
 				size_t *retlen, struct otp_info *buf)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	const struct spi_nor_otp_ops *ops = nor->params[0]->otp.ops;
 	unsigned int n_regions = spi_nor_otp_n_regions(nor);
 	unsigned int i;
 	int ret, locked;
@@ -284,7 +284,7 @@ static int spi_nor_mtd_otp_info(struct mtd_info *mtd, size_t len,
 static int spi_nor_mtd_otp_range_is_locked(struct spi_nor *nor, loff_t ofs,
 					   size_t len)
 {
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	const struct spi_nor_otp_ops *ops = nor->params[0]->otp.ops;
 	unsigned int region;
 	int locked;
 
@@ -309,7 +309,7 @@ static int spi_nor_mtd_otp_read_write(struct mtd_info *mtd, loff_t ofs,
 				      const u8 *buf, bool is_write)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	const struct spi_nor_otp_ops *ops = nor->params[0]->otp.ops;
 	const size_t rlen = spi_nor_otp_region_len(nor);
 	loff_t rstart, rofs;
 	unsigned int region;
@@ -395,7 +395,7 @@ static int spi_nor_mtd_otp_write(struct mtd_info *mtd, loff_t to, size_t len,
 static int spi_nor_mtd_otp_erase(struct mtd_info *mtd, loff_t from, size_t len)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	const struct spi_nor_otp_ops *ops = nor->params[0]->otp.ops;
 	const size_t rlen = spi_nor_otp_region_len(nor);
 	unsigned int region;
 	loff_t rstart;
@@ -448,7 +448,7 @@ static int spi_nor_mtd_otp_erase(struct mtd_info *mtd, loff_t from, size_t len)
 static int spi_nor_mtd_otp_lock(struct mtd_info *mtd, loff_t from, size_t len)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	const struct spi_nor_otp_ops *ops = nor->params[0]->otp.ops;
 	const size_t rlen = spi_nor_otp_region_len(nor);
 	unsigned int region;
 	int ret;
@@ -484,7 +484,7 @@ void spi_nor_set_mtd_otp_ops(struct spi_nor *nor)
 {
 	struct mtd_info *mtd = &nor->mtd;
 
-	if (!nor->params->otp.ops)
+	if (!nor->params[0]->otp.ops)
 		return;
 
 	if (WARN_ON(!is_power_of_2(spi_nor_otp_region_len(nor))))
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 2257f1b4c2e2..206251c193db 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -432,7 +432,7 @@ static void spi_nor_regions_sort_erase_types(struct spi_nor_erase_map *map)
 static int spi_nor_parse_bfpt(struct spi_nor *nor,
 			      const struct sfdp_parameter_header *bfpt_header)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	struct spi_nor_erase_map *map = &params->erase_map;
 	struct spi_nor_erase_type *erase_type = map->erase_type;
 	struct sfdp_bfpt bfpt;
@@ -655,7 +655,7 @@ static u8 spi_nor_smpt_addr_nbytes(const struct spi_nor *nor, const u32 settings
 		return 4;
 	case SMPT_CMD_ADDRESS_LEN_USE_CURRENT:
 	default:
-		return nor->params->addr_mode_nbytes;
+		return nor->params[0]->addr_mode_nbytes;
 	}
 }
 
@@ -807,7 +807,7 @@ spi_nor_region_check_overlay(struct spi_nor_erase_region *region,
 static int spi_nor_init_non_uniform_erase_map(struct spi_nor *nor,
 					      const u32 *smpt)
 {
-	struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_erase_map *map = &nor->params[0]->erase_map;
 	struct spi_nor_erase_type *erase = map->erase_type;
 	struct spi_nor_erase_region *region;
 	u64 offset;
@@ -925,7 +925,7 @@ static int spi_nor_parse_smpt(struct spi_nor *nor,
 	if (ret)
 		goto out;
 
-	spi_nor_regions_sort_erase_types(&nor->params->erase_map);
+	spi_nor_regions_sort_erase_types(&nor->params[0]->erase_map);
 	/* fall through */
 out:
 	kfree(smpt);
@@ -965,7 +965,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 		{ 0u /* not used */,		BIT(11) },
 		{ 0u /* not used */,		BIT(12) },
 	};
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 	struct spi_nor_pp_command *params_pp = params->page_programs;
 	struct spi_nor_erase_map *map = &params->erase_map;
 	struct spi_nor_erase_type *erase_type = map->erase_type;
@@ -1150,14 +1150,14 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 
 	 /* Set the Read Status Register dummy cycles and dummy address bytes. */
 	if (dwords[0] & PROFILE1_DWORD1_RDSR_DUMMY)
-		nor->params->rdsr_dummy = 8;
+		nor->params[0]->rdsr_dummy = 8;
 	else
-		nor->params->rdsr_dummy = 4;
+		nor->params[0]->rdsr_dummy = 4;
 
 	if (dwords[0] & PROFILE1_DWORD1_RDSR_ADDR_BYTES)
-		nor->params->rdsr_addr_nbytes = 4;
+		nor->params[0]->rdsr_addr_nbytes = 4;
 	else
-		nor->params->rdsr_addr_nbytes = 0;
+		nor->params[0]->rdsr_addr_nbytes = 0;
 
 	/*
 	 * We don't know what speed the controller is running at. Find the
@@ -1183,7 +1183,7 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	dummy = round_up(dummy, 2);
 
 	/* Update the fast read settings. */
-	spi_nor_set_read_settings(&nor->params->reads[SNOR_CMD_READ_8_8_8_DTR],
+	spi_nor_set_read_settings(&nor->params[0]->reads[SNOR_CMD_READ_8_8_8_DTR],
 				  0, dummy, opcode,
 				  SNOR_PROTO_8_8_8_DTR);
 
diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index 0150049007be..8c3ff2921dce 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -132,7 +132,7 @@ static int cypress_nor_octal_dtr_dis(struct spi_nor *nor)
 static int cypress_nor_quad_enable_volatile(struct spi_nor *nor)
 {
 	struct spi_mem_op op;
-	u8 addr_mode_nbytes = nor->params->addr_mode_nbytes;
+	u8 addr_mode_nbytes = nor->params[0]->addr_mode_nbytes;
 	u8 cfr1v_written;
 	int ret;
 
@@ -200,9 +200,9 @@ static int cypress_nor_set_page_size(struct spi_nor *nor)
 		return ret;
 
 	if (nor->bouncebuf[0] & SPINOR_REG_CYPRESS_CFR3V_PGSZ)
-		nor->params->page_size = 512;
+		nor->params[0]->page_size = 512;
 	else
-		nor->params->page_size = 256;
+		nor->params[0]->page_size = 256;
 
 	return 0;
 }
@@ -213,7 +213,7 @@ s25hx_t_post_bfpt_fixup(struct spi_nor *nor,
 			const struct sfdp_bfpt *bfpt)
 {
 	/* Replace Quad Enable with volatile version */
-	nor->params->quad_enable = cypress_nor_quad_enable_volatile;
+	nor->params[0]->quad_enable = cypress_nor_quad_enable_volatile;
 
 	return cypress_nor_set_page_size(nor);
 }
@@ -221,7 +221,7 @@ s25hx_t_post_bfpt_fixup(struct spi_nor *nor,
 static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 {
 	struct spi_nor_erase_type *erase_type =
-					nor->params->erase_map.erase_type;
+					nor->params[0]->erase_map.erase_type;
 	unsigned int i;
 
 	/*
@@ -244,7 +244,7 @@ static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 
 static void s25hx_t_late_init(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = nor->params[0];
 
 	/* Fast Read 4B requires mode cycles */
 	params->reads[SNOR_CMD_READ_FAST].num_mode_clocks = 8;
@@ -277,8 +277,8 @@ static int cypress_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 
 static void s28hs512t_default_init(struct spi_nor *nor)
 {
-	nor->params->octal_dtr_enable = cypress_nor_octal_dtr_enable;
-	nor->params->writesize = 16;
+	nor->params[0]->octal_dtr_enable = cypress_nor_octal_dtr_enable;
+	nor->params[0]->writesize = 16;
 }
 
 static void s28hs512t_post_sfdp_fixup(struct spi_nor *nor)
@@ -287,18 +287,18 @@ static void s28hs512t_post_sfdp_fixup(struct spi_nor *nor)
 	 * On older versions of the flash the xSPI Profile 1.0 table has the
 	 * 8D-8D-8D Fast Read opcode as 0x00. But it actually should be 0xEE.
 	 */
-	if (nor->params->reads[SNOR_CMD_READ_8_8_8_DTR].opcode == 0)
-		nor->params->reads[SNOR_CMD_READ_8_8_8_DTR].opcode =
+	if (nor->params[0]->reads[SNOR_CMD_READ_8_8_8_DTR].opcode == 0)
+		nor->params[0]->reads[SNOR_CMD_READ_8_8_8_DTR].opcode =
 			SPINOR_OP_CYPRESS_RD_FAST;
 
 	/* This flash is also missing the 4-byte Page Program opcode bit. */
-	spi_nor_set_pp_settings(&nor->params->page_programs[SNOR_CMD_PP],
+	spi_nor_set_pp_settings(&nor->params[0]->page_programs[SNOR_CMD_PP],
 				SPINOR_OP_PP_4B, SNOR_PROTO_1_1_1);
 	/*
 	 * Since xSPI Page Program opcode is backward compatible with
 	 * Legacy SPI, use Legacy SPI opcode there as well.
 	 */
-	spi_nor_set_pp_settings(&nor->params->page_programs[SNOR_CMD_PP_8_8_8_DTR],
+	spi_nor_set_pp_settings(&nor->params[0]->page_programs[SNOR_CMD_PP_8_8_8_DTR],
 				SPINOR_OP_PP_4B, SNOR_PROTO_8_8_8_DTR);
 
 	/*
@@ -306,7 +306,7 @@ static void s28hs512t_post_sfdp_fixup(struct spi_nor *nor)
 	 * address bytes needed for Read Status Register command as 0 but the
 	 * actual value for that is 4.
 	 */
-	nor->params->rdsr_addr_nbytes = 4;
+	nor->params[0]->rdsr_addr_nbytes = 4;
 }
 
 static int s28hs512t_post_bfpt_fixup(struct spi_nor *nor,
@@ -333,7 +333,7 @@ s25fs_s_nor_post_bfpt_fixups(struct spi_nor *nor,
 	 * of 256 bytes.  Overwrite the page size advertised by BFPT
 	 * to get the writes working.
 	 */
-	nor->params->page_size = 256;
+	nor->params[0]->page_size = 256;
 
 	return 0;
 }
@@ -524,7 +524,7 @@ static int spansion_nor_sr_ready_and_clear(struct spi_nor *nor)
 
 static void spansion_nor_late_init(struct spi_nor *nor)
 {
-	if (nor->params->size > SZ_16M) {
+	if (nor->params[0]->size > SZ_16M) {
 		nor->flags |= SNOR_F_4B_OPCODES;
 		/* No small sector erase for 4-byte command set */
 		nor->erase_opcode = SPINOR_OP_SE;
@@ -532,7 +532,7 @@ static void spansion_nor_late_init(struct spi_nor *nor)
 	}
 
 	if (nor->info->mfr_flags & USE_CLSR)
-		nor->params->ready = spansion_nor_sr_ready_and_clear;
+		nor->params[0]->ready = spansion_nor_sr_ready_and_clear;
 }
 
 static const struct spi_nor_fixups spansion_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/sst.c b/drivers/mtd/spi-nor/sst.c
index 63bcc97bf978..1921f247a6a0 100644
--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -23,7 +23,7 @@ static int sst26vf_nor_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 	int ret;
 
 	/* We only support unlocking the entire flash array. */
-	if (ofs != 0 || len != nor->params->size)
+	if (ofs != 0 || len != nor->params[0]->size)
 		return -EINVAL;
 
 	ret = spi_nor_read_cr(nor, nor->bouncebuf);
@@ -51,7 +51,7 @@ static const struct spi_nor_locking_ops sst26vf_nor_locking_ops = {
 
 static void sst26vf_nor_late_init(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &sst26vf_nor_locking_ops;
+	nor->params[0]->locking_ops = &sst26vf_nor_locking_ops;
 }
 
 static const struct spi_nor_fixups sst26vf_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/swp.c b/drivers/mtd/spi-nor/swp.c
index 1f178313ba8f..adbd1519f063 100644
--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -340,7 +340,7 @@ static const struct spi_nor_locking_ops spi_nor_sr_locking_ops = {
 
 void spi_nor_init_default_locking_ops(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &spi_nor_sr_locking_ops;
+	nor->params[0]->locking_ops = &spi_nor_sr_locking_ops;
 }
 
 static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
@@ -352,7 +352,7 @@ static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	if (ret)
 		return ret;
 
-	ret = nor->params->locking_ops->lock(nor, ofs, len);
+	ret = nor->params[0]->locking_ops->lock(nor, ofs, len);
 
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
@@ -367,7 +367,7 @@ static int spi_nor_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	if (ret)
 		return ret;
 
-	ret = nor->params->locking_ops->unlock(nor, ofs, len);
+	ret = nor->params[0]->locking_ops->unlock(nor, ofs, len);
 
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
@@ -382,7 +382,7 @@ static int spi_nor_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	if (ret)
 		return ret;
 
-	ret = nor->params->locking_ops->is_locked(nor, ofs, len);
+	ret = nor->params[0]->locking_ops->is_locked(nor, ofs, len);
 
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
@@ -409,7 +409,7 @@ void spi_nor_try_unlock_all(struct spi_nor *nor)
 
 	dev_dbg(nor->dev, "Unprotecting entire flash array\n");
 
-	ret = spi_nor_unlock(&nor->mtd, 0, nor->params->size);
+	ret = spi_nor_unlock(&nor->mtd, 0, nor->params[0]->size);
 	if (ret)
 		dev_dbg(nor->dev, "Failed to unlock the entire flash memory array\n");
 }
@@ -418,7 +418,7 @@ void spi_nor_set_mtd_locking_ops(struct spi_nor *nor)
 {
 	struct mtd_info *mtd = &nor->mtd;
 
-	if (!nor->params->locking_ops)
+	if (!nor->params[0]->locking_ops)
 		return;
 
 	mtd->_lock = spi_nor_lock;
diff --git a/drivers/mtd/spi-nor/winbond.c b/drivers/mtd/spi-nor/winbond.c
index ffaa24055259..ac1bd43219f4 100644
--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -215,13 +215,13 @@ static const struct spi_nor_otp_ops winbond_nor_otp_ops = {
 
 static void winbond_nor_default_init(struct spi_nor *nor)
 {
-	nor->params->set_4byte_addr_mode = winbond_nor_set_4byte_addr_mode;
+	nor->params[0]->set_4byte_addr_mode = winbond_nor_set_4byte_addr_mode;
 }
 
 static void winbond_nor_late_init(struct spi_nor *nor)
 {
-	if (nor->params->otp.org->n_regions)
-		nor->params->otp.ops = &winbond_nor_otp_ops;
+	if (nor->params[0]->otp.org->n_regions)
+		nor->params[0]->otp.ops = &winbond_nor_otp_ops;
 }
 
 static const struct spi_nor_fixups winbond_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/xilinx.c b/drivers/mtd/spi-nor/xilinx.c
index 5723157739fc..b6531cdbf386 100644
--- a/drivers/mtd/spi-nor/xilinx.c
+++ b/drivers/mtd/spi-nor/xilinx.c
@@ -55,7 +55,7 @@ static const struct flash_info xilinx_nor_parts[] = {
  */
 static u32 s3an_nor_convert_addr(struct spi_nor *nor, u32 addr)
 {
-	u32 page_size = nor->params->page_size;
+	u32 page_size = nor->params[0]->page_size;
 	u32 offset, page;
 
 	offset = addr % page_size;
@@ -140,14 +140,14 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 	 */
 	if (nor->bouncebuf[0] & XSR_PAGESIZE) {
 		/* Flash in Power of 2 mode */
-		page_size = (nor->params->page_size == 264) ? 256 : 512;
-		nor->params->page_size = page_size;
+		page_size = (nor->params[0]->page_size == 264) ? 256 : 512;
+		nor->params[0]->page_size = page_size;
 		nor->mtd.writebufsize = page_size;
-		nor->params->size = 8 * page_size * nor->info->n_sectors;
+		nor->params[0]->size = 8 * page_size * nor->info->n_sectors;
 		nor->mtd.erasesize = 8 * page_size;
 	} else {
 		/* Flash in Default addressing mode */
-		nor->params->convert_addr = s3an_nor_convert_addr;
+		nor->params[0]->convert_addr = s3an_nor_convert_addr;
 		nor->mtd.erasesize = nor->info->sector_size;
 	}
 
@@ -156,8 +156,8 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 
 static void xilinx_nor_late_init(struct spi_nor *nor)
 {
-	nor->params->setup = xilinx_nor_setup;
-	nor->params->ready = xilinx_nor_sr_ready;
+	nor->params[0]->setup = xilinx_nor_setup;
+	nor->params[0]->ready = xilinx_nor_sr_ready;
 }
 
 static const struct spi_nor_fixups xilinx_nor_fixups = {
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 42218a1164f6..4ea32fb6c759 100644
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
@@ -397,7 +403,7 @@ struct spi_nor {
 
 	const struct spi_nor_controller_ops *controller_ops;
 
-	struct spi_nor_flash_parameter *params;
+	struct spi_nor_flash_parameter *params[SNOR_FLASH_CNT_MAX];
 
 	struct {
 		struct spi_mem_dirmap_desc *rdesc;
-- 
2.17.1

