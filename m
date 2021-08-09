Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8AA3E4ABC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhHIRXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhHIRXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:23:19 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2A5C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 10:22:58 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id f10-20020a0ccc8a0000b02903521ac3b9d7so4042938qvl.15
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 10:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zob3UxBCZJOXL7+Saz9eyr6rn9i6ZG0QqW2KutXmaCw=;
        b=CZfapeTkzBQt16ltomwZpYcT1FjIsPBszmbvmk6E0Fz7l1iuDe1kNfCBZFgyoSFO+A
         N9xZ9quGmXNLxaHteHL/h37VRrcrQQvpSpEUWVbg6vl3CKTRVDxQzLPWgg4ll1iB5wT6
         k5Tj3qL3CrNL60KAeS+1MtbgmZ0bhhvWGrIms7E1hmB6m+f6neI6xkKLXgbcBRfiWimP
         2FUQBI0YlBwaa3bp6K8FsvfkeVuoeXlR7gua6xkpsziIhepesjrlc5IXt/B4IsdXBMYd
         wDbMeN3Tm+ehCVkb0NJbKe1xcSGwcyrzun7dOroGyiBDMgb/+IC3/J4HnXZVCXVoW3lo
         RJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zob3UxBCZJOXL7+Saz9eyr6rn9i6ZG0QqW2KutXmaCw=;
        b=CQ0nNcW+wy5GDdAq9ce2mnXhAZI70GwTiLGVC5q4dmBuL++4WTPnpoc1k/BHDPwbK8
         s3BtJApFKrP4xy2ZJ+FfdtYcLzDErxI6Mc1iOI0Tw3Dml4lcHyKNK68bA3e47Fe/hwdR
         xtvQooTgzmfR9crVZqt6fYtXr13CdLSYb4cH8m/Q3rrvkGnLacghi3ChQO1uF5okj1NC
         Ctyg0OM69reLQ363jcCWINY1saMnNfoNmzePx0/GPtV6aHnf+c8FQRT6ehedzeCpQ9en
         ez9k5hNWOAtAxZ15GR+ym70jlY5yeELm/xI2sn6Xhd02vpRIrRK2K/HshMWttFRaQsoO
         IXJQ==
X-Gm-Message-State: AOAM532fhMoJsatOWOGf6LzuWJQ95ib46R5K9BLFhguIARTpxB3O/JS4
        mS0luf+Mx6Y2LO8rSwmP7QqHvEyUafyrbL4YQ4jC8A==
X-Google-Smtp-Source: ABdhPJxXLB/5bgROHElsTEKC1vPGaTBNAh2SbwYNIKQjRon/lN1p5FM1mh7wpJeDitwnaIhwEJoiTwxWc9Axtf5bFmKMDA==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a05:6214:9d2:: with SMTP id
 dp18mr13523234qvb.46.1628529777974; Mon, 09 Aug 2021 10:22:57 -0700 (PDT)
Date:   Mon,  9 Aug 2021 17:22:03 +0000
In-Reply-To: <20210809172207.3890697-1-richardsonnick@google.com>
Message-Id: <20210809172207.3890697-3-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210809172207.3890697-1-richardsonnick@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 2/3] pktgen: Add imix distribution bins
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, arunkaly@google.com,
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

In order to represent the distribution of imix packet sizes, a
pre-computed data structure is used. It features 100 (IMIX_PRECISION)
"bins". Contiguous ranges of these bins represent the respective
packet size of each imix entry. This is done to avoid the overhead of
selecting the correct imix packet size based on the corresponding weights.

Example:
imix_weights 40,7 576,4 1500,1
total_weight = 7 + 4 + 1 = 12

pkt_size 40 occurs 7/total_weight = 58% of the time
pkt_size 576 occurs 4/total_weight = 33% of the time
pkt_size 1500 occurs 1/total_weight = 9% of the time

We generate a random number between [0-99] and select the corresponding
packet size based on the specified weights.
Eg. random number = 358723895 % 100 = 65
Selects the packet size corresponding to index:65 in the pre-computed
imix_distribution array.
An example of the  pre-computed array is below:

The imix_distribution will look like the following:
0        ->  0 (index of imix_entry.size == 40)
1        ->  0 (index of imix_entry.size == 40)
2        ->  0 (index of imix_entry.size == 40)
[...]    ->  0 (index of imix_entry.size == 40)
57       ->  0 (index of imix_entry.size == 40)
58       ->  1 (index of imix_entry.size == 576)
[...]    ->  1 (index of imix_entry.size == 576)
90       ->  1 (index of imix_entry.size == 576)
91       ->  2 (index of imix_entry.size == 1500)
[...]    ->  2 (index of imix_entry.size == 1500)
99       ->  2 (index of imix_entry.size == 1500)

Create and use "bin" representation of the imix distribution.

Signed-off-by: Nick Richardson <richardsonnick@google.com>
---
 net/core/pktgen.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 83c83e1b5f28..be46de1d6eec 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -177,6 +177,7 @@
 #define MPLS_STACK_BOTTOM htonl(0x00000100)
 /* Max number of internet mix entries that can be specified in imix_weights. */
 #define MAX_IMIX_ENTRIES 20
+#define IMIX_PRECISION 100 /* Precision of IMIX distribution */
 
 #define func_enter() pr_debug("entering %s\n", __func__);
 
@@ -354,6 +355,8 @@ struct pktgen_dev {
 	/* IMIX */
 	unsigned int n_imix_entries;
 	struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
+	/* Maps 0-IMIX_PRECISION range to imix_entry based on probability*/
+	__u8 imix_distribution[IMIX_PRECISION];
 
 	/* MPLS */
 	unsigned int nr_labels;	/* Depth of stack, 0 = no MPLS */
@@ -483,6 +486,7 @@ static void pktgen_stop_all_threads(struct pktgen_net *pn);
 
 static void pktgen_stop(struct pktgen_thread *t);
 static void pktgen_clear_counters(struct pktgen_dev *pkt_dev);
+static void fill_imix_distribution(struct pktgen_dev *pkt_dev);
 
 /* Module parameters, defaults. */
 static int pg_count_d __read_mostly = 1000;
@@ -1045,6 +1049,8 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (len < 0)
 			return len;
 
+		fill_imix_distribution(pkt_dev);
+
 		i += len;
 		return count;
 	}
@@ -2572,6 +2578,14 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 				t = pkt_dev->min_pkt_size;
 		}
 		pkt_dev->cur_pkt_size = t;
+	} else if (pkt_dev->n_imix_entries > 0) {
+		struct imix_pkt *entry;
+		__u32 t = prandom_u32() % IMIX_PRECISION;
+		__u8 entry_index = pkt_dev->imix_distribution[t];
+
+		entry = &pkt_dev->imix_entries[entry_index];
+		entry->count_so_far++;
+		pkt_dev->cur_pkt_size = entry->size;
 	}
 
 	set_cur_queue_map(pkt_dev);
@@ -2640,6 +2654,33 @@ static void free_SAs(struct pktgen_dev *pkt_dev)
 	}
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
+
 static int process_ipsec(struct pktgen_dev *pkt_dev,
 			      struct sk_buff *skb, __be16 protocol)
 {
-- 
2.32.0.605.g8dce9f2422-goog

