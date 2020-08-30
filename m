Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439F32570B2
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 23:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgH3V0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 17:26:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21765 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726150AbgH3V0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 17:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598822797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=433hylRzd7tAV1qS/y1gHwbMIYEXzinu0vCj4lzPHz4=;
        b=QPEzMFDGH8gBWw4/3ie2JrK66fpYXwVSd5aQUETkaEJRBNQTIGTzROpEEDGJzLw2TYXCQ2
        5rIryO2gLqBfKZQPKkyvWnCz5c+H++1RFNvx2ZTJe+b4z+CPQSKvZUAtJoLW20+IuHgb/K
        LA0zZ7da5qLa3A5Mr1AbHgoLFQA3OB0=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-xwiIGBWsPcu_JrTvdGsPTw-1; Sun, 30 Aug 2020 17:26:35 -0400
X-MC-Unique: xwiIGBWsPcu_JrTvdGsPTw-1
Received: by mail-ot1-f72.google.com with SMTP id z23so3147726ote.14
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 14:26:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=433hylRzd7tAV1qS/y1gHwbMIYEXzinu0vCj4lzPHz4=;
        b=lZNSd4g1XneWmpRkr4rplqtCTJwhl1UzVQEemNOkLz/hcS3m5Q0m1k5chKzo8svGiQ
         Pf6sVazZh9uwrgislzQh56ne8Yu5BQhJbQtoGJ12fBkSX4eV04AZpxroDCYVqCts7IOL
         xj7fucxuWy91stQRxtbO547+kUvqjWabIcHovr5aHgdg/2p+hydQuDLRs9XC9FU6W6PP
         xtwUzd99AeRrhEyo+d7PyOqJB3eSMHSCqhogDxWulJpJPoyJV4MFYtICbVd/8tfCo8tQ
         ZipWNz2r5lakf8kV43wv0WbWXAP4swXRE130ij70F8uAl3kS4tpTQOD+RkbjJSbEHr/s
         1giw==
X-Gm-Message-State: AOAM532h6Q7ENQ5XPUpUnxTNPCzlBlHhE2oxtWhK5vHBhKYT7+WE3ezQ
        0LMnZSkw+VHpaFSwRIwYYOb6SQMmXj/DGoKa4tzNl92UJIK5JpNhK4Jg4F5htrL4xqwE/CYWatz
        3SZ4NLpyCKHzlhLMv
X-Received: by 2002:a9d:3b7:: with SMTP id f52mr3903192otf.45.1598822795191;
        Sun, 30 Aug 2020 14:26:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybDLDpnxY9uSLFo6hRHL0aNUMXIi9WnqSA61aLSjk3opsO/+Bibt61vu94GFaJ8D6B6GCGfw==
X-Received: by 2002:a9d:3b7:: with SMTP id f52mr3903187otf.45.1598822794964;
        Sun, 30 Aug 2020 14:26:34 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p11sm699264oif.11.2020.08.30.14.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 14:26:34 -0700 (PDT)
From:   trix@redhat.com
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] net: openvswitch: pass NULL for unused parameters
Date:   Sun, 30 Aug 2020 14:26:30 -0700
Message-Id: <20200830212630.32241-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis flags these problems

flow_table.c:713:2: warning: The expression is an uninitialized
  value. The computed value will also be garbage
        (*n_mask_hit)++;
        ^~~~~~~~~~~~~~~
flow_table.c:748:5: warning: The expression is an uninitialized
  value. The computed value will also be garbage
                                (*n_cache_hit)++;
                                ^~~~~~~~~~~~~~~~

These are not problems because neither parameter is used
by the calling function.

Looking at all of the calling functions, there are many
cases where the results are unused.  Passing unused
parameters is a waste.

In the case where the output mask index parameter of flow_lookup()
is not used by the caller, it is always has a value of 0.

To avoid passing unused parameters, rework the
masked_flow_lookup() and flow_lookup() routines to check
for NULL parameters and change the unused parameters to NULL.

For the mask index parameter, use a local pointer to a value of
0 if user passed in NULL.

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2
- fix spelling
- add mask index to NULL parameters
---
net/openvswitch/flow_table.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index e2235849a57e..eac25596e4f4 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -710,7 +710,8 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
 	ovs_flow_mask_key(&masked_key, unmasked, false, mask);
 	hash = flow_hash(&masked_key, &mask->range);
 	head = find_bucket(ti, hash);
-	(*n_mask_hit)++;
+	if (n_mask_hit)
+		(*n_mask_hit)++;
 
 	hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver],
 				lockdep_ovsl_is_held()) {
@@ -730,12 +731,17 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   const struct sw_flow_key *key,
 				   u32 *n_mask_hit,
 				   u32 *n_cache_hit,
-				   u32 *index)
+				   u32 *in_index)
 {
 	u64 *usage_counters = this_cpu_ptr(ma->masks_usage_cntr);
 	struct sw_flow *flow;
 	struct sw_flow_mask *mask;
 	int i;
+	u32 idx = 0;
+	u32 *index = &idx;
+
+	if (in_index)
+		index = in_index;
 
 	if (likely(*index < ma->max)) {
 		mask = rcu_dereference_ovsl(ma->masks[*index]);
@@ -745,7 +751,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				u64_stats_update_begin(&ma->syncp);
 				usage_counters[*index]++;
 				u64_stats_update_end(&ma->syncp);
-				(*n_cache_hit)++;
+				if (n_cache_hit)
+					(*n_cache_hit)++;
 				return flow;
 			}
 		}
@@ -796,13 +803,9 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 
 	*n_mask_hit = 0;
 	*n_cache_hit = 0;
-	if (unlikely(!skb_hash || mc->cache_size == 0)) {
-		u32 mask_index = 0;
-		u32 cache = 0;
-
-		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
-				   &mask_index);
-	}
+	if (unlikely(!skb_hash || mc->cache_size == 0))
+		return flow_lookup(tbl, ti, ma, key, n_mask_hit, NULL,
+				   NULL);
 
 	/* Pre and post recirulation flows usually have the same skb_hash
 	 * value. To avoid hash collisions, rehash the 'skb_hash' with
@@ -849,11 +852,7 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 {
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
-	u32 __always_unused n_mask_hit;
-	u32 __always_unused n_cache_hit;
-	u32 index = 0;
-
-	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	return flow_lookup(tbl, ti, ma, key, NULL, NULL, NULL);
 }
 
 struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
@@ -865,7 +864,6 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
 	/* Always called under ovs-mutex. */
 	for (i = 0; i < ma->max; i++) {
 		struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
-		u32 __always_unused n_mask_hit;
 		struct sw_flow_mask *mask;
 		struct sw_flow *flow;
 
@@ -873,7 +871,7 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
 		if (!mask)
 			continue;
 
-		flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
+		flow = masked_flow_lookup(ti, match->key, mask, NULL);
 		if (flow && ovs_identifier_is_key(&flow->id) &&
 		    ovs_flow_cmp_unmasked_key(flow, match)) {
 			return flow;
-- 
2.18.1

