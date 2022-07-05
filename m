Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370985671D4
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbiGEPEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiGEPCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:36 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803C61572F;
        Tue,  5 Jul 2022 08:02:14 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k129so7229512wme.0;
        Tue, 05 Jul 2022 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QayDVb1TKX4nQ32atr/TNQ1V8pDXQwsZmBz0HTUXHx0=;
        b=UWMB+llED/MEE1En5HIuhSQzeryDHrKYY2Oa6b+KhkqzdKYypx6Kypn4Wby2ccgM7F
         UZRh74HoA0ltXLlK8BIMlhaJ+EUzL0qamQ52hZCAQNXm7tI0KehlCywyGmqJ4wlhDgJf
         3awMgLs2eGkhY721CEm4oJs0m4z6M2stAlMl/wqIk8Fgo+v4dtt1um0c/+P4mK2e916l
         LzQIoapR4enyXXfP9Ixud/7yghoL+wi71/NQq/cWxYrt8o/DV9dg27Xomk/+1RC4hAQv
         wmvLWghSzEBwZpi0Hnx7Ln31Z1n7+/CKWMW1qEilJ9xcRUr1S/fhWpKwegJ6P3eMhAQU
         Fd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QayDVb1TKX4nQ32atr/TNQ1V8pDXQwsZmBz0HTUXHx0=;
        b=u+orRW/lWpkCIvSLZVgIeWqhnkCH81yVIka2Mluk7mNX+joF6WoGH5VkebvVNrYJmn
         YH/x2Vl3J0xBW5ONoru7nfxVqmK7BaLRrlo+TUhovttFNH0j1Tf3Nre82YdtZzslP+ff
         gnIf7tN8Fnb5wFWbOv+8XrRJlfPJSyw5n+7Ue1Sp5g7cWA6uGPopA1oDCVzXJw2GEKVm
         xGQGtsBj/wvZGKa/Qc4yDeOSH3YRJRSgAR3n+01TCYowJKREUnkaeR0ll/M+8hvVMXYS
         vhe95NHxZ49rFkD7Bz+gL/enyqwKbqbscYm/1kazYeOJw6yJ/ILFVb6cRhyJT7Z97mNI
         sxkA==
X-Gm-Message-State: AJIora8ea1dtBElIRuezRKIFFRgqd2IWxECJoeET9djF24aOALSgAXsw
        ap0jYWiBtaj/BniKBcp5hD/KYaUX/fGVVA==
X-Google-Smtp-Source: AGRyM1s5PtBo8NsQvmSVPotWDsA2JqWeU6dcxcJtAw47i0CUV/9f8oeYLKjcrAhRTaov5q7+/AaP9g==
X-Received: by 2002:a05:600c:a42:b0:39c:9086:8a34 with SMTP id c2-20020a05600c0a4200b0039c90868a34mr39290063wmq.169.1657033332623;
        Tue, 05 Jul 2022 08:02:12 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 20/25] io_uring: add rsrc referencing for notifiers
Date:   Tue,  5 Jul 2022 16:01:20 +0100
Message-Id: <77556e7ac0d76a760c3a3f739fb2d177853e76c0.1656318994.git.asml.silence@gmail.com>
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

In preparation to zerocopy sends with fixed buffers make notifiers to
reference the rsrc node to protect the used fixed buffers. We can't just
grab it for a send request as notifiers can likely outlive requests that
used it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c |  5 +++++
 io_uring/notif.h |  1 +
 io_uring/rsrc.h  | 12 +++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 0a03d04c010b..a53acdda9ec0 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -7,10 +7,12 @@
 
 #include "io_uring.h"
 #include "notif.h"
+#include "rsrc.h"
 
 static void __io_notif_complete_tw(struct callback_head *cb)
 {
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
+	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
 	struct io_ring_ctx *ctx = notif->ctx;
 	struct mmpin *mmp = &notif->uarg.mmp;
 
@@ -31,6 +33,7 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	ctx->notif_locked_nr++;
 	io_cq_unlock_post(ctx);
 
+	io_rsrc_put_node(rsrc_node, 1);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -125,6 +128,8 @@ struct io_notif *io_alloc_notif(struct io_ring_ctx *ctx,
 	/* master ref owned by io_notif_slot, will be dropped on flush */
 	refcount_set(&notif->uarg.refcnt, 1);
 	percpu_ref_get(&ctx->refs);
+	notif->rsrc_node = ctx->rsrc_node;
+	io_charge_rsrc_node(ctx);
 	return notif;
 }
 
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 6dde39c6afbe..00efe164bdc4 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -11,6 +11,7 @@
 struct io_notif {
 	struct ubuf_info	uarg;
 	struct io_ring_ctx	*ctx;
+	struct io_rsrc_node	*rsrc_node;
 
 	/* complete via tw if ->task is non-NULL, fallback to wq otherwise */
 	struct task_struct	*task;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 87f58315b247..af342fd239d0 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -135,6 +135,13 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 	}
 }
 
+static inline void io_charge_rsrc_node(struct io_ring_ctx *ctx)
+{
+	ctx->rsrc_cached_refs--;
+	if (unlikely(ctx->rsrc_cached_refs < 0))
+		io_rsrc_refs_refill(ctx);
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 					struct io_ring_ctx *ctx,
 					unsigned int issue_flags)
@@ -144,9 +151,8 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
 
 		if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 			lockdep_assert_held(&ctx->uring_lock);
-			ctx->rsrc_cached_refs--;
-			if (unlikely(ctx->rsrc_cached_refs < 0))
-				io_rsrc_refs_refill(ctx);
+
+			io_charge_rsrc_node(ctx);
 		} else {
 			percpu_ref_get(&req->rsrc_node->refs);
 		}
-- 
2.36.1

