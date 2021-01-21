Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E842FDEE0
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387719AbhAUA6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 19:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729055AbhAUAmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 19:42:38 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EF1C061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 16:41:58 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id p18so112854pgm.11
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 16:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tIG+7sNMOvHVi0UngzbEgibZomTCjpwqfmxfWQUZQ6k=;
        b=Mf8P8woqYbkIh+3DL8+AxevSOwSoaNIOwn48WBAmd3P8ubBbjzqVZAmfE+TTVYde6E
         llNi/AU7jfKmBl5QZvGGOg1eisTjMKISidqt0ufe6PvSgOsIrv4adOERByGliL6GXe6r
         wNc6frb+NPkL3ih3+nJ2Ika46xR2aYbidkUNkWyXa5spnBqIzwxW7gktJgTY8BSKHQnQ
         7L3RGIojwptKdNYDHpzdkIzR7r6l3//kLq1QrC21Y/+Gc5VOFUOnS+MlwzjGYUd9VR6G
         64AYCCv3aKEoxsvRDA7IBx7ah149yNklGK+5BMfPlyZH3TPLWunsa7t55iNv3qfJFd+2
         Q6YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tIG+7sNMOvHVi0UngzbEgibZomTCjpwqfmxfWQUZQ6k=;
        b=N2WQBU+vLgHnNiob109WwIlDjtWBizM1fhJE+uJ1kQiTOvnr2J+d3BTlHyDHOBKhT5
         hjSwhyHQh7AxAiNQ1nzzFw7rdHshPdEwaep49OjfkRHd4mwE46bWPwUHphwxpm755JKc
         L/AVQwT0L2OluD4XYadhCCHo/YbqQEvgjPUxKrJ8bNhPBUgquIuTykP1dY2aBjomtbtF
         vdlg/ANYf6/ePcBVCbrBe8xDVbEYPWdR7wN1Bqm+cyIGML4Lk6NWdjTAs+xvahxWyO6z
         X+dAs0kN9WiMxgEPDrFCUyeSXT7C77EOQpG4iqHkLv/BIfWwInipAhHjP/HLECJJWtVz
         VO1A==
X-Gm-Message-State: AOAM532z6zdY4xwMH3xEByvzOLgSpMCyUcl0lT7XGZn4NBBf4gngg1gH
        3CWJOOrR4/2/VpV4GzMXung=
X-Google-Smtp-Source: ABdhPJxGYQYYiQn1L5IeSuJpwlxkMfGLOlDTp5naTUW5AKINDWTmyWqSZJdyjZqfwUdY5+YNhc9zLg==
X-Received: by 2002:a65:4781:: with SMTP id e1mr3291025pgs.30.1611189718223;
        Wed, 20 Jan 2021 16:41:58 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f693:9fff:feea:f0b9])
        by smtp.gmail.com with ESMTPSA id a37sm2874646pgm.79.2021.01.20.16.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 16:41:57 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org
Subject: [net-next v2 1/2] tcp: Remove CMSG magic numbers for tcp_recvmsg().
Date:   Wed, 20 Jan 2021 16:41:47 -0800
Message-Id: <20210121004148.2340206-2-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
References: <20210121004148.2340206-1-arjunroy.kdev@gmail.com>
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
gently refactor these magic numbers into enums.

Signed-off-by: Arjun Roy <arjunroy@google.com>
---
 net/ipv4/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 856ae516ac18..28ca6a024f63 100644
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
2.30.0.284.gd98b1dd5eaa7-goog

