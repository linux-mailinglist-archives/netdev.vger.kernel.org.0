Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B57552B25B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiERG1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiERG1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:27:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D261D9EBA
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:27:28 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w17-20020a17090a529100b001db302efed6so1067814pjh.4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZTyFHE2cz+h0U321aUqbYjcSf8Z4cJcvd5lyDcw/ys0=;
        b=aUG1sGuOr3P+P+SZqoPdfwwfcWgnRch2ZckkTTZpNsgi17cECqFGVaDSZqx22Q5+7B
         4BbobRgQ8qpqSBVivroFE23BGd94aKkCuYHBV2UZtld7UpXDH8vW3p9HtVC6VZqbvH2D
         DNaLT2HBBjcSfl49TcKvL1YgYAM2Gpu4iaoKISnbflTJ/W45qIonGuovvpFxUFC5lg3u
         HJHCaY+iI+lnk1UKVdtZ37BrLvOSf8cae+66i7DaKAEf2+EpRuDfzmBpcnyDNSHDxcHJ
         mL/TPKAK/RLg9E2gtAKy8Y6PmyyKVYzYVygCylfDO575e+id6pbDJGhqi1iu0t59tnCi
         uq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZTyFHE2cz+h0U321aUqbYjcSf8Z4cJcvd5lyDcw/ys0=;
        b=c1szqaoFyjaqNuVDLjtTYdMcpXcpuBuroNqv2YUVs5cnoFUdBnSp74DyJSpLb2/Ix9
         sCmmTC49e10APKDnOBzBpK5yY1OSTdTA5CjbwY03MxBE+vSdbs0OsMgOUfniFPVcCieX
         IjE+Cxl+mpasfmU9IBQvI1VJ3YnZknEJNYU7R8mx6HxJI5v9PiZVB0RNg8IsqTMqYlfL
         6CbWLrsZjO9vZ9cBO5XQTnmHRBHG4mvZsbOTNIylTLYWVUSDU3c/9v1ljfQtm9xbIjop
         sIftTjsGsqJ9x0fQyUsjyq9DMBRce4xceWtSF8w0YpWBIDld8cS5agkEwqb1D6+bZkQB
         sK3A==
X-Gm-Message-State: AOAM532f9FeC7MPY7FTTFpkB4FMS0q5lDdBO2alKJGBNd+g9zGc9xsZ0
        0SiTLM8fjowxoTpOLklMNO9i4g==
X-Google-Smtp-Source: ABdhPJxxesNLUzNTFhsvyxKlpWxUyou6xrEE+r8VIxCxIODGMJTZHbr79ZNg9EuqaRDwq0ESX8kDeA==
X-Received: by 2002:a17:902:aa06:b0:158:f13b:4859 with SMTP id be6-20020a170902aa0600b00158f13b4859mr26082683plb.141.1652855247724;
        Tue, 17 May 2022 23:27:27 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id x21-20020a1709027c1500b001613dfe1678sm701896pll.273.2022.05.17.23.27.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 May 2022 23:27:27 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH] bpf: avoid grabbing spin_locks of all cpus when no free elems
Date:   Wed, 18 May 2022 14:27:15 +0800
Message-Id: <20220518062715.27809-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

We encountered bad case on big system with 96 CPUs that
alloc_htab_elem() would last for 1ms. The reason is that after the
prealloc hashtab has no free elems, when trying to update, it will still
grab spin_locks of all cpus. If there are multiple update users, the
competition is very serious.

So this patch add is_empty in pcpu_freelist_head to check freelist
having free or not. If having, grab spin_lock, or check next cpu's
freelist.

Before patch: hash_map performance
./map_perf_test 1
0:hash_map_perf pre-alloc 975345 events per sec
4:hash_map_perf pre-alloc 855367 events per sec
12:hash_map_perf pre-alloc 860862 events per sec
8:hash_map_perf pre-alloc 849561 events per sec
3:hash_map_perf pre-alloc 849074 events per sec
6:hash_map_perf pre-alloc 847120 events per sec
10:hash_map_perf pre-alloc 845047 events per sec
5:hash_map_perf pre-alloc 841266 events per sec
14:hash_map_perf pre-alloc 849740 events per sec
2:hash_map_perf pre-alloc 839598 events per sec
9:hash_map_perf pre-alloc 838695 events per sec
11:hash_map_perf pre-alloc 845390 events per sec
7:hash_map_perf pre-alloc 834865 events per sec
13:hash_map_perf pre-alloc 842619 events per sec
1:hash_map_perf pre-alloc 804231 events per sec
15:hash_map_perf pre-alloc 795314 events per sec

hash_map the worst: no free
./map_perf_test 2048
6:worse hash_map_perf pre-alloc 28628 events per sec
5:worse hash_map_perf pre-alloc 28553 events per sec
11:worse hash_map_perf pre-alloc 28543 events per sec
3:worse hash_map_perf pre-alloc 28444 events per sec
1:worse hash_map_perf pre-alloc 28418 events per sec
7:worse hash_map_perf pre-alloc 28427 events per sec
13:worse hash_map_perf pre-alloc 28330 events per sec
14:worse hash_map_perf pre-alloc 28263 events per sec
9:worse hash_map_perf pre-alloc 28211 events per sec
15:worse hash_map_perf pre-alloc 28193 events per sec
12:worse hash_map_perf pre-alloc 28190 events per sec
10:worse hash_map_perf pre-alloc 28129 events per sec
8:worse hash_map_perf pre-alloc 28116 events per sec
4:worse hash_map_perf pre-alloc 27906 events per sec
2:worse hash_map_perf pre-alloc 27801 events per sec
0:worse hash_map_perf pre-alloc 27416 events per sec
3:worse hash_map_perf pre-alloc 28188 events per sec

ftrace trace

0)               |  htab_map_update_elem() {
0)   0.198 us    |    migrate_disable();
0)               |    _raw_spin_lock_irqsave() {
0)   0.157 us    |      preempt_count_add();
0)   0.538 us    |    }
0)   0.260 us    |    lookup_elem_raw();
0)               |    alloc_htab_elem() {
0)               |      __pcpu_freelist_pop() {
0)               |        _raw_spin_lock() {
0)   0.152 us    |          preempt_count_add();
0)   0.352 us    |          native_queued_spin_lock_slowpath();
0)   1.065 us    |        }
		 |	  ...
0)               |        _raw_spin_unlock() {
0)   0.254 us    |          preempt_count_sub();
0)   0.555 us    |        }
0) + 25.188 us   |      }
0) + 25.486 us   |    }
0)               |    _raw_spin_unlock_irqrestore() {
0)   0.155 us    |      preempt_count_sub();
0)   0.454 us    |    }
0)   0.148 us    |    migrate_enable();
0) + 28.439 us   |  }

The test machine is 16C, trying to get spin_lock 17 times, in addition
to 16c, there is an extralist.

after patch: hash_map performance
./map_perf_test 1
0:hash_map_perf pre-alloc 969348 events per sec
10:hash_map_perf pre-alloc 906526 events per sec
11:hash_map_perf pre-alloc 904557 events per sec
9:hash_map_perf pre-alloc 902384 events per sec
15:hash_map_perf pre-alloc 912287 events per sec
14:hash_map_perf pre-alloc 905689 events per sec
12:hash_map_perf pre-alloc 903680 events per sec
13:hash_map_perf pre-alloc 902631 events per sec
8:hash_map_perf pre-alloc 875369 events per sec
4:hash_map_perf pre-alloc 862808 events per sec
1:hash_map_perf pre-alloc 857218 events per sec
2:hash_map_perf pre-alloc 852875 events per sec
5:hash_map_perf pre-alloc 846497 events per sec
6:hash_map_perf pre-alloc 828467 events per sec
3:hash_map_perf pre-alloc 812542 events per sec
7:hash_map_perf pre-alloc 805336 events per sec

hash_map worst: no free
./map_perf_test 2048
7:worse hash_map_perf pre-alloc 391104 events per sec
4:worse hash_map_perf pre-alloc 388073 events per sec
5:worse hash_map_perf pre-alloc 387038 events per sec
1:worse hash_map_perf pre-alloc 386546 events per sec
0:worse hash_map_perf pre-alloc 384590 events per sec
11:worse hash_map_perf pre-alloc 379378 events per sec
10:worse hash_map_perf pre-alloc 375480 events per sec
12:worse hash_map_perf pre-alloc 372394 events per sec
6:worse hash_map_perf pre-alloc 367692 events per sec
3:worse hash_map_perf pre-alloc 363970 events per sec
9:worse hash_map_perf pre-alloc 364008 events per sec
8:worse hash_map_perf pre-alloc 363759 events per sec
2:worse hash_map_perf pre-alloc 360743 events per sec
14:worse hash_map_perf pre-alloc 361195 events per sec
13:worse hash_map_perf pre-alloc 360276 events per sec
15:worse hash_map_perf pre-alloc 360057 events per sec
0:worse hash_map_perf pre-alloc 378177 events per sec

ftrace trace
0)               |  htab_map_update_elem() {
0)   0.317 us    |    migrate_disable();
0)               |    _raw_spin_lock_irqsave() {
0)   0.260 us    |      preempt_count_add();
0)   1.803 us    |    }
0)   0.276 us    |    lookup_elem_raw();
0)               |    alloc_htab_elem() {
0)   0.586 us    |      __pcpu_freelist_pop();
0)   0.945 us    |    }
0)               |    _raw_spin_unlock_irqrestore() {
0)   0.160 us    |      preempt_count_sub();
0)   0.972 us    |    }
0)   0.657 us    |    migrate_enable();
0)   8.669 us    |  }

It can be seen that after adding this patch, the map performance is
almost not degraded, and when free=0, first check is_empty instead of
directly acquiring spin_lock.

As for why to add is_empty instead of directly judging head->first, my
understanding is this, head->first is frequently modified during updating
map, which will lead to invalid other cpus's cache, and is_empty is after
freelist having no free elems will be changed, the performance will be
better.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 kernel/bpf/percpu_freelist.c | 68 ++++++++++++++++++++++++------------
 kernel/bpf/percpu_freelist.h |  1 +
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 3d897de89061..abc148c8cae1 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -16,9 +16,11 @@ int pcpu_freelist_init(struct pcpu_freelist *s)
 
 		raw_spin_lock_init(&head->lock);
 		head->first = NULL;
+		head->is_empty = true;
 	}
 	raw_spin_lock_init(&s->extralist.lock);
 	s->extralist.first = NULL;
+	s->extralist.is_empty = true;
 	return 0;
 }
 
@@ -32,6 +34,8 @@ static inline void pcpu_freelist_push_node(struct pcpu_freelist_head *head,
 {
 	node->next = head->first;
 	head->first = node;
+	if (head->is_empty)
+		head->is_empty = false;
 }
 
 static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
@@ -130,14 +134,18 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 	orig_cpu = cpu = raw_smp_processor_id();
 	while (1) {
 		head = per_cpu_ptr(s->freelist, cpu);
-		raw_spin_lock(&head->lock);
-		node = head->first;
-		if (node) {
-			head->first = node->next;
+		if (!head->is_empty) {
+			raw_spin_lock(&head->lock);
+			node = head->first;
+			if (node) {
+				head->first = node->next;
+				if (!head->first)
+					head->is_empty = true;
+				raw_spin_unlock(&head->lock);
+				return node;
+			}
 			raw_spin_unlock(&head->lock);
-			return node;
 		}
-		raw_spin_unlock(&head->lock);
 		cpu = cpumask_next(cpu, cpu_possible_mask);
 		if (cpu >= nr_cpu_ids)
 			cpu = 0;
@@ -146,11 +154,16 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 	}
 
 	/* per cpu lists are all empty, try extralist */
-	raw_spin_lock(&s->extralist.lock);
-	node = s->extralist.first;
-	if (node)
-		s->extralist.first = node->next;
-	raw_spin_unlock(&s->extralist.lock);
+	if (!s->extralist.is_empty) {
+		raw_spin_lock(&s->extralist.lock);
+		node = s->extralist.first;
+		if (node) {
+			s->extralist.first = node->next;
+			if (!s->extralist.first)
+				s->extralist.is_empty = true;
+		}
+		raw_spin_unlock(&s->extralist.lock);
+	}
 	return node;
 }
 
@@ -164,14 +177,18 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
 	orig_cpu = cpu = raw_smp_processor_id();
 	while (1) {
 		head = per_cpu_ptr(s->freelist, cpu);
-		if (raw_spin_trylock(&head->lock)) {
-			node = head->first;
-			if (node) {
-				head->first = node->next;
+		if (!head->is_empty) {
+			if (raw_spin_trylock(&head->lock)) {
+				node = head->first;
+				if (node) {
+					head->first = node->next;
+					if (!head->first)
+						head->is_empty = true;
+					raw_spin_unlock(&head->lock);
+					return node;
+				}
 				raw_spin_unlock(&head->lock);
-				return node;
 			}
-			raw_spin_unlock(&head->lock);
 		}
 		cpu = cpumask_next(cpu, cpu_possible_mask);
 		if (cpu >= nr_cpu_ids)
@@ -181,12 +198,17 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
 	}
 
 	/* cannot pop from per cpu lists, try extralist */
-	if (!raw_spin_trylock(&s->extralist.lock))
-		return NULL;
-	node = s->extralist.first;
-	if (node)
-		s->extralist.first = node->next;
-	raw_spin_unlock(&s->extralist.lock);
+	if (!s->extralist.is_empty) {
+		if (!raw_spin_trylock(&s->extralist.lock))
+			return NULL;
+		node = s->extralist.first;
+		if (node) {
+			s->extralist.first = node->next;
+			if (!s->extralist.first)
+				s->extralist.is_empty = true;
+		}
+		raw_spin_unlock(&s->extralist.lock);
+	}
 	return node;
 }
 
diff --git a/kernel/bpf/percpu_freelist.h b/kernel/bpf/percpu_freelist.h
index 3c76553cfe57..9e4545631ed5 100644
--- a/kernel/bpf/percpu_freelist.h
+++ b/kernel/bpf/percpu_freelist.h
@@ -9,6 +9,7 @@
 struct pcpu_freelist_head {
 	struct pcpu_freelist_node *first;
 	raw_spinlock_t lock;
+	bool is_empty;
 };
 
 struct pcpu_freelist {
-- 
2.20.1

