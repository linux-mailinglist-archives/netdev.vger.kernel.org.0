Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D025E19A816
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 10:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbgDAI7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 04:59:44 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39602 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730574AbgDAI7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 04:59:43 -0400
Received: by mail-pj1-f68.google.com with SMTP id z3so2408905pjr.4
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 01:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=JQOoytMTlG3Bnb50EbIcwB0Is9VzX14cOjEmJJMe1Kc=;
        b=h72EbmOBuSH1tZWPCvm0EohGouBM2h8AmJZROO6Sc5TOfDHRx9LwGaF6Ki/FzUlaB8
         RXJEIfP0pXJlQIx7wSJKKZ94gMEzvmarGfgBB6w9hRXupgtaxsrSri11xsJF4R8ROgw1
         nLPsbP+s9tIAGGaf6qvPcXVjzvx5toxqEQDQSop+ntNN7or+jQzbpE4wa6mSVke9rj/X
         J+Z5K0VNOjtRKaeLxyk5JENu92qW60EKk76CJitBfzYsRkUsusedXQsrZ2G/Uj2S/2To
         Miaj20dG/4kVrDFRPgplkkRPRl/bnCJ8ZEnrwqw4BhcNop3ta7kXZCjBZUJ9biwxnddN
         yNIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=JQOoytMTlG3Bnb50EbIcwB0Is9VzX14cOjEmJJMe1Kc=;
        b=O16PtyPfowlx2oqiv6NdhP1VrcjRxuiHnVzhRVSir06im2ZRjG4nYD6SZUNxN1NsLa
         dCIY2f45KKSNJFCnxHfSCqJm4ZMq1CzNfVPJ8ZyKxZV3w37ePdkfM7KmzLZ2KBUWU5wj
         MyZDR/J7yX2EQiGeuyfxj6fYH6dZwp8g3SNEtHrljyIxc39yjD73Gx2R9R4hPpAyndVK
         EMQtEweRMPRDhl83hKUvEc+FFzz/OUTjnWXckByWtkwKIw6kA4ldsdhQmKmwzLIlHnEr
         s9dSb3ap/2qSxYFv85uKMM9+GXdUpGtNda/rSqspeI2faDaC5ssYBMgt8GB9L1X0jZJF
         Zr6g==
X-Gm-Message-State: AGi0Pub7VLMSmOrkVKUlC4iCS1FI2YAOmgc60YKfPoybZ+HKnGGJE+3e
        pbB3yIKUxfS2EQcDSmQXzd9OEgoJ
X-Google-Smtp-Source: APiQypJr8ELYP3Bg0Uw1MIQOxO1U5sT2kx240dtI5CIeqDbomRwYCyothGvvGUJ4+JOdLmBzZTuoIg==
X-Received: by 2002:a17:90a:30c3:: with SMTP id h61mr3594716pjb.18.1585731582139;
        Wed, 01 Apr 2020 01:59:42 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e9sm1109954pfl.179.2020.04.01.01.59.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 01:59:41 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 1/5] xfrm: allow to accept packets with ipv6 NEXTHDR_HOP in xfrm_input
Date:   Wed,  1 Apr 2020 16:59:21 +0800
Message-Id: <c089597acfb559c70b1485ec84d01a78c8341bb3.1585731430.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

The nexthdr from ESP could be NEXTHDR_HOP(0), so it should
continue processing the packet when nexthdr returns 0 in
xfrm_input(). Otherwize, when ipv6 nexthdr is set, the
packet will be droppped.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index aa35f23..8a202c44 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -644,7 +644,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 		dev_put(skb->dev);
 
 		spin_lock(&x->lock);
-		if (nexthdr <= 0) {
+		if (nexthdr < 0) {
 			if (nexthdr == -EBADMSG) {
 				xfrm_audit_state_icvfail(x, skb,
 							 x->type->proto);
-- 
2.1.0

