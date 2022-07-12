Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84FF557281F
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiGLUzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiGLUyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:54:02 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B4FC4A;
        Tue, 12 Jul 2022 13:53:31 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n185so5401730wmn.4;
        Tue, 12 Jul 2022 13:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mddxqgnN1yh+xxOhPWC4dQqQBxAtQdPRnybH+6hTMsI=;
        b=Yb1tXPVjRfgzdWZkwJhHv7IHoK2pniKpmYyzXJCC+3KYJEq2cuoV7UXCJchFoA30+P
         lLynJbO9bUw3ETkyGi1t6buNFlme7ETGozCcdUVMwnrtfuiWGdnrlj0D2wgRhrY6ooAz
         7iU6S9XyUZPN/oAjY135mt/+yBmi9PD0JqxWxH+Z+Uyc4UybXI9tcEgDCZFzXdZBZDd1
         QSQ54k9Ru5TqYlGHdxMHbUXTIRluGa5BgRzayu5Vp+tubp47fIhSi8WJU72nXWXSYAvT
         xgtBZzLvYz5JQnM87SEt2jpDW1aq/haRR3Q5Wxmdqt5Zbm/G4KUEssLdOurr5EbdSZPV
         5Vmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mddxqgnN1yh+xxOhPWC4dQqQBxAtQdPRnybH+6hTMsI=;
        b=UFDesXCawAP10MNo+K2XsP1N5cCzHBpX4SlaIZWbmM/bQsmvYXC3cy7o43onfxNSb6
         xszDEK+jHnLMz3jNp2H+ChNPj73+FzaozgrZWmdkQVtAUxt/rmHzyqkeQQL8QfCnG1SW
         jAzWcq8UfUNVSoneb+tme7ZZOkyoW+5x3UIu0vw8MMe3j+1eJbzOe8K0sa5T1w5jjERJ
         t8aiW8Cev0bKM320gZIOgvxCRv7Gna97FEY1PliHLmqkalv0wtMiMsGW+hN1nZ8UplUY
         ObJYIQZe2o1TKEk8QvMwibQF1ahy2CH1k7ifEwjieumrsmw+sHBIAA7dT5J2t3TL57y/
         aQDw==
X-Gm-Message-State: AJIora/IxD2FpV6rHNgUp1rTfb+F6U0CsnwQ/hgreUSLK+klgZq/RQEE
        DRx1hf7kTogrc22eQV+wuzJaPG/hn1s=
X-Google-Smtp-Source: AGRyM1uBx/j0OyBwsle4ybJkRt3ODr/BAjbZIaGy2igf4h9B7g3gPW2OkHjJO71FlbD1KRdfAiTfzg==
X-Received: by 2002:a05:600c:4e16:b0:3a2:ef34:dbe3 with SMTP id b22-20020a05600c4e1600b003a2ef34dbe3mr4825412wmq.71.1657659209185;
        Tue, 12 Jul 2022 13:53:29 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 18/27] io_uring: add notification slot registration
Date:   Tue, 12 Jul 2022 21:52:42 +0100
Message-Id: <a0aa8161fe3ebb2a4cc6e5dbd0cffb96e6881cf5.1657643355.git.asml.silence@gmail.com>
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

Let the userspace to register and unregister notification slots.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 17 ++++++++++++++
 io_uring/io_uring.c           |  9 ++++++++
 io_uring/notif.c              | 43 +++++++++++++++++++++++++++++++++++
 io_uring/notif.h              |  3 +++
 4 files changed, 72 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e858dba2e6c9..f1ba8e934168 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -454,6 +454,10 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* zerocopy notification API */
+	IORING_REGISTER_NOTIFIERS		= 26,
+	IORING_UNREGISTER_NOTIFIERS		= 27,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -500,6 +504,19 @@ struct io_uring_rsrc_update2 {
 	__u32 resv2;
 };
 
+struct io_uring_notification_slot {
+	__u64 tag;
+	__u64 resv[3];
+};
+
+struct io_uring_notification_register {
+	__u32 nr_slots;
+	__u32 resv;
+	__u64 resv2;
+	__u64 data;
+	__u64 resv3;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index bdc5a2839d94..41ef98a43d32 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3875,6 +3875,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_NOTIFIERS:
+		ret = io_notif_register(ctx, arg, nr_args);
+		break;
+	case IORING_UNREGISTER_NOTIFIERS:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_notif_unregister(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 0a2e98bd74f6..e6d98dc208c7 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -162,5 +162,48 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
 	kvfree(ctx->notif_slots);
 	ctx->notif_slots = NULL;
 	ctx->nr_notif_slots = 0;
+	io_notif_cache_purge(ctx);
+	return 0;
+}
+
+__cold int io_notif_register(struct io_ring_ctx *ctx,
+			     void __user *arg, unsigned int size)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_uring_notification_slot __user *slots;
+	struct io_uring_notification_slot slot;
+	struct io_uring_notification_register reg;
+	unsigned i;
+
+	if (ctx->nr_notif_slots)
+		return -EBUSY;
+	if (size != sizeof(reg))
+		return -EINVAL;
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (!reg.nr_slots || reg.nr_slots > IORING_MAX_NOTIF_SLOTS)
+		return -EINVAL;
+	if (reg.resv || reg.resv2 || reg.resv3)
+		return -EINVAL;
+
+	slots = u64_to_user_ptr(reg.data);
+	ctx->notif_slots = kvcalloc(reg.nr_slots, sizeof(ctx->notif_slots[0]),
+				GFP_KERNEL_ACCOUNT);
+	if (!ctx->notif_slots)
+		return -ENOMEM;
+
+	for (i = 0; i < reg.nr_slots; i++, ctx->nr_notif_slots++) {
+		struct io_notif_slot *notif_slot = &ctx->notif_slots[i];
+
+		if (copy_from_user(&slot, &slots[i], sizeof(slot))) {
+			io_notif_unregister(ctx);
+			return -EFAULT;
+		}
+		if (slot.resv[0] | slot.resv[1] | slot.resv[2]) {
+			io_notif_unregister(ctx);
+			return -EINVAL;
+		}
+		notif_slot->tag = slot.tag;
+	}
 	return 0;
 }
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 1dd48efb7744..00efe164bdc4 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -6,6 +6,7 @@
 #include <linux/nospec.h>
 
 #define IO_NOTIF_SPLICE_BATCH	32
+#define IORING_MAX_NOTIF_SLOTS (1U << 10)
 
 struct io_notif {
 	struct ubuf_info	uarg;
@@ -48,6 +49,8 @@ struct io_notif_slot {
 	u32			seq;
 };
 
+int io_notif_register(struct io_ring_ctx *ctx,
+		      void __user *arg, unsigned int size);
 int io_notif_unregister(struct io_ring_ctx *ctx);
 void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
-- 
2.37.0

