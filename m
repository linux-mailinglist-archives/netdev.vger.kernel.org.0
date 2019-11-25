Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F221095EE
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfKYXJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:09:48 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41242 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfKYXJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:09:47 -0500
Received: by mail-pg1-f194.google.com with SMTP id 207so7946654pge.8
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 15:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G0cPyC006hnvLt+vhRMpzYR5TfT6GaLflCtS07u8efA=;
        b=h6fbGlyIkP8nO/BoM5xdZ9hsIq3bUfYcrqcGtgRCzgigiEmhtmP2AuKqkbX8jbrNaq
         VcG2d7eIi5d8D9tQzdh6/chck/bjuNw0NCZsGQ56fwQoXqxYaMmpmO1bmwdvrKoaJovR
         7eJs/4g5BLZpDomF/1mSHH8zJ3PtE7e0UCSEyNlKnYCVtFgRncHIJa/Ckb3ZK1vMPE8F
         COCMp/SlQIhUOeKzmrWV33Tpd0MLBIVMybW0/dyydmz2E9u1AMsKLG9AlDdYT9xzj4di
         K/AIf/6+9daStqahJfUtEct7XJKQqeQQjtvUYLhNcwCepLC5a35Sbi9iNxVI6m9evqY/
         pMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G0cPyC006hnvLt+vhRMpzYR5TfT6GaLflCtS07u8efA=;
        b=h/mLEIi8dhKRlapGlgsezrS8DUfzVjUtNY46ZMrfvFj3L5l5qzvEmZXVngvFnY2nlF
         StQLUr0ychm8iU7mbSsiedO0or1IOgKyLs6NM4MvGd7FczIWWqDWfZYELs/T5n00jE4V
         AjB/kXCZlQ3aq+nh0LLmz4lXPGAuRvXWNx8qbMGQe5Gd9KK78sEJkbsEQ40THm+LcT+y
         iPYm08bnj/AwkgwCGBzwLp1O27SIrgR8bL/hmjRLTMJMlRo6tM0tECpucLx7EB9NmPcj
         0COezIZEFVs9sFdU4Qg4Sh1Q/H292p0L+DthMaoItMFEN7fJREuPkdjep5kLDwY40Qml
         NWMw==
X-Gm-Message-State: APjAAAUsEZ6FV++BKmHToGuhqT3SOHFbuTEpjShN96ytAr9YIu1NUqJ9
        KxWlc/eFZUDKcsw199OKz9AhRZUi
X-Google-Smtp-Source: APXvYqyh1seExqhD9fcWMcf0P6sodLKgpMnxHByFEz4yG55PRmq0a2r2iLtaNgw1vD3FBkd8lqENXA==
X-Received: by 2002:a65:6906:: with SMTP id s6mr18719779pgq.26.1574723386786;
        Mon, 25 Nov 2019 15:09:46 -0800 (PST)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id u20sm9716324pgo.50.2019.11.25.15.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 15:09:45 -0800 (PST)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2] net-sctp: replace some sock_net(sk) with just 'net'
Date:   Mon, 25 Nov 2019 15:09:37 -0800
Message-Id: <20191125230937.172098-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <20191125.105022.2027962925589066709.davem@davemloft.net>
References: <20191125.105022.2027962925589066709.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

It already existed in part of the function, but move it
to a higher level and use it consistently throughout.

Safe since sk is never written to.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 net/sctp/socket.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 83e4ca1fabda..e4c398db07a0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8267,6 +8267,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 	struct sctp_sock *sp = sctp_sk(sk);
 	bool reuse = (sk->sk_reuse || sp->reuse);
 	struct sctp_bind_hashbucket *head; /* hash list */
+	struct net *net = sock_net(sk);
 	kuid_t uid = sock_i_uid(sk);
 	struct sctp_bind_bucket *pp;
 	unsigned short snum;
@@ -8282,7 +8283,6 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		/* Search for an available port. */
 		int low, high, remaining, index;
 		unsigned int rover;
-		struct net *net = sock_net(sk);
 
 		inet_get_local_port_range(net, &low, &high);
 		remaining = (high - low) + 1;
@@ -8294,12 +8294,12 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 				rover = low;
 			if (inet_is_local_reserved_port(net, rover))
 				continue;
-			index = sctp_phashfn(sock_net(sk), rover);
+			index = sctp_phashfn(net, rover);
 			head = &sctp_port_hashtable[index];
 			spin_lock(&head->lock);
 			sctp_for_each_hentry(pp, &head->chain)
 				if ((pp->port == rover) &&
-				    net_eq(sock_net(sk), pp->net))
+				    net_eq(net, pp->net))
 					goto next;
 			break;
 		next:
@@ -8323,10 +8323,10 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 		 * to the port number (snum) - we detect that with the
 		 * port iterator, pp being NULL.
 		 */
-		head = &sctp_port_hashtable[sctp_phashfn(sock_net(sk), snum)];
+		head = &sctp_port_hashtable[sctp_phashfn(net, snum)];
 		spin_lock(&head->lock);
 		sctp_for_each_hentry(pp, &head->chain) {
-			if ((pp->port == snum) && net_eq(pp->net, sock_net(sk)))
+			if ((pp->port == snum) && net_eq(pp->net, net))
 				goto pp_found;
 		}
 	}
@@ -8382,7 +8382,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 pp_not_found:
 	/* If there was a hash table miss, create a new port.  */
 	ret = 1;
-	if (!pp && !(pp = sctp_bucket_create(head, sock_net(sk), snum)))
+	if (!pp && !(pp = sctp_bucket_create(head, net, snum)))
 		goto fail_unlock;
 
 	/* In either case (hit or miss), make sure fastreuse is 1 only
-- 
2.24.0.432.g9d3f5f5b63-goog

