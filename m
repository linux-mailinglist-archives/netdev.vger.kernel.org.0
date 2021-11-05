Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095EA446A1B
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 21:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhKEUv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 16:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhKEUvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 16:51:51 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57B8C061714;
        Fri,  5 Nov 2021 13:49:11 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w9-20020a17090a1b8900b001a6b3b7ec17so4079893pjc.3;
        Fri, 05 Nov 2021 13:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u0mVXsRz1L12lg+FS0aqM5yzxNrbuenZfhlvvf78DsE=;
        b=bed/qJVnBpwfADqNm6l9SXOhYDVRTIxH8/YZfNXIES3Z+hDkDd155u6l+QHVaQbYXr
         pnh7sLPQreZKQvkO1WCNvBlA0qriQC79/dS6Tl4VqfLAMW4YdOJ6/IdBrn1Lkq/gk4G+
         L3Ob6mrAvrKskvEI5T8ZbvpjMXXBS8Jhw+eRMpAhLEepWxj3IqmkKGbohxYSRHSN76RH
         Lmi+Y/zHuizLxu/52aKz971XNlEQLIaMOpiKWbHzJF5GCRh0FO3G3FY8ci8OIPHAQrk3
         70kG7WohqMwqOv9bUOtOqRTua3/H4VUOZqVuSSO+fcoydIMngZclwIt22PGcwf8Fqp+3
         NAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u0mVXsRz1L12lg+FS0aqM5yzxNrbuenZfhlvvf78DsE=;
        b=T/luNt2e5S+cbpBczMrwvJbi4ZeEMCz7jP2X9bhF3vjBi90A71OKJYckBGRNlMYIvF
         1fhmCQJRZb8ptl8eu32h0JhjYBLaFzUA8wGUdzT0vf4so7HNAfnoYZzMqu7IuUOCBIKJ
         wv4VJVJNM/0/90lujiZwnbjJHnUepFlnXpeYsWSHS7Q8yhmeAQwGwPfk5Xhy6GrgFgrP
         3apXZ/tSvFps3XEF6lihM5V/WtGzY7cK4NhSCWyf3LoxELQsWvLLNxiPMNS78LxjuaMd
         m/g+X5FQ268WZVaDEsJcCqP67cOHGvkkOVzMVsSjRXkvcxLaTnkC2Bm1Y+8/Gx7MnRoG
         qC6w==
X-Gm-Message-State: AOAM531LhMELwGC2ZwqlelhJSGJvs7cWvm6RlIWw7fs/x/BbcLegCAk1
        /txf50ZXUxHLFjDvRMBRL24=
X-Google-Smtp-Source: ABdhPJwL0SIeNKorlFnQbMtPXwgKZ3Vf4o24N/eLwYc77iimxYDKQZtFVW07gN1/TyXqjvzA6wur8w==
X-Received: by 2002:a17:90b:3758:: with SMTP id ne24mr33495756pjb.59.1636145351150;
        Fri, 05 Nov 2021 13:49:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:808])
        by smtp.gmail.com with ESMTPSA id mg17sm7022173pjb.17.2021.11.05.13.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 13:49:10 -0700 (PDT)
Date:   Fri, 5 Nov 2021 13:49:08 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20211105204908.4cqxk2nbkas6bduw@ast-mbp.dhcp.thefacebook.com>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
 <20211104125503.smxxptjqri6jujke@apollo.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211104125503.smxxptjqri6jujke@apollo.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 06:25:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> On Wed, Nov 03, 2021 at 04:46:42AM IST, Alexei Starovoitov wrote:
> > On Sat, Oct 30, 2021 at 08:16:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> > > This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> > > patch adding the lookup helper is based off of Maxim's recent patch to aid in
> > > rebasing their series on top of this, all adjusted to work with kfunc support
> > > [0].
> > >
> > > This is an RFC series, as I'm unsure whether the reference tracking for
> > > PTR_TO_BTF_ID will be accepted.
> >
> > Yes. The patches look good overall.
> > Please don't do __BPF_RET_TYPE_MAX signalling. It's an ambiguous name.
> > _MAX is typically used for a different purpose. Just give it an explicit name.
> > I don't fully understand why that skip is needed though.
> 
> I needed a sentinel to skip return type checking (otherwise check that return
> type and prototype match) since existing kfunc don't have a
> get_kfunc_return_type callback, but if we add bpf_func_proto support to kfunc
> then we can probably convert existing kfuncs to that as well and skip all this
> logic. Mostly needed it for RET_PTR_TO_BTF_ID_OR_NULL.

So it's just to special case r0=PTR_TO_BTF_ID_OR_NULL instead of
PTR_TO_BTF_ID that it's doing by default now?
Then could you use a btf_id list to whitelist all such funcs that needs _OR_NULL
variant and just do a search in that list in check_kfunc_call() ?
Instead of adding get_kfunc_return_type() callback.

> Extending to support bpf_func_proto seemed like a bit of work so I wanted to get
> some feedback first on all this, before working on it.

No need to hack into bpf_func_proto. All kernel funcs have BTF. It's all we need.
The _OR_NULL part we will eventually be able to express with btf_tag when
it's supported by both gcc and clang.

> > > Also, I want to understand whether it would make sense to introduce
> > > check_helper_call style bpf_func_proto based argument checking for kfuncs, or
> > > continue with how it is right now, since it doesn't seem correct that PTR_TO_MEM
> > > can be passed where PTR_TO_BTF_ID may be expected. Only PTR_TO_CTX is enforced.
> >
> > Do we really allow to pass PTR_TO_MEM argument into a function that expects PTR_TO_BTF_ID ?
> 
> Sorry, that's poorly phrased. Current kfunc doesn't support PTR_TO_MEM. I meant
> it would be allowed now, with the way I implemented things, but there also isn't
> a way to signal whether PTR_TO_BTF_ID is expected (hence the question about
> bpf_func_proto). I did not understand why that was not done originally (maybe it
> was lack of usecase). PTR_TO_CTX works because the type is matched with prog
> type, so you can't pass something else there. For other cases the type of
> register is considered.

Right. btf_check_kfunc_arg_match doesn't allow ptr_to_mem yet.
There is no signalling needed.
All args passed by the program into kfunc have to be either exact
PTR_TO_BTF_ID or conversions from PTR_TO_SOCK*.

Passing rX=PTR_TO_CTX into kfunc should not work. If I'm reading the code
correctly it's not allowed. I'm not sure why you're saying it can be done.
It's possible to pass PTR_TO_CTX into another bpf prog's global function.
The same btf_check_func_arg_match() helper checks both cases (global funcs and kfuncs).
Maybe that's where the confusion comes from?

Same with if (ptr_to_mem_ok). It's only for passing PTR_TO_MEM
into bpf prog's global function.
We can extend the verifier and allow PTR_TO_MEM into kfunc that
has 'long *' prototype, for example.
But it doesn't sound like the use case you have in mind.
