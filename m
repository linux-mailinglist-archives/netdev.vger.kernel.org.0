Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5997C58EFA6
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiHJPvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiHJPvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:51:42 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD724C617;
        Wed, 10 Aug 2022 08:51:40 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bv3so18211594wrb.5;
        Wed, 10 Aug 2022 08:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=RS63Hb0HKwQLj+yY8E+g8nWuxDYTXWs65j0+OKPH1OE=;
        b=ZQdOMbpO/VHyANe5mleak9CanXYG2CBuqoaXodVPqSxfN0jYX3Wpv/vcb6iubMBW1u
         4Ble+mSyTPc7xm8K/FN13yhEm7K3hDV1my/RtaOdys3+jH8lzdROVrs3yday1zidVe+x
         bMEKgzVG6yfs6m4/lp21crX1YCY0qdX1LO/SN3r1GTpQB97R7NYdjhtr4vcyw0X1MhlZ
         Rsr3NqzS5od350DfBp0/rWIgXTPVwoJA57tT5sN5ssmtZG7YNPmWvIuqmqqLbLD3mFiz
         LM3JoK9cwamnuJVbkAxMoi+VNXdtwhLPXE2PCWt/23HgKhwIUuswHMgcOCy1QLV1mNAn
         Xu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=RS63Hb0HKwQLj+yY8E+g8nWuxDYTXWs65j0+OKPH1OE=;
        b=X2vFMomXGDOwWZ+7D9vzD4/w+Cdz9e9ao4ouwVdY0iSrp454nW7gGRDMIaIIJnL0Zw
         DB19kKAhXYO5YD+GwCmu3IT+UiDhxR1t9nxhks+Gazino8z8qwGl5AX0LLn3HIsE38Ko
         WI019uls1D1ZZuLb2ENgtb1IuYs5D/I7NF5FT/C0K1PMP1DCi45WuECxM2JTUktlR/Ry
         4WUtk1zQ+PcxwQnkfeKLL5hN3xJI0pXDP+rEv84l0Y8Es9Uw5lXRxReIJhEqDJgxeBZ+
         6+eJZct4tJoVFAPIB3FafyqUdSWKuZpKFbCZXdfd41rauCidMJJPG3njtlkoem6OSlHX
         /rWg==
X-Gm-Message-State: ACgBeo1vNFjBUpYM3+sGv98bHJfQo5xses+P9BBJL39T+F52ZJCyee6Y
        cqLy69RCJReRNZU1NxfEDmIn90inKbw=
X-Google-Smtp-Source: AA6agR4m7a1ZpBafnXxHxc3Qgb+mIUi9eJAFTWTIHDXvxrcaOuXHorpWp86zCAS5S/bxu6e6MTh00Q==
X-Received: by 2002:a5d:64aa:0:b0:21e:be27:6dfb with SMTP id m10-20020a5d64aa000000b0021ebe276dfbmr18180217wrp.456.1660146698952;
        Wed, 10 Aug 2022 08:51:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id ay1-20020a05600c1e0100b003a342933727sm3004519wmb.3.2022.08.10.08.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 08:51:38 -0700 (PDT)
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
Subject: [RFC net-next io_uring 02/11] xen/netback: use struct ubuf_info_msgzc
Date:   Wed, 10 Aug 2022 16:49:10 +0100
Message-Id: <9d13d0d17d672ce55a3d5cfd06d5c521270a7d4d.1660124059.git.asml.silence@gmail.com>
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
2.37.0

