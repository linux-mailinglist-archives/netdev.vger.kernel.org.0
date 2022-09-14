Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2AB5B884F
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiINMen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiINMeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:34:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E85B60D3;
        Wed, 14 Sep 2022 05:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTdG1HV0QjdnPFtHgW+UBlHcC0VE+X+KcliQJwC9hvKfItBjeHmHjUqx7+RF26t9OXTn/gOTTl3iSZTuX6HyrAJPX6HUZmtKLPA56PzxtDVWhXFvuxcjIOAV2t4S2F0VDKSG6LW6LCywTlasKtDzK1MV3pmSRtPRt8w7L9CxcshKbQhBqPm7lG78j37fl1lh7Ls5P8cQXX/TZZM/ChskGWh2aT84Kir2tRghTYNEKDLLBvZd7h/dLNRIAOyFDI7+gvrjoSXPnWh+1PmUH0eBllsofTP1q1wXnlhbkk9LXnPWm3erTffkcA0BR4dFxYRJQKwM9XBafBnEEXFGObcSCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31hmKJDC3GhxIi9PvtWwAE+Du6ihIrbAz9tarUUrDe4=;
 b=JvoMVnPg+yYO6UbqXoy43mrTynSARRHS08itoQhnBoM5tmTfOP1Yg9a49iIEybsYN+4ktiu7tXLGEKt6fxOeokR1dUW+OPHpaCXKXr63Um1pkdWqSEY+D4CRMBmuccAgilbaHmd2E5e+N9BC5556Gw8w8rJgj9rxIxg35bffwY+8cG1h2FgDAvxlXO7xbr6YAPYDP0I1lqHEE7z4+OqbV04uvzK/C647SG1VzdXQghIeENEafWunhV2gMM5zhBbdrUEuCpl01k4tU4VVrOdnMWhJwyacxGOpWSXV5mKtjjFUhnWHZSJ+RxAHLlcZlK+H5dfKI4JU1HowQetOxIbwZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31hmKJDC3GhxIi9PvtWwAE+Du6ihIrbAz9tarUUrDe4=;
 b=JhQUFkK4gFlJTRSkQNXsDi0ewd2XRkWECZADwMv813BRSKcLIU6hdJwBx0Q+Ghzox8fcACkwSntXPrAEwU/kDD7pnPbeVKqAXagXOOfhdAPpZ5lNDCaUTc9nv6wHzeTw0+lNHESh7z6PmdE13wZ8Fr/ttQJ9Zph2MwgxtBNuVhw=
Received: from DS7PR06CA0017.namprd06.prod.outlook.com (2603:10b6:8:2a::24) by
 DM6PR02MB7019.namprd02.prod.outlook.com (2603:10b6:5:22d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.12; Wed, 14 Sep 2022 12:34:33 +0000
Received: from DM3NAM02FT026.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::e2) by DS7PR06CA0017.outlook.office365.com
 (2603:10b6:8:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 12:34:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT026.mail.protection.outlook.com (10.13.5.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 12:34:32 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 05:33:44 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Wed, 14 Sep 2022 05:33:44 -0700
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 claudiu.beznea@microchip.com,
 conor.dooley@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=50635 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oYRaJ-0009Ng-TA; Wed, 14 Sep 2022 05:33:44 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 153D61054C8; Wed, 14 Sep 2022 18:03:30 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <andrew@lunn.ch>,
        <conor.dooley@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, Ronak Jain <ronak.jain@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH v3 net-next 1/2] firmware: xilinx: add support for sd/gem config
Date:   Wed, 14 Sep 2022 18:03:15 +0530
Message-ID: <1663158796-14869-2-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3NAM02FT026:EE_|DM6PR02MB7019:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee69ad9-0f6f-463e-8e4b-08da964d7a12
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJmaL1VhEBdsnT/D9m1kQ7dxK7bFDfaTNXRgSpaVm9eCaevLywlGmfBuzUlo14qZguEsUo/BiH50h9NcKvlaTi6qbRq7jnBNjg6BPANJ+9GIzVakCwYCTFvcG6u/uMHfQqN5J2YYYROL7xtb99Ii8QlL93s83dfBGbo/xcHkgeww6aeFgEZzCmRFT6DTO+QB2b75HjuGKHCCiXYvsuWCpFnM/GiqzZX85k7Zwiye+4PaAf3bPFF9KNpVPZNrNSvn9AMpNbcA9rzdohr60MLCovD/WZ8eKEl9RuMqlgNzSyYNBrh9Jd9/forQeLQx23++4PPX1DgxWqtit2/vmZ7E3o6Ydqin06lwm5EG26/cB1tt4RS7ndGs9AjI+9XY6fG/n4LUpj5XB2BYG7gSn3DQkrSw6vnJNnJg+ZIcAllVWW59UuK7qsx5qVXN/+UiFOOFdm/YvLIYq7AqlIygTN7TA/VZRWIHEruJxEfLs8sKfrxOSg2GSwFarZuN1VavE0z4hf045fOz0K87VIZp3AV5NV48sNT8TmUObMzXpkkpQzKtMZ76aPQuniQmmC6E+qt+RrqmM4tGIZh2pN0tiwGCZE5PduoQSyKs3diQtuaNlaunE72RaW6ATCdJxdCBkpYSyrUtNwbUHTr5evnV6Z6ckDwCtthFMnE4+STyCoOS4aIvZ0If3izJKFR4Kx1ZFcbauHm9CW/MjU3rZ7j4tAUK6t1HGlrai/0Wycn+dLLb/LEmY/iANl58vg0bCEGp3zPlkTtip2Cy7Lp9H+gQtx5Xj3Hsv+DzhKfhJRnlxF1pHCbOfi2tP9vA1WcpZf0yJTg+
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(54906003)(2906002)(4326008)(40480700001)(316002)(2616005)(8676002)(41300700001)(70586007)(26005)(70206006)(186003)(6666004)(42186006)(8936002)(40460700003)(7416002)(83380400001)(478600001)(36756003)(921005)(5660300002)(82740400003)(36860700001)(356005)(7636003)(336012)(110136005)(47076005)(6266002)(42882007)(83170400001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 12:34:32.9937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee69ad9-0f6f-463e-8e4b-08da964d7a12
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT026.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB7019
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ronak Jain <ronak.jain@xilinx.com>

Add new APIs in firmware to configure SD/GEM registers. Internally
it calls PM IOCTL for below SD/GEM register configuration:
- SD/EMMC select
- SD slot type
- SD base clock
- SD 8 bit support
- SD fixed config
- GEM SGMII Mode
- GEM fixed config

Signed-off-by: Ronak Jain <ronak.jain@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
- Changes for v3:
  Use enum kernel-doc comment style for enum pm_sd_config_type and
  pm_gem_config_type.

- Changes for v2:
  Use tab indent for zynqmp_pm_set_sd/gem_config() return
  documentation
---
 drivers/firmware/xilinx/zynqmp.c     | 31 +++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h | 45 ++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index d1f652802181..ff5cabe70a2b 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1311,6 +1311,37 @@ int zynqmp_pm_get_feature_config(enum pm_feature_config_id id,
 				   id, 0, payload);
 }
 
+/**
+ * zynqmp_pm_set_sd_config - PM call to set value of SD config registers
+ * @node:	SD node ID
+ * @config:	The config type of SD registers
+ * @value:	Value to be set
+ *
+ * Return:	Returns 0 on success or error value on failure.
+ */
+int zynqmp_pm_set_sd_config(u32 node, enum pm_sd_config_type config, u32 value)
+{
+	return zynqmp_pm_invoke_fn(PM_IOCTL, node, IOCTL_SET_SD_CONFIG,
+				   config, value, NULL);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_set_sd_config);
+
+/**
+ * zynqmp_pm_set_gem_config - PM call to set value of GEM config registers
+ * @node:	GEM node ID
+ * @config:	The config type of GEM registers
+ * @value:	Value to be set
+ *
+ * Return:	Returns 0 on success or error value on failure.
+ */
+int zynqmp_pm_set_gem_config(u32 node, enum pm_gem_config_type config,
+			     u32 value)
+{
+	return zynqmp_pm_invoke_fn(PM_IOCTL, node, IOCTL_SET_GEM_CONFIG,
+				   config, value, NULL);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_set_gem_config);
+
 /**
  * struct zynqmp_pm_shutdown_scope - Struct for shutdown scope
  * @subtype:	Shutdown subtype
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 9f50dacbf7d6..76d2b3ebad84 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -153,6 +153,9 @@ enum pm_ioctl_id {
 	/* Runtime feature configuration */
 	IOCTL_SET_FEATURE_CONFIG = 26,
 	IOCTL_GET_FEATURE_CONFIG = 27,
+	/* Dynamic SD/GEM configuration */
+	IOCTL_SET_SD_CONFIG = 30,
+	IOCTL_SET_GEM_CONFIG = 31,
 };
 
 enum pm_query_id {
@@ -399,6 +402,30 @@ enum pm_feature_config_id {
 	PM_FEATURE_EXTWDT_VALUE = 4,
 };
 
+/**
+ * enum pm_sd_config_type - PM SD configuration.
+ * @SD_CONFIG_EMMC_SEL: To set SD_EMMC_SEL in CTRL_REG_SD and SD_SLOTTYPE
+ * @SD_CONFIG_BASECLK: To set SD_BASECLK in SD_CONFIG_REG1
+ * @SD_CONFIG_8BIT: To set SD_8BIT in SD_CONFIG_REG2
+ * @SD_CONFIG_FIXED: To set fixed config registers
+ */
+enum pm_sd_config_type {
+	SD_CONFIG_EMMC_SEL = 1,
+	SD_CONFIG_BASECLK = 2,
+	SD_CONFIG_8BIT = 3,
+	SD_CONFIG_FIXED = 4,
+};
+
+/**
+ * enum pm_gem_config_type - PM GEM configuration.
+ * @GEM_CONFIG_SGMII_MODE: To set GEM_SGMII_MODE in GEM_CLK_CTRL register
+ * @GEM_CONFIG_FIXED: To set fixed config registers
+ */
+enum pm_gem_config_type {
+	GEM_CONFIG_SGMII_MODE = 1,
+	GEM_CONFIG_FIXED = 2,
+};
+
 /**
  * struct zynqmp_pm_query_data - PM query data
  * @qid:	query ID
@@ -475,6 +502,9 @@ int zynqmp_pm_is_function_supported(const u32 api_id, const u32 id);
 int zynqmp_pm_set_feature_config(enum pm_feature_config_id id, u32 value);
 int zynqmp_pm_get_feature_config(enum pm_feature_config_id id, u32 *payload);
 int zynqmp_pm_register_sgi(u32 sgi_num, u32 reset);
+int zynqmp_pm_set_sd_config(u32 node, enum pm_sd_config_type config, u32 value);
+int zynqmp_pm_set_gem_config(u32 node, enum pm_gem_config_type config,
+			     u32 value);
 #else
 static inline int zynqmp_pm_get_api_version(u32 *version)
 {
@@ -745,6 +775,21 @@ static inline int zynqmp_pm_register_sgi(u32 sgi_num, u32 reset)
 {
 	return -ENODEV;
 }
+
+static inline int zynqmp_pm_set_sd_config(u32 node,
+					  enum pm_sd_config_type config,
+					  u32 value)
+{
+	return -ENODEV;
+}
+
+static inline int zynqmp_pm_set_gem_config(u32 node,
+					   enum pm_gem_config_type config,
+					   u32 value)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif /* __FIRMWARE_ZYNQMP_H__ */
-- 
2.25.1

