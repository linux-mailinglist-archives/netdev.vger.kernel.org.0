Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F0D4B95F6
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiBQCjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:39:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbiBQCjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:39:05 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832D5C4280;
        Wed, 16 Feb 2022 18:38:52 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y18so3481132plb.11;
        Wed, 16 Feb 2022 18:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xTcS0f/Xs8kE6IelEABxDBm87eaDm53OYO7OwtM+FT4=;
        b=K5bARjZcsN16Fs5q+G2rpsQ7sZhRaovO/FamgVmCU20oSeFlUvKZ3RkmXT81YMu+E2
         cXqk61OVy0fTAqRCisV0k+b801mUhW36XHbQbBw/IelyHyqkd0yU81TPAW7l4JcRBGre
         zR75RmTfEFtwQFkC6Ibm0EM7ZNo6ZsQHY+1xFadU2MnCuVJHcu5uYemWRGOvgDaHNF3F
         AuI1Cb9oqhzepJh/uCD9swTBffC4Jg97NgUFaf0YbOvA5FIhE56g33LOCDWiwoo+SVNU
         N1Cux+i+vC+kxnYB//m0/4FSNWbXROn2yYFbFb56A5rcPB/xgi8aVT44DI/cEV7EVvvc
         NEyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xTcS0f/Xs8kE6IelEABxDBm87eaDm53OYO7OwtM+FT4=;
        b=VULAETRZzoFKSU+FBrRVhZKomaNkrWRyzPdXmOk62YXrWtRK0ib70PPrQWxBqFK5Uc
         kzTggyjCPtpqoM24awZ6qTkAkOSSPiWiXIL8pBpkOr0+02a8QJM6v6rvHbz1fo2K6/Dz
         iRy/5lwZFsDySpgFumqzD0gZYDeF+pNj4s8LOlzx5sKFbSzDhH5q+LHrW71494MvDWTO
         0rBNGrOS085ZpCCLAqj83qEMMfDFFEUH6C4BhbXYij+BiE2jI0cZG0Q5iZtQpYT+ak+V
         A6hdXXPZz/QccOW+GxKrU9mNThcBCVZ+R/Mqimz96Bk+Nzhwxp9HFXdlMlldJOWAQanG
         MUew==
X-Gm-Message-State: AOAM532xOfK/tl719nyNQJxRrL3MAHW031xzA2MVADkErx8o8KhK6jt5
        aVqrGUlioVrrN4FnPoxCP/m5Mp0oTdI=
X-Google-Smtp-Source: ABdhPJwJAZRqD9L+SLcRNr8/qFNdprKOh7jLAFWWWCS0pCc0tr1HKvgH0U2ziMfj+8Ls0vZ7N4jUbA==
X-Received: by 2002:a17:902:7442:b0:14e:e5b2:6af6 with SMTP id e2-20020a170902744200b0014ee5b26af6mr913267plt.136.1645065531934;
        Wed, 16 Feb 2022 18:38:51 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3a48])
        by smtp.gmail.com with ESMTPSA id h15sm2332927pfh.143.2022.02.16.18.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 18:38:51 -0800 (PST)
Date:   Wed, 16 Feb 2022 18:38:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [RFC bpf-next 1/4] bpf: cgroup_sock lsm flavor
Message-ID: <20220217023849.jn5pcwz23rj2772x@ast-mbp.dhcp.thefacebook.com>
References: <20220216001241.2239703-1-sdf@google.com>
 <20220216001241.2239703-2-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216001241.2239703-2-sdf@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 04:12:38PM -0800, Stanislav Fomichev wrote:
>  {
> @@ -1767,14 +1769,23 @@ static int invoke_bpf_prog(const struct btf_func_model *m, u8 **pprog,
>  
>  	/* arg1: lea rdi, [rbp - stack_size] */
>  	EMIT4(0x48, 0x8D, 0x7D, -stack_size);
> -	/* arg2: progs[i]->insnsi for interpreter */
> -	if (!p->jited)
> -		emit_mov_imm64(&prog, BPF_REG_2,
> -			       (long) p->insnsi >> 32,
> -			       (u32) (long) p->insnsi);
> -	/* call JITed bpf program or interpreter */
> -	if (emit_call(&prog, p->bpf_func, prog))
> -		return -EINVAL;
> +
> +	if (p->expected_attach_type == BPF_LSM_CGROUP_SOCK) {
> +		/* arg2: progs[i] */
> +		emit_mov_imm64(&prog, BPF_REG_2, (long) p >> 32, (u32) (long) p);
> +		if (emit_call(&prog, __cgroup_bpf_run_lsm_sock, prog))
> +			return -EINVAL;
> +	} else {
> +		/* arg2: progs[i]->insnsi for interpreter */
> +		if (!p->jited)
> +			emit_mov_imm64(&prog, BPF_REG_2,
> +				       (long) p->insnsi >> 32,
> +				       (u32) (long) p->insnsi);
> +
> +		/* call JITed bpf program or interpreter */
> +		if (emit_call(&prog, p->bpf_func, prog))
> +			return -EINVAL;

Overall I think it's a workable solution.
As far as mechanism I think it would be better
to allocate single dummy bpf_prog and use normal fmod_ret
registration mechanism instead of hacking arch trampoline bits.
Set dummy_bpf_prog->bpf_func = __cgroup_bpf_run_lsm_sock;
and keep as dummy_bpf_prog->jited = false;
From p->insnsi pointer in arg2 it's easy to go back to struct bpf_prog.
Such dummy prog might even be statically defined like dummy_bpf_prog.
Or allocated dynamically once.
It can be added as fmod_ret to multiple trampolines.
Just gut the func_model check.

As far as api the attach should probably be to a cgroup+lsm_hook pair.
link_create.target_fd will be cgroup_fd.
At prog load time attach_btf_id should probably be one
of existing bpf_lsm_* hooks.
Feels wrong to duplicate the whole set into lsm_cgroup_sock set.

It's fine to have prog->expected_attach_type == BPF_LSM_CGROUP_SOCK
to disambiguate. Will we probably only have two:
BPF_LSM_CGROUP_SOCK and BPF_LSM_CGROUP_TASK ?

> +int __cgroup_bpf_run_lsm_sock(u64 *regs, const struct bpf_prog *prog)
> +{
> +	struct socket *sock = (void *)regs[BPF_REG_0];
> +	struct cgroup *cgrp;
> +	struct sock *sk;
> +
> +	sk = sock->sk;
> +	if (!sk)
> +		return 0;
> +
> +	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
> +
> +	return BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[prog->aux->cgroup_atype],
> +				     regs, bpf_prog_run, 0);
> +}

Would it be fast enough?
We went through a bunch of optimization for normal cgroup and ended with:
        if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) &&
            cgroup_bpf_sock_enabled(sk, CGROUP_INET_INGRESS))
Here the trampoline code plus call into __cgroup_bpf_run_lsm_sock
will be there for all cgroups.
Since cgroup specific check will be inside BPF_PROG_RUN_ARRAY_CG.
I suspect it's ok, since the link_create will be for few specific lsm hooks
which are typically not in the fast path.
Unlike traditional cgroup hook like ingress that is hot.

For BPF_LSM_CGROUP_TASK it will take cgroup from current instead of sock, right?
Args access should magically work. 'regs' above should be fine for
all lsm hooks.

The typical prog:
+SEC("lsm_cgroup_sock/socket_post_create")
+int BPF_PROG(socket_post_create, struct socket *sock, int family,
+            int type, int protocol, int kern)
looks good too.
Feel natural.
I guess they can be sleepable too?
