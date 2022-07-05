Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20745671D0
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbiGEPEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 11:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiGEPC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 11:02:29 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F7817E1A;
        Tue,  5 Jul 2022 08:02:10 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id f2so12596507wrr.6;
        Tue, 05 Jul 2022 08:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OyzXlHlPpUF+PH3cvr0acLEzu0fqzPDm7G8p3eUY1iQ=;
        b=oY665IzMEMc069+iaFhE806eybX+Vi7JUUgzz76HgKm/BEi8RmiLw8O6vaotDBWZh4
         sr7Jb9AaZLI5BkhrQO7WmZBhYcwGiX3CVB+Ikj/pQ1o3bWaMJZ2CmsCyaVxhx6YDSr4W
         e8uSk10DtnKW5qW7MXWlMgAryd6QG0MBYPdtpP7azjixrYMQ4bV4ip2DEr/u9O7VllAO
         fKHZVIR46xsXb/deGjNUeximHFKEbm/ftuNyOnndXgs3owWc4QYhAoG0cSRX/kNkeLVT
         LlwNyaYkeSw2SdI93JnMa6W7np8fjV2Q7t8s6HXMMGYlVPu+Fr0+rghlsiZXGH06tmY8
         E8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OyzXlHlPpUF+PH3cvr0acLEzu0fqzPDm7G8p3eUY1iQ=;
        b=qbz0V9Nbr5zwjyG6llzU9KSQxclGcke0cDDQzG8cJPz2XfxwW2ECfOpHQKVDghFrTm
         M19XkIzEA7xeyxl3Gkh5FaTctJot925sx+qVKBiFzzBMHSGF6RPPd6BJq6NdZz7Gc/s8
         yrWo+I9w3/IoBd+jIQng+e6Xqqrtb+feqJCbmqFxmjOjnuSHAbsawJeIyli9dZXsKeEH
         A1KUvaeOtobxG0E4m3CRka7R45h3TysratNVekRWdqLf+vx6wk/8w1/ZX3r/IahASHbh
         sji/3WBExPVKVp6XLsbNWPhg/0LbDUUJiY6mXGo62z0lodJlpGPpOZsVHDhhzaaXSco3
         glIg==
X-Gm-Message-State: AJIora8zKZm8UkPtHqdgywyrI3XDehKe12cYRz0Vg9Zq17+dmtzWJHzb
        +IatkU1JfnByE3EPjf4f7t5dkkijANcKQA==
X-Google-Smtp-Source: AGRyM1tJfsBeMrIe3Dl2+VRSgweWSzFDTlzj0Tjk8JsyY3B/9FeNKugG94VtGU0X3QRP0IKpD+znrQ==
X-Received: by 2002:a05:6000:1282:b0:21d:6afa:35ca with SMTP id f2-20020a056000128200b0021d6afa35camr10615518wrx.452.1657033330047;
        Tue, 05 Jul 2022 08:02:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id k27-20020adfd23b000000b0021d728d687asm2518200wrh.36.2022.07.05.08.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 08:02:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v3 18/25] io_uring: account locked pages for non-fixed zc
Date:   Tue,  5 Jul 2022 16:01:18 +0100
Message-Id: <8b9d08b0ef818070564864036419550d5d767911.1656318994.git.asml.silence@gmail.com>
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

Fixed buffers are RLIMIT_MEMLOCK accounted, however it doesn't cover iovec
based zerocopy sends. Do the accounting on the io_uring side.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 1 +
 io_uring/notif.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index ef492f1360c8..d5b00e07e72b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -834,6 +834,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
+	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 2e9329f97d2c..0a03d04c010b 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -12,7 +12,13 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 {
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_ring_ctx *ctx = notif->ctx;
+	struct mmpin *mmp = &notif->uarg.mmp;
 
+	if (mmp->user) {
+		atomic_long_sub(mmp->num_pg, &mmp->user->locked_vm);
+		free_uid(mmp->user);
+		mmp->user = NULL;
+	}
 	if (likely(notif->task)) {
 		io_put_task(notif->task, 1);
 		notif->task = NULL;
-- 
2.36.1

