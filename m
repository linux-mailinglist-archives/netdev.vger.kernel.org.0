Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E39177F1
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 13:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfEHL37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 07:29:59 -0400
Received: from mail-eopbgr680067.outbound.protection.outlook.com ([40.107.68.67]:60487
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727617AbfEHL3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 07:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1h8/OM7WIJ2+B7PQh5VU5won9TYo5K6loDOmlI1d0MY=;
 b=QfgnDHDVF0bpE3Lq1ne8goyHiQYLwG2dRTorIyjw235b+zmgtG2P71WpCb6/Klt10mquueyrN4BIY6989T4HneNxSCuLAVuL5tZEncHFbK/hLHSChzZsF3poHMTjUMp/nL0EVqhd2ixDaQizNevQAl7+Prw0KvOZ4UOnrvnMQ3o=
Received: from BN6PR03CA0050.namprd03.prod.outlook.com (2603:10b6:404:4c::12)
 by CO2PR03MB2263.namprd03.prod.outlook.com (2603:10b6:102:a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1856.11; Wed, 8 May
 2019 11:29:37 +0000
Received: from SN1NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by BN6PR03CA0050.outlook.office365.com
 (2603:10b6:404:4c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.1878.20 via Frontend
 Transport; Wed, 8 May 2019 11:29:37 +0000
Authentication-Results: spf=pass (sender IP is 137.71.25.57)
 smtp.mailfrom=analog.com; lists.freedesktop.org; dkim=none (message not
 signed) header.d=none;lists.freedesktop.org; dmarc=bestguesspass action=none
 header.from=analog.com;
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT010.mail.protection.outlook.com (10.152.72.86) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.1856.11
 via Frontend Transport; Wed, 8 May 2019 11:29:36 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x48BTZXm017075
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Wed, 8 May 2019 04:29:35 -0700
Received: from saturn.analog.com (10.50.1.244) by NWD2HUBCAS7.ad.analog.com
 (10.64.69.107) with Microsoft SMTP Server id 14.3.408.0; Wed, 8 May 2019
 07:29:35 -0400
From:   Alexandru Ardelean <alexandru.ardelean@analog.com>
To:     <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-ide@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-rpi-kernel@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-rockchip@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-omap@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-usb@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>, <alsa-devel@alsa-project.org>
CC:     <gregkh@linuxfoundation.org>, <andriy.shevchenko@linux.intel.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Date:   Wed, 8 May 2019 14:28:29 +0300
Message-ID: <20190508112842.11654-5-alexandru.ardelean@analog.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190508112842.11654-1-alexandru.ardelean@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ADIRoutedOnPrem: True
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(1496009)(346002)(376002)(396003)(136003)(39860400002)(2980300002)(189003)(199004)(36756003)(48376002)(446003)(11346002)(50466002)(51416003)(2616005)(476003)(246002)(47776003)(8676002)(50226002)(8936002)(7696005)(486006)(356004)(6666004)(4326008)(107886003)(44832011)(54906003)(110136005)(316002)(53416004)(106002)(16586007)(5660300002)(14444005)(86362001)(1076003)(76176011)(7416002)(126002)(2441003)(7636002)(305945005)(2906002)(336012)(426003)(26005)(186003)(70586007)(77096007)(2201001)(478600001)(70206006)(142933001)(921003)(2101003)(83996005)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR03MB2263;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31297c83-3c94-4818-a71a-08d6d3a873f6
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4709054)(2017052603328);SRVR:CO2PR03MB2263;
X-MS-TrafficTypeDiagnostic: CO2PR03MB2263:
X-Microsoft-Antispam-PRVS: <CO2PR03MB226365C285E013E4A789A7FBF9320@CO2PR03MB2263.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-Forefront-PRVS: 0031A0FFAF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: zM9X/pZmTz9sMrsKb6y22/hNvqDLvXsAWqFIYl6VaGthrOrzboWYJJBrG2OmLxblECbDBNAYy1fAXXPFNUtNNW4OLkTQPGDSXp61NKVgByVJ1a3Yk+8M+ba9MCE1unmAirGGPUwzFdN724w4EagzPmXnryEw1auev6pHsuE3QGfkeawBN+XwLLXictqbVVmorZq+xLG2NmjhU7a77nzjfMiAjD68Le+2CXdSFEdDYqn54YA79xIG8P/2oLWGWjFQM3OBAiQ9wGQDPj9/VmzBoD2kA9N/9sT4cJYQgoQcTwatzMJSI8LlUgarl7IDcml11aWhv7z2VHqvmMPikG3Rx9WUEjseHrWcIi45ED+tXv/pGao43riYiBTfc5SL8H9qQfa8yFsiXioRJiYsgmTyxMiBHTCE3UU+818x/BxC9zs=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2019 11:29:36.2666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31297c83-3c94-4818-a71a-08d6d3a873f6
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR03MB2263
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change re-introduces `match_string()` as a macro that uses
ARRAY_SIZE() to compute the size of the array.
The macro is added in all the places that do
`match_string(_a, ARRAY_SIZE(_a), s)`, since the change is pretty
straightforward.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
---
 drivers/clk/bcm/clk-bcm2835.c                    | 4 +---
 drivers/gpio/gpiolib-of.c                        | 2 +-
 drivers/gpu/drm/i915/intel_pipe_crc.c            | 2 +-
 drivers/mfd/omap-usb-host.c                      | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 +-
 drivers/pci/pcie/aer.c                           | 2 +-
 drivers/usb/common/common.c                      | 4 ++--
 drivers/usb/typec/class.c                        | 8 +++-----
 drivers/usb/typec/tps6598x.c                     | 2 +-
 drivers/vfio/vfio.c                              | 4 +---
 include/linux/string.h                           | 9 +++++++++
 sound/firewire/oxfw/oxfw.c                       | 2 +-
 sound/soc/codecs/max98088.c                      | 2 +-
 sound/soc/codecs/max98095.c                      | 2 +-
 14 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
index a775f6a1f717..1ab388590ead 100644
--- a/drivers/clk/bcm/clk-bcm2835.c
+++ b/drivers/clk/bcm/clk-bcm2835.c
@@ -1390,9 +1390,7 @@ static struct clk_hw *bcm2835_register_clock(struct bcm2835_cprman *cprman,
 	for (i = 0; i < data->num_mux_parents; i++) {
 		parents[i] = data->parents[i];
 
-		ret = __match_string(cprman_parent_names,
-				     ARRAY_SIZE(cprman_parent_names),
-				     parents[i]);
+		ret = match_string(cprman_parent_names, parents[i]);
 		if (ret >= 0)
 			parents[i] = cprman->real_parent_names[ret];
 	}
diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index 27d6f04ab58e..71e886869d78 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -279,7 +279,7 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
 	if (!con_id)
 		return ERR_PTR(-ENOENT);
 
-	i = __match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
+	i = match_string(whitelist, con_id);
 	if (i < 0)
 		return ERR_PTR(-ENOENT);
 
diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
index 286fad1f0e08..6fc4f3d3d1f6 100644
--- a/drivers/gpu/drm/i915/intel_pipe_crc.c
+++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
@@ -449,7 +449,7 @@ display_crc_ctl_parse_source(const char *buf, enum intel_pipe_crc_source *s)
 		return 0;
 	}
 
-	i = __match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
+	i = match_string(pipe_crc_sources, buf);
 	if (i < 0)
 		return i;
 
diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 9aaacb5bdb26..53dff34c0afc 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -509,7 +509,7 @@ static int usbhs_omap_get_dt_pdata(struct device *dev,
 			continue;
 
 		/* get 'enum usbhs_omap_port_mode' from port mode string */
-		ret = __match_string(port_modes, ARRAY_SIZE(port_modes), mode);
+		ret = match_string(port_modes, mode);
 		if (ret < 0) {
 			dev_warn(dev, "Invalid port%d-mode \"%s\" in device tree\n",
 					i, mode);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 59ce3ff35553..778b4dfd8b75 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -667,7 +667,7 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
 	};
 	int ret, bt_force_ant_mode;
 
-	ret = __match_string(modes_str, ARRAY_SIZE(modes_str), buf);
+	ret = match_string(modes_str, buf);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 41a0773a1cbc..2278caba109c 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -203,7 +203,7 @@ void pcie_ecrc_get_policy(char *str)
 {
 	int i;
 
-	i = __match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
+	i = match_string(ecrc_policy_str, str);
 	if (i < 0)
 		return;
 
diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index bca0c404c6ca..5a651d311d38 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -68,7 +68,7 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 	if (ret < 0)
 		return USB_SPEED_UNKNOWN;
 
-	ret = __match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
+	ret = match_string(speed_names, maximum_speed);
 
 	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
 }
@@ -106,7 +106,7 @@ static enum usb_dr_mode usb_get_dr_mode_from_string(const char *str)
 {
 	int ret;
 
-	ret = __match_string(usb_dr_modes, ARRAY_SIZE(usb_dr_modes), str);
+	ret = match_string(usb_dr_modes, str);
 	return (ret < 0) ? USB_DR_MODE_UNKNOWN : ret;
 }
 
diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index 4abc5a76ec51..38ac776cba8a 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -1409,8 +1409,7 @@ EXPORT_SYMBOL_GPL(typec_set_pwr_opmode);
  */
 int typec_find_port_power_role(const char *name)
 {
-	return __match_string(typec_port_power_roles,
-			      ARRAY_SIZE(typec_port_power_roles), name);
+	return match_string(typec_port_power_roles, name);
 }
 EXPORT_SYMBOL_GPL(typec_find_port_power_role);
 
@@ -1424,7 +1423,7 @@ EXPORT_SYMBOL_GPL(typec_find_port_power_role);
  */
 int typec_find_power_role(const char *name)
 {
-	return __match_string(typec_roles, ARRAY_SIZE(typec_roles), name);
+	return match_string(typec_roles, name);
 }
 EXPORT_SYMBOL_GPL(typec_find_power_role);
 
@@ -1438,8 +1437,7 @@ EXPORT_SYMBOL_GPL(typec_find_power_role);
  */
 int typec_find_port_data_role(const char *name)
 {
-	return __match_string(typec_port_data_roles,
-			      ARRAY_SIZE(typec_port_data_roles), name);
+	return match_string(typec_port_data_roles, name);
 }
 EXPORT_SYMBOL_GPL(typec_find_port_data_role);
 
diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index 0389e4391faf..0c4e47868590 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -423,7 +423,7 @@ static int tps6598x_check_mode(struct tps6598x *tps)
 	if (ret)
 		return ret;
 
-	switch (__match_string(modes, ARRAY_SIZE(modes), mode)) {
+	switch (match_string(modes, mode)) {
 	case TPS_MODE_APP:
 		return 0;
 	case TPS_MODE_BOOT:
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b31585ecf48f..fe8283d3781b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -637,9 +637,7 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
 			return true;
 	}
 
-	return __match_string(vfio_driver_whitelist,
-			      ARRAY_SIZE(vfio_driver_whitelist),
-			      drv->name) >= 0;
+	return match_string(vfio_driver_whitelist, drv->name) >= 0;
 }
 
 /*
diff --git a/include/linux/string.h b/include/linux/string.h
index 531d04308ff9..07e9f89088df 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -194,6 +194,15 @@ static inline int strtobool(const char *s, bool *res)
 int __match_string(const char * const *array, size_t n, const char *string);
 int __sysfs_match_string(const char * const *array, size_t n, const char *s);
 
+/**
+ * match_string - matches given string in an array
+ * @_a: array of strings
+ * @_s: string to match with
+ *
+ * Helper for __match_string(). Calculates the size of @a automatically.
+ */
+#define match_string(_a, _s) __match_string(_a, ARRAY_SIZE(_a), _s)
+
 /**
  * sysfs_match_string - matches given string in an array
  * @_a: array of strings
diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
index 9ec5316f3bb5..433fc84c4f90 100644
--- a/sound/firewire/oxfw/oxfw.c
+++ b/sound/firewire/oxfw/oxfw.c
@@ -57,7 +57,7 @@ static bool detect_loud_models(struct fw_unit *unit)
 	if (err < 0)
 		return false;
 
-	return __match_string(models, ARRAY_SIZE(models), model) >= 0;
+	return match_string(models, model) >= 0;
 }
 
 static int name_card(struct snd_oxfw *oxfw)
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index 3ef743075bda..911ffe84c37e 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1405,7 +1405,7 @@ static int max98088_get_channel(struct snd_soc_component *component, const char
 {
 	int ret;
 
-	ret = __match_string(eq_mode_name, ARRAY_SIZE(eq_mode_name), name);
+	ret = match_string(eq_mode_name, name);
 	if (ret < 0)
 		dev_err(component->dev, "Bad EQ channel name '%s'\n", name);
 	return ret;
diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
index cd69916d5dcb..d182d45d0c83 100644
--- a/sound/soc/codecs/max98095.c
+++ b/sound/soc/codecs/max98095.c
@@ -1636,7 +1636,7 @@ static int max98095_get_bq_channel(struct snd_soc_component *component,
 {
 	int ret;
 
-	ret = __match_string(bq_mode_name, ARRAY_SIZE(bq_mode_name), name);
+	ret = match_string(bq_mode_name, name);
 	if (ret < 0)
 		dev_err(component->dev, "Bad biquad channel name '%s'\n", name);
 	return ret;
-- 
2.17.1

