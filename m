Return-Path: <netdev+bounces-1214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 376DE6FCB65
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76AA828137B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BCBE3D6A;
	Tue,  9 May 2023 16:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8574218005
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:35:58 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF7110F0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:35:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9e50081556so11439498276.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 09:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683650156; x=1686242156;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZUTL77CEPkSZl2Y/+PPUHqvW1kClzAtK6Hm0iWI3+DQ=;
        b=A8euNkpgL7V7O5VluPEKtEc6l/WVjH8mBPRA8rop6ETWhk0zobjZhYOhtQuiZPWhNG
         glNCNCNoEJdNYk5Tqv0AWYPC86CsoA4/MQ3jYMamDSKt8yXVfuXvZQtqOifH2cMZ03ZQ
         c8D4YPH8/A3vo6Q2AZ0WWeLaM9WG3ahlpYt8Aa16BURkZ4keXnozHWtATBZ5Z5bQl7Zf
         q8cYAHvotqqHkN9GoUGrn3dM8gxEdQ4Bu41wo/Ewic+toTIdhSHK2K5WWeOakWnBvpoe
         KtiJziYVjiVlzMHWnDxNUHNQL6LC0kO1n7kJ6zMdIvwXDx4rS3CsXbxx41P/nz0vwpz0
         guyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683650156; x=1686242156;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZUTL77CEPkSZl2Y/+PPUHqvW1kClzAtK6Hm0iWI3+DQ=;
        b=hqj+0m/GrGhItUlyxqmZmWjz2Rdgx6ZNgj/T2eE98HDYMlNPHm4T3qrlpfjFwgIXUB
         c74YVb0wGrkYQfEvPpsPr4eMROJ1h4ubHTFnXe1WPE2e60hui7JRf6X5kWu6jjt561AR
         /OMWDMSP+G2o9OnxoKnHUWn9N1M0GznmtDFSzHBv+UjNoPWGkYLqu7HXylVJkxajoWKi
         XObo9jakyU369ly3Bv8OOyOtbS5binoVkJStucT6VBlqdh/73KYKf9CepQPO49I1r4s5
         hG6lWHxmOg1OCxqDX5UsDObdonzdMs1tDw4BnKnbvWA4xrsdq4Chi+65WYcqPs4NbklB
         aO3Q==
X-Gm-Message-State: AC+VfDyroMWdoxyHemsldG3iF6IYXbVUcNxbjbltB1VuKwCVb/HWuP49
	WbF8jeO7kZXqEYwdCIqTZtGErYQIuGgbTg==
X-Google-Smtp-Source: ACHHUZ6e/AFDh/lQlO8aeB1s63wGYKJ7P65ll35KhnQGoHtaJ4+FxBdv2oSoNN1v3rKHYdDTZUYZXgYMuwB8cQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:1a03:0:b0:b9d:b16c:517f with SMTP id
 a3-20020a251a03000000b00b9db16c517fmr6295252yba.10.1683650156404; Tue, 09 May
 2023 09:35:56 -0700 (PDT)
Date: Tue,  9 May 2023 16:35:53 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509163553.3081476-1-edumazet@google.com>
Subject: [PATCH net] net: annotate sk->sk_err write from do_recvmmsg()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

do_recvmmsg() can write to sk->sk_err from multiple threads.

As said before, many other points reading or writing sk_err
need annotations.

Fixes: 34b88a68f26a ("net: Fix use after free in the recvmmsg exit path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index a7b4b37d86df7a9232d582a14863c05b5fd34b68..b7e01d0fe0824d1f277c1fe70f68f09a10319832 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2911,7 +2911,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 		 * error to return on the next call or if the
 		 * app asks about it using getsockopt(SO_ERROR).
 		 */
-		sock->sk->sk_err = -err;
+		WRITE_ONCE(sock->sk->sk_err, -err);
 	}
 out_put:
 	fput_light(sock->file, fput_needed);
-- 
2.40.1.521.gf1e218fcd8-goog


