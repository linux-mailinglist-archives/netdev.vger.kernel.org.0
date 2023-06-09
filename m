Return-Path: <netdev+bounces-9580-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 085BA729E17
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5940B1C20E81
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825FC1952B;
	Fri,  9 Jun 2023 15:13:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772B51991B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:13:57 +0000 (UTC)
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7B61FF3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:13:56 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id 5614622812f47-39c7f78c237so681049b6e.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686323635; x=1688915635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QM5JDAuNZuAnLZxiWDER0g18nXNzg7qD4OHp9FyblC4=;
        b=SSNZJBlayjEBT9BCH6Md6blZYczAvD37fBYc2wwrOw3KVAFHRG53D2fe4Otp0btOpE
         Kzkf8qWH6MZSRO5XWPcpywifFTLhqxDmhb4KV5Gx5QFMuV2TRwnMH3ujru4AcKJMqYEj
         NkcMaUIZTuYBNdKswaq5FQejQpYmufG2sYHWHPIfNQHxdjTT5xcakNDXeA3l7wG9g6C6
         6JjiPIP0CNzXDeGGHcn+6vSX8V/8PoepeqwZoU7uo3Q2kwacwhPMg63KgDMiFSJuJTWR
         1ugJPi+h0kJJXg7QOrhdgjakethfMiy6d2d7jlJwVywO2447o9235eo2tYLsHgwtVRit
         KDkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686323635; x=1688915635;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QM5JDAuNZuAnLZxiWDER0g18nXNzg7qD4OHp9FyblC4=;
        b=iyD4Kgwf/s9QbIResDlYdFNgIFxB8HBhLPlx9MlOCk5il5kzM3ifXcXTXc9ZW+qPeo
         o5eF/CHFZvK00ZD3M7p0vNG9glqR2fze0leEfJ2xxH67P8apIa7J1+hZWyuM6Kro/dqJ
         4zeuTb9ZW5w+aHvcZIfTIsVA1ONZ7AiKm2JIUb/i1pa0BmVxA1cplByo6PUefkIamtp1
         Mt+w42dUzL4AkcG4jpS3aj9N73Kv4vtZ6mT1OeWRv7MLnuH2QoC7jIO8jnW3G1pyU6l+
         3Pj2PHe1Oj78FJVFd1/GSK7O7mOr2s5feQ39jvzyd8dmos/bKonHh2DZUEcoQ5XpRlIb
         cRVQ==
X-Gm-Message-State: AC+VfDxuMQwYLW2GXYPtunkXhHoM7fifr55ny1eFwYe7pZt0JLYaPUt5
	ADpny7C5fFmGpg6GnzXkdZXY8VakKnCcLNhRYv8=
X-Google-Smtp-Source: ACHHUZ4wfkiCdGtng7QaS48b7Y4W6ccrypBFPDYWYMfflLzIXnzXxRHwSOmakjPgWj4PAV2NGebp2w==
X-Received: by 2002:a05:6808:114d:b0:39a:bc5c:f265 with SMTP id u13-20020a056808114d00b0039abc5cf265mr2476709oiu.28.1686323635299;
        Fri, 09 Jun 2023 08:13:55 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id z2-20020aca3302000000b0038ee0c3b38esm1536449oiz.44.2023.06.09.08.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:13:55 -0700 (PDT)
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
Subject: [RFC PATCH net-next 3/4] net/ipv4: use rhashtable length helper
Date: Fri,  9 Jun 2023 12:13:31 -0300
Message-Id: <20230609151332.263152-4-pctammela@mojatatu.com>
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

Avoid open coding the rhashtable length read

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/ipv4/proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index eaf1d3113b62..cab1edc3c416 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -42,6 +42,7 @@
 #include <linux/export.h>
 #include <net/sock.h>
 #include <net/raw.h>
+#include <linux/rhashtable.h>
 
 #define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
@@ -69,7 +70,7 @@ static int sockstat_seq_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "RAW: inuse %d\n",
 		   sock_prot_inuse_get(net, &raw_prot));
 	seq_printf(seq,  "FRAG: inuse %u memory %lu\n",
-		   atomic_read(&net->ipv4.fqdir->rhashtable.nelems),
+		   rhashtable_len(&net->ipv4.fqdir->rhashtable),
 		   frag_mem_limit(net->ipv4.fqdir));
 	return 0;
 }
-- 
2.39.2


