Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD0E311BD2
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 08:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBFHCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 02:02:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBFHCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 02:02:49 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8626C06174A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 23:02:08 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id s23so6126081pgh.11
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 23:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uK0ExnzD817hnfzMoozq09+P6+3Fen0JJ4OpWDxjWR8=;
        b=BIalWWMNwaiuokocQspXBDV62gzvqaipoZHnppQadth6d84bUWflTbB32wrQrw+5Zv
         HqxR1yKKGRhWwGVoIQsmpfAYzCwOuwVU4WTjWxkoFhxXxVPQhN3kHjZj+DX1+1Wieg3y
         KpiIwUEwltJd0QqpdIkUdyo4xzj0/661CRe81c1OqPD5b7L8SAWCkL2pfG1AomIY2lri
         9nG9DyZg8TjCzvEu0cHeG4RaX5dIWgrjRFVrLSN/L4Jb7S2yQeliub5lG1CTqRvL1cks
         +7ByPnvYjnE3uKZlU09wJD1ba7IRXbjxpPeUYsX/TJwOrOq35JRR2lTSp4s/RJua/7yi
         nkbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uK0ExnzD817hnfzMoozq09+P6+3Fen0JJ4OpWDxjWR8=;
        b=nDcV+sUq96KrbVDIKH1V4WfsS3EPEwYUB/e/A/0JqJpkOkqGzftX8G/YxKapAt4IQy
         QwFd1KK5rlMzh+WllyzWrUL10xSxYs6aXur/TAi6G8JNgCCjv70qRu4cF4PX2gKgzHB8
         zgRfa1LTagqO8itaLvSAlR4+aEsrnj62NWqe+51enAg3lDSpf5vYaoteOuR8rMXtlGcy
         vvZdDB5gwnx7W5NfBT+ROiWKC7DTMzt5H8DGh2soeoEyU0+mB1a/t3nMBsYqHlpfbPZV
         kgPDGiOFPubmz44XFALwQVn2KnOfn6A7scKTbwfU+tYr4w0F0ENYqBkqNmgV06Tcdeed
         W/eA==
X-Gm-Message-State: AOAM532zhvhlQZPYh1DtR6vvpkmbOe6mcYir54cxgTpMEJUI1R6TBku1
        CzSQhJW2Rx5zlsXiy6d6bSE=
X-Google-Smtp-Source: ABdhPJzDpwcLXsX8OxQwmTzHOCZ4QXPnJKvuBvX0998z0f2Xp1dbyxqj69fqge1E0z1uRJGqX9LTEg==
X-Received: by 2002:a63:1d47:: with SMTP id d7mr8390245pgm.251.1612594928363;
        Fri, 05 Feb 2021 23:02:08 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:7c0b:39c9:2d6b:c893])
        by smtp.gmail.com with ESMTPSA id u31sm14070897pgl.9.2021.02.05.23.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 23:02:07 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net v2] tcp: Explicitly mark reserved field in tcp_zerocopy_receive args.
Date:   Fri,  5 Feb 2021 23:02:03 -0800
Message-Id: <20210206070203.483362-1-arjunroy.kdev@gmail.com>
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
index e1a17c6b473c..c8469c579ed8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		}
 		if (copy_from_user(&zc, optval, len))
 			return -EFAULT;
+		if (zc.reserved)
+			return -EINVAL;
 		lock_sock(sk);
 		err = tcp_zerocopy_receive(sk, &zc, &tss);
 		release_sock(sk);
-- 
2.30.0.478.g8a0d178c01-goog

