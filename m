Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC50D30D1C0
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhBCCp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:45:26 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:51325 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230215AbhBCCpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 21:45:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UNjXz5s_1612320271;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UNjXz5s_1612320271)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Feb 2021 10:44:38 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] esp: Simplify the calculation of variables
Date:   Wed,  3 Feb 2021 10:44:30 +0800
Message-Id: <1612320270-873-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./net/ipv6/esp6.c:791:16-18: WARNING !A || A && B is equivalent
to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 net/ipv6/esp6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 2b804fc..153ad10 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -788,7 +788,7 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 	int hlen = sizeof(struct ip_esp_hdr) + crypto_aead_ivsize(aead);
 	int hdr_len = skb_network_header_len(skb);
 
-	if (!xo || (xo && !(xo->flags & CRYPTO_DONE)))
+	if (!xo || !(xo->flags & CRYPTO_DONE))
 		kfree(ESP_SKB_CB(skb)->tmp);
 
 	if (unlikely(err))
-- 
1.8.3.1

