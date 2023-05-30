Return-Path: <netdev+bounces-6346-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 577B0715D79
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:41:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114B0281030
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9F817FF0;
	Tue, 30 May 2023 11:40:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED6413ACA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:40:41 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFFAEA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:40:39 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d41d8bc63so3389221b3a.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446839; x=1688038839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JbrrHsu8KzXBp8abtNpZsLO9DbdsQWsXzCPkkoYMdc=;
        b=XUY6RCnc6d+7un5QD7wAiC5Pb7wzmwMI4vRo1wJc4PF0bSz7lhpfuw5w2hLGZ7RA/3
         n332Bt+Pe4lAngq6WuKUDTougZGEtz32pIJU7zKJ8QTXJ5ViSZGmOERloMz4QRJYUPXH
         hsv0l3Khpa0C5xc3NS3GzMJDoOmmkOVJ01kqthm/kqhC6JK6gClKXL3r+jLADDxhzx9e
         f8NGSVpHLSwGsRh54M1XlrCzSrhEhoysZtz/ipf9w+BGN8Jbp6s9IBTI7fqTjtdWxouD
         Z3Xw+ieXdkIIETN2bAKZUVTNN+xCGvn93OegJEeKCcXmPMVmn2p4opliPA/APLsYLQee
         burg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685446839; x=1688038839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JbrrHsu8KzXBp8abtNpZsLO9DbdsQWsXzCPkkoYMdc=;
        b=D4fgjkCjtZwsMWxjalfmZfZaetwu+WpLMP8dhN1zGzZZT0Z04FAgm4HWdweS1csXih
         FxT/vORnH63YSkAwbAqWOXVOVs/eRg3xTccTQHYyR668+QU1wfTE+CVGDXz/fvA0f2Q5
         IVGqqbNOZz9ccDA04MlefINtYOP3f+CTVN2Jde2kRD43qQdxTXTs7mbP61RJqC9FnMtc
         0JrLAYZ9zaJLUWDJjFfhUYduA8RlylCn0Rol7kbjLjYcDBpEoS4d77pwCOyH/2GfpCl3
         ueQW+JZfc6XYi55NY1SaZ0omOh9JU9fMQzZh6/LzMZ3BvqD9vR4qp5/OLvRVlQevxuL4
         RPQg==
X-Gm-Message-State: AC+VfDxOgWek64imMgAnOAy3zVqlwjlt8bSXmP4l3FPuavlaPU06yEdC
	iCmYG+mWU4OXkLBRhUJNVYs8ew==
X-Google-Smtp-Source: ACHHUZ5emuULCTRsl8IAfWUHF9798CEwa7RQFgXH9Xp8NT+z0Zduzv+V05AvK7LnBc/h3VKpGHIubA==
X-Received: by 2002:a05:6a20:9151:b0:10c:71de:5dc5 with SMTP id x17-20020a056a20915100b0010c71de5dc5mr2593508pzc.30.1685446839327;
        Tue, 30 May 2023 04:40:39 -0700 (PDT)
Received: from C02DV8HUMD6R.bytedance.net ([203.208.167.147])
        by smtp.gmail.com with ESMTPSA id j20-20020aa78dd4000000b00642ea56f06fsm1515103pfr.0.2023.05.30.04.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 04:40:38 -0700 (PDT)
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
Subject: [PATCH v4 2/4] sock: Always take memcg pressure into consideration
Date: Tue, 30 May 2023 19:40:09 +0800
Message-Id: <20230530114011.13368-3-wuyun.abel@bytedance.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230530114011.13368-1-wuyun.abel@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
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
index 641c9373b44b..b0e5533e5909 100644
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


