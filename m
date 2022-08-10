Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F6658EFB0
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiHJPwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiHJPvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:55 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAADD51407;
        Wed, 10 Aug 2022 08:51:45 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v131-20020a1cac89000000b003a4bb3f786bso1236841wme.0;
        Wed, 10 Aug 2022 08:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=aYyDEkTXwWBCvoGHlIPqb+/BxSLKuFl8ndVR481kS1w=;
        b=hZ9U5hOp4VB5FaNjAUnUraKpOCA2Wpyj5HNp6Hhmv23m66TTZRgMWtl/dQOYhFz/E9
         36lXEdGbdo0OOYp9ub05DxHU0JI2ixvQfkVCuWQmznlpIUTvzJs+XnGqaJ2CMBu+LqhP
         BnPg0B38v5clDnOrD+9TKJLttKJu9NRZchU1iQUWn8KW95x2YDQFqqAhiIbkPwedVKlK
         NGR7PWWBnUvj5HLI2Nv9zCRnQk5F7LOPjdp0zI7zbkzXr3sK9gOJiNthyiUh1Y08msvy
         8rfhtGaZQIdqI/4wm9WgW+yQdrbS+/dsw22V6yBOrwzgjM4RRxcF9hYdLnEirsOA1u+p
         JGmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=aYyDEkTXwWBCvoGHlIPqb+/BxSLKuFl8ndVR481kS1w=;
        b=QBns0V45GWQUMi1ZmaGEx8Y6fb0wUQ0OWtC7jbFynvW4jijhJwIiojXybTQHMTbvJK
         BEzqN8FFKpC4Zfjqz8wcCGKajYk7Ye9/6V9jdGn98kqVHmufM7CMgI26vOknJf6KB3ZK
         4tLSC/7sesifMWuy7M+UyFrTezQtZhXaKX6YeNDNzP4VnvVNdZgQlhRfZjGmx0WtF0gU
         Ex7jzEVmbN+TOZRyPwW4yXqDv//z09OMLheSUvqoNq26wOTK6Tp91Hc0obOYFeokMsO9
         dvoInxYi6iVPONmhCuJGzdc/ThVCLapPdij2h0ovPS3/0R8aEIMdfMYDYWXDg7lVrtjt
         Y4lA==
X-Gm-Message-State: ACgBeo0JDZ4ZzFuD3rcqQhJjshQuRlf0NKqWv+xJMhfVC4rGTxKlIMil
        oVfNns6OzFdI6cGLNNKm/a/sylMtxDY=
X-Google-Smtp-Source: AA6agR4pIC1FSo3wRp5p1MAJqhHvgQE9nDnk6Uk00rTTOcb22zy1nLrULEj+sKAA+/DezVNGQLcv4Q==
X-Received: by 2002:a05:600c:1e8d:b0:3a5:74d:c61c with SMTP id be13-20020a05600c1e8d00b003a5074dc61cmr2953296wmb.70.1660146703329;
        Wed, 10 Aug 2022 08:51:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC net-next io_uring 05/11] net: rename ubuf_info's flags
Date:   Wed, 10 Aug 2022 16:49:13 +0100
Message-Id: <7d43d8dd1c7e7c9964d40202482f325ecd06642b.1660124059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1660124059.git.asml.silence@gmail.com>
References: <cover.1660124059.git.asml.silence@gmail.com>
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

ubuf_info::flags contains SKBFL_* flags that we copy into skbs, change
the field name to stress that it keeps skb flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 4 ++--
 io_uring/notif.c       | 2 +-
 net/core/skbuff.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index afd7400d7f62..e749b5d3868d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -534,7 +534,7 @@ struct ubuf_info {
 	void (*callback)(struct sk_buff *, struct ubuf_info *,
 			 bool zerocopy_success);
 	refcount_t refcnt;
-	u8 flags;
+	u8 skb_flags;
 };
 
 struct ubuf_info_msgzc {
@@ -1664,7 +1664,7 @@ static inline void net_zcopy_get(struct ubuf_info *uarg)
 static inline void skb_zcopy_init(struct sk_buff *skb, struct ubuf_info *uarg)
 {
 	skb_shinfo(skb)->destructor_arg = uarg;
-	skb_shinfo(skb)->flags |= uarg->flags;
+	skb_shinfo(skb)->flags |= uarg->skb_flags;
 }
 
 static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
diff --git a/io_uring/notif.c b/io_uring/notif.c
index b5f989dff9de..97cb4a7e8849 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -65,7 +65,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
 
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
-	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	nd->uarg.skb_flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&nd->uarg.refcnt, 1);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index b047a773acd7..40bb84986800 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1206,7 +1206,7 @@ static struct ubuf_info *msg_zerocopy_alloc(struct sock *sk, size_t size)
 	uarg->len = 1;
 	uarg->bytelen = size;
 	uarg->zerocopy = 1;
-	uarg->ubuf.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
+	uarg->ubuf.skb_flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	refcount_set(&uarg->ubuf.refcnt, 1);
 	sock_hold(sk);
 
-- 
2.37.0

