Return-Path: <netdev+bounces-4622-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33C170D97F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80D511C20D43
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E447D1E529;
	Tue, 23 May 2023 09:47:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BC1DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:47:28 +0000 (UTC)
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0061F139
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:24 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64d30ab1ef2so3422212b3a.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1684835244; x=1687427244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wljfsHXHo/5dnZRd+Tp9MykDSGj/AnuCuvCHil+r0Q0=;
        b=Wk4AsMej2kFn2vk6ySqFSw0wYlfCctDm1y9dO/NXtgPyjoCFO7fD+mNjbXE5ii9egR
         fAzkSX11GOa1h9RD0fMJ/iJALgwbS7eEPS2c5FhLye8DHrs0smXM9Bm5IDvCFx7HlS1X
         gXaDjlgcvO1qiCK8OLndIWQUrFhEv7BLVe7ORpTI1Hzo4qdtIEjNodfDbYJMfQkuY3dL
         5R2b/Jrsb3YHOZsEY8BhCksLDo4X6RM8z44pPg2ymI0PMn1CR6jWh2Ox321uXC/Tk7Tu
         0HOJyipQKU7yVeh5qZ++ubCoWE2vN2VwaBSEG7tQMchuc1xwsd2NyO1uzg3Zj8tCqh3h
         qdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684835244; x=1687427244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wljfsHXHo/5dnZRd+Tp9MykDSGj/AnuCuvCHil+r0Q0=;
        b=jBDo2zAtqjZcOp5CXfB2Scq5OJfp8fWgUpNYyb0R1LIC+ziTpOo14DcRgcnBLuTP0w
         3GcISandPoqzNRkFcUQrda0RWS9/Dg+crd5L8Ng2OLnRXem+1NnMvdzB6SfqbcwHUTMb
         kNvTMg5ZfPq2tz29vO6Hxr/pI/fRhhyZo/UUjtnRq86QOacLLG9a8HSvKbceTHD0JzFv
         U7cyKMULt9tAMM4dNG8JAPqXZPTFYDsaU356YJn57jtq/v+3R5qZg30/Dkh30lemCsgb
         skmecXpFRUeIbxPyWhnAYJ1cvrO3JwG3kLfo2kw5Q/Rdb9V3L04eIoOTOIMWr5rdhXI1
         P1ig==
X-Gm-Message-State: AC+VfDw1j8IlensNy6vIVJwuVHoWyJ4E9lYXYIlTpJCH86p7epnnx9YM
	4YqNZykL/05He4xhwghuzYnQBw==
X-Google-Smtp-Source: ACHHUZ70YJnyM6ttX9OZc9Uu5PHLrLyAMVMkoYPM9DzbVinKXHtZToqQGMxLnElUinxlIrQUmcMvOA==
X-Received: by 2002:a05:6a00:23c7:b0:63d:2f13:200 with SMTP id g7-20020a056a0023c700b0063d2f130200mr18310565pfc.16.1684835244458;
        Tue, 23 May 2023 02:47:24 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79116000000b0063b898b3502sm5457216pfh.153.2023.05.23.02.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:47:23 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v3 4/5] sock: Consider memcg pressure when raising sockmem
Date: Tue, 23 May 2023 17:46:51 +0800
Message-Id: <20230523094652.49411-5-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230523094652.49411-1-wuyun.abel@bytedance.com>
References: <20230523094652.49411-1-wuyun.abel@bytedance.com>
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
index 801df091e37a..b899e0b9feda 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2976,22 +2976,31 @@ EXPORT_SYMBOL(sk_wait_data);
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
+	bool charged = true, pressured = false;
 	struct proto *prot = sk->sk_prot;
-	bool charged = true;
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


