Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477A0540499
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345495AbiFGRRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344707AbiFGRRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:44 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA8E4FC5E
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:43 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso4251966pjk.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8PPQ+e5B3bo3oZ0FlS4Jz6Ii1VVUtQoGFiulGS3lIN4=;
        b=PdnqY4K33C3bUAhljq+1Ewak3BgOSbtDq3wmbUBUIE9aYfW+bkHKna9jJrPSb/uawO
         XnvykqSNlKkcmp9ppjKq+O7Dh67oe0t9zfLFPcKKhlsBZ8DyozRQfZUIwCMEJqJ13bAL
         BoTadRf8UCUMnvBzFHKGSCALyGj0uZ1M1Ixq0+SMxBSq3lCON620SRwlcZ0JDkzUTAlG
         NHlkACCV54nGbTjXIjf81D0yQM1Vbx1AiZy5iPke44wTCgv32XXrBVxSVd4aX3H2iQvr
         rfND9CNFqoyDhATEXy1JJ3R8mWXcNHChRgTSl6mkIrmoO8TMM787O29KFc9hxMBuBHxR
         87fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8PPQ+e5B3bo3oZ0FlS4Jz6Ii1VVUtQoGFiulGS3lIN4=;
        b=Yu1i+LjGBYYJpy4tBZLe9CZg4u8ShWxjdHoF5Wak3j1ArXppUMEABGxFagwK/l7sXJ
         YMLBmYTekU/WRdgrSKsvjz4KL1IpMdcDDUw70qk4PycgPgRn/wPdmdSll94A9eJluE17
         Ymb+ETSM1V790GpFDy0LSq4pcG6UWx/BSBYdXl3zvPaZQt2dmfvXtJJLNiB4n2AXrQ4T
         Pe/T/aE7VSIM7XHM90zAo2vPRZG4JDiZgndY12RK/Hak2t9OwiOIQUbxrb8+xhfvRCf3
         xmCC2zq6cB+kRVdhcY5hSDl7qhHPX7i5hm4q2FA2hqyPE/2yPweQgQhx+a3QFTum0Y73
         gWCA==
X-Gm-Message-State: AOAM533GdcrGkWywqijWLwiYcyKoPE9lH3qe3gPJKMD4qiHOOEAEspcL
        ZtQWRF2OZi3kfM1MmQKqCFM=
X-Google-Smtp-Source: ABdhPJyjCv1ZRd4GhaEC30IDNdRUQoWW3sJMrA3iU52RWoReDKOWOM/a13hgNZ0yfpr6NWP3gw5NgA==
X-Received: by 2002:a17:903:1103:b0:167:839e:7ba1 with SMTP id n3-20020a170903110300b00167839e7ba1mr9469146plh.136.1654622262648;
        Tue, 07 Jun 2022 10:17:42 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:37 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/8] net: use DEBUG_NET_WARN_ON_ONCE() in __release_sock()
Date:   Tue,  7 Jun 2022 10:17:25 -0700
Message-Id: <20220607171732.21191-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Check against skb dst in socket backlog has never triggered
in past years.

Keep the check only for CONFIG_DEBUG_NET=y builds.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 2ff40dd0a7a652029cca1743109286b50c2a17f3..f5062d9e122275a511efbc4d30de2ee501182498 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2844,7 +2844,7 @@ void __release_sock(struct sock *sk)
 		do {
 			next = skb->next;
 			prefetch(next);
-			WARN_ON_ONCE(skb_dst_is_noref(skb));
+			DEBUG_NET_WARN_ON_ONCE(skb_dst_is_noref(skb));
 			skb_mark_not_on_list(skb);
 			sk_backlog_rcv(sk, skb);
 
-- 
2.36.1.255.ge46751e96f-goog

