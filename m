Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B68F4F6561
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbiDFQ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237706AbiDFQ2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:28:51 -0400
Received: from smtpbg511.qq.com (smtpbg511.qq.com [203.205.250.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA3B43B839
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 18:55:01 -0700 (PDT)
X-QQ-mid: bizesmtp67t1649210094tibayfbs
Received: from localhost.localdomain ( [58.240.82.166])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 06 Apr 2022 09:54:47 +0800 (CST)
X-QQ-SSF: 01400000002000E0J000B00A0000000
X-QQ-FEAT: c49ksGaa/D0gN5uUShXkLvi4StQF//H6ybxXME+XXnAxqDp2rXScwtotTigm3
        6obhKpXd07FHPimqK12M3WpP+xzZcrhZv5BWqxovQ1fee7xq69T2VeMCxWdT5ZpmhbUMwPf
        zzKY9zbkDsR1qR9HVsqhJYSFPsbGJdALhtHAlO4bUIMhtXFTa50a0FGgdAKq/H8WgsWbPDz
        hTiH6PlGcT0n11R+9AJunPm0QtyJJdtqx8ulZyIYvaj9n/QGQFDYbebJCMUNTMjF0kI+VCP
        9tENxv7DtB4aPclQsRSPpFWq60SRb4F3uxVpgwUw2k5yHE07G5Y8cRBzkh0PIKdrxPJl3Mq
        RKLSVU8K9zN2OCpJ6Q37JarXWgnCg==
X-QQ-GoodBg: 2
From:   Meng Tang <tangmeng@uniontech.com>
To:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Meng Tang <tangmeng@uniontech.com>
Subject: [PATCH net] ipw2x00: use DEVICE_ATTR_*() macro
Date:   Wed,  6 Apr 2022 09:54:44 +0800
Message-Id: <20220406015444.14408-1-tangmeng@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign8
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEVICE_ATTR_*() helper instead of plain DEVICE_ATTR,
which makes the code a bit shorter and easier to read.

Signed-off-by: Meng Tang <tangmeng@uniontech.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c |  64 +++++-----
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 119 +++++++++----------
 2 files changed, 90 insertions(+), 93 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 2ace2b27ecad..5234511dac78 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3501,7 +3501,7 @@ static void ipw2100_msg_free(struct ipw2100_priv *priv)
 	priv->msg_buffers = NULL;
 }
 
-static ssize_t show_pci(struct device *d, struct device_attribute *attr,
+static ssize_t pci_show(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
 	struct pci_dev *pci_dev = to_pci_dev(d);
@@ -3521,34 +3521,34 @@ static ssize_t show_pci(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(pci, 0444, show_pci, NULL);
+static DEVICE_ATTR_RO(pci);
 
-static ssize_t show_cfg(struct device *d, struct device_attribute *attr,
+static ssize_t cfg_show(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
 	struct ipw2100_priv *p = dev_get_drvdata(d);
 	return sprintf(buf, "0x%08x\n", (int)p->config);
 }
 
-static DEVICE_ATTR(cfg, 0444, show_cfg, NULL);
+static DEVICE_ATTR_RO(cfg);
 
-static ssize_t show_status(struct device *d, struct device_attribute *attr,
+static ssize_t status_show(struct device *d, struct device_attribute *attr,
 			   char *buf)
 {
 	struct ipw2100_priv *p = dev_get_drvdata(d);
 	return sprintf(buf, "0x%08x\n", (int)p->status);
 }
 
-static DEVICE_ATTR(status, 0444, show_status, NULL);
+static DEVICE_ATTR_RO(status);
 
-static ssize_t show_capability(struct device *d, struct device_attribute *attr,
+static ssize_t capability_show(struct device *d, struct device_attribute *attr,
 			       char *buf)
 {
 	struct ipw2100_priv *p = dev_get_drvdata(d);
 	return sprintf(buf, "0x%08x\n", (int)p->capability);
 }
 
-static DEVICE_ATTR(capability, 0444, show_capability, NULL);
+static DEVICE_ATTR_RO(capability);
 
 #define IPW2100_REG(x) { IPW_ ##x, #x }
 static const struct {
@@ -3785,7 +3785,7 @@ IPW2100_ORD(STAT_TX_HOST_REQUESTS, "requested Host Tx's (MSDU)"),
 	    IPW2100_ORD(NIC_MANF_DATE_TIME, "MANF Date/Time STAMP"),
 	    IPW2100_ORD(UCODE_VERSION, "Ucode Version"),};
 
-static ssize_t show_registers(struct device *d, struct device_attribute *attr,
+static ssize_t registers_show(struct device *d, struct device_attribute *attr,
 			      char *buf)
 {
 	int i;
@@ -3805,9 +3805,9 @@ static ssize_t show_registers(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(registers, 0444, show_registers, NULL);
+static DEVICE_ATTR_RO(registers);
 
-static ssize_t show_hardware(struct device *d, struct device_attribute *attr,
+static ssize_t hardware_show(struct device *d, struct device_attribute *attr,
 			     char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -3846,9 +3846,9 @@ static ssize_t show_hardware(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(hardware, 0444, show_hardware, NULL);
+static DEVICE_ATTR_RO(hardware);
 
-static ssize_t show_memory(struct device *d, struct device_attribute *attr,
+static ssize_t memory_show(struct device *d, struct device_attribute *attr,
 			   char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -3905,7 +3905,7 @@ static ssize_t show_memory(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static ssize_t store_memory(struct device *d, struct device_attribute *attr,
+static ssize_t memory_store(struct device *d, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -3940,9 +3940,9 @@ static ssize_t store_memory(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(memory, 0644, show_memory, store_memory);
+static DEVICE_ATTR_RW(memory);
 
-static ssize_t show_ordinals(struct device *d, struct device_attribute *attr,
+static ssize_t ordinals_show(struct device *d, struct device_attribute *attr,
 			     char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -3976,9 +3976,9 @@ static ssize_t show_ordinals(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static DEVICE_ATTR(ordinals, 0444, show_ordinals, NULL);
+static DEVICE_ATTR_RO(ordinals);
 
-static ssize_t show_stats(struct device *d, struct device_attribute *attr,
+static ssize_t stats_show(struct device *d, struct device_attribute *attr,
 			  char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -3997,7 +3997,7 @@ static ssize_t show_stats(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(stats, 0444, show_stats, NULL);
+static DEVICE_ATTR_RO(stats);
 
 static int ipw2100_switch_mode(struct ipw2100_priv *priv, u32 mode)
 {
@@ -4043,7 +4043,7 @@ static int ipw2100_switch_mode(struct ipw2100_priv *priv, u32 mode)
 	return 0;
 }
 
-static ssize_t show_internals(struct device *d, struct device_attribute *attr,
+static ssize_t internals_show(struct device *d, struct device_attribute *attr,
 			      char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -4095,9 +4095,9 @@ static ssize_t show_internals(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static DEVICE_ATTR(internals, 0444, show_internals, NULL);
+static DEVICE_ATTR_RO(internals);
 
-static ssize_t show_bssinfo(struct device *d, struct device_attribute *attr,
+static ssize_t bssinfo_show(struct device *d, struct device_attribute *attr,
 			    char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -4140,7 +4140,7 @@ static ssize_t show_bssinfo(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(bssinfo, 0444, show_bssinfo, NULL);
+static DEVICE_ATTR_RO(bssinfo);
 
 #ifdef CONFIG_IPW2100_DEBUG
 static ssize_t debug_level_show(struct device_driver *d, char *buf)
@@ -4165,7 +4165,7 @@ static ssize_t debug_level_store(struct device_driver *d,
 static DRIVER_ATTR_RW(debug_level);
 #endif				/* CONFIG_IPW2100_DEBUG */
 
-static ssize_t show_fatal_error(struct device *d,
+static ssize_t fatal_error_show(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -4190,7 +4190,7 @@ static ssize_t show_fatal_error(struct device *d,
 	return out - buf;
 }
 
-static ssize_t store_fatal_error(struct device *d,
+static ssize_t fatal_error_store(struct device *d,
 				 struct device_attribute *attr, const char *buf,
 				 size_t count)
 {
@@ -4199,16 +4199,16 @@ static ssize_t store_fatal_error(struct device *d,
 	return count;
 }
 
-static DEVICE_ATTR(fatal_error, 0644, show_fatal_error, store_fatal_error);
+static DEVICE_ATTR_RW(fatal_error);
 
-static ssize_t show_scan_age(struct device *d, struct device_attribute *attr,
+static ssize_t scan_age_show(struct device *d, struct device_attribute *attr,
 			     char *buf)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%d\n", priv->ieee->scan_age);
 }
 
-static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
+static ssize_t scan_age_store(struct device *d, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -4232,9 +4232,9 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(scan_age, 0644, show_scan_age, store_scan_age);
+static DEVICE_ATTR_RW(scan_age);
 
-static ssize_t show_rf_kill(struct device *d, struct device_attribute *attr,
+static ssize_t rf_kill_show(struct device *d, struct device_attribute *attr,
 			    char *buf)
 {
 	/* 0 - RF kill not enabled
@@ -4278,7 +4278,7 @@ static int ipw_radio_kill_sw(struct ipw2100_priv *priv, int disable_radio)
 	return 1;
 }
 
-static ssize_t store_rf_kill(struct device *d, struct device_attribute *attr,
+static ssize_t rf_kill_store(struct device *d, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
 	struct ipw2100_priv *priv = dev_get_drvdata(d);
@@ -4286,7 +4286,7 @@ static ssize_t store_rf_kill(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(rf_kill, 0644, show_rf_kill, store_rf_kill);
+static DEVICE_ATTR_RW(rf_kill);
 
 static struct attribute *ipw2100_sysfs_entries[] = {
 	&dev_attr_hardware.attr,
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5727c7c00a28..ed343d4fb9d5 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1259,7 +1259,7 @@ static struct ipw_fw_error *ipw_alloc_error_log(struct ipw_priv *priv)
 	return error;
 }
 
-static ssize_t show_event_log(struct device *d,
+static ssize_t event_log_show(struct device *d,
 			      struct device_attribute *attr, char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1289,9 +1289,9 @@ static ssize_t show_event_log(struct device *d,
 	return len;
 }
 
-static DEVICE_ATTR(event_log, 0444, show_event_log, NULL);
+static DEVICE_ATTR_RO(event_log);
 
-static ssize_t show_error(struct device *d,
+static ssize_t error_show(struct device *d,
 			  struct device_attribute *attr, char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1326,7 +1326,7 @@ static ssize_t show_error(struct device *d,
 	return len;
 }
 
-static ssize_t clear_error(struct device *d,
+static ssize_t error_store(struct device *d,
 			   struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
@@ -1337,9 +1337,9 @@ static ssize_t clear_error(struct device *d,
 	return count;
 }
 
-static DEVICE_ATTR(error, 0644, show_error, clear_error);
+static DEVICE_ATTR_RW(error);
 
-static ssize_t show_cmd_log(struct device *d,
+static ssize_t cmd_log_show(struct device *d,
 			    struct device_attribute *attr, char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1364,12 +1364,12 @@ static ssize_t show_cmd_log(struct device *d,
 	return len;
 }
 
-static DEVICE_ATTR(cmd_log, 0444, show_cmd_log, NULL);
+static DEVICE_ATTR_RO(cmd_log);
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 static void ipw_prom_free(struct ipw_priv *priv);
 static int ipw_prom_alloc(struct ipw_priv *priv);
-static ssize_t store_rtap_iface(struct device *d,
+static ssize_t rtap_iface_store(struct device *d,
 			 struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
@@ -1414,7 +1414,7 @@ static ssize_t store_rtap_iface(struct device *d,
 	return count;
 }
 
-static ssize_t show_rtap_iface(struct device *d,
+static ssize_t rtap_iface_show(struct device *d,
 			struct device_attribute *attr,
 			char *buf)
 {
@@ -1429,9 +1429,9 @@ static ssize_t show_rtap_iface(struct device *d,
 	}
 }
 
-static DEVICE_ATTR(rtap_iface, 0600, show_rtap_iface, store_rtap_iface);
+static DEVICE_ATTR_ADMIN_RW(rtap_iface);
 
-static ssize_t store_rtap_filter(struct device *d,
+static ssize_t rtap_filter_store(struct device *d,
 			 struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
@@ -1451,7 +1451,7 @@ static ssize_t store_rtap_filter(struct device *d,
 	return count;
 }
 
-static ssize_t show_rtap_filter(struct device *d,
+static ssize_t rtap_filter_show(struct device *d,
 			struct device_attribute *attr,
 			char *buf)
 {
@@ -1460,17 +1460,17 @@ static ssize_t show_rtap_filter(struct device *d,
 		       priv->prom_priv ? priv->prom_priv->filter : 0);
 }
 
-static DEVICE_ATTR(rtap_filter, 0600, show_rtap_filter, store_rtap_filter);
+static DEVICE_ATTR_ADMIN_RW(rtap_filter);
 #endif
 
-static ssize_t show_scan_age(struct device *d, struct device_attribute *attr,
+static ssize_t scan_age_show(struct device *d, struct device_attribute *attr,
 			     char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%d\n", priv->ieee->scan_age);
 }
 
-static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
+static ssize_t scan_age_store(struct device *d, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1504,16 +1504,16 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static DEVICE_ATTR(scan_age, 0644, show_scan_age, store_scan_age);
+static DEVICE_ATTR_RW(scan_age);
 
-static ssize_t show_led(struct device *d, struct device_attribute *attr,
+static ssize_t led_show(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%d\n", (priv->config & CFG_NO_LED) ? 0 : 1);
 }
 
-static ssize_t store_led(struct device *d, struct device_attribute *attr,
+static ssize_t led_store(struct device *d, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1537,36 +1537,36 @@ static ssize_t store_led(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(led, 0644, show_led, store_led);
+static DEVICE_ATTR_RW(led);
 
-static ssize_t show_status(struct device *d,
+static ssize_t status_show(struct device *d,
 			   struct device_attribute *attr, char *buf)
 {
 	struct ipw_priv *p = dev_get_drvdata(d);
 	return sprintf(buf, "0x%08x\n", (int)p->status);
 }
 
-static DEVICE_ATTR(status, 0444, show_status, NULL);
+static DEVICE_ATTR_RO(status);
 
-static ssize_t show_cfg(struct device *d, struct device_attribute *attr,
+static ssize_t cfg_show(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
 	struct ipw_priv *p = dev_get_drvdata(d);
 	return sprintf(buf, "0x%08x\n", (int)p->config);
 }
 
-static DEVICE_ATTR(cfg, 0444, show_cfg, NULL);
+static DEVICE_ATTR_RO(cfg);
 
-static ssize_t show_nic_type(struct device *d,
+static ssize_t nic_type_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "TYPE: %d\n", priv->nic_type);
 }
 
-static DEVICE_ATTR(nic_type, 0444, show_nic_type, NULL);
+static DEVICE_ATTR_RO(nic_type);
 
-static ssize_t show_ucode_version(struct device *d,
+static ssize_t ucode_version_show(struct device *d,
 				  struct device_attribute *attr, char *buf)
 {
 	u32 len = sizeof(u32), tmp = 0;
@@ -1578,9 +1578,9 @@ static ssize_t show_ucode_version(struct device *d,
 	return sprintf(buf, "0x%08x\n", tmp);
 }
 
-static DEVICE_ATTR(ucode_version, 0644, show_ucode_version, NULL);
+static DEVICE_ATTR_RO(ucode_version);
 
-static ssize_t show_rtc(struct device *d, struct device_attribute *attr,
+static ssize_t rtc_show(struct device *d, struct device_attribute *attr,
 			char *buf)
 {
 	u32 len = sizeof(u32), tmp = 0;
@@ -1592,20 +1592,20 @@ static ssize_t show_rtc(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", tmp);
 }
 
-static DEVICE_ATTR(rtc, 0644, show_rtc, NULL);
+static DEVICE_ATTR_RO(rtc);
 
 /*
  * Add a device attribute to view/control the delay between eeprom
  * operations.
  */
-static ssize_t show_eeprom_delay(struct device *d,
+static ssize_t eeprom_delay_show(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
 	struct ipw_priv *p = dev_get_drvdata(d);
 	int n = p->eeprom_delay;
 	return sprintf(buf, "%i\n", n);
 }
-static ssize_t store_eeprom_delay(struct device *d,
+static ssize_t eeprom_delay_store(struct device *d,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
@@ -1614,9 +1614,9 @@ static ssize_t store_eeprom_delay(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(eeprom_delay, 0644, show_eeprom_delay, store_eeprom_delay);
+static DEVICE_ATTR_RW(eeprom_delay);
 
-static ssize_t show_command_event_reg(struct device *d,
+static ssize_t command_event_reg_show(struct device *d,
 				      struct device_attribute *attr, char *buf)
 {
 	u32 reg = 0;
@@ -1625,7 +1625,7 @@ static ssize_t show_command_event_reg(struct device *d,
 	reg = ipw_read_reg32(p, IPW_INTERNAL_CMD_EVENT);
 	return sprintf(buf, "0x%08x\n", reg);
 }
-static ssize_t store_command_event_reg(struct device *d,
+static ssize_t command_event_reg_store(struct device *d,
 				       struct device_attribute *attr,
 				       const char *buf, size_t count)
 {
@@ -1637,10 +1637,9 @@ static ssize_t store_command_event_reg(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(command_event_reg, 0644,
-		   show_command_event_reg, store_command_event_reg);
+static DEVICE_ATTR_RW(command_event_reg);
 
-static ssize_t show_mem_gpio_reg(struct device *d,
+static ssize_t mem_gpio_reg_show(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
 	u32 reg = 0;
@@ -1649,7 +1648,7 @@ static ssize_t show_mem_gpio_reg(struct device *d,
 	reg = ipw_read_reg32(p, 0x301100);
 	return sprintf(buf, "0x%08x\n", reg);
 }
-static ssize_t store_mem_gpio_reg(struct device *d,
+static ssize_t mem_gpio_reg_store(struct device *d,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
@@ -1661,9 +1660,9 @@ static ssize_t store_mem_gpio_reg(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(mem_gpio_reg, 0644, show_mem_gpio_reg, store_mem_gpio_reg);
+static DEVICE_ATTR_RW(mem_gpio_reg);
 
-static ssize_t show_indirect_dword(struct device *d,
+static ssize_t indirect_dword_show(struct device *d,
 				   struct device_attribute *attr, char *buf)
 {
 	u32 reg = 0;
@@ -1676,7 +1675,7 @@ static ssize_t show_indirect_dword(struct device *d,
 
 	return sprintf(buf, "0x%08x\n", reg);
 }
-static ssize_t store_indirect_dword(struct device *d,
+static ssize_t indirect_dword_store(struct device *d,
 				    struct device_attribute *attr,
 				    const char *buf, size_t count)
 {
@@ -1687,10 +1686,9 @@ static ssize_t store_indirect_dword(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(indirect_dword, 0644,
-		   show_indirect_dword, store_indirect_dword);
+static DEVICE_ATTR_RW(indirect_dword);
 
-static ssize_t show_indirect_byte(struct device *d,
+static ssize_t indirect_byte_show(struct device *d,
 				  struct device_attribute *attr, char *buf)
 {
 	u8 reg = 0;
@@ -1703,7 +1701,7 @@ static ssize_t show_indirect_byte(struct device *d,
 
 	return sprintf(buf, "0x%02x\n", reg);
 }
-static ssize_t store_indirect_byte(struct device *d,
+static ssize_t indirect_byte_store(struct device *d,
 				   struct device_attribute *attr,
 				   const char *buf, size_t count)
 {
@@ -1714,10 +1712,9 @@ static ssize_t store_indirect_byte(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(indirect_byte, 0644,
-		   show_indirect_byte, store_indirect_byte);
+static DEVICE_ATTR_RW(indirect_byte);
 
-static ssize_t show_direct_dword(struct device *d,
+static ssize_t direct_dword_show(struct device *d,
 				 struct device_attribute *attr, char *buf)
 {
 	u32 reg = 0;
@@ -1730,7 +1727,7 @@ static ssize_t show_direct_dword(struct device *d,
 
 	return sprintf(buf, "0x%08x\n", reg);
 }
-static ssize_t store_direct_dword(struct device *d,
+static ssize_t direct_dword_store(struct device *d,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
 {
@@ -1741,7 +1738,7 @@ static ssize_t store_direct_dword(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(direct_dword, 0644, show_direct_dword, store_direct_dword);
+static DEVICE_ATTR_RW(direct_dword);
 
 static int rf_kill_active(struct ipw_priv *priv)
 {
@@ -1756,7 +1753,7 @@ static int rf_kill_active(struct ipw_priv *priv)
 	return (priv->status & STATUS_RF_KILL_HW) ? 1 : 0;
 }
 
-static ssize_t show_rf_kill(struct device *d, struct device_attribute *attr,
+static ssize_t rf_kill_show(struct device *d, struct device_attribute *attr,
 			    char *buf)
 {
 	/* 0 - RF kill not enabled
@@ -1802,7 +1799,7 @@ static int ipw_radio_kill_sw(struct ipw_priv *priv, int disable_radio)
 	return 1;
 }
 
-static ssize_t store_rf_kill(struct device *d, struct device_attribute *attr,
+static ssize_t rf_kill_store(struct device *d, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1812,9 +1809,9 @@ static ssize_t store_rf_kill(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(rf_kill, 0644, show_rf_kill, store_rf_kill);
+static DEVICE_ATTR_RW(rf_kill);
 
-static ssize_t show_speed_scan(struct device *d, struct device_attribute *attr,
+static ssize_t speed_scan_show(struct device *d, struct device_attribute *attr,
 			       char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1829,7 +1826,7 @@ static ssize_t show_speed_scan(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0\n");
 }
 
-static ssize_t store_speed_scan(struct device *d, struct device_attribute *attr,
+static ssize_t speed_scan_store(struct device *d, struct device_attribute *attr,
 				const char *buf, size_t count)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1865,16 +1862,16 @@ static ssize_t store_speed_scan(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(speed_scan, 0644, show_speed_scan, store_speed_scan);
+static DEVICE_ATTR_RW(speed_scan);
 
-static ssize_t show_net_stats(struct device *d, struct device_attribute *attr,
+static ssize_t net_stats_show(struct device *d, struct device_attribute *attr,
 			      char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
 	return sprintf(buf, "%c\n", (priv->config & CFG_NET_STATS) ? '1' : '0');
 }
 
-static ssize_t store_net_stats(struct device *d, struct device_attribute *attr,
+static ssize_t net_stats_store(struct device *d, struct device_attribute *attr,
 			       const char *buf, size_t count)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
@@ -1886,9 +1883,9 @@ static ssize_t store_net_stats(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(net_stats, 0644, show_net_stats, store_net_stats);
+static DEVICE_ATTR_RW(net_stats);
 
-static ssize_t show_channels(struct device *d,
+static ssize_t channels_show(struct device *d,
 			     struct device_attribute *attr,
 			     char *buf)
 {
@@ -1932,7 +1929,7 @@ static ssize_t show_channels(struct device *d,
 	return len;
 }
 
-static DEVICE_ATTR(channels, 0400, show_channels, NULL);
+static DEVICE_ATTR_ADMIN_RO(channels);
 
 static void notify_wx_assoc_event(struct ipw_priv *priv)
 {
-- 
2.20.1



