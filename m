Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB15E2D7E4E
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgLKSp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388074AbgLKSpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:45:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FE2C0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:44:39 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id f9so7510657pfc.11
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 10:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mW2zFPNP7G//hkG8ndLKCGmEp9aO230bmkLYm2wC0Co=;
        b=d1sd2QDk4Ah70ps/CqBegW82V9DIP7Kc8m610OSF7V5SblIxNHKRE0/BnDwu97SBuW
         4epe4H8NTc/TwMWRHL8bSPqfFgOqVt6xD5MFp28jonACzcaQE+B97u3dSCjOAXpz9spY
         FhOk9fmYCEEbyB0feKq4i6XudEho0cN9ufpU2vTASy/SqjM2Q3oqYE2h7JCfjXiReFFR
         OphQMfDcCJsR3KyQY5lW5bhKfNnp++Cb5RWmN/twOBp7+5mCdqfATTkjB021Vuask93n
         jd1eOlABzRI0VOF51Jlp8lrCpG2dPiQLXZkzoFQWT6JWPhB5MHlvS0J35pLkRH/Ddc64
         IIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mW2zFPNP7G//hkG8ndLKCGmEp9aO230bmkLYm2wC0Co=;
        b=KZlbosohdHKrjZGGWhv91CTmYVdCQuKg6TAHfogzc9zctaJkavzAu6rXfH63IUGMwn
         U+E4BEKFTHXQiw6wRFxc2mMWB4yNzMb5hi0fGptmnW2NGkO4nJsDIwgQyOv8aVwdo+mF
         BPST3waDRPCrOMBRnYh4CQtJ1eLVICr/YDu/O+N30ADuP/SZYKD2oldWrM/xXTZ6xXzt
         fsz7LDWD+yaqCN9m9x6FredRrmWWU03Xh/UEMeVueZE8gVerJC1dJLV4AvYhV02LaAvZ
         DsKCeQ1V+CBkMkkw/sMFQt/z8F91+15HCfrpBGDT6TGsF132lcAXl20iox5xUv4jFsFI
         QRXw==
X-Gm-Message-State: AOAM530CqT3kgmgMnaHEDuVvkpVVd5s/B10VAHmRvLWMQhiJ/fXhbNjN
        vyxdfy8gzTRInmekR9xume4=
X-Google-Smtp-Source: ABdhPJzOu2FNLZhiKEH4KSuILWscifyHXZzqISVD2UBRt4zv9S5iwrQdXnUx7enC0W8dlAYecy968g==
X-Received: by 2002:a63:802:: with SMTP id 2mr13272044pgi.292.1607712278655;
        Fri, 11 Dec 2020 10:44:38 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id h4sm11783486pgp.8.2020.12.11.10.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 10:44:38 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com
Subject: [net-next 1/2] tcp: Remove CMSG magic numbers for tcp_recvmsg().
Date:   Fri, 11 Dec 2020 10:44:18 -0800
Message-Id: <20201211184419.1271335-2-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
In-Reply-To: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
References: <20201211184419.1271335-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

At present, tcp_recvmsg() uses flags to track if any CMSGs are pending
and what those CMSGs are. These flags are currently magic numbers,
used only within tcp_recvmsg().

To prepare for receive timestamp support in tcp receive zerocopy,
gently refactor these magic numbers into enums. This is purely a
clean-up patch and introduces no change in behaviour.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 net/ipv4/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ed42d2193c5c..d2d9f62dfc88 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -280,6 +280,12 @@
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
 
+/* Track pending CMSGs. */
+enum {
+	TCP_CMSG_INQ = 1,
+	TCP_CMSG_TS = 2
+};
+
 struct percpu_counter tcp_orphan_count;
 EXPORT_SYMBOL_GPL(tcp_orphan_count);
 
@@ -2272,7 +2278,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 		goto out;
 
 	if (tp->recvmsg_inq)
-		*cmsg_flags = 1;
+		*cmsg_flags = TCP_CMSG_INQ;
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	/* Urgent data needs to be handled specially. */
@@ -2453,7 +2459,7 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 
 		if (TCP_SKB_CB(skb)->has_rxtstamp) {
 			tcp_update_recv_tstamps(skb, tss);
-			*cmsg_flags |= 2;
+			*cmsg_flags |= TCP_CMSG_TS;
 		}
 
 		if (used + offset < skb->len)
@@ -2513,9 +2519,9 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 	release_sock(sk);
 
 	if (cmsg_flags && ret >= 0) {
-		if (cmsg_flags & 2)
+		if (cmsg_flags & TCP_CMSG_TS)
 			tcp_recv_timestamp(msg, sk, &tss);
-		if (cmsg_flags & 1) {
+		if (cmsg_flags & TCP_CMSG_INQ) {
 			inq = tcp_inq_hint(sk);
 			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
 		}
-- 
2.29.2.576.ga3fc446d84-goog

