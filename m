Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA8E35E645A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbiIVNzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiIVNzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:55:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7A5E7C15
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:55:46 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MYGvx4vHtzHp5B;
        Thu, 22 Sep 2022 21:53:33 +0800 (CST)
Received: from dggpemm100009.china.huawei.com (7.185.36.113) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 21:55:44 +0800
Received: from huawei.com (10.175.113.32) by dggpemm100009.china.huawei.com
 (7.185.36.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 21:55:43 +0800
From:   Liu Shixin <liushixin2@huawei.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH] net: ethernet: mtk_eth_soc: use DEFINE_SHOW_ATTRIBUTE to simplify code
Date:   Thu, 22 Sep 2022 22:29:29 +0800
Message-ID: <20220922142929.3250844-1-liushixin2@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
 .../net/ethernet/mediatek/mtk_ppe_debugfs.c   | 38 +++----------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
index eb0b598f14e4..e0d7c6f83b80 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
@@ -162,52 +162,26 @@ mtk_ppe_debugfs_foe_show(struct seq_file *m, void *private, bool bind)
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
 
 int mtk_ppe_debugfs_init(struct mtk_ppe *ppe)
 {
-	static const struct file_operations fops_all = {
-		.open = mtk_ppe_debugfs_foe_open_all,
-		.read = seq_read,
-		.llseek = seq_lseek,
-		.release = single_release,
-	};
-
-	static const struct file_operations fops_bind = {
-		.open = mtk_ppe_debugfs_foe_open_bind,
-		.read = seq_read,
-		.llseek = seq_lseek,
-		.release = single_release,
-	};
-
 	struct dentry *root;
 
 	root = debugfs_create_dir("mtk_ppe", NULL);
-	debugfs_create_file("entries", S_IRUGO, root, ppe, &fops_all);
-	debugfs_create_file("bind", S_IRUGO, root, ppe, &fops_bind);
+	debugfs_create_file("entries", S_IRUGO, root, ppe, &mtk_ppe_debugfs_foe_all_fops);
+	debugfs_create_file("bind", S_IRUGO, root, ppe, &mtk_ppe_debugfs_foe_bind_fops);
 
 	return 0;
 }
-- 
2.25.1

