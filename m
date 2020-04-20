Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB551B0FB0
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgDTPPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:15:20 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:33686 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbgDTPPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=j04KOWK7oiQmUIJaNm9oBICc+BDi64eNQbDFosd6GAc=; b=O
        62Hh01nRPnqzdOOXRJBwPCqr2UDY3DOTlZATbevd/ObcSAWL7KgWQL0sDcBMZ7LJ
        kGxzdz1++TMkEI/En/EeTpEOXMQpjeZKSJ8jWioH4uONIU9GcnG6EKO21XAM3pLX
        U3qiTCZjCtWnELGaFn90k6DnmoT0HMDAjTbn21FI6s=
Received: from localhost.localdomain (unknown [120.229.255.67])
        by app2 (Coremail) with SMTP id XQUFCgCHj+NwvJ1eNKwjAA--.950S3;
        Mon, 20 Apr 2020 23:14:58 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH v2] SUNRPC: Remove unreachable error condition
Date:   Mon, 20 Apr 2020 23:14:19 +0800
Message-Id: <1587395659-86206-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgCHj+NwvJ1eNKwjAA--.950S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw48Kr4rAryUZry3Gr47CFg_yoWkAwc_XF
        4IqFykX34DGF4qyFZrCr40yFy7C3y5Kr18Gwn7G34xG3Wjv3Z0vFs5CFn3ArWfurWfuF13
        CrZrGry3Zw13tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUba8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
        6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbHa0DUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rpc_clnt_test_and_add_xprt() invokes rpc_call_null_helper(), which
return the value of rpc_run_task() to "task". Since rpc_run_task() is
impossible to return an ERR pointer, there is no need to add the
IS_ERR() condition on "task" here. So we need to remove it.

Fixes: 7f554890587c ("SUNRPC: Allow addition of new transports to a
struct rpc_clnt")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
Changes in v2:
- Remove useless IS_ERR check instead of fixing a refcnt leak in this
error path
---
 net/sunrpc/clnt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 7324b21f923e..5957e336caf7 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2803,8 +2803,7 @@ int rpc_clnt_test_and_add_xprt(struct rpc_clnt *clnt,
 	task = rpc_call_null_helper(clnt, xprt, NULL,
 			RPC_TASK_SOFT|RPC_TASK_SOFTCONN|RPC_TASK_ASYNC|RPC_TASK_NULLCREDS,
 			&rpc_cb_add_xprt_call_ops, data);
-	if (IS_ERR(task))
-		return PTR_ERR(task);
+
 	rpc_put_task(task);
 success:
 	return 1;
-- 
2.7.4

