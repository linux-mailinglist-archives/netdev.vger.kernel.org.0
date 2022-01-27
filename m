Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD00749DD83
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbiA0JN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbiA0JNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:13:54 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F08C061714;
        Thu, 27 Jan 2022 01:13:54 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id q63so2324959pja.1;
        Thu, 27 Jan 2022 01:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rmUqM+JYtP9hKEr5gUjT2LuBcGNasQZbfimvB5akS00=;
        b=FmNJ0RdvWxfmALj/4hQCt9ECPJF0+Iq58fxQpJOlbwgbBj1dQ6jDRQwmO9wu73yStr
         zXwmvJ4pLxbtLKhnTvW6BsjH2kLBFCiKpK02PsyXMIO3L3NTEF0IjnNQjrHB3+249o13
         Yv4lHT6FXdrmXMsibBucrEkGZLJ5dbVknH4YkgjYxb+2RUmbO8Wm19vJB4Aroc/1SuRH
         Z3Szvv3u+x0XismOUJptUit5/uAFVHBDeFdHE6F1oxNFVNyhFO633dTITeIsQGWtoZVv
         4sZ3TjuxCoemIkg7xJdvjiituN+PGqBl5TCXA/WxWv20l3hbSaMQ6KPfCrEWVSr4wSFK
         nwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rmUqM+JYtP9hKEr5gUjT2LuBcGNasQZbfimvB5akS00=;
        b=zF67YII2uLPnWLjwqVk0Vna8bOB53Mjz5BKaYL2VKxcJ3hRYqQk5QaROoXydXJU3J7
         bE2nHc4WWtWcy6QglK0EsrwYMk7WPrtWz13LefZ1Z1u1yuzhUalHa9UE1uE80ou/hKfC
         aNEP99FjNfmHOv8J5rnmeDwn1nXmntShoNOPjOf5ch45GuGfE92S17+YRBijwnuqIzru
         YDVevl+zUbrGQ7yBKChlg5hkB3HFRb8Gc8j7hmWiUnAgTG1IrLB1+rkG6BlcIsNea3pB
         oAp1p0EaA7Ca458LIE41bRJChtMM7bATioLxQxPkCGHVCxf2tDYWGhSEL4aF37WjZXGp
         xdvQ==
X-Gm-Message-State: AOAM532kylE0Mbevm/Tw6hbby1EALgf01I/suCqEHL7U4A3dPBuiVuA8
        EK5+AkLbIj7trKturiNNMrg=
X-Google-Smtp-Source: ABdhPJy5tRAkD0XVxHKuY+wCoVJiiKA0uCOnuWpnm8HZc30Sx4d2PUKW2+o55n+w284BHOMETfTNEg==
X-Received: by 2002:a17:90a:15cf:: with SMTP id w15mr3246619pjd.79.1643274834331;
        Thu, 27 Jan 2022 01:13:54 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:13:53 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
Subject: [PATCH v2 net-next 3/8] net: netfilter: use kfree_drop_reason() for NF_DROP
Date:   Thu, 27 Jan 2022 17:13:03 +0800
Message-Id: <20220127091308.91401-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
skb is dropped by reason of NF_DROP. Following new drop reasons
are introduced:

SKB_DROP_REASON_NETFILTER_DROP

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v2:
- add document for SKB_DROP_REASON_NETFILTER_DROP
---
 include/linux/skbuff.h     | 1 +
 include/trace/events/skb.h | 1 +
 net/netfilter/core.c       | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5c5615a487e7..786ea2c2334e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -320,6 +320,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
 	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
 	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
+	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index a8a64b97504d..3d89f7b09a43 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -16,6 +16,7 @@
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
 	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 354cb472f386..d1c9dfbb11fa 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -621,7 +621,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		case NF_ACCEPT:
 			break;
 		case NF_DROP:
-			kfree_skb(skb);
+			kfree_skb_reason(skb,
+					 SKB_DROP_REASON_NETFILTER_DROP);
 			ret = NF_DROP_GETERR(verdict);
 			if (ret == 0)
 				ret = -EPERM;
-- 
2.34.1

