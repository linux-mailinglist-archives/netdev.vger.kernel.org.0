Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BE356A161
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbiGGLxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbiGGLww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:52 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34235725A;
        Thu,  7 Jul 2022 04:52:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a5so11266915wrx.12;
        Thu, 07 Jul 2022 04:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hdUqBQRL0M8k3/ERJQ8Tpj8kF4Bki9R+wj8zDNk4L4U=;
        b=CHqpDq7PFolUPTrHXiliVGpHvg84HNgoCSpt3X5917qZvoibQp6mpo9tW0rnC/XfA1
         6c8wMwfXI9kago0piOD8B8edJ4/BjGgIH69n1xgc7NuMISMUXFGpXgA3ztgPQlZbRUOn
         GQ/JcYtlO57iVNqKyTazWMsMNSYBSlH7Oc20sfl7ynZDCDPixpj5DuYvZE7eSok6OnE2
         7XdREWZpqCDFN/4k6v3kLCsOZjo4jLky/Ku1UkWKOeEu1mkBao5g12yyW0pQS1jh0kzr
         1EXjw2X3vt7sitctPy+enDMeF6Z9tB0tEt4LIyYbvY1WyanMI9cPCR7+a0dfbDWxy05c
         e6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hdUqBQRL0M8k3/ERJQ8Tpj8kF4Bki9R+wj8zDNk4L4U=;
        b=FekPAN70Vo0gE3AYxoxxoAC9RGpWk65uCtoXQMElItI0qLFsFAQWRv2H34qcjMk/Nl
         Jjv9AJ4gmgv8EPbCx9C2+ihN8HQp66JtZSR3iMOSHLCxFEjylp80bXD78DGU5uoTzit3
         a5i5WKkXrG4L/iyi2Oaucy4XGVjyfH1QJAnc7dPLOl85CavQBaRlv0cLR5IzvXCmlJdO
         ul5m2UdxO0zJCV3LJAbR66rJ9U75LI3Et0IPLjQJq2CcGt+a5hn/VXZuHVvgfIFc6x0B
         3CkD9IIoMHs1QgCyjEvyctZxbb67+rqI/fETc0hmv8sX11WsVZiK2QYdrp1Lsgn2MKnW
         qx7w==
X-Gm-Message-State: AJIora/0ujyNK02X89GQZUpTYs71ythfMSMrH7XjnQRAMwVRbTV4gXbV
        rnIAyGAQCsP9ghYguzhzGcg+zwsCbKQxggB9fPA=
X-Google-Smtp-Source: AGRyM1sDgBrksV2wP21F4DQYtpBSViC4H9NXhwp+0PZA8OMBIpGC6vbzcyfmRD90WXrCPAgd0c4vsg==
X-Received: by 2002:adf:d1ea:0:b0:21b:a6cb:fcf6 with SMTP id g10-20020adfd1ea000000b0021ba6cbfcf6mr42348139wrd.477.1657194736776;
        Thu, 07 Jul 2022 04:52:16 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 26/27] io_uring: enable managed frags with register buffers
Date:   Thu,  7 Jul 2022 12:49:57 +0100
Message-Id: <c5d9fb8e0c6d651bc4809abafe3d53288b7de200.1657194434.git.asml.silence@gmail.com>
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
2.36.1

