Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58765671C4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbiGEPCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231917AbiGEPB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:01:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE71315A06;
        Tue,  5 Jul 2022 08:01:54 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id c131-20020a1c3589000000b003a19b2bce36so4304528wma.4;
        Tue, 05 Jul 2022 08:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mNAl7aHtaBa/r+OrmETRXcPT/IbWKen65cbhqfyTMuk=;
        b=QIyJpbFm4K9zyHmtH9uiaoaO0dVKXXutkbT93MI7Aq3iCVG2ljN3+ePEIY2svBMUE2
         yftHamAuWuQvysHJMim9F1bKKeoKDDe0jo4y5Um+20UmdHpsaRqqVUeGVx9MAQ084omx
         zXho48b4/txDxxSnNc7zUN3w8dfqE2st7rxRaoeKXdKNYItOV9Vr2XFatEezzsQCVn8J
         5/V9ImdqnEtCpbjHyHsZ4oOieMH+NxwB9KPBDhfQ067uQ2eMTAVidQ558eObfcwVvEsH
         HKGCCPG0pOIlUPRfmc1UiiQC8Eov9ADvp9aII5n1QIuBwj+0YdnJ7OpeBE4O2ZTOJMQd
         MVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mNAl7aHtaBa/r+OrmETRXcPT/IbWKen65cbhqfyTMuk=;
        b=WJa0CXR8fDYKHbD1AT4/8qCvprYkqA1DapYzW00gCpcPphxBYBcO86LcCU3wul81Jn
         I44Ivbt9jHIfm9qRoDF7LTznUWKt49PtoPJDyYGfa4Za0M8KirbWX2h+mh+tx8sWXj5E
         p2q+N+Phm7QzxopjDVguymOpjXp8Y3bR02jzhYa85pLZBBT0U5pGq5OMWJwhwVnLTwYq
         SDFkp8wtbLS8fjGwj+9GX0y+0pm8JPbMLGn/wezM/fhnwqmCKKUHuFWOBh8gr8h5seWl
         jNpkLwCr3R8N7Yrktm10oZ6LEhwEj/3jSG7fzImSjVXU/6u1jFg5oN2PF/4snAJHRboU
         gC6A==
X-Gm-Message-State: AJIora89X9O4QCFwF258ofwcEP5M3a1zK9rRPZFrz8lhz+veNo4l9MSE
        FAV6kGCTTTfydRUrH/TFETIS9yFsmp+pGQ==
X-Google-Smtp-Source: AGRyM1t+FRcbfBXNkFqqNHfWVbAfizNxyQZmmszAH48Uv7YGgDS0ifHmhMNNBh/9yrg+A+eG21iXrQ==
X-Received: by 2002:a7b:ce04:0:b0:3a1:92e0:d889 with SMTP id m4-20020a7bce04000000b003a192e0d889mr20351544wmc.131.1657033313017;
        Tue, 05 Jul 2022 08:01:53 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:01:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 05/25] net: bvec specific path in zerocopy_sg_from_iter
Date:   Tue,  5 Jul 2022 16:01:05 +0100
Message-Id: <4d0050583906d5fc4db710019995fb76805c9b05.1656318994.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656318994.git.asml.silence@gmail.com>
References: <cover.1656318994.git.asml.silence@gmail.com>
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

Add an bvec specialised and optimised path in zerocopy_sg_from_iter.
It'll be used later for {get,put}_page() optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/datagram.c | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 50f4faeea76c..5237cb533bb4 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -613,11 +613,58 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter);
 
+static int __zerocopy_sg_from_bvec(struct sock *sk, struct sk_buff *skb,
+				   struct iov_iter *from, size_t length)
+{
+	int frag = skb_shinfo(skb)->nr_frags;
+	int ret = 0;
+	struct bvec_iter bi;
+	ssize_t copied = 0;
+	unsigned long truesize = 0;
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
+		get_page(v.bv_page);
+		skb_fill_page_desc(skb, frag++, v.bv_page, v.bv_offset, v.bv_len);
+		bvec_iter_advance_single(from->bvec, &bi, v.bv_len);
+	}
+	if (bi.bi_size)
+		ret = -EMSGSIZE;
+
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
 int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 			    struct iov_iter *from, size_t length)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
 
+	if (iov_iter_is_bvec(from))
+		return __zerocopy_sg_from_bvec(sk, skb, from, length);
+
 	while (length && iov_iter_count(from)) {
 		struct page *pages[MAX_SKB_FRAGS];
 		struct page *last_head = NULL;
-- 
2.36.1

