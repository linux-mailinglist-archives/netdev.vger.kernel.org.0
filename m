Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB89E5453DD
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 20:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345306AbiFISOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 14:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345329AbiFISN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 14:13:56 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A223B339F
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 11:13:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id lw3-20020a17090b180300b001e31fad7d5aso20871pjb.6
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 11:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vluAGTMIfwVyo7bLiqlBGz2BhUJzgDYPHPvvS9bz/gU=;
        b=sKuaXpkxCNRxo4dKoyS/7EaD6laN/vydpvteaS6Qcx2qD5Okb8+50GLBkgQZcj0Aut
         6whls+bSF1ucm3CgKvkJzF37xZCxTwUnd0CqPEzn+fYc3Md1E3RcsS9/G9b6ApvlkmoU
         xmL7rvMSOot/6pzYdi+AULDuNTiH2YBFZTd+9s+qND2lP2+PBpe2MMghlECLiooPn5Ts
         AnSymca/eMo5hCNs7QDD9GmRZrJElEXHa6VHZCN5W9yQJLuO73qtKSxia83oXWcJmQrG
         +pIcn1ejPJA583jdZlI0VV77B1D3Je1BJItw15xjaBU8oskgF8KaxGspK87a6TVIS7wv
         kcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vluAGTMIfwVyo7bLiqlBGz2BhUJzgDYPHPvvS9bz/gU=;
        b=0kmuhMqqPzD/sv54kjrL89aTzJR3RMcsCIHwc9SeyAMI67F9QAoYg2pkgvngWUdnA3
         L8WyLLDKLgfEfZ65PmkA10cSlRAZZ7Wj4TIuFx8tqeqIxnj3NeGkR2YXOqoEmzO2ti1T
         qQSLb8pae6IFCUXIKMTJ5PgRo54b6JLsfI7Y+ugizvy569Lo/hBNz8m1sBGKCW7FqMwI
         Oy04wERuIcSLlPvOEolH08OgN2Fv9AC654k1Y2NyJmkQ9Ab90RdP/JZqhO1KrurDLebj
         ZrgCD9ReHab30XH6cIpibUor7lhU3W7bRtJM8uzq9FhnS4mEUoG7jDHF/MjDPx9efQmB
         CYcw==
X-Gm-Message-State: AOAM533eKwCj8fA0Fk4MU4eL9Qtm1Ny8ojz52AM+2Hfjm4Xaj9KjQNgH
        YyKKNOWlgbw5EsWqrCDPXezkWGI=
X-Google-Smtp-Source: ABdhPJyRYCta6Vqo5XxGqBx/s8D7LTEKhczS3RZ8AIhOsjvPbLChu+PT5zTb9YKRfwRK1G07opyciQs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr112410pje.0.1654798432681; Thu, 09 Jun
 2022 11:13:52 -0700 (PDT)
Date:   Thu, 9 Jun 2022 11:13:50 -0700
In-Reply-To: <20220609143614.97837-1-quentin@isovalent.com>
Message-Id: <YqI4XrKeQkENT/+w@google.com>
Mime-Version: 1.0
References: <20220609143614.97837-1-quentin@isovalent.com>
Subject: Re: [PATCH bpf-next] libbpf: Improve probing for memcg-based memory accounting
From:   sdf@google.com
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09, Quentin Monnet wrote:
> To ensure that memory accounting will not hinder the load of BPF
> objects, libbpf may raise the memlock rlimit before proceeding to some
> operations. Whether this limit needs to be raised depends on the version
> of the kernel: newer versions use cgroup-based (memcg) memory
> accounting, and do not require any adjustment.

> There is a probe in libbpf to determine whether memcg-based accounting
> is supported. But this probe currently relies on the availability of a
> given BPF helper, bpf_ktime_get_coarse_ns(), which landed in the same
> kernel version as the memory accounting change. This works in the
> generic case, but it may fail, for example, if the helper function has
> been backported to an older kernel. This has been observed for Google
> Cloud's Container-Optimized OS (COS), where the helper is available but
> rlimit is still in use. The probe succeeds, the rlimit is not raised,
> and probing features with bpftool, for example, fails.

> Here we attempt to improve this probe and to effectively rely on memory
> accounting. Function probe_memcg_account() in libbpf is updated to set
> the rlimit to 0, then attempt to load a BPF object, and then to reset
> the rlimit. If the load still succeeds, then this means we're running
> with memcg-based accounting.

> This probe was inspired by the similar one from the cilium/ebpf Go
> library [0].

> [0] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39

> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>   tools/lib/bpf/bpf.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)

> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 240186aac8e6..781387e6f66b 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -99,31 +99,44 @@ static inline int sys_bpf_prog_load(union bpf_attr  
> *attr, unsigned int size, int

>   /* Probe whether kernel switched from memlock-based (RLIMIT_MEMLOCK) to
>    * memcg-based memory accounting for BPF maps and progs. This was done  
> in [0].
> - * We use the support for bpf_ktime_get_coarse_ns() helper, which was  
> added in
> - * the same 5.11 Linux release ([1]), to detect memcg-based accounting  
> for BPF.
> + * To do so, we lower the soft memlock rlimit to 0 and attempt to create  
> a BPF
> + * object. If it succeeds, then memcg-based accounting for BPF is  
> available.
>    *
>    *   [0]  
> https://lore.kernel.org/bpf/20201201215900.3569844-1-guro@fb.com/
> - *   [1] d05512618056 ("bpf: Add bpf_ktime_get_coarse_ns helper")
>    */
>   int probe_memcg_account(void)
>   {
>   	const size_t prog_load_attr_sz = offsetofend(union bpf_attr,  
> attach_btf_obj_fd);
>   	struct bpf_insn insns[] = {
> -		BPF_EMIT_CALL(BPF_FUNC_ktime_get_coarse_ns),
>   		BPF_EXIT_INSN(),
>   	};
> +	struct rlimit rlim_init, rlim_cur_zero = {};
>   	size_t insn_cnt = ARRAY_SIZE(insns);
>   	union bpf_attr attr;
>   	int prog_fd;

> -	/* attempt loading freplace trying to use custom BTF */
>   	memset(&attr, 0, prog_load_attr_sz);
>   	attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
>   	attr.insns = ptr_to_u64(insns);
>   	attr.insn_cnt = insn_cnt;
>   	attr.license = ptr_to_u64("GPL");

> +	if (getrlimit(RLIMIT_MEMLOCK, &rlim_init))
> +		return -1;
> +
> +	/* Drop the soft limit to zero. We maintain the hard limit to its
> +	 * current value, because lowering it would be a permanent operation
> +	 * for unprivileged users.
> +	 */
> +	rlim_cur_zero.rlim_max = rlim_init.rlim_max;
> +	if (setrlimit(RLIMIT_MEMLOCK, &rlim_cur_zero))
> +		return -1;
> +
>   	prog_fd = sys_bpf_fd(BPF_PROG_LOAD, &attr, prog_load_attr_sz);
> +
> +	/* reset soft rlimit as soon as possible */
> +	setrlimit(RLIMIT_MEMLOCK, &rlim_init);

Isn't that adding more flakiness to the other daemons running as
the same user? Also, there might be surprises if another daemon that
has libbpf in it starts right when we've set the limit temporarily to zero.

Can we push these decisions to the users as part of libbpf 1.0 cleanup?

> +
>   	if (prog_fd >= 0) {
>   		close(prog_fd);
>   		return 1;
> --
> 2.34.1

