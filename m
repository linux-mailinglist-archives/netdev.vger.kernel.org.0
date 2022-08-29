Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74A55A4B26
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiH2MLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiH2MK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:10:56 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2B02BE2;
        Mon, 29 Aug 2022 04:55:58 -0700 (PDT)
Received: by mail-wm1-f42.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso8044844wmc.0;
        Mon, 29 Aug 2022 04:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:from:to:cc;
        bh=IRQQodgrI0rD6EnFTbfw2xeJ3D9VPk4cilZ4rKqcs2s=;
        b=I2gVmNfGRk97P073p11Fzfpoyc8jaV4344s+6x4KYyqkS6KxaPxEgqOgN9IBzfgs98
         bpnrYyraIgjSQqwsyD0O/xQ4CkQiL31avQ172TXu1bkeWN+V6gAt3FVtALYDUD4Fc4dZ
         0i6LYUdM/iNJArhk8oPo0VbLXrkLsL6SHiKvneLgmq00JGCmkM0+yLzmyXLUQ0+RRS5j
         40GhMeoTcpaOc9A0wiCefIu1M3Sn9KCF8IEUDzoR8/hrcUbiW3d4U9hp5RGin/HHBEFb
         TFu8y7DwF0XIdB12y83MR758WPbQO31QN+z3jF+nLjUaGf38uK65ndmLr8MrG+k6mb0o
         VEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:content-disposition:mime-version:message-id:subject:to
         :from:date:x-gm-message-state:from:to:cc;
        bh=IRQQodgrI0rD6EnFTbfw2xeJ3D9VPk4cilZ4rKqcs2s=;
        b=Et85OrLTu1pmtbsjbMy2Gcrx5TO3brdkix/JRz2mVxXZG3S7pt50SLymA4Py98Ry3P
         ntXnAxCKC+VeJZ1ENOYIxfq0jVe+TQuWSBK9xkbuMH/ulqHUejZGTrJOJc/x8rePpsQ4
         Re6k5m8pYM8q0jj/lPHlGkktrlG4O76Cvi021bU8XjObRCR0ctasm9oPvJvGDaf1vUPm
         nEJHKkDiR4k0DTFuiUCtY/EPreVBHOh5BIK8gdjdr96g91qo0MDSA2VWKna72U2pRD8x
         zYcb8uxsymYTfClPsGao00ozKVg5tpj1VbmSvjzuY2fz/3CSasCjHpLwbhvpoj/oVj6V
         BAkg==
X-Gm-Message-State: ACgBeo3mqJQxMQw5YTMsJgyoRmcjn8n4dbtAQpq7tO89budd2W6voYIh
        FMKr1KxE/QIvugG7ajJ8nAM=
X-Google-Smtp-Source: AA6agR5+TRvLKL/hosvHkbd9eCcEl4Wk9DuFLZLrpdGPTJ0t4wvGsTFJIwtXVuOLW+wjIaYxu+H/Mw==
X-Received: by 2002:a05:600c:1c88:b0:3a8:3e79:7214 with SMTP id k8-20020a05600c1c8800b003a83e797214mr5101643wms.155.1661773782991;
        Mon, 29 Aug 2022 04:49:42 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id r10-20020adff10a000000b002211fc70174sm7851027wro.99.2022.08.29.04.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:49:42 -0700 (PDT)
Date:   Mon, 29 Aug 2022 13:47:49 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, alex.aring@gmail.com,
        stefan@datenfreihafen.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, kafai@fb.com,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 4/4] net-next: frags: dynamic timeout under load
Message-ID: <20220829114739.GA2436@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calculate a dynamic fragment reassembly timeout, taking into
consideration the current fqdir load and the load introduced by
the peer. Reintroduce low_thresh, which now acts as a knob for
adjusting per-peer memory limits.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  3 +++
 include/net/inet_frag.h                |  1 +
 net/ipv4/inet_fragment.c               | 30 +++++++++++++++++++++++++-
 net/ipv4/ip_fragment.c                 |  2 +-
 4 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 56cd4ea059b2..fb25aa6e22a2 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -247,6 +247,9 @@ ipfrag_low_thresh - LONG INTEGER
 	begins to remove incomplete fragment queues to free up resources.
 	The kernel still accepts new fragments for defragmentation.
 
+	(Since linux-6.1)
+	Maximum memory used to reassemble IP fragments sent by a single peer.
+
 ipfrag_time - INTEGER
 	Time in seconds to keep an IP fragment in memory.
 
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 077a0ec78a58..595a6db57a0e 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -99,6 +99,7 @@ struct inet_frag_queue {
 	u16			max_size;
 	struct fqdir		*fqdir;
 	struct inet_peer	*peer;
+	u64			timeout;
 	struct rcu_head		rcu;
 };
 
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 8b8d77d548d4..34c5ebba4951 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -314,6 +314,30 @@ void inet_frag_free(struct inet_frag_queue *q)
 	call_rcu(&q->rcu, inet_frag_destroy_rcu);
 }
 
+static int inet_frag_update_timeout(struct inet_frag_queue *q)
+{
+	u64 peer_timeout, inet_timeout;
+	long peer_mem, inet_mem;
+	long high_thresh = READ_ONCE(q->fqdir->high_thresh);
+	long low_thresh  = READ_ONCE(q->fqdir->low_thresh);
+	u64 base_timeout = READ_ONCE(q->fqdir->timeout);
+
+	peer_mem = low_thresh - peer_mem_limit(q);
+	inet_mem = high_thresh - frag_mem_limit(q->fqdir);
+
+	if (peer_mem <= 0 || inet_mem <= 0)
+		return -ENOMEM;
+
+	/* Timeout changes linearly with respect to the amount of free memory.
+	 * Choose the more permissive of the two timeouts, to avoid limiting
+	 * the system while there is still enough memory.
+	 */
+	peer_timeout = div64_long(base_timeout * peer_mem, low_thresh);
+	inet_timeout = div64_long(base_timeout * inet_mem, high_thresh);
+	q->timeout = max_t(u64, peer_timeout, inet_timeout);
+	return 0;
+}
+
 void inet_frag_destroy(struct inet_frag_queue *q)
 {
 	struct fqdir *fqdir;
@@ -346,6 +370,10 @@ static struct inet_frag_queue *inet_frag_alloc(struct fqdir *fqdir,
 
 	q->fqdir = fqdir;
 	f->constructor(q, arg);
+	if (inet_frag_update_timeout(q)) {
+		inet_frag_free(q);
+		return NULL;
+	}
 	add_frag_mem_limit(q, f->qsize);
 
 	timer_setup(&q->timer, f->frag_expire, 0);
@@ -367,7 +395,7 @@ static struct inet_frag_queue *inet_frag_create(struct fqdir *fqdir,
 		*prev = ERR_PTR(-ENOMEM);
 		return NULL;
 	}
-	mod_timer(&q->timer, jiffies + fqdir->timeout);
+	mod_timer(&q->timer, jiffies + q->timeout);
 
 	*prev = rhashtable_lookup_get_insert_key(&fqdir->rhashtable, &q->key,
 						 &q->node, f->rhash_params);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index e35061f6aadb..88a99242d721 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -236,7 +236,7 @@ static int ip_frag_reinit(struct ipq *qp)
 {
 	unsigned int sum_truesize = 0;
 
-	if (!mod_timer(&qp->q.timer, jiffies + qp->q.fqdir->timeout)) {
+	if (!mod_timer(&qp->q.timer, jiffies + qp->q.timeout)) {
 		refcount_inc(&qp->q.refcnt);
 		return -ETIMEDOUT;
 	}
-- 
2.36.1

