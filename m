Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB4B6987C5
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjBOWXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOWXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:23:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228F23756D;
        Wed, 15 Feb 2023 14:23:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id bx22so32826pjb.3;
        Wed, 15 Feb 2023 14:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hpypx6T5XDDDNoNi8TTx7yOf2XIJqA8Pjt15g1zmZbo=;
        b=cS7PmGaVrFmLkYxWGDRmQ59YKWBu0JVRqPaamF13RriATsggPhhTMscs+vOSLyHrxn
         8Uo4mHgzDwtcO5mt5YdcvWwbQffrgJI5Ekj3lcU8U/zXY9N0si70RloO4QnUBJsXXg7v
         MStNTHJqf9UM0H4dGTWe4sQcsF5hEF0paInaHDAVPWsYTlYXqSUWfHNBdXKCt5ChIRC/
         RXHaDolf3EskVHEcX3jF2bDDOlt3ZOi06FbTDLDhMTr4yomQFtST7fX6iopABQparXx8
         BzRh1L2ftYZfAi63Rvr45om0HYDmlXToaG0Sdf3Vb46ccOdOqQU2jjdVQ9nyyQikjkVe
         3/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hpypx6T5XDDDNoNi8TTx7yOf2XIJqA8Pjt15g1zmZbo=;
        b=3QGIxpgvG4iv58khBwlAb3M62KcJbkK67LY7y7c56ou5TYrjBqXN937Nd5OzUnoxvo
         zo8YNI0uqFvnzI6m9z9xCQrmv53y0cYvAlstX3hf1QDVZKXtFdp3tWguJHKudSY5Q7pw
         SC/YG+p+3AAI2VOEcQW2hD0KPQBn4lkGzouXTmM7nGv8r54MT0OxmUNRlqjsTahQqdYD
         SXXUW1YHrZgR1Os3sJA6XSoaVw5JZQAHsd4lR0uky56xiv1jbkAgv8QSAODyl0YuZiwT
         XwYvYgsGmLYYiNVp7sdMEFzRNpw1S1pjoWZZcE9SUiZIeb/afJ52uKI4c0UB5Hwfe4yF
         097A==
X-Gm-Message-State: AO0yUKWgqEUtFLS5Ck90adI4TvozF1znyuB0LAwdjfntJNsCpuerzZqf
        kZd6pi05+NgkkKnkO0CVYgg=
X-Google-Smtp-Source: AK7set+XyPzMZb6C3llGtiWgZ/FFc/krLa7vj7YI4avV5/rDihGRzmh8vHwp6UBjoAveGMkE8u1rVw==
X-Received: by 2002:a05:6a20:3d0c:b0:c1:2037:554f with SMTP id y12-20020a056a203d0c00b000c12037554fmr4240436pzi.62.1676499822424;
        Wed, 15 Feb 2023 14:23:42 -0800 (PST)
Received: from MacBook-Pro-6.local ([2620:10d:c090:500::7:f55d])
        by smtp.gmail.com with ESMTPSA id j4-20020aa78dc4000000b00590163e1762sm12177505pfr.200.2023.02.15.14.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:23:41 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:23:38 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@kernel.org, void@manifault.com, davemarchevsky@meta.com,
        tj@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 2/4] bpf: Introduce kptr_rcu.
Message-ID: <20230215222338.hxzub5jdftcvfqxx@MacBook-Pro-6.local>
References: <20230215065812.7551-1-alexei.starovoitov@gmail.com>
 <20230215065812.7551-3-alexei.starovoitov@gmail.com>
 <20230215104837.gm3ohqzownrtky5k@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215104837.gm3ohqzownrtky5k@apollo>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 11:48:37AM +0100, Kumar Kartikeya Dwivedi wrote:
> On Wed, Feb 15, 2023 at 07:58:10AM CET, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > The life time of certain kernel structures like 'struct cgroup' is protected by RCU.
> > Hence it's safe to dereference them directly from kptr-s in bpf maps.
> > The resulting pointer is PTR_TRUSTED and can be passed to kfuncs that expect KF_TRUSTED_ARGS.
> 
> But I thought PTR_TRUSTED was meant to ensure that the refcount is always > 0?
> E.g. in [0] you said that kernel code should ensure refcount is held while
> passing trusted pointer as tracepoint args. It's also clear from what functions
> that operate on PTR_TRUSTED are doing. bpf_cgroup_acquire is doing css_get and
> not css_tryget. Similarly bpf_cgroup_ancestor also calls cgroup_get which does
> css_get instead of css_tryget.
> 
>   [0]: https://lore.kernel.org/bpf/CAADnVQJfj9mrFZ+mBfwh8Xba333B6EyHRMdb6DE4s6te_5_V_A@mail.gmail.com

In that link I was saying:
"
But imagine there is only RCU protected pointer that
is passed into tracepoint somewhere.
The verifier doesn't recognize refcnt++ on it and ref_obj_id == 0
the kernel code doesn't do refcnt++ either.
But it's still safe and this arg should still be
PTR_TO_BTF_ID | PTR_TRUSTED.
The bpf prog can pass it further into kfunc that has KF_TRUSTED_ARGS.
Since RCU is held before calling into tracepoint the bpf prog
has to be non sleepable. Additional rcu_read_lock done by
the prog is redundant, but doesn't hurt.
When prog is calling kfunc the pointer is still valid and
kfunc can safely operate on it assuming that object is not going away.
That is the definition of KF_TRUSTED_ARGS from pov of kfunc.
"

I'm still saying the same.
But you have a good point about bpf_cgroup_acquire().
It needs to do cgroup_tryget().

In general atomic_inc is only tiny bit faster than atomic_inc_not_zero(),
so we can convert all KF_TRUSTED_ARGS kfuncs to deal with RCU protected
pointers which refcnt could have reached zero.

imo kptr_rcu closes usability gap we have with kptrs.
Accessing the same kernel pointer from multiple cpus just not feasible
with kptr_xchg. Inventing refcnt mechanisms and doing ++ on all cpus
will be too slow. RCU is perfect for the case of lots of
concurrent reads with few updates.

I think we can remove KF_RCU as well.

> And if we want to do RCU + css_tryget, we already have that in the form of
> kptr_get.

With kptr_rcu bpf_kptr_get() will become explicit in bpf progs.
Instead of bpf_cgroup_kptr_get() the prog can do:
bpf_rcu_read_lock(); // if sleepable
cgrp = val->cgrp;
if (cgrp) {
    cgrp_refcnted = bpf_cgroup_acquire(cgrp);
    if (cgrp_refcnted) ...

Less special kfuncs the better.

> I think we've had a similar discussion about this in
> https://lore.kernel.org/bpf/20220216214405.tn7thpnvqkxuvwhd@ast-mbp.dhcp.thefacebook.com,
> where you advised against directly assuming pointers to RCU protected objects as
> trusted where refcount could drop to 0. So then we went the kptr_get route,
> because explicit RCU sections weren't available back then to load + inc_not_zero
> directly (for sleepable programs).

yep. bpf_rcu_read_lock() wasn't available at that time and it felt
that the mechanism should work the same way in sleepable and non-sleepable bpf progs,
but sleepable progs have OOM issue if they hold to any kernel object.
So it's better to enforce in the verifier that both sleepable and non-sleepable
access kernel objects under RCU. We don't have to do it for all kptrs,
but for some it's probably necessary.

> 
> > Derefrence of other kptr-s returns PTR_UNTRUSTED.
> >
> > For example:
> > struct map_value {
> >    struct cgroup __kptr_rcu *cgrp;
> > };
> >
> > SEC("tp_btf/cgroup_mkdir")
> > int BPF_PROG(test_cgrp_get_ancestors, struct cgroup *cgrp_arg, const char *path)
> > {
> >   struct cgroup *cg, *cg2;
> >
> >   cg = bpf_cgroup_acquire(cgrp_arg); // cg is PTR_TRUSTED and ref_obj_id > 0
> >   bpf_kptr_xchg(&v->cgrp, cg);
> >
> >   cg2 = v->cgrp; // cg2 is PTR_TRUSTED | MEM_RCU. This is new feature introduced by this patch.
> >
> >   bpf_cgroup_ancestor(cg2, level); // safe to do. cg2 will not disappear
> 							^^ But it's percpu_ref
> 							can drop to zero, right?

Correct.
bpf_cgroup_ancestor() also needs to do cgroup_tryget().
