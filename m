Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCCA5727E3
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbiGLUyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 16:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiGLUxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 16:53:48 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032B7D03B3;
        Tue, 12 Jul 2022 13:53:23 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v16so12790828wrd.13;
        Tue, 12 Jul 2022 13:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zU7SCTZ1JR9bpmBy/aLylVb+e+9ie+s0rEDh1Smgcsg=;
        b=F8O/jx5Je8eryKkph6AeX5I8ABHFSKvG/mNDO6VjK4TGox9Z+Z9g67tGWGVonwYaX8
         ABTZZc1RpU56XCDZ8Oz2N5S3H3n8gU4PHzi8YCR7NumYYazatkqYJ5zn3rcQ9p5/bxfc
         fDhXHPw/ynwfAMT9uNhGUJb8WuEKLc9A1Qg02RGFolptTciLXGLh0qXZKytXPJ6jzfYk
         BYz7nUpalakGuhdfS90zylg1dT7gkgO/ihrdrKgPGI6o7NzCCRkzK1BfSHPl4yZLZ2IF
         QmPBsIc67tbl78FFrpuU5RP2FIJKBlXaGwfz5dupuJnhGrOnR8t4S7vllopPthaK+Pam
         bW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zU7SCTZ1JR9bpmBy/aLylVb+e+9ie+s0rEDh1Smgcsg=;
        b=6dgZIsGbvcvff7NGxVk0n/xR9CVVjq5Q46Su6+2axU6S82H9u3HnnnbIBGxp72ZXU1
         DUlmnaQ+jk65UcFNRDrZf/pN7HXs2yv5MYw5IBNdcv1Bsktw3VBrwylNL/3aT4X6VtC3
         dT0DV8zcBzoUfbBDAOJ3udUUvNQcwqAwkr/Z1khlRCIkzLS+0KyOID1ZFz3adMsabSY8
         w+OWegG4G4WQCVcl6GSXopxQXlvesUNQJHo19ZfRy09WOd8Cnd8c2ZE+FOK2NSd8f+ys
         DlRPjQwpQ835l5LocX0JMSxI4Pp3BItQa/1ko3bbwpqtUyBHt7z+N492EFndcmbfoErv
         Iazw==
X-Gm-Message-State: AJIora+Oh/JEdv7AiYxCkQC7nNujCNQk0EHwY5Otg8Wz9MiKz+Nbnuo2
        YyWh3am9xwME6jsvzAU6lMldp4TWFfk=
X-Google-Smtp-Source: AGRyM1tgGvNkygL1SBdVVnlSafYsitm6VFrOzmb1ExdfB9SQlfNPmvMHAfOSIcCo+FyJPCGHGE3S+w==
X-Received: by 2002:a05:6000:1152:b0:21d:7646:a976 with SMTP id d18-20020a056000115200b0021d7646a976mr24466876wrx.416.1657659201832;
        Tue, 12 Jul 2022 13:53:21 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id c14-20020a7bc00e000000b003a044fe7fe7sm89833wmb.9.2022.07.12.13.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 13:53:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v5 12/27] io_uring: initialise msghdr::msg_ubuf
Date:   Tue, 12 Jul 2022 21:52:36 +0100
Message-Id: <b8f9f263875a4a36e7f26cc5d55ebe315308f57d.1657643355.git.asml.silence@gmail.com>
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
2.37.0

