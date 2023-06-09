Return-Path: <netdev+bounces-9581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2042E729E1A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7074F1C21163
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD3219BC0;
	Fri,  9 Jun 2023 15:14:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE0E256D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:14:01 +0000 (UTC)
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD982113
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:14:00 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-392116b8f31so666474b6e.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686323639; x=1688915639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fG+z5pDu0L2aUS+EwfGH/j31mJRBKgw/abvuWFuc9sQ=;
        b=DzcdcTUKESOM1ePlDTRa2oCGGUmnlJUXzw94qKPEo2jw9M1BVSYY9fmhrHGUjUqX/u
         YYTGdimahyOztLLXrfKNrk9xn8wN4K+NOkR6dHEFFd/pt2k2niGcUQFtZ+F0Dc9gcmO5
         z++FqMsp49aFevEco56/+Am5bhA5613EPwiz3zoJjYud16xezBRh2411JopRd6PJ1HLP
         KKard7Fc5d1O40s/T0fOMae48wEEIYYyA8c8VIR4dPxqudntaibeuWCXk1ESgK+1wgVW
         5E9ytJnBQ6pNwbVlqQIIjxiQ+KOSDornxLFqqxnlathKJx6OsKe8U9x9q4zoxD/teQuj
         eAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686323639; x=1688915639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fG+z5pDu0L2aUS+EwfGH/j31mJRBKgw/abvuWFuc9sQ=;
        b=bd6xKLrg/OdUPrN6snk5HSAZ601aU0k1qzlbtBBVemX89ilvXJng/xp3LRkahSm404
         BuwVwn2R+6/ADvOz9G0fl5JaZp1fHkDqeQDx8q0dk+kHHizhtXsxwZLfJPAy2pWi1iZC
         7/s0Z3lJeue7syHDgq7/WFQzoKcjlRVhj78GIgv4pOkv5f399jJtpnBqRarMJ2nD3iaA
         VWHqSQbY0ciUYYxJ7aYtJ5w7g4xKH/tz3++6qyXTuD88ad3KObLUzNV66GPZOXC/v9GO
         4KvV4k9/7Rbengu7F0TIH8qLdyCYGo1dPvPN19WHIs1D+fZQ84LpBWHda2WVAC2fFhAi
         NPiA==
X-Gm-Message-State: AC+VfDwolZaq4MczKTd8TAEkWjlhYsp25KnBElFOhwlIOdB0vtFygfk4
	QYt6eW9G5jO7HrMd8nuQ/qxjY7Xjz2tL/W5wzLs=
X-Google-Smtp-Source: ACHHUZ4Sx8GQIGHQMGR/vofb1dcbBX1IB9dlqdPNb+hC/HpWeV0V9drPKj2QzCoK6xn+KZAZXGj6pg==
X-Received: by 2002:a05:6808:3b5:b0:39b:da91:8749 with SMTP id n21-20020a05680803b500b0039bda918749mr1608793oie.50.1686323637937;
        Fri, 09 Jun 2023 08:13:57 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id z2-20020aca3302000000b0038ee0c3b38esm1536449oiz.44.2023.06.09.08.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:13:57 -0700 (PDT)
From: Pedro Tammela <pctammela@mojatatu.com>
To: netdev@vger.kernel.org
Cc: tgraf@suug.ch,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [RFC PATCH net-next 4/4] net/ipv6: use rhashtable length helper
Date: Fri,  9 Jun 2023 12:13:32 -0300
Message-Id: <20230609151332.263152-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609151332.263152-1-pctammela@mojatatu.com>
References: <20230609151332.263152-1-pctammela@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Avoid open coding the rhashtab length read

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/ipv6/proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index e20b3705c2d2..402e4f6f9e25 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -25,6 +25,7 @@
 #include <net/udp.h>
 #include <net/transp_v6.h>
 #include <net/ipv6.h>
+#include <linux/rhashtable.h>
 
 #define MAX4(a, b, c, d) \
 	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
@@ -44,7 +45,7 @@ static int sockstat6_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "RAW6: inuse %d\n",
 		       sock_prot_inuse_get(net, &rawv6_prot));
 	seq_printf(seq, "FRAG6: inuse %u memory %lu\n",
-		   atomic_read(&net->ipv6.fqdir->rhashtable.nelems),
+		   rhashtable_len(&net->ipv6.fqdir->rhashtable),
 		   frag_mem_limit(net->ipv6.fqdir));
 	return 0;
 }
-- 
2.39.2


