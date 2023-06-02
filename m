Return-Path: <netdev+bounces-7335-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91EAA71FB9C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:12:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 470BA2816F4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7067BC8EF;
	Fri,  2 Jun 2023 08:12:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED658BF6
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:12:04 +0000 (UTC)
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AD019B
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:12:02 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id 006d021491bc7-558565cc58fso1355684eaf.0
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 01:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685693522; x=1688285522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMgEeyTxt1Bo6VDZUGwQjdkhsPRlWxhl30gajyLXBa4=;
        b=VjphZxOIejuEYZEGuPwwC4pDQ7lIV7K/XG9vcSDLCRxCWGgGi5PSze6VUYd11+IAs0
         Kuul4CNsZBFvMYso/aMxRk0DUCPanLD16zAl1A0vODdrCeOViOsELz9IBaR8oTw6UPca
         Sh5kimkJvKN5Y60CS7Fgx05CnVMkFs3LUuQK4GRlUFaU64P6G3aEXHniXJomFeuNh7RV
         2g9IxHPICSZ3vQb4CogF4QAJdPmhaXCbiWb/5M6aqzDmAghY5ZlzepkhiMb7IttTe7uY
         mULWUSkeYlsAYa+W5goQyWu6i+nF1szs/G1oDUjv5o+ae9/cGIFhbicxvEJ9GU8G5HDk
         p57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685693522; x=1688285522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMgEeyTxt1Bo6VDZUGwQjdkhsPRlWxhl30gajyLXBa4=;
        b=AycqeSTdOP9zPpYKfp3/sy3BSJ7FvNrYAKSSGnnSCk/XwfmlyFvJFWE12Ab0ntwrsz
         hV6w5snDTMKISDlJ+ILYAF/Ld6jeFcujpDXPOlt0z7SqhTcXm1ZRVKqRxih86PL0kpSL
         nww+wJ+qOFTJK/SVlvglWz3CEumTuj3BP8aQkSKHA9IV/mj4Eua5f49fYowJ/0OfJu8p
         U/oCAKT10P4AVireqmpx1Iv4I1WfbsWuMnkeAdIe9sYqAHaHohURUYaolmYK3wx3NCXx
         KufAX5V2sFLvJ5705cvh1QBAi8SU0WjJCPITPuBqAFit0fEevCxj/d1oayZrHnvv5VFU
         aKFw==
X-Gm-Message-State: AC+VfDz+/yNualApV1HWVB885v6cdhm+XFHv9rRky9Xe7gQ4RyF161xM
	OpURnhr7wXjcv3wteV4aFs1sYg==
X-Google-Smtp-Source: ACHHUZ4A27qjlFy5d7fB7UgzYv64hzjwk6Uq2zWiwMXFJiJaGOxm7+lY8w3gnnmpSkd1sTF3hYYqJw==
X-Received: by 2002:a05:6808:198:b0:398:9ee4:1dac with SMTP id w24-20020a056808019800b003989ee41dacmr1647685oic.32.1685693522017;
        Fri, 02 Jun 2023 01:12:02 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id ij9-20020a170902ab4900b001b025aba9edsm703570plb.220.2023.06.02.01.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 01:12:01 -0700 (PDT)
From: Abel Wu <wuyun.abel@bytedance.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Vladimir Davydov <vdavydov.dev@gmail.com>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH net-next v5 2/3] sock: Always take memcg pressure into consideration
Date: Fri,  2 Jun 2023 16:11:34 +0800
Message-Id: <20230602081135.75424-3-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230602081135.75424-1-wuyun.abel@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The sk_under_memory_pressure() is called to check whether there is
memory pressure related to this socket. But now it ignores the net-
memcg's pressure if the proto of the socket doesn't care about the
global pressure, which may put burden on its memcg compaction or
reclaim path (also remember that socket memory is un-reclaimable).

So always check the memcg's vm status to alleviate memstalls when
it's in pressure.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 3f63253ee092..ad1895ffbc4a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
-	if (!sk->sk_prot->memory_pressure)
-		return false;
-
 	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return !!*sk->sk_prot->memory_pressure;
+	return sk->sk_prot->memory_pressure &&
+		*sk->sk_prot->memory_pressure;
 }
 
 static inline long
-- 
2.37.3


