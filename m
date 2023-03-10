Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663076B4F0A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 18:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbjCJRjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 12:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjCJRja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 12:39:30 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7421A4A7;
        Fri, 10 Mar 2023 09:38:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeLakNGNekktQ9oH29ROiRoBrn5Fy8JMa+Ixr9JNlq6Mcz/p766bsSWfvQgeSzLmiwaqi5rLerlq885EtAabapDFFR06LpAZGCpBkBo+C49yGzC0ubMgmYkMs4rkaztKJXRyGHsOiUOKmdsi5eAicZvD55jnSU99SdnRFr8vzSSPtNG69znKTauNCJ6hZPRhNHno9jAIQblL6Fpo0zprBIVEUoB5FvxlRU3UAGInf59/nm4LXnJTwF4kmN53PbbVA3PN05Y0TLFcV9yVr5hl89YZD+LEZDDbKGGsBYmGcQ5mAl/ZoZDRkzzjIPv7LLorZpeXOdJjSbr+PBKwLlIdug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81s+8TCJ7jCbm+CdMdkkcrMQFPnQni896CqX3sAY8EM=;
 b=LvwHtEPmgof7fsDnf/6UG+CZvMdV7kVEZ617+02yb8IOeZYaWqXzxFkXtVULD+jTr2JuCDxGP1ev6ZvVBwN4oxF1IyRoPK0+BOu+SLQD+wdVdVK4tCNS32hL7f8i+xQH204ogdTZ/BKTOhE/ifboaTQFcgCnEH1O6dT8ptkgE9wf7xtR2bfEQV5t7qQa2YBHg2jjCAs93ak5zbMckhHV6hUuVcE2/Iszrka3kbPtYc1WI7IiYPKZGwbW+MQQ0pwsq2B7fl9guCdbTXHBhPxyQYoHDbGDeM8vQiM5I9yE7uvJ4PKcy0KqOFglrsKPhH+8QETnTHk98WLAY3Vm8PfSQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81s+8TCJ7jCbm+CdMdkkcrMQFPnQni896CqX3sAY8EM=;
 b=QlVtaqUmf8kADsI1gF1aBW5cbbezrae44CYVjuxs7DW36rHYfBzgRM6JVh1mBK7r/WlCJ9GPAtcSI/Ijn53GWyzRUXDq+c6glCy02iUGX4B+3VMs+6H7FbVodFf9NdygegJVeNAo+aq2oR5V4KcUQWj6K3lMRB4tGfVVQJFgGXA=
Received: from BN9PR03CA0295.namprd03.prod.outlook.com (2603:10b6:408:f5::30)
 by MN0PR12MB6080.namprd12.prod.outlook.com (2603:10b6:208:3c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Fri, 10 Mar
 2023 17:37:47 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::44) by BN9PR03CA0295.outlook.office365.com
 (2603:10b6:408:f5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Fri, 10 Mar 2023 17:37:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.19 via Frontend Transport; Fri, 10 Mar 2023 17:37:47 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:37:46 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Mar
 2023 11:37:46 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 10 Mar 2023 11:37:19 -0600
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
Subject: [PATCH V6 10/15] mtd: spi-nor: Convert macros with inline functions
Date:   Fri, 10 Mar 2023 23:02:12 +0530
Message-ID: <20230310173217.3429788-11-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
References: <20230310173217.3429788-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT008:EE_|MN0PR12MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: fd36cdfe-4339-4904-33a6-08db218e29d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +7AdhxKj+IbKYweXW5YhHmvXoMT0r8zLxWe0ZY5RkP66vsRzRROiPjf1wnS6n++7geWeya8KbrcVP6JhZcglyd0QWt9lGoEtHS1BTUAjUtYZqELbw69plm3+9YB34fMKoQpNxzq590jBXYpzqqkOL1Wo1BPRvGF26jvEDWrpphxd/A87bYyRA6+yEo2WMdkIPz39BJyBNpczVG4oPa6AkOL/W/dYYzqcGygxBi3eLdO5PTykQHROOZ6lrHQYXvKdTmJPNtNHlMtG7vo4tHJpgqRFCKMKrKBSGQNZ2S3pO7DLdImURPOkXFMkIciaBJOOWGHORyPMvFMiFM+ySrheAyTiOi3HqtNS8KhDI2m5oKLiPQctcR0R3mLPJ53hGqKbHpAAdmmeLuD+nbR1S83dYA9Q5XlkPBCt2f68qFLZlqTowy5e780MWScvikXMH6lJIdLUg03+YcXClBRQAGwrXOu4ailsv4cPkkfP4STf1UG7tfyXaRMS+ApgT3c06+NyL7hNzhw7wLpqZBHMMZX6yTZ/Q/z90hindfodh+/849Hd/Ejr45UUGZwxcUgD0MIxp2v1EjzO3LKqQzHJ/gKJl9LjGZZeSF7IpCoFKIRC77xPvTWGwSvNVbVmZLlzY2898bGKohfE8G4etGFU2cyPB9rarVRK1WUk7Kw5DiJdHe/Xg1fOaP60ODAMj1Tj5zxJMJ22sV9bPBqD45YEb1cJwzobo81vsdDMt+y11UCd2XPEfLGSxzg6nwk6k/tVonvPU1Hvu5Caxoth4hKvs1ymYzh5DkIveYebQ0a6yP8cAi21cTJ5TgdUSu7SWCanK48HjHu9kKrJ0o5bi0eOYaBAb0Y23QTEHImO3yh9SMpmlKM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(46966006)(40470700004)(336012)(36756003)(426003)(110136005)(54906003)(7366002)(40460700003)(7276002)(7406005)(186003)(356005)(7336002)(478600001)(1076003)(7416002)(921005)(82310400005)(2906002)(2616005)(26005)(40480700001)(1191002)(6666004)(86362001)(8936002)(81166007)(82740400003)(5660300002)(83380400001)(8676002)(70586007)(70206006)(4326008)(36860700001)(41300700001)(316002)(47076005)(41080700001)(36900700001)(2101003)(83996005)(84006005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:37:47.2758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd36cdfe-4339-4904-33a6-08db218e29d8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6080
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In further patches the nor->params references in
spi_nor_otp_region_len(nor) & spi_nor_otp_n_regions(nor) macros will be
replaced with spi_nor_get_params() API. To make the transition smoother,
first converting the macros into static inline functions.

Suggested-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
---
 drivers/mtd/spi-nor/otp.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/otp.c b/drivers/mtd/spi-nor/otp.c
index 00ab0d2d6d2f..3d75899de303 100644
--- a/drivers/mtd/spi-nor/otp.c
+++ b/drivers/mtd/spi-nor/otp.c
@@ -11,8 +11,27 @@
 
 #include "core.h"
 
-#define spi_nor_otp_region_len(nor) ((nor)->params->otp.org->len)
-#define spi_nor_otp_n_regions(nor) ((nor)->params->otp.org->n_regions)
+/**
+ * spi_nor_otp_region_len() - get size of one OTP region in bytes
+ * @nor:        pointer to 'struct spi_nor'
+ *
+ * Return: size of one OTP region in bytes
+ */
+static inline unsigned int spi_nor_otp_region_len(struct spi_nor *nor)
+{
+	return nor->params->otp.org->len;
+}
+
+/**
+ * spi_nor_otp_n_regions() - get number of individual OTP regions
+ * @nor:        pointer to 'struct spi_nor'
+ *
+ * Return: number of individual OTP regions
+ */
+static inline unsigned int spi_nor_otp_n_regions(struct spi_nor *nor)
+{
+	return nor->params->otp.org->n_regions;
+}
 
 /**
  * spi_nor_otp_read_secr() - read security register
-- 
2.25.1

