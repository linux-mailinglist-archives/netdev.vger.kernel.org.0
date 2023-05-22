Return-Path: <netdev+bounces-4149-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC21370B5CB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:03:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2B2A1C209CF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2BCE4C6B;
	Mon, 22 May 2023 07:02:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54A163BD
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:02:27 +0000 (UTC)
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034121BFF
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:02:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-253724f6765so3191468a91.3
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 00:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684738915; x=1687330915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1oOKoVyoIUj8JPcN8+63Cdo8i/cPI1zhOYlcZa0hSM=;
        b=enaay0xaoWLn/utKosxoWRmovCC2iDOPsViPWAcSu4/JYlpa61g+2mofypwr36XV6P
         5J3FltcUkPLQkIl0AZJuYxAJtrS6Ks0D8MuZLcveqzNcyyAJqnubyinFllJt+2ys+NkJ
         68YlViqxi2UvNOTwFFXFpMSMLyiRimLE2iWipptXmQyAZXdKBmKATAFkFEQgja08ESC7
         2bKN4+w6r38j+xphjcn508J/X8RhzgKuNcSOUxWHrnOH3iClosHDqVgE0Fl8TVP7ywoO
         W8xflpGtFM3isY8piNeZ98x693UPRt6aX4eeOCZnFll7sC9O0u1+a2pAmnLNHXwULg9U
         pJVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684738915; x=1687330915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1oOKoVyoIUj8JPcN8+63Cdo8i/cPI1zhOYlcZa0hSM=;
        b=UtAu7wD/KigprNzBU5+z5l+ff6x6pXWMtbXCrRAupixKC0OqtFJY8/voJFRU2zq2V7
         klFjFWKqIDiNmNDVrk/mvLByJROAP5Xay2obCHNNfZoKv4wv/nrem6+WRqIbP3Q7ZEsz
         E1IlI3gzJ+uf03rlPzUzbijHiebTVVCZ87PeovGqB45iLJhoveM+XcGYRSbTBhAZTPYe
         ZIQwDCxv5ckjgGBLkatddcIBLYWaAxwTXhZpPAsqrfWImnJU26PRiVApSEByV1Vh+GB/
         X4xo1vbey1L5K6EtXfiQsif5XEMhFmHUlnS42OmbUewgid6N689vLLGr0xOTtNG0fFwE
         z96Q==
X-Gm-Message-State: AC+VfDxmZpGAO7t0OXvpmEEtN3h8ovgj6nmatYAebEvifqayzLPKPv//
	uG2O+MvmmRLT32NrQCsNA+mwUQ==
X-Google-Smtp-Source: ACHHUZ4o2D5U9H7O9EVzembFmHB5vNmURPTxvA+5i11/ATadoYPSFYWcOfJ9V/84ql5EYbtBEo1FuA==
X-Received: by 2002:a17:90b:1d0c:b0:255:67e3:98a with SMTP id on12-20020a17090b1d0c00b0025567e3098amr2054678pjb.11.1684738915145;
        Mon, 22 May 2023 00:01:55 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.251])
        by smtp.gmail.com with ESMTPSA id d27-20020a630e1b000000b0052cbd854927sm3687505pgl.18.2023.05.22.00.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 00:01:54 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Glauber Costa <glommer@parallels.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v2 3/4] sock: Consider memcg pressure when raising sockmem
Date: Mon, 22 May 2023 15:01:21 +0800
Message-Id: <20230522070122.6727-4-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230522070122.6727-1-wuyun.abel@bytedance.com>
References: <20230522070122.6727-1-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

For now __sk_mem_raise_allocated() mainly considers global socket
memory pressure and allows to raise if no global pressure observed,
including the sockets whose memcgs are in pressure, which might
result in longer memcg memstall.

So take net-memcg's pressure into consideration when allocating
socket memory to alleviate long tail latencies.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 net/core/sock.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 801df091e37a..7641d64293af 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2977,21 +2977,30 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
 	struct proto *prot = sk->sk_prot;
-	bool charged = true;
+	bool charged = true, pressured = false;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
-	if (memcg_charge &&
-	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
-						gfp_memcg_charge())))
-		goto suppress_allocation;
+
+	if (memcg_charge) {
+		charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+						  gfp_memcg_charge());
+		if (!charged)
+			goto suppress_allocation;
+		if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
+			pressured = true;
+	}
 
 	/* Under limit. */
-	if (allocated <= sk_prot_mem_limits(sk, 0)) {
+	if (allocated <= sk_prot_mem_limits(sk, 0))
 		sk_leave_memory_pressure(sk);
+	else
+		pressured = true;
+
+	/* No pressure observed in global/memcg. */
+	if (!pressured)
 		return 1;
-	}
 
 	/* Under pressure. */
 	if (allocated > sk_prot_mem_limits(sk, 1))
-- 
2.37.3


