Return-Path: <netdev+bounces-3916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2911D709864
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:35:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9C96281C98
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D6F2DDDF;
	Fri, 19 May 2023 13:34:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC6DDD2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:34:23 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E27B12C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:34:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-96f850b32caso6054966b.3
        for <netdev@vger.kernel.org>; Fri, 19 May 2023 06:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684503260; x=1687095260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd+XFWzERIuNvnwKCj7UX3DHrtWrVL2BPTWeu2EKRas=;
        b=CIWT6L5Mh2pPJIiJWEGFcjrDPFYbUjF7oO2hB+UPwGC6rXCny43PE9G0O1/IdJaXEH
         VoDHRcbo4YcKaRhB7cBpU4JgLa0kQnciIJ0vZP9jzsFffML+9Q3p8qEfQ/e/T3/TxVIV
         v+Woe80Lw17i5DFVIp6AqaV0huJeq7Nmh9V6+fL58OxFW21RQBPbS/3nU7t46CFMFTAX
         4Wc7S9YtLfCwHTuOjS0b8KbUL0tv6KBCUsoynoVELqHqGyIeYyYJ7oa1FneJ20jZqHzZ
         2rSyM85+PL6DxzhWHrozG81QJLg9y9imsVm7uyQLJ5LKowTkojmDlsuIGafCUuLhtgwb
         2AKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684503260; x=1687095260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd+XFWzERIuNvnwKCj7UX3DHrtWrVL2BPTWeu2EKRas=;
        b=GgPBHuqqeEvSk14TMPFkP8B25uNeLDWgGS8MnkF5LZS7ed9iL6/GCdozgzdEG1eVzF
         hpqItc87kGYyZ7se6LpNnF0vIgHC8Fa2lhxXF49c8IZY9Yi5c3d26H57LPkuzS+ZqHRQ
         77ADgSUtRzgiaKsLEAfaPWPBpGPELyreBwdsiBmt4N6snVTtg4YXSgrV94R2ZKBHoKQi
         beC2LMaGlfY0/TmCgWdZhY8xpGlHZYDER2LVJ/6QVX35v8GEasPA6eONeCETGedKQexF
         OoqBzzzIIqxdda42YFFmxnhi91g6Mr3pKcBDmK/Lrovq7msQ+HFJ98BRr1T5gGa8NRGS
         QCEQ==
X-Gm-Message-State: AC+VfDwD3PtAhx9IfBTAbtBj4SYGhpF06GwKQ4rsh4jscjvPmk+56/Hq
	zHQPwVnxMZxGWKTgZe/Z9PrUw6UeaiA=
X-Google-Smtp-Source: ACHHUZ7D+Zmu/tN9LHKi3YKtCZ4BYeNgeU6XFojFiNTto7q/KeDPHPkJIZhlmrJ54AYLg/k2Roz+7g==
X-Received: by 2002:a17:907:7da7:b0:96a:e022:6486 with SMTP id oz39-20020a1709077da700b0096ae0226486mr2076119ejc.2.1684503259420;
        Fri, 19 May 2023 06:34:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a04d])
        by smtp.gmail.com with ESMTPSA id l7-20020a170906938700b00947ed087a2csm2279270ejx.154.2023.05.19.06.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 06:34:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: netdev@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 2/2] net/tcp: optimise non error splice paths
Date: Fri, 19 May 2023 14:33:05 +0100
Message-Id: <0ad3bdc1e5e4ccef2ee0b36fb3b068e61b1b1a53.1684501922.git.asml.silence@gmail.com>
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

Move post __tcp_splice_read() error checking inside the "nothing to
read" block. That removes an extra if from the path where it has
successfully spliced some bytes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bf7627f37e69..0139b2c70ed4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -799,9 +799,9 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
 	timeo = sock_rcvtimeo(sk, sock->file->f_flags & O_NONBLOCK);
 	while (true) {
 		ret = __tcp_splice_read(sk, &tss);
-		if (ret < 0)
-			break;
-		else if (!ret) {
+		if (ret <= 0) {
+			if (unlikely(ret < 0))
+				break;
 			if (spliced)
 				break;
 			if (sock_flag(sk, SOCK_DONE))
-- 
2.40.0


