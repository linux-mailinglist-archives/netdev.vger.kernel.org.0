Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6577356A196
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiGGLxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiGGLwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:21 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C5053D33;
        Thu,  7 Jul 2022 04:52:11 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id n10so652456wrc.4;
        Thu, 07 Jul 2022 04:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FNoKlp/SzKlWKmK/1oNh3mGrQFyB3mtnwPpvEKvsiGw=;
        b=Y3VVECV5nyDkb5h+3N82nH/dQ3E7F2OgTMBmUTzHgZ43JyTmExa6k6CfS0GBMvTJ+1
         CoNLdWWMdKRx235F8de9jx4CQUq3qpPkE7Ef9IneyEdtqvA5qb02scGF4EpNCcpuNApe
         f8TuIsJgSbreYofNhnywB1TO02RUTZpf30s6ga6jibfQxh4riCxIl+4InY5om8UUD5C+
         OfJdmCFuRubUyNNPtmwQwFpZIZGepY1c78xf+N9TwsJKB7VwAwqFc7OIn0+aPNAUI3XY
         y/wkWqjS/sURH3yRFxfvuYYaYVHg1oTQvt+Qrgg0cnFBtjJJD2xKsZdSbegPH6CQmm47
         qGeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FNoKlp/SzKlWKmK/1oNh3mGrQFyB3mtnwPpvEKvsiGw=;
        b=1c05pXrsgkOcaSE9LQ7wWLuenOO6orgS5YS4+H1SAi5VHPJt9VnZPxvOxqgqm0VKP6
         GPfR49x4wnFDFPOnOqx615Kqkm+iLWBYB/4fByDsY2SLT8DBjXCrmPhtEP8Q4eGGJl7g
         NhGurngX+vp/YOT44oeyoI7yqFS2+zyb9YuhI/jvw63+4UcM0q2ItKiZ1peczsJeUjZf
         FGA+Dl4OpowMV4iH2XynxnjdL+74NMIbVA3gThswh+HBSr6JV89yBmEQGfbFZnIsdYWF
         UFWJEzx3BtarlvWDMwU5hzHqKm7KG9XSw9cQPOThctk6Eyr33PtC5/8A4effDXTGFje8
         Z4gA==
X-Gm-Message-State: AJIora8YGfG5sePMZcRjD0UTCqBaZElcYuYaV2JppvHnauDupI0RMPqR
        16TWBaJ91hCNYNAg2RnXaBBc/5j7oY7VQ/P4Q/M=
X-Google-Smtp-Source: AGRyM1vpEFSGS6wbdfQ3p+XZzzOJ8na4RMVJfyFlyF75WuRNegLPfoQfnEHtqVnTL1ZTL58ugNlX6w==
X-Received: by 2002:a5d:5846:0:b0:21b:c444:9913 with SMTP id i6-20020a5d5846000000b0021bc4449913mr39721499wrf.128.1657194729572;
        Thu, 07 Jul 2022 04:52:09 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 20/27] io_uring: account locked pages for non-fixed zc
Date:   Thu,  7 Jul 2022 12:49:51 +0100
Message-Id: <b54ec5eef1eeb7c0f947248392241fcfd9dae522.1657194434.git.asml.silence@gmail.com>
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

Fixed buffers are RLIMIT_MEMLOCK accounted, however it doesn't cover iovec
based zerocopy sends. Do the accounting on the io_uring side.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 1 +
 io_uring/notif.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 399267e8f1ef..69273d4f4ef0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -724,6 +724,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	ret = import_single_range(WRITE, zc->buf, zc->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
+	mm_account_pinned_pages(&notif->uarg.mmp, zc->len);
 
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e6d98dc208c7..c5179e5c1cd6 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -14,7 +14,13 @@ static void __io_notif_complete_tw(struct callback_head *cb)
 	struct io_notif *notif = container_of(cb, struct io_notif, task_work);
 	struct io_rsrc_node *rsrc_node = notif->rsrc_node;
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

