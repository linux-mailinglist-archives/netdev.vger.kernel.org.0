Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B635258A86
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgIAIj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgIAIj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:39:57 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F09BC061244;
        Tue,  1 Sep 2020 01:39:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c142so395975pfb.7;
        Tue, 01 Sep 2020 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAUzFX3GHFt9VC8VV2i+/H/3rq3wYZlwv9O+CT0MnS4=;
        b=JVvXhMOS6wiswcHFXVH9IWhgE4eAfvJMWlC4D2dp9D2Ub/9tLM1Lz6vIkl1e/dCAxx
         QKoW59z02IMQ0UmwZSWYYN1Hia8Tr8HyzCgsbAGw0K2FeNoRzcXzkZ4qIQJrkxjJcfa+
         haWdPAikYH5h/qCXfOszY8QD+vPUqkFTeoAW5SvC7gZwI1nF/pF2z9pxpkwQxIfAnSNq
         jKBl1ei2V0pdViz3smqW1Vq4TxI4kvnuzoZUz7KH+Q2RUp9tbhQ+vSiEAp7euR5hVJdh
         K/q013PM6bEp69XR7g6PlBktSRuVUNFSRJC/ziZegSKxB9Pl8GZlM4RfA3SYDa8qUnXY
         JLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAUzFX3GHFt9VC8VV2i+/H/3rq3wYZlwv9O+CT0MnS4=;
        b=uehv0HBhbXeAoLcfu3MmZ/7UaTJ1HJ+m68Hob55gPP20IbozNuxrj4EfO8fqZ7QnwC
         +NOf0y0XyxNJYIGZ+E4aouCai+pev5ZyM+OrttvY/F/oqoiw+UB9+hC/IGa36HcNY7k+
         GQ01fyWKwNF24GvTKt2M6i3qm1QrTikwiVDRv0/qMZ5tL1MU7K5Y5vUkDQa5WLdSJJo9
         ksYekqUBSsmCddwJCiWPvw6y55IkUavdNR62z07CIMz8swyjNAN1iqLuJAIgFlUQDiYA
         Kh7YU74xoh3g8G3i9Cziy7QY6aGMVHbRj3ss4d360PN2rnsQN9gefWKafJlSKSBfe7P0
         qkcw==
X-Gm-Message-State: AOAM533wFTbHcUnVu3ka0GUKpqHMo2hAAm5XYKnycrbU5FdqUMJnT7iP
        gSJ3D28cyR2LGLQmipV0i2k=
X-Google-Smtp-Source: ABdhPJwQx5aQ7+rcvwjWXN0C/kMWfCzdLW2RGzqNeH1F5KvTt+bAH8CXAJkKMsyNpTSXbXVRuluVFg==
X-Received: by 2002:a63:1341:: with SMTP id 1mr615307pgt.144.1598949596604;
        Tue, 01 Sep 2020 01:39:56 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id c201sm979003pfb.216.2020.09.01.01.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 01:39:56 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org, toke@redhat.com,
        brouer@redhat.com, dsahern@gmail.com
Subject: [PATCH bpf-next v2] bpf: {cpu,dev}map: change various functions return type from int to void
Date:   Tue,  1 Sep 2020 10:39:28 +0200
Message-Id: <20200901083928.6199-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The functions bq_enqueue(), bq_flush_to_queue(), and bq_xmit_all() in
{cpu,dev}map.c always return zero. Changing the return type from int
to void makes the code easier to follow.

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/cpumap.c | 11 +++--------
 kernel/bpf/devmap.c | 15 +++++++--------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 8d2a8623d2a7..cf548fc88780 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -79,8 +79,6 @@ struct bpf_cpu_map {
 
 static DEFINE_PER_CPU(struct list_head, cpu_map_flush_list);
 
-static int bq_flush_to_queue(struct xdp_bulk_queue *bq);
-
 static struct bpf_map *cpu_map_alloc(union bpf_attr *attr)
 {
 	u32 value_size = attr->value_size;
@@ -670,7 +668,7 @@ const struct bpf_map_ops cpu_map_ops = {
 	.map_btf_id		= &cpu_map_btf_id,
 };
 
-static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
+static void bq_flush_to_queue(struct xdp_bulk_queue *bq)
 {
 	struct bpf_cpu_map_entry *rcpu = bq->obj;
 	unsigned int processed = 0, drops = 0;
@@ -679,7 +677,7 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
 	int i;
 
 	if (unlikely(!bq->count))
-		return 0;
+		return;
 
 	q = rcpu->queue;
 	spin_lock(&q->producer_lock);
@@ -702,13 +700,12 @@ static int bq_flush_to_queue(struct xdp_bulk_queue *bq)
 
 	/* Feedback loop via tracepoints */
 	trace_xdp_cpumap_enqueue(rcpu->map_id, processed, drops, to_cpu);
-	return 0;
 }
 
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
  * Thus, safe percpu variable access.
  */
-static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
+static void bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 {
 	struct list_head *flush_list = this_cpu_ptr(&cpu_map_flush_list);
 	struct xdp_bulk_queue *bq = this_cpu_ptr(rcpu->bulkq);
@@ -729,8 +726,6 @@ static int bq_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_frame *xdpf)
 
 	if (!bq->flush_node.prev)
 		list_add(&bq->flush_node, flush_list);
-
-	return 0;
 }
 
 int cpu_map_enqueue(struct bpf_cpu_map_entry *rcpu, struct xdp_buff *xdp,
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index a42052b85c35..2b5ca93c17de 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -341,14 +341,14 @@ bool dev_map_can_have_prog(struct bpf_map *map)
 	return false;
 }
 
-static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
+static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
 	int sent = 0, drops = 0, err = 0;
 	int i;
 
 	if (unlikely(!bq->count))
-		return 0;
+		return;
 
 	for (i = 0; i < bq->count; i++) {
 		struct xdp_frame *xdpf = bq->q[i];
@@ -369,7 +369,7 @@ static int bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
 	bq->dev_rx = NULL;
 	__list_del_clearprev(&bq->flush_node);
-	return 0;
+	return;
 error:
 	/* If ndo_xdp_xmit fails with an errno, no frames have been
 	 * xmit'ed and it's our responsibility to them free all.
@@ -421,8 +421,8 @@ struct bpf_dtab_netdev *__dev_map_lookup_elem(struct bpf_map *map, u32 key)
 /* Runs under RCU-read-side, plus in softirq under NAPI protection.
  * Thus, safe percpu variable access.
  */
-static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
-		      struct net_device *dev_rx)
+static void bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
+		       struct net_device *dev_rx)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_flush_list);
 	struct xdp_dev_bulk_queue *bq = this_cpu_ptr(dev->xdp_bulkq);
@@ -441,8 +441,6 @@ static int bq_enqueue(struct net_device *dev, struct xdp_frame *xdpf,
 
 	if (!bq->flush_node.prev)
 		list_add(&bq->flush_node, flush_list);
-
-	return 0;
 }
 
 static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
@@ -462,7 +460,8 @@ static inline int __xdp_enqueue(struct net_device *dev, struct xdp_buff *xdp,
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
 
-	return bq_enqueue(dev, xdpf, dev_rx);
+	bq_enqueue(dev, xdpf, dev_rx);
+	return 0;
 }
 
 static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
-- 
2.25.1

