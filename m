Return-Path: <netdev+bounces-9578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C93729E0D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:14:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91982281961
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 046D618C3C;
	Fri,  9 Jun 2023 15:13:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB8E18C05
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:13:53 +0000 (UTC)
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E32210C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:13:52 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-39c84863e7cso648873b6e.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686323631; x=1688915631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSK20+cmPdvbepJqQyD3omQ1jTT5Y4rR/Dah7tvJKjU=;
        b=m3BT3PO5glf/ESqSsGnPyMKB5uglucucpRlhPpvAe3CcPv3LLEyBKpuONaslS59yf5
         P/SRpthMNuAn/P/AV6vWK0Af9KpDsjkqmpr7ftXrDNF6ya44gtYhyLm1gcbZNygUrvRq
         qMKFOYjCoRgDaUoT0OEtdFx4/EV2ZqojtUPzJmN1uGBuzu2V4lsVjADs8YjXmRkBdSF1
         TROvntBT9V8+cVwaq2OZF1cvdqprK1k0m3ZZ1UFTU2BnpwUfbI5BTsthum7whhKNSu25
         pLw3j9J082KvheuLbD2f9QRMs45tTBikksW0ksUOXXCVUvS/F4y61E7cGIz/eAPkAAtc
         6gWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686323631; x=1688915631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DSK20+cmPdvbepJqQyD3omQ1jTT5Y4rR/Dah7tvJKjU=;
        b=EGg/1TkkEoy/+j1mkxL3CvbbxQmpjnDtka4mnPYnQ0pwOT0G4PQ5JUGPtCTbU6RrxZ
         M+s0ItB7kqygHxlV7B7X1ulYnv3pCd6ij9NNc2jIRcKy6J+nbZEGGm/w+Z83pxJ/mdct
         EmfqU05V/LIJBU3EdAvD3evoNYJKCSoTFdfS7TiygwhuDIKAkNGuguYTdMvvP349XfnA
         fwHpndoQOXfWtVYUebqYpZWrnoA5y5SETMO+uzOnKXw/Fgw0CMzzcx0D0nSSDZnyDQ+g
         4KHN7R+zV0Yg5fw5fLNuYk53kDsefzq9ysrJM5993KLDrNqYxnLuOY2QPjs9r01mHTVI
         MTFw==
X-Gm-Message-State: AC+VfDzac647IuhB9nOnGG7WWiTNdiS+V5E+J/97G7TUWyawJo9va04W
	w56Cd5Qu5zuE5E87nbuG1BRKtmD1ZDzqRSxkOt0=
X-Google-Smtp-Source: ACHHUZ7Zb/d8qekC/JsEwOir+iFcDhiJ3qd+t8zYZC9rDY7SLSsrpqvbSRkha7FQBp0GfMzvV0hJ+g==
X-Received: by 2002:a05:6808:1529:b0:39a:ba7e:33bd with SMTP id u41-20020a056808152900b0039aba7e33bdmr2269679oiw.0.1686323629912;
        Fri, 09 Jun 2023 08:13:49 -0700 (PDT)
Received: from rogue-one.tail33bf8.ts.net ([2804:14d:5c5e:44fb:643a:b27d:4a69:3b94])
        by smtp.gmail.com with ESMTPSA id z2-20020aca3302000000b0038ee0c3b38esm1536449oiz.44.2023.06.09.08.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 08:13:49 -0700 (PDT)
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
Subject: [RFC PATCH net-next 1/4] rhashtable: add length helper for rhashtable and rhltable
Date: Fri,  9 Jun 2023 12:13:29 -0300
Message-Id: <20230609151332.263152-2-pctammela@mojatatu.com>
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

Instead of having users open code the rhashtable length like:
   atomic_read(&ht->nelems)

Provide a helper for both flavours of rhashtables.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/linux/rhashtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 5b5357c0bd8c..aac803491916 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -1283,4 +1283,20 @@ static inline void rhltable_destroy(struct rhltable *hlt)
 	return rhltable_free_and_destroy(hlt, NULL, NULL);
 }
 
+/**
+ * rhashtable_len - hash table length
+ * @ht: the hash table
+ *
+ * Returns the number of elements in the hash table
+ */
+static inline int rhashtable_len(struct rhashtable *ht)
+{
+	return atomic_read(&ht->nelems);
+}
+
+static inline int rhltable_len(struct rhltable *hlt)
+{
+	return rhashtable_len(&hlt->ht);
+}
+
 #endif /* _LINUX_RHASHTABLE_H */
-- 
2.39.2


