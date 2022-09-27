Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0BD5EC00C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiI0Kpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiI0Kpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:45:53 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2953A59BB;
        Tue, 27 Sep 2022 03:45:51 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4McGQ71VzSz1P6p6;
        Tue, 27 Sep 2022 18:41:35 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 18:45:49 +0800
Received: from huawei.com (10.175.113.32) by dggpemm100009.china.huawei.com
 (7.185.36.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 18:45:49 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        "John Crispin" <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Liu Shixin" <liushixin2@huawei.com>
Subject: [PATCH net-next v2] net: ethernet: mtk_eth_soc: use DEFINE_SHOW_ATTRIBUTE to simplify code
Date:   Tue, 27 Sep 2022 19:19:25 +0800
Message-ID: <20220927111925.2424100-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm100009.china.huawei.com (7.185.36.113)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE helper macro to simplify the code.
No functional change.

Signed-off-by: Liu Shixin <liushixin2@huawei.com>
---

v1->v2: Rebase on net-next.

 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   | 36 ++++---------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index ec49829ab32d..391b071bcff3 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -162,52 +162,28 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
 }
 
 static int
-mtk_ppe_debugfs_foe_show_all(struct seq_file *m, void *private)
+mtk_ppe_debugfs_foe_all_show(struct seq_file *m, void *private)
 {
 	return mtk_ppe_debugfs_foe_show(m, private, false);
 }
+DEFINE_SHOW_ATTRIBUTE(mtk_ppe_debugfs_foe_all);
 
 static int
-mtk_ppe_debugfs_foe_show_bind(struct seq_file *m, void *private)
+mtk_ppe_debugfs_foe_bind_show(struct seq_file *m, void *private)
 {
 	return mtk_ppe_debugfs_foe_show(m, private, true);
 }
-
-static int
-mtk_ppe_debugfs_foe_open_all(struct inode *inode, struct file *file)
-{
-	return single_open(file, mtk_ppe_debugfs_foe_show_all,
-			   inode->i_private);
-}
-
-static int
-mtk_ppe_debugfs_foe_open_bind(struct inode *inode, struct file *file)
-{
-	return single_open(file, mtk_ppe_debugfs_foe_show_bind,
-			   inode->i_private);
-}
+DEFINE_SHOW_ATTRIBUTE(mtk_ppe_debugfs_foe_bind);
 
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe, int index)
 {
-	static const struct file_operations fops_all = {
-		.open = mtk_ppe_debugfs_foe_open_all,
-		.read = seq_read,
-		.llseek = seq_lseek,
-		.release = single_release,
-	};
-	static const struct file_operations fops_bind = {
-		.open = mtk_ppe_debugfs_foe_open_bind,
-		.read = seq_read,
-		.llseek = seq_lseek,
-		.release = single_release,
-	};
 	struct dentry *root;
 
 	snprintf(ppe->dirname, sizeof(ppe->dirname), "ppe%d", index);
 
 	root = debugfs_create_dir(ppe->dirname, NULL);
-	debugfs_create_file("entries", S_IRUGO, root, ppe, &fops_all);
-	debugfs_create_file("bind", S_IRUGO, root, ppe, &fops_bind);
+	debugfs_create_file("entries", S_IRUGO, root, ppe, &mtk_ppe_debugfs_foe_all_fops);
+	debugfs_create_file("bind", S_IRUGO, root, ppe, &mtk_ppe_debugfs_foe_bind_fops);
 
 	return 0;
 }
-- 
2.25.1

