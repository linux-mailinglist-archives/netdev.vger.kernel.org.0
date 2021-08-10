Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201F73E8365
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 21:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhHJTCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 15:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbhHJTCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 15:02:42 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE5C06179F
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:02:17 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id r13-20020ac85c8d0000b029028efef0404cso9536046qta.14
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 12:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LD5EM5kZNOu66+iSv1Q9X75TvjKmtvXyw6oUcsk/oJc=;
        b=hvL77SsKpxUXlNdVpZW+5fBRnSR5XhA5CxfsiXvB56MNTbW1MNRzVDAeXcZfiQRJVR
         dY7AO7BLxaSEdmjDseD+Uo89DPBg2Z4j5MBkVEntaCa11BWuczlPevVw1SQbqR6cMpgx
         6un5YRvEgW1gIMhEf4ZZugg/XH3efTTc6tijwzDUvbtO1NPK/XMe9OlgHbVZwb+T82u5
         oYdNtc/FCiD/uPVUECfzq2XKBGXpKjcO3LXVACivTHucWafUJ21XhDrj5i/kdAPwOf97
         jQPWl09xkD+BL4C1h/XMEPEabx4Lu1Yi5Nz2ogFLnEPQnyCcu/hXeRJmhbJ7q1HQHK0p
         /MVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LD5EM5kZNOu66+iSv1Q9X75TvjKmtvXyw6oUcsk/oJc=;
        b=tVCVSN65iowU8J2yEqzPwEnNZh1ZJuJnbB+bpV0yAOrTYm33PSHrXGfHgKNiwOBSyv
         zWnbk1jrInXtfopgQqfPM01l5buij0MzM/H3rLDBB1vbsAbCqxoVvVvtxCP6rei/nSlN
         7yPCBjKcS3XitcH3zH+lD07M4Lq5CXKbKlgEQwyRdNYRmwLHMkZC7fcT2acYbdCc1IFk
         gtJNt8JvMtlHPGiE0A9job76dnpC8dbI7dC5O8+sbxH3ziWJxxtTCo/jOk6ZnwW0O/e/
         aDI/5PMFFVpVUoS7ZC6F6T3GfJbirgt3o6iId70wZGQgtVQLoiOFD9BlcA41XR1+7p8k
         nqXw==
X-Gm-Message-State: AOAM530/Pekfjp6++KxIUBm8q0BYAJ+aTnLc18NxDpJ4EPNRpk1IBCWE
        2NaW8ToCidH0RZWhOqyY21lHte1kk/l5F+25P7P5yA==
X-Google-Smtp-Source: ABdhPJwN/JfoIDzQQZROMIXWX9NZa2WxHaoL9mBdNWSVMu14p6iwqfDC10WbpeTA14yBfGfbP9j5P9NWtmXN7PY5d+DfaA==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a05:6214:d05:: with SMTP id
 5mr11741968qvh.54.1628622136748; Tue, 10 Aug 2021 12:02:16 -0700 (PDT)
Date:   Tue, 10 Aug 2021 19:01:55 +0000
In-Reply-To: <20210810190159.4103778-1-richardsonnick@google.com>
Message-Id: <20210810190159.4103778-4-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210810190159.4103778-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2 3/3] pktgen: Add output for imix results
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, promanov@google.com, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Leesoo Ahn <dev@ooseel.net>, Di Zhu <zhudi21@huawei.com>,
        Ye Bin <yebin10@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>, netdev@vger.kernel.org,
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
index ac1de15000e2..7aca175e749b 100644
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
@@ -3282,7 +3294,19 @@ static void show_results(struct pktgen_dev *pkt_dev, int nr_frags)
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
2.32.0.605.g8dce9f2422-goog

