Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5518B221EC4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgGPInp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:43:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbgGPIno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 04:43:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 18DE657D27D285A20981;
        Thu, 16 Jul 2020 16:43:43 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 16:43:41 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] hsr: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 16 Jul 2020 16:47:28 +0800
Message-ID: <20200716084728.7944-1-miaoqinglang@huawei.com>
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

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 net/hsr/hsr_debugfs.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index d994c83b0..ed7f53475 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -54,16 +54,7 @@ hsr_node_table_show(struct seq_file *sfp, void *data)
 	return 0;
 }
 
-/* hsr_node_table_open - Open the node_table file
- *
- * Description:
- * This routine opens a debugfs file node_table of specific hsr device
- */
-static int
-hsr_node_table_open(struct inode *inode, struct file *filp)
-{
-	return single_open(filp, hsr_node_table_show, inode->i_private);
-}
+DEFINE_SHOW_ATTRIBUTE(hsr_node_table);
 
 void hsr_debugfs_rename(struct net_device *dev)
 {
@@ -78,13 +69,6 @@ void hsr_debugfs_rename(struct net_device *dev)
 		priv->node_tbl_root = d;
 }
 
-static const struct file_operations hsr_fops = {
-	.open	= hsr_node_table_open,
-	.read_iter	= seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
 /* hsr_debugfs_init - create hsr node_table file for dumping
  * the node table
  *
@@ -106,7 +90,7 @@ void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 
 	de = debugfs_create_file("node_table", S_IFREG | 0444,
 				 priv->node_tbl_root, priv,
-				 &hsr_fops);
+				 &hsr_node_table_fops);
 	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr node_table file\n");
 		debugfs_remove(priv->node_tbl_root);
-- 
2.17.1

