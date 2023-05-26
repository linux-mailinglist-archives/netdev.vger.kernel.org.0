Return-Path: <netdev+bounces-5743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6665E7129D4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11A921C210AD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD2D271F5;
	Fri, 26 May 2023 15:43:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA01742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:43:46 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D71C134
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:43:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba81b238ee8so1983574276.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685115824; x=1687707824;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FQoh9ajoSQoocerlSNJVQjWy3Z8lhgiOUjOtV0wUfpQ=;
        b=VgmUVTcPC+eQf7DaVFcvBgIKWTAql2pDQzmlWCOQBZWa9H48KlNi2BnpQ330rHYrsg
         wyD7KCwpQFQmnc04ack1Th4cxju19Qzwrma/Trm36V6KVX/XusiBQk4NQkmg1s7ou9hO
         NZaKO7z3eIDl1NMvD0cmbmLOoJOV8Pgmm5xOgLFygdRFESmxijG7QpD/zbdo31aP2p68
         Q0nV3qn+AXBWWtGD+02kAyjvxjmNtU/idrjMtDV54eNJtOn5TxdMmDgXh0S4xjHC6S7G
         4Hy8WIPC147L5VULNma5o8uoKp1B2F2K00LbTMUXmLNgh6kVvk+9ctrUsDt7j0B0r4W7
         WmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685115824; x=1687707824;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FQoh9ajoSQoocerlSNJVQjWy3Z8lhgiOUjOtV0wUfpQ=;
        b=eZPhc0/WExa6VMoApF19Qnw3FIkYMCBVzsq/O6bAGVLoJnq1n8YRu7kpbXm6rBPTqu
         H6+h5vGnqxOnzAONQbAyDYOVVrH9f5QWD1NWAqhIavMP2e8CUsSDgos2JxuWtQ7lmHwi
         VY+bLT004vguSBBtbqZ8KRRMxcoVfGNp8FzJeP2qg0EQGDSjfygUM/5ow1M0Knx11r4t
         xkjUXivrcH+uVCkCYriQTlDlAKmBaUpimR/UPYUvKW064zsyWeGHOOtf+wSpsWsOlYWL
         Wtohggbv2ggaJ6IUeu8i7hvwt5DkOMd6vRlHo1DL/p2RAUQ3zWYDtsi8WcdX53mjOeSK
         NiBA==
X-Gm-Message-State: AC+VfDwFFTQckxaC7BXnUGBI1eDChtfUjT0WK9U9cmRHUo+kdCFwp+No
	/FyBWWSwLF9R7ywOdDm0pnSc6rTv57LbGw==
X-Google-Smtp-Source: ACHHUZ4/XP5Bf3ulncs2nPqu39aQJTa0D3QTmEfRuGdjz4ZAw9LiLQ3FPJTYqWFzAxw2iW9fPwD0EKJE6KoCtA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d88c:0:b0:bac:adb8:a605 with SMTP id
 p134-20020a25d88c000000b00bacadb8a605mr817913ybg.2.1685115823862; Fri, 26 May
 2023 08:43:43 -0700 (PDT)
Date: Fri, 26 May 2023 15:43:42 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230526154342.2533026-1-edumazet@google.com>
Subject: [PATCH net] af_packet: do not use READ_ONCE() in packet_bind()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

A recent patch added READ_ONCE() in packet_bind() and packet_bind_spkt()

This is better handled by reading pkt_sk(sk)->num later
in packet_do_bind() while appropriate lock is held.

READ_ONCE() in writers are often an evidence of something being wrong.

Fixes: 822b5a1c17df ("af_packet: Fix data-races of pkt_sk(sk)->num.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/packet/af_packet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a1f9a0e9f3c8a72e5a95f96473b7b6c63f893935..a2dbeb264f260e5b8923ece9aac99fe19ddfeb62 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3201,6 +3201,9 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 
 	lock_sock(sk);
 	spin_lock(&po->bind_lock);
+	if (!proto)
+		proto = po->num;
+
 	rcu_read_lock();
 
 	if (po->fanout) {
@@ -3299,7 +3302,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
 	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
 	name[sizeof(uaddr->sa_data_min)] = 0;
 
-	return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
+	return packet_do_bind(sk, name, 0, 0);
 }
 
 static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
@@ -3316,8 +3319,7 @@ static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len
 	if (sll->sll_family != AF_PACKET)
 		return -EINVAL;
 
-	return packet_do_bind(sk, NULL, sll->sll_ifindex,
-			      sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->num));
+	return packet_do_bind(sk, NULL, sll->sll_ifindex, sll->sll_protocol);
 }
 
 static struct proto packet_proto = {
-- 
2.41.0.rc0.172.g3f132b7071-goog


