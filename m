Return-Path: <netdev+bounces-1235-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CF426FCCC3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:31:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE0D81C20BF8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF90417ABB;
	Tue,  9 May 2023 17:31:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3530F9C9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:31:35 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399301BE6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:31:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba6388fb324so65038276.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 10:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683653493; x=1686245493;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jeFrpC9dhguCPI9NCxMv7crlV52sCdyjI04uxtwvfYE=;
        b=6hC1Rx5E9Cnrq8T5/1AyRDQouwqS3Lu++xwf0e7cj9veFnDlPFRa+h7K9xr1qhALfz
         fJ06Modl0qoETvUimTqqE5TYcTdZ+zcBh5/DUVd1+VALO/apm3l1tF+B5+IFibJ87TsO
         N/TTiEoR0fbjgl8KnX056f0rrFVNQQaYuhld6aU62ZOU70SxzR1Y4S0SS7ylMDs132ko
         WWQgC7DsS7VsoSw1+8RNnRiqx/MQmyvZZ5AjS9U5hW2pb5V7pH8FDBszeurnDmk2cGn4
         x80THaiI8T9FyHMkTstFNrOXGWgePYqiNEBj47aonU8p02LYHNDR3xy2y6Ogr0JuSK0t
         ZKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683653493; x=1686245493;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jeFrpC9dhguCPI9NCxMv7crlV52sCdyjI04uxtwvfYE=;
        b=SseRr5iVAeFVWqiyGKDMqtZmo3dafVtCTFI+Gap1w4vFiSV8c9zWCS5e3cqo+RKd4J
         7J/877kIgqKjTzH+6gxBi8owMLXIXtyDbogvpwqmn1q3wWwkKv7gHyuqQ1tnwwAueqe4
         ivcwHDJFepB5VM5c4nlqVk0MmgSPMiU7Bs5xPc7tTzwS7PuLvMoKIZ1G6VFPk1qYGYuv
         9j3xdXrQKelepbSA9cuV4GBLNEcTIwiueamNI1RlR+YrKTBf4wsOZDeXslp0ZJZpYrL8
         pkgVbW84yRgOGWPwQUOdBAXzD3gNB+oAHJ/W0MnsS/5MuK25yg/Vxv+RPcMU6D3wwgYa
         y3Bw==
X-Gm-Message-State: AC+VfDxS04yx+LMLEB0nGFeaRKlSawrmRDUr4ksLjkvP6wsBduzRc4bz
	VXO5CG6SEom536Txty0Dkj2JMTLdYjFeXQ==
X-Google-Smtp-Source: ACHHUZ7Zk6nA7Po8LRbp73mGKXjDAaeJcRjWLXS9UaVFrUnT+kaKt9HqMxXcYsd91kU4D1VS2CgQHhum9P1fzA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9f02:0:b0:b8f:53e1:64b with SMTP id
 n2-20020a259f02000000b00b8f53e1064bmr6679954ybq.13.1683653493542; Tue, 09 May
 2023 10:31:33 -0700 (PDT)
Date: Tue,  9 May 2023 17:31:31 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509173131.3263780-1-edumazet@google.com>
Subject: [PATCH net] net: datagram: fix data-races in datagram_poll()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

datagram_poll() runs locklessly, we should add READ_ONCE()
annotations while reading sk->sk_err, sk->sk_shutdown and sk->sk_state.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/datagram.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 5662dff3d381a92b271d9cba38a28a6a8478c114..176eb58347461b160890ce2d6b2d3cbc7412e321 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -807,18 +807,21 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask;
+	u8 shutdown;
 
 	sock_poll_wait(file, sock, wait);
 	mask = 0;
 
 	/* exceptional events? */
-	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
+	if (READ_ONCE(sk->sk_err) ||
+	    !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR |
 			(sock_flag(sk, SOCK_SELECT_ERR_QUEUE) ? EPOLLPRI : 0);
 
-	if (sk->sk_shutdown & RCV_SHUTDOWN)
+	shutdown = READ_ONCE(sk->sk_shutdown);
+	if (shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLRDHUP | EPOLLIN | EPOLLRDNORM;
-	if (sk->sk_shutdown == SHUTDOWN_MASK)
+	if (shutdown == SHUTDOWN_MASK)
 		mask |= EPOLLHUP;
 
 	/* readable? */
@@ -827,10 +830,12 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 
 	/* Connection-based need to check for termination and startup */
 	if (connection_based(sk)) {
-		if (sk->sk_state == TCP_CLOSE)
+		int state = READ_ONCE(sk->sk_state);
+
+		if (state == TCP_CLOSE)
 			mask |= EPOLLHUP;
 		/* connection hasn't started yet? */
-		if (sk->sk_state == TCP_SYN_SENT)
+		if (state == TCP_SYN_SENT)
 			return mask;
 	}
 
-- 
2.40.1.521.gf1e218fcd8-goog


