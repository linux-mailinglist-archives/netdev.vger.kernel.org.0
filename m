Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C6358EFA4
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiHJPvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiHJPvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B8349B60;
        Wed, 10 Aug 2022 08:51:39 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z12so18222301wrs.9;
        Wed, 10 Aug 2022 08:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=mveucMTZdZPLlN4D5K1kqfZw5UNWDwp9Ns7O7VRFK+I=;
        b=FeHdakLvXxtWgjpPF+aflE98THue/ZKUpEuSPYY/vwKS6pLky2/FycS8L1DaAOP7p2
         gbmwq+ySuj1nbkojJhrktc86MeoeDdNZHmrmEXeui4TvX9dWZtL5o1pn/n2SFPu2UKqJ
         LwG8Bt1+6Z9HVd12TbOjrwFHHO7Xbx+0NZ4knAvVP00VnvWpTA1vdoX8qFWZUEU1a0Hc
         WTzV9hRGh/acAWBr/K4D/fYN2WXLMaChMzaEobWBKN01dp0GD77rhc2rXo7Zw1Rse8vI
         EoYL8E2KpOU5sN0NjoXacILSTjNTJslWSxRKaYX/is4eawuPkbRaWRlUK6vsWA5Q252i
         fHCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=mveucMTZdZPLlN4D5K1kqfZw5UNWDwp9Ns7O7VRFK+I=;
        b=VEJoyOrdLQBPaiK440vKvKQmYJQZF1w3S1FoRCeD0gVrFfwZfWOBqtEY2hYwzg4NkJ
         Xx5pj3Dzp8i3vpjdmqQE9JoE2PQX37BVb7tnI96hrFCIvtqjCUOQvZfiV1fJOLoCkHIZ
         ImlOjofUB33KtvWVYkiiDaWT6RTEYcMcaOJpHYnzufh3xb1orTfrxPWtp4Mjf1ZpCt97
         3o23hZvZpwVJKPoQ9/tQsF7s5MwlvgKaA0k4HuipYXDyP98uf4C/0j5gaWGgfC8O2684
         vNvxyXRlvp9Ob1i5nsgv1ekzSO+CCtVFWBTqkklDP67eqYa1Djy+n/PzSxa2pdRW3Sz6
         9aYQ==
X-Gm-Message-State: ACgBeo3Bi4n6B4w3tWe7h4HZ9hId0z23fBeDjuDtGKTM9w/nJ0/6xyK3
        Iz2Beuv8R8OWYXfg7dF6Wx31QtWH9Ts=
X-Google-Smtp-Source: AA6agR6IVj+Term37QFPdVaJx8duP8zGzs+p0efJL76vLIQCk5ivpP0E95/E2mMnqsqquEDgBKZAtg==
X-Received: by 2002:a05:6000:3c6:b0:220:5efd:423c with SMTP id b6-20020a05600003c600b002205efd423cmr18135634wrg.214.1660146697602;
        Wed, 10 Aug 2022 08:51:37 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:37 -0700 (PDT)
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
Subject: [RFC net-next io_uring 01/11] net: introduce struct ubuf_info_msgzc
Date:   Wed, 10 Aug 2022 16:49:09 +0100
Message-Id: <d43f3ed1cb75c5572c1fc3bb32f2bb47c682da93.1660124059.git.asml.silence@gmail.com>
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

We're going to split struct ubuf_info and leave there only
mandatory fields. Users are free to extend it. Add struct
ubuf_info_msgzc, which will be an extended version for MSG_ZEROCOPY and
some other users. It duplicates of struct ubuf_info for now and will be
removed in a couple of patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ca8afa382bf2..f8ac3678dab8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -554,7 +554,28 @@ struct ubuf_info {
 	} mmp;
 };
 
+struct ubuf_info_msgzc {
+	struct ubuf_info ubuf;
+
+	union {
+		struct {
+			unsigned long desc;
+			void *ctx;
+		};
+		struct {
+			u32 id;
+			u16 len;
+			u16 zerocopy:1;
+			u32 bytelen;
+		};
+	};
+
+	struct mmpin mmp;
+};
+
 #define skb_uarg(SKB)	((struct ubuf_info *)(skb_shinfo(SKB)->destructor_arg))
+#define uarg_to_msgzc(ubuf_ptr)	container_of((ubuf_ptr), struct ubuf_info_msgzc, \
+					     ubuf)
 
 int mm_account_pinned_pages(struct mmpin *mmp, size_t size);
 void mm_unaccount_pinned_pages(struct mmpin *mmp);
-- 
2.37.0

