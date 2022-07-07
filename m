Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0061856A1AB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGGLv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiGGLvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:51:54 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D4A53D0D;
        Thu,  7 Jul 2022 04:51:53 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v16so14509975wrd.13;
        Thu, 07 Jul 2022 04:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ejPnmCaORJdrMyGe4YE1VTQPE0oM/mTMwJ4lvV5CWyQ=;
        b=SK3A5sYXIVyTW3AVh10tPpO6KnSEQ4egjekYG6KZGAt+mCECxdG6mTPJ2p8ZWL5QFQ
         ouawLTWIMwVli8N8ljpIQvzIt1i0bcfMVXvjSO0cxiykpwts/Nc3OtQWaCnnhpW0SLUf
         hnfyQe2KuUpjk20kTFc92AmVn7sy9HrrlYiKEy2IqYe3NX9aOTLZZC6teTEa5va2mxPp
         t4mNV5ffHSaQrinWTcwMLEMTjEPiP9JKHC2ioeb+nFpvVg6r+Sobu680b3CcqD5L4vIz
         GO7Dn53HG5Tkza0e34Z6SuUNCsNlFa4EJsGADSd7+mXJD2RaMMQXYzRrdJBBJPHn11v7
         uhmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ejPnmCaORJdrMyGe4YE1VTQPE0oM/mTMwJ4lvV5CWyQ=;
        b=HQx/x8KbUSLgCPo/6ynmRb1OkoDXs6/ntbBIye0XmJtU7lQkSS8bVubGcI1VaOXGW+
         T8zU9BouiqgjdQcaizIigWy4P6qz48ibCz+BISKTR5e1quLTgpLhczPkrXWia3xoRcWA
         qxSr533mFRyjps291nG5nMh2VOPP36Zb4CcsfPBkYfj7KHUp0m7G8R0sU9PHZ1JkS2b+
         b/LQ8CWJnuU5cov2M1tvBjJ9sutjnSXYgG3vpSthf5c81w5PosSmB0W64FjzBc/3tlNl
         Zgj3f2NOhQvlnqumzouRQYjPH/ZvjwkBuib8WQuwJzlKzlRFJuhBJV97HMePtSO5ikmh
         8qfw==
X-Gm-Message-State: AJIora/X41tyvQGKCwWbuZowgg/RHofLRBqAI+3CB2bNIf9Iv7jIWlwe
        d8kBwIKVwBPh4OCEurt/YJWiEaceQCsryK3QU9Y=
X-Google-Smtp-Source: AGRyM1uytWO0KV2ZLFjSm4t05Yvv+I9jZy5pafRH9FHurUA3jy0l6i365aVoG7gkydeS5fXo6NxPTw==
X-Received: by 2002:adf:ec0f:0:b0:21d:7771:c3cb with SMTP id x15-20020adfec0f000000b0021d7771c3cbmr10846010wrn.81.1657194711560;
        Thu, 07 Jul 2022 04:51:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:51:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 04/27] skbuff: add SKBFL_DONT_ORPHAN flag
Date:   Thu,  7 Jul 2022 12:49:35 +0100
Message-Id: <c1dd557e091e21937baa088308770121017daa8c.1657194434.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657194434.git.asml.silence@gmail.com>
References: <cover.1657194434.git.asml.silence@gmail.com>
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

We don't want to list every single ubuf_info callback in
skb_orphan_frags(), add a flag controlling the behaviour.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 8 +++++---
 net/core/skbuff.c      | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d3d10556f0fa..8e12b3b9ad6c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -686,10 +686,13 @@ enum {
 	 * charged to the kernel memory.
 	 */
 	SKBFL_PURE_ZEROCOPY = BIT(2),
+
+	SKBFL_DONT_ORPHAN = BIT(3),
 };
 
 #define SKBFL_ZEROCOPY_FRAG	(SKBFL_ZEROCOPY_ENABLE | SKBFL_SHARED_FRAG)
-#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY)
+#define SKBFL_ALL_ZEROCOPY	(SKBFL_ZEROCOPY_FRAG | SKBFL_PURE_ZEROCOPY | \
+				 SKBFL_DONT_ORPHAN)
 
 /*
  * The callback notifies userspace to release buffers when skb DMA is done in
@@ -3182,8 +3185,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
 {
 	if (likely(!skb_zcopy(skb)))
 		return 0;
-	if (!skb_zcopy_is_nouarg(skb) &&
-	    skb_uarg(skb)->callback == msg_zerocopy_callback)
+	if (skb_shinfo(skb)->flags & SKBFL_DONT_ORPHAN)
 		return 0;
 	return skb_copy_ubufs(skb, gfp_mask);
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 09f56bfa2771..fc22b3d32052 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1193,7 +1193,7 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->len = 1;
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
-	uarg->flags = SKBFL_ZEROCOPY_FRAG;
+	uarg->flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	refcount_set(&uarg->refcnt, 1);
 	sock_hold(sk);
 
-- 
2.36.1

