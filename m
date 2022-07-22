Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230F057DBF3
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbiGVINW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiGVIND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:13:03 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEA09DC9A;
        Fri, 22 Jul 2022 01:12:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BosJO8YcjjNEy7ZUt1oSzdSuuJtJ3mR+PH2ovFABtEXIDOO/fNQIwCbh4jLEWwpCeDowJ1tTq1RcxfRyqFHbUMqi2BPmKZtvN6M1XBHdj+nz5t17KqBoISvG/el2xa5XtYNQXt3f2GgYvY8ryTTEIzTFx6qMHhNkCip0ugncpsEq6bVXtlB4Jl4unZmzX7japFx3MBvTPlw0b00tu556reShCZp/ggGpmopEzG8ThJLg9P3CrZ1Zu2BO/cxL3P3brVQYyqFHbfv5kD6JkuoCfg3n1glry+w1Gcjd7Fv37ZpMaOBo40gvfmKUhkZ6LuhppHG9lRw38CLOV6dMrgJtgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YK+jWnoCTIHNjeLRd8W15XbMMX2IKHVVv9UF7eLxR5U=;
 b=CkAsur96Cy+o7dTHyC4ghWO8+POb3PS3wRlB4LXSfidLByiQ9NjH5pNth0G0jsSVlbeKXsxBTUa4dWyZVKVR0Lf1GLg8GXgY2ESWMoVPC4PTyp2EJ5lxNSXQi+5qPaq3s2CQfWyWMAIgP+TTWOONiGbcCHNud+Q3PjOx6txzFhKYu/NWfQNDlB0uYHPB2T/Z1Y+bnSnB4ngroH8xs4jcusshqJfi4BLv/jyk4FvEuLauWfVr+K/o9fe62VmeJCAZXEB5XlkDNShkq0SWwrdjF1lIz2oRFOkUVOy5VmEY57mGs/aIjF1Xj8K0DSHiwuBuqCFSlQqI3Oivh7/HVls6Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK+jWnoCTIHNjeLRd8W15XbMMX2IKHVVv9UF7eLxR5U=;
 b=TazGPDITbSomgZb1evOYAeM1g+IaIx+lXCiCat+l9T7NWZBrnk+yN4mxI+gT9s1c+m4uBCLeTWqPihHmh+3qOsqVGz/dYnN++UKGYCg9yWF5BEKJoKhQ+kNoxJqHmo+gC8XNLrhKtF82fvCvJvI2yKjDX+GAqoO8WzqY5CLHTgI=
Received: from DM5PR08CA0045.namprd08.prod.outlook.com (2603:10b6:4:60::34) by
 DM6PR02MB4267.namprd02.prod.outlook.com (2603:10b6:5:28::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.21; Fri, 22 Jul 2022 08:12:50 +0000
Received: from DM3NAM02FT056.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::c6) by DM5PR08CA0045.outlook.office365.com
 (2603:10b6:4:60::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Fri, 22 Jul 2022 08:12:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT056.mail.protection.outlook.com (10.13.4.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 08:12:50 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 01:12:49 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 01:12:49 -0700
Envelope-to: git@xilinx.com,
 git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.2] (port=60637 helo=xhdvnc102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oEnmC-0000OV-AH; Fri, 22 Jul 2022 01:12:48 -0700
Received: by xhdvnc102.xilinx.com (Postfix, from userid 13245)
        id 6E9B1104563; Fri, 22 Jul 2022 13:42:34 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <ronak.jain@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@xilinx.com>, <git@amd.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next 1/2] firmware: xilinx: add support for sd/gem config
Date:   Fri, 22 Jul 2022 13:41:59 +0530
Message-ID: <1658477520-13551-2-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f640c5-cd8c-4d25-1792-08da6bb9f820
X-MS-TrafficTypeDiagnostic: DM6PR02MB4267:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utMXKt9FkKI5Sw5hJ+V4nPmvtIj1f+qEgwhWZd/81VfCNTT25KSPuxPspMuIuIExBgabk4uRQiKfXWgB+9puaysAYIcRFXtvTlexeTfLIdCFQigTVjNnUd1MDI6niOpofieB/oc339azTmqPy2BrosTCyVUiHpDBr1UcS/VIVGEpV7262UY0W9hTb6njsFzb3E/ktpCdp5WxFusAD0JNTeJWfFx8Y3vyhAijDhYptRc2gTakfX8FIBnI9Yg3ajbt+cgY7JAV8rVXJgqeyxcfbUUdSnmAZ6f4LW33y5HkKhOvDeDAWXniKNFs/pdyZ4G38wmVSjdFCgD0u134XFBRbfC6owC6ffCGACOzuNjt7+ZY730o/k5MsdymdZavUjchAWWT7VWxCjfc9lsJDZu8+VAqwbbdqXUNZtfroQGrW/OeB+PJxl5F3OOgrstAwS6QfCJaikiWZt5aTZpbA1A+/RRgx+plyHOepTOmOhJsTfnXP1JwUsQMSQDSZsxDXJ9Udawzz7IO3M6SY+92SDEP0SK+DN0tOZrTE0yb8rYjSG2UZswkO2//tHJmi0u7FBUZOtTrJORoE+GLlxZczhbX0XOCqGGffevpUnlPQQ6SA3OWTzsr8ByvbPQqz2TGvTmXx3w97ULLhaU2iZeCyGEyZoi61YjWpTGSHV5u/63fMTFuSHjUrzAxqQQTvtx+dvTNTphx4WXu/0OvGwoTtaMQW67Adm2Si9ta9CZvjifixTVOWGRjzU5YIgmYJ4KBcQNuJzb7cDn0Ma1ZxUeRHPqvx+/U1Ftd4EvUvRzD89Pp3rhkr/r7xENcbzZnRI2hm0vExYJy0p5e2BZODDBExFaKIw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(40470700004)(46966006)(36860700001)(7636003)(316002)(6266002)(36756003)(356005)(336012)(186003)(26005)(2616005)(6666004)(478600001)(82740400003)(41300700001)(83170400001)(54906003)(8936002)(8676002)(70206006)(7416002)(110136005)(42186006)(4326008)(5660300002)(82310400005)(70586007)(2906002)(83380400001)(40460700003)(42882007)(47076005)(40480700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 08:12:50.1383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f640c5-cd8c-4d25-1792-08da6bb9f820
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT056.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4267
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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
 drivers/firmware/xilinx/zynqmp.c     | 31 ++++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h | 33 ++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 7977a494a651..32a35bafb65e 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1297,6 +1297,37 @@ int zynqmp_pm_get_feature_config(enum pm_feature_config_id id,
 				   id, 0, payload);
 }
 
+/**
+ * zynqmp_pm_set_sd_config - PM call to set value of SD config registers
+ * @node:	SD node ID
+ * @config:	The config type of SD registers
+ * @value:	Value to be set
+ *
+ * Return:      Returns 0 on success or error value on failure.
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
+ * Return:      Returns 0 on success or error value on failure.
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
index 1ec73d5352c3..063a93c133f1 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -152,6 +152,9 @@ enum pm_ioctl_id {
 	/* Runtime feature configuration */
 	IOCTL_SET_FEATURE_CONFIG = 26,
 	IOCTL_GET_FEATURE_CONFIG = 27,
+	/* Dynamic SD/GEM configuration */
+	IOCTL_SET_SD_CONFIG = 30,
+	IOCTL_SET_GEM_CONFIG = 31,
 };
 
 enum pm_query_id {
@@ -393,6 +396,18 @@ enum pm_feature_config_id {
 	PM_FEATURE_EXTWDT_VALUE = 4,
 };
 
+enum pm_sd_config_type {
+	SD_CONFIG_EMMC_SEL = 1, /* To set SD_EMMC_SEL in CTRL_REG_SD and SD_SLOTTYPE */
+	SD_CONFIG_BASECLK = 2, /* To set SD_BASECLK in SD_CONFIG_REG1 */
+	SD_CONFIG_8BIT = 3, /* To set SD_8BIT in SD_CONFIG_REG2 */
+	SD_CONFIG_FIXED = 4, /* To set fixed config registers */
+};
+
+enum pm_gem_config_type {
+	GEM_CONFIG_SGMII_MODE = 1, /* To set GEM_SGMII_MODE in GEM_CLK_CTRL register */
+	GEM_CONFIG_FIXED = 2, /* To set fixed config registers */
+};
+
 /**
  * struct zynqmp_pm_query_data - PM query data
  * @qid:	query ID
@@ -468,6 +483,9 @@ int zynqmp_pm_feature(const u32 api_id);
 int zynqmp_pm_is_function_supported(const u32 api_id, const u32 id);
 int zynqmp_pm_set_feature_config(enum pm_feature_config_id id, u32 value);
 int zynqmp_pm_get_feature_config(enum pm_feature_config_id id, u32 *payload);
+int zynqmp_pm_set_sd_config(u32 node, enum pm_sd_config_type config, u32 value);
+int zynqmp_pm_set_gem_config(u32 node, enum pm_gem_config_type config,
+			     u32 value);
 #else
 static inline int zynqmp_pm_get_api_version(u32 *version)
 {
@@ -733,6 +751,21 @@ static inline int zynqmp_pm_get_feature_config(enum pm_feature_config_id id,
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

