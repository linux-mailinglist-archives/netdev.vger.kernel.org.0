Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E82370F3E
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhEBVMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbhEBVMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 17:12:51 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC76C06174A;
        Sun,  2 May 2021 14:12:00 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id p12so2326383pgj.10;
        Sun, 02 May 2021 14:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=fDNxOY+/09Nl9KfuVzTsfsTgmcyaSu6t9/8XNUyUuFo=;
        b=RQbGtj4EbLLSBZJ4+DigeYXzy1U++mVcvluqGiVVJ8Kwkefm4pn5/TsPy28CtrzQPL
         vuTV3hrnjRcGJqc2g8N1cTf9m4LYJgt3nIIFdOlnjrG1m9VU9SHYbjeGHFlfcytI0wr7
         76sGsll33jts8/CwxCXTSZ7N8zqzL5S48pwypxMJliYqPXcPFIxKppFOerAaK6PhyjjK
         9zdUY6HoN+eSavbTwS3dRUpWDu+ehDI1hpN0vOtg9oqUd4ac1nZtY3+a6O5tV/Utg/9x
         +31ewdxZwwSN+YwxgKJjv7P9PuDMwb+WLtlyFP/oQ1dPgJwlvgAQVVnaaH/JTFTV9KIB
         EXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=fDNxOY+/09Nl9KfuVzTsfsTgmcyaSu6t9/8XNUyUuFo=;
        b=Aa6vBR3+ASCUnmmQSetqIv6P6sbpTvv+zcgz3Z3s2+qocZfZ94HyetEn/fxYACqgHw
         YkHgLsj0doItJBaU3kAcG/uYFJOGZv/wbbDPLloQNXGmVuR4zHn5n23s+f+ZgH0WwAzk
         DfXV0n7WBYsYaCoGZL+46kj2yWMxjPcsx72YtxtGyIzJqwK3i7DxHxa1q1XTMa3Rv/W3
         kbTDZsenZ0YEpz/2DRMggSVVo4HgEqDKtyjt9nVD3b2nHnaGs+Lx4t3q2Akk6kgT160z
         KkI6lTD9lHIymW3/CbLmzbmTzth1Wtgxgv68958RGwN9C+98NLlXZ6VHKUWdVx+60JDA
         5mlA==
X-Gm-Message-State: AOAM532/lcjPIh7CrPZOEptaXne3qK/6csC7SA7fLd5rcqXb/gI5R64r
        Xx1jim7m3FlHxWf8btcAgJGbfNeSpYZk7X1K
X-Google-Smtp-Source: ABdhPJwLrQQZHA4vVnleLKlDDUuYmZ4uMjJntClNXlBJUA36nN5LStZcPDKg9Zo9R6WWjnKJjE1gfg==
X-Received: by 2002:a63:2c14:: with SMTP id s20mr14887638pgs.72.1619989919274;
        Sun, 02 May 2021 14:11:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b13sm7680573pjl.38.2021.05.02.14.11.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 14:11:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH net 1/2] Revert "net/sctp: fix race condition in sctp_destroy_sock"
Date:   Mon,  3 May 2021 05:11:41 +0800
Message-Id: <4dc7d7dd4bcf7122604ccb52a5c747c3fb9101c5.1619989856.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1619989856.git.lucien.xin@gmail.com>
References: <cover.1619989856.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1619989856.git.lucien.xin@gmail.com>
References: <cover.1619989856.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b166a20b07382b8bc1dcee2a448715c9c2c81b5b.

This one has to be reverted as it introduced a dead lock, as
syzbot reported:

       CPU0                    CPU1
       ----                    ----
  lock(&net->sctp.addr_wq_lock);
                               lock(slock-AF_INET6);
                               lock(&net->sctp.addr_wq_lock);
  lock(slock-AF_INET6);

CPU0 is the thread of sctp_addr_wq_timeout_handler(), and CPU1
is that of sctp_close().

The original issue this commit fixed will be fixed in the next
patch.

Reported-by: syzbot+959223586843e69a2674@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index b7b9013..76a388b5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1520,9 +1520,11 @@ static void sctp_close(struct sock *sk, long timeout)
 
 	/* Supposedly, no process has access to the socket, but
 	 * the net layers still may.
+	 * Also, sctp_destroy_sock() needs to be called with addr_wq_lock
+	 * held and that should be grabbed before socket lock.
 	 */
-	local_bh_disable();
-	bh_lock_sock(sk);
+	spin_lock_bh(&net->sctp.addr_wq_lock);
+	bh_lock_sock_nested(sk);
 
 	/* Hold the sock, since sk_common_release() will put sock_put()
 	 * and we have just a little more cleanup.
@@ -1531,7 +1533,7 @@ static void sctp_close(struct sock *sk, long timeout)
 	sk_common_release(sk);
 
 	bh_unlock_sock(sk);
-	local_bh_enable();
+	spin_unlock_bh(&net->sctp.addr_wq_lock);
 
 	sock_put(sk);
 
@@ -4991,6 +4993,9 @@ static int sctp_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sock_prot_inuse_add(net, sk->sk_prot, 1);
 
+	/* Nothing can fail after this block, otherwise
+	 * sctp_destroy_sock() will be called without addr_wq_lock held
+	 */
 	if (net->sctp.default_auto_asconf) {
 		spin_lock(&sock_net(sk)->sctp.addr_wq_lock);
 		list_add_tail(&sp->auto_asconf_list,
@@ -5025,9 +5030,7 @@ static void sctp_destroy_sock(struct sock *sk)
 
 	if (sp->do_auto_asconf) {
 		sp->do_auto_asconf = 0;
-		spin_lock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 		list_del(&sp->auto_asconf_list);
-		spin_unlock_bh(&sock_net(sk)->sctp.addr_wq_lock);
 	}
 	sctp_endpoint_free(sp->ep);
 	local_bh_disable();
-- 
2.1.0

