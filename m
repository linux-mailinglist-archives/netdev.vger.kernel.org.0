Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF61600F05
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 14:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJQMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 08:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJQMTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 08:19:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9417E32AB5;
        Mon, 17 Oct 2022 05:18:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFszHe6WBrs3JeeDKrwQmEBjYLHEz6duu0hfIbFRfx83bWvSkJ8UUx8AgRUFjUDDvLKt1w3B0Esk/9Z8VdGT1XgeNxn3FryU8mgHitBOOuQJzz9k19t/KuP3KK/8SqwlTJJHP0XE0GJ5Ejf6VEEkiwwJDEIOwMU2I3ZL/GO/M7AlX1MopEt9YakdC8pvv+yZCRYGnU/zTET3bsNbtsfCJOjZZooEeqTbGwICIYRPuD7lM4jPTWD6iIWMPINTKjRaaE8qWZ92mjciVbRlG5gML/t9evSLlu3YrSvNjhZkMWV1M2dCqcXc2mccAttCRycPAkfejzBLbVLvSsS/G2iByg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ReI+qCtEX/SVBrpWY5Mpd/A7aaRF/i4K2IsEVB/aTiE=;
 b=EJHM2lMhhitz2zhYZfwEXswUuZoJzXf3GatnOQy1FHN42l5prxypjxWJSbnbc2aMwSXNm/PXT/vvHD775IycJTe8632hzNtcAw7Wqq6GB0SHyRgUKXEFvzafqb0Bal4PeIWpLOi1IRACeuiZf1057cI2kZI1gNry93z1cDg3IbQ4q/gLSArRzcEiNlAdzADjU1hSC0P/1NsfRNoVOdj/D/3J3UgpHiNg7lQlC5HrAPCWvqAlPfv/9urUvU5LLyST4gBbc45WyYs0Dv34gIqo3fsOwgmlazD/kyVp9SwQE4s4+rT+ce7plhIW+tXkTexsEqkAGhgAHczExYNUDBc3Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ReI+qCtEX/SVBrpWY5Mpd/A7aaRF/i4K2IsEVB/aTiE=;
 b=UFVXfnXlDUNd5KNGa+XFM2iODiaq2HTfAd6w0FR357F/mhQFGbP/2fMrrq9lT7ZcPobyIQpAzqWrq8MuRuFkI6gVSojYBtcU9VlQYvv9IJHnX+KY6QgPUJHCSes/E+/g+h6srHjp3vmvSx7h5FaHAH0n6EWkK0IxUU4iI6Rv9WQ=
Received: from MW4P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::20)
 by CH2PR12MB4037.namprd12.prod.outlook.com (2603:10b6:610:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Mon, 17 Oct
 2022 12:16:58 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::df) by MW4P222CA0015.outlook.office365.com
 (2603:10b6:303:114::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Mon, 17 Oct 2022 12:16:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Mon, 17 Oct 2022 12:16:57 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:16:55 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 07:16:54 -0500
Received: from xhdlakshmis40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Mon, 17 Oct 2022 07:16:32 -0500
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
Subject: [PATCH 09/10] mtd: spi-nor: Add parallel memories support in spi-nor
Date:   Mon, 17 Oct 2022 17:42:48 +0530
Message-ID: <20221017121249.19061-10-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
References: <20221017121249.19061-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|CH2PR12MB4037:EE_
X-MS-Office365-Filtering-Correlation-Id: 9743319b-0736-4896-99d8-08dab0397ca3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TiVDlF061l6+O/NQ2qlOCgDmD9mEQFknPBmxbkGB1qDWWheKzoZqjr43A8/W+e0pdJwRs2fLs+I6hc6mTrap3Poxaog0ujpEZ7JetQaXfVZ8NCjSgvjLPzB/5AJ8X/kzXBfHU+xqxxDKfkgavEfBwM1WniCopD3kC0EX858enOlqOjUkbeqJbXiOA7Z0fhynZqougNWYyN1qpdCVtSkpvSEKFfj+XLtWNpxk/BpmYYhNET9BucIc2fu2h0ujfe3DGeRruXxYomXQNTLyeTmKXUWUFMj0NDDW8qSF//aw7P5z0LXGJqXCQd5TtN749MQSxM1yyvIlRiHuk1tq9IMhh7SfMSoCCb5wLDi5cq846M7EzlmGq23L0UWx6aVGWjIe55Rqi4s90v9z3wBauwVRGZbYS/lkXiSjU6+IbciNqE0phLLXYGnoZo0Wf+mQcjNgXczaiCAnFDYHogaYwKCtRnJbVTj/2N3I0amnCZvhU6QkV+8O8mzmfo4j3TaD36F32Sy0+qKOo2lUU8yE87kSWK5FrmMtp1gz6ikKJE2za9yC1a8naa+2ln26dJctpSRXdgUzBXCJbR988Fr1RrSEmulMMrra3VGQ13NmNLNSCn94eFZjZKdmni6NOUqj5oCG41SCrBEDIwIbEJDB5etqPZ/zvPf2Q1irw24zavbLHBc9/urc/nA8w9Eu4qoweflZRMdVvGLcP0zVdJNMHE6OO57i0YsmkSh/6ReiE5sLU0qak7JWX+kUYrODuw7Xr25/ipsoKD6YmD2s8z5LjfWlpwPJ5ewSJgiEecuanhts48n37liYf+tmMCbSZbed5eeu60w5NAJ8i+Hr7RX3cFwGqgmJ0h5FdaVELlySXerQPNe6TkYYO7qWUyWcKFnPvt8r9NqKTu8SllazOB7RfUfWxQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(336012)(426003)(2616005)(47076005)(186003)(1076003)(83380400001)(921005)(356005)(81166007)(86362001)(36860700001)(82740400003)(30864003)(7406005)(7416002)(5660300002)(7336002)(7366002)(2906002)(41300700001)(8936002)(4326008)(82310400005)(40480700001)(8676002)(40460700003)(6666004)(478600001)(26005)(316002)(70206006)(70586007)(54906003)(110136005)(36756003)(36900700001)(2101003)(41080700001)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 12:16:57.5192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9743319b-0736-4896-99d8-08dab0397ca3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4037
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/mtd/spi-nor/core.c      | 455 +++++++++++++++++++++++---------
 drivers/mtd/spi-nor/core.h      |   4 +
 drivers/mtd/spi-nor/micron-st.c |   5 +
 3 files changed, 344 insertions(+), 120 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 3801890c17e6..8b434115a92e 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -463,17 +463,29 @@ int spi_nor_read_sr(struct spi_nor *nor, u8 *sr)
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
 
@@ -1450,12 +1462,108 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
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
+			while (cur_cs_num < SNOR_FLASH_CNT_MAX && (nor->params[cur_cs_num])) {
+				nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
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
+					      (unsigned long)(nor->params[cur_cs_num]->size /
+							      SZ_2M));
+				ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
+				if (ret)
+					goto erase_err;
+				cur_cs_num++;
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
+			       (addr > sz - 1) && (nor->params[cur_cs_num]))
+				sz += nor->params[++cur_cs_num]->size;
+
+			while (len) {
+				nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+				ret = spi_nor_write_enable(nor);
+				if (ret)
+					goto erase_err;
+
+				offset = addr;
+				if (nor->flags & SNOR_F_HAS_STACKED)
+					offset -= (sz - nor->params[cur_cs_num]->size);
+
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
+				if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1))
+					sz += nor->params[++cur_cs_num]->size;
+			}
+
+		/* erase multiple sectors */
+		} else {
+			u64 erase_len = 0;
+
+			/* Determine the flash from which the operation need to start */
+			while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
+			       (addr > sz - 1) && (nor->params[cur_cs_num]))
+				sz += nor->params[++cur_cs_num]->size;
+			/* perform multi sector erase onec per Flash*/
+			while (len) {
+				erase_len = (len > (sz - addr)) ? (sz - addr) : len;
+				offset = addr;
+				nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+				if (nor->flags & SNOR_F_HAS_STACKED)
+					offset -= (sz - nor->params[cur_cs_num]->size);
+				ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
+				if (ret)
+					goto erase_err;
+				len -= erase_len;
+				addr += erase_len;
+				sz += nor->params[++cur_cs_num]->size;
+			}
+		}
+	} else {
+		nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+
+		/* whole-chip erase? */
+		if (len == mtd->size && !(nor->flags &
+					  SNOR_F_NO_OP_CHIP_ERASE)) {
+			unsigned long timeout;
 
-		while (cur_cs_num < SNOR_FLASH_CNT_MAX && (nor->params[cur_cs_num])) {
-			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
 			ret = spi_nor_write_enable(nor);
 			if (ret)
 				goto erase_err;
@@ -1472,77 +1580,45 @@ static int spi_nor_erase(struct mtd_info *mtd, struct erase_info *instr)
 			 */
 			timeout = max(CHIP_ERASE_2MB_READY_WAIT_JIFFIES,
 				      CHIP_ERASE_2MB_READY_WAIT_JIFFIES *
-				      (unsigned long)(nor->params[cur_cs_num]->size / SZ_2M));
+				      (unsigned long)(mtd->size / SZ_2M));
 			ret = spi_nor_wait_till_ready_with_timeout(nor, timeout);
 			if (ret)
 				goto erase_err;
-			cur_cs_num++;
-		}
 
-	/* REVISIT in some cases we could speed up erasing large regions
-	 * by using SPINOR_OP_SE instead of SPINOR_OP_BE_4K.  We may have set up
-	 * to use "small sector erase", but that's not always optimal.
-	 */
-
-	/* "sector"-at-a-time erase */
-	} else if (spi_nor_has_uniform_erase(nor)) {
-		/* Determine the flash from which the operation need to start */
-		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
-		       (addr > sz - 1) && (nor->params[cur_cs_num]))
-			sz += nor->params[++cur_cs_num]->size;
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
-			if (nor->flags & SNOR_F_HAS_STACKED)
-				offset -= (sz - nor->params[cur_cs_num]->size);
+				offset = addr / 2;
 
-			ret = spi_nor_erase_sector(nor, offset);
-			if (ret)
-				goto erase_err;
+				ret = spi_nor_erase_sector(nor, offset);
+				if (ret)
+					goto erase_err;
 
-			ret = spi_nor_wait_till_ready(nor);
-			if (ret)
-				goto erase_err;
+				ret = spi_nor_wait_till_ready(nor);
+				if (ret)
+					goto erase_err;
 
-			addr += mtd->erasesize;
-			len -= mtd->erasesize;
-
-			/*
-			 * Flash cross over condition in stacked mode.
-			 */
-			if ((nor->flags & SNOR_F_HAS_STACKED) && (addr > sz - 1))
-				sz += nor->params[++cur_cs_num]->size;
-		}
-
-	/* erase multiple sectors */
-	} else {
-		u64 erase_len = 0;
+				offset += mtd->erasesize;
+				len -= mtd->erasesize;
+			}
 
-		/* Determine the flash from which the operation need to start */
-		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) &&
-		       (addr > sz - 1) && (nor->params[cur_cs_num]))
-			sz += nor->params[++cur_cs_num]->size;
-		/* perform multi sector erase onec per Flash*/
-		while (len) {
-			erase_len = (len > (sz - addr)) ? (sz - addr) : len;
-			offset = addr;
-			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-			if (nor->flags & SNOR_F_HAS_STACKED)
-				offset -= (sz - nor->params[cur_cs_num]->size);
-			ret = spi_nor_erase_multi_sectors(nor, offset, erase_len);
+		/* erase multiple sectors */
+		} else {
+			offset = addr / 2;
+			ret = spi_nor_erase_multi_sectors(nor, offset, len);
 			if (ret)
 				goto erase_err;
-			len -= erase_len;
-			addr += erase_len;
-			sz += nor->params[++cur_cs_num]->size;
 		}
 	}
-
 	ret = spi_nor_write_disable(nor);
 
 erase_err:
@@ -1719,27 +1795,52 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 	ssize_t ret, read_len;
 	u32 cur_cs_num = 0;
 	u64 sz = nor->params[cur_cs_num]->size;
+	u_char *readbuf;
+	bool is_ofst_odd = false;
 
 	dev_dbg(nor->dev, "from 0x%08x, len %zd\n", (u32)from, len);
 
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
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) &&
+		       (nor->params[cur_cs_num]))
+			sz += nor->params[++cur_cs_num]->size;
+	}
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
 		return ret;
 
-	/* Determine the flash from which the operation need to start */
-	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (from > sz - 1) &&
-	       (nor->params[cur_cs_num]))
-		sz += nor->params[++cur_cs_num]->size;
 	while (len) {
 		loff_t addr = from;
 
-		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-		read_len = (len > (sz - addr)) ? (sz - addr) : len;
-		addr -= (sz - nor->params[cur_cs_num]->size);
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			read_len = len;
+			addr /= 2;
+		} else {
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+			read_len = (len > (sz - addr)) ? (sz - addr) : len;
+			addr -= (sz - nor->params[cur_cs_num]->size);
+		}
 
 		addr = spi_nor_convert_addr(nor, addr);
 
-		ret = spi_nor_read_data(nor, addr, len, buf);
+		ret = spi_nor_read_data(nor, addr, read_len, readbuf);
 		if (ret == 0) {
 			/* We shouldn't see 0-length reads */
 			ret = -EIO;
@@ -1749,8 +1850,15 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 			goto read_err;
 
 		WARN_ON(ret > read_len);
-		*retlen += ret;
+		if (is_ofst_odd) {
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
 
@@ -1765,6 +1873,9 @@ static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 	ret = 0;
 
 read_err:
+	if (is_ofst_odd)
+		kfree(readbuf);
+
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
 }
@@ -1786,11 +1897,36 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 
 	dev_dbg(nor->dev, "to 0x%08x, len %zd\n", (u32)to, len);
 
-	/* Determine the flash from which the operation need to start */
-	while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) &&
-	       (nor->params[cur_cs_num]))
-		sz += nor->params[++cur_cs_num]->size;
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
+		while ((cur_cs_num < SNOR_FLASH_CNT_MAX) && (to > sz - 1) &&
+		       (nor->params[cur_cs_num]))
+			sz += nor->params[++cur_cs_num]->size;
+	}
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
 		return ret;
@@ -1814,8 +1950,13 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* the size of data remaining on the first page */
 		page_remain = min_t(size_t, page_size - page_offset, len - i);
 
-		nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
-		addr -= (sz - nor->params[cur_cs_num]->size);
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			addr /= 2;
+		} else {
+			nor->spimem->spi->cs_index_mask = 0x01 << cur_cs_num;
+			addr -= (sz - nor->params[cur_cs_num]->size);
+		}
 
 		addr = spi_nor_convert_addr(nor, addr);
 
@@ -2240,7 +2381,15 @@ static int spi_nor_select_erase(struct spi_nor *nor)
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
 
@@ -2258,7 +2407,15 @@ static int spi_nor_select_erase(struct spi_nor *nor)
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
 
@@ -2572,11 +2729,25 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
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
 			nor->params[idx] = devm_kzalloc(nor->dev,
-							sizeof(*nor->params[0]),
-							GFP_KERNEL);
+							sizeof(*nor->params[0]), GFP_KERNEL);
 			if (nor->params[idx]) {
 				memcpy(nor->params[idx], nor->params[0], sizeof(*nor->params[0]));
 				nor->params[idx]->size = flash_size[idx];
@@ -2782,23 +2953,40 @@ static int spi_nor_quad_enable(struct spi_nor *nor)
 {
 	int err, idx;
 
-	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
-		if (nor->params[idx]) {
-			if (!nor->params[idx]->quad_enable)
-				return 0;
+	if (nor->flags & SNOR_F_HAS_PARALLEL) {
+		if (!nor->params[0]->quad_enable)
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
+		err = nor->params[0]->quad_enable(nor);
+		if (err)
+			return err;
+	} else {
+		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+			if (nor->params[idx]) {
+				if (!nor->params[idx]->quad_enable)
+					return 0;
+
+				if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
+				      spi_nor_get_protocol_width(nor->write_proto) == 4))
+					return 0;
+				/*
+				 * Set the appropriate CS index before
+				 * issuing the command.
+				 */
+				nor->spimem->spi->cs_index_mask = 0x01 << idx;
 
-			err = nor->params[idx]->quad_enable(nor);
-			if (err)
-				return err;
+				err = nor->params[idx]->quad_enable(nor);
+				if (err)
+					return err;
+			}
 		}
 	}
 	return err;
@@ -2847,16 +3035,25 @@ static int spi_nor_init(struct spi_nor *nor)
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
-			if (nor->params[idx]) {
-				/*
-				 * Select the appropriate CS index before
-				 * issuing the command.
-				 */
-				nor->spimem->spi->cs_index_mask = 0x01 << idx;
-				err = nor->params[idx]->set_4byte_addr_mode(nor, true);
-				if (err)
-					return err;
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			/*
+			 * In parallel mode both chip selects i.e., CS0 &
+			 * CS1 need to be asserted simulatneously.
+			 */
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			nor->params[0]->set_4byte_addr_mode(nor, true);
+		} else {
+			for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+				if (nor->params[idx]) {
+					/*
+					 * Select the appropriate CS index before
+					 * issuing the command.
+					 */
+					nor->spimem->spi->cs_index_mask = 0x01 << idx;
+					err = nor->params[idx]->set_4byte_addr_mode(nor, true);
+					if (err)
+						return err;
+				}
 			}
 		}
 	}
@@ -2977,14 +3174,23 @@ void spi_nor_restore(struct spi_nor *nor)
 	/* restore the addressing mode */
 	if (nor->addr_nbytes == 4 && !(nor->flags & SNOR_F_4B_OPCODES) &&
 	    nor->flags & SNOR_F_BROKEN_RESET) {
-		for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
-			if (nor->params[idx]) {
-				/*
-				 * Select the appropriate CS index before
-				 * issuing the command.
-				 */
-				nor->spimem->spi->cs_index_mask = 0x01 << idx;
-				nor->params[idx]->set_4byte_addr_mode(nor, false);
+		if (nor->flags & SNOR_F_HAS_PARALLEL) {
+			/*
+			 * In parallel mode both chip selects i.e., CS0 &
+			 * CS1 need to be asserted simulatneously.
+			 */
+			nor->spimem->spi->cs_index_mask = SPI_NOR_ENABLE_MULTI_CS;
+			nor->params[0]->set_4byte_addr_mode(nor, false);
+		} else {
+			for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
+				if (nor->params[idx]) {
+					/*
+					 * Select the appropriate CS index before
+					 * issuing the command.
+					 */
+					nor->spimem->spi->cs_index_mask = 0x01 << idx;
+					nor->params[idx]->set_4byte_addr_mode(nor, false);
+				}
 			}
 		}
 	}
@@ -3069,7 +3275,16 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 	else
 		mtd->_erase = spi_nor_erase;
 	mtd->writesize = nor->params[0]->writesize;
-	mtd->writebufsize = nor->params[0]->page_size;
+	/*
+	 * In parallel-memories the write operation is
+	 * performed on both the flashes simultaneously
+	 * one page per flash, so double the writebufsize.
+	 */
+	if (nor->flags & SNOR_F_HAS_PARALLEL)
+		mtd->writebufsize = nor->params[0]->page_size << 1;
+	else
+		mtd->writebufsize = nor->params[0]->page_size;
+
 	for (idx = 0; idx < SNOR_FLASH_CNT_MAX; idx++) {
 		if (nor->params[idx])
 			total_sz += nor->params[idx]->size;
@@ -3185,7 +3400,7 @@ static int spi_nor_create_read_dirmap(struct spi_nor *nor)
 	};
 	struct spi_mem_op *op = &info.op_tmpl;
 
-	if (nor->flags & SNOR_F_HAS_STACKED) {
+	if (nor->flags & (SNOR_F_HAS_STACKED | SNOR_F_HAS_PARALLEL)) {
 		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++)
 			info.length += nor->params[idx]->size;
 	}
@@ -3221,7 +3436,7 @@ static int spi_nor_create_write_dirmap(struct spi_nor *nor)
 	};
 	struct spi_mem_op *op = &info.op_tmpl;
 
-	if (nor->flags & SNOR_F_HAS_STACKED) {
+	if (nor->flags & (SNOR_F_HAS_STACKED | SNOR_F_HAS_PARALLEL)) {
 		for (idx = 1; idx < SNOR_FLASH_CNT_MAX; idx++)
 			info.length += nor->params[idx]->size;
 	}
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 285b7a46a1da..5c0e756c6df1 100644
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
index ad2a2e126c4a..ec1e19a0e011 100644
--- a/drivers/mtd/spi-nor/micron-st.c
+++ b/drivers/mtd/spi-nor/micron-st.c
@@ -345,6 +345,9 @@ static int micron_st_nor_read_fsr(struct spi_nor *nor, u8 *fsr)
 			op.data.nbytes = 2;
 		}
 
+		if (nor->flags & SNOR_F_HAS_PARALLEL)
+			op.data.nbytes = 2;
+
 		spi_nor_spimem_setup_op(nor, &op, nor->reg_proto);
 
 		ret = spi_mem_exec_op(nor->spimem, &op);
@@ -356,6 +359,8 @@ static int micron_st_nor_read_fsr(struct spi_nor *nor, u8 *fsr)
 	if (ret)
 		dev_dbg(nor->dev, "error %d reading FSR\n", ret);
 
+	if (nor->flags & SNOR_F_HAS_PARALLEL)
+		fsr[0] &= fsr[1];
 	return ret;
 }
 
-- 
2.17.1

