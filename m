Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2896F343295
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 13:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhCUMnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 08:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhCUMm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 08:42:56 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D25C061574;
        Sun, 21 Mar 2021 05:42:56 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g10so5148704plt.8;
        Sun, 21 Mar 2021 05:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lQ4bmh/CsDFXlzhabMxrzD2UIU3buMBGOPGfvJyLVio=;
        b=p9NBlQJ/In/nlUJwYY37Tm2D/f8It4ym8rskyTtG35WadMQDlnqmLFnXWe+Pnu54ew
         +BRkkBPB8su2oRou37JQMOFmxZJBupi/RJvAfaqvDdPJTj29PqlCXznJvGEWfVmjyvhd
         qGQpajJwOFVMng5j2vaaGMAsrWV+NdU7r9/eRN50V7ueXOU1YRqbg1ev0R6dS6tQnApF
         ZHQYij9Rc2R18+kTwSKOucajf1dOM/EB7HNegBd+N4yRy2TANWISjPfq/I/+HNtEvQ1g
         8yUrbaUptRLdF+QSFM6PWjxuGs1U8sHPclcI6SiIXKigBQwxtU6rY0fGqQjMBnacfzsG
         kg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lQ4bmh/CsDFXlzhabMxrzD2UIU3buMBGOPGfvJyLVio=;
        b=Z0hvoJBI0aGbehoX+47J12ZC+NcQRNmabr0RF0nDHwt8z2CMU1If9h/b1fjpLUXh9N
         G6GNPm+NOemWIJ35M54FMmFevfjuoPVt+Vfi6WngBUth9qbQmknprPsyrpL/91+ghkCc
         zLEZRzrkbKarD2NI3W0QCQyOwYXpb1a1vB0Vob4MSEm7uIUNBawD4BePRmjPqPK8D8s0
         5N7PLoM+WjFduGlbPk9zl2fEZtHyPaTpw++8FBQyb+zhSOaRj01D7FMnRPVu2QcARPqK
         ymRupJTx+924zXR7eyEO11F/2GBeewPrV9ZzfEaPFvIBY1c20qYI2e5GXqsrVukde3MW
         cryA==
X-Gm-Message-State: AOAM530dqUzeBC78drjjwEsPX4aYV+Bh0oKEhYB+1/Pkkqo3ag9PLVrr
        XFNlkx3cKukHk4dz+84qPes=
X-Google-Smtp-Source: ABdhPJwklQUCyHeQqTqMRMRZ+d2kmZPGMBLUW4QQk1p3Rm5yw/iJjUcMT2OtFapv9fXokRqB86i3BA==
X-Received: by 2002:a17:902:b70e:b029:e6:cef9:6486 with SMTP id d14-20020a170902b70eb02900e6cef96486mr17438560pls.18.1616330575662;
        Sun, 21 Mar 2021 05:42:55 -0700 (PDT)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id e1sm11235065pfd.72.2021.03.21.05.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 05:42:55 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     andy.shevchenko@gmail.com, kuba@kernel.org, linux@roeck-us.net,
        David.Laight@aculab.com
Cc:     davem@davemloft.net, dong.menglong@zte.com.cn,
        viro@zeniv.linux.org.uk, herbert@gondor.apana.org.au,
        axboe@kernel.dk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: socket: change MSG_CMSG_COMPAT to BIT(21)
Date:   Sun, 21 Mar 2021 20:39:29 +0800
Message-Id: <20210321123929.142838-3-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210321123929.142838-1-dong.menglong@zte.com.cn>
References: <20210321123929.142838-1-dong.menglong@zte.com.cn>
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
 include/linux/socket.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index d5ebfe30d96b..317b2933f499 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -312,17 +312,18 @@ struct ucred {
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
 
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
-- 
2.31.0

