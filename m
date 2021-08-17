Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C803EF659
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 01:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbhHQXwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 19:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbhHQXwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 19:52:32 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4919DC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 16:51:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id p23-20020a05620a22f700b003d5ac11ac5cso446771qki.15
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 16:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=66LPn3qAi6+RNBmqfq0UYvC3j3r/16uwPxDAmwkK1Rw=;
        b=MuXuzaYjkly6ZK6hbdIJnuw+v7wznvPbDZ0p5MMYdjR2zpPsmOU1mOJZDjly7T7t3h
         Vor+OvLRGzh8Bd/dUJ2iiV+DJ0Ze5P5CHK6O7sVdw1/fyIv8SifmAFvv85DVwZ3Yhg/f
         v2YLLY2yEtoEC8PlqkLlQ1zTUixMwAtTfMUU4hV6yvSERkh2717O6RPgTjCsfEhzbWbQ
         /m/fH4YcNnEF09btKf/x6aznzeFYMFpsPy4JV/tV1Rytsyr5wGgD1pA7JusBqJyL1NmS
         eRvD8GALaACkO8jsXXmBOgSaURGv6FEuiGC4FXzQD6sTey3/a5DANaYeVFzVIVe0uw5m
         TaWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=66LPn3qAi6+RNBmqfq0UYvC3j3r/16uwPxDAmwkK1Rw=;
        b=MRNl3qPHerjD0zcVjsYU+Ib4KgfWG2UaZKYQg+EYP9tU7YGnZ93s39RQH/uGfGLi99
         Fv2t1Dc30RzeI8zknSTj91Y2ACgw3t+eomLBFByvGEkh4RNmFWOZbn/rlvTISzWITm0E
         xAkhq7AliDicVHT07bNs6hppCjpqkrCRs4AVg2F3m62OmpuxYy5/pp+V9DQc3SkwgX1A
         kv8/9uiQI3Fg4U/qKbcsgr0KySYpvgbmYv8EiHFzuCeb36jZSkZR6cSXJXjTjqDgOQpk
         nkH0UsmCkT36scHOfdPG8FcecrxrsAWv8PRSFqh5GMM1JzVqycWINrtuDLD0yMTvLhG2
         vxHA==
X-Gm-Message-State: AOAM533Ia7tkGheYbc7dUNiJK8sboTekYvA6QrCG5A+cFjtux553omNN
        t5AqLyWRXoUJ28jUKurIGO953rNdTn2Z051FilHcIDj8kl45DAHXIi+Y8MO63QuswJI7B7uwuBd
        IbF/3+ZeVpWX50jtXSB/JDcw1mjjhiTtluTAy+OX9IKY3iQ8/m83QV6BEld+8pjCW9Vf0xWVGkD
        NXHISgLRg=
X-Google-Smtp-Source: ABdhPJxJBFWKOxzMxsf1ZaOmZuY64y/gaCGF1flpnHOTiBjvAE8aVUtkkKkBy0xIE8sDlAx/xsrBfH/7aExo84L29XKv6Q==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a05:6214:f2e:: with SMTP id
 iw14mr6100161qvb.36.1629244317401; Tue, 17 Aug 2021 16:51:57 -0700 (PDT)
Date:   Tue, 17 Aug 2021 23:51:38 +0000
In-Reply-To: <20210817235141.1136355-1-richardsonnick@google.com>
Message-Id: <20210817235141.1136355-4-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210817235141.1136355-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v3 3/3] pktgen: Add output for imix results
From:   Nicholas Richardson <richardsonnick@google.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ye Bin <yebin10@huawei.com>, Leesoo Ahn <dev@ooseel.net>,
        Di Zhu <zhudi21@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

The bps for imix mode is calculated by:
sum(imix_entry.size) / time_elapsed

The actual counts of each imix_entry are displayed under the
"Current:" section of the interface output in the following format:
imix_size_counts: size_1,count_1 size_2,count_2 ... size_n,count_n

Example (count = 200000):
imix_weights: 256,1 859,3 205,2
imix_size_counts: 256,32082 859,99796 205,68122
Result: OK: 17992362(c17964678+d27684) usec, 200000 (859byte,0frags)
  11115pps 47Mb/sec (47977140bps) errors: 0

Summary of changes:
Calculate bps based on imix counters when in IMIX mode.
Add output for IMIX counters.

Signed-off-by: Nick Richardson <richardsonnick@google.com>
---
 net/core/pktgen.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 9e78edf0f69b..699f76779f0c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -695,6 +695,18 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
 		   (unsigned long long)pkt_dev->sofar,
 		   (unsigned long long)pkt_dev->errors);
 
+	if (pkt_dev->n_imix_entries > 0) {
+		int i;
+
+		seq_puts(seq, "     imix_size_counts: ");
+		for (i = 0; i < pkt_dev->n_imix_entries; i++) {
+			seq_printf(seq, "%llu,%llu ",
+				   pkt_dev->imix_entries[i].size,
+				   pkt_dev->imix_entries[i].count_so_far);
+		}
+		seq_puts(seq, "\n");
+	}
+
 	seq_printf(seq,
 		   "     started: %lluus  stopped: %lluus idle: %lluus\n",
 		   (unsigned long long) ktime_to_us(pkt_dev->started_at),
@@ -3281,7 +3293,19 @@ static void show_results(struct pktgen_dev *pkt_dev, int nr_frags)
 	pps = div64_u64(pkt_dev->sofar * NSEC_PER_SEC,
 			ktime_to_ns(elapsed));
 
-	bps = pps * 8 * pkt_dev->cur_pkt_size;
+	if (pkt_dev->n_imix_entries > 0) {
+		int i;
+		struct imix_pkt *entry;
+
+		bps = 0;
+		for (i = 0; i < pkt_dev->n_imix_entries; i++) {
+			entry = &pkt_dev->imix_entries[i];
+			bps += entry->size * entry->count_so_far;
+		}
+		bps = div64_u64(bps * 8 * NSEC_PER_SEC, ktime_to_ns(elapsed));
+	} else {
+		bps = pps * 8 * pkt_dev->cur_pkt_size;
+	}
 
 	mbps = bps;
 	do_div(mbps, 1000000);
-- 
2.33.0.rc1.237.g0d66db33f3-goog

