Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824F83432CA
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCUNpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhCUNob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 09:44:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A906AC061574;
        Sun, 21 Mar 2021 06:44:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so6769115pjb.4;
        Sun, 21 Mar 2021 06:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+tW1sbTAqpwuW52zUYbzaaee2q2ruShFJBcwucBx5E=;
        b=jKjONsL9CzBYsFkD7TUUdFD/PHDEngI8wNvENRUG2xaBZbAo+5cfB19g7vCvOJcmnq
         C6c7qQxJ+rUXwa4bQMmd2k+g4YglAeN2ENKj57mX0btpThCK/q12mu0kucwY5J7aTngd
         AAiOslv5BmAXDZD8wjXZSSRGQxuWR8qA3rDkG1PACe+pOSXEstIZYIS4HcZue6mgPOGI
         ObksWofQnn54FmPxNrC13tSm8FVH6q4U3wz55B5vAb60Vu+hB5029ePvHYEKop6EPqHO
         RD71DPeSm404temG5u0nZqins+OcnksiI4+XzqsbU9Y6G5bciH0AM0t87TEMBMXQg4GJ
         SsEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+tW1sbTAqpwuW52zUYbzaaee2q2ruShFJBcwucBx5E=;
        b=WQabYBTIGZoBeYrw4pKNaUyKtHaFPwgzuzNZ5dS/phxvPj/B/DMvv1VPtw8la4qsn1
         7vDTsnlRcBJNcvBCzA4QcAlHD/7VU8Aug5ss+/qNVdqdjAsuvapcNdxH7YbvkCIqArYh
         f+KQgH4GZzwMVB1AIY8gMhRelKLW1UGNlZObGVc9J0ozIowi2fd2WV+4eHUmRwPDpVzm
         WZ+EHYSsGuJiGzfHVToN5W3/yIelYu2lrPTnH0a57Ck+Y/Gj/KWPWyR/k3PlQ/LFsK4w
         T7shg/JVBzubNvxxG4uRHOoFHyOtcr0q3Cj23sHpoIpdq/KFZh1u67BnkaNjWRiAetfz
         MyrA==
X-Gm-Message-State: AOAM5316X0V/Vlxc0NMLSCPb1Ywpg3GSPa7NZvPOrGafb4bPkZ5Z05DF
        GfnUZMN38Yz4L0Z3UQVJheM=
X-Google-Smtp-Source: ABdhPJy3asG16JABejQfwIMMYL444isnq7G3FcVHdYqZQeAHAHAwGorDzmfzNJJH5aHq39JH419m/A==
X-Received: by 2002:a17:902:dac2:b029:e6:30a6:4c06 with SMTP id q2-20020a170902dac2b02900e630a64c06mr23161529plx.65.1616334270262;
        Sun, 21 Mar 2021 06:44:30 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id d22sm10759477pjx.24.2021.03.21.06.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 06:44:29 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     herbert@gondor.apana.org.au, andy.shevchenko@gmail.com,
        kuba@kernel.org, linux@roeck-us.net, David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/2] net: socket: use BIT() for MSG_*
Date:   Sun, 21 Mar 2021 21:43:56 +0800
Message-Id: <20210321134357.148323-2-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210321134357.148323-1-dong.menglong@zte.com.cn>
References: <20210321134357.148323-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

The bit mask for MSG_* seems a little confused here. Replace it
with BIT() to make it clear to understand.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 include/linux/socket.h | 71 ++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 385894b4a8bb..d5ebfe30d96b 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -283,42 +283,45 @@ struct ucred {
    Added those for 1003.1g not all are supported yet
  */
 
-#define MSG_OOB		1
-#define MSG_PEEK	2
-#define MSG_DONTROUTE	4
-#define MSG_TRYHARD     4       /* Synonym for MSG_DONTROUTE for DECnet */
-#define MSG_CTRUNC	8
-#define MSG_PROBE	0x10	/* Do not send. Only probe path f.e. for MTU */
-#define MSG_TRUNC	0x20
-#define MSG_DONTWAIT	0x40	/* Nonblocking io		 */
-#define MSG_EOR         0x80	/* End of record */
-#define MSG_WAITALL	0x100	/* Wait for a full request */
-#define MSG_FIN         0x200
-#define MSG_SYN		0x400
-#define MSG_CONFIRM	0x800	/* Confirm path validity */
-#define MSG_RST		0x1000
-#define MSG_ERRQUEUE	0x2000	/* Fetch message from error queue */
-#define MSG_NOSIGNAL	0x4000	/* Do not generate SIGPIPE */
-#define MSG_MORE	0x8000	/* Sender will send more */
-#define MSG_WAITFORONE	0x10000	/* recvmmsg(): block until 1+ packets avail */
-#define MSG_SENDPAGE_NOPOLICY 0x10000 /* sendpage() internal : do no apply policy */
-#define MSG_SENDPAGE_NOTLAST 0x20000 /* sendpage() internal : not the last page */
-#define MSG_BATCH	0x40000 /* sendmmsg(): more messages coming */
-#define MSG_EOF         MSG_FIN
-#define MSG_NO_SHARED_FRAGS 0x80000 /* sendpage() internal : page frags are not shared */
-#define MSG_SENDPAGE_DECRYPTED	0x100000 /* sendpage() internal : page may carry
-					  * plain text and require encryption
-					  */
-
-#define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
-#define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
-#define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
-					   descriptor received through
-					   SCM_RIGHTS */
+#define MSG_OOB		BIT(0)
+#define MSG_PEEK	BIT(1)
+#define MSG_DONTROUTE	BIT(2)
+#define MSG_TRYHARD	BIT(2)	/* Synonym for MSG_DONTROUTE for DECnet		*/
+#define MSG_CTRUNC	BIT(3)
+#define MSG_PROBE	BIT(4)	/* Do not send. Only probe path f.e. for MTU	*/
+#define MSG_TRUNC	BIT(5)
+#define MSG_DONTWAIT	BIT(6)	/* Nonblocking io		*/
+#define MSG_EOR		BIT(7)	/* End of record		*/
+#define MSG_WAITALL	BIT(8)	/* Wait for a full request	*/
+#define MSG_FIN		BIT(9)
+#define MSG_SYN		BIT(10)
+#define MSG_CONFIRM	BIT(11)	/* Confirm path validity	*/
+#define MSG_RST		BIT(12)
+#define MSG_ERRQUEUE	BIT(13)	/* Fetch message from error queue */
+#define MSG_NOSIGNAL	BIT(14)	/* Do not generate SIGPIPE	*/
+#define MSG_MORE	BIT(15)	/* Sender will send more	*/
+#define MSG_WAITFORONE	BIT(16)	/* recvmmsg(): block until 1+ packets avail */
+#define MSG_SENDPAGE_NOPOLICY	BIT(16)	/* sendpage() internal : do no apply policy */
+#define MSG_SENDPAGE_NOTLAST	BIT(17)	/* sendpage() internal : not the last page  */
+#define MSG_BATCH		BIT(18)	/* sendmmsg(): more messages coming */
+#define MSG_EOF	MSG_FIN
+#define MSG_NO_SHARED_FRAGS	BIT(19)	/* sendpage() internal : page frags
+					 * are not shared
+					 */
+#define MSG_SENDPAGE_DECRYPTED	BIT(20)	/* sendpage() internal : page may carry
+					 * plain text and require encryption
+					 */
+
+#define MSG_ZEROCOPY		BIT(26)	/* Use user data in kernel path */
+#define MSG_FASTOPEN		BIT(29)	/* Send data in TCP SYN */
+#define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
+					 * descriptor received through
+					 * SCM_RIGHTS
+					 */
 #if defined(CONFIG_COMPAT)
-#define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
+#define MSG_CMSG_COMPAT		BIT(31)	/* This message needs 32 bit fixups */
 #else
-#define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
+#define MSG_CMSG_COMPAT		0	/* We never have 32 bit fixups */
 #endif
 
 
-- 
2.30.2

