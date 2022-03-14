Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2AB4D8BB5
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243827AbiCNSWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243172AbiCNSWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:22:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5DE40916;
        Mon, 14 Mar 2022 11:20:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mm23-20020a17090b359700b001bfceefd8c6so34570pjb.3;
        Mon, 14 Mar 2022 11:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RF+1tKIxbhkbd34MY/Kw4KvXJeW1v+//VaSxu1I3Lhk=;
        b=ofPzwpkpIafxeiIvIEj65F2HbQ+4CpKdEqYh0AgcgzF78Ka22NqmaALXB6bvgnkbz/
         QbqLekESMX+3YfZJBmSy05SMOcBfEJRGgfb298RP2Iz38OvLn4MbZvuOcY6aTLdBayQn
         Nwt7ttQwCM/C8aJRbTxcGREbfqlzvdPi9I/sIBztkRPzKgv79mNOthJ276ZD0P/hjBgL
         VLCjzo/EnqjPw3EwcFP/sPxQsk85G97Cu/uxNjekUIzVpwaS35kp23PEYaXgHEHhMTrP
         A1ALXf+VejeizTXKreVW4AfFdgjV5nL8R1fuw3tACMwRwTubSTHpvxd4uRpqvMOVnsIO
         hZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=RF+1tKIxbhkbd34MY/Kw4KvXJeW1v+//VaSxu1I3Lhk=;
        b=Mg84iTWFFJgYM0kegOMQpxGlcLCCegk0pgN7OoMVr7xvEgnNVmd/3VoS/EHuri/fU7
         mcM1Cd+eCNTGIS6n9dEJwU4OKiv0E6qO2z3nkR+I3tXomArA6tYeIzYL2iX3RXVqGdL6
         coyFEpA2Dhg5NaqNCzsKCk9MMnhg6G+lO8eR9id87SIgbhXX/IfMQAz+YKCnshCD0nG/
         YLoVVPv5uVF/4wm/X3RMUjU3ngdDZcvVPKV7L8bUdH+ys/KgzWCa2fZVqnA76eRnn0HM
         LTRWK1i3ZQdIx6AcqpyNkVHBzVhXi8MMbtn71ZK/7SU+Y6coWUWXeyILapg2NgDD/UIR
         1Www==
X-Gm-Message-State: AOAM532pNQN3QDmGg+lq7ka+iFPg1HPFstNgL2/ZW2lgJkDAZfjU7x8h
        0UzQcQ3czFlKZq/P8FSdlrI=
X-Google-Smtp-Source: ABdhPJwS1VYy1ociN4ZAKgptmE5nqkK/AuRcEgvLOtmnF+ZgrOfUqymbqkCTEGefXd75Q0P8ZInfxA==
X-Received: by 2002:a17:902:f681:b0:151:d88b:ebde with SMTP id l1-20020a170902f68100b00151d88bebdemr24357022plg.159.1647282045671;
        Mon, 14 Mar 2022 11:20:45 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4800:3540:62a:d25b:6c78:634e])
        by smtp.gmail.com with ESMTPSA id o65-20020a17090a0a4700b001bef5cffea7sm619410pjo.0.2022.03.14.11.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 11:20:45 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
Subject: [PATCH v3 1/2] bpf: Adjust BPF stack helper functions to accommodate skip > 0
Date:   Mon, 14 Mar 2022 11:20:41 -0700
Message-Id: <20220314182042.71025-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's say that the caller has storage for num_elem stack frames.  Then,
the BPF stack helper functions walk the stack for only num_elem frames.
This means that if skip > 0, one keeps only 'num_elem - skip' frames.

This is because it sets init_nr in the perf_callchain_entry to the end
of the buffer to save num_elem entries only.  I believe it was because
the perf callchain code unwound the stack frames until it reached the
global max size (sysctl_perf_event_max_stack).

However it now has perf_callchain_entry_ctx.max_stack to limit the
iteration locally.  This simplifies the code to handle init_nr in the
BPF callstack entries and removes the confusion with the perf_event's
__PERF_SAMPLE_CALLCHAIN_EARLY which sets init_nr to 0.

Also change the comment on bpf_get_stack() in the header file to be
more explicit what the return value means.

Link: https://lore.kernel.org/bpf/30a7b5d5-6726-1cc2-eaee-8da2828a9a9c@oracle.com

Fixes: c195651e565a ("bpf: add bpf_get_stack helper")
Based-on-patch-by: Eugene Loh <eugene.loh@oracle.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 include/uapi/linux/bpf.h |  8 +++---
 kernel/bpf/stackmap.c    | 56 +++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b0383d371b9a..f09f20845904 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2975,8 +2975,8 @@ union bpf_attr {
  *
  * 			# sysctl kernel.perf_event_max_stack=<new value>
  * 	Return
- * 		A non-negative value equal to or less than *size* on success,
- * 		or a negative error in case of failure.
+ * 		The non-negative copied *buf* length equal to or less than
+ * 		*size* on success, or a negative error in case of failure.
  *
  * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
  * 	Description
@@ -4279,8 +4279,8 @@ union bpf_attr {
  *
  *			# sysctl kernel.perf_event_max_stack=<new value>
  *	Return
- *		A non-negative value equal to or less than *size* on success,
- *		or a negative error in case of failure.
+ * 		The non-negative copied *buf* length equal to or less than
+ * 		*size* on success, or a negative error in case of failure.
  *
  * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res, u32 len, u64 flags)
  *	Description
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 22c8ae94e4c1..2823dcefae10 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -166,7 +166,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 }
 
 static struct perf_callchain_entry *
-get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
+get_callchain_entry_for_task(struct task_struct *task, u32 max_depth)
 {
 #ifdef CONFIG_STACKTRACE
 	struct perf_callchain_entry *entry;
@@ -177,9 +177,8 @@ get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
 	if (!entry)
 		return NULL;
 
-	entry->nr = init_nr +
-		stack_trace_save_tsk(task, (unsigned long *)(entry->ip + init_nr),
-				     sysctl_perf_event_max_stack - init_nr, 0);
+	entry->nr = stack_trace_save_tsk(task, (unsigned long *)entry->ip,
+					 max_depth, 0);
 
 	/* stack_trace_save_tsk() works on unsigned long array, while
 	 * perf_callchain_entry uses u64 array. For 32-bit systems, it is
@@ -191,7 +190,7 @@ get_callchain_entry_for_task(struct task_struct *task, u32 init_nr)
 		int i;
 
 		/* copy data from the end to avoid using extra buffer */
-		for (i = entry->nr - 1; i >= (int)init_nr; i--)
+		for (i = entry->nr - 1; i >= 0; i--)
 			to[i] = (u64)(from[i]);
 	}
 
@@ -208,27 +207,19 @@ static long __bpf_get_stackid(struct bpf_map *map,
 {
 	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
 	struct stack_map_bucket *bucket, *new_bucket, *old_bucket;
-	u32 max_depth = map->value_size / stack_map_data_size(map);
-	/* stack_map_alloc() checks that max_depth <= sysctl_perf_event_max_stack */
-	u32 init_nr = sysctl_perf_event_max_stack - max_depth;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	u32 hash, id, trace_nr, trace_len;
 	bool user = flags & BPF_F_USER_STACK;
 	u64 *ips;
 	bool hash_matches;
 
-	/* get_perf_callchain() guarantees that trace->nr >= init_nr
-	 * and trace-nr <= sysctl_perf_event_max_stack, so trace_nr <= max_depth
-	 */
-	trace_nr = trace->nr - init_nr;
-
-	if (trace_nr <= skip)
+	if (trace->nr <= skip)
 		/* skipping more than usable stack trace */
 		return -EFAULT;
 
-	trace_nr -= skip;
+	trace_nr = trace->nr - skip;
 	trace_len = trace_nr * sizeof(u64);
-	ips = trace->ip + skip + init_nr;
+	ips = trace->ip + skip;
 	hash = jhash2((u32 *)ips, trace_len / sizeof(u32), 0);
 	id = hash & (smap->n_buckets - 1);
 	bucket = READ_ONCE(smap->buckets[id]);
@@ -285,8 +276,7 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 	   u64, flags)
 {
 	u32 max_depth = map->value_size / stack_map_data_size(map);
-	/* stack_map_alloc() checks that max_depth <= sysctl_perf_event_max_stack */
-	u32 init_nr = sysctl_perf_event_max_stack - max_depth;
+	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
 	bool kernel = !user;
@@ -295,8 +285,12 @@ BPF_CALL_3(bpf_get_stackid, struct pt_regs *, regs, struct bpf_map *, map,
 			       BPF_F_FAST_STACK_CMP | BPF_F_REUSE_STACKID)))
 		return -EINVAL;
 
-	trace = get_perf_callchain(regs, init_nr, kernel, user,
-				   sysctl_perf_event_max_stack, false, false);
+	max_depth += skip;
+	if (max_depth > sysctl_perf_event_max_stack)
+		max_depth = sysctl_perf_event_max_stack;
+
+	trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
+				   false, false);
 
 	if (unlikely(!trace))
 		/* couldn't fetch the stack trace */
@@ -387,7 +381,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 			    struct perf_callchain_entry *trace_in,
 			    void *buf, u32 size, u64 flags)
 {
-	u32 init_nr, trace_nr, copy_len, elem_size, num_elem;
+	u32 trace_nr, copy_len, elem_size, num_elem, max_depth;
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
@@ -412,30 +406,28 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		goto err_fault;
 
 	num_elem = size / elem_size;
-	if (sysctl_perf_event_max_stack < num_elem)
-		init_nr = 0;
-	else
-		init_nr = sysctl_perf_event_max_stack - num_elem;
+	max_depth = num_elem + skip;
+	if (sysctl_perf_event_max_stack < max_depth)
+		max_depth = sysctl_perf_event_max_stack;
 
 	if (trace_in)
 		trace = trace_in;
 	else if (kernel && task)
-		trace = get_callchain_entry_for_task(task, init_nr);
+		trace = get_callchain_entry_for_task(task, max_depth);
 	else
-		trace = get_perf_callchain(regs, init_nr, kernel, user,
-					   sysctl_perf_event_max_stack,
+		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
 					   false, false);
 	if (unlikely(!trace))
 		goto err_fault;
 
-	trace_nr = trace->nr - init_nr;
-	if (trace_nr < skip)
+	if (trace->nr < skip)
 		goto err_fault;
 
-	trace_nr -= skip;
+	trace_nr = trace->nr - skip;
 	trace_nr = (trace_nr <= num_elem) ? trace_nr : num_elem;
 	copy_len = trace_nr * elem_size;
-	ips = trace->ip + skip + init_nr;
+
+	ips = trace->ip + skip;
 	if (user && user_build_id)
 		stack_map_get_build_id_offset(buf, ips, trace_nr, user);
 	else
-- 
2.35.1.723.g4982287a31-goog

