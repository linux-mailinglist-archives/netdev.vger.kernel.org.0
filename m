Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F1256EF9
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 17:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgH3PPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 11:15:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59257 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726023AbgH3PPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 11:15:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598800508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Qe2bq4z5dTUuex6AZKp5/mRBzSkcGmSP4Euz2gp/VUE=;
        b=QtI5mxY3f1AgipF27yW/ulAYqlGuy64EEBZnpJb0+dG5m+QX73jidsbBkcfOlLJx26YEq9
        UlXafnlbq2KeIlOE08d7PkJFiUg/by3ERw5dalL2dUTt9GKANzhOz5br7QlCbFedDorlVD
        YN2pmNFkt8iGsuQo9NQO7UgFXrzm2pA=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-wg9nx3WDNcuL75EobKH3Ig-1; Sun, 30 Aug 2020 11:15:06 -0400
X-MC-Unique: wg9nx3WDNcuL75EobKH3Ig-1
Received: by mail-io1-f69.google.com with SMTP id t187so2575719iof.22
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 08:15:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qe2bq4z5dTUuex6AZKp5/mRBzSkcGmSP4Euz2gp/VUE=;
        b=PodOQtsisX/Kpt6/0tp2JaDH2H3nB6MvTecviAH24/iLFIIFQGJdeJOztN86+K8GGS
         s5VO5ZlNQPJOuUKqnAryxJenVt6SRc62AsVFn64rjHS1/P7Xr1XTOq+W2QDV5xRoNVAC
         XB9622C5tnN2TMufb7uh8AVwC7PlWQcnJsmnZoue2mrSlYVBOOeRUGBO2Y7hDoL9MRYj
         LjxKFvJUkeZFKI1pF2/Qu6flGAXSu/LL7eValOxfx7CptxqHFVZhkNZI+mnaTYJzLeFw
         TBbBZSX7yZAMzAeSMFUFKB9rYBiZv6bqg9CSt5jDk7861qOZJkKqyDT8lfBlBq7Q+0bp
         xB6w==
X-Gm-Message-State: AOAM531+pGAfvwyQrOzMYiGt9ygI82nCtqZJzpPt5uHnAK98L46m27G+
        6gkaRbjmPgBicAJIxBhqOstmvxnJy1FYap+r0zhoTPeeB4b3fcZ2cQRTrHWqXcDvG3gUNoTONwU
        xww959DTJAR6YpM7X
X-Received: by 2002:a92:364f:: with SMTP id d15mr5810928ilf.89.1598800505835;
        Sun, 30 Aug 2020 08:15:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRytt73N2hWbZvqwb/+WTkSxJy87W8rcdq9Uz2GipT1EUKrVIh7nlT+Fj7nl/3oUSkpRJaew==
X-Received: by 2002:a92:364f:: with SMTP id d15mr5810915ilf.89.1598800505509;
        Sun, 30 Aug 2020 08:15:05 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q19sm3042288ilj.85.2020.08.30.08.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 08:15:04 -0700 (PDT)
From:   trix@redhat.com
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: openvswitch: pass NULL for unused parameters
Date:   Sun, 30 Aug 2020 08:14:59 -0700
Message-Id: <20200830151459.4648-1-trix@redhat.com>
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

These are not problems because neither pararmeter is used
by the calling function.

Looking at all of the calling functions, there are many
cases where the results are unused.  Passing unused
parameters is a waste.

To avoid passing unused parameters, rework the
masked_flow_lookup() and flow_lookup() routines to check
for NULL parameters and change the unused parameters to NULL.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/openvswitch/flow_table.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index e2235849a57e..18e7fa3aa67e 100644
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
@@ -745,7 +746,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				u64_stats_update_begin(&ma->syncp);
 				usage_counters[*index]++;
 				u64_stats_update_end(&ma->syncp);
-				(*n_cache_hit)++;
+				if (n_cache_hit)
+					(*n_cache_hit)++;
 				return flow;
 			}
 		}
@@ -798,9 +800,8 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
 	*n_cache_hit = 0;
 	if (unlikely(!skb_hash || mc->cache_size == 0)) {
 		u32 mask_index = 0;
-		u32 cache = 0;
 
-		return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
+		return flow_lookup(tbl, ti, ma, key, n_mask_hit, NULL,
 				   &mask_index);
 	}
 
@@ -849,11 +850,9 @@ struct sw_flow *ovs_flow_tbl_lookup(struct flow_table *tbl,
 {
 	struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 	struct mask_array *ma = rcu_dereference_ovsl(tbl->mask_array);
-	u32 __always_unused n_mask_hit;
-	u32 __always_unused n_cache_hit;
 	u32 index = 0;
 
-	return flow_lookup(tbl, ti, ma, key, &n_mask_hit, &n_cache_hit, &index);
+	return flow_lookup(tbl, ti, ma, key, NULL, NULL, &index);
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

