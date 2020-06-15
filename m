Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6142D1F9278
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 11:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgFOJCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 05:02:34 -0400
Received: from m17617.mail.qiye.163.com ([59.111.176.17]:59054 "EHLO
        m17617.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbgFOJCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 05:02:33 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.227])
        by m17617.mail.qiye.163.com (Hmail) with ESMTPA id C6ACE2617F6;
        Mon, 15 Jun 2020 17:02:28 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] qlcnic: Use kobj_to_dev() instead
Date:   Mon, 15 Jun 2020 17:02:23 +0800
Message-Id: <1592211744-31822-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTBkZH04fGUJLT0xIVkpOQklJSkpMT0JJS0tVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mzo6Azo6HDg6LwgvShY8PgJK
        MwMwFBRVSlVKTkJJSUpKTE9CTU1MVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlJTFlXWQgBWUFMTENONwY+
X-HM-Tid: 0a72b73739109375kuwsc6ace2617f6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kobj_to_dev() instead of container_of()

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c | 34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)
 mode change 100644 => 100755 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
index 8d7b9bb..1003763
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c
@@ -269,7 +269,7 @@ static ssize_t qlcnic_sysfs_read_crb(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *attr, char *buf,
 				     loff_t offset, size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	int ret;
 
@@ -286,7 +286,7 @@ static ssize_t qlcnic_sysfs_write_crb(struct file *filp, struct kobject *kobj,
 				      struct bin_attribute *attr, char *buf,
 				      loff_t offset, size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	int ret;
 
@@ -315,7 +315,7 @@ static ssize_t qlcnic_sysfs_read_mem(struct file *filp, struct kobject *kobj,
 				     struct bin_attribute *attr, char *buf,
 				     loff_t offset, size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	u64 data;
 	int ret;
@@ -337,7 +337,7 @@ static ssize_t qlcnic_sysfs_write_mem(struct file *filp, struct kobject *kobj,
 				      struct bin_attribute *attr, char *buf,
 				      loff_t offset, size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	u64 data;
 	int ret;
@@ -402,7 +402,7 @@ static ssize_t qlcnic_sysfs_write_pm_config(struct file *filp,
 					    char *buf, loff_t offset,
 					    size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_pm_func_cfg *pm_cfg;
 	u32 id, action, pci_func;
@@ -452,7 +452,7 @@ static ssize_t qlcnic_sysfs_read_pm_config(struct file *filp,
 					   char *buf, loff_t offset,
 					   size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_pm_func_cfg *pm_cfg;
 	u8 pci_func;
@@ -545,7 +545,7 @@ static ssize_t qlcnic_sysfs_write_esw_config(struct file *file,
 					     char *buf, loff_t offset,
 					     size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_esw_func_cfg *esw_cfg;
 	struct qlcnic_npar_info *npar;
@@ -629,7 +629,7 @@ static ssize_t qlcnic_sysfs_read_esw_config(struct file *file,
 					    char *buf, loff_t offset,
 					    size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_esw_func_cfg *esw_cfg;
 	u8 pci_func;
@@ -681,7 +681,7 @@ static ssize_t qlcnic_sysfs_write_npar_config(struct file *file,
 					      char *buf, loff_t offset,
 					      size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_info nic_info;
 	struct qlcnic_npar_func_cfg *np_cfg;
@@ -728,7 +728,7 @@ static ssize_t qlcnic_sysfs_read_npar_config(struct file *file,
 					     char *buf, loff_t offset,
 					     size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_npar_func_cfg *np_cfg;
 	struct qlcnic_info nic_info;
@@ -775,7 +775,7 @@ static ssize_t qlcnic_sysfs_get_port_stats(struct file *file,
 					   char *buf, loff_t offset,
 					   size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_esw_statistics port_stats;
 	int ret;
@@ -810,7 +810,7 @@ static ssize_t qlcnic_sysfs_get_esw_stats(struct file *file,
 					  char *buf, loff_t offset,
 					  size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_esw_statistics esw_stats;
 	int ret;
@@ -845,7 +845,7 @@ static ssize_t qlcnic_sysfs_clear_esw_stats(struct file *file,
 					    char *buf, loff_t offset,
 					    size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	int ret;
 
@@ -875,7 +875,7 @@ static ssize_t qlcnic_sysfs_clear_port_stats(struct file *file,
 					     size_t size)
 {
 
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	int ret;
 
@@ -904,7 +904,7 @@ static ssize_t qlcnic_sysfs_read_pci_config(struct file *file,
 					    char *buf, loff_t offset,
 					    size_t size)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 	struct qlcnic_pci_func_cfg *pci_cfg;
 	struct qlcnic_pci_info *pci_info;
@@ -946,7 +946,7 @@ static ssize_t qlcnic_83xx_sysfs_flash_read_handler(struct file *filp,
 {
 	unsigned char *p_read_buf;
 	int  ret, count;
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 
 	if (!size)
@@ -1124,7 +1124,7 @@ static ssize_t qlcnic_83xx_sysfs_flash_write_handler(struct file *filp,
 	int  ret;
 	static int flash_mode;
 	unsigned long data;
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct qlcnic_adapter *adapter = dev_get_drvdata(dev);
 
 	ret = kstrtoul(buf, 16, &data);
-- 
2.7.4

