Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9027E6ACA39
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCFR2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:28:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCFR2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:28:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01C41A4;
        Mon,  6 Mar 2023 09:27:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZg5AT2puwJrpoS2k1CFA7Fof0gXKgyATrEQcuRv2N5b9TX0CvUl16MfuEzEvr5XUTXr/98YZTBFri3oaPs1bVdmFU41s6N3qiKp9SeD8exwy7gFS5kNHGkTtQMI6zceFY/m2rwCtISmsImnD15r1vfHFtCMGsZAtm1GSEO5tWXlGUxXGYQMMJtyY0njO6mvwdZdn7R9j+PRdhIPV8pFk2Uk6ieU2AvbcSZvexyXd/4p+jm/lUcQFdrfpBzqG+8qHXHPL+OwE4fMFRNcJ4qxHEidLhWlm4KjX5w0G1M4naMf9BG0aEu1zXzCHCB+ql1sekS1WXrOiEahJyHNZdLPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81s+8TCJ7jCbm+CdMdkkcrMQFPnQni896CqX3sAY8EM=;
 b=GP+bj0l0i7ptKMwT8OM0vzvTCbQKt0sRPXZqeZcamqsZUjsUzmi6zvs4gbDQlguERV5uaP5/6ttiM6uscAaF80dy4L6wrdgymaSYdeedrDwpNjcyv1SV5XJMfcRcKZHIJ5MbAuCsBoC7+tTmmee0kBcLsu5IfQteAHdhR0q+CKmbKYbzMp5+oa/KA/jGJESmTfqPUiWU8O1tWeZ9Prlgrhr2qHJkoEvja0fCvkuScWqm+vp6qd9t41nhobG+G2E0zfLvWzwT5ghTL3XKqhpUUSZSMngJNAoFE1totcSJQVcNbMVLfBv2FRW0E6hisEW6cr4413GeJ70xRrtD8Q2eGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81s+8TCJ7jCbm+CdMdkkcrMQFPnQni896CqX3sAY8EM=;
 b=WGqp0HW8qHtBghSW8V3nIAlRRvNH1SjEUolBjgZa+g5Ea2utzEg0zHFYwflWXzLxNIIMGFmrsoH0YYhvSVVeJmVE/LZTupOUuErUk0N1JCl7pNwJ0L+bJ3tj1xLr82w81PhbkcTJ7SccrdgZiIl0w0x3FFJaIS9YjayQQG2Zd/o=
Received: from DS7PR03CA0152.namprd03.prod.outlook.com (2603:10b6:5:3b2::7) by
 SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Mon, 6 Mar 2023 17:27:24 +0000
Received: from CY4PEPF0000B8E9.namprd05.prod.outlook.com
 (2603:10b6:5:3b2:cafe::a7) by DS7PR03CA0152.outlook.office365.com
 (2603:10b6:5:3b2::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28 via Frontend
 Transport; Mon, 6 Mar 2023 17:27:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8E9.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.4 via Frontend Transport; Mon, 6 Mar 2023 17:27:23 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:27:22 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Mar
 2023 11:27:20 -0600
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Mon, 6 Mar 2023 11:26:53 -0600
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
Subject: [PATCH V5 10/15] mtd: spi-nor: Convert macros with inline functions
Date:   Mon, 6 Mar 2023 22:51:04 +0530
Message-ID: <20230306172109.595464-11-amit.kumar-mahapatra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E9:EE_|SA0PR12MB4445:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f0c3563-0db1-4e00-970e-08db1e680cb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hETlFU7BbPuy59QUdy4OEMz4eK35Z6y1CnZe66eZ30R79RPx2YJ524efSpUr4NcbyckGiqnMLdYWRsCxpiImYlmCwojrVI5f3oZUhTuogdccWRWLZkxAjYa+HCMTmKx9QgJV8ld2HgPgYENqo1CxlDVV4P8yWnNDihig3C2l1DUkgRDf40UkaiLXwvkVn583Mpo1akvOUxs4+B4zt9InRuepzz4s4/qZmtBvh5Mk7TtQ0T5qd5GZ1mKQsis0eiVzugOHlQCxuiuQDaIPuHV0uotmTK6/LSR7TO7slZ4IzJTapsAn1nFR2BmXRVV7vO6Z2fRbSh+TeJthkzzel0YWWEC/qoTPWw0N9FeWWfGtDw9YxNNPqowAi5kWYttLlO9qd6Ha1Y5LdRzSuLdFMkQ9OZtQISF0eg7zKXeyz5YTUIxXSshzOkS5TpGZu08mhMTi4ZRmSkq7d1/Y6otoTMG6ztBx6mTgcZD+3kayq/2RTVwq6O0PXZFFzpivSSXEs3j7uYeyttLigWIw3FIpbmYRwyYfC8xLPiVmfzSTgjHoDWYtaK6QA2ChUhYK88t60/+uCDOyzFv5nmq+fdf70Ar1I8QC/6j2yeurmCoMjtpvEm4AsADCb753QSGGs2JdUJ6yCqZIODUpjz29PClE4ujKlCuXKn2aexxxJgCm9NGRArlk7tp+sttxYM0plTNgUL/zbMRxyMDjkW9QoZRpOhOtQbwG6w6e4aGXQYlyB+XELcyE8W16OT5yGbm+iu9lR+bRjJvYY/wLq6Xpsvnsnc3U40raxhFRCTL5/bQHFeXSc+uaBQV2937p8z04E2gxg2qwC52/7zF9MX2CV/X0Xl9Tf/lBGJ/4vC85zgDKQI7uiVw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(1076003)(36860700001)(6666004)(36756003)(47076005)(426003)(82310400005)(83380400001)(921005)(356005)(40460700003)(86362001)(1191002)(81166007)(40480700001)(82740400003)(186003)(336012)(26005)(2616005)(41300700001)(70206006)(70586007)(8676002)(4326008)(2906002)(5660300002)(7276002)(7336002)(7366002)(7406005)(7416002)(8936002)(478600001)(316002)(54906003)(110136005)(41080700001)(84006005)(83996005)(36900700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:27:23.7679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0c3563-0db1-4e00-970e-08db1e680cb3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

