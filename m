Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61ED3AA1D9
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFPQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhFPQzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 12:55:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C181C061574;
        Wed, 16 Jun 2021 09:52:56 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mj8-20020a17090b3688b029016ee34fc1b3so2145894pjb.0;
        Wed, 16 Jun 2021 09:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iEVChFbDFCmGN1dMH8S/MzuZpIpTIysMe0k+9GMBk4M=;
        b=e8MuuvfSQj5GaTDjsgRKpZy9VAUr9BQowvYfyNgAzuNEPJF2bGNf5WfVgngKrDCLi+
         HlwpPGAt15B8bOKl8gVwgJvYzQgI5VQet0RpmWqimtX3Zpk19OdvNpHm47lTd9oVyqG9
         97r6HvCbFsFOBo3VIa7yB3ZOFN46foLap4tx8hPtrqm/NyPq5Y5jvhonvXU6sn+6e3Z8
         K0nvUAkR+05E1gDsejffgHPgxj7uwj7BvLIr9r3RZsHa+5EO8fadh27zaaTTB7qRFw6y
         JMVooDtGeelj4iiW9Jipm0nBb+MKnwnqn5og3j7K7ZTSS/w2w7g+UMk8Vbp5dPUVDq6W
         2Ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iEVChFbDFCmGN1dMH8S/MzuZpIpTIysMe0k+9GMBk4M=;
        b=nxnMMvSmdgvWcerXS2twLll875nVM0nd/UPLIKZ1Kc0dgwuj3wodG9Z2LEii8N0K4F
         KGsW9CY+eo0vPc6eK3RDHrlyq/AbdfW8yhPGvYYn8SWevNl/eon5WkEadCd2DhGedkVV
         TLvrWHZrXHB9BbQphQM0NySL1Q+S5zUeF1Ef/DuNf0WvLH0lA9zM7DrBdGkWtNThV0Z0
         RYQeWmN+722ASAJ8QXWE047K42ekK1iUbpiRzI0wZRKPVxjswfc3bQShXk1b/ON+2AlH
         A/yQDoR46sMlRUpT6Xoo84WLTFkfWBVUrKex0pJHH+D4TPJqbZCvTUG4QlFXclKReGOJ
         cNIQ==
X-Gm-Message-State: AOAM532IncnGmHg3AhMiPURWtXSXIp3ikbJue3QY6XeX5fmA/48s1A8Z
        KgV+Iunt9fNx3V73XuHrNs4=
X-Google-Smtp-Source: ABdhPJx6N41qAHAo35IzvHNW7n7ocG2jvq1AhGfix8r85Cf50CmIhTU+PLlnSjm4XP69VAuKBnqN4Q==
X-Received: by 2002:a17:90b:19d4:: with SMTP id nm20mr4133255pjb.134.1623862375898;
        Wed, 16 Jun 2021 09:52:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b564])
        by smtp.gmail.com with ESMTPSA id r6sm5791216pjm.12.2021.06.16.09.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 09:52:54 -0700 (PDT)
Date:   Wed, 16 Jun 2021 09:52:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
Message-ID: <20210616165250.ejtcvgip5q5hbacy@ast-mbp.dhcp.thefacebook.com>
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com>
 <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
 <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com>
 <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com>
 <CAADnVQJ3CQ=WnsantyEy6GB58rdsd7q=aJv93WPsZZJmXdJGzQ@mail.gmail.com>
 <CAEf4BzZWr7HhKn3opxHeaZqkgo4gsYYhDQ4d4HuNhx-i8XgjCg@mail.gmail.com>
 <20210616042622.22nzdrrnlndogn5w@ast-mbp>
 <CAEf4BzZ_=tJGqGS9FKxxQqGfRqAoF_m9r8FW29n9ZqC_u-10DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uw7m3mfu5sptiiin"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ_=tJGqGS9FKxxQqGfRqAoF_m9r8FW29n9ZqC_u-10DA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uw7m3mfu5sptiiin
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 15, 2021 at 10:54:40PM -0700, Andrii Nakryiko wrote:
> 
> It could be the case, of course. But let's try to think this through
> to the end before giving up. I think it's mostly because we are trying
> to be too clever with lockless synchronization.

imo your proposed code fits "too clever" too ;)
Just a reminder that few emails ago you've argued 
about "obviously correct" approach, but now...

> I had a feeling that bpf_timer_cb needs to take lock as well. But once
> we add that, refcounting becomes simpler and more deterministic, IMO.
> Here's what I have in mind. I keep only important parts of the code,
> so it's not a complete implementation. Please take a look below, I
> left a few comments here and there.
> 
> 
> struct bpf_hrtimer {
>        struct hrtimer timer;
>        struct bpf_map *map;
>        void *value;
> 
>        struct bpf_prog *prog;
>        void *callback_fn;
> 
>        /* pointer to that lock in struct bpf_timer_kern
>         * so that we can access it from bpf_timer_cb()
>         */
>        struct bpf_spin_lock *lock;
> };
> 
> BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, int, flags,
>            struct bpf_map *, map)
> {
>        struct bpf_hrtimer *t;
>        int ret = 0;
> 
>        ____bpf_spin_lock(&timer->lock);
>        t = timer->timer;
>        if (t) {
>                ret = -EBUSY;
>                goto out;
>        }
>        /* allocate hrtimer via map_kmalloc to use memcg accounting */
>        t = bpf_map_kmalloc_node(map, sizeof(*t), GFP_ATOMIC, NUMA_NO_NODE);
>        if (!t) {
>                ret = -ENOMEM;
>                goto out;
>        }
>        t->value = (void *)timer /* - offset of bpf_timer inside elem */;
>        t->map = map;
>        t->timer.function = bpf_timer_cb;
> 
>        /* we'll init them in bpf_timer_start */
>        t->prog = NULL;
>        t->callback_fn = NULL;
> 
>        hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
>        timer->timer = t;
> out:
>        ____bpf_spin_unlock(&timer->lock);
>        return ret;
> }
> 
> 
> BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs,
>            void *, cb, struct bpf_prog *, prog)
> {
>        struct bpf_hrtimer *t;
>        int ret = 0;
> 
>        ____bpf_spin_lock(&timer->lock);
>        t = timer->timer;
>        if (!t) {
>                ret = -EINVAL;
>                goto out;
>        }
> 
>        /* doesn't matter what it returns, we just request cancellation */
>        hrtimer_try_to_cancel(&t->timer);
> 
>        /* t->prog might not be the same as prog (!) */
>        if (prog != t->prog) {
>             /* callback hasn't yet dropped refcnt */
>            if (t->prog) /* if it's null bpf_timer_cb() is running and
> will put it later */
>                bpf_prog_put(t->prog);
> 
>            if (IS_ERR(bpf_prog_inc_not_zero(prog))) {
>                /* this will only happen if prog is still running (and
> it's actually us),
>                 * but it was already put to zero, e.g., by closing last FD,
>                 * so there is no point in scheduling a new run
>                 */

I have a bit of mind explosion here... everything will be alright.

>                t->prog = NULL;
>                t->callback_fn = NULL;
>                ret = -E_WE_ARE_SHUTTING_DOWN;
>                goto out;
>            }
>        } /* otherwise we keep existing refcnt on t->prog == prog */
> 
>        /* potentially new combination of prog and cb */
>        t->prog = prog;
>        t->callback_fn = cb;
> 
>        hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
> out:
>        ____bpf_spin_unlock(&timer->lock);
>        return ret;
> }
> 
> BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
> {
>        struct bpf_hrtimer *t;
>        int ret = 0;
> 
>        ____bpf_spin_lock(&timer->lock);
>        t = timer->timer;
>        if (!t) {
>                ret = -EINVAL;
>                goto out;
>        }
> 
>        /* this part I still worry about due to possibility of cpu migration,
>         * we need to think if we should migrate_disable() in bpf_timer_cb()
>         * and bpf_timer_* helpers(), but that's a separate topic
>         */
>        if (this_cpu_read(hrtimer_running) == t) {
>                ret = -EDEADLK;
>                goto out;
>        }
> 
>        ret = hrtimer_cancel(&t->timer);
> 
>        if (t->prog) {
>             /* bpf_timer_cb hasn't put it yet (and now won't) */
>             bpf_prog_put(t->prog);
>             t->prog = NULL;
>             t->callback_fn = NULL;
>        }
> out:
>        ____bpf_spin_unlock(&timer->lock);
>        return ret;
> }
> 
> static enum hrtimer_restart bpf_timer_cb(struct hrtimer *timer)
> {
>        struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
>        struct bpf_map *map = t->map;
>        struct bpf_prog *prog;
>        void *key, *callback_fn;
>        u32 idx;
>        int ret;
> 
>        /* this is very IMPORTANT  */
>        ____bpf_spin_lock(t->lock);
> 
>        prog = t->prog;
>        if (!prog) {
>            /* we were cancelled, prog is put already, exit early */
>            ____bpf_spin_unlock(&timer->lock);
>            return HRTIMER_NORESTART;
>        }
>        callback_fn = t->callback_fn;
> 
>        /* make sure bpf_timer_cancel/bpf_timer_start won't
> bpf_prog_put our prog */
>        t->prog = NULL;
>        t->callback_fn = NULL;
> 
>        ____bpf_spin_unlock(t->lock);
> 
>        /* at this point we "own" prog's refcnt decrement */
> 
>        this_cpu_write(hrtimer_running, t);
> 
>        ...
> 
>        ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
>                                            (u64)(long)key,
>                                            (u64)(long)value, 0, 0);
>        WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> 
>        bpf_prog_put(prog); /* always correct and non-racy */
> 
>        this_cpu_write(hrtimer_running, NULL);
> 
>        return HRTIMER_NORESTART;
> }
> 
> bpf_timer_cancel_and_free() is mostly the same with t->prog NULL check
> as everywhere else

I haven't started detailed analysis of above proposal, but looks overly
complicated on the first glance. Not saying it's bad or good.
Just complexity and races are striking.

> 
> > There is no need to complicate bpf_timer with crazy refcnting schemes.
> > The user space can simply pin the program in bpffs. In the future we might
> > introduce a self-pinning helper that would pin the program and create a file.
> > Sort-of like syscall prog type would pin self.
> > That would be explicit and clean api instead of obscure hacks inside bpf_timer*().
> 
> Do I understand correctly that the alternative that you are proposing
> is to keep some linked list of all map_values across all maps in the
> system that have initialized bpf_hrtimer with that particular bpf_prog
> in them? And when bpf_prog is put to zero you'll go and destruct them
> all in a race-free way?
> 
> I have a bit of a hard time imagining how that will be implemented
> exactly, so I might be overcomplicating that in my mind. Will be happy
> to see the working code.

Here is working code...
Note how patch 1 is so much simpler without complicated refcnting.
And how patch 2 removes for_each_map_element that was necessary earlier.
Also note that link list approach is an optimization.
Instead of keeping a link list the bpf_free_used_timers() could call
a map specific op to iterate all elems and free timers with
timer->prog == prog_going_away.
That was my initial proposal couple month ago.
link_list is purely an optimization instead of for_each_map_elem.

--uw7m3mfu5sptiiin
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-bpf-Cancel-and-free-timers-when-prog-is-going-away.patch"

From c11bf0aa23f1df25682056f2c581c9bc9bd8df31 Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Wed, 16 Jun 2021 09:19:36 -0700
Subject: [PATCH bpf-next 1/2] bpf: Cancel and free timers when prog is going
 away.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/bpf.h  |  3 ++
 kernel/bpf/core.c    |  3 ++
 kernel/bpf/helpers.c | 70 +++++++++++++++++++++++++-------------------
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7c403235c7e8..f67ea2512844 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -245,6 +245,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
 void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
 			   bool lock_src);
 void bpf_timer_cancel_and_free(void *timer);
+void bpf_free_used_timers(struct bpf_prog_aux *aux);
 int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
 
 struct bpf_offload_dev;
@@ -871,6 +872,8 @@ struct bpf_prog_aux {
 	u32 size_poke_tab;
 	struct bpf_ksym ksym;
 	const struct bpf_prog_ops *ops;
+	spinlock_t timers_lock;
+	struct hlist_head used_timers;
 	struct bpf_map **used_maps;
 	struct mutex used_maps_mutex; /* mutex for used_maps and used_map_cnt */
 	struct btf_mod_pair *used_btfs;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5e31ee9f7512..aa7960986a75 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -104,6 +104,8 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
 	fp->jit_requested = ebpf_jit_enabled();
 
 	INIT_LIST_HEAD_RCU(&fp->aux->ksym.lnode);
+	INIT_HLIST_HEAD(&fp->aux->used_timers);
+	spin_lock_init(&fp->aux->timers_lock);
 	mutex_init(&fp->aux->used_maps_mutex);
 	mutex_init(&fp->aux->dst_mutex);
 
@@ -2201,6 +2203,7 @@ static void bpf_prog_free_deferred(struct work_struct *work)
 	int i;
 
 	aux = container_of(work, struct bpf_prog_aux, work);
+	bpf_free_used_timers(aux);
 	bpf_free_used_maps(aux);
 	bpf_free_used_btfs(aux);
 	if (bpf_prog_is_dev_bound(aux))
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b8df592c33cc..08f5d0f73f68 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -987,6 +987,7 @@ const struct bpf_func_proto bpf_snprintf_proto = {
 
 struct bpf_hrtimer {
 	struct hrtimer timer;
+	struct hlist_node hlist;
 	struct bpf_map *map;
 	struct bpf_prog *prog;
 	void *callback_fn;
@@ -1004,7 +1005,6 @@ static DEFINE_PER_CPU(struct bpf_hrtimer *, hrtimer_running);
 static enum hrtimer_restart bpf_timer_cb(struct hrtimer *timer)
 {
 	struct bpf_hrtimer *t = container_of(timer, struct bpf_hrtimer, timer);
-	struct bpf_prog *prog = t->prog;
 	struct bpf_map *map = t->map;
 	void *key;
 	u32 idx;
@@ -1031,16 +1031,6 @@ static enum hrtimer_restart bpf_timer_cb(struct hrtimer *timer)
 					    (u64)(long)t->value, 0, 0);
 	WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
 
-	/* The bpf function finished executed. Drop the prog refcnt.
-	 * It could reach zero here and trigger free of bpf_prog
-	 * and subsequent free of the maps that were holding timers.
-	 * If callback_fn called bpf_timer_start on this timer
-	 * the prog refcnt will be > 0.
-	 *
-	 * If callback_fn deleted map element the 't' could have been freed,
-	 * hence t->prog deref is done earlier.
-	 */
-	bpf_prog_put(prog);
 	this_cpu_write(hrtimer_running, NULL);
 	return HRTIMER_NORESTART;
 }
@@ -1077,6 +1067,10 @@ BPF_CALL_5(bpf_timer_init, struct bpf_timer_kern *, timer, void *, cb, int, flag
 	t->prog = prog;
 	hrtimer_init(&t->timer, clockid, HRTIMER_MODE_REL_SOFT);
 	t->timer.function = bpf_timer_cb;
+	INIT_HLIST_NODE(&t->hlist);
+	spin_lock(&prog->aux->timers_lock);
+	hlist_add_head_rcu(&t->hlist, &prog->aux->used_timers);
+	spin_unlock(&prog->aux->timers_lock);
 	timer->timer = t;
 out:
 	____bpf_spin_unlock(&timer->lock);
@@ -1103,12 +1097,6 @@ BPF_CALL_2(bpf_timer_start, struct bpf_timer_kern *, timer, u64, nsecs)
 		ret = -EINVAL;
 		goto out;
 	}
-	if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
-		/* If the timer wasn't active or callback already executing
-		 * bump the prog refcnt to keep it alive until
-		 * callback is invoked (again).
-		 */
-		bpf_prog_inc(t->prog);
 	hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
 out:
 	____bpf_spin_unlock(&timer->lock);
@@ -1145,13 +1133,7 @@ BPF_CALL_1(bpf_timer_cancel, struct bpf_timer_kern *, timer)
 	/* Cancel the timer and wait for associated callback to finish
 	 * if it was running.
 	 */
-	if (hrtimer_cancel(&t->timer) == 1) {
-		/* If the timer was active then drop the prog refcnt,
-		 * since callback will not be invoked.
-		 */
-		bpf_prog_put(t->prog);
-		ret = 1;
-	}
+	ret = hrtimer_cancel(&t->timer);
 out:
 	____bpf_spin_unlock(&timer->lock);
 	return ret;
@@ -1164,8 +1146,10 @@ static const struct bpf_func_proto bpf_timer_cancel_proto = {
 	.arg1_type	= ARG_PTR_TO_TIMER,
 };
 
-/* This function is called by delete_element in htab and lru maps
- * and by map_free for array, lru, htab maps.
+/* This function is called by map_delete/update_elem for individual
+ * element and by bpf_free_used_timers when prog is going away.
+ * When map is destroyed by ops->map_free all bpf_timers in there
+ * are freed.
  */
 void bpf_timer_cancel_and_free(void *val)
 {
@@ -1177,7 +1161,7 @@ void bpf_timer_cancel_and_free(void *val)
 	if (!t)
 		goto out;
 	/* Cancel the timer and wait for callback to complete if it was
-	 * running. Only individual delete_element in htab or lru maps can
+	 * running. Only delete/update of individual element can
 	 * return 1 from hrtimer_cancel.
 	 * The whole map is destroyed when its refcnt reaches zero.
 	 * That happens after bpf prog refcnt reaches zero.
@@ -1197,15 +1181,41 @@ void bpf_timer_cancel_and_free(void *val)
 	 * In non-preallocated maps timer->timer = NULL will happen after
 	 * callback completes, since prog execution is an RCU critical section.
 	 */
-	if (this_cpu_read(hrtimer_running) != t &&
-	    hrtimer_cancel(&t->timer) == 1)
-		bpf_prog_put(t->prog);
+	if (this_cpu_read(hrtimer_running) != t)
+		hrtimer_cancel(&t->timer);
+
+	spin_lock(&t->prog->aux->timers_lock);
+	hlist_del_rcu(&t->hlist);
+	spin_unlock(&t->prog->aux->timers_lock);
+	t->prog = LIST_POISON1;
 	kfree(t);
 	timer->timer = NULL;
 out:
 	____bpf_spin_unlock(&timer->lock);
 }
 
+/* This function is called after prog->refcnt reaches zero.
+ * It's called before bpf_free_used_maps to clean up timers in maps
+ * if going away prog had callback_fn-s for them.
+ */
+void bpf_free_used_timers(struct bpf_prog_aux *aux)
+{
+	struct bpf_timer_kern *timer;
+	struct bpf_hrtimer *t;
+	struct hlist_node *n;
+
+	rcu_read_lock();
+	hlist_for_each_entry_safe(t, n, &aux->used_timers, hlist) {
+		timer = t->value + t->map->timer_off;
+		/* The map isn't going away. The 'timer' points into map
+		 * element that isn't going away either, but cancel_and_free
+		 * could be racing with parallel map_delete_elem.
+		 */
+		bpf_timer_cancel_and_free(timer);
+	}
+	rcu_read_unlock();
+}
+
 const struct bpf_func_proto bpf_get_current_task_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_proto __weak;
 const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
-- 
2.30.2


--uw7m3mfu5sptiiin
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-bpf-Don-t-iterate-all-map-elements-anymore.patch"

From 62d9bd33aac388c34e7fd3b411e0d40084d07f4b Mon Sep 17 00:00:00 2001
From: Alexei Starovoitov <ast@kernel.org>
Date: Wed, 16 Jun 2021 09:40:32 -0700
Subject: [PATCH bpf-next 2/2] bpf: Don't iterate all map elements anymore.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/arraymap.c |  7 -------
 kernel/bpf/hashtab.c  | 11 -----------
 2 files changed, 18 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 5c84ab7f8872..d82a6de65273 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -385,17 +385,10 @@ static void *array_map_vmalloc_addr(struct bpf_array *array)
 static void array_map_free(struct bpf_map *map)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
-	int i;
 
 	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
 		bpf_array_free_percpu(array);
 
-	if (unlikely(map_value_has_timer(map)))
-		for (i = 0; i < array->map.max_entries; i++)
-			bpf_timer_cancel_and_free(array->value +
-						  array->elem_size * i +
-						  map->timer_off);
-
 	if (array->map.map_flags & BPF_F_MMAPABLE)
 		bpf_map_area_free(array_map_vmalloc_addr(array));
 	else
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index c885492d0a76..5e2736c46185 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -244,17 +244,6 @@ static void htab_free_elems(struct bpf_htab *htab)
 		cond_resched();
 	}
 free_elems:
-	if (unlikely(map_value_has_timer(&htab->map)))
-		for (i = 0; i < htab->map.max_entries; i++) {
-			struct htab_elem *elem;
-
-			elem = get_htab_elem(htab, i);
-			bpf_timer_cancel_and_free(elem->key +
-						  round_up(htab->map.key_size, 8) +
-						  htab->map.timer_off);
-			cond_resched();
-		}
-
 	bpf_map_area_free(htab->elems);
 }
 
-- 
2.30.2


--uw7m3mfu5sptiiin--
