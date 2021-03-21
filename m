Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA063432CB
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhCUNpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhCUNoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:44:38 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC07C061574;
        Sun, 21 Mar 2021 06:44:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so7185166pjb.0;
        Sun, 21 Mar 2021 06:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ipls7LAfXxAOeZq1Ni1c39go/J4X9iGxp02joKQsB6o=;
        b=Ah2UkPHCJRXJYXlogGVbdx9FvFYPUKx3aFyY8G/23fMxNeYaTqfAfk00y69yfEGu2p
         WRdSsG7VQQyxTMk3jKTlY4e+xAtTNJStjcrY6JL5UKZ4SnZf2XGGyTGx5uzIn+wLRSv9
         E8IgVT9/UpIp6kHMyeoTgHz8NRydffqllgLCR541ZjOrg9zkGq4fL7K1J6t+75qLhp5R
         vTNLtrAWtanm3EpB7U8OUqzAybM3aOnTbsayWWgWQoQ8AlfYvp9ONkp1MNjrwsF7ClUO
         BcTCFJoqJCV4Mt0Dfabyswd5Iu9jOcZL2po4WUlxzsMyGMoKFsVNO5MlNDntVgNvxr9A
         1KSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ipls7LAfXxAOeZq1Ni1c39go/J4X9iGxp02joKQsB6o=;
        b=o/gP5u28CB43lYBWsIP0Uxy+g0R5QkXRfVbb1KPTwX4LFKtyzenr6BxaHWEJ7k1lzX
         3JmpXABvWaAbo7BN26mr5L2eKC7dmq3P/LMPs+yYwkMKQQnYBAmiBFLBsTTeFgjjY6c1
         1i3GvNhUVwYrqPXB1IwkTSL0sOPdn6TypphO3VPEUQTs/y3qRUp1to2YzBaB/HKjQR1O
         kYfxlU6qiirqbw+IoR+NGi3/nfuMd/mIaZ1MI8QiLQT1Z4ssz0rB9A7L4wCVm2y9b7Lv
         PWZ+KCQjiImxjv7lIjlfvI5JC80hW8BN/Gsko4GG341ZtglqldsX1oMwA4L/WeAFlu8F
         Bxrw==
X-Gm-Message-State: AOAM532ISRk6Q7dvBzBimILhLzSbHaygJMRyycZ0IbX6PvVNZDyA7Bhy
        4N7XAYb8wwWC+cOjF8o2sgM=
X-Google-Smtp-Source: ABdhPJzXXo9pH6ZezmUiqw94ZhsE+iTXPhGhTWE64xD2o3z3hlg8JCAU8B5JP34VGW/g8E1/RXjsSA==
X-Received: by 2002:a17:90a:a898:: with SMTP id h24mr8382989pjq.9.1616334277526;
        Sun, 21 Mar 2021 06:44:37 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id 202sm10617024pfu.46.2021.03.21.06.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 06:44:37 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     herbert@gondor.apana.org.au, andy.shevchenko@gmail.com,
        kuba@kernel.org, linux@roeck-us.net, David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 2/2] net: socket: change MSG_CMSG_COMPAT to BIT(21)
Date:   Sun, 21 Mar 2021 21:43:57 +0800
Message-Id: <20210321134357.148323-3-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210321134357.148323-1-dong.menglong@zte.com.cn>
References: <20210321134357.148323-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Currently, MSG_CMSG_COMPAT is defined as '1 << 31'. However, 'msg_flags'
is defined with type of 'int' somewhere, such as 'packet_recvmsg' and
other recvmsg functions:

static int packet_recvmsg(struct socket *sock, struct msghdr *msg,
			  size_t len,
			  int flags)

If MSG_CMSG_COMPAT is set in 'flags', it's value will be negative.
Once it perform bit operations with MSG_*, the upper 32 bits of
the result will be set, just like what Guenter Roeck explained
here:

https://lore.kernel.org/netdev/20210317013758.GA134033@roeck-us.net

As David Laight suggested, fix this by change MSG_CMSG_COMPAT to
some value else. MSG_CMSG_COMPAT is an internal value, which is't
used in userspace, so this change works.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
v2:
- add comment to stop people from trying to use BIT(31)
---
 include/linux/socket.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index d5ebfe30d96b..61b2694d68dd 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -312,17 +312,21 @@ struct ucred {
 					 * plain text and require encryption
 					 */
 
+#if defined(CONFIG_COMPAT)
+#define MSG_CMSG_COMPAT		BIT(21)	/* This message needs 32 bit fixups */
+#else
+#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
+#endif
+
 #define MSG_ZEROCOPY		BIT(26)	/* Use user data in kernel path */
 #define MSG_FASTOPEN		BIT(29)	/* Send data in TCP SYN */
 #define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
 					 * descriptor received through
 					 * SCM_RIGHTS
 					 */
-#if defined(CONFIG_COMPAT)
-#define MSG_CMSG_COMPAT		BIT(31)	/* This message needs 32 bit fixups */
-#else
-#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
-#endif
+/* Attention: Don't use BIT(31) for MSG_*, as 'msg_flags' is defined
+ * as 'int' somewhere and BIT(31) will make it become negative.
+ */
 
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
-- 
2.31.0

