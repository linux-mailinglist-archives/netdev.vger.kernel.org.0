Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F801174E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 12:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfEBKfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 06:35:11 -0400
Received: from mail-eopbgr680076.outbound.protection.outlook.com ([40.107.68.76]:51574
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbfEBKfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 06:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fr+YiCSUCqSdr01qCa+OPyUdK/KRvRD3l436sQrkGDM=;
 b=rl+c9SSxQ+6fy3w2niPIW2CeRgojfEpuYNk4wLjUucG/jXHFZ1GaH8VSMQ25c45eD1BfqFACIflX5ahKLK19hpemOMst2IaoIMPePtm5t+Fp4SF0lf8hS93tPCRA+WcCoCg/b8sd4Iox3n25/f7MoPxY0kaCiBghO9GfkBtVKxU=
Received: from BL0PR02CA0077.namprd02.prod.outlook.com (2603:10b6:208:51::18)
 by CY1PR02MB1659.namprd02.prod.outlook.com (2a01:111:e400:529a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1835.12; Thu, 2 May
 2019 10:35:04 +0000
Received: from CY1NAM02FT004.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by BL0PR02CA0077.outlook.office365.com
 (2603:10b6:208:51::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1856.10 via Frontend
 Transport; Thu, 2 May 2019 10:35:03 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT004.mail.protection.outlook.com (10.152.74.112) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Thu, 2 May 2019 10:35:02 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93O-0004iU-Cn; Thu, 02 May 2019 03:35:02 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1hM93J-0007Vo-9T; Thu, 02 May 2019 03:34:57 -0700
Received: from xsj-pvapsmtp01 (mailhost.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x42AYtDU031041;
        Thu, 2 May 2019 03:34:55 -0700
Received: from [172.23.155.80] (helo=xhdengvm155080.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1hM93G-0007VF-NM; Thu, 02 May 2019 03:34:55 -0700
Received: by xhdengvm155080.xilinx.com (Postfix, from userid 23151)
        id E3C358141B; Thu,  2 May 2019 16:04:53 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     <herbert@gondor.apana.org.au>, <kstewart@linuxfoundation.org>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <pombredanne@nexb.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <saratcha@xilinx.com>
CC:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V3 3/4] crypto: Add Xilinx SHA3 driver
Date:   Thu, 2 May 2019 16:04:41 +0530
Message-ID: <1556793282-17346-4-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
References: <1556793282-17346-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(39860400002)(2980300002)(199004)(189003)(90966002)(11346002)(107886003)(63266004)(70206006)(476003)(126002)(478600001)(36756003)(26005)(52956003)(14444005)(2201001)(186003)(76176011)(103686004)(305945005)(50226002)(6636002)(6266002)(2616005)(81156014)(8676002)(5660300002)(356004)(6666004)(446003)(51416003)(54906003)(110136005)(106002)(8936002)(81166006)(36386004)(44832011)(70586007)(316002)(50466002)(16586007)(42186006)(486006)(336012)(2906002)(48376002)(47776003)(4326008)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR02MB1659;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb7ac2f1-4609-406d-be0e-08d6cee9d618
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:CY1PR02MB1659;
X-MS-TrafficTypeDiagnostic: CY1PR02MB1659:
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-Microsoft-Antispam-PRVS: <CY1PR02MB1659C0B04931FBB36A9FA490AF340@CY1PR02MB1659.namprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0025434D2D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: C/w3CCjEtvg2Ddg9nAVnCQu+iwA31GO60cbMVhz8c4x4zJ32qOL/CmIaO3j/jHhzEojsYNwIgGG4OKAu45W0D8sqb1o/nigawfpQ4oCbceS0zIxluKV5cTqwssoir3mO49tVFvquvc2fj6aDBiqN6GRk7PhAZvecpqMlwaYifUbvO9FqIJHMqZopMJpYCFKJySfmTn+2LWqAukcF2FWLT8fvAvBXaKW0FK9DeDE/cLzgaUGtSciROHRxitucNFSoejWtTMlUMQlCFSlCwGSocBxWow9cPLp64N8zEE/W3krZw0BQRcFGzbfHCqmcqAWURds9Sa5fhgeg4BJj5A2jBLDiqyRhlCf2nr58joq0IJNcxE+xTnhjZr/wZnXJ8meTlIQJrLMf2pPOhio5M/CveVatr5yFauDuPx4wk6eGu4Y=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2019 10:35:02.8467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7ac2f1-4609-406d-be0e-08d6cee9d618
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR02MB1659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds SHA3 driver support for the Xilinx
ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/crypto/Kconfig      |  10 ++
 drivers/crypto/Makefile     |   1 +
 drivers/crypto/zynqmp-sha.c | 240 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 251 insertions(+)
 create mode 100644 drivers/crypto/zynqmp-sha.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0be55fc..d9647a0 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -667,6 +667,16 @@ config CRYPTO_DEV_ROCKCHIP
 	  This driver interfaces with the hardware crypto accelerator.
 	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
 
+config CRYPTO_DEV_ZYNQMP_SHA3
+	tristate "Support for Xilinx ZynqMP SHA3 hw accelerator"
+	depends on ARCH_ZYNQMP || COMPILE_TEST
+	select CRYPTO_HASH
+	help
+	  Xilinx ZynqMP has SHA3 engine used for secure hash calculation.
+	  This driver interfaces with SHA3 hw engine.
+	  Select this if you want to use the ZynqMP module
+	  for SHA3 hash computation.
+
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 8e7e225..64c29fe 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -47,3 +47,4 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += hisilicon/
+obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_SHA3) += zynqmp-sha.o
diff --git a/drivers/crypto/zynqmp-sha.c b/drivers/crypto/zynqmp-sha.c
new file mode 100644
index 0000000..e8efe17
--- /dev/null
+++ b/drivers/crypto/zynqmp-sha.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Cryptographic API.
+ *
+ * Support for Xilinx ZynqMP SHA3 HW Acceleration.
+ *
+ * Copyright (c) 2018 Xilinx Inc.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/of_device.h>
+#include <linux/crypto.h>
+#include <linux/cryptohash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/algapi.h>
+#include <crypto/sha.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+
+#define ZYNQMP_SHA3_INIT	1
+#define ZYNQMP_SHA3_UPDATE	2
+#define ZYNQMP_SHA3_FINAL	4
+
+static const struct zynqmp_eemi_ops *eemi_ops;
+struct zynqmp_sha_dev *sha_dd;
+
+struct zynqmp_sha_reqctx {
+	struct zynqmp_sha_dev	*dd;
+	unsigned long		flags;
+};
+
+struct zynqmp_sha_ctx {
+	struct zynqmp_sha_dev	*dd;
+	unsigned long		flags;
+};
+
+struct zynqmp_sha_dev {
+	struct device		*dev;
+	int			err;
+
+	unsigned long		flags;
+	struct ahash_request	*req;
+};
+
+static int zynqmp_sha_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct zynqmp_sha_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct zynqmp_sha_reqctx *ctx = ahash_request_ctx(req);
+	struct zynqmp_sha_dev *dd = sha_dd;
+	int ret;
+
+	if (!eemi_ops->sha_hash)
+		return -ENOTSUPP;
+
+	if (!tctx->dd)
+		tctx->dd = dd;
+	else
+		dd = tctx->dd;
+
+	ctx->dd = dd;
+	dev_dbg(dd->dev, "init: digest size: %d\n",
+		crypto_ahash_digestsize(tfm));
+
+	ret = eemi_ops->sha_hash(0, 0, ZYNQMP_SHA3_INIT);
+
+	return ret;
+}
+
+static int zynqmp_sha_update(struct ahash_request *req)
+{
+	struct zynqmp_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct zynqmp_sha_dev *dd = tctx->dd;
+	size_t dma_size = req->nbytes;
+	dma_addr_t dma_addr;
+	char *kbuf;
+	int ret;
+
+	if (!req->nbytes)
+		return 0;
+
+	if (!eemi_ops->sha_hash)
+		return -ENOTSUPP;
+
+	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(kbuf, req->src, 0, req->nbytes, 0);
+	ret = eemi_ops->sha_hash(dma_addr, req->nbytes, ZYNQMP_SHA3_UPDATE);
+	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
+
+	return ret;
+}
+
+static int zynqmp_sha_final(struct ahash_request *req)
+{
+	struct zynqmp_sha_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
+	struct zynqmp_sha_dev *dd = tctx->dd;
+	size_t dma_size = SHA384_DIGEST_SIZE;
+	dma_addr_t dma_addr;
+	char *kbuf;
+	int ret;
+
+	if (!eemi_ops->sha_hash)
+		return -ENOTSUPP;
+
+	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	ret = eemi_ops->sha_hash(dma_addr, dma_size, ZYNQMP_SHA3_FINAL);
+	memcpy(req->result, kbuf, SHA384_DIGEST_SIZE);
+	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
+
+	return ret;
+}
+
+static int zynqmp_sha_finup(struct ahash_request *req)
+{
+	zynqmp_sha_update(req);
+	zynqmp_sha_final(req);
+
+	return 0;
+}
+
+static int zynqmp_sha_digest(struct ahash_request *req)
+{
+	zynqmp_sha_init(req);
+	zynqmp_sha_update(req);
+	zynqmp_sha_final(req);
+
+	return 0;
+}
+
+static int zynqmp_sha_cra_init(struct crypto_tfm *tfm)
+{
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct zynqmp_sha_reqctx));
+
+	return 0;
+}
+
+static struct ahash_alg sha3_alg = {
+	.init		= zynqmp_sha_init,
+	.update		= zynqmp_sha_update,
+	.final		= zynqmp_sha_final,
+	.finup		= zynqmp_sha_finup,
+	.digest		= zynqmp_sha_digest,
+	.halg = {
+		.digestsize	= SHA384_DIGEST_SIZE,
+		.statesize	= sizeof(struct sha256_state),
+		.base	= {
+			.cra_name		= "xilinx-sha3-384",
+			.cra_driver_name	= "zynqmp-sha3-384",
+			.cra_priority		= 300,
+			.cra_flags		= CRYPTO_ALG_ASYNC,
+			.cra_blocksize		= SHA384_BLOCK_SIZE,
+			.cra_ctxsize		= sizeof(struct zynqmp_sha_ctx),
+			.cra_alignmask		= 0,
+			.cra_module		= THIS_MODULE,
+			.cra_init		= zynqmp_sha_cra_init,
+		}
+	}
+};
+
+static const struct of_device_id zynqmp_sha_dt_ids[] = {
+	{ .compatible = "xlnx,zynqmp-sha3-384" },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, zynqmp_sha_dt_ids);
+
+static int zynqmp_sha_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int err;
+
+	eemi_ops = zynqmp_pm_get_eemi_ops();
+	if (IS_ERR(eemi_ops))
+		return PTR_ERR(eemi_ops);
+
+	sha_dd = devm_kzalloc(&pdev->dev, sizeof(*sha_dd), GFP_KERNEL);
+	if (!sha_dd)
+		return -ENOMEM;
+
+	sha_dd->dev = dev;
+	platform_set_drvdata(pdev, sha_dd);
+
+	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
+	if (err < 0) {
+		dev_err(dev, "no usable DMA configuration");
+		goto err_algs;
+	}
+
+	err = crypto_register_ahash(&sha3_alg);
+	if (err)
+		goto err_algs;
+
+	return 0;
+
+err_algs:
+	return err;
+}
+
+static int zynqmp_sha_remove(struct platform_device *pdev)
+{
+	sha_dd = platform_get_drvdata(pdev);
+
+	if (!sha_dd)
+		return -ENODEV;
+
+	crypto_unregister_ahash(&sha3_alg);
+
+	return 0;
+}
+
+static struct platform_driver zynqmp_sha_driver = {
+	.probe		= zynqmp_sha_probe,
+	.remove		= zynqmp_sha_remove,
+	.driver		= {
+		.name	= "zynqmp-keccak-384",
+		.of_match_table	= of_match_ptr(zynqmp_sha_dt_ids),
+	},
+};
+
+module_platform_driver(zynqmp_sha_driver);
+
+MODULE_DESCRIPTION("ZynqMP SHA3 hw acceleration support.");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nava kishore Manne <navam@xilinx.com>");
-- 
1.9.5

