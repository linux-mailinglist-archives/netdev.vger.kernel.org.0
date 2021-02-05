Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9315D311929
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhBFC4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhBFCsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:48:24 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CE1C0698C2
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 15:01:42 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t25so5597428pga.2
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 15:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d67BDzWYyAITe7f+GNbr1RScjWjDqo1aWGCEyXk/nnU=;
        b=Jtsp4OWv9dyFlObzhsuk3jqtCSHIoWzQXW3nVmXMg8cr2nvfMfIRwdQA50qIqYUuLG
         hZ15jPLLufwCLHh1xjJD2A4EWJ6bFf8elpQetBU4q9BNPJgJ8+UzvI9NyRhr7c0Ktu7R
         wBz+LwmrNUYK0Qb+OIcZ8eWb3KrPtO4X3UXbQxPhmeMdrbDlIv81qFe3Im7AeZuwyJsT
         E2ilYMlb2oZ0U1KgARpDjQPbKbmT9kI/J2UoyOtT/aIZD5sSVlzTSoOs06EHz7LNFOhk
         ss6ZFucDQ3TusBYFjAJ7M9srHKRQvkR1p7IokpGIuS6sV5S3qvSWNpGXIEIgSLcqSTst
         PCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d67BDzWYyAITe7f+GNbr1RScjWjDqo1aWGCEyXk/nnU=;
        b=Xh02t2GZcONnDkrT7YUwtUBszbqmPS2Ao8oAR0EmL644yV5G+WyBqrGyfmd/pNDjAb
         jtsQ68xjW8aD5opgczDd+z5/D26wCTPcNNj8TIXeJGgeNaNl6D4bQ2vBDjwlWSPLO1Cc
         KZIzBVEa2tyvcXTzMeNt7URpJdD+A1M32QdzQ8+/FcBiZzMAbSnyW0CASJl7s9xI/MKt
         a9N/g7OJZoDiTNu62TnFYmTQ5Td3UsZlrCvaeRokyK0jgN7f8837bAFHzaS6jIN/tlGN
         5LLQNnlH8hwRfLNhbzV07+NYXfWf04+uNvqZH5fJuOChw1sPfJnQ6OAKWSWCr5SEkYyY
         qmuw==
X-Gm-Message-State: AOAM533xRjeUFDpJhkZWGIdK/nLhnN0Y7OFLVE68795yMXtXS9LVF9OB
        oxfk/Q3NPNSzYK/JsR5UKZA=
X-Google-Smtp-Source: ABdhPJwsgigUWPvy64r/VB5ByNCmGqOKOFf8HhmpSMA/wrt74rVqsnyZfCLiqTkdJIkDO/baLABkTg==
X-Received: by 2002:aa7:94b5:0:b029:1d7:f868:e48d with SMTP id a21-20020aa794b50000b02901d7f868e48dmr4799258pfl.9.1612566101837;
        Fri, 05 Feb 2021 15:01:41 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:7c0b:39c9:2d6b:c893])
        by smtp.gmail.com with ESMTPSA id k11sm9929018pfc.22.2021.02.05.15.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 15:01:41 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net] tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
Date:   Fri,  5 Feb 2021 15:01:27 -0800
Message-Id: <20210205230127.310521-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

Explicitly define reserved field and require it to be 0-valued.

Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Suggested-by: David Ahern <dsahern@gmail.com>
Suggested-by: Leon Romanovsky <leon@kernel.org>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/tcp.h | 2 +-
 net/ipv4/tcp.c           | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 42fc5a640df4..8fc09e8638b3 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
 	__u64 msg_control; /* ancillary data */
 	__u64 msg_controllen;
 	__u32 msg_flags;
-	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
+	__u32 reserved; /* set to 0 for now */
 };
 #endif /* _UAPI_LINUX_TCP_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e1a17c6b473c..97aee57ab9b4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		}
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
+		if (zc.reserved)
+			return -EOPNOTSUPP;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc, &tss);
 		release_sock(sk);
-- 
2.30.0.478.g8a0d178c01-goog

