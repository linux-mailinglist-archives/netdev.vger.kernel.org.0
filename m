Return-Path: <netdev+bounces-5044-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B9A70F866
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 610C7280F32
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C9D18B09;
	Wed, 24 May 2023 14:15:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDBE60847
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:15:02 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCFA12E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:14:58 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-556011695d1so18284057b3.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684937698; x=1687529698;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3QpoZ9y5N+ktvZDtvrvSN6vnq4i+JDRJoYjrXy4QMdk=;
        b=MYnLIZUyKdjv2RPom2LqjM9paMRqiqYt4df0wpY5TrzK2CwoIO+6Q33rUphSTvHGQR
         cUNuqiMW+kyoS+oNa32QfHvCGp94zNasK8gCS3IcZmtukuMf5RVI3A4cDzN0pSQhZLlz
         avOlKFHbA0JZMnbtcZ9nPQKupeSBojez4+zw9tP0112/f0woT/RZ//u1anJiRePYsITs
         HfVcRyBmfYXy2DcDOywq4h4AH7pn1k609H2ds/rqSyFCZeqibgSvkVXJzb3uVbbgf3fB
         OiK+wNPlgYyWHFT5hsuK8rkw7ZZeId3xdu79JCjjTuHq7B5fdJRprysGQIjjyYhJ7i+A
         9Lkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684937698; x=1687529698;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3QpoZ9y5N+ktvZDtvrvSN6vnq4i+JDRJoYjrXy4QMdk=;
        b=RCi6qfpOoDSLdbhGl36EwcjwP3C52o7dpqMWqH0kOtXnhKOOPhXUSv/lznySYzWfVd
         mz+Vgp5NqaTocpk2ocrHtSzHR3yqrPWdDiFRf5giJTCufDgYDQY/rFVbL/wiLc9zswG4
         Kxfm2E6JUkYmtQ4iCS1qn9btlbiuQG1c5weEMl5B2itJ3roVGKM2CSM9S9g+knc2/Ioy
         RQ3MrzQAKTpjxXmkDEZK3Tyq5NilXmpY95ibC7MwvoNsG6PbHvmck+rPNQEYOhD0rV5M
         kBQnSKfQESRA4IzzMqHQJnWQQb0T66HqLoIPrZGL/5HaMbW7VSrtKxQ1ruwTy9U/HGuX
         xR7Q==
X-Gm-Message-State: AC+VfDxeSvxGI2IgCIH92v5Qped5gQWlgAo2klyFysRxWKnlAYJb1CrT
	2kLItKCAVJPRKfqoP9zlHrvkV8HOX91nLQ==
X-Google-Smtp-Source: ACHHUZ5Js+WzTer2Ao4PLf0UsLTQ6DVuoYRIMN37+tweA7T7obElzB/n84h1tMYS8c7DNWizmqjDvwJMyspuSA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1895:b0:ba8:4ba3:5b54 with SMTP
 id cj21-20020a056902189500b00ba84ba35b54mr8041225ybb.11.1684937697857; Wed,
 24 May 2023 07:14:57 -0700 (PDT)
Date: Wed, 24 May 2023 14:14:56 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230524141456.1045467-1-edumazet@google.com>
Subject: [PATCH net] netrom: fix info-leak in nr_write_internal()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, Simon Kapadia <szymon@kapadia.pl>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Simon Kapadia reported the following issue:

<quote>

The Online Amateur Radio Community (OARC) has recently been experimenting
with building a nationwide packet network in the UK.
As part of our experimentation, we have been testing out packet on 300bps HF,
and playing with net/rom.  For HF packet at this baud rate you really need
to make sure that your MTU is relatively low; AX.25 suggests a PACLEN of 60,
and a net/rom PACLEN of 40 to go with that.
However the Linux net/rom support didn't work with a low PACLEN;
the mkiss module would truncate packets if you set the PACLEN below about 200 or so, e.g.:

Apr 19 14:00:51 radio kernel: [12985.747310] mkiss: ax1: truncating oversized transmit packet!

This didn't make any sense to me (if the packets are smaller why would they
be truncated?) so I started investigating.
I looked at the packets using ethereal, and found that many were just huge
compared to what I would expect.
A simple net/rom connection request packet had the request and then a bunch
of what appeared to be random data following it:

</quote>

Simon provided a patch that I slightly revised:
Not only we must not use skb_tailroom(), we also do
not want to count NR_NETWORK_LEN twice.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-Developed-by: Simon Kapadia <szymon@kapadia.pl>
Signed-off-by: Simon Kapadia <szymon@kapadia.pl>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Simon Kapadia <szymon@kapadia.pl>
---
 net/netrom/nr_subr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_subr.c b/net/netrom/nr_subr.c
index 3f99b432ea707e20a9620fb89cdf37d5e4f121e9..e2d2af924cff4a4103e59e04a6efe69c6fcca23e 100644
--- a/net/netrom/nr_subr.c
+++ b/net/netrom/nr_subr.c
@@ -123,7 +123,7 @@ void nr_write_internal(struct sock *sk, int frametype)
 	unsigned char  *dptr;
 	int len, timeout;
 
-	len = NR_NETWORK_LEN + NR_TRANSPORT_LEN;
+	len = NR_TRANSPORT_LEN;
 
 	switch (frametype & 0x0F) {
 	case NR_CONNREQ:
@@ -141,7 +141,8 @@ void nr_write_internal(struct sock *sk, int frametype)
 		return;
 	}
 
-	if ((skb = alloc_skb(len, GFP_ATOMIC)) == NULL)
+	skb = alloc_skb(NR_NETWORK_LEN + len, GFP_ATOMIC);
+	if (!skb)
 		return;
 
 	/*
@@ -149,7 +150,7 @@ void nr_write_internal(struct sock *sk, int frametype)
 	 */
 	skb_reserve(skb, NR_NETWORK_LEN);
 
-	dptr = skb_put(skb, skb_tailroom(skb));
+	dptr = skb_put(skb, len);
 
 	switch (frametype & 0x0F) {
 	case NR_CONNREQ:
-- 
2.40.1.698.g37aff9b760-goog


