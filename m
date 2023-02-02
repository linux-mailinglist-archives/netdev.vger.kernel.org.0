Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3356B68824A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbjBBPaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjBBPaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:30:06 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94FB6A31D;
        Thu,  2 Feb 2023 07:29:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChyoQqSXhSnI7KoY5biInXOIJANssAPJrEvZH6mPHFvtP0lVOqeQidsJ4Uto1H6iquYZjLAaxDFcNqa2JU7ntt9CIYV0+A+wTqMkMObUCWZpPqoAgx0s52/VKSMFp3aUnply0g7COSTuobhfxGKlQten9DCIbEi3MDXySNM+ori5NHMEIIrY0sbF5aLACqNCumzvZHDbjV8KC+7rnpvEY0wh+StU1nFUAFXjUY9JBSDu4cZkBNeDjEMZV9+nbve1k6du4mK6lOjLD9FeZAjGpfMS0MMcfxtFsyLOcyQbnOMLiqvU/mP47ACKcWYURjbV6fpHAJYYsaJm5Gg5L7gs3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pEjyARU/iDHF4qEL808MswcLI+5ZEPTvCc976Kw1g4=;
 b=ECbHH6DIKxNnbu7Ao6TpVUFAK+561mk7hftiWheVrhrhcHvlOyaYbUdMikCftUFGbuyuqB27emkT8sbKmuwtd4dLwI6ORXiU97+CT8dKEJZmWoV5yYwiPjYxx8d+3ki/+0ybP3OFT7yxci1eeHlLFbUwnk/b5YkPCx2ZF2Gvagxhjez9G2cgIBWFaje7mnUoyqXiEocllzTJ6K5qiuA93P/A1B36vLBopjSMao5BaLib+Y9aaEKZ4gbL8+C+XyjmXtKJ4fK0d50MqPjrIAg47O2W4oqcC3TsFqKLJrpTUqM28FBL0lPd6QA5/XHMDqlHLdpfIB01oWrMesL3eITibg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pEjyARU/iDHF4qEL808MswcLI+5ZEPTvCc976Kw1g4=;
 b=HFvChiGMfTn/v0rutEii1Iz7VC8vZawQmS93vvsHzOOwopFciQroMfPUOv/t/y8UKLbhjfwEcqHzPBl5veOm3oduamJB4RksMKOZqhlwKZ29cW6djKM/7hmcrVnp1diDu9CZmx6WffJ3sdGLHjeznv/6hcYB1q5TWbNmsYwkR4E=
Received: from BLAPR03CA0135.namprd03.prod.outlook.com (2603:10b6:208:32e::20)
 by SA1PR12MB6750.namprd12.prod.outlook.com (2603:10b6:806:257::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 15:28:29 +0000
Received: from BL02EPF000108E8.namprd05.prod.outlook.com
 (2603:10b6:208:32e:cafe::d1) by BLAPR03CA0135.outlook.office365.com
 (2603:10b6:208:32e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Thu, 2 Feb 2023 15:28:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108E8.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 15:28:29 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:28:28 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 09:28:28 -0600
Received: from xhdsgoud40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 2 Feb 2023 09:28:05 -0600
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
Subject: [PATCH v3 13/13] spi: spi-zynqmp-gqspi: Add parallel memories support in GQSPI driver
Date:   Thu, 2 Feb 2023 20:52:58 +0530
Message-ID: <20230202152258.512973-14-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
References: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E8:EE_|SA1PR12MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 64e877f6-3653-4e8d-acc9-08db053222c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xGpiEMVI0Q79Sm8quNRd1PoYqX8Os2QrTQscMq54fZXySLuL5b5pypVhT9FwWTm6A8VP7CFpp1AuC3+JiGjP0zjzIqP0vyeZd9MGpGCFEx3I7SyCK4cKXlZFo8xlaVnLLLbnGg/O5reTo/v7lPPwUGXgHUOyBAJTY66fTr/SsbLyF6YqUa9WsU4KQ6Whksv3JKdG4ACqmx3HZDlmyEQZ9P2vYqIxDSpzgb3yl1Ez1WpYPU7WQoOG20L/F7uSCCjLFQopJUcTBq5f2z0EcONqSRiguyN/6nBIO6VRPo/hdapw90Drrz46kjFOm8phoINDvox4ZKMUCBFUnxN9OMXmMoomB+ybIxKWpHlSpOmxDxcfEVPeZY0dJidUgckyXU3U7RD2/u0yYGL0iCQqZr1SBWHtH4ROpjmX5CYBJJ8qbKlEgdp7It+ar2ldVuZFHg9z1j40dDoFTG2qaY1hPreqKsLZMGKk1/O6M9+qegWyG3UpdchLe6XTdTNSlgfIfkVPCgov0d5Ow1aYqio2RJxk6o9+GNkKF0KOTP7wqL7BtaUWaFwf5NhSOYY2iljvCfrAxFLI4InlWMwSn5+rk7IllvazKGbKsQQJ4MKrmSF+6AYBhNrLJsORzZW4CAhF8UzgWuDkVZTt74VGRwEyi9G+ME/CmSAYufpa8bTDfnFwDPUZK2rMObUCM3mRYj/4Ava/QJVreqb2LNwoLdjCdLU2m632Y2/AUB1UYK7QBgl0zdKBl+BzDHQgwGel0wwk1Na6st0GzkFOSyhMz1lm4HbalJaSFVoTgz7b/afIlLYjP8RzxNiECSTRue2blY1HJnMvlyTSX0s0cLcFXD85nXMJWw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(356005)(921005)(40480700001)(36756003)(36860700001)(47076005)(82310400005)(81166007)(40460700003)(426003)(82740400003)(8676002)(2906002)(4326008)(54906003)(70586007)(110136005)(7416002)(7406005)(7366002)(316002)(70206006)(6666004)(8936002)(86362001)(41300700001)(5660300002)(7276002)(7336002)(1076003)(478600001)(26005)(186003)(83380400001)(2616005)(336012)(36900700001)(41080700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 15:28:29.1575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e877f6-3653-4e8d-acc9-08db053222c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6750
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During GQSPI driver probe set ctlr->multi-cs-cap for enabling multi CS
capability of the controller. In parallel mode the controller can either
split the data between both the flash or can send the same data to both the
flashes, this is determined by the STRIPE bit. While sending commands to
the flashes the GQSPI driver send the same command to both the flashes by
resetting the STRIPE bit, but while writing/reading data to & from the
flash the GQSPI driver splits the data evenly between both the flashes by
setting the STRIPE bit.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/spi/spi-zynqmp-gqspi.c | 39 +++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 4759f704bf5c..9e44371bfda2 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/spi/spi-mem.h>
+#include <linux/mtd/spi-nor.h>
 
 /* Generic QSPI register offsets */
 #define GQSPI_CONFIG_OFST		0x00000100
@@ -192,6 +193,7 @@ struct qspi_platform_data {
  * @op_lock:		Operational lock
  * @speed_hz:          Current SPI bus clock speed in hz
  * @has_tapdelay:	Used for tapdelay register available in qspi
+ * @is_parallel:		Used for multi CS support
  */
 struct zynqmp_qspi {
 	struct spi_controller *ctlr;
@@ -214,8 +216,33 @@ struct zynqmp_qspi {
 	struct mutex op_lock;
 	u32 speed_hz;
 	bool has_tapdelay;
+	bool is_parallel;
 };
 
+/**
+ * zynqmp_gqspi_update_stripe - For GQSPI controller data stripe capabilities
+ * @op:	Pointer to mem ops
+ * Return:      Status of the data stripe
+ *
+ * Returns true if data stripe need to be enabled, else returns false
+ */
+bool zynqmp_gqspi_update_stripe(const struct spi_mem_op *op)
+{
+	if (op->cmd.opcode ==  SPINOR_OP_BE_4K ||
+	    op->cmd.opcode ==  SPINOR_OP_BE_32K ||
+	    op->cmd.opcode ==  SPINOR_OP_CHIP_ERASE ||
+	    op->cmd.opcode ==  SPINOR_OP_SE ||
+	    op->cmd.opcode ==  SPINOR_OP_BE_32K_4B ||
+	    op->cmd.opcode ==  SPINOR_OP_SE_4B ||
+	    op->cmd.opcode == SPINOR_OP_BE_4K_4B ||
+	    op->cmd.opcode ==  SPINOR_OP_WRSR ||
+	    op->cmd.opcode ==  SPINOR_OP_BRWR ||
+	    (op->cmd.opcode ==  SPINOR_OP_WRSR2 && !op->addr.nbytes))
+		return false;
+
+	return true;
+}
+
 /**
  * zynqmp_gqspi_read - For GQSPI controller read operation
  * @xqspi:	Pointer to the zynqmp_qspi structure
@@ -470,7 +497,14 @@ static void zynqmp_qspi_chipselect(struct spi_device *qspi, bool is_high)
 
 	genfifoentry |= GQSPI_GENFIFO_MODE_SPI;
 
-	if (qspi->cs_index_mask & GQSPI_SELECT_UPPER_CS) {
+	if ((qspi->cs_index_mask & GQSPI_SELECT_LOWER_CS) &&
+	    (qspi->cs_index_mask & GQSPI_SELECT_UPPER_CS)) {
+		zynqmp_gqspi_selectslave(xqspi,
+					 GQSPI_SELECT_FLASH_CS_BOTH,
+					 GQSPI_SELECT_FLASH_BUS_BOTH);
+		if (!xqspi->is_parallel)
+			xqspi->is_parallel = true;
+	} else if (qspi->cs_index_mask & GQSPI_SELECT_UPPER_CS) {
 		zynqmp_gqspi_selectslave(xqspi,
 					 GQSPI_SELECT_FLASH_CS_UPPER,
 					 GQSPI_SELECT_FLASH_BUS_LOWER);
@@ -1139,6 +1173,8 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 	}
 
 	if (op->data.nbytes) {
+		if (xqspi->is_parallel && zynqmp_gqspi_update_stripe(op))
+			genfifoentry |= GQSPI_GENFIFO_STRIPE;
 		reinit_completion(&xqspi->data_completion);
 		if (op->data.dir == SPI_MEM_DATA_OUT) {
 			xqspi->txbuf = (u8 *)op->data.buf.out;
@@ -1334,6 +1370,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
 	ctlr->dev.of_node = np;
 	ctlr->auto_runtime_pm = true;
+	ctlr->multi_cs_cap = true;
 
 	ret = devm_spi_register_controller(&pdev->dev, ctlr);
 	if (ret) {
-- 
2.25.1

