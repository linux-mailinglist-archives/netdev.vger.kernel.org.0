Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118B135F163
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 12:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhDNKRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 06:17:35 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33374 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbhDNKR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 06:17:27 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 5AD81800056;
        Wed, 14 Apr 2021 12:17:04 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 12:17:04 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Apr
 2021 12:17:03 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9074A31802CB; Wed, 14 Apr 2021 12:17:03 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/3] esp4: Simplify the calculation of variables
Date:   Wed, 14 Apr 2021 12:16:59 +0200
Message-ID: <20210414101701.324777-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414101701.324777-1-steffen.klassert@secunet.com>
References: <20210414101701.324777-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Fix the following coccicheck warnings:

./net/ipv4/esp4.c:757:16-18: WARNING !A || A && B is equivalent to !A || B.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a3271ec3e162..804a7698df5b 100644
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
2.25.1

