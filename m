Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A5B572808
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiGLU4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbiGLUyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:55 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2E72ED52;
        Tue, 12 Jul 2022 13:53:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b26so12831567wrc.2;
        Tue, 12 Jul 2022 13:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WExwuGiqZIBx1fmX1iBGP3JMT2QbBuC/oWcmMGulQEg=;
        b=AR1tcfKYxhwttlnwbEu04QtHHvFEwA8d6fTwm8XkFzi/3Skk2t67yWkd539d0tBtOg
         eUBF9HhPWXwa5aJyj6lJl75cbOLHT8evfHscEvlH5D8iFJErYCZUvl3NFVVEgccRXboK
         I9U3YW74wdBrCHMgnJ3M6E9p09tuXoZjeE6GhkKnnUI8U/yMNjVxbszzDsOG6fXLmpAG
         2ioGMJFPqz1uxUxQZLa0GsCZnJQusg7jKmk/tt9N4Kw5JoyYgUdEdG3TmlRI/QUt80M3
         /9YxMGdZSvS+u587xf+O2jsirphJ5whxgTaM0uFlLh4gfeOI35K2kMu2wu79/Jy9Lla8
         tgUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WExwuGiqZIBx1fmX1iBGP3JMT2QbBuC/oWcmMGulQEg=;
        b=6TWucY1DYrW1SNtUT5fILBNoGWe8UyBRxqIafMYzTUj+UDujkrGLAEXKwPBtm0Lxbi
         ZFZk5wM+PRDlX4Y2Y+YdXkTcXFneqd8APpdkz5O+huoAiZtTK8lIAJG7AiKM4TMtqYl3
         1HxIxfm0M29XlJR57b1QGF9fed0IFNHfHHGMVEaclL2ucmgqHV98D0XuVnqCjbdyZVF8
         D49m5mBvlc9Ynd1xDoi8TGHEVf2diZQ3RmvkbMirSvMJYe0zlZHeV08wZrlaknPDe0f5
         WF072+UzHQsUJU52Kfu41ypKcWsIoS22tl2euDxQ0z8gUnAHgJFVPcCluHPC1ApHZudv
         A5XA==
X-Gm-Message-State: AJIora8zErZoTzYGq0DZUqSVHJRZi2QQmGT5fkMMA6CgsEOHuPooGcxx
        TssfS1PrwIyMUxc4IoISBunV+iL0gXE=
X-Google-Smtp-Source: AGRyM1unJ1n2O0NPeI9UuP/QZRL5LZMj16HAQZczt097u1MFWD1uXx0tu81pUtVLOKUHy1uQupxduw==
X-Received: by 2002:a5d:64e8:0:b0:21d:b277:d4a7 with SMTP id g8-20020a5d64e8000000b0021db277d4a7mr5252670wri.621.1657659219223;
        Tue, 12 Jul 2022 13:53:39 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 26/27] io_uring: enable managed frags with register buffers
Date:   Tue, 12 Jul 2022 21:52:50 +0100
Message-Id: <278731d3f20caf346cfc025fbee0b4c9ee4ed751.1657643355.git.asml.silence@gmail.com>
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

io_uring's registered buffers infra has a good performant way of pinning
pages, so let's use SKBFL_MANAGED_FRAG_REFS when our requests are purely
register buffer backed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index bf9916d5e50c..a4e863dce7ec 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -704,6 +704,60 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
+			   struct iov_iter *from, size_t length)
+{
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int frag = shinfo->nr_frags;
+	int ret = 0;
+	struct bvec_iter bi;
+	ssize_t copied = 0;
+	unsigned long truesize = 0;
+
+	if (!shinfo->nr_frags)
+		shinfo->flags |= SKBFL_MANAGED_FRAG_REFS;
+
+	if (!skb_zcopy_managed(skb) || !iov_iter_is_bvec(from)) {
+		skb_zcopy_downgrade_managed(skb);
+		return __zerocopy_sg_from_iter(NULL, sk, skb, from, length);
+	}
+
+	bi.bi_size = min(from->count, length);
+	bi.bi_bvec_done = from->iov_offset;
+	bi.bi_idx = 0;
+
+	while (bi.bi_size && frag < MAX_SKB_FRAGS) {
+		struct bio_vec v = mp_bvec_iter_bvec(from->bvec, bi);
+
+		copied += v.bv_len;
+		truesize += PAGE_ALIGN(v.bv_len + v.bv_offset);
+		__skb_fill_page_desc_noacc(shinfo, frag++, v.bv_page,
+					   v.bv_offset, v.bv_len);
+		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
+	}
+	if (bi.bi_size)
+		ret = -EMSGSIZE;
+
+	shinfo->nr_frags = frag;
+	from->bvec += bi.bi_idx;
+	from->nr_segs -= bi.bi_idx;
+	from->count = bi.bi_size;
+	from->iov_offset = bi.bi_bvec_done;
+
+	skb->data_len += copied;
+	skb->len += copied;
+	skb->truesize += truesize;
+
+	if (sk && sk->sk_type == SOCK_STREAM) {
+		sk_wmem_queued_add(sk, truesize);
+		if (!skb_zcopy_pure(skb))
+			sk_mem_charge(sk, truesize);
+	} else {
+		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
+	}
+	return ret;
+}
+
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage address;
@@ -768,7 +822,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg.msg_flags = msg_flags;
 	msg.msg_ubuf = &notif->uarg;
-	msg.sg_from_iter = NULL;
+	msg.sg_from_iter = io_sg_from_iter;
 	ret = sock_sendmsg(sock, &msg);
 
 	if (unlikely(ret < min_ret)) {
-- 
2.37.0

