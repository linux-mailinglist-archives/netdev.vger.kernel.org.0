Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB425377ED
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234706AbiE3JON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiE3JOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:14:04 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AF77A478
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:14:00 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id bo5so10084173pfb.4
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 02:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/aO+jf2mfum2lozA0/bk+POhUodk65js+sUsVeQ8jAE=;
        b=LerkZnf5CPpcI69vtjO3F6lQ4rhXQ+cOQmDDyWyj2YYT806h3QAsMTVXZ5jUDA4sEs
         PaZ5oasFyx3OENvqoKZEyFzBI2xSzsreqBICLaHaube0AQ00n7StTn1hiSm5vuJStgAM
         sFC3meol5yFCSuW8wbvJMvKdcuWgTzDH18g6OXN0bO8e3AjY0hpxAj5l2NlNeZRKgGFT
         zrd+ZPUagBdzqto2bspQKnISbjkTsciJxhbdPn2UPqPdgQSqEi1vKYoboJrs7sm949nY
         obUwt+/Dx9Yj6zTyZNbySi3c7+qryxLK3vMY/HJb6VuEmbCEMeMh20YgqM3T69cb1ADc
         Mtpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/aO+jf2mfum2lozA0/bk+POhUodk65js+sUsVeQ8jAE=;
        b=2mj+TWRNX7QBO41yu7uK2QjevAGiqSeHAsF15Eral1HTP2MKgr+yQMS90RfnAF6zJf
         N4eBri4KsuLRoMmHz6UB4xFgT2yLBPPd5pp8c2gThgGDMotl5oFpt9nyNciE/RDvcygM
         9g4rR4JKGbkiOge0HJcuv9PTvKOqhWzz0u8Tk7ZRBinmf9sEnOBvL0PbK0F/p/MuUiBS
         QebPzh0HTZBnBQisiP/2lmSpXc2Ks/4agsl3xOwCLJnRqvbr38WPCvf8UsFYKdEq163H
         LnVOlqz3hxXztRgTbmZ1MKT0dkD7M/quUpZkl6PMGlR1UUZEwVW6MBL8HGyHXZA4hs+3
         YbSA==
X-Gm-Message-State: AOAM532XBpFa3H2qmNkZxGHB6s1dALR5Ce1PkWDTjU+bSUJxCt5HxuAH
        viNgEv6V2N2qAWFDF7gm8cGZi8ScVrAVeBcl
X-Google-Smtp-Source: ABdhPJyDwEZ/st38zGBwvrBthGjm2ezoOPEupdzo52oUsJnsJQ8bGkTrwFDGrWJxt5nucW0E2pakXA==
X-Received: by 2002:a63:9044:0:b0:3fa:27bf:448c with SMTP id a65-20020a639044000000b003fa27bf448cmr34298392pge.131.1653902039733;
        Mon, 30 May 2022 02:13:59 -0700 (PDT)
Received: from C02F52LSML85.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902ebc200b0015e8d4eb20dsm8640644plg.87.2022.05.30.02.13.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 May 2022 02:13:59 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        zhoufeng.zf@bytedance.com
Subject: [PATCH v3 1/2] bpf: avoid grabbing spin_locks of all cpus when no free elems
Date:   Mon, 30 May 2022 17:13:39 +0800
Message-Id: <20220530091340.53443-2-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
References: <20220530091340.53443-1-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

This patch add is_empty in pcpu_freelist_head to check freelist
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
freelist having no free elems will be changed, the performance will be better.

Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 kernel/bpf/percpu_freelist.c | 28 +++++++++++++++++++++++++---
 kernel/bpf/percpu_freelist.h |  1 +
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 3d897de89061..f83eb63720d4 100644
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
@@ -130,14 +134,19 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 	orig_cpu = cpu = raw_smp_processor_id();
 	while (1) {
 		head = per_cpu_ptr(s->freelist, cpu);
+		if (head->is_empty)
+			goto next_cpu;
 		raw_spin_lock(&head->lock);
 		node = head->first;
 		if (node) {
 			head->first = node->next;
+			if (!head->first)
+				head->is_empty = true;
 			raw_spin_unlock(&head->lock);
 			return node;
 		}
 		raw_spin_unlock(&head->lock);
+next_cpu:
 		cpu = cpumask_next(cpu, cpu_possible_mask);
 		if (cpu >= nr_cpu_ids)
 			cpu = 0;
@@ -146,10 +155,15 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
 	}
 
 	/* per cpu lists are all empty, try extralist */
+	if (s->extralist.is_empty)
+		return NULL;
 	raw_spin_lock(&s->extralist.lock);
 	node = s->extralist.first;
-	if (node)
+	if (node) {
 		s->extralist.first = node->next;
+		if (!s->extralist.first)
+			s->extralist.is_empty = true;
+	}
 	raw_spin_unlock(&s->extralist.lock);
 	return node;
 }
@@ -164,15 +178,20 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
 	orig_cpu = cpu = raw_smp_processor_id();
 	while (1) {
 		head = per_cpu_ptr(s->freelist, cpu);
+		if (head->is_empty)
+			goto next_cpu;
 		if (raw_spin_trylock(&head->lock)) {
 			node = head->first;
 			if (node) {
 				head->first = node->next;
+				if (!head->first)
+					head->is_empty = true;
 				raw_spin_unlock(&head->lock);
 				return node;
 			}
 			raw_spin_unlock(&head->lock);
 		}
+next_cpu:
 		cpu = cpumask_next(cpu, cpu_possible_mask);
 		if (cpu >= nr_cpu_ids)
 			cpu = 0;
@@ -181,11 +200,14 @@ ___pcpu_freelist_pop_nmi(struct pcpu_freelist *s)
 	}
 
 	/* cannot pop from per cpu lists, try extralist */
-	if (!raw_spin_trylock(&s->extralist.lock))
+	if (s->extralist.is_empty || !raw_spin_trylock(&s->extralist.lock))
 		return NULL;
 	node = s->extralist.first;
-	if (node)
+	if (node) {
 		s->extralist.first = node->next;
+		if (!s->extralist.first)
+			s->extralist.is_empty = true;
+	}
 	raw_spin_unlock(&s->extralist.lock);
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

