Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B0F3E4ABD
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhHIRX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbhHIRXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:23:25 -0400
Received: from mail-vs1-xe49.google.com (mail-vs1-xe49.google.com [IPv6:2607:f8b0:4864:20::e49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08405C061798
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 10:23:05 -0700 (PDT)
Received: by mail-vs1-xe49.google.com with SMTP id b19-20020a67fe930000b02902bcabe3d14cso1744018vsr.12
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 10:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8/jOUxt+YUrjRZL/TINLUwdfhHd+V6WjO0jwX/Usg4E=;
        b=GHV6a2TdKtfhsbwPqnhgRO74xhjaQwItH+Mrr+cp2L7u9JGbqujDQaYzvHp0bR+Jrl
         xRERdiFYLc7X0azOr01s+S4snqaH7WWq8CKnL6PxUzUAXuPAIx9WJCeJ8LX3B8hMlbfY
         rP6JsV0HhYuApDTX7RGqmK1C1k/p/rnhPiTvBpLVQiUHRImGGDjOMVs4SqTNYH/AK5sy
         7YawBAWcU+hCUGZ6NoVspTIzigrYW/GdWB64zkDEeVsFRtIrZkU1HmRH2Td6II6rfYD+
         ZgRy90rxMSc0MyIxvWFgHJ9r1kByl65BVkA0LFmaflPMEiRc1dC7uM0VU4ohsjA3GXsD
         +ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8/jOUxt+YUrjRZL/TINLUwdfhHd+V6WjO0jwX/Usg4E=;
        b=GojShbuRw5K/+zW1PQFgAszwhCX/o/UocVSKufBLZgY9GWAQuZxO4x+guknZJpNyv7
         JE+N/fbXGrEc/dUSeHTfIPhe2OsR9WrbTyIXY8h1OFxHB6TKZ5RI0jmCcQvijS9zV8r9
         wsd6byMi1/uAdH7BE/HYVsYj+YHZBBPu0utNAKpdGDn4fN7KIX0rbUqh5NhC2SEgMqCm
         2ALSmmrlCMNRn+kaPXXGziTGRVvO8K7XitKpOUyA8JB6nYeBg5AaP/Itqlu9oBOMgmjU
         Qjc5hd6lRCJjR8GPJPtirXoxQ4M3y80Tndqm56BlY1PzfvMIyWnvEEVJPyqaJg3TopDw
         lOoQ==
X-Gm-Message-State: AOAM532P/uN0BZgtb8u/qziGYZH5FEJ3RbHmTd4MZKBZY2YjLEQVVVNn
        kot1XtZiVjVPIQPN9KeqGhQjeF/F1RJC/34JZLFkvw==
X-Google-Smtp-Source: ABdhPJyP+6B2j1eCMPELbbPZURKm+kELXvP9Kf87YcP9rbfEA9txxN99JVVAd6v+vwZDt2L2rb0yNcJD5AuONeefBUwv3A==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a9f:2286:: with SMTP id
 6mr17039040uan.53.1628529784146; Mon, 09 Aug 2021 10:23:04 -0700 (PDT)
Date:   Mon,  9 Aug 2021 17:22:04 +0000
In-Reply-To: <20210809172207.3890697-1-richardsonnick@google.com>
Message-Id: <20210809172207.3890697-4-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210809172207.3890697-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 3/3] pktgen: Add output for imix results
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ye Bin <yebin10@huawei.com>, Leesoo Ahn <dev@ooseel.net>,
        Di Zhu <zhudi21@huawei.com>,
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
imix_counts: 256,32082 859,99796 205,68122
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
index be46de1d6eec..b1705e62b10f 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -695,6 +695,18 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
 		   (unsigned long long)pkt_dev->sofar,
 		   (unsigned long long)pkt_dev->errors);
 
+	if (pkt_dev->n_imix_entries > 0) {
+		int i;
+
+		seq_printf(seq, "     imix_size_counts: ");
+		for (i = 0; i < pkt_dev->n_imix_entries; i++) {
+			seq_printf(seq, "%llu,%llu ",
+				   pkt_dev->imix_entries[i].size,
+				   pkt_dev->imix_entries[i].count_so_far);
+		}
+		seq_printf(seq, "\n");
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
2.32.0.605.g8dce9f2422-goog

