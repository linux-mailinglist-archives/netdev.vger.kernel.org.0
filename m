Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB32E5E800B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIWQkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIWQk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:40:27 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D83719BE;
        Fri, 23 Sep 2022 09:40:26 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id g3so776661wrq.13;
        Fri, 23 Sep 2022 09:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=NLIYqCB5GFGbnjqA6dYmmqdLI8BuNFTVxSCPXONSBRc=;
        b=owDxYda7B4frXz3u0Fwc1/mPY0PkIoc9YEt4hkPPANfeq4CAFBjXeUytt806Zgzrh2
         Oflmk3RWPGkL3H4Kqr+rh0g6ue3kNa5qh9EG2VFQ5SqjrD782ppbdaoa2zK8ufjpi3tg
         YpW05bXLXbqTGO0ZMSAueq+peDDRvbo8UVlb48ZmGp0vWAJpfOl00oTe17PDhCBXTmcj
         4LkSJcqD4FNFtW3MKLedobmMatlst3bdPyImM5Y1cg33OA2+GGukbR5y3KFMrsGkoqPe
         QYLUipMNRbiIvHjo0pc7wNIYe7Hj0Xd06Y+WNBvXMB+pfT+4vyFvrFYbZ+73u9ePpxWd
         LFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=NLIYqCB5GFGbnjqA6dYmmqdLI8BuNFTVxSCPXONSBRc=;
        b=diyoHVNJnMp+XooHEQKBmPjJK+sEvvY/rBAg8SaW8S8Og9OgT9mfzZgVoh60y47gQO
         C76du9I5y/tEPyX+AI7Nz9whFPjje4GzmB9XvUJWfc9nqCXav9Sp3W7jvbQTGsStxa4p
         N9g18WgKfBL3sy8cUCXbE4VgP9Mh2O2ihIwqx/IhPQuf9kddv/kMOr6/7fzbuyj/OG3A
         4Z1FpRDQPXxbmh6CDu9oY0U0LHapmxa9kFmZRQa78j2E7UQiTk57r3TGL+P9tbyh5jrb
         aX44WNq3+ySgGheetT7yGmIAIHRp9XRxFd7Q5m9V4zSQKwA5TshDrJEteK5VMv5LA3Ax
         Q3lg==
X-Gm-Message-State: ACrzQf3Hdry4p1zSDYSw+Kx/I3CL5AIDn5/YosDroVSC6RyV2zDUl1CM
        +ZiIkujqXoKR3KKNpLp6r54KIUnEbj8=
X-Google-Smtp-Source: AMsMyM5HMaxWgOxUGbCzg/XjKD/kmOOlcN0KKz9OmaE/RAZn/7aZ8z59Qz72lGSep1WOF16x4j6q2w==
X-Received: by 2002:a5d:5c06:0:b0:22a:7b52:cda6 with SMTP id cc6-20020a5d5c06000000b0022a7b52cda6mr5635717wrb.485.1663951224622;
        Fri, 23 Sep 2022 09:40:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.201.74.threembb.co.uk. [188.28.201.74])
        by smtp.gmail.com with ESMTPSA id x13-20020a5d60cd000000b0022af6c93340sm7717399wrt.17.2022.09.23.09.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:40:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 2/4] xen/netback: use struct ubuf_info_msgzc
Date:   Fri, 23 Sep 2022 17:39:02 +0100
Message-Id: <5e00bc6d4d8c3fdcf3ed02549ba8a36d5552e56c.1663892211.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663892211.git.asml.silence@gmail.com>
References: <cover.1663892211.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ubuf_info will be changed, use ubuf_info_msgzc instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/xen-netback/common.h    | 2 +-
 drivers/net/xen-netback/interface.c | 4 ++--
 drivers/net/xen-netback/netback.c   | 7 ++++---
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 8174d7b2966c..1545cbee77a4 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -62,7 +62,7 @@ struct pending_tx_info {
 	 * ubuf_to_vif is a helper which finds the struct xenvif from a pointer
 	 * to this field.
 	 */
-	struct ubuf_info callback_struct;
+	struct ubuf_info_msgzc callback_struct;
 };
 
 #define XEN_NETIF_TX_RING_SIZE __CONST_RING_SIZE(xen_netif_tx, XEN_PAGE_SIZE)
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index fb32ae82d9b0..e579ecd40b74 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -591,8 +591,8 @@ int xenvif_init_queue(struct xenvif_queue *queue)
 	}
 
 	for (i = 0; i < MAX_PENDING_REQS; i++) {
-		queue->pending_tx_info[i].callback_struct = (struct ubuf_info)
-			{ .callback = xenvif_zerocopy_callback,
+		queue->pending_tx_info[i].callback_struct = (struct ubuf_info_msgzc)
+			{ { .callback = xenvif_zerocopy_callback },
 			  { { .ctx = NULL,
 			      .desc = i } } };
 		queue->grant_tx_handle[i] = NETBACK_INVALID_HANDLE;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index a256695fc89e..3d2081bbbc86 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -133,7 +133,7 @@ static inline unsigned long idx_to_kaddr(struct xenvif_queue *queue,
 
 /* Find the containing VIF's structure from a pointer in pending_tx_info array
  */
-static inline struct xenvif_queue *ubuf_to_queue(const struct ubuf_info *ubuf)
+static inline struct xenvif_queue *ubuf_to_queue(const struct ubuf_info_msgzc *ubuf)
 {
 	u16 pending_idx = ubuf->desc;
 	struct pending_tx_info *temp =
@@ -1228,11 +1228,12 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 	return work_done;
 }
 
-void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf,
+void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf_base,
 			      bool zerocopy_success)
 {
 	unsigned long flags;
 	pending_ring_idx_t index;
+	struct ubuf_info_msgzc *ubuf = uarg_to_msgzc(ubuf_base);
 	struct xenvif_queue *queue = ubuf_to_queue(ubuf);
 
 	/* This is the only place where we grab this lock, to protect callbacks
@@ -1241,7 +1242,7 @@ void xenvif_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *ubuf,
 	spin_lock_irqsave(&queue->callback_lock, flags);
 	do {
 		u16 pending_idx = ubuf->desc;
-		ubuf = (struct ubuf_info *) ubuf->ctx;
+		ubuf = (struct ubuf_info_msgzc *) ubuf->ctx;
 		BUG_ON(queue->dealloc_prod - queue->dealloc_cons >=
 			MAX_PENDING_REQS);
 		index = pending_index(queue->dealloc_prod);
-- 
2.37.2

