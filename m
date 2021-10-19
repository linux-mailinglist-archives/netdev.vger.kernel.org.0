Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03FD433D33
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhJSRTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229991AbhJSRTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:19:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634663846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AIJC2yruzOEdv1ZyqfrvMRThhVQK13LRvNvRyzdw7do=;
        b=ZeYbiVhyGY8GQ1NFRA9aW+0iQNScSxhoBRAVVbvSUHeUgqJ929N0dFdrgILdE0ma/WjlVd
        8tCr3vR2UQt/ScinKjM9zzSur7RySM+pxUhwZvpI2YggTYkS+CTjodoYXmwibpTBFyxOyt
        pNcTTBaYUAWjdr/GNSSKETecPPrfVjo=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-LsTHCJTYNSGIVqjeNojcEw-1; Tue, 19 Oct 2021 13:17:25 -0400
X-MC-Unique: LsTHCJTYNSGIVqjeNojcEw-1
Received: by mail-ed1-f69.google.com with SMTP id f4-20020a50e084000000b003db585bc274so18222318edl.17
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AIJC2yruzOEdv1ZyqfrvMRThhVQK13LRvNvRyzdw7do=;
        b=ZBSW+ygcy1GM7egAVItiLedqPy5ufBtnM6wkZ/qE4wFULaMQDWofTDFmSjZrFVYRm3
         jx6IAUTEi4+MFdaB+PCTfijsZ/A0HovS+CC2yr0ABto9uejanxXvJ4doH+0KlaISQFx6
         e3CJFFxI908NWBQnMGxzdjqatSUJFiGK3in8CH+pOdF7VFcGhsovsi/Y5vr09pyml27u
         HONxGAy0SXAIm9W9N+j+ifXlouT2Pdt6OPbD8xHvNn7BpPBs20JfHGBvHKomQSS4ExmK
         PbWEMUTPW3Q5FDpkFyOIRtuwdcR2tRVZhhEJi24lI5TDzl8OztZTEDmdQ0AD/KJznKEu
         wF1w==
X-Gm-Message-State: AOAM531deNB6ZeIKvCqD9sar6KMNv0ZCNw5f9v3n4hmPqxVfgcFW5R+v
        HzoyEjtvvkwuxx55bn6/gKXPAl+uAIjAHw+srghePEIGrIeVfEEqGG/5xpnwgJTddDzkFDPSS+Q
        dQYn/vrCK/VnCNSsu
X-Received: by 2002:a17:906:7a50:: with SMTP id i16mr40577655ejo.507.1634663843061;
        Tue, 19 Oct 2021 10:17:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIoXD019yuI+9FPGJqeeS1wsqqotPtAoCzbzPpe3aSzWUk7gL8EpwYy0+kdD6O7egT6dp5QQ==
X-Received: by 2002:a17:906:7a50:: with SMTP id i16mr40577497ejo.507.1634663841454;
        Tue, 19 Oct 2021 10:17:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bq4sm10554865ejb.43.2021.10.19.10.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 10:17:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6CB7E18025D; Tue, 19 Oct 2021 19:17:19 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, edumazet@google.com
Subject: [PATCH net-next] fq_codel: generalise ce_threshold marking for subset of traffic
Date:   Tue, 19 Oct 2021 19:15:34 +0200
Message-Id: <20211019171534.66628-1-toke@redhat.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
so it can be applied to a subset of the traffic, using the ECT(1) bit of
the ECN field as the classifier. However, hard-coding ECT(1) as the only
classifier for this feature seems limiting, so let's expand it to be more
general.

To this end, change the parameter from a ce_threshold_ect1 boolean, to a
one-byte selector/mask pair (ce_threshold_{selector,mask}) which is applied
to the whole diffserv/ECN field in the IP header. This makes it possible to
classify packets by any value in either the ECN field or the diffserv
field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
INET_ECN_MASK corresponds to the functionality before this patch, and a
mask of ~INET_ECN_MASK allows using the selector as a straight-forward
match against a diffserv code point.

Regardless of the selector chosen, the normal rules for ECN-marking of
packets still apply, i.e., the flow must still declare itself ECN-capable
by setting one of the bits in the ECN field to get marked at all.

Fixes: e72aeb9ee0e3 ("fq_codel: implement L4S style ce_threshold_ect1 marking")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/net/codel.h            |  7 +++++--
 include/net/codel_impl.h       | 14 +++++++-------
 include/uapi/linux/pkt_sched.h |  3 ++-
 net/mac80211/sta_info.c        |  3 ++-
 net/sched/sch_fq_codel.c       | 13 +++++++++----
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/include/net/codel.h b/include/net/codel.h
index 5e8b181b76b8..a6c9e34e62b8 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -102,7 +102,9 @@ static inline u32 codel_time_to_us(codel_time_t val)
  * @interval:	width of moving time window
  * @mtu:	device mtu, or minimal queue backlog in bytes.
  * @ecn:	is Explicit Congestion Notification enabled
- * @ce_threshold_ect1: if ce_threshold only marks ECT(1) packets
+ * @ce_threshold_selector: apply ce_threshold to packets matching this value
+ *                         in the diffserv/ECN byte of the IP header
+ * @ce_threshold_mask: mask to apply to ce_threshold_selector comparison
  */
 struct codel_params {
 	codel_time_t	target;
@@ -110,7 +112,8 @@ struct codel_params {
 	codel_time_t	interval;
 	u32		mtu;
 	bool		ecn;
-	bool		ce_threshold_ect1;
+	u8		ce_threshold_selector;
+	u8		ce_threshold_mask;
 };
 
 /**
diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
index 7af2c3eb3c43..137d40d8cbeb 100644
--- a/include/net/codel_impl.h
+++ b/include/net/codel_impl.h
@@ -54,7 +54,8 @@ static void codel_params_init(struct codel_params *params)
 	params->interval = MS2TIME(100);
 	params->target = MS2TIME(5);
 	params->ce_threshold = CODEL_DISABLED_THRESHOLD;
-	params->ce_threshold_ect1 = false;
+	params->ce_threshold_mask = 0;
+	params->ce_threshold_selector = 0;
 	params->ecn = false;
 }
 
@@ -250,13 +251,12 @@ static struct sk_buff *codel_dequeue(void *ctx,
 	if (skb && codel_time_after(vars->ldelay, params->ce_threshold)) {
 		bool set_ce = true;
 
-		if (params->ce_threshold_ect1) {
-			/* Note: if skb_get_dsfield() returns -1, following
-			 * gives INET_ECN_MASK, which is != INET_ECN_ECT_1.
-			 */
-			u8 ecn = skb_get_dsfield(skb) & INET_ECN_MASK;
+		if (params->ce_threshold_mask) {
+			int dsfield = skb_get_dsfield(skb);
 
-			set_ce = (ecn == INET_ECN_ECT_1);
+			set_ce = (dsfield >= 0 &&
+				  (((u8)dsfield & params->ce_threshold_mask) ==
+				   params->ce_threshold_selector));
 		}
 		if (set_ce && INET_ECN_set_ce(skb))
 			stats->ce_mark++;
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 6be9a84cccfa..f292b467b27f 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -840,7 +840,8 @@ enum {
 	TCA_FQ_CODEL_CE_THRESHOLD,
 	TCA_FQ_CODEL_DROP_BATCH_SIZE,
 	TCA_FQ_CODEL_MEMORY_LIMIT,
-	TCA_FQ_CODEL_CE_THRESHOLD_ECT1,
+	TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR,
+	TCA_FQ_CODEL_CE_THRESHOLD_MASK,
 	__TCA_FQ_CODEL_MAX
 };
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index a39830418434..bd52ac3bee90 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -513,7 +513,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->cparams.target = MS2TIME(20);
 	sta->cparams.interval = MS2TIME(100);
 	sta->cparams.ecn = true;
-	sta->cparams.ce_threshold_ect1 = false;
+	sta->cparams.ce_threshold_selector = 0;
+	sta->cparams.ce_threshold_mask = 0;
 
 	sta_dbg(sdata, "Allocated STA %pM\n", sta->sta.addr);
 
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 033d65d06eb1..839e1235db05 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -362,7 +362,8 @@ static const struct nla_policy fq_codel_policy[TCA_FQ_CODEL_MAX + 1] = {
 	[TCA_FQ_CODEL_CE_THRESHOLD] = { .type = NLA_U32 },
 	[TCA_FQ_CODEL_DROP_BATCH_SIZE] = { .type = NLA_U32 },
 	[TCA_FQ_CODEL_MEMORY_LIMIT] = { .type = NLA_U32 },
-	[TCA_FQ_CODEL_CE_THRESHOLD_ECT1] = { .type = NLA_U8 },
+	[TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR] = { .type = NLA_U8 },
+	[TCA_FQ_CODEL_CE_THRESHOLD_MASK] = { .type = NLA_U8 },
 };
 
 static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
@@ -409,8 +410,10 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 		q->cparams.ce_threshold = (val * NSEC_PER_USEC) >> CODEL_SHIFT;
 	}
 
-	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1])
-		q->cparams.ce_threshold_ect1 = !!nla_get_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_ECT1]);
+	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR])
+		q->cparams.ce_threshold_selector = nla_get_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR]);
+	if (tb[TCA_FQ_CODEL_CE_THRESHOLD_MASK])
+		q->cparams.ce_threshold_mask = nla_get_u8(tb[TCA_FQ_CODEL_CE_THRESHOLD_MASK]);
 
 	if (tb[TCA_FQ_CODEL_INTERVAL]) {
 		u64 interval = nla_get_u32(tb[TCA_FQ_CODEL_INTERVAL]);
@@ -552,7 +555,9 @@ static int fq_codel_dump(struct Qdisc *sch, struct sk_buff *skb)
 		if (nla_put_u32(skb, TCA_FQ_CODEL_CE_THRESHOLD,
 				codel_time_to_us(q->cparams.ce_threshold)))
 			goto nla_put_failure;
-		if (nla_put_u8(skb, TCA_FQ_CODEL_CE_THRESHOLD_ECT1, q->cparams.ce_threshold_ect1))
+		if (nla_put_u8(skb, TCA_FQ_CODEL_CE_THRESHOLD_SELECTOR, q->cparams.ce_threshold_selector))
+			goto nla_put_failure;
+		if (nla_put_u8(skb, TCA_FQ_CODEL_CE_THRESHOLD_MASK, q->cparams.ce_threshold_mask))
 			goto nla_put_failure;
 	}
 
-- 
2.33.0

