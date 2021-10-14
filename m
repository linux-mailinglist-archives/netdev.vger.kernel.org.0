Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894C642CFE8
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 03:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhJNB27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 21:28:59 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:50020 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229967AbhJNB26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 21:28:58 -0400
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-03 (Coremail) with SMTP id rQCowADHqOVDh2dh39eAAw--.51542S2;
        Thu, 14 Oct 2021 09:26:27 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] hv_netvsc: Add comment of netvsc_xdp_xmit()
Date:   Thu, 14 Oct 2021 01:26:26 +0000
Message-Id: <1634174786-1810351-1-git-send-email-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: rQCowADHqOVDh2dh39eAAw--.51542S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr18XFyrZFykGFWfAFy8uFg_yoWfAFc_u3
        48WF17Xr4YkF1vkF4DGF4rZFy8twsFqFyfZrWIqrW3Ja4UArWUXwnYvF9rGr48WrW8Cr9x
        Gwn7Xay7Z347WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
        n2kIc2xKxwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
        W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
        1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
        IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAI
        cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
        nxnUUI43ZEXa7VUbLiSPUUUUU==
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding comment to avoid the misusing of netvsc_xdp_xmit().
Otherwise the value of skb->queue_mapping could be 0 and
then the return value of skb_get_rx_queue() could be MAX_U16
cause by overflow.

Fixes: 351e158 ("hv_netvsc: Add XDP support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/hyperv/netvsc_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f682a55..ac9529c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -803,6 +803,7 @@ void netvsc_linkstatus_callback(struct net_device *net,
 	schedule_delayed_work(&ndev_ctx->dwork, 0);
 }
 
+/* This function should only be called after skb_record_rx_queue() */
 static void netvsc_xdp_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	int rc;
-- 
2.7.4

