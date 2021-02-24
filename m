Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BE632418A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 17:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhBXQBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 11:01:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12645 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhBXPgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 10:36:09 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dm0LM5dJ9z164Mx;
        Wed, 24 Feb 2021 23:33:15 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Wed, 24 Feb 2021 23:34:44 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH] net: bridge: Fix jump_label config
Date:   Wed, 24 Feb 2021 23:38:03 +0800
Message-ID: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
of HAVE_JUMP_LABLE.

Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 net/bridge/br_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 222285d9dae2..065b6cfba40f 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -207,7 +207,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 	int ret;
 
 	net = dev_net(skb->dev);
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))
 		goto frame_finish;
 #endif
-- 
2.26.2

