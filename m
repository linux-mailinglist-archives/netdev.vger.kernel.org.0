Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254DA221F14
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbgGPIzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:55:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35396 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726013AbgGPIzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 04:55:13 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DCD12226F6AA503A777A;
        Thu, 16 Jul 2020 16:55:08 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 16:55:03 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 16 Jul 2020 16:58:59 +0800
Message-ID: <20200716085859.11635-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yongqiang Liu <liuyongqiang13@huawei.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
---
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 63 ++-----------------
 1 file changed, 6 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index f80f94e1e..b87db0846 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -42,24 +42,7 @@ static int dpaa2_dbg_cpu_show(struct seq_file *file, void *offset)
 	return 0;
 }
 
-static int dpaa2_dbg_cpu_open(struct inode *inode, struct file *file)
-{
-	int err;
-	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)inode->i_private;
-
-	err = single_open(file, dpaa2_dbg_cpu_show, priv);
-	if (err < 0)
-		netdev_err(priv->net_dev, "single_open() failed\n");
-
-	return err;
-}
-
-static const struct file_operations dpaa2_dbg_cpu_ops = {
-	.open = dpaa2_dbg_cpu_open,
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_cpu);
 
 static char *fq_type_to_str(struct dpaa2_eth_fq *fq)
 {
@@ -106,24 +89,7 @@ static int dpaa2_dbg_fqs_show(struct seq_file *file, void *offset)
 	return 0;
 }
 
-static int dpaa2_dbg_fqs_open(struct inode *inode, struct file *file)
-{
-	int err;
-	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)inode->i_private;
-
-	err = single_open(file, dpaa2_dbg_fqs_show, priv);
-	if (err < 0)
-		netdev_err(priv->net_dev, "single_open() failed\n");
-
-	return err;
-}
-
-static const struct file_operations dpaa2_dbg_fq_ops = {
-	.open = dpaa2_dbg_fqs_open,
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_fqs);
 
 static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 {
@@ -151,24 +117,7 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 	return 0;
 }
 
-static int dpaa2_dbg_ch_open(struct inode *inode, struct file *file)
-{
-	int err;
-	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)inode->i_private;
-
-	err = single_open(file, dpaa2_dbg_ch_show, priv);
-	if (err < 0)
-		netdev_err(priv->net_dev, "single_open() failed\n");
-
-	return err;
-}
-
-static const struct file_operations dpaa2_dbg_ch_ops = {
-	.open = dpaa2_dbg_ch_open,
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_ch);
 
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 {
@@ -179,13 +128,13 @@ void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 	priv->dbg.dir = dir;
 
 	/* per-cpu stats file */
-	debugfs_create_file("cpu_stats", 0444, dir, priv, &dpaa2_dbg_cpu_ops);
+	debugfs_create_file("cpu_stats", 0444, dir, priv, &dpaa2_dbg_cpu_fops);
 
 	/* per-fq stats file */
-	debugfs_create_file("fq_stats", 0444, dir, priv, &dpaa2_dbg_fq_ops);
+	debugfs_create_file("fq_stats", 0444, dir, priv, &dpaa2_dbg_fqs_fops);
 
 	/* per-fq stats file */
-	debugfs_create_file("ch_stats", 0444, dir, priv, &dpaa2_dbg_ch_ops);
+	debugfs_create_file("ch_stats", 0444, dir, priv, &dpaa2_dbg_ch_fops);
 }
 
 void dpaa2_dbg_remove(struct dpaa2_eth_priv *priv)
-- 
2.17.1

