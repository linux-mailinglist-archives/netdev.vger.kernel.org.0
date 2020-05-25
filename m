Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E678E1E1049
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 16:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390939AbgEYORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 10:17:42 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:56638 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388714AbgEYORm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 10:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=yXApgBJF7xcQKVRSk3HDzC6DxxKYhOHfHRVUfNQbTPs=; b=4
        BarvoNNC8GKkvRFHoG7AohTA9EhGNyeRiT1JyawU/rRBzQPapG7ZeW+uXFgn8g1I
        7DYSW70ZrywJERuZMQahf83cEc1rwfa/SrSEpztfz83rzTi6I+CyuUYf9w3ANu2t
        2P8FMD41z9jdenOSsjZpRhjaQrOjk12ac6N4BIivmM=
Received: from localhost.localdomain (unknown [223.73.184.21])
        by app1 (Coremail) with SMTP id XAUFCgAnLaF208teMdMwAg--.41704S3;
        Mon, 25 May 2020 22:17:27 +0800 (CST)
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
Subject: [PATCH] SUNRPC: Remove unreachable error condition in rpcb_getport_async()
Date:   Mon, 25 May 2020 22:17:02 +0800
Message-Id: <1590416223-52653-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgAnLaF208teMdMwAg--.41704S3
X-Coremail-Antispam: 1UD129KBjvdXoW7JF18KF15tF4xtFy5tF15twb_yoWDWrb_JF
        W8AFs7Za4vkrn7tanrtrWfJ3y7Z3W2yr1vgwsxA34xXayxX39xtrs5Zrn8Aa17GFWfur1U
        Crs3Ga48Cw12kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbf8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IE
        rcIFxwACI402YVCY1x02628vn2kIc2xKxwCY02Avz4vE14v_Xryl42xK82IYc2Ij64vIr4
        1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
        67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
        8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20E
        Y4v20xvaj40_Gr0_Zr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
        AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbksqPUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rpcb_getport_async() invokes rpcb_call_async(), which return the value
of rpc_run_task() to "child". Since rpc_run_task() is impossible to
return an ERR pointer, there is no need to add the IS_ERR() condition on
"child" here. So we need to remove it.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/sunrpc/rpcb_clnt.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 4a020b688860..c27123e6ba80 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -795,12 +795,6 @@ void rpcb_getport_async(struct rpc_task *task)
 
 	child = rpcb_call_async(rpcb_clnt, map, proc);
 	rpc_release_client(rpcb_clnt);
-	if (IS_ERR(child)) {
-		/* rpcb_map_release() has freed the arguments */
-		dprintk("RPC: %5u %s: rpc_run_task failed\n",
-			task->tk_pid, __func__);
-		return;
-	}
 
 	xprt->stat.bind_count++;
 	rpc_put_task(child);
-- 
2.7.4

