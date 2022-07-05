Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D5D567208
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiGEPE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiGEPDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:03:00 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2724183AA;
        Tue,  5 Jul 2022 08:02:18 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id f190so7204162wma.5;
        Tue, 05 Jul 2022 08:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X9c0BvKViP3ldUZ7qslOympJ4LcsRat6WwWwcKSD/go=;
        b=QwnwG1bdlC6DRcRsAGYm3vIwKJpfHOQ0fxjA1/DgK51yBmPaauAmQs5XjjmLuQP6lh
         RvHLFn0/7oOyThXmyLBlv4gNOSU6KjEsQ7m8GwTa44IH5JKrYx/9kOMRRfn3+DDMDPiG
         cMMK+qOFqXlKTK5pVh+G6zCJBzAx0gOrMYOqubsCWp1hI0LvWWMUNtvu1Oj9wxq4P/c3
         tKSnsUCxP9mRnIt8C+66nAQHmL+6X9uFmTt2EWWujO2KQuGIN5fvJ7Cou0v0U7Wy7VAK
         KlAy2v1RaHJAhL+6e/iaQvybKQpaNn7goRjWhEMyFbrEipxy7T+/ZizVihgAR8NXc/84
         dMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X9c0BvKViP3ldUZ7qslOympJ4LcsRat6WwWwcKSD/go=;
        b=zSRujog39/q+oGbfi9N8l9JmfwQwB167sJIZIesBj2WDspq9yD1lWLQy01jC7LYZoA
         9FaGtaISsonGiPxPFK+lfSl5QzwPZw9zL7jbNfOlIoYXFcAFoz3mi1wUYqM0H7Ay+GDS
         WDGgDJ/Qd0X2p62ahihjEjtoyxPmTYYampwyc2xh2++h8XeST3sus2toKmClZXqqKn29
         6vCZ9dBx7MvD318n3Tj7SZ7L20bRsS5gX9kBScONpu2warMW7wSGGBBuaPojmS1dVNIs
         1+6SqsEMl70gwMi+gtYEW88mx0vLhYPSiUDQV810gKtah9WAXZOGdIFTF9Hw2jrNkl0F
         BxyQ==
X-Gm-Message-State: AJIora99RbjyXtRikL0dhuKc6MS6HSQBsgzr8YgVuPvUbC7nYgg42/1p
        XrdeYpMVlN4C/6ZlZsM3ynvh2/vbi6QqEg==
X-Google-Smtp-Source: AGRyM1tPrNLSIuUHE0Tt8KKXOeaHkqjoKSKYypCeQNDCBUCcMuv5dgzTEl4ov/gYESA52xM770VHWg==
X-Received: by 2002:a05:600c:a4c:b0:39c:6517:1136 with SMTP id c12-20020a05600c0a4c00b0039c65171136mr37100230wmq.12.1657033337857;
        Tue, 05 Jul 2022 08:02:17 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 24/25] io_uring: add zc notification flush requests
Date:   Tue,  5 Jul 2022 16:01:24 +0100
Message-Id: <36e4a90c33718fa1ca634d5fb0352ef7177462d4.1656318994.git.asml.silence@gmail.com>
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

Overlay notification control onto IORING_OP_RSRC_UPDATE (former
IORING_OP_FILES_UPDATE). It allows to flush a range of zc notifications
from slots with indexes [sqe->off, sqe->off+sqe->len). If sqe->arg is
not zero, it also copies sqe->arg as a new tag for all flushed
notifications.

Note, it doesn't flush a notification of a slot if there was no requests
attached to it (since last flush or registration).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/rsrc.c               | 38 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e62e61ceb494..eeb0fbee19cb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,7 @@ enum io_uring_op {
  */
 enum {
 	IORING_RSRC_UPDATE_FILES,
+	IORING_RSRC_UPDATE_NOTIF,
 };
 
 /*
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 0c3f95f24cef..af58d58dd21b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -15,6 +15,7 @@
 #include "io_uring.h"
 #include "openclose.h"
 #include "rsrc.h"
+#include "notif.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -742,6 +743,41 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+static int io_notif_update(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned len = up->nr_args;
+	unsigned idx_end, idx = up->offset;
+	int ret = 0;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	if (unlikely(check_add_overflow(idx, len, &idx_end))) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	if (unlikely(idx_end > ctx->nr_notif_slots)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	for (; idx < idx_end; idx++) {
+		struct io_notif_slot *slot = &ctx->notif_slots[idx];
+
+		if (!slot->notif)
+			continue;
+		if (up->arg)
+			slot->tag = up->arg;
+		io_notif_slot_flush_submit(slot, issue_flags);
+	}
+out:
+	io_ring_submit_unlock(ctx, issue_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
+
 int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req);
@@ -749,6 +785,8 @@ int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
 	switch (up->type) {
 	case IORING_RSRC_UPDATE_FILES:
 		return io_files_update(req, issue_flags);
+	case IORING_RSRC_UPDATE_NOTIF:
+		return io_notif_update(req, issue_flags);
 	}
 	return -EINVAL;
 }
-- 
2.36.1

