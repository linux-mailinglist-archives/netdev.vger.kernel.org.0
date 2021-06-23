Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D9C3B187A
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 13:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhFWLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 07:10:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37771 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230174AbhFWLJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 07:09:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624446456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/RD8INVqrZhxhRYQu3p0iItEELqlKBFxEmUhyTn65o=;
        b=DFYu4DMGN3RwHXbmP+9cbPQYkVulaUttcBP5F6xoMiL3WYv7xAUugigQMpBQKAy8KX2hEC
        llUb8OpUfp507cq1L+O4LMaYhS8VHNHtDc/Fva2hAZUrdRx8rdJj9s5Kxtap1PR6ozFZzV
        aDDmugyzuvxZfLWpYcWCjO7Vbj2b89A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-9UrXy0KJNhqXC8xtWcrbqA-1; Wed, 23 Jun 2021 07:07:35 -0400
X-MC-Unique: 9UrXy0KJNhqXC8xtWcrbqA-1
Received: by mail-ej1-f70.google.com with SMTP id w13-20020a170906384db02903d9ad6b26d8so868174ejc.0
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 04:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w/RD8INVqrZhxhRYQu3p0iItEELqlKBFxEmUhyTn65o=;
        b=Vra41TDCxIqTH3c6dWfIiA/WKuFb/IWA/dkgpxjH2s6gghDsBrkOAimN/Ms5YTmpr/
         Hue35qO1gvlH8PxayHJoAlcvctSg3+mDZ6vSMcusUwWkk2gjlWOZie9oQe91nybuywhv
         zj5kvD49ZhbFRsNQ9iX6dfHQStQl/RhzPd0gq40f06DppXrvuJUp6C1Jaj5Qeakd82Zv
         mGA9YG4evSDVezdlhLVJ97SB1TWRuKY9jOHMtT6Q4lSkSGX30AMMmEUjSytVuGnzT+mL
         +oaAM6IHisX5tRl2QSmJF9uBA/8rvwKf8FputJkrKG3oE4MQoMWdrXMDO+KtM1Q/MvKy
         ZA4w==
X-Gm-Message-State: AOAM5323muKABF2MD7zgdy282hnTQ28KnK2R+XC8/CGKl0ze5SQg5PA1
        lEVBUHZ8Xb17K7DAW8CB8lNp6mblT3rewFXwDh7gD0y6Rj8AJdiLW6fLLa6C4ku8WN13pmAqNr0
        0dNCF9WsMfcN7xc80
X-Received: by 2002:a05:6402:18f6:: with SMTP id x54mr11865253edy.53.1624446454209;
        Wed, 23 Jun 2021 04:07:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkLnLptVgUW3clOL3nBx1FYnj3knCIVTef6R4LuM+oJs85AS2SKwdWmRQkxek9cThzk7dCeg==
X-Received: by 2002:a05:6402:18f6:: with SMTP id x54mr11865234edy.53.1624446454079;
        Wed, 23 Jun 2021 04:07:34 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id z20sm7246260ejd.18.2021.06.23.04.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 04:07:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1DB33180736; Wed, 23 Jun 2021 13:07:28 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 06/19] sched: remove unneeded rcu_read_lock() around BPF program invocation
Date:   Wed, 23 Jun 2021 13:07:14 +0200
Message-Id: <20210623110727.221922-7-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623110727.221922-1-toke@redhat.com>
References: <20210623110727.221922-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rcu_read_lock() call in cls_bpf and act_bpf are redundant: on the TX
side, there's already a call to rcu_read_lock_bh() in __dev_queue_xmit(),
and on RX there's a covering rcu_read_lock() in
netif_receive_skb{,_list}_internal().

With the previous patches we also amended the lockdep checks in the map
code to not require any particular RCU flavour, so we can just get rid of
the rcu_read_lock()s.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/sched/act_bpf.c | 2 --
 net/sched/cls_bpf.c | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index e48e980c3b93..e409a0005717 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -43,7 +43,6 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 	tcf_lastuse_update(&prog->tcf_tm);
 	bstats_cpu_update(this_cpu_ptr(prog->common.cpu_bstats), skb);
 
-	rcu_read_lock();
 	filter = rcu_dereference(prog->filter);
 	if (at_ingress) {
 		__skb_push(skb, skb->mac_len);
@@ -56,7 +55,6 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 	}
 	if (skb_sk_is_prefetched(skb) && filter_res != TC_ACT_OK)
 		skb_orphan(skb);
-	rcu_read_unlock();
 
 	/* A BPF program may overwrite the default action opcode.
 	 * Similarly as in cls_bpf, if filter_res == -1 we use the
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 6e3e63db0e01..fa739efa59f4 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -85,8 +85,6 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	struct cls_bpf_prog *prog;
 	int ret = -1;
 
-	/* Needed here for accessing maps. */
-	rcu_read_lock();
 	list_for_each_entry_rcu(prog, &head->plist, link) {
 		int filter_res;
 
@@ -131,7 +129,6 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 
 		break;
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
-- 
2.32.0

