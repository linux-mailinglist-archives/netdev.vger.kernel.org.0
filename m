Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085BF446A71
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 22:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhKEVQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 17:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbhKEVP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 17:15:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ABFC061205;
        Fri,  5 Nov 2021 14:13:16 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m14so9953306pfc.9;
        Fri, 05 Nov 2021 14:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bLFcudYHcUQ0bdDojW2Sio4njsKVHhnb9MBRPYO2+MY=;
        b=TCL0tvyQdSd6bNITEUpRGd2Id7HR657Yi3fzt7UJE7XpzxP4GRTByZekComWYMBp21
         ya2hjPrKgbI1CUVWnJBUat1IedOZYiFJ+u3GDs5/xLvtq+jWq0/kbYl/F8A9cbsC3uPw
         q0bi+IJ4zsTdzunyuXaXdJ4JDYrrJzaQhquxT1aahmhvFPde5nxJfr4wzmaHO2V+rjVx
         HweG7jOcz1EUbDKIar9eGAPdsQRbxyyIolss3///O9ycVUWEfRt82DOduirHkmqnziug
         +Ppy+W05YhXN6e8fJ9EoH2ggHTqg7SNdjQq1HaSQTKM0jjnMb4kCaI/69R2yDUVsyPdG
         sGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bLFcudYHcUQ0bdDojW2Sio4njsKVHhnb9MBRPYO2+MY=;
        b=AM6WVonhjbf9M93SbgZ9WwQW7kHc1fXbw+v7y3KKm1Omzq4A6rk1HyDOwpg8NXCLYI
         D+Mbaa9Ta7xJHAxFrITq73KY4cCXFMDOIDP6uP52Gg0ok38bvpWK18IVaB7NbzttsukL
         NtFaWfmuPcmsvOiRSNj312OPUtcofh+qZy2cUP1TThaDkRgopVNCCB8lZC0ws7l8OoXi
         g8VRH2J22XG5Yz3ZkAchj7kIvjxPdSKbVGaskxqNddQ418cHTnaIw3yLeDgLLpNDJ0b7
         LIG5Xcg/4RhoFbTZUVC0+om4OrwHBZkGVs9JaU8mcnvoj8+tjbYcdvQUU0BrkNpXOMjT
         IwuQ==
X-Gm-Message-State: AOAM530qx3NdMNDFtWmKtHO0iV5dHqSLIifNB9jj8EOlyEhH/xdPlPX7
        oaR/K2TKKMmMCnBgeuJMURo=
X-Google-Smtp-Source: ABdhPJwzvM2kX++dyZjZBTrSfHpn/pqm9mv/pZANcQniMsg0fyJyySwR0Lh2LYwvmnDXqp1zDj456A==
X-Received: by 2002:a05:6a00:1ad2:b0:47c:8125:4daa with SMTP id f18-20020a056a001ad200b0047c81254daamr61610330pfv.60.1636146796188;
        Fri, 05 Nov 2021 14:13:16 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id t2sm6749668pgf.35.2021.11.05.14.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 14:13:15 -0700 (PDT)
Date:   Sat, 6 Nov 2021 02:43:12 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 0/6] Introduce unstable CT lookup helpers
Message-ID: <20211105211312.ms3r7zpna3c7ct4f@apollo.localdomain>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
 <20211104125503.smxxptjqri6jujke@apollo.localdomain>
 <20211105204908.4cqxk2nbkas6bduw@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105204908.4cqxk2nbkas6bduw@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 06, 2021 at 02:19:08AM IST, Alexei Starovoitov wrote:
> On Thu, Nov 04, 2021 at 06:25:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> > On Wed, Nov 03, 2021 at 04:46:42AM IST, Alexei Starovoitov wrote:
> > > On Sat, Oct 30, 2021 at 08:16:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > > This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> > > > patch adding the lookup helper is based off of Maxim's recent patch to aid in
> > > > rebasing their series on top of this, all adjusted to work with kfunc support
> > > > [0].
> > > >
> > > > This is an RFC series, as I'm unsure whether the reference tracking for
> > > > PTR_TO_BTF_ID will be accepted.
> > >
> > > Yes. The patches look good overall.
> > > Please don't do __BPF_RET_TYPE_MAX signalling. It's an ambiguous name.
> > > _MAX is typically used for a different purpose. Just give it an explicit name.
> > > I don't fully understand why that skip is needed though.
> >
> > I needed a sentinel to skip return type checking (otherwise check that return
> > type and prototype match) since existing kfunc don't have a
> > get_kfunc_return_type callback, but if we add bpf_func_proto support to kfunc
> > then we can probably convert existing kfuncs to that as well and skip all this
> > logic. Mostly needed it for RET_PTR_TO_BTF_ID_OR_NULL.
>
> So it's just to special case r0=PTR_TO_BTF_ID_OR_NULL instead of
> PTR_TO_BTF_ID that it's doing by default now?
> Then could you use a btf_id list to whitelist all such funcs that needs _OR_NULL
> variant and just do a search in that list in check_kfunc_call() ?
> Instead of adding get_kfunc_return_type() callback.
>

Hm, good idea, that should work for now.

> > Extending to support bpf_func_proto seemed like a bit of work so I wanted to get
> > some feedback first on all this, before working on it.
>
> No need to hack into bpf_func_proto. All kernel funcs have BTF. It's all we need.
> The _OR_NULL part we will eventually be able to express with btf_tag when
> it's supported by both gcc and clang.
>

More on this below.

> > > > Also, I want to understand whether it would make sense to introduce
> > > > check_helper_call style bpf_func_proto based argument checking for kfuncs, or
> > > > continue with how it is right now, since it doesn't seem correct that PTR_TO_MEM
> > > > can be passed where PTR_TO_BTF_ID may be expected. Only PTR_TO_CTX is enforced.
> > >
> > > Do we really allow to pass PTR_TO_MEM argument into a function that expects PTR_TO_BTF_ID ?
> >
> > Sorry, that's poorly phrased. Current kfunc doesn't support PTR_TO_MEM. I meant
> > it would be allowed now, with the way I implemented things, but there also isn't
> > a way to signal whether PTR_TO_BTF_ID is expected (hence the question about
> > bpf_func_proto). I did not understand why that was not done originally (maybe it
> > was lack of usecase). PTR_TO_CTX works because the type is matched with prog
> > type, so you can't pass something else there. For other cases the type of
> > register is considered.
>
> Right. btf_check_kfunc_arg_match doesn't allow ptr_to_mem yet.
> There is no signalling needed.
> All args passed by the program into kfunc have to be either exact
> PTR_TO_BTF_ID or conversions from PTR_TO_SOCK*.
>

I should have been clearer again :). Sorry for that.

Right now only PTR_TO_BTF_ID and PTR_TO_SOCK and scalars are supported, as you
noted, for kfunc arguments.

So in 3/6 I move the PTR_TO_CTX block before btf_is_kernel check, that means if
reg type is PTR_TO_CTX and it matches the argument for the program, it will use
that, otherwise it moves to btf_is_kernel(btf) block, which checks if reg->type
is PTR_TO_BTF_ID or one of PTR_TO_SOCK* and does struct match for those. Next, I
punt to ptr_to_mem for the rest of the cases, which I think is problematic,
since now you may pass PTR_TO_MEM where some kfunc wants a PTR_TO_BTF_ID.

But without bpf_func_proto, I am not sure we can decide what is expected in the
kfunc. For something like bpf_sock_tuple, we'd want a PTR_TO_MEM, but taking in
a PTR_TO_BTF_ID also isn't problematic since it is just data, but for a struct
embedding pointers or other cases, it may be a problem.

For PTR_TO_CTX in kfunc case, based on my reading and testing, it will reject
any attempts to pass anything other than PTR_TO_CTX due to btf_get_prog_ctx_type
for that argument. So that works fine.

To me it seems like extending with some limited argument checking is necessary,
either using tagging as you mentioned or bpf_func_proto, or some other hardcoded
checking for now since the number of helpers needing this support is low.

Please correct me if I'm wrong about any of this.

> Passing rX=PTR_TO_CTX into kfunc should not work. If I'm reading the code
> correctly it's not allowed. I'm not sure why you're saying it can be done.
> It's possible to pass PTR_TO_CTX into another bpf prog's global function.
> The same btf_check_func_arg_match() helper checks both cases (global funcs and kfuncs).
> Maybe that's where the confusion comes from?
>
> Same with if (ptr_to_mem_ok). It's only for passing PTR_TO_MEM
> into bpf prog's global function.
> We can extend the verifier and allow PTR_TO_MEM into kfunc that
> has 'long *' prototype, for example.
> But it doesn't sound like the use case you have in mind.

--
Kartikeya
