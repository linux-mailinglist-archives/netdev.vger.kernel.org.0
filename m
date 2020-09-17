Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9B426DC56
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgIQNBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 09:01:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13270 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbgIQNAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 09:00:42 -0400
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 09:00:40 EDT
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2D97E76B3A852E820812;
        Thu, 17 Sep 2020 20:44:41 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:44:31 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 17 Sep 2020 20:45:08 +0800
Message-ID: <20200917124508.102754-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 63 ++-----------------
 1 file changed, 6 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 56d9927fb..b87db0846 100644
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
-	.read = seq_read,
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
-	.read = seq_read,
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
-	.read = seq_read,
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
2.23.0

