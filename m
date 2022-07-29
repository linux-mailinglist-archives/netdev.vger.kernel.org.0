Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3258559B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 21:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiG2ThG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 15:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238771AbiG2ThE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 15:37:04 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC2287366;
        Fri, 29 Jul 2022 12:37:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5Im5KvSAduhMGr6547gC69SNkw99BAwPJJLrRYbHBHuZ6xLPiL+bSSBkZllCKP7xt2i0A3RBbrar2aETtc7GCFFtY+V9/U763IR9j4RtWGWnM99e74HBtZbb1Weae4G1yy/mT2hOMOhgnc+AL4iEdT8gs828pRs9oP6/70RoFMTju1fk73wl7vyoNPwe4urA7vBEZDP0ouyHdLcJJkiAUu/b9MUXwtrQfNXgEeyKyhWkahzI7Tyo9UTe/AXiu4jwJnBzYrwSuSx6rSLd2UNq6cX71+TFHqRj03iDA6ZWsrOBLbcGzrDU+vCTI5fMCsRohLfhkT5i1v0nrdA1eC/zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxuBLQyTlZLiue2zimNPlMyIbm6yAtPWF8jMFP5KsRg=;
 b=eTcAszn0DxPNaNrzB9OEGA9/m8FlrPG7SMyJgndsTfRWw3maOto9qIB6scVqfqokv3DkdPT5yUBeW1AgTieBA0TT1qi8RTPv7JXqQAQ6aXSKNEgyNLVFDNOft+GXhI8fQ6np/kpnzzteCDYTFBUT8eEIrWp25mhzqD+yE9YyUoL0V0AcWmY0beLbQ+UknSi5hJdRSpWkI1TLPXZ08tW8XVl/UUi67CPYMVN7GzcI9m8whmEOgT6gROmu4vOG/+gqqSY8YdfnQvNbj+4ucmkfUQX6yCjbieMRLEe5BBS4XNk6tlQ55wAlBSa9+sxvpBPyzkxoXZS5bB+dc1eA/Zt+1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxuBLQyTlZLiue2zimNPlMyIbm6yAtPWF8jMFP5KsRg=;
 b=LDz+hmyFG1UGOadvkmsNjKiS0VOESQbqgW53P+6hEd7GhrlYWjY7VakJH49x2vOcW1DvhPQ7lr2wvzdRU2VybE1UWFscMuhjcSWbj67z443YTyduQVb9foU8Rx1Z75qKNQSSPYyIwWl4eivW/09PEhNrcOSjZIEuIeWb1bqhW50=
Received: from SA0PR11CA0157.namprd11.prod.outlook.com (2603:10b6:806:1bb::12)
 by CO1PR02MB8553.namprd02.prod.outlook.com (2603:10b6:303:158::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 19:37:01 +0000
Received: from SN1NAM02FT0051.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:1bb:cafe::9b) by SA0PR11CA0157.outlook.office365.com
 (2603:10b6:806:1bb::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12 via Frontend
 Transport; Fri, 29 Jul 2022 19:37:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0051.mail.protection.outlook.com (10.97.5.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 29 Jul 2022 19:37:01 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Jul 2022 12:36:59 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 29 Jul 2022 12:36:59 -0700
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
Received: from [172.23.64.3] (port=58455 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oHVn8-000GwV-JP; Fri, 29 Jul 2022 12:36:59 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 38418102C79; Sat, 30 Jul 2022 01:06:43 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>,
        Ronak Jain <ronak.jain@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem config
Date:   Sat, 30 Jul 2022 01:05:49 +0530
Message-ID: <1659123350-10638-2-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 429a2f0e-68c8-44ba-68ae-08da7199b547
X-MS-TrafficTypeDiagnostic: CO1PR02MB8553:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43aQAYDEXGiVZE8sf365nL9SXKbtysJhZeofooda1IUFV5oeVMoKkh5x0JG0nyVOe+2rsx0T5J1bJI7ZBA6oX4GnYgPAIX3DiUl+2ooLp3/Tko1JJpmNYKAmAs0JhOb82cZiAeRwrH1Kc0PFiVQDLEHw9wW3b2lwt/uodaElpJGftSvaMszinPNESJNPBhh6UH4rhxOQHYs3TVVkT6oG3uz5HsegzrJOYHmPuJtBLd9V26qucuXA8NXwKIJ8avJWqIH4i3PcvfVxCZhMWrrvt4B5U1iKdccBQox0ACudTWHqsL1GbcyxRv2Rqdy/bY0qYWHGn80DYlCwLEgXnv2CEpIITLQTbyYjm8lwBtZQxqzp7zg1WkqFMMX6QiymSPm9OdyqNqg+h492mJg8HijdDaiMcGhyHQALPbV3KHbYpsDVnwp35FEkRndFjh6Mzo6SAlh2q19cD/0miMUoEvL43pRkHyUjnolqsTt+JcQuZ+UgmLG4qLIXH22pBePxtN1Nw2JaYoU8RG7j1zg6xvTXztEjzmWYIfF4KELCndyC11tQcV0z9flIhpaiRlgqp7H8A8WkZM68gUXyyjyIkg8js6KV8H+xD6z2E8Nmon3abRhhz6+wLNfBjD33M+M+vIM4zDlSDGxbnP5OJSBc3tB6uESCUQ71yKpKaLllScSl5CvNYjV9iGr79hwiEdCo9V9JWQGXeRhie1jx+lto9weTNob2I6rKxJJBOvA55kES/gI5Cf0iB0A9ElotX1v2WlCWp83SjXJ9iLrKENTE3Zj5ou093QeaCVoHNfY/2m7ZENr+P3BhbVk9hbGiJETO+XxQT6ForO4VKdgkuZvDgw5vug==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(136003)(396003)(376002)(40470700004)(36840700001)(46966006)(41300700001)(356005)(6266002)(83170400001)(36860700001)(82740400003)(7636003)(26005)(2616005)(336012)(40460700003)(42882007)(186003)(83380400001)(8936002)(70586007)(7416002)(4326008)(47076005)(70206006)(8676002)(36756003)(5660300002)(40480700001)(110136005)(2906002)(54906003)(316002)(42186006)(478600001)(82310400005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:37:01.0699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 429a2f0e-68c8-44ba-68ae-08da7199b547
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0051.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8553
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
Changes for v2:
- Use tab indent for zynqmp_pm_set_sd/gem_config return documentation.
---
 drivers/firmware/xilinx/zynqmp.c     | 31 +++++++++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 7977a494a651..44c44077dfc5 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1298,6 +1298,37 @@ int zynqmp_pm_get_feature_config(enum pm_feature_config_id id,
 }
 
 /**
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
+/**
  * struct zynqmp_pm_shutdown_scope - Struct for shutdown scope
  * @subtype:	Shutdown subtype
  * @name:	Matching string for scope argument
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
2.1.1

