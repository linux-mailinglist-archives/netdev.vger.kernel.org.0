Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F826741C9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjASS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjASS7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:59:22 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A899516B;
        Thu, 19 Jan 2023 10:58:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZgeoylr2MofFvXYmxMAddeHWlkkJTMJDD1vgibYQmv95fHJJu7J6o1/UvgGPcSKH9Ny6OzG5lA9DsT7OVjv+zlBKtsSdPyVQYJ6FN9wK9EOmTgp/ka2U/tFXg1rog8flr/1y4p0PQjWrrCdqQ16qAl/BvsbwMs1ZeJPx7uPNR4hdlD630JXiQKpI9pRMdWA20VZnttLAAUgdQC3mNUECHxXJkFNRUu324zCbnCfGT9P9dqrNpQV523r8LaFaCLgrZ9WVVMgZh9vDc96xpvk58LpzQ4P7AaCknIN1yYQZigN9O/pTRG65UJRzCmee2LRVgj9GcMcil6Zty/02Muhpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0rjGu5RUgQf3YFAd61KZZ1eMN8raw3GbNRFDVfWNYso=;
 b=dBLOUX+1NqSbqOiZZmqlDEcDLuV4XQdSWv92gO1KPWwnPxShCgeK7Qz8gzOp1t3XEiQV2ypH0X+Q9//aLmLiVnjeTylHH1dKkjIokSMe2Vgq91b+CJm4XSc2ItA5DteLK2Q8V5XDW/jjhQ5XrcFjsdNgR70DR3gJg9V1W/YIJYag8/uO3u7ewTolcg0HJHdWJ84zhWjP9w11bX/FZy9JuVdY5DkQkzCaK+r8swSJd74eCfnYiEzBVI08FJqrUM5kE5qW9MPS30WSdahJZXsqHz+xlPz08s7WoA4EAElVlW3Bb+WBz7C9gac8vkmX/IzzhgRKbSTZnN2BpK+46bJ2TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0rjGu5RUgQf3YFAd61KZZ1eMN8raw3GbNRFDVfWNYso=;
 b=Zxxb6A/ZSa3OTh7j7SCnUv64mXQ0E1+86pBkm4uZQizG4Kmgsr+KJe1PF6ZFRX6b5fKGGf0TCaimVFgmHoxFIDea3oK2NyyhP3fZ94paI22krQB3JNMpMhkwwyTRg2u9dAVAaHTWaCS72pvEPzKymHYI53cTkRTH4pnvMt77fHs=
Received: from CY5PR19CA0069.namprd19.prod.outlook.com (2603:10b6:930:69::15)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 18:58:03 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:69:cafe::af) by CY5PR19CA0069.outlook.office365.com
 (2603:10b6:930:69::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 18:58:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Thu, 19 Jan 2023 18:58:03 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 12:58:02 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 19 Jan 2023 12:57:36 -0600
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
        <kvalo@kernel.org>, <thierry.reding@gmail.com>,
        <jonathanh@nvidia.com>, <skomatineni@nvidia.com>,
        <sumit.semwal@linaro.org>, <christian.koenig@amd.com>,
        <j.neuschaefer@gmx.net>, <vireshk@kernel.org>, <rmfrfs@gmail.com>,
        <johan@kernel.org>, <elder@kernel.org>,
        <gregkh@linuxfoundation.org>
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
        <ldewangan@nvidia.com>, <michal.simek@amd.com>,
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
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <greybus-dev@lists.linaro.org>, <linux-staging@lists.linux.dev>,
        <amitrkcian2002@gmail.com>
Subject: [PATCH v2 09/13] mtd: spi-nor: Add APIs to set/get nor->params
Date:   Fri, 20 Jan 2023 00:23:38 +0530
Message-ID: <20230119185342.2093323-10-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|SA0PR12MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: ba7d683c-a948-4f5b-213a-08dafa4f17c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2LFW6sxKS+DJgeivXbcBQzaJFN2yXjGp2azx5n3ZL4gnHj1SewnYHbOSMnbmxrRTbZGnatTkyoLjKRoW2l/C9/tx8sGNt8m7/xN/1ehZ/OvAZfjBQFNYXVfdCxzu+ma4WDMDmpr08rqvti++S9ZDdiGfHebS79XutOKzAWZdEufYe5XnrVYrfv5D6uGCIhiyctqszVcvktRVUAgyX//JKsul2XJeEOTgCw3SVOrrAaU9JW6O/vxN0inuwOuI9kIGbxHtvsU60PVoHfuY4TP4mXA/6+q6809ml2ihTowsH83w54/AvtylZkInbKOgyD7a0bEEjc7BQd8P5qh9Rcl6k9XgSeLwdvXX9FAZV5x+za4jtjw5TWxLfraD5CEkrnZYaalk87YwKTMpnT+iQo26HGtO5ABkMg6zmLi0dHiyPfY7n646UkR9KYkVstVP+ag12umHl8TkhII/lyZ0VLdr55rR8iGX5giFxF8Ods17moolQ241t1gxPb4ZImFIK0jhtRMYtZwdjxNpCPvTYPAwIAnLKXCSrNg3BQQQAtn9Q5KV4hhhZoSlPN9I8aNBS0dLN0yFQtY9fmJDxYCkKlU91VLXfgU99zVrBgpvi2jbrV1JgRdku+Rd7KOs8wryR7JSa/01O+bxMZj0kGANbP4JHhy5345XOVGdh75dj1XbUmHynlyGL1Wzgd1eEXtvL+iZK4sMhkHCU4mghRDchLdXRbwLB0LdiNkkDj0UPnSFkvfZKbD6VSb4q6/KQq5/xog2MkHBnjI89OLhiPFo2C/NXPuQ5f/NpT6oC9S5tlnlvlRY5khD6gFhHu0b+bIlWRxs+YFCi4AfUpCl+mM4FNuRtRNdhx1iOHQ0dHV967xpqsg56JqgZnEqmvhjdseEyIr
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(81166007)(36860700001)(82740400003)(70586007)(356005)(86362001)(8936002)(5660300002)(7276002)(7336002)(70206006)(2906002)(7366002)(7406005)(30864003)(7416002)(478600001)(4326008)(8676002)(1076003)(41300700001)(40480700001)(26005)(186003)(40460700003)(336012)(82310400005)(2616005)(83380400001)(426003)(47076005)(316002)(110136005)(1191002)(54906003)(921005)(36756003)(36900700001)(41080700001)(2101003)(83996005)(84006005)(579004)(559001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 18:58:03.2379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7d683c-a948-4f5b-213a-08dafa4f17c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Supporting multi-cs in spi-nor would require the *params member of
struct spi_nor to be an array. To make the transition smoother introduced
spi_nor_get_params() & spi_nor_set_params() APIs to get & set nor->params,
added a new local variable (struct spi_nor_flash_parameter *params) to hold
the return value of the spi_nor_get_params() function call and replaced all
nor->params references with the "params".
While adding multi-cs support in further patches the *params member of the
spi_nor structure would be converted to arrays & the "idx" parameter of
the APIs would be used as array index i.e., nor->params[idx].

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/mtd/spi-nor/atmel.c      |  17 ++--
 drivers/mtd/spi-nor/core.c       | 129 ++++++++++++++++++++-----------
 drivers/mtd/spi-nor/debugfs.c    |   4 +-
 drivers/mtd/spi-nor/gigadevice.c |   4 +-
 drivers/mtd/spi-nor/issi.c       |  11 ++-
 drivers/mtd/spi-nor/macronix.c   |   6 +-
 drivers/mtd/spi-nor/micron-st.c  |  34 +++++---
 drivers/mtd/spi-nor/otp.c        |  21 +++--
 drivers/mtd/spi-nor/sfdp.c       |  29 ++++---
 drivers/mtd/spi-nor/spansion.c   |  50 +++++++-----
 drivers/mtd/spi-nor/sst.c        |   7 +-
 drivers/mtd/spi-nor/swp.c        |  22 ++++--
 drivers/mtd/spi-nor/winbond.c    |  10 ++-
 drivers/mtd/spi-nor/xilinx.c     |  18 +++--
 include/linux/mtd/spi-nor.h      |  10 +++
 15 files changed, 248 insertions(+), 124 deletions(-)

diff --git a/drivers/mtd/spi-nor/atmel.c b/drivers/mtd/spi-nor/atmel.c
index 656dd80a0be7..57ca9f5ee205 100644
--- a/drivers/mtd/spi-nor/atmel.c
+++ b/drivers/mtd/spi-nor/atmel.c
@@ -23,10 +23,11 @@ static int at25fs_nor_lock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 
 static int at25fs_nor_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
 	/* We only support unlocking the whole flash array */
-	if (ofs || len != nor->params->size)
+	if (ofs || len != params->size)
 		return -EINVAL;
 
 	/* Write 0x00 to the status register to disable write protection */
@@ -50,7 +51,9 @@ static const struct spi_nor_locking_ops at25fs_nor_locking_ops = {
 
 static void at25fs_nor_late_init(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &at25fs_nor_locking_ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->locking_ops = &at25fs_nor_locking_ops;
 }
 
 static const struct spi_nor_fixups at25fs_nor_fixups = {
@@ -69,11 +72,12 @@ static const struct spi_nor_fixups at25fs_nor_fixups = {
 static int atmel_nor_set_global_protection(struct spi_nor *nor, loff_t ofs,
 					   uint64_t len, bool is_protect)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 	u8 sr;
 
 	/* We only support locking the whole flash array */
-	if (ofs || len != nor->params->size)
+	if (ofs || len != params->size)
 		return -EINVAL;
 
 	ret = spi_nor_read_sr(nor, nor->bouncebuf);
@@ -131,9 +135,10 @@ static int atmel_nor_global_unprotect(struct spi_nor *nor, loff_t ofs,
 static int atmel_nor_is_global_protected(struct spi_nor *nor, loff_t ofs,
 					 uint64_t len)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
-	if (ofs >= nor->params->size || (ofs + len) > nor->params->size)
+	if (ofs >= params->size || (ofs + len) > params->size)
 		return -EINVAL;
 
 	ret = spi_nor_read_sr(nor, nor->bouncebuf);
@@ -151,7 +156,9 @@ static const struct spi_nor_locking_ops atmel_nor_global_protection_ops = {
 
 static void atmel_nor_global_protection_late_init(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &atmel_nor_global_protection_ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->locking_ops = &atmel_nor_global_protection_ops;
 }
 
 static const struct spi_nor_fixups atmel_nor_global_protection_fixups = {
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index d8703d7dfd0a..8a4a54bf2d0e 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -448,14 +448,15 @@ int spi_nor_read_id(struct spi_nor *nor, u8 naddr, u8 ndummy, u8 *id,
  */
 int spi_nor_read_sr(struct spi_nor *nor, u8 *sr)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
 	if (nor->spimem) {
 		struct spi_mem_op op = SPI_NOR_RDSR_OP(sr);
 
 		if (nor->reg_proto == SNOR_PROTO_8_8_8_DTR) {
-			op.addr.nbytes = nor->params->rdsr_addr_nbytes;
-			op.dummy.nbytes = nor->params->rdsr_dummy;
+			op.addr.nbytes = params->rdsr_addr_nbytes;
+			op.dummy.nbytes = params->rdsr_dummy;
 			/*
 			 * We don't want to read only one byte in DTR mode. So,
 			 * read 2 and then discard the second byte.
@@ -596,9 +597,11 @@ int spi_nor_sr_ready(struct spi_nor *nor)
  */
 static int spi_nor_ready(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/* Flashes might override the standard routine. */
-	if (nor->params->ready)
-		return nor->params->ready(nor);
+	if (params->ready)
+		return params->ready(nor);
 
 	return spi_nor_sr_ready(nor);
 }
@@ -760,6 +763,7 @@ static int spi_nor_write_sr1_and_check(struct spi_nor *nor, u8 sr1)
  */
 static int spi_nor_write_16bit_sr_and_check(struct spi_nor *nor, u8 sr1)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 	u8 *sr_cr = nor->bouncebuf;
 	u8 cr_written;
@@ -769,7 +773,7 @@ static int spi_nor_write_16bit_sr_and_check(struct spi_nor *nor, u8 sr1)
 		ret = spi_nor_read_cr(nor, &sr_cr[1]);
 		if (ret)
 			return ret;
-	} else if (nor->params->quad_enable) {
+	} else if (params->quad_enable) {
 		/*
 		 * If the Status Register 2 Read command (35h) is not
 		 * supported, we should at least be sure we don't
@@ -777,7 +781,7 @@ static int spi_nor_write_16bit_sr_and_check(struct spi_nor *nor, u8 sr1)
 		 *
 		 * We can safely assume that when the Quad Enable method is
 		 * set, the value of the QE bit is one, as a consequence of the
-		 * nor->params->quad_enable() call.
+		 * params->quad_enable() call.
 		 *
 		 * We can safely assume that the Quad Enable bit is present in
 		 * the Status Register 2 at BIT(1). According to the JESD216
@@ -1048,17 +1052,21 @@ static u8 spi_nor_convert_3to4_erase(u8 opcode)
 
 static bool spi_nor_has_uniform_erase(const struct spi_nor *nor)
 {
-	return !!nor->params->erase_map.uniform_erase_type;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	return !!params->erase_map.uniform_erase_type;
 }
 
 static void spi_nor_set_4byte_opcodes(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	nor->read_opcode = spi_nor_convert_3to4_read(nor->read_opcode);
 	nor->program_opcode = spi_nor_convert_3to4_program(nor->program_opcode);
 	nor->erase_opcode = spi_nor_convert_3to4_erase(nor->erase_opcode);
 
 	if (!spi_nor_has_uniform_erase(nor)) {
-		struct spi_nor_erase_map *map = &nor->params->erase_map;
+		struct spi_nor_erase_map *map = &params->erase_map;
 		struct spi_nor_erase_type *erase;
 		int i;
 
@@ -1095,10 +1103,12 @@ void spi_nor_unlock_and_unprep(struct spi_nor *nor)
 
 static u32 spi_nor_convert_addr(struct spi_nor *nor, loff_t addr)
 {
-	if (!nor->params->convert_addr)
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	if (!params->convert_addr)
 		return addr;
 
-	return nor->params->convert_addr(nor, addr);
+	return params->convert_addr(nor, addr);
 }
 
 /*
@@ -1318,7 +1328,8 @@ static int spi_nor_init_erase_cmd_list(struct spi_nor *nor,
 				       struct list_head *erase_list,
 				       u64 addr, u32 len)
 {
-	const struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_erase_map *map = &params->erase_map;
 	const struct spi_nor_erase_type *erase, *prev_erase = NULL;
 	struct spi_nor_erase_region *region;
 	struct spi_nor_erase_command *cmd = NULL;
@@ -1746,12 +1757,16 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 	size_t *retlen, const u_char *buf)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
+	struct spi_nor_flash_parameter *params;
 	size_t page_offset, page_remain, i;
 	ssize_t ret;
-	u32 page_size = nor->params->page_size;
+	u32 page_size;
 
 	dev_dbg(nor->dev, "to 0x%08x, len %zd\n", (u32)to, len);
 
+	params = spi_nor_get_params(nor, 0);
+	page_size = params->page_size;
+
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
 		return ret;
@@ -1903,6 +1918,8 @@ int spi_nor_hwcaps_pp2cmd(u32 hwcaps)
 static int spi_nor_spimem_check_op(struct spi_nor *nor,
 				   struct spi_mem_op *op)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/*
 	 * First test with 4 address bytes. The opcode itself might
 	 * be a 3B addressing opcode but we don't care, because
@@ -1911,7 +1928,7 @@ static int spi_nor_spimem_check_op(struct spi_nor *nor,
 	 */
 	op->addr.nbytes = 4;
 	if (!spi_mem_supports_op(nor->spimem, op)) {
-		if (nor->params->size > SZ_16M)
+		if (params->size > SZ_16M)
 			return -EOPNOTSUPP;
 
 		/* If flash size <= 16MB, 3 address bytes are sufficient */
@@ -1975,7 +1992,7 @@ static int spi_nor_spimem_check_pp(struct spi_nor *nor,
 static void
 spi_nor_spimem_adjust_hwcaps(struct spi_nor *nor, u32 *hwcaps)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	unsigned int cap;
 
 	/* X-X-X modes are not supported yet, mask them all. */
@@ -2067,6 +2084,7 @@ static int spi_nor_select_read(struct spi_nor *nor,
 			       u32 shared_hwcaps)
 {
 	int cmd, best_match = fls(shared_hwcaps & SNOR_HWCAPS_READ_MASK) - 1;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	const struct spi_nor_read_command *read;
 
 	if (best_match < 0)
@@ -2076,7 +2094,7 @@ static int spi_nor_select_read(struct spi_nor *nor,
 	if (cmd < 0)
 		return -EINVAL;
 
-	read = &nor->params->reads[cmd];
+	read = &params->reads[cmd];
 	nor->read_opcode = read->opcode;
 	nor->read_proto = read->proto;
 
@@ -2097,6 +2115,7 @@ static int spi_nor_select_read(struct spi_nor *nor,
 static int spi_nor_select_pp(struct spi_nor *nor,
 			     u32 shared_hwcaps)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int cmd, best_match = fls(shared_hwcaps & SNOR_HWCAPS_PP_MASK) - 1;
 	const struct spi_nor_pp_command *pp;
 
@@ -2107,7 +2126,7 @@ static int spi_nor_select_pp(struct spi_nor *nor,
 	if (cmd < 0)
 		return -EINVAL;
 
-	pp = &nor->params->page_programs[cmd];
+	pp = &params->page_programs[cmd];
 	nor->program_opcode = pp->opcode;
 	nor->write_proto = pp->proto;
 	return 0;
@@ -2176,7 +2195,8 @@ spi_nor_select_uniform_erase(struct spi_nor_erase_map *map,
 
 static int spi_nor_select_erase(struct spi_nor *nor)
 {
-	struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	struct spi_nor_erase_map *map = &params->erase_map;
 	const struct spi_nor_erase_type *erase = NULL;
 	struct mtd_info *mtd = &nor->mtd;
 	u32 wanted_size = nor->info->sector_size;
@@ -2225,7 +2245,7 @@ static int spi_nor_select_erase(struct spi_nor *nor)
 static int spi_nor_default_setup(struct spi_nor *nor,
 				 const struct spi_nor_hwcaps *hwcaps)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	u32 ignored_mask, shared_mask;
 	int err;
 
@@ -2285,8 +2305,10 @@ static int spi_nor_default_setup(struct spi_nor *nor,
 
 static int spi_nor_set_addr_nbytes(struct spi_nor *nor)
 {
-	if (nor->params->addr_nbytes) {
-		nor->addr_nbytes = nor->params->addr_nbytes;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	if (params->addr_nbytes) {
+		nor->addr_nbytes = params->addr_nbytes;
 	} else if (nor->read_proto == SNOR_PROTO_8_8_8_DTR) {
 		/*
 		 * In 8D-8D-8D mode, one byte takes half a cycle to transfer. So
@@ -2307,7 +2329,7 @@ static int spi_nor_set_addr_nbytes(struct spi_nor *nor)
 		nor->addr_nbytes = 3;
 	}
 
-	if (nor->addr_nbytes == 3 && nor->params->size > 0x1000000) {
+	if (nor->addr_nbytes == 3 && params->size > 0x1000000) {
 		/* enable 4-byte addressing if the device exceeds 16MiB */
 		nor->addr_nbytes = 4;
 	}
@@ -2329,10 +2351,11 @@ static int spi_nor_set_addr_nbytes(struct spi_nor *nor)
 static int spi_nor_setup(struct spi_nor *nor,
 			 const struct spi_nor_hwcaps *hwcaps)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
-	if (nor->params->setup)
-		ret = nor->params->setup(nor, hwcaps);
+	if (params->setup)
+		ret = params->setup(nor, hwcaps);
 	else
 		ret = spi_nor_default_setup(nor, hwcaps);
 	if (ret)
@@ -2367,7 +2390,7 @@ static void spi_nor_manufacturer_init_params(struct spi_nor *nor)
  */
 static void spi_nor_no_sfdp_init_params(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_nor_erase_map *map = &params->erase_map;
 	const u8 no_sfdp_flags = nor->info->no_sfdp_flags;
 	u8 i, erase_mask;
@@ -2492,6 +2515,8 @@ static void spi_nor_init_fixup_flags(struct spi_nor *nor)
  */
 static void spi_nor_late_init_params(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	if (nor->manufacturer && nor->manufacturer->fixups &&
 	    nor->manufacturer->fixups->late_init)
 		nor->manufacturer->fixups->late_init(nor);
@@ -2506,7 +2531,7 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
 	 * NOR protection support. When locking_ops are not provided, we pick
 	 * the default ones.
 	 */
-	if (nor->flags & SNOR_F_HAS_LOCK && !nor->params->locking_ops)
+	if (nor->flags & SNOR_F_HAS_LOCK && !params->locking_ops)
 		spi_nor_init_default_locking_ops(nor);
 }
 
@@ -2520,12 +2545,13 @@ static void spi_nor_late_init_params(struct spi_nor *nor)
  */
 static void spi_nor_sfdp_init_params_deprecated(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_nor_flash_parameter sfdp_params;
 
-	memcpy(&sfdp_params, nor->params, sizeof(sfdp_params));
+	memcpy(&sfdp_params, params, sizeof(sfdp_params));
 
 	if (spi_nor_parse_sfdp(nor)) {
-		memcpy(nor->params, &sfdp_params, sizeof(*nor->params));
+		memcpy(params, &sfdp_params, sizeof(*params));
 		nor->flags &= ~SNOR_F_4B_OPCODES;
 	}
 }
@@ -2560,7 +2586,7 @@ static void spi_nor_init_params_deprecated(struct spi_nor *nor)
  */
 static void spi_nor_init_default_params(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	const struct flash_info *info = nor->info;
 	struct device_node *np = spi_nor_get_flash_node(nor);
 
@@ -2646,12 +2672,15 @@ static void spi_nor_init_default_params(struct spi_nor *nor)
  */
 static int spi_nor_init_params(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
-	nor->params = devm_kzalloc(nor->dev, sizeof(*nor->params), GFP_KERNEL);
-	if (!nor->params)
+	params = devm_kzalloc(nor->dev, sizeof(*params), GFP_KERNEL);
+	if (!params)
 		return -ENOMEM;
 
+	spi_nor_set_params(nor, 0, params);
+
 	spi_nor_init_default_params(nor);
 
 	if (nor->info->parse_sfdp) {
@@ -2679,9 +2708,10 @@ static int spi_nor_init_params(struct spi_nor *nor)
  */
 static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
-	if (!nor->params->octal_dtr_enable)
+	if (!params->octal_dtr_enable)
 		return 0;
 
 	if (!(nor->read_proto == SNOR_PROTO_8_8_8_DTR &&
@@ -2691,7 +2721,7 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 	if (!(nor->flags & SNOR_F_IO_MODE_EN_VOLATILE))
 		return 0;
 
-	ret = nor->params->octal_dtr_enable(nor, enable);
+	ret = params->octal_dtr_enable(nor, enable);
 	if (ret)
 		return ret;
 
@@ -2711,18 +2741,21 @@ static int spi_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
  */
 static int spi_nor_quad_enable(struct spi_nor *nor)
 {
-	if (!nor->params->quad_enable)
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	if (!params->quad_enable)
 		return 0;
 
 	if (!(spi_nor_get_protocol_width(nor->read_proto) == 4 ||
 	      spi_nor_get_protocol_width(nor->write_proto) == 4))
 		return 0;
 
-	return nor->params->quad_enable(nor);
+	return params->quad_enable(nor);
 }
 
 static int spi_nor_init(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int err;
 
 	err = spi_nor_octal_dtr_enable(nor, true);
@@ -2764,7 +2797,7 @@ static int spi_nor_init(struct spi_nor *nor)
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		err = nor->params->set_4byte_addr_mode(nor, true);
+		err = params->set_4byte_addr_mode(nor, true);
 		if (err && err != -ENOTSUPP)
 			return err;
 	}
@@ -2880,12 +2913,14 @@ static void spi_nor_put_device(struct mtd_info *mtd)
 
 void spi_nor_restore(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params;
 	int ret;
 
 	/* restore the addressing mode */
 	if (nor->addr_nbytes == 4 && !(nor->flags & SNOR_F_4B_OPCODES) &&
 	    nor->flags & SNOR_F_BROKEN_RESET) {
-		ret = nor->params->set_4byte_addr_mode(nor, false);
+		params = spi_nor_get_params(nor, 0);
+		ret = params->set_4byte_addr_mode(nor, false);
 		if (ret)
 			/*
 			 * Do not stop the execution in the hope that the flash
@@ -2957,6 +2992,7 @@ static const struct flash_info *spi_nor_get_flash_info(struct spi_nor *nor,
 
 static void spi_nor_set_mtd_info(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct mtd_info *mtd = &nor->mtd;
 	struct device *dev = nor->dev;
 
@@ -2972,9 +3008,9 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 		mtd->flags |= MTD_NO_ERASE;
 	else
 		mtd->_erase = spi_nor_erase;
-	mtd->writesize = nor->params->writesize;
-	mtd->writebufsize = nor->params->page_size;
-	mtd->size = nor->params->size;
+	mtd->writesize = params->writesize;
+	mtd->writebufsize = params->page_size;
+	mtd->size = params->size;
 	mtd->_read = spi_nor_read;
 	/* Might be already set by some SST flashes. */
 	if (!mtd->_write)
@@ -3028,7 +3064,7 @@ int spi_nor_scan(struct spi_nor *nor, const char *name,
 	 * We need the bounce buffer early to read/write registers when going
 	 * through the spi-mem layer (buffers have to be DMA-able).
 	 * For spi-mem drivers, we'll reallocate a new buffer if
-	 * nor->params->page_size turns out to be greater than PAGE_SIZE (which
+	 * params->page_size turns out to be greater than PAGE_SIZE (which
 	 * shouldn't happen before long since NOR pages are usually less
 	 * than 1KB) after spi_nor_scan() returns.
 	 */
@@ -3099,13 +3135,14 @@ EXPORT_SYMBOL_GPL(spi_nor_scan);
 
 static int spi_nor_create_read_dirmap(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_mem_dirmap_info info = {
 		.op_tmpl = SPI_MEM_OP(SPI_MEM_OP_CMD(nor->read_opcode, 0),
 				      SPI_MEM_OP_ADDR(nor->addr_nbytes, 0, 0),
 				      SPI_MEM_OP_DUMMY(nor->read_dummy, 0),
 				      SPI_MEM_OP_DATA_IN(0, NULL, 0)),
 		.offset = 0,
-		.length = nor->params->size,
+		.length = params->size,
 	};
 	struct spi_mem_op *op = &info.op_tmpl;
 
@@ -3130,13 +3167,14 @@ static int spi_nor_create_read_dirmap(struct spi_nor *nor)
 
 static int spi_nor_create_write_dirmap(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_mem_dirmap_info info = {
 		.op_tmpl = SPI_MEM_OP(SPI_MEM_OP_CMD(nor->program_opcode, 0),
 				      SPI_MEM_OP_ADDR(nor->addr_nbytes, 0, 0),
 				      SPI_MEM_OP_NO_DUMMY,
 				      SPI_MEM_OP_DATA_OUT(0, NULL, 0)),
 		.offset = 0,
-		.length = nor->params->size,
+		.length = params->size,
 	};
 	struct spi_mem_op *op = &info.op_tmpl;
 
@@ -3159,6 +3197,7 @@ static int spi_nor_create_write_dirmap(struct spi_nor *nor)
 
 static int spi_nor_probe(struct spi_mem *spimem)
 {
+	struct spi_nor_flash_parameter *params;
 	struct spi_device *spi = spimem->spi;
 	struct flash_platform_data *data = dev_get_platdata(&spi->dev);
 	struct spi_nor *nor;
@@ -3205,13 +3244,15 @@ static int spi_nor_probe(struct spi_mem *spimem)
 
 	spi_nor_debugfs_register(nor);
 
+	params = spi_nor_get_params(nor, 0);
+
 	/*
 	 * None of the existing parts have > 512B pages, but let's play safe
 	 * and add this logic so that if anyone ever adds support for such
 	 * a NOR we don't end up with buffer overflows.
 	 */
-	if (nor->params->page_size > PAGE_SIZE) {
-		nor->bouncebuf_size = nor->params->page_size;
+	if (params->page_size > PAGE_SIZE) {
+		nor->bouncebuf_size = params->page_size;
 		devm_kfree(nor->dev, nor->bouncebuf);
 		nor->bouncebuf = devm_kmalloc(nor->dev,
 					      nor->bouncebuf_size,
diff --git a/drivers/mtd/spi-nor/debugfs.c b/drivers/mtd/spi-nor/debugfs.c
index ff895f6758ea..5689bfda1f2c 100644
--- a/drivers/mtd/spi-nor/debugfs.c
+++ b/drivers/mtd/spi-nor/debugfs.c
@@ -73,7 +73,7 @@ static void spi_nor_print_flags(struct seq_file *s, unsigned long flags,
 static int spi_nor_params_show(struct seq_file *s, void *data)
 {
 	struct spi_nor *nor = s->private;
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_nor_erase_map *erase_map = &params->erase_map;
 	struct spi_nor_erase_region *region;
 	const struct flash_info *info = nor->info;
@@ -181,7 +181,7 @@ static void spi_nor_print_pp_cmd(struct seq_file *s,
 static int spi_nor_capabilities_show(struct seq_file *s, void *data)
 {
 	struct spi_nor *nor = s->private;
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	u32 hwcaps = params->hwcaps.mask;
 	int i, cmd;
 
diff --git a/drivers/mtd/spi-nor/gigadevice.c b/drivers/mtd/spi-nor/gigadevice.c
index d57ddaf1525b..643f131d3916 100644
--- a/drivers/mtd/spi-nor/gigadevice.c
+++ b/drivers/mtd/spi-nor/gigadevice.c
@@ -13,6 +13,8 @@ gd25q256_post_bfpt(struct spi_nor *nor,
 		   const struct sfdp_parameter_header *bfpt_header,
 		   const struct sfdp_bfpt *bfpt)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/*
 	 * GD25Q256C supports the first version of JESD216 which does not define
 	 * the Quad Enable methods. Overwrite the default Quad Enable method.
@@ -24,7 +26,7 @@ gd25q256_post_bfpt(struct spi_nor *nor,
 	 */
 	if (bfpt_header->major == SFDP_JESD216_MAJOR &&
 	    bfpt_header->minor == SFDP_JESD216_MINOR)
-		nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+		params->quad_enable = spi_nor_sr1_bit6_quad_enable;
 
 	return 0;
 }
diff --git a/drivers/mtd/spi-nor/issi.c b/drivers/mtd/spi-nor/issi.c
index a0ddad2afffc..ccd13b73a75f 100644
--- a/drivers/mtd/spi-nor/issi.c
+++ b/drivers/mtd/spi-nor/issi.c
@@ -13,6 +13,8 @@ is25lp256_post_bfpt_fixups(struct spi_nor *nor,
 			   const struct sfdp_parameter_header *bfpt_header,
 			   const struct sfdp_bfpt *bfpt)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/*
 	 * IS25LP256 supports 4B opcodes, but the BFPT advertises
 	 * BFPT_DWORD1_ADDRESS_BYTES_3_ONLY.
@@ -20,7 +22,7 @@ is25lp256_post_bfpt_fixups(struct spi_nor *nor,
 	 */
 	if ((bfpt->dwords[BFPT_DWORD(1)] & BFPT_DWORD1_ADDRESS_BYTES_MASK) ==
 		BFPT_DWORD1_ADDRESS_BYTES_3_ONLY)
-		nor->params->addr_nbytes = 4;
+		params->addr_nbytes = 4;
 
 	return 0;
 }
@@ -31,7 +33,8 @@ static const struct spi_nor_fixups is25lp256_fixups = {
 
 static void pm25lv_nor_late_init(struct spi_nor *nor)
 {
-	struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	struct spi_nor_erase_map *map = &params->erase_map;
 	int i;
 
 	/* The PM25LV series has a different 4k sector erase opcode */
@@ -91,7 +94,9 @@ static const struct flash_info issi_nor_parts[] = {
 
 static void issi_nor_default_init(struct spi_nor *nor)
 {
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->quad_enable = spi_nor_sr1_bit6_quad_enable;
 }
 
 static const struct spi_nor_fixups issi_fixups = {
diff --git a/drivers/mtd/spi-nor/macronix.c b/drivers/mtd/spi-nor/macronix.c
index d81a4cb2812b..b78d0f57075c 100644
--- a/drivers/mtd/spi-nor/macronix.c
+++ b/drivers/mtd/spi-nor/macronix.c
@@ -104,8 +104,10 @@ static const struct flash_info macronix_nor_parts[] = {
 
 static void macronix_nor_default_init(struct spi_nor *nor)
 {
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
-	nor->params->set_4byte_addr_mode = spi_nor_set_4byte_addr_mode;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	params->set_4byte_addr_mode = spi_nor_set_4byte_addr_mode;
 }
 
 static const struct spi_nor_fixups macronix_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/micron-st.c b/drivers/mtd/spi-nor/micron-st.c
index 7bb86df52f0b..b93e16094b6c 100644
--- a/drivers/mtd/spi-nor/micron-st.c
+++ b/drivers/mtd/spi-nor/micron-st.c
@@ -49,10 +49,11 @@
 
 static int micron_st_nor_octal_dtr_en(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_mem_op op;
 	u8 *buf = nor->bouncebuf;
 	int ret;
-	u8 addr_mode_nbytes = nor->params->addr_mode_nbytes;
+	u8 addr_mode_nbytes = params->addr_mode_nbytes;
 
 	/* Use 20 dummy cycles for memory array reads. */
 	*buf = 20;
@@ -128,27 +129,31 @@ static int micron_st_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 
 static void mt35xu512aba_default_init(struct spi_nor *nor)
 {
-	nor->params->octal_dtr_enable = micron_st_nor_octal_dtr_enable;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->octal_dtr_enable = micron_st_nor_octal_dtr_enable;
 }
 
 static void mt35xu512aba_post_sfdp_fixup(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/* Set the Fast Read settings. */
-	nor->params->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
-	spi_nor_set_read_settings(&nor->params->reads[SNOR_CMD_READ_8_8_8_DTR],
+	params->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
+	spi_nor_set_read_settings(&params->reads[SNOR_CMD_READ_8_8_8_DTR],
 				  0, 20, SPINOR_OP_MT_DTR_RD,
 				  SNOR_PROTO_8_8_8_DTR);
 
 	nor->cmd_ext_type = SPI_NOR_EXT_REPEAT;
-	nor->params->rdsr_dummy = 8;
-	nor->params->rdsr_addr_nbytes = 0;
+	params->rdsr_dummy = 8;
+	params->rdsr_addr_nbytes = 0;
 
 	/*
 	 * The BFPT quad enable field is set to a reserved value so the quad
 	 * enable function is ignored by spi_nor_parse_bfpt(). Make sure we
 	 * disable it.
 	 */
-	nor->params->quad_enable = NULL;
+	params->quad_enable = NULL;
 }
 
 static const struct spi_nor_fixups mt35xu512aba_fixups = {
@@ -336,14 +341,15 @@ static int micron_st_nor_set_4byte_addr_mode(struct spi_nor *nor, bool enable)
  */
 static int micron_st_nor_read_fsr(struct spi_nor *nor, u8 *fsr)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
 	if (nor->spimem) {
 		struct spi_mem_op op = MICRON_ST_RDFSR_OP(fsr);
 
 		if (nor->reg_proto == SNOR_PROTO_8_8_8_DTR) {
-			op.addr.nbytes = nor->params->rdsr_addr_nbytes;
-			op.dummy.nbytes = nor->params->rdsr_dummy;
+			op.addr.nbytes = params->rdsr_addr_nbytes;
+			op.dummy.nbytes = params->rdsr_dummy;
 			/*
 			 * We don't want to read only one byte in DTR mode. So,
 			 * read 2 and then discard the second byte.
@@ -446,16 +452,20 @@ static int micron_st_nor_ready(struct spi_nor *nor)
 
 static void micron_st_nor_default_init(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	nor->flags |= SNOR_F_HAS_LOCK;
 	nor->flags &= ~SNOR_F_HAS_16BIT_SR;
-	nor->params->quad_enable = NULL;
-	nor->params->set_4byte_addr_mode = micron_st_nor_set_4byte_addr_mode;
+	params->quad_enable = NULL;
+	params->set_4byte_addr_mode = micron_st_nor_set_4byte_addr_mode;
 }
 
 static void micron_st_nor_late_init(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	if (nor->info->mfr_flags & USE_FSR)
-		nor->params->ready = micron_st_nor_ready;
+		params->ready = micron_st_nor_ready;
 }
 
 static const struct spi_nor_fixups micron_st_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/otp.c b/drivers/mtd/spi-nor/otp.c
index 00ab0d2d6d2f..a9c0844d55ef 100644
--- a/drivers/mtd/spi-nor/otp.c
+++ b/drivers/mtd/spi-nor/otp.c
@@ -222,7 +222,8 @@ int spi_nor_otp_is_locked_sr2(struct spi_nor *nor, unsigned int region)
 
 static loff_t spi_nor_otp_region_start(const struct spi_nor *nor, unsigned int region)
 {
-	const struct spi_nor_otp_organization *org = nor->params->otp.org;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_otp_organization *org = params->otp.org;
 
 	return org->base + region * org->offset;
 }
@@ -247,7 +248,8 @@ static int spi_nor_mtd_otp_info(struct mtd_info *mtd, size_t len,
 				size_t *retlen, struct otp_info *buf)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_otp_ops *ops = params->otp.ops;
 	unsigned int n_regions = spi_nor_otp_n_regions(nor);
 	unsigned int i;
 	int ret, locked;
@@ -284,7 +286,8 @@ static int spi_nor_mtd_otp_info(struct mtd_info *mtd, size_t len,
 static int spi_nor_mtd_otp_range_is_locked(struct spi_nor *nor, loff_t ofs,
 					   size_t len)
 {
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_otp_ops *ops = params->otp.ops;
 	unsigned int region;
 	int locked;
 
@@ -309,7 +312,8 @@ static int spi_nor_mtd_otp_read_write(struct mtd_info *mtd, loff_t ofs,
 				      const u8 *buf, bool is_write)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_otp_ops *ops = params->otp.ops;
 	const size_t rlen = spi_nor_otp_region_len(nor);
 	loff_t rstart, rofs;
 	unsigned int region;
@@ -395,7 +399,8 @@ static int spi_nor_mtd_otp_write(struct mtd_info *mtd, loff_t to, size_t len,
 static int spi_nor_mtd_otp_erase(struct mtd_info *mtd, loff_t from, size_t len)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_otp_ops *ops = params->otp.ops;
 	const size_t rlen = spi_nor_otp_region_len(nor);
 	unsigned int region;
 	loff_t rstart;
@@ -448,7 +453,8 @@ static int spi_nor_mtd_otp_erase(struct mtd_info *mtd, loff_t from, size_t len)
 static int spi_nor_mtd_otp_lock(struct mtd_info *mtd, loff_t from, size_t len)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	const struct spi_nor_otp_ops *ops = params->otp.ops;
 	const size_t rlen = spi_nor_otp_region_len(nor);
 	unsigned int region;
 	int ret;
@@ -482,9 +488,10 @@ static int spi_nor_mtd_otp_lock(struct mtd_info *mtd, loff_t from, size_t len)
 
 void spi_nor_set_mtd_otp_ops(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct mtd_info *mtd = &nor->mtd;
 
-	if (!nor->params->otp.ops)
+	if (!params->otp.ops)
 		return;
 
 	if (WARN_ON(!is_power_of_2(spi_nor_otp_region_len(nor))))
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 8434f654eca1..09814adf8620 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -431,7 +431,7 @@ static void spi_nor_regions_sort_erase_types(struct spi_nor_erase_map *map)
 static int spi_nor_parse_bfpt(struct spi_nor *nor,
 			      const struct sfdp_parameter_header *bfpt_header)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_nor_erase_map *map = &params->erase_map;
 	struct spi_nor_erase_type *erase_type = map->erase_type;
 	struct sfdp_bfpt bfpt;
@@ -645,6 +645,8 @@ static int spi_nor_parse_bfpt(struct spi_nor *nor,
  */
 static u8 spi_nor_smpt_addr_nbytes(const struct spi_nor *nor, const u32 settings)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	switch (settings & SMPT_CMD_ADDRESS_LEN_MASK) {
 	case SMPT_CMD_ADDRESS_LEN_0:
 		return 0;
@@ -654,7 +656,7 @@ static u8 spi_nor_smpt_addr_nbytes(const struct spi_nor *nor, const u32 settings
 		return 4;
 	case SMPT_CMD_ADDRESS_LEN_USE_CURRENT:
 	default:
-		return nor->params->addr_mode_nbytes;
+		return params->addr_mode_nbytes;
 	}
 }
 
@@ -806,7 +808,8 @@ spi_nor_region_check_overlay(struct spi_nor_erase_region *region,
 static int spi_nor_init_non_uniform_erase_map(struct spi_nor *nor,
 					      const u32 *smpt)
 {
-	struct spi_nor_erase_map *map = &nor->params->erase_map;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	struct spi_nor_erase_map *map = &params->erase_map;
 	struct spi_nor_erase_type *erase = map->erase_type;
 	struct spi_nor_erase_region *region;
 	u64 offset;
@@ -894,6 +897,7 @@ static int spi_nor_init_non_uniform_erase_map(struct spi_nor *nor,
 static int spi_nor_parse_smpt(struct spi_nor *nor,
 			      const struct sfdp_parameter_header *smpt_header)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	const u32 *sector_map;
 	u32 *smpt;
 	size_t len;
@@ -924,7 +928,7 @@ static int spi_nor_parse_smpt(struct spi_nor *nor,
 	if (ret)
 		goto out;
 
-	spi_nor_regions_sort_erase_types(&nor->params->erase_map);
+	spi_nor_regions_sort_erase_types(&params->erase_map);
 	/* fall through */
 out:
 	kfree(smpt);
@@ -964,7 +968,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 		{ 0u /* not used */,		BIT(11) },
 		{ 0u /* not used */,		BIT(12) },
 	};
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_nor_pp_command *params_pp = params->page_programs;
 	struct spi_nor_erase_map *map = &params->erase_map;
 	struct spi_nor_erase_type *erase_type = map->erase_type;
@@ -1127,6 +1131,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 static int spi_nor_parse_profile1(struct spi_nor *nor,
 				  const struct sfdp_parameter_header *profile1_header)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	u32 *dwords, addr;
 	size_t len;
 	int ret;
@@ -1149,14 +1154,14 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 
 	 /* Set the Read Status Register dummy cycles and dummy address bytes. */
 	if (dwords[0] & PROFILE1_DWORD1_RDSR_DUMMY)
-		nor->params->rdsr_dummy = 8;
+		params->rdsr_dummy = 8;
 	else
-		nor->params->rdsr_dummy = 4;
+		params->rdsr_dummy = 4;
 
 	if (dwords[0] & PROFILE1_DWORD1_RDSR_ADDR_BYTES)
-		nor->params->rdsr_addr_nbytes = 4;
+		params->rdsr_addr_nbytes = 4;
 	else
-		nor->params->rdsr_addr_nbytes = 0;
+		params->rdsr_addr_nbytes = 0;
 
 	/*
 	 * We don't know what speed the controller is running at. Find the
@@ -1182,8 +1187,8 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	dummy = round_up(dummy, 2);
 
 	/* Update the fast read settings. */
-	nor->params->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
-	spi_nor_set_read_settings(&nor->params->reads[SNOR_CMD_READ_8_8_8_DTR],
+	params->hwcaps.mask |= SNOR_HWCAPS_READ_8_8_8_DTR;
+	spi_nor_set_read_settings(&params->reads[SNOR_CMD_READ_8_8_8_DTR],
 				  0, dummy, opcode,
 				  SNOR_PROTO_8_8_8_DTR);
 
@@ -1191,7 +1196,7 @@ static int spi_nor_parse_profile1(struct spi_nor *nor,
 	 * Page Program is "Required Command" in the xSPI Profile 1.0. Update
 	 * the params->hwcaps.mask here.
 	 */
-	nor->params->hwcaps.mask |= SNOR_HWCAPS_PP_8_8_8_DTR;
+	params->hwcaps.mask |= SNOR_HWCAPS_PP_8_8_8_DTR;
 
 out:
 	kfree(dwords);
diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index b621cdfd506f..30bfe9db6210 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -46,10 +46,11 @@
 
 static int cypress_nor_octal_dtr_en(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_mem_op op;
 	u8 *buf = nor->bouncebuf;
 	int ret;
-	u8 addr_mode_nbytes = nor->params->addr_mode_nbytes;
+	u8 addr_mode_nbytes = params->addr_mode_nbytes;
 
 	/* Use 24 dummy cycles for memory array reads. */
 	*buf = SPINOR_REG_CYPRESS_CFR2V_MEMLAT_11_24;
@@ -136,8 +137,9 @@ static int cypress_nor_octal_dtr_dis(struct spi_nor *nor)
  */
 static int cypress_nor_quad_enable_volatile(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_mem_op op;
-	u8 addr_mode_nbytes = nor->params->addr_mode_nbytes;
+	u8 addr_mode_nbytes = params->addr_mode_nbytes;
 	u8 cfr1v_written;
 	int ret;
 
@@ -195,8 +197,9 @@ static int cypress_nor_quad_enable_volatile(struct spi_nor *nor)
  */
 static int cypress_nor_set_page_size(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_mem_op op =
-		CYPRESS_NOR_RD_ANY_REG_OP(nor->params->addr_mode_nbytes,
+		CYPRESS_NOR_RD_ANY_REG_OP(params->addr_mode_nbytes,
 					  SPINOR_REG_CYPRESS_CFR3V,
 					  nor->bouncebuf);
 	int ret;
@@ -206,9 +209,9 @@ static int cypress_nor_set_page_size(struct spi_nor *nor)
 		return ret;
 
 	if (nor->bouncebuf[0] & SPINOR_REG_CYPRESS_CFR3V_PGSZ)
-		nor->params->page_size = 512;
+		params->page_size = 512;
 	else
-		nor->params->page_size = 256;
+		params->page_size = 256;
 
 	return 0;
 }
@@ -218,16 +221,19 @@ s25hx_t_post_bfpt_fixup(struct spi_nor *nor,
 			const struct sfdp_parameter_header *bfpt_header,
 			const struct sfdp_bfpt *bfpt)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/* Replace Quad Enable with volatile version */
-	nor->params->quad_enable = cypress_nor_quad_enable_volatile;
+	params->quad_enable = cypress_nor_quad_enable_volatile;
 
 	return cypress_nor_set_page_size(nor);
 }
 
 static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct spi_nor_erase_type *erase_type =
-					nor->params->erase_map.erase_type;
+					params->erase_map.erase_type;
 	unsigned int i;
 
 	/*
@@ -250,7 +256,7 @@ static void s25hx_t_post_sfdp_fixup(struct spi_nor *nor)
 
 static void s25hx_t_late_init(struct spi_nor *nor)
 {
-	struct spi_nor_flash_parameter *params = nor->params;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 
 	/* Fast Read 4B requires mode cycles */
 	params->reads[SNOR_CMD_READ_FAST].num_mode_clocks = 8;
@@ -283,22 +289,24 @@ static int cypress_nor_octal_dtr_enable(struct spi_nor *nor, bool enable)
 
 static void s28hx_t_post_sfdp_fixup(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/*
 	 * On older versions of the flash the xSPI Profile 1.0 table has the
 	 * 8D-8D-8D Fast Read opcode as 0x00. But it actually should be 0xEE.
 	 */
-	if (nor->params->reads[SNOR_CMD_READ_8_8_8_DTR].opcode == 0)
-		nor->params->reads[SNOR_CMD_READ_8_8_8_DTR].opcode =
+	if (params->reads[SNOR_CMD_READ_8_8_8_DTR].opcode == 0)
+		params->reads[SNOR_CMD_READ_8_8_8_DTR].opcode =
 			SPINOR_OP_CYPRESS_RD_FAST;
 
 	/* This flash is also missing the 4-byte Page Program opcode bit. */
-	spi_nor_set_pp_settings(&nor->params->page_programs[SNOR_CMD_PP],
+	spi_nor_set_pp_settings(&params->page_programs[SNOR_CMD_PP],
 				SPINOR_OP_PP_4B, SNOR_PROTO_1_1_1);
 	/*
 	 * Since xSPI Page Program opcode is backward compatible with
 	 * Legacy SPI, use Legacy SPI opcode there as well.
 	 */
-	spi_nor_set_pp_settings(&nor->params->page_programs[SNOR_CMD_PP_8_8_8_DTR],
+	spi_nor_set_pp_settings(&params->page_programs[SNOR_CMD_PP_8_8_8_DTR],
 				SPINOR_OP_PP_4B, SNOR_PROTO_8_8_8_DTR);
 
 	/*
@@ -306,7 +314,7 @@ static void s28hx_t_post_sfdp_fixup(struct spi_nor *nor)
 	 * address bytes needed for Read Status Register command as 0 but the
 	 * actual value for that is 4.
 	 */
-	nor->params->rdsr_addr_nbytes = 4;
+	params->rdsr_addr_nbytes = 4;
 }
 
 static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
@@ -318,8 +326,10 @@ static int s28hx_t_post_bfpt_fixup(struct spi_nor *nor,
 
 static void s28hx_t_late_init(struct spi_nor *nor)
 {
-	nor->params->octal_dtr_enable = cypress_nor_octal_dtr_enable;
-	nor->params->writesize = 16;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->octal_dtr_enable = cypress_nor_octal_dtr_enable;
+	params->writesize = 16;
 }
 
 static const struct spi_nor_fixups s28hx_t_fixups = {
@@ -333,13 +343,15 @@ s25fs_s_nor_post_bfpt_fixups(struct spi_nor *nor,
 			     const struct sfdp_parameter_header *bfpt_header,
 			     const struct sfdp_bfpt *bfpt)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
 	/*
 	 * The S25FS-S chip family reports 512-byte pages in BFPT but
 	 * in reality the write buffer still wraps at the safe default
 	 * of 256 bytes.  Overwrite the page size advertised by BFPT
 	 * to get the writes working.
 	 */
-	nor->params->page_size = 256;
+	params->page_size = 256;
 
 	return 0;
 }
@@ -541,7 +553,9 @@ static int spansion_nor_sr_ready_and_clear(struct spi_nor *nor)
 
 static void spansion_nor_late_init(struct spi_nor *nor)
 {
-	if (nor->params->size > SZ_16M) {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	if (params->size > SZ_16M) {
 		nor->flags |= SNOR_F_4B_OPCODES;
 		/* No small sector erase for 4-byte command set */
 		nor->erase_opcode = SPINOR_OP_SE;
@@ -549,7 +563,7 @@ static void spansion_nor_late_init(struct spi_nor *nor)
 	}
 
 	if (nor->info->mfr_flags & USE_CLSR)
-		nor->params->ready = spansion_nor_sr_ready_and_clear;
+		params->ready = spansion_nor_sr_ready_and_clear;
 }
 
 static const struct spi_nor_fixups spansion_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/sst.c b/drivers/mtd/spi-nor/sst.c
index 63bcc97bf978..6b91a32804ad 100644
--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -20,10 +20,11 @@ static int sst26vf_nor_lock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 
 static int sst26vf_nor_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
 	/* We only support unlocking the entire flash array. */
-	if (ofs != 0 || len != nor->params->size)
+	if (ofs != 0 || len != params->size)
 		return -EINVAL;
 
 	ret = spi_nor_read_cr(nor, nor->bouncebuf);
@@ -51,7 +52,9 @@ static const struct spi_nor_locking_ops sst26vf_nor_locking_ops = {
 
 static void sst26vf_nor_late_init(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &sst26vf_nor_locking_ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->locking_ops = &sst26vf_nor_locking_ops;
 }
 
 static const struct spi_nor_fixups sst26vf_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/swp.c b/drivers/mtd/spi-nor/swp.c
index 1f178313ba8f..88eaed2c40fe 100644
--- a/drivers/mtd/spi-nor/swp.c
+++ b/drivers/mtd/spi-nor/swp.c
@@ -340,11 +340,14 @@ static const struct spi_nor_locking_ops spi_nor_sr_locking_ops = {
 
 void spi_nor_init_default_locking_ops(struct spi_nor *nor)
 {
-	nor->params->locking_ops = &spi_nor_sr_locking_ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->locking_ops = &spi_nor_sr_locking_ops;
 }
 
 static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
+	struct spi_nor_flash_parameter *params;
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
 	int ret;
 
@@ -352,7 +355,8 @@ static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	if (ret)
 		return ret;
 
-	ret = nor->params->locking_ops->lock(nor, ofs, len);
+	params = spi_nor_get_params(nor, 0);
+	ret = params->locking_ops->lock(nor, ofs, len);
 
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
@@ -360,6 +364,7 @@ static int spi_nor_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 static int spi_nor_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
+	struct spi_nor_flash_parameter *params;
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
 	int ret;
 
@@ -367,7 +372,8 @@ static int spi_nor_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	if (ret)
 		return ret;
 
-	ret = nor->params->locking_ops->unlock(nor, ofs, len);
+	params = spi_nor_get_params(nor, 0);
+	ret = params->locking_ops->unlock(nor, ofs, len);
 
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
@@ -375,6 +381,7 @@ static int spi_nor_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 
 static int spi_nor_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 {
+	struct spi_nor_flash_parameter *params;
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
 	int ret;
 
@@ -382,7 +389,8 @@ static int spi_nor_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
 	if (ret)
 		return ret;
 
-	ret = nor->params->locking_ops->is_locked(nor, ofs, len);
+	params = spi_nor_get_params(nor, 0);
+	ret = params->locking_ops->is_locked(nor, ofs, len);
 
 	spi_nor_unlock_and_unprep(nor);
 	return ret;
@@ -402,6 +410,7 @@ static int spi_nor_is_locked(struct mtd_info *mtd, loff_t ofs, uint64_t len)
  */
 void spi_nor_try_unlock_all(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	int ret;
 
 	if (!(nor->flags & SNOR_F_HAS_LOCK))
@@ -409,16 +418,17 @@ void spi_nor_try_unlock_all(struct spi_nor *nor)
 
 	dev_dbg(nor->dev, "Unprotecting entire flash array\n");
 
-	ret = spi_nor_unlock(&nor->mtd, 0, nor->params->size);
+	ret = spi_nor_unlock(&nor->mtd, 0, params->size);
 	if (ret)
 		dev_dbg(nor->dev, "Failed to unlock the entire flash memory array\n");
 }
 
 void spi_nor_set_mtd_locking_ops(struct spi_nor *nor)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	struct mtd_info *mtd = &nor->mtd;
 
-	if (!nor->params->locking_ops)
+	if (!params->locking_ops)
 		return;
 
 	mtd->_lock = spi_nor_lock;
diff --git a/drivers/mtd/spi-nor/winbond.c b/drivers/mtd/spi-nor/winbond.c
index ca39acf4112c..ce321e40d2f4 100644
--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -218,13 +218,17 @@ static const struct spi_nor_otp_ops winbond_nor_otp_ops = {
 
 static void winbond_nor_default_init(struct spi_nor *nor)
 {
-	nor->params->set_4byte_addr_mode = winbond_nor_set_4byte_addr_mode;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->set_4byte_addr_mode = winbond_nor_set_4byte_addr_mode;
 }
 
 static void winbond_nor_late_init(struct spi_nor *nor)
 {
-	if (nor->params->otp.org->n_regions)
-		nor->params->otp.ops = &winbond_nor_otp_ops;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	if (params->otp.org->n_regions)
+		params->otp.ops = &winbond_nor_otp_ops;
 }
 
 static const struct spi_nor_fixups winbond_nor_fixups = {
diff --git a/drivers/mtd/spi-nor/xilinx.c b/drivers/mtd/spi-nor/xilinx.c
index 5723157739fc..6c5da0e0f9a4 100644
--- a/drivers/mtd/spi-nor/xilinx.c
+++ b/drivers/mtd/spi-nor/xilinx.c
@@ -55,7 +55,8 @@ static const struct flash_info xilinx_nor_parts[] = {
  */
 static u32 s3an_nor_convert_addr(struct spi_nor *nor, u32 addr)
 {
-	u32 page_size = nor->params->page_size;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+	u32 page_size = params->page_size;
 	u32 offset, page;
 
 	offset = addr % page_size;
@@ -115,6 +116,7 @@ static int xilinx_nor_sr_ready(struct spi_nor *nor)
 static int xilinx_nor_setup(struct spi_nor *nor,
 			    const struct spi_nor_hwcaps *hwcaps)
 {
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
 	u32 page_size;
 	int ret;
 
@@ -140,14 +142,14 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 	 */
 	if (nor->bouncebuf[0] & XSR_PAGESIZE) {
 		/* Flash in Power of 2 mode */
-		page_size = (nor->params->page_size == 264) ? 256 : 512;
-		nor->params->page_size = page_size;
+		page_size = (params->page_size == 264) ? 256 : 512;
+		params->page_size = page_size;
 		nor->mtd.writebufsize = page_size;
-		nor->params->size = 8 * page_size * nor->info->n_sectors;
+		params->size = 8 * page_size * nor->info->n_sectors;
 		nor->mtd.erasesize = 8 * page_size;
 	} else {
 		/* Flash in Default addressing mode */
-		nor->params->convert_addr = s3an_nor_convert_addr;
+		params->convert_addr = s3an_nor_convert_addr;
 		nor->mtd.erasesize = nor->info->sector_size;
 	}
 
@@ -156,8 +158,10 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 
 static void xilinx_nor_late_init(struct spi_nor *nor)
 {
-	nor->params->setup = xilinx_nor_setup;
-	nor->params->ready = xilinx_nor_sr_ready;
+	struct spi_nor_flash_parameter *params = spi_nor_get_params(nor, 0);
+
+	params->setup = xilinx_nor_setup;
+	params->ready = xilinx_nor_sr_ready;
 }
 
 static const struct spi_nor_fixups xilinx_nor_fixups = {
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 25765556223a..728674ea3c22 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -421,6 +421,16 @@ static inline struct device_node *spi_nor_get_flash_node(struct spi_nor *nor)
 	return mtd_get_of_node(&nor->mtd);
 }
 
+static inline struct spi_nor_flash_parameter *spi_nor_get_params(const struct spi_nor *nor, u8 idx)
+{
+	return nor->params;
+}
+
+static inline void spi_nor_set_params(struct spi_nor *nor, u8 idx,
+				      struct spi_nor_flash_parameter *params)
+{
+	nor->params = params;
+}
 /**
  * spi_nor_scan() - scan the SPI NOR
  * @nor:	the spi_nor structure
-- 
2.17.1

