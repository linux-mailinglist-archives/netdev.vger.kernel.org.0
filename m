Return-Path: <netdev+bounces-12157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59D17367AF
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AE44280FED
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F96E57B;
	Tue, 20 Jun 2023 09:27:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B313DE56E
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 09:27:39 +0000 (UTC)
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B420198C
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:27:34 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-39ca48cd4c6so2865167b6e.0
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687253253; x=1689845253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hQPeetryXYO8HRB1jhiVIFx7v2qMa1RF1n/zxPN4HNQ=;
        b=PzpdxtoaTtVDo2hKmd1luCFRpMRf9n/zI+Bjdcyd54COf0eZRoP+deZORi35sr3HL9
         E+jbqo63o9VE2rpOlqMM69NGb3zcuZEKdfOC6kgRzCS2JlOTTxvOUVZcHOt+lX+6VHEH
         Inm+np3ZqD/QkYz02ZF44zQ+ms2BEv11HtGyt80vpNJD4LgnUPukRGpfRItbs2MY9+iJ
         d4BPYL+NzHII8WXjxR+nIDq+CaQ8/I9uujcr/YAEE60ZUrXKj5aTvirvn4XARpcC2VQd
         r0tv17Yaf5v+NvUGBAP1UntdnaHOCWpD+ffiXlrqQiVMLNpqPJA/IO3kJGw3n0wZ5VgO
         HeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687253253; x=1689845253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hQPeetryXYO8HRB1jhiVIFx7v2qMa1RF1n/zxPN4HNQ=;
        b=MUX028dDRIHuworWduOxmskXumInS0BxhFar/Dg9Fu48ECxbL4v+W37Drcbfh3Q1+3
         zjfRkN8cdglwJyyQXDWAkGk9yQ7vA3hnmyy/2Rhb2q254/uR6buRFhse0LPmkhAZq24l
         YG7/bHeULM26W5zyqHzDqqZVTJLOtV0TcJBEIukRgxzCkAHWnFeHr/m8o+54jPGJZa1M
         jfUNbtcthqDKvoxeqPpLMvD9SrH9/lq44t/hL7EAC1ugmga6ljzimbUeow4aKs9vRzyI
         7fxpZAxGNUAL/eB+AVBXjmTOX1p3wXZOapBj3upE+PylhTSOcPyIe41gQy7ouzvsmkVx
         I53Q==
X-Gm-Message-State: AC+VfDxtNC5UFWapCVtJhOmqCDb0bXAUIwOHpoWS9drlNiMJq8IhJZPW
	gl24KsrZOgFdYUIzRbc7304TCw==
X-Google-Smtp-Source: ACHHUZ5RrmV/xmS/J93vSCf4ZDHwVoc9y0brWeeIQbOyyzn4S/A2tJZnY8Xsuy0blZ/tqoT4YZw2QA==
X-Received: by 2002:a05:6808:1828:b0:39a:bf70:e421 with SMTP id bh40-20020a056808182800b0039abf70e421mr10877276oib.58.1687253253365;
        Tue, 20 Jun 2023 02:27:33 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.146])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902a60d00b001ae0a4b1d3fsm1188921plq.153.2023.06.20.02.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 02:27:32 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>,
	netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] inet: Cleanup on charging memory for newly accepted sockets
Date: Tue, 20 Jun 2023 17:27:11 +0800
Message-Id: <20230620092712.16217-1-wuyun.abel@bytedance.com>
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If there is no net-memcg associated with the sock, don't bother
calculating its memory usage for charge.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 net/ipv4/inet_connection_sock.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 65ad4251f6fd..22f7b3aaff3c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -706,20 +706,23 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
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
+		}
+
+		if (amt)
 			mem_cgroup_charge_skmem(newsk->sk_memcg, amt,
 						GFP_KERNEL | __GFP_NOFAIL);
 
-- 
2.37.3


