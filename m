Return-Path: <netdev+bounces-9579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48731729E16
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02EE7281961
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAF5319530;
	Fri,  9 Jun 2023 15:13:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC911952B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:13:54 +0000 (UTC)
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4921FEB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:13:53 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 5614622812f47-39c7f7a151fso654887b6e.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686323632; x=1688915632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqUtzMv9176eVmaGGpavOuZ/bRr8DznLogOIZDXKbuk=;
        b=gh1Cy2/LWH6TMihQKqdzE2eAXcVS9qSUUaL5D1jn9Lnm6QeM2RaUTbVXMVrlTEcsIw
         dBAaM+ArEq6+qXtOMYfC01tgZO7WX6GEAdkKAQLHRw8G6nbFTqobSOXgIJgs4C7ohXp5
         zeeuAp2rR0OBT5cBuXvuwR1o/SmT78l3LusnR+d1/6YrlpKl/cVc237CLiRxm/5MaMsR
         tUCxJT+woGZvlEPWiEJleQkr0aDDTnupDdf5thi0JTUVwscphMW1X29WGq4FN1cX1UWa
         fVqB271QewQAE7CpIURRdT6nPbPca3Vc1EFeWsJuKPHCnxf77Wr+AreqdUTFW28+VwuA
         ss5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686323632; x=1688915632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqUtzMv9176eVmaGGpavOuZ/bRr8DznLogOIZDXKbuk=;
        b=AmnvcikERKCtIL1mSMXanUEFnHYofvTnpnzJonnz7W3UEttf3HOSS9BqREPG/PyPOC
         YgNHTEbHmkYAkTkj2VdGSmJcnZoYYKeO0OrfogAzPGQAh+uBHtxA+Usml/9dTA4lMz3U
         7W2jiSbaS64recwc54v/+Fh6B1cqAPecvdDU7LGHwaU8mDDRBd5YH2zKEpRCFbHokpy/
         ab6Y3GTSFZnm5D35MRcbSIeLJALO0pC1RKc2QgjF7DDhN8q8ma+w4B04Q136It1eBZJN
         bcdMbhEPOgkcadflpBYfCGM0sO1S0+BRLJRcqmXeKiF4qSYgqz8qKQn/R8lnhLkUwGqJ
         SeiA==
X-Gm-Message-State: AC+VfDyKUOAV8fXDjIsODd7sFxMxQYtn3+/uVjV+yJPcDeI7ChrheE+3
	bjHLIYFmOw6a3Jr81AwDUmu3WlUvNtMByYAc2D8=
X-Google-Smtp-Source: ACHHUZ4QOhXsshrZWGRNmpetK7tvidgyf/3hR5jUdGIunaYtUeWIsM1WeMsegDi1kVcokHxZVgPC/A==
X-Received: by 2002:a05:6808:349:b0:398:850:6206 with SMTP id j9-20020a056808034900b0039808506206mr1876733oie.27.1686323632609;
        Fri, 09 Jun 2023 08:13:52 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id z2-20020aca3302000000b0038ee0c3b38esm1536449oiz.44.2023.06.09.08.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:13:52 -0700 (PDT)
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
Subject: [RFC PATCH net-next 2/4] rhashtable: use new length helpers
Date: Fri,  9 Jun 2023 12:13:30 -0300
Message-Id: <20230609151332.263152-3-pctammela@mojatatu.com>
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

Use the new length helpers instead of open coding the length read

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 lib/rhashtable.c      | 2 +-
 lib/test_rhashtable.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 6ae2ba8e06a2..1f8ca27af853 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -390,7 +390,7 @@ static int rhashtable_rehash_alloc(struct rhashtable *ht,
 static int rhashtable_shrink(struct rhashtable *ht)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
-	unsigned int nelems = atomic_read(&ht->nelems);
+	unsigned int nelems = rhashtable_len(ht);
 	unsigned int size = 0;
 
 	if (nelems)
diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index c20f6cb4bf55..5853b83d9ad1 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -199,9 +199,9 @@ static void test_bucket_stats(struct rhashtable *ht, unsigned int entries)
 	rhashtable_walk_exit(&hti);
 
 	pr_info("  Traversal complete: counted=%u, nelems=%u, entries=%d, table-jumps=%u\n",
-		total, atomic_read(&ht->nelems), entries, chain_len);
+		total, rhashtable_len(ht), entries, chain_len);
 
-	if (total != atomic_read(&ht->nelems) || total != entries)
+	if (total != rhashtable_len(ht) || total != entries)
 		pr_warn("Test failed: Total count mismatch ^^^");
 }
 
-- 
2.39.2


