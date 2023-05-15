Return-Path: <netdev+bounces-2694-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EECB1703253
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FCB01C20BD9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66EA4E56F;
	Mon, 15 May 2023 16:08:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56711E552
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:08:45 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE861987;
	Mon, 15 May 2023 09:08:26 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96aadfb19d7so695574566b.2;
        Mon, 15 May 2023 09:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684166870; x=1686758870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p+/KgeGTvYD4VU83ivrKJR5CVNGs2S8SquG6Hadg/og=;
        b=Wzoz++pGy8QtqPwGINL9MTm22bUrl5iQ3dcCvRt9Na/2JcGIbmlL1APBME/r7PqsHw
         439/32CwXE9aBEN7lYst1prB/HQU+onlAhhkPG/L4456/5vXjWNyaMS5l3Y9Pk6il8x+
         2XYs7SbfD6tu2jgkn4SDpJFzqgpSYv8FNwsPQWqF6vxgX0JD/5DJJV7RD6mU08L83JSh
         5i6yWY5TdVDcRVkRUltie9HdFXODPTIDjS5aAzKt82ZvnObkbIwT38B9F/df4n7fFKw8
         zvWoJ7YCS5yLyS+/ixcaYeQpyUbgt9hY07dfFJGraeUyGT0u6LxPfC72/0eTvtd0H9Uh
         8GtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684166870; x=1686758870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+/KgeGTvYD4VU83ivrKJR5CVNGs2S8SquG6Hadg/og=;
        b=itAYb7eO3t9e5bt7HeUWvwyakvt4CvPUyjqTuqp6WaEbYUDLtH36kXK/HmqaAmALjR
         nnLUGFMN0LBlq+2ct8tyI0a+e8uxjNKIP1aiOrSPm6vEJ77TMoOPrYmSd9K+8/oi/Kef
         nKw5F0oEeXvxPOaCe1KLmfvrP6nGW8d6rgLGUVimuTlumxJqDo7kiV/BygqpxsMo3x8I
         q5s/N9qtlDuUsFla8G26hQJ5N//R5lYku37KpvQmZgWd/uuw81pA/rwQZr0fYjNV36xs
         f1lRlWDyESELF0QXXjLpTq0NUX/q/xlRc9SdyZlK9WycWhYsOUWcUSjccDk2Hz6/jVcA
         MUjQ==
X-Gm-Message-State: AC+VfDzHXl01K1o7MLil5v+2Bs3UrthwPF8AiykAP4pfeXdWfEZLEwos
	gPxrtLLKBhPbBkrrYMPwqr1pKFMWwwU=
X-Google-Smtp-Source: ACHHUZ60/UKpwLhdDOryw+hJysiWn2x7FkdlX8wrj2XmC21BXFu/hTtdwYUk37YHqBkXQS99sTdlAg==
X-Received: by 2002:a17:907:26c7:b0:966:5bc0:bfe6 with SMTP id bp7-20020a17090726c700b009665bc0bfe6mr27042525ejc.2.1684166870002;
        Mon, 15 May 2023 09:07:50 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6366])
        by smtp.gmail.com with ESMTPSA id z25-20020a17090674d900b0096ac3e01a35sm4407085ejl.130.2023.05.15.09.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 09:07:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 0/2] minor tcp io_uring zc optimisations
Date: Mon, 15 May 2023 17:06:35 +0100
Message-Id: <cover.1684166247.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

Patch 1 is a simple cleanup, patch 2 gives removes 2 atomics from the
io_uring zc TCP submission path, which yielded extra 0.5% for my
throughput CPU bound tests based on liburing/examples/send-zerocopy.c

Pavel Begunkov (2):
  net/tcp: don't peek at tail for io_uring zc
  net/tcp: optimise io_uring zc ubuf refcounting

 net/ipv4/tcp.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

-- 
2.40.0


