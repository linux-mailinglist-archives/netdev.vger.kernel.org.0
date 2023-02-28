Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290EA6A5DEF
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 18:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjB1RH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 12:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjB1RHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 12:07:55 -0500
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA62B171C;
        Tue, 28 Feb 2023 09:07:53 -0800 (PST)
Received: by mail-qt1-f170.google.com with SMTP id y10so6595687qtj.2;
        Tue, 28 Feb 2023 09:07:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1STn0ChdpEyosfrTpw212glnukdXlJ1S7+QzeAmafM=;
        b=WXFfDLlAwX3FrCAwdo0aZi2LVOauhR8NraxSs85sQ/fyICDgkMSSBmDkaLG2moDgN6
         KkJ+BKex5gVoC7K+7TqilyjN0+iAUydFCVG9fFm//Sj1n7a53/e7S5Qz7QjC+5uw4jEf
         qO7h02C0p1En3UYxc9d4mUlInwy688a0nn9j5L/fOVF5M4BjFZiGw7xSpI15gKSuW4eV
         EgbVgOAc49sR/1kJTm79iKZyWca2pVKxkkBQWp20BtPu/90K2wezfIQJs+TouV7bz0wF
         +0fcWSh+3IMeftmqdQS9eWqRicVp9MF0Pt3cTvXHqCxZ2qin8NfKJurGqqGv4yLafNrw
         htng==
X-Gm-Message-State: AO0yUKVq6pQBiyMvnuqyAHHBAzfx4bdHdueFGf7oKLgoCnUvaEMu2meG
        0axwPEM0WbvYGkl9GHuEne0=
X-Google-Smtp-Source: AK7set8wMUPDT6/cRynARy5O28d62ggPAXrkeZmKMTl1dGmzImpas3RmWusxvGmF2zA/7FJEyO5kZg==
X-Received: by 2002:a05:622a:1101:b0:3bf:ca04:3bc6 with SMTP id e1-20020a05622a110100b003bfca043bc6mr6006053qty.9.1677604072687;
        Tue, 28 Feb 2023 09:07:52 -0800 (PST)
Received: from maniforge ([2620:10d:c091:480::1:f172])
        by smtp.gmail.com with ESMTPSA id i14-20020ac8764e000000b003b86b962030sm6728644qtr.72.2023.02.28.09.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 09:07:52 -0800 (PST)
Date:   Tue, 28 Feb 2023 11:07:49 -0600
From:   David Vernet <void@manifault.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: Tweak cgroup kfunc test.
Message-ID: <Y/405fRuemfgdC3l@maniforge>
References: <20230228040121.94253-1-alexei.starovoitov@gmail.com>
 <20230228040121.94253-6-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228040121.94253-6-alexei.starovoitov@gmail.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 08:01:21PM -0800, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Adjust cgroup kfunc test to dereference RCU protected cgroup pointer
> as PTR_TRUSTED and pass into KF_TRUSTED_ARGS kfunc.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

This LGTM, but I noticed that another cgrp test was failing with this
patch set:

[root@archbig bpf]# ./test_progs -t cgrp_local_storage/recursion
test_cgrp_local_storage:PASS:join_cgroup /cgrp_local_storage 0 nsec
libbpf: prog 'on_lookup': BPF program load failed: Permission denied
libbpf: prog 'on_lookup': -- BEGIN PROG LOAD LOG --
reg type unsupported for arg#0 function on_lookup#16
0: R1=ctx(off=0,imm=0) R10=fp0
; struct task_struct *task = bpf_get_current_task_btf();
0: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct(off=0,imm=0)
1: (bf) r6 = r0                       ; R0_w=trusted_ptr_task_struct(off=0,imm=0) R6_w=trusted_ptr_task_struct(off=0,imm=0)
; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
2: (79) r1 = *(u64 *)(r6 +2296)       ; R1_w=rcu_ptr_or_null_css_set(off=0,imm=0) R6_w=trusted_ptr_task_struct(off=0,imm=0)
; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
3: (79) r2 = *(u64 *)(r1 +120)
R1 invalid mem access 'rcu_ptr_or_null_'
processed 4 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
-- END PROG LOAD LOG --
libbpf: prog 'on_lookup': failed to load: -13
libbpf: failed to load object 'cgrp_ls_recursion'
libbpf: failed to load BPF skeleton 'cgrp_ls_recursion': -13
test_recursion:FAIL:skel_open_and_load unexpected error: -13
#43/3    cgrp_local_storage/recursion:FAIL
#43      cgrp_local_storage:FAIL

All error logs:
test_cgrp_local_storage:PASS:join_cgroup /cgrp_local_storage 0 nsec
libbpf: prog 'on_lookup': BPF program load failed: Permission denied
libbpf: prog 'on_lookup': -- BEGIN PROG LOAD LOG --
reg type unsupported for arg#0 function on_lookup#16
0: R1=ctx(off=0,imm=0) R10=fp0
; struct task_struct *task = bpf_get_current_task_btf();
0: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct(off=0,imm=0)
1: (bf) r6 = r0                       ; R0_w=trusted_ptr_task_struct(off=0,imm=0) R6_w=trusted_ptr_task_struct(off=0,imm=0)
; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
2: (79) r1 = *(u64 *)(r6 +2296)       ; R1_w=rcu_ptr_or_null_css_set(off=0,imm=0) R6_w=trusted_ptr_task_struct(off=0,imm=0)
; bpf_cgrp_storage_delete(&map_a, task->cgroups->dfl_cgrp);
3: (79) r2 = *(u64 *)(r1 +120)
R1 invalid mem access 'rcu_ptr_or_null_'
processed 4 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
-- END PROG LOAD LOG --
libbpf: prog 'on_lookup': failed to load: -13
libbpf: failed to load object 'cgrp_ls_recursion'
libbpf: failed to load BPF skeleton 'cgrp_ls_recursion': -13
test_recursion:FAIL:skel_open_and_load unexpected error: -13
#43/3    cgrp_local_storage/recursion:FAIL
#43      cgrp_local_storage:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
[root@archbig bpf]#

The ptr type looks correct, so I assumed that the arg type for the proto
needed to be updated to expect NULL. This doesn't seem to fix it though:

diff --git a/kernel/bpf/bpf_cgrp_storage.c b/kernel/bpf/bpf_cgrp_storage.c
index 6cdf6d9ed91d..9d5d47c8e820 100644
--- a/kernel/bpf/bpf_cgrp_storage.c
+++ b/kernel/bpf/bpf_cgrp_storage.c
@@ -241,6 +241,6 @@ const struct bpf_func_proto bpf_cgrp_storage_delete_proto = {
        .gpl_only       = false,
        .ret_type       = RET_INTEGER,
        .arg1_type      = ARG_CONST_MAP_PTR,
-   .arg2_type      = ARG_PTR_TO_BTF_ID,
+ .arg2_type  = ARG_PTR_TO_BTF_ID_OR_NULL,
        .arg2_btf_id    = &bpf_cgroup_btf_id[0],
 };

> ---
>  tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c | 2 +-
>  tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c | 7 ++++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> index 4ad7fe24966d..d5a53b5e708f 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
> @@ -205,7 +205,7 @@ int BPF_PROG(cgrp_kfunc_get_unreleased, struct cgroup *cgrp, const char *path)
>  }
>  
>  SEC("tp_btf/cgroup_mkdir")
> -__failure __msg("arg#0 is untrusted_ptr_or_null_ expected ptr_ or socket")
> +__failure __msg("bpf_cgroup_release expects refcounted")
>  int BPF_PROG(cgrp_kfunc_release_untrusted, struct cgroup *cgrp, const char *path)
>  {
>  	struct __cgrps_kfunc_map_value *v;
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> index 42e13aebdd62..85becaa8573b 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
> @@ -61,7 +61,7 @@ int BPF_PROG(test_cgrp_acquire_leave_in_map, struct cgroup *cgrp, const char *pa
>  SEC("tp_btf/cgroup_mkdir")
>  int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
>  {
> -	struct cgroup *kptr;
> +	struct cgroup *kptr, *cg;
>  	struct __cgrps_kfunc_map_value *v;
>  	long status;
>  
> @@ -80,6 +80,11 @@ int BPF_PROG(test_cgrp_xchg_release, struct cgroup *cgrp, const char *path)
>  		return 0;
>  	}
>  
> +	kptr = v->cgrp;
> +	cg = bpf_cgroup_ancestor(kptr, 1);
> +	if (cg)	/* verifier only check */
> +		bpf_cgroup_release(cg);
> +
>  	kptr = bpf_kptr_xchg(&v->cgrp, NULL);
>  	if (!kptr) {
>  		err = 3;
> -- 
> 2.30.2
> 
