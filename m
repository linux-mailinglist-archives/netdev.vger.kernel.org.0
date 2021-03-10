Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873C83332DE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhCJBxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbhCJBxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 20:53:45 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA53DC06174A;
        Tue,  9 Mar 2021 17:53:44 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id z5so7691607plg.3;
        Tue, 09 Mar 2021 17:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3cAJ8QasC8iUVsBAkva2w1fCiJ27KJ2oqhZsjVJDktk=;
        b=h8aMBarV2GLotNdUMDkDCi0rcE8MAukDz9gB7KqiG3YGguTrGPgZwqnZ9nG316CFGn
         cOLj5+DDZv26u98TcFdoBjg0MhnGjnaQLte7gJuPBPfYn1kraNAMkRt7DnbtAQ5jXQlm
         rMBm9ZME8KdtKXligikR9Rt5c83yxqZ/pNuFv8anASAW9/iq81W0FdcO2tY67JOyhBAp
         ve1TFeLkDA7GXT5h0Ti847lND4o/K5oWjuC24D2zFktnewLHEqlENfquV4XGBFAlC6qE
         t9Pt//CBOgmAr6+9JK3C5SWKQ8QPmwqKEKEkrMIBi1rlcXF6kOQCO1wO+RPGiyNB1HOs
         geSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3cAJ8QasC8iUVsBAkva2w1fCiJ27KJ2oqhZsjVJDktk=;
        b=ZVBdc35NwK8ZMlCg3vMS1YjZYZL20pl6bsxBNQpfwLlrogtQ2dH3Pg4cIFaCQ0NrO+
         gE/9gYGunY1knmOgNIzaMjLU8NRHDAO/MCeb4j/UvqyCRiqjFU8Skw4quuZvu5NohwTD
         HX5EmTyLCsjfPJBXlUmf79lZ3BqSOSWtaU1lRCn74qK1Nx0mCl/+NlmVEsg4PtkOL1cK
         QQp5viGMKqU7GjIxrtAXL1nO/XUeT4ZPKRqGbwRtpOsNmZ8WiGgFn+3GItR9R9H/182a
         1q6BGqSd9rY78A2rpYn72x6x9agJ7nLqgc7vZCtPaTtIuLTLMqx1Sjv3WULPOC1frb1M
         +KlA==
X-Gm-Message-State: AOAM5334pdYCtrZkVRb6IyNZcLQ3ifdZx9dXH3UNdIHIKBJvAT5/0z6q
        aZuPMofCT9yPDCKR2bSlqBg=
X-Google-Smtp-Source: ABdhPJxT/HLum+AWOy81iV0DNKMICKUNS7reZBCD61CC4J/ms1MegQBNNdn0QHNbqCBfi9MhV3Y6cQ==
X-Received: by 2002:a17:902:ac82:b029:e3:bca2:cca7 with SMTP id h2-20020a170902ac82b02900e3bca2cca7mr811515plr.43.1615341224328;
        Tue, 09 Mar 2021 17:53:44 -0800 (PST)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id 133sm14867097pfa.130.2021.03.09.17.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 17:53:43 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org, andy.shevchenko@gmail.com
Cc:     davem@davemloft.net, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        herbert@gondor.apana.org.au, dong.menglong@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
Date:   Tue,  9 Mar 2021 17:51:35 -0800
Message-Id: <20210310015135.293794-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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
v4:
- CC netdev
v3:
- move changelog here
v2:
- use BIT() instead of BIT_MASK()
---
 include/linux/socket.h | 71 ++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 385894b4a8bb..e88859f38cd0 100644
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
+#define MSG_BATCH	BIT(18)		/* sendmmsg(): more messages coming */
+#define MSG_EOF		MSG_FIN
+#define MSG_NO_SHARED_FRAGS	BIT(19)	/* sendpage() internal : page frags
+					 * are not shared
+					 */
+#define MSG_SENDPAGE_DECRYPTED	BIT(20)	/* sendpage() internal : page may carry
+					 * plain text and require encryption
+					 */
+
+#define MSG_ZEROCOPY	BIT(26)		/* Use user data in kernel path */
+#define MSG_FASTOPEN	BIT(29)		/* Send data in TCP SYN */
+#define MSG_CMSG_CLOEXEC	BIT(30)	/* Set close_on_exec for file
+					 * descriptor received through
+					 * SCM_RIGHTS
+					 */
 #if defined(CONFIG_COMPAT)
-#define MSG_CMSG_COMPAT	0x80000000	/* This message needs 32 bit fixups */
+#define MSG_CMSG_COMPAT	BIT(31)	/* This message needs 32 bit fixups */
 #else
-#define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
+#define MSG_CMSG_COMPAT	0	/* We never have 32 bit fixups */
 #endif
 
 
-- 
2.25.1

