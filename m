Return-Path: <netdev+bounces-3915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 198D0709862
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:34:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021621C21251
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500EEDDD5;
	Fri, 19 May 2023 13:34:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F6C6DDD2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:34:22 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC955C2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:34:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-96f683e8855so103005066b.2
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684503259; x=1687095259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKg0AFt/2baDk2QwOs1gDGEvUDueTmQNCWQTAs1fOBA=;
        b=iAKPH7FI6sHFsjAiSB9F8ngNygYgqVilqUxDUm2b3DdB3jFuzAdbccv3IzF8GbNvbV
         KBPPb8I5ICAB7YRDkZRiP6SNhZoK6ApaarLlJ/uSdxaaqwVsb6jRIMwChMTTTnimzNnR
         G1xuiCwiEXMc5obaUPM6odiTn6E6L+1oQYsp4Cg42Dezn128Vm2EBJhK+yxksOtTHFWG
         iwFh5LR5GNgPR/CeYzJKRu0iVKK39G859t0DiRf8GjmpeOtBiyI2xRZr8QYvAJZfm2q5
         QuxY9mZu5+jTEuwbJS9IXQit0Npiru7AvDh9vEwefUXG4lUQIT7gf7BP/UXoK2xgCUOt
         jMew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684503259; x=1687095259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKg0AFt/2baDk2QwOs1gDGEvUDueTmQNCWQTAs1fOBA=;
        b=CDsc4221qbBy2n5leE23/DTMMfl5wiL1fKv28/FgNgMIAIZV6cDWsD7xUBllOkAdUj
         aGLFgDmmaZfOWAPqY8kyDb8ZZ6XsBc9FJXuC+l0xqjZZNRM0/sXcRkBfo8FRg/AE0auC
         rz+cFsZBY42LrMl5Ootnn/U9eMLRvYp7gdIWF9dDxyFmOmW6YtUm9DV1L1UHL4oz9zyh
         6f9sOMakJUN8zU+exg4RPW2k7XWY8SK8Arft3Fbe9S/FHZGWZ7sWVs8Ts7OYfAIrNoNo
         yMSdcYL8tX6rRkLbwcAjrNCM52tNwYO88inGuvGkLCtqwf49cz1cDQY3u4w81fA0FjeD
         +T+g==
X-Gm-Message-State: AC+VfDy3nXEHAr00AzA+02WPgJfRRhSf8N11uYPKeHTw+PzEpyEPg7T8
	i56VgtRFLDDDykmA95FY6rEIu59M4b0=
X-Google-Smtp-Source: ACHHUZ7l2/0w3RytZGN8Ct5ytsd83W/4bYtoNqt7A7x9zw68umY6EE+rHaxqjRza10qU3i2k7r+VIA==
X-Received: by 2002:a17:906:fe45:b0:94a:5d5c:fe6f with SMTP id wz5-20020a170906fe4500b0094a5d5cfe6fmr1570967ejb.47.1684503258793;
        Fri, 19 May 2023 06:34:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a04d])
        by smtp.gmail.com with ESMTPSA id l7-20020a170906938700b00947ed087a2csm2279270ejx.154.2023.05.19.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 06:34:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 1/2] net/tcp: optimise locking for blocking splice
Date: Fri, 19 May 2023 14:33:04 +0100
Message-Id: <a6838ca891ccff2c2407d9232ccd2a46fa3f8989.1684501922.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1684501922.git.asml.silence@gmail.com>
References: <cover.1684501922.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Even when tcp_splice_read() reads all it was asked for, for blocking
sockets it'll release and immediately regrab the socket lock, loop
around and break on the while check.

Check tss.len right after we adjust it, and return if we're done.
That saves us one release_sock(); lock_sock(); pair per successful
blocking splice read.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4d6392c16b7a..bf7627f37e69 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -789,13 +789,15 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 	 */
 	if (unlikely(*ppos))
 		return -ESPIPE;
+	if (unlikely(!tss.len))
+		return 0;
 
 	ret = spliced = 0;
 
 	lock_sock(sk);
 
 	timeo = sock_rcvtimeo(sk, sock->file->f_flags & O_NONBLOCK);
-	while (tss.len) {
+	while (true) {
 		ret = __tcp_splice_read(sk, &tss);
 		if (ret < 0)
 			break;
@@ -835,10 +837,10 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 			}
 			continue;
 		}
-		tss.len -= ret;
 		spliced += ret;
+		tss.len -= ret;
 
-		if (!timeo)
+		if (!tss.len || !timeo)
 			break;
 		release_sock(sk);
 		lock_sock(sk);
-- 
2.40.0


