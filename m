Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1065E7568
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiIWIGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 04:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbiIWIGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 04:06:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C567D11E0CC;
        Fri, 23 Sep 2022 01:06:45 -0700 (PDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYl605hsbzpVP8;
        Fri, 23 Sep 2022 16:03:52 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 16:06:43 +0800
Received: from huawei.com (10.175.113.133) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 16:06:42 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <chuck.lever@oracle.com>, <jlayton@kernel.org>,
        <trond.myklebust@hammerspace.com>, <anna@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <wanghai38@huawei.com>, <linux-nfs@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] SUNRPC: use DEFINE_PROC_SHOW_ATTRIBUTE to define rpc_proc_fops
Date:   Fri, 23 Sep 2022 16:35:02 +0800
Message-ID: <20220923083502.8722-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use DEFINE_PROC_SHOW_ATTRIBUTE helper macro to simplify the code.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/sunrpc/stats.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/stats.c b/net/sunrpc/stats.c
index 52908f9e6ea..7b4c42e56cf 100644
--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -34,7 +34,8 @@
 /*
  * Get RPC client stats
  */
-static int rpc_proc_show(struct seq_file *seq, void *v) {
+static int rpc_show(struct seq_file *seq, void *v)
+{
 	const struct rpc_stat	*statp = seq->private;
 	const struct rpc_program *prog = statp->program;
 	unsigned int i, j;
@@ -64,17 +65,7 @@ static int rpc_proc_show(struct seq_file *seq, void *v) {
 	return 0;
 }
 
-static int rpc_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, rpc_proc_show, pde_data(inode));
-}
-
-static const struct proc_ops rpc_proc_ops = {
-	.proc_open	= rpc_proc_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= single_release,
-};
+DEFINE_PROC_SHOW_ATTRIBUTE(rpc);
 
 /*
  * Get RPC server stats
-- 
2.17.1

