Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48CA327C8F
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhCAKr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:47:29 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:42165 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234673AbhCAKq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:46:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UPykXWy_1614595564;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UPykXWy_1614595564)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 01 Mar 2021 18:46:10 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] esp4: Simplify the calculation of variables
Date:   Mon,  1 Mar 2021 18:46:02 +0800
Message-Id: <1614595562-56960-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./net/ipv4/esp4.c:757:16-18: WARNING !A || A && B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv4/esp4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a3271ec..804a769 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -754,7 +754,7 @@ int esp_input_done2(struct sk_buff *skb, int err)
 	int hlen = sizeof(struct ip_esp_hdr) + crypto_aead_ivsize(aead);
 	int ihl;
 
-	if (!xo || (xo && !(xo->flags & CRYPTO_DONE)))
+	if (!xo || !(xo->flags & CRYPTO_DONE))
 		kfree(ESP_SKB_CB(skb)->tmp);
 
 	if (unlikely(err))
-- 
1.8.3.1

