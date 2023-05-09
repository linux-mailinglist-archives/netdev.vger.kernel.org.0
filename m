Return-Path: <netdev+bounces-1203-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675456FCA18
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7221C20BE3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD9D18008;
	Tue,  9 May 2023 15:19:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F317FE6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:19:16 +0000 (UTC)
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7675844BF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:19:15 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-760dff4b701so37603439f.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 08:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683645555; x=1686237555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dgWRc5/LSrLk2Jc/BvYuBNSBxWtzvDa1580QK6qMmU=;
        b=4xi4UZAsDeZFH2vLjBFdwNzUsZtprOD9/RBP6wxtqxg2m2X0Pjlt0wGUNsQsC4YjDC
         prvSHWRI031SawHeC7XDrXt2NCWtp22mGMWbkt4ze/0RNLPQZ96qCJP54CPLe/oYA2V4
         +OeMBSOhB88waZ+p2FXolrirI5HHe0yBzxhV3nwWRR9lo8gOqDc9LXXC0VxS5WNACLTz
         bu7Ig3MeIqOObDGvZn85n+CTT6M86yMgbNblAoLWF1IceccPHnwapfS4y+tUKqP1tNHB
         HDP9nG7JtLG26waYqnPKg6JByAGiL2yYvHdkKCBOhLxXog21b0CvwGVgPq6EfL586PT1
         m/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683645555; x=1686237555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dgWRc5/LSrLk2Jc/BvYuBNSBxWtzvDa1580QK6qMmU=;
        b=NA9QbtaD6QSR8YboZ+O65phs+Aq9jUYO6doQnzXRgmG/kmGpyXZNEXEx4TpjjOnVvP
         wWaATtOWR2czsxeYS/FzqcUYa26D3UvQVZ1TWBT92G6JcZ6OO2IbW2n98OrTEojATWab
         tkmmjtpSud0g3WHm0mLLvSzsmjobwrOyHMAJiW+XeSf+29bt8MeHofjHQoGoHv0mLgek
         PakJDnbBudjvrC8EjnbB8/YD6Pykfd1Lv7LdIkBIWoz4qw8OESvdthH6rHKNmo3iRkXQ
         PxkZSDWCyOHvUNW49gpAoHhoh/AN4IPoyYA2810PJgScZKQA5ZYwXFrWmTDq35x1cgGG
         MjWg==
X-Gm-Message-State: AC+VfDx9oclbAs5QgyhrZhvrNMN++HkPylL4uvZ+77Q7SkVzqQRiZKSJ
	i9JaNiM72u1vLN4lKAU70EP+cQ==
X-Google-Smtp-Source: ACHHUZ5Dj4Z1JapNi5FTM3anXVp9Zd6k/R11Xiek3v5eBUYl2hIPAtlM36jdfz24NtBjXzjui/oOSw==
X-Received: by 2002:a05:6602:2d51:b0:763:6aab:9f3e with SMTP id d17-20020a0566022d5100b007636aab9f3emr11367715iow.1.1683645554843;
        Tue, 09 May 2023 08:19:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z1-20020a056638240100b0041659b1e2afsm677390jat.14.2023.05.09.08.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 08:19:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	Jens Axboe <axboe@kernel.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH 1/3] net: set FMODE_NOWAIT for sockets
Date: Tue,  9 May 2023 09:19:08 -0600
Message-Id: <20230509151910.183637-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230509151910.183637-1-axboe@kernel.dk>
References: <20230509151910.183637-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The socket read/write functions deal with O_NONBLOCK and IOCB_NOWAIT
just fine, so we can flag them as being FMODE_NOWAIT compliant. With
this, we can remove socket special casing in io_uring when checking
if a file type is sane for nonblocking IO, and it's also the defined
way to flag file types as such in the kernel.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/socket.c b/net/socket.c
index a7b4b37d86df..6861dbbfadb6 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -471,6 +471,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
 		return file;
 	}
 
+	file->f_mode |= FMODE_NOWAIT;
 	sock->file = file;
 	file->private_data = sock;
 	stream_open(SOCK_INODE(sock), file);
-- 
2.39.2


