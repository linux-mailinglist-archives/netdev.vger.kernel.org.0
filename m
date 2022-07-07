Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442B656A175
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiGGLwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235480AbiGGLwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:52:04 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44898564C5;
        Thu,  7 Jul 2022 04:52:02 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n185so10475964wmn.4;
        Thu, 07 Jul 2022 04:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QCK7k3yHrE0FdtZ6WCn4Gv42BbVCsPIkdpgk1yDl/3o=;
        b=m0cZHyNXEPKBh9Q4KJojy6doLEzyR/sluUouDiM5a4RcCcA2Z0gRw97Su9wdfbQTAS
         mvr6PPXmEb8iuxUaUxwoNGbYoaA2DMXU2ZPRfriiMn5omjkeYCAPhSnSaWrLVilARsjk
         Is1jI5t8yl38JoE1y4ODySIHSIQNX1qMAPBgB/YSyGP4oKRQHwq5AnZJMV9YntLj/rPp
         VDb0QrBE5Cx6oBlMugtCFNQW8e6fXIZQNMYG45UVSWYEAmZP1MzPzTfN3+swkrb71VXO
         gyAJXwy13IszPUTrVD1aGkuoENt4mq2hRIVxM4owE3dsoU+Bq6HL80MAG3pVfK4ev7Of
         OvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QCK7k3yHrE0FdtZ6WCn4Gv42BbVCsPIkdpgk1yDl/3o=;
        b=KxrSOO2aY51B+QGoJd4Sh3U530Sumv5IMt4z3Bl4+F8gb2l/lEeMvyA6YK/H/JDPzY
         b+PARYaf97evsGhBBlhs3vzu+P2QdKQXKop9SXOlHyIhZPx4o9KZDx/oOTmiNAtBNtr7
         129CtX0RU818JT2FKanO0b9FyyU9dDy26pOLx8UnqZIjZAZeE3XXf5QX31fPUX4ufDVY
         F1YxZMLHd9HczM0qyCvU7+9R4QNibAcFJrkjfIlfOWY40G+yKzDqFOleAaPlFAuuB/Fd
         iuDCYjzxRshQCxn0sF21Pva6nOl6j45CM5edAkUWF7wDBCqcds0CJEMVyHFMtvrSwr6m
         P06g==
X-Gm-Message-State: AJIora8GKxwoHAyP+1GdiR0TqkxxEAvu67tKUqoIi4IuBg92MOBC0c36
        Z9QHUTNQqc9GhkSXJ1DkyCXGWAXbo2Y95AH90oc=
X-Google-Smtp-Source: AGRyM1vo4qy7omuQEEnoNgKG0XWRgkEY6HWfPZBujSlCn+bLDtpzLhKs/q0B0sKyy8oiO8kkByh9+Q==
X-Received: by 2002:a05:600c:255:b0:3a1:963d:2ba3 with SMTP id 21-20020a05600c025500b003a1963d2ba3mr4005526wmj.200.1657194720555;
        Thu, 07 Jul 2022 04:52:00 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a5d5142000000b0021b966abc19sm37982131wrt.19.2022.07.07.04.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 04:52:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v4 12/27] io_uring: initialise msghdr::msg_ubuf
Date:   Thu,  7 Jul 2022 12:49:43 +0100
Message-Id: <c0014f41f320fad881ab52acd241accb06681fd8.1657194434.git.asml.silence@gmail.com>
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

Initialise newly added ->msg_ubuf in io_recv() and io_send().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index cb08a4b62840..2dd61fcf91d8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -255,6 +255,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
+	msg.msg_ubuf = NULL;
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -601,6 +602,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_flags = 0;
 	msg.msg_controllen = 0;
 	msg.msg_iocb = NULL;
+	msg.msg_ubuf = NULL;
 
 	flags = sr->msg_flags;
 	if (force_nonblock)
-- 
2.36.1

