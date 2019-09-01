Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC70CA49A2
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 15:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfIANzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 09:55:32 -0400
Received: from mail-eopbgr720043.outbound.protection.outlook.com ([40.107.72.43]:43936
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728988AbfIANzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Sep 2019 09:55:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzDT2XqDo/WOKqZRf4uzrc7lmAHoOs6uKtFvnULATYmS8y7JaSRt8ojTveJMSzORyph+fQJ4Tui+3nYnDd5NlX2Na5kikvJkcKPgL/Us8KjTPbByeS4jYfwB4pKoI997qNmZohzrQQjm4FhHrj3r5GoILsaulzUr4dpe6p+/O//ZwN50wO6C7Sn158ivfmrGTLbojFAPsgqM9wBZhHkuwHfsTD8MCCtzNQTYM+Jyck2PEEaOKDhn75QyQVE2FjSe9hMLZGcTCVIrJ49555qln2vVooj8J1WljhBNSwRoxp4qNBJ5IirwbZeHIOwUvsvq6taTqicvuFfcX/rpcM4y9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIEpp7MxALukTdhql1vN8tCY8u+jVp27P9wfgdJJnmw=;
 b=OuSdjEiXdks4t5/8G6j8E7ykw/Dmep7aiNGJ28fhwFwWO+cvXmQsOgikajL5b2jR91o3CHaOdM1SLCIHiCEpPBtPeDeLzWakjREbR6Z743ByrKMnG3bfv6bFpZLY8E/oNMraBNkQ6N9ivOJXvECvD99AGYofuY/VujVylhIIze8nF6txU7LP3c/foLBXAURIb8fWJtnDfkUDuMSJhxEpLTLfW+E2LZ+VxchPVss1IID3wvbRsm1hXvm6A73TRngodVfk1Jf/KKyYc9jA5jua4P3pqvVeED/np/yLc8ELNLHQFyCFoeMe6wjnHIZt2lzW1T5C2QmMQ47kFH4JtMvN5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xIEpp7MxALukTdhql1vN8tCY8u+jVp27P9wfgdJJnmw=;
 b=HOGQvF/fLyTlVZzU4bDq81swp+XYGpGXPT+TeAA1QVQr21AMf1YvxYvalVG/CHFibUC4GYrCpFIDvKtO4cr0UIuB4GQUV0mZGB6JqNayEMCKruJAHlR6urRXTcETw0xVNtMMm5yqhZqEcDr+zO3oeNwGzCJU8WpDtV/tf9CntrM=
Received: from SN4PR0201CA0024.namprd02.prod.outlook.com
 (2603:10b6:803:2b::34) by BN7PR02MB5251.namprd02.prod.outlook.com
 (2603:10b6:408:27::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2178.18; Sun, 1 Sep
 2019 13:55:27 +0000
Received: from CY1NAM02FT059.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::209) by SN4PR0201CA0024.outlook.office365.com
 (2603:10b6:803:2b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.19 via Frontend
 Transport; Sun, 1 Sep 2019 13:55:27 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 CY1NAM02FT059.mail.protection.outlook.com (10.152.74.211) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Sun, 1 Sep 2019 13:55:26 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:50134 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QKD-00048y-PW; Sun, 01 Sep 2019 06:55:25 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <kalyani.akula@xilinx.com>)
        id 1i4QK8-0002cJ-MK; Sun, 01 Sep 2019 06:55:20 -0700
Received: from xsj-pvapsmtp01 (xsj-smtp.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x81DtBew002115;
        Sun, 1 Sep 2019 06:55:12 -0700
Received: from [172.23.155.44] (helo=xhdengvm155044.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <kalyania@xilinx.com>)
        id 1i4QJz-0002ar-Fa; Sun, 01 Sep 2019 06:55:11 -0700
Received: by xhdengvm155044.xilinx.com (Postfix, from userid 23151)
        id C70B386002; Sun,  1 Sep 2019 19:25:10 +0530 (IST)
From:   Kalyani Akula <kalyani.akula@xilinx.com>
To:     herbert@gondor.apana.org.au, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Kalyani Akula <kalyania@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [PATCH V2 4/4] crypto: Add Xilinx AES driver
Date:   Sun,  1 Sep 2019 19:24:58 +0530
Message-Id: <1567346098-27927-5-git-send-email-kalyani.akula@xilinx.com>
X-Mailer: git-send-email 1.9.5
In-Reply-To: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
References: <1567346098-27927-1-git-send-email-kalyani.akula@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(2980300002)(189003)(199004)(76176011)(2906002)(11346002)(81156014)(81166006)(42186006)(50466002)(8676002)(426003)(51416003)(446003)(106002)(44832011)(50226002)(26005)(6666004)(336012)(8936002)(486006)(70586007)(476003)(36386004)(48376002)(356004)(2616005)(70206006)(126002)(36756003)(305945005)(316002)(478600001)(16586007)(5660300002)(186003)(4326008)(6266002)(107886003)(103686004)(52956003)(47776003)(54906003)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR02MB5251;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:xapps1.xilinx.com,unknown-60-100.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dff0979-6508-482e-c273-08d72ee40b03
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:BN7PR02MB5251;
X-MS-TrafficTypeDiagnostic: BN7PR02MB5251:
X-Microsoft-Antispam-PRVS: <BN7PR02MB52511F3D1FD28F35F7E34FCCAFBF0@BN7PR02MB5251.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0147E151B5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: AU5MgG/O0nLUlYMFBBot+7NwxNXO14KO//f70aC7bb59p22DPujVKdA0ypSqNANk9FJR2Ca3Ey6GCyZZhxy/KcQWHTbNjnukx7g4iLY1YV4K/WJ8AhN950scKsaD+0so2O91QBNAS6HgIqAtPOYTODyE2o//wc1EOGlzCT7+dHut4P5baSMz0LpiqBDVX1rFsfOfdF2ZwIJuiZDk1EbQ06wQ8BdoUKXMKPLdwjZqSNYi06fZZlJV1khNC2k3ky50llZj3i2rtig3iWDAvI451vp8huJsi0iQQMFE3MnLo/q3cvASMGcPpxqADp9cHlMwANOimaVVKR6//R0BO372O9CplwBoJ3579NK01yJOIJ9g8tICvqCCbmfVK9c3MyYtrp+5zjtr7Bz/sG/zlvipS3URrroAR2tToHxpDjoVFrs=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2019 13:55:26.3067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dff0979-6508-482e-c273-08d72ee40b03
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5251
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds AES driver support for the Xilinx
ZynqMP SoC.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/crypto/Kconfig          |  11 ++
 drivers/crypto/Makefile         |   1 +
 drivers/crypto/zynqmp-aes-gcm.c | 297 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 309 insertions(+)
 create mode 100644 drivers/crypto/zynqmp-aes-gcm.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 603413f..a0d058a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -677,6 +677,17 @@ config CRYPTO_DEV_ROCKCHIP
 	  This driver interfaces with the hardware crypto accelerator.
 	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
 
+config CRYPTO_DEV_ZYNQMP_AES
+	tristate "Support for Xilinx ZynqMP AES hw accelerator"
+	depends on ARCH_ZYNQMP || COMPILE_TEST
+	select CRYPTO_AES
+	select CRYPTO_SKCIPHER
+	help
+	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
+	  encryption and decryption. This driver interfaces with AES hw
+	  accelerator. Select this if you want to use the ZynqMP module
+	  for AES algorithms.
+
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
 	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index afc4753..c99663a 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -48,3 +48,4 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += hisilicon/
+obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes-gcm.o
diff --git a/drivers/crypto/zynqmp-aes-gcm.c b/drivers/crypto/zynqmp-aes-gcm.c
new file mode 100644
index 0000000..d65f038
--- /dev/null
+++ b/drivers/crypto/zynqmp-aes-gcm.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Xilinx ZynqMP AES Driver.
+ * Copyright (c) 2019 Xilinx Inc.
+ */
+
+#include <crypto/aes.h>
+#include <crypto/scatterwalk.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/scatterlist.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+
+#define ZYNQMP_AES_IV_SIZE			12
+#define ZYNQMP_AES_GCM_SIZE			16
+#define ZYNQMP_AES_KEY_SIZE			32
+
+#define ZYNQMP_AES_DECRYPT			0
+#define ZYNQMP_AES_ENCRYPT			1
+
+#define ZYNQMP_AES_KUP_KEY			0
+#define ZYNQMP_AES_DEVICE_KEY			1
+#define ZYNQMP_AES_PUF_KEY			2
+
+#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
+#define ZYNQMP_AES_SIZE_ERR			0x06
+#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
+#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
+
+#define ZYNQMP_AES_BLOCKSIZE			0x04
+
+static const struct zynqmp_eemi_ops *eemi_ops;
+struct zynqmp_aes_dev *aes_dd;
+
+struct zynqmp_aes_dev {
+	struct device *dev;
+};
+
+struct zynqmp_aes_op {
+	struct zynqmp_aes_dev *dd;
+	void *src;
+	void *dst;
+	int len;
+	u8 key[ZYNQMP_AES_KEY_SIZE];
+	u8 *iv;
+	u32 keylen;
+	u32 keytype;
+};
+
+struct zynqmp_aes_data {
+	u64 src;
+	u64 iv;
+	u64 key;
+	u64 dst;
+	u64 size;
+	u64 optype;
+	u64 keysrc;
+};
+
+static int zynqmp_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
+			     unsigned int len)
+{
+	struct zynqmp_aes_op *op = crypto_tfm_ctx(tfm);
+
+	if (((len != 1) && (len !=  ZYNQMP_AES_KEY_SIZE)) || (!key))
+		return -EINVAL;
+
+	if (len == 1) {
+		op->keytype = *key;
+
+		if ((op->keytype < ZYNQMP_AES_KUP_KEY) ||
+			(op->keytype > ZYNQMP_AES_PUF_KEY))
+			return -EINVAL;
+
+	} else if (len == ZYNQMP_AES_KEY_SIZE) {
+		op->keytype = ZYNQMP_AES_KUP_KEY;
+		op->keylen = len;
+		memcpy(op->key, key, len);
+	}
+
+	return 0;
+}
+
+static int zynqmp_aes_xcrypt(struct blkcipher_desc *desc,
+			     struct scatterlist *dst,
+			     struct scatterlist *src,
+			     unsigned int nbytes,
+			     unsigned int flags)
+{
+	struct zynqmp_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
+	struct zynqmp_aes_dev *dd = aes_dd;
+	int err, ret, copy_bytes, src_data = 0, dst_data = 0;
+	dma_addr_t dma_addr, dma_addr_buf;
+	struct zynqmp_aes_data *abuf;
+	struct blkcipher_walk walk;
+	unsigned int data_size;
+	size_t dma_size;
+	char *kbuf;
+
+	if (!eemi_ops->aes)
+		return -ENOTSUPP;
+
+	if (op->keytype == ZYNQMP_AES_KUP_KEY)
+		dma_size = nbytes + ZYNQMP_AES_KEY_SIZE
+			+ ZYNQMP_AES_IV_SIZE;
+	else
+		dma_size = nbytes + ZYNQMP_AES_IV_SIZE;
+
+	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	abuf = dma_alloc_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
+				  &dma_addr_buf, GFP_KERNEL);
+	if (!abuf) {
+		dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
+		return -ENOMEM;
+	}
+
+	data_size = nbytes;
+	blkcipher_walk_init(&walk, dst, src, data_size);
+	err = blkcipher_walk_virt(desc, &walk);
+	op->iv = walk.iv;
+
+	while ((nbytes = walk.nbytes)) {
+		op->src = walk.src.virt.addr;
+		memcpy(kbuf + src_data, op->src, nbytes);
+		src_data = src_data + nbytes;
+		nbytes &= (ZYNQMP_AES_BLOCKSIZE - 1);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+	memcpy(kbuf + data_size, op->iv, ZYNQMP_AES_IV_SIZE);
+	abuf->src = dma_addr;
+	abuf->dst = dma_addr;
+	abuf->iv = abuf->src + data_size;
+	abuf->size = data_size - ZYNQMP_AES_GCM_SIZE;
+	abuf->optype = flags;
+	abuf->keysrc = op->keytype;
+
+	if (op->keytype == ZYNQMP_AES_KUP_KEY) {
+		memcpy(kbuf + data_size + ZYNQMP_AES_IV_SIZE,
+		       op->key, ZYNQMP_AES_KEY_SIZE);
+
+		abuf->key = abuf->src + data_size + ZYNQMP_AES_IV_SIZE;
+	} else {
+		abuf->key = 0;
+	}
+	eemi_ops->aes(dma_addr_buf, &ret);
+
+	if (ret != 0) {
+		switch (ret) {
+		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
+			dev_err(dd->dev, "ERROR: Gcm Tag mismatch\n\r");
+			break;
+		case ZYNQMP_AES_SIZE_ERR:
+			dev_err(dd->dev, "ERROR : Non word aligned data\n\r");
+			break;
+		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
+			dev_err(dd->dev, "ERROR: Wrong KeySrc, enable secure mode\n\r");
+			break;
+		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
+			dev_err(dd->dev, "ERROR: PUF is not registered\r\n");
+			break;
+		default:
+			dev_err(dd->dev, "ERROR: Invalid");
+			break;
+		}
+		goto END;
+	}
+	if (flags)
+		copy_bytes = data_size;
+	else
+		copy_bytes = data_size - ZYNQMP_AES_GCM_SIZE;
+
+	blkcipher_walk_init(&walk, dst, src, copy_bytes);
+	err = blkcipher_walk_virt(desc, &walk);
+
+	while ((nbytes = walk.nbytes)) {
+		memcpy(walk.dst.virt.addr, kbuf + dst_data, nbytes);
+		dst_data = dst_data + nbytes;
+		nbytes &= (ZYNQMP_AES_BLOCKSIZE - 1);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+END:
+	memset(kbuf, 0, dma_size);
+	memset(abuf, 0, sizeof(struct zynqmp_aes_data));
+	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
+	dma_free_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
+			  abuf, dma_addr_buf);
+	return err;
+}
+
+static int zynqmp_aes_decrypt(struct blkcipher_desc *desc,
+			      struct scatterlist *dst,
+			      struct scatterlist *src,
+			      unsigned int nbytes)
+{
+	return zynqmp_aes_xcrypt(desc, dst, src, nbytes, ZYNQMP_AES_DECRYPT);
+}
+
+static int zynqmp_aes_encrypt(struct blkcipher_desc *desc,
+			      struct scatterlist *dst,
+			      struct scatterlist *src,
+			      unsigned int nbytes)
+{
+	return zynqmp_aes_xcrypt(desc, dst, src, nbytes, ZYNQMP_AES_ENCRYPT);
+}
+
+static struct crypto_alg zynqmp_alg = {
+	.cra_name		=	"xilinx-zynqmp-aes",
+	.cra_driver_name	=	"zynqmp-aes-gcm",
+	.cra_priority		=	400,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
+					CRYPTO_ALG_KERN_DRIVER_ONLY,
+	.cra_blocksize		=	ZYNQMP_AES_BLOCKSIZE,
+	.cra_ctxsize		=	sizeof(struct zynqmp_aes_op),
+	.cra_alignmask		=	15,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_module		=	THIS_MODULE,
+	.cra_u			=	{
+	.blkcipher	=	{
+			.min_keysize	=	0,
+			.max_keysize	=	ZYNQMP_AES_KEY_SIZE,
+			.setkey		=	zynqmp_setkey_blk,
+			.encrypt	=	zynqmp_aes_encrypt,
+			.decrypt	=	zynqmp_aes_decrypt,
+			.ivsize		=	ZYNQMP_AES_IV_SIZE,
+		}
+	}
+};
+
+static const struct of_device_id zynqmp_aes_dt_ids[] = {
+	{ .compatible = "xlnx,zynqmp-aes" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
+
+static int zynqmp_aes_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int ret;
+
+	eemi_ops = zynqmp_pm_get_eemi_ops();
+
+	if (IS_ERR(eemi_ops))
+		return PTR_ERR(eemi_ops);
+
+	aes_dd = devm_kzalloc(dev, sizeof(*aes_dd), GFP_KERNEL);
+	if (!aes_dd)
+		return -ENOMEM;
+
+	aes_dd->dev = dev;
+	platform_set_drvdata(pdev, aes_dd);
+
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(44));
+	if (ret < 0) {
+		dev_err(dev, "no usable DMA configuration");
+		return ret;
+	}
+
+	ret = crypto_register_alg(&zynqmp_alg);
+	if (ret)
+		goto err_algs;
+
+	dev_info(dev, "AES Successfully Registered\n\r");
+	return 0;
+
+err_algs:
+	return ret;
+}
+
+static int zynqmp_aes_remove(struct platform_device *pdev)
+{
+	aes_dd = platform_get_drvdata(pdev);
+	if (!aes_dd)
+		return -ENODEV;
+	crypto_unregister_alg(&zynqmp_alg);
+
+	return 0;
+}
+
+static struct platform_driver xilinx_aes_driver = {
+	.probe = zynqmp_aes_probe,
+	.remove = zynqmp_aes_remove,
+	.driver = {
+		.name = "zynqmp_aes",
+		.of_match_table = of_match_ptr(zynqmp_aes_dt_ids),
+	},
+};
+
+module_platform_driver(xilinx_aes_driver);
+
+MODULE_DESCRIPTION("Xilinx ZynqMP AES hw acceleration support.");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Nava kishore Manne <nava.manne@xilinx.com>");
+MODULE_AUTHOR("Kalyani Akula <kalyani.akula@xilinx.com>");
-- 
1.8.3.1

