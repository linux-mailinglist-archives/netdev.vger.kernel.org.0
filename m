Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D173EF78C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 03:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhHRBda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 21:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhHRBd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 21:33:29 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE08CC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 18:32:55 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id e17-20020a0562141511b029034f8146604fso1012406qvy.12
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 18:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=L5moxT2jLL1QoSiZ11RqMC3wpmZIVwXe69nsWU69g+w=;
        b=DEJLI4Nej2HbG/RrjQzEYC6ehvq9nqUASq/uIN+gk2Q32HREUxa6ZgSQF5Q9Givt+p
         8jdLmDUhVwxhSLUQmjIyTqbamZYg3kFklHx9weptXptHnJkaCVRER7kaflsI/fONDMrQ
         0A30YXwRXVz5HxdmG5v3YY+N9cSSgDVoL+ZcYKjUBcfifxJqZ2zaMibUHoZYrQh6MKXF
         dDps22Lqbdptg807hKOqB1SrWYcGB2emVm537yX7vczzfGOiZjaQZVGEZJueF2cZna07
         kG4JOCXEKuA72qCfutilAPD94g70xADzwC9bKdO4tQBJzYalSkb+Mg44l5LkphVKwh3g
         1fkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=L5moxT2jLL1QoSiZ11RqMC3wpmZIVwXe69nsWU69g+w=;
        b=RHTvCyxxsJjGltPDhGHGYEJ6tia/xBoGDSOSTsTjF5NvbzTzLcNbLZEkuObcnwskpm
         mWqp/wvYKON9EGRO46f1WMSEyxo20RrrpABUH+E4UlMA7cTyDqb6G7pw7geqksvBQ30U
         6gK2OCljUAi6d6s2LRhOIEAwnjTgXoEDIVLL3fKMrPifMsL9EVrKXeG/LjuN59If3iNZ
         eDzetW35K+wxubLVyMqm23b7Znydj2OPWDm7kRE8JpalX1nScKh2gj/d8F3lTzYGQO7i
         wtb371UfYBiJyO3TnehW3ZzktN9X0bpIPr+TrMr4mzWeZaZ+WXckaAOIT/Q8mptIjYUD
         GbPg==
X-Gm-Message-State: AOAM532p8NRtvOEjX2HMd89kV7FW3uKX95xHk18+2qPKPwZHPM5O9jwo
        M9m+tu+YGTBt9BINgchFUSjASzWL8gShDc9C5Fije9uYRr/9I4EIg7Od5yfSS89xr/QQDgogDwk
        ag5pDUdD2lSxzx4l6E2wr5PYMNA5NbhvMtjI+R3P2/D2O+DaTEPZhn5nabE+pc1hGkRk79bZv79
        B8SJZ1iBE=
X-Google-Smtp-Source: ABdhPJytIaSaLZfB5oh6aVtn64Gw3GQ/SLbacTPCPjwrqofp9Cbpc3Nrje1IVJ+7gLPmaNM3c4ZdYMhX2GLe5z2AszQHDQ==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:ad4:50ce:: with SMTP id
 e14mr6436544qvq.9.1629250375156; Tue, 17 Aug 2021 18:32:55 -0700 (PDT)
Date:   Wed, 18 Aug 2021 01:31:26 +0000
Message-Id: <20210818013129.1147350-1-richardsonnick@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] pktgen: Remove fill_imix_distribution() CONFIG_XFRM dependency
From:   Nicholas Richardson <richardsonnick@google.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Leesoo Ahn <dev@ooseel.net>, Ye Bin <yebin10@huawei.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

Currently, the declaration of fill_imix_distribution() is dependent
on CONFIG_XFRM. This is incorrect.

Move fill_imix_distribution() declaration out of #ifndef CONFIG_XFRM
block.

Signed-off-by: Nick Richardson <richardsonnick@google.com>
---
 net/core/pktgen.c | 53 +++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 94008536a9d6..9e5a3249373c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2601,6 +2601,32 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 	pkt_dev->flows[flow].count++;
 }
 
+static void fill_imix_distribution(struct pktgen_dev *pkt_dev)
+{
+	int cumulative_probabilites[MAX_IMIX_ENTRIES];
+	int j = 0;
+	__u64 cumulative_prob = 0;
+	__u64 total_weight = 0;
+	int i = 0;
+
+	for (i = 0; i < pkt_dev->n_imix_entries; i++)
+		total_weight += pkt_dev->imix_entries[i].weight;
+
+	/* Fill cumulative_probabilites with sum of normalized probabilities */
+	for (i = 0; i < pkt_dev->n_imix_entries - 1; i++) {
+		cumulative_prob += div64_u64(pkt_dev->imix_entries[i].weight *
+						     IMIX_PRECISION,
+					     total_weight);
+		cumulative_probabilites[i] = cumulative_prob;
+	}
+	cumulative_probabilites[pkt_dev->n_imix_entries - 1] = 100;
+
+	for (i = 0; i < IMIX_PRECISION; i++) {
+		if (i == cumulative_probabilites[j])
+			j++;
+		pkt_dev->imix_distribution[i] = j;
+	}
+}
 
 #ifdef CONFIG_XFRM
 static u32 pktgen_dst_metrics[RTAX_MAX + 1] = {
@@ -2662,33 +2688,6 @@ static void free_SAs(struct pktgen_dev *pkt_dev)
 	}
 }
 
-static void fill_imix_distribution(struct pktgen_dev *pkt_dev)
-{
-	int cumulative_probabilites[MAX_IMIX_ENTRIES];
-	int j = 0;
-	__u64 cumulative_prob = 0;
-	__u64 total_weight = 0;
-	int i = 0;
-
-	for (i = 0; i < pkt_dev->n_imix_entries; i++)
-		total_weight += pkt_dev->imix_entries[i].weight;
-
-	/* Fill cumulative_probabilites with sum of normalized probabilities */
-	for (i = 0; i < pkt_dev->n_imix_entries - 1; i++) {
-		cumulative_prob += div64_u64(pkt_dev->imix_entries[i].weight *
-						     IMIX_PRECISION,
-					     total_weight);
-		cumulative_probabilites[i] = cumulative_prob;
-	}
-	cumulative_probabilites[pkt_dev->n_imix_entries - 1] = 100;
-
-	for (i = 0; i < IMIX_PRECISION; i++) {
-		if (i == cumulative_probabilites[j])
-			j++;
-		pkt_dev->imix_distribution[i] = j;
-	}
-}
-
 static int process_ipsec(struct pktgen_dev *pkt_dev,
 			      struct sk_buff *skb, __be16 protocol)
 {
-- 
2.33.0.rc1.237.g0d66db33f3-goog

