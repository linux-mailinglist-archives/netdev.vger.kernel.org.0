Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D120D5727E8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiGLUxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiGLUxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:13 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0D4CDA1C;
        Tue, 12 Jul 2022 13:53:12 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id bu1so11641726wrb.9;
        Tue, 12 Jul 2022 13:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PuXIMDYTsEzEI4UhsZdMwE6aeyhFjCPDoQCmzh6YH3o=;
        b=QP9OK++DUQUGUN/TfnVfXW4o6NNZJOcm61ED+dTvcywJIfbyqHNgd2Iwavh3F+mj9X
         Rjh9ftLgNpOdYsR56P1d2hM6QN7oPIU2M6c5825vOLnJWB+0arqLlzmQi+2Wn4GO9+61
         1gIyVdHgeAj1RcEH4EB5kV23mslrkcXswLTfLPwFtMm/MsJVRrl9TNtAgfZVzLhG5YiI
         dOHZbdQWqvp0Pfah2v/+PCCJe7t218O6mFrzIag8U+Vq4xBhBeap6dtelnPVwfz91bjw
         hlmy0qKRCXCORMdWjRA/4GE0yqCcysmexvnDdAwb385pwzE6RDkNFwp+4kNDv++M0ENe
         JWXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PuXIMDYTsEzEI4UhsZdMwE6aeyhFjCPDoQCmzh6YH3o=;
        b=MGeKL86jPpNbD/GScwSSXLAjj7XMQRgbknPRpyHutrRftVFqgt48iYJvOw7NRl21FA
         QiG/FVt/wA8cCzJouOBMGipEuyIWllNL9Xu7lUqHwplmuh/wnTYaiM9ms/bxya2B0LFL
         JwRZUl8BgcD2RyIUNGCn9gIDZMs9TbQEGejSwOgQ7gyo7fG7FP3x094bJwjn+ZxnDV9k
         JG3dY8K1El534vvjLomYvZJ250g3e2olKcRIOexHAffW41fsJbltyE5B7k4InE5hO+1/
         2/l9Aeus0Xvce3u7PPAXm9WRKbzI5WQWs8kGYL6dZvEuuoJBtH7upL5ZMhgSz3mBKoog
         m/MQ==
X-Gm-Message-State: AJIora+PV0bcM7d+yvSZcEQacFnguYPLwXtVlDG85SsUPyhyjknR+6tX
        SwTBKHSgjuXeQoNWI1qmjMz4dr5/RLs=
X-Google-Smtp-Source: AGRyM1t8LKotJskqrU/NswXAsKu+ZHQ2weZAQ/2YMkDGFacGQX1f8sJ9NH26DiTkDDbVTeW5UwOdxw==
X-Received: by 2002:a5d:6b43:0:b0:21d:7d01:b314 with SMTP id x3-20020a5d6b43000000b0021d7d01b314mr25127544wrw.357.1657659192085;
        Tue, 12 Jul 2022 13:53:12 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 04/27] skbuff: add SKBFL_DONT_ORPHAN flag
Date:   Tue, 12 Jul 2022 21:52:28 +0100
Message-Id: <c1dd557e091e21937baa088308770121017daa8c.1657643355.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657643355.git.asml.silence@gmail.com>
References: <cover.1657643355.git.asml.silence@gmail.com>
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
2.37.0

