Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AC5671D7
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiGEPED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbiGEPC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:29 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97A217ABE;
        Tue,  5 Jul 2022 08:02:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a5so3274966wrx.12;
        Tue, 05 Jul 2022 08:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D4NntIuJV34ug7A0X+amA/c6OF0AjApfUu1QUoGOdxk=;
        b=jGy8WpkxOtJxnq6C8b4FOZNH5T5316NoemiAURQDzXiFOaBdSo7638YunIA0+m9MtU
         x0aX7HnPdngWryxbz87mGzzi0M3FDDjZ6X7ZyxXpaxDjqljPwHxxuyeESLgmaDlrP9TQ
         VbtlfesDi9rNlwDjbdOj20Y0a6nHFcbGzmzmuV9QhdFSTkm296gD+mLJno6wMA4iowu7
         bXEQAm1rSPel5Wxd4QfhKM1LgF9oBeObQCJcyFcZSqaf9hpPXOG+CXDvEdQZ1/J1+/5P
         hzlPhQebXBBZMRA8you34HD7M05/vrAlLya8+n4uFnYX0KCmRhCuSPbBrvUkj/hS+bmc
         GFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D4NntIuJV34ug7A0X+amA/c6OF0AjApfUu1QUoGOdxk=;
        b=LCqYLWjJWgHICFn3m8eFz7Iwi7Ylm1dZSvW01+FCYoweKREGcFXkik5T2zCnqN3DmX
         kZNcrNYkzVaUhhSuf7hTRhLdhYr4gZnSbGkIqM+7n7IrQU1TJ/hCNL2O5FffxJn2f1E9
         4rFYqm/CN/4HvuLpDTTIZBBuKNtYp7IwjNAR2H0ox283pR48P+wGqxcbEcjpisKlqMEX
         Crpx4CxJYYKuhYMLP1fJhd7Uzzruca8ohfxAqMr5y78I9QdZmVpr0lJvcjXUWF7eysFT
         DzOMbEbJYO8WHtb4aYmCblpkB/xR6aHCr7w+BI5/MruL+iPCVOoEDZVIFy6cRf4Jq6Iq
         099g==
X-Gm-Message-State: AJIora+NoA59MqI7Z5JKbm1P9PFyhe8/aPYESstJ+VnsXGuX90+VSMmF
        L8SltL6nrxH0LyQLgCRptotPPTTlvoZIkw==
X-Google-Smtp-Source: AGRyM1snF9sXVTxhArnz8el+v03a7lEqk2AVfQ3aQrqUG7aZy57Tdt5L21QLyN2D4XQU4MOPfxEJmQ==
X-Received: by 2002:adf:f78d:0:b0:21d:6e79:88a2 with SMTP id q13-20020adff78d000000b0021d6e7988a2mr6706112wrp.493.1657033327404;
        Tue, 05 Jul 2022 08:02:07 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 16/25] io_uring: add notification slot registration
Date:   Tue,  5 Jul 2022 16:01:16 +0100
Message-Id: <21830bd164c444b21f6ba8b672311fb245efe752.1656318994.git.asml.silence@gmail.com>
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

Let the userspace to register and unregister notification slots.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 17 ++++++++++++++
 io_uring/io_uring.c           |  9 ++++++++
 io_uring/notif.c              | 43 +++++++++++++++++++++++++++++++++++
 io_uring/notif.h              |  3 +++
 4 files changed, 72 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 09e7c3b13d2d..9b7ea3e1018f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -429,6 +429,10 @@ enum {
 	/* sync cancelation API */
 	IORING_REGISTER_SYNC_CANCEL		= 24,
 
+	/* zerocopy notification API */
+	IORING_REGISTER_NOTIFIERS		= 25,
+	IORING_UNREGISTER_NOTIFIERS		= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST
 };
@@ -475,6 +479,19 @@ struct io_uring_rsrc_update2 {
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
index 6054e71e6ade..3b885d65e569 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3862,6 +3862,15 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_sync_cancel(ctx, arg);
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
index f795e820de56..2e9329f97d2c 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -157,5 +157,48 @@ __cold int io_notif_unregister(struct io_ring_ctx *ctx)
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
index 23ca7620fff9..6dde39c6afbe 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -6,6 +6,7 @@
 #include <linux/nospec.h>
 
 #define IO_NOTIF_SPLICE_BATCH	32
+#define IORING_MAX_NOTIF_SLOTS (1U << 10)
 
 struct io_notif {
 	struct ubuf_info	uarg;
@@ -47,6 +48,8 @@ struct io_notif_slot {
 	u32			seq;
 };
 
+int io_notif_register(struct io_ring_ctx *ctx,
+		      void __user *arg, unsigned int size);
 int io_notif_unregister(struct io_ring_ctx *ctx);
 void io_notif_cache_purge(struct io_ring_ctx *ctx);
 
-- 
2.36.1

