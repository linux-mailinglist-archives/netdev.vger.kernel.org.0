Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A813B115B
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 03:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhFWBfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 21:35:10 -0400
Received: from m12-14.163.com ([220.181.12.14]:37576 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhFWBfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 21:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=PSmR4
        fAzMrnWcLxhcj8pQXBA+gGfkgbzypjD+WIgSik=; b=XwYq1qJ2tz/zlCxo7EX8V
        QEVR6e4h2PMN0319bXEw3jRfGZCRWniJIRXXn01Io+dYFgFZ0ti5B8672TsztSXk
        5FCz/fq6bu0lu3MohEavvr4nsysJi/kMcZBPfU6W5eqbgvoLAsHRu8ZuvkdbJbW/
        Y1Pldbt83HwBp2Ib6S0580=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowADnkjA8j9JgI6tOQQ--.24970S2;
        Wed, 23 Jun 2021 09:32:45 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: caif: add a return statement
Date:   Tue, 22 Jun 2021 18:32:38 -0700
Message-Id: <20210623013238.9204-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowADnkjA8j9JgI6tOQQ--.24970S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFyUCF4rCF47WF4rAr1DJrb_yoW8ArWUpF
        sYqF9rCr4kJr1UWwsIqFW0vF1Fyrykt3y7Gas7Ja4fW398Cr98Z39YyF4F9w4UZrs8C3W3
        Wr4q9F1vvwn3Z3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bo7KsUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiyh26g1QHMfNtsAAAsi
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Return statement is needed in every condition in Int function.
Fixed some grammar issues.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/caif/caif_socket.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 3ad0a1df6712..84a00b9cb0dc 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -281,7 +281,7 @@ static int caif_seqpkt_recvmsg(struct socket *sock, struct msghdr *m,
 	if (flags & MSG_OOB)
 		goto read_error;
 
-	skb = skb_recv_datagram(sk, flags, 0 , &ret);
+	skb = skb_recv_datagram(sk, flags, 0, &ret);
 	if (!skb)
 		goto read_error;
 	copylen = skb->len;
@@ -295,6 +295,7 @@ static int caif_seqpkt_recvmsg(struct socket *sock, struct msghdr *m,
 		goto out_free;
 
 	ret = (flags & MSG_TRUNC) ? skb->len : copylen;
+	return ret;
 out_free:
 	skb_free_datagram(sk, skb);
 	caif_check_flow_release(sk);
@@ -615,7 +616,7 @@ static int caif_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	while (sent < len) {
 
-		size = len-sent;
+		size = len - sent;
 
 		if (size > cf_sk->maxframe)
 			size = cf_sk->maxframe;
@@ -815,8 +816,8 @@ static int caif_connect(struct socket *sock, struct sockaddr *uaddr,
 	sock->state = SS_CONNECTING;
 	sk->sk_state = CAIF_CONNECTING;
 
-	/* Check priority value comming from socket */
-	/* if priority value is out of range it will be ajusted */
+	/* Check priority value coming from socket */
+	/* if priority value is out of range it will be adjusted */
 	if (cf_sk->sk.sk_priority > CAIF_PRIO_MAX)
 		cf_sk->conn_req.priority = CAIF_PRIO_MAX;
 	else if (cf_sk->sk.sk_priority < CAIF_PRIO_MIN)
-- 
2.25.1

