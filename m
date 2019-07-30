Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEF47A8C5
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 14:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbfG3MjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 08:39:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33985 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728448AbfG3MjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 08:39:16 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so23783307pgc.1;
        Tue, 30 Jul 2019 05:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=XOpzq4Pk8rHPRc1YdQdhzXolgMILfbPrr3Vf0IayI94=;
        b=SvmPJmYYzkdDGLIzBtYzSr1NZ+tiWvIIJF1xFwL9KdXzonCem/N7n44clrpBqhhayX
         jr+vkuqMz1TD+UCYDOjhDoCPMnhMohtjYcZamIFxDXM9GcCEMiQz9PCthvLwV7ntBp2C
         TzkOhCTQHCfqnQmcWgJl+67o8JwTXV5V8wokUcHDu5RBDoUWyGHsWXf/BuX7qWqqhvHi
         2bzBkAZ4j3gyuAJG+m9/7Z/hl8sz3a9m89gdgGPUgUlcF/cirkXqMnlEs6B8CHThHjrg
         gWkCAVK3oL1ZtZyE3pRTVCJDtuZZZl80wJlds7QuJX+rqv1iSeB74HzJAFk4gky7VoE6
         t5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=XOpzq4Pk8rHPRc1YdQdhzXolgMILfbPrr3Vf0IayI94=;
        b=QwbvD8A4bJUog3Kc8EDd2tjaB9YmQr/+w1QqLb0XwOTMztp8cS7qKlfPRIRm8WLz8E
         +mLGWgqyPJ59S01hJxsjuWO6kPtVPJ2eaY59VynZLAojwfMCAoIV5LTzGu4iwR8mL3+L
         PR87QpA7QsMQRDOIY71q9UchLqz0GVh/tDwGIlw7D8UqoqfOjKL51ObqMEqxbn8MzkAn
         JFZObimpseHQ3y34tzQo/KTv2fKKRm3dmhYZkXMiXeDJHI0QR88qhmUIy8YT91gEuoxF
         uZ+ArLBtCRa8udUr29KE5YwAnXbobbAfgbHHhtkccIOuK5EFzb0xMniOGJwikjzlCEqC
         DwSA==
X-Gm-Message-State: APjAAAV1d047Za6Yf/evBMtycgBqkDYt5A4TW4+1WJ/vFZiui0BTGelM
        bKaHk9+AMgPl5VFVjI3+cMbAY3Vn
X-Google-Smtp-Source: APXvYqzDfsUviACApJv1zhGu1LRzYLlnwX+qGXr45/cTlBwMPlfSRJ1+4Y6Pj3R9Dn2k0935cYwdNA==
X-Received: by 2002:a62:3895:: with SMTP id f143mr41187524pfa.116.1564490354942;
        Tue, 30 Jul 2019 05:39:14 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 124sm67056714pfw.142.2019.07.30.05.39.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 05:39:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 5/5] sctp: factor out sctp_connect_add_peer
Date:   Tue, 30 Jul 2019 20:38:23 +0800
Message-Id: <9c1d65ebe29d85fc50a9bb285797a4449e6dd3a6.1564490276.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <64a624d23fe947a7bd4fe1d66ddb8719e791c284.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
 <bb6e9856c2db0f24b91fb326fbe3c9c013f2459b.1564490276.git.lucien.xin@gmail.com>
 <2fe592e724eee4e9b00097485a5bccf317907874.1564490276.git.lucien.xin@gmail.com>
 <9995f1c75cd5a555fc22ba2ab374890ad1cee470.1564490276.git.lucien.xin@gmail.com>
 <64a624d23fe947a7bd4fe1d66ddb8719e791c284.1564490276.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1564490276.git.lucien.xin@gmail.com>
References: <cover.1564490276.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this function factored out from sctp_sendmsg_new_asoc() and
__sctp_connect(), it adds a peer with the other addr into the
asoc after this asoc is created with the 1st addr.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 76 +++++++++++++++++++++++--------------------------------
 1 file changed, 31 insertions(+), 45 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 6f77853..2f7e88c 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -1111,6 +1111,33 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 	return err;
 }
 
+static int sctp_connect_add_peer(struct sctp_association *asoc,
+				 union sctp_addr *daddr, int addr_len)
+{
+	struct sctp_endpoint *ep = asoc->ep;
+	struct sctp_association *old;
+	struct sctp_transport *t;
+	int err;
+
+	err = sctp_verify_addr(ep->base.sk, daddr, addr_len);
+	if (err)
+		return err;
+
+	old = sctp_endpoint_lookup_assoc(ep, daddr, &t);
+	if (old && old != asoc)
+		return old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
+							    : -EALREADY;
+
+	if (sctp_endpoint_is_peeled_off(ep, daddr))
+		return -EADDRNOTAVAIL;
+
+	t = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL, SCTP_UNKNOWN);
+	if (!t)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /* __sctp_connect(struct sock* sk, struct sockaddr *kaddrs, int addrs_size)
  *
  * Common routine for handling connect() and sctp_connectx().
@@ -1119,10 +1146,10 @@ static int sctp_connect_new_asoc(struct sctp_endpoint *ep,
 static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 			  int addrs_size, int flags, sctp_assoc_t *assoc_id)
 {
-	struct sctp_association *old, *asoc;
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 	struct sctp_transport *transport;
+	struct sctp_association *asoc;
 	void *addr_buf = kaddrs;
 	union sctp_addr *daddr;
 	struct sctp_af *af;
@@ -1167,29 +1194,10 @@ static int __sctp_connect(struct sock *sk, struct sockaddr *kaddrs,
 		if (asoc->peer.port != ntohs(daddr->v4.sin_port))
 			goto out_free;
 
-		err = sctp_verify_addr(sk, daddr, af->sockaddr_len);
+		err = sctp_connect_add_peer(asoc, daddr, af->sockaddr_len);
 		if (err)
 			goto out_free;
 
-		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
-		if (old && old != asoc) {
-			err = old->state >= SCTP_STATE_ESTABLISHED ? -EISCONN
-								   : -EALREADY;
-			goto out_free;
-		}
-
-		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
-			err = -EADDRNOTAVAIL;
-			goto out_free;
-		}
-
-		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
-						SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
-			goto out_free;
-		}
-
 		addr_buf  += af->sockaddr_len;
 		walk_size += af->sockaddr_len;
 	}
@@ -1683,8 +1691,6 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 
 	/* sendv addr list parse */
 	for_each_cmsghdr(cmsg, cmsgs->addrs_msg) {
-		struct sctp_transport *transport;
-		struct sctp_association *old;
 		union sctp_addr _daddr;
 		int dlen;
 
@@ -1718,30 +1724,10 @@ static int sctp_sendmsg_new_asoc(struct sock *sk, __u16 sflags,
 			daddr->v6.sin6_port = htons(asoc->peer.port);
 			memcpy(&daddr->v6.sin6_addr, CMSG_DATA(cmsg), dlen);
 		}
-		err = sctp_verify_addr(sk, daddr, sizeof(*daddr));
-		if (err)
-			goto free;
-
-		old = sctp_endpoint_lookup_assoc(ep, daddr, &transport);
-		if (old && old != asoc) {
-			if (old->state >= SCTP_STATE_ESTABLISHED)
-				err = -EISCONN;
-			else
-				err = -EALREADY;
-			goto free;
-		}
 
-		if (sctp_endpoint_is_peeled_off(ep, daddr)) {
-			err = -EADDRNOTAVAIL;
-			goto free;
-		}
-
-		transport = sctp_assoc_add_peer(asoc, daddr, GFP_KERNEL,
-						SCTP_UNKNOWN);
-		if (!transport) {
-			err = -ENOMEM;
+		err = sctp_connect_add_peer(asoc, daddr, sizeof(*daddr));
+		if (err)
 			goto free;
-		}
 	}
 
 	return 0;
-- 
2.1.0

