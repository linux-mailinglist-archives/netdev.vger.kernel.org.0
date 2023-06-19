Return-Path: <netdev+bounces-11852-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA601734D96
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1717B1C2095B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE8BC79C3;
	Mon, 19 Jun 2023 08:26:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35925393
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:26:10 +0000 (UTC)
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5059310EB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:26:03 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6686a05bc66so806484b3a.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687163162; x=1689755162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F8yD1wR7/XPi7gwA6elrYpxc4KO0mgxsWGuKssVmyeI=;
        b=WNEWwE+H7gcDOhV2Dj5pUjomec9Q1dRItxWLOwUse39FDkRFNWtAGNXrSIHa8T7Ll2
         uN9J8ANpjQCF9tOe8miijYmNYk0nfUdb18wt3+dAj+x3E4mJDQOUgneMkPoDaq6Ub6l8
         Do22aI1mst4d7HhCqd7pBZn1URcges292+Fru4h5IyfEAIxCnkBm/ekYqZWn7JDoxn+v
         KVqG7NUu7bL8bWqyMSC7/SmbEQEK+YU47feC1atSjnqmGaHtiGGe80hiBw3P6UpZunWh
         80o2kuAu9JnmlX2azWCZHoob/dMSrAGoEVEVx/dXvOPv5CQwNZPSH0LnDb/xWz55ffL4
         a+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687163162; x=1689755162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8yD1wR7/XPi7gwA6elrYpxc4KO0mgxsWGuKssVmyeI=;
        b=UdMnzdR/NFAdHNMWFcbZEXEc5bzpist4t1Re/v4vNWc75EEV/2/xnS7qyQKOj6aD7q
         gJW+m2gccz0rmDw12181aLdZH6xBV6/rVc84COSvo1MXaII8GAF/Cj1uEI2tWCaH4SzN
         U0oOcXt6RUOWPfiHbRF3meJLjOAKGD1vPdhcjNVg9Ez0KeUPgcxyRuqFxddrg722mePf
         h0IRKB/1NLBk3mFD+DnKT3eJMJqNXpZGhnO67fPRM+CsrZ1cE6vRC2C9pVWPW87hxnoj
         7Zj7T7VdfFBtl9A9qZMn+Vw5k+rNcuDQ5zTxDfSh7mIGcPokI6NseBVXpB8xqd94Ds38
         ZhSA==
X-Gm-Message-State: AC+VfDxZ+kWiaUqcj14/pN0/5Ck5YAsk6xEjD0164mEKs4t8yGP9xXXR
	m72j2MzgUG/MbtwVr4YPt9qCoQ==
X-Google-Smtp-Source: ACHHUZ61SXRvFwz2nwiq7U1Bpd/nBf/vrNF+H3x9Gp8UobOHG9D71Y53Y6gOfu9A/lYKVSKyEcVdyA==
X-Received: by 2002:a05:6a00:a02:b0:663:f82b:c6d9 with SMTP id p2-20020a056a000a0200b00663f82bc6d9mr10107983pfh.22.1687163162592;
        Mon, 19 Jun 2023 01:26:02 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id a6-20020aa780c6000000b00634b91326a9sm3060093pfn.143.2023.06.19.01.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 01:26:01 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>,
	netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] inet: Save one atomic op if no memcg to charge
Date: Mon, 19 Jun 2023 16:25:47 +0800
Message-Id: <20230619082547.73929-1-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
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

If there is no net-memcg associated with the sock, don't bother
calculating its memory usage for charge.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 net/ipv4/inet_connection_sock.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 65ad4251f6fd..73798282c1ef 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -706,20 +706,24 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 out:
 	release_sock(sk);
 	if (newsk && mem_cgroup_sockets_enabled) {
-		int amt;
+		int amt = 0;
 
 		/* atomically get the memory usage, set and charge the
 		 * newsk->sk_memcg.
 		 */
 		lock_sock(newsk);
 
-		/* The socket has not been accepted yet, no need to look at
-		 * newsk->sk_wmem_queued.
-		 */
-		amt = sk_mem_pages(newsk->sk_forward_alloc +
-				   atomic_read(&newsk->sk_rmem_alloc));
 		mem_cgroup_sk_alloc(newsk);
-		if (newsk->sk_memcg && amt)
+		if (newsk->sk_memcg) {
+			/* The socket has not been accepted yet, no need
+			 * to look at newsk->sk_wmem_queued.
+			 */
+			amt = sk_mem_pages(newsk->sk_forward_alloc +
+					   atomic_read(&newsk->sk_rmem_alloc));
+
+		}
+
+		if (amt)
 			mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
 						GFP_KERNEL | __GFP_NOFAIL);
 
-- 
2.37.3


