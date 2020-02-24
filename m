Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF5316ACC0
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbgBXRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:13:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50966 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:13:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so102032wmb.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 09:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=djq2UzRGDZUviySA8l7HGT0qHQEYWEuCD4uLW+Pmvvs=;
        b=WAaMkWyorUPlUuI4nRXYbnoDGL7eMtZS5tpi8LV09uUXVKFh7REQoOvUkK7e7el4rQ
         oWWOnN2++jNfuFzKY1zTUQCyJat1fTLlATlX3vBCBeFPfbMwKhe/f+QW6XvTChbrrrtY
         4PbOkD+89zTQLmnpGpMMS0qrKSMdfAMjGVrdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=djq2UzRGDZUviySA8l7HGT0qHQEYWEuCD4uLW+Pmvvs=;
        b=KCn4hhw0eyZDolgeajWyTYpJhtJXZolSokypQ2iZryYhLViimIy6F851raZymALLkg
         7EDXW4gDy6T0RmCITZ9pK6IiZryk/UF/Ao0FjfI88rvOfsr0Eoy0eFVJ3jvX2kl6WgT3
         4I3m+pW13CXh/zsXThsaHe3I+r6BzH7D7cav0tQ4Pcoch5Q90EscS5Yetl+97DbGy7ug
         y1FgNYEnvIXzjh30zcVhwUbPwQq0mi/Rw1SQTFA33upsx0Aw/+7yrTYZtgaLet18kYLS
         Q1u5QLNBYsjo/O2KdELJOeE+YkeTm/3yPW6Ta5dYF4jxy5/nHQ1O0bDJY8PEqeJgDNmE
         Yflg==
X-Gm-Message-State: APjAAAXKgCDXQF+k2fqtUVlSS2c2e+inqUfTN1rZGD2pMh4O9NmIqlii
        g/j8bd8T0W73k3nWLpn9/EvzlQ==
X-Google-Smtp-Source: APXvYqw+txJF+rLovWHEHGiqNzAcu94O+9oGuFuSTTeDeQS+cKKNh0sPeN+HaDKqz1TrcTn35uMIVQ==
X-Received: by 2002:a1c:dc85:: with SMTP id t127mr95275wmg.16.1582564387555;
        Mon, 24 Feb 2020 09:13:07 -0800 (PST)
Received: from chromium.org ([2620:0:105f:fd00:d960:542a:a1d:648a])
        by smtp.gmail.com with ESMTPSA id g29sm13919879wrb.59.2020.02.24.09.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:13:07 -0800 (PST)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Mon, 24 Feb 2020 18:13:05 +0100
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
Message-ID: <20200224171305.GA21886@chromium.org>
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook>
 <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24-Feb 08:32, Casey Schaufler wrote:
> On 2/23/2020 2:08 PM, Alexei Starovoitov wrote:
> > On Fri, Feb 21, 2020 at 08:22:59PM -0800, Kees Cook wrote:
> >> If I'm understanding this correctly, there are two issues:
> >>
> >> 1- BPF needs to be run last due to fexit trampolines (?)
> > no.
> > The placement of nop call can be anywhere.
> > BPF trampoline is automagically converting nop call into a sequence
> > of directly invoked BPF programs.
> > No link list traversals and no indirect calls in run-time.
> 
> Then why the insistence that it be last?

I think this came out of the discussion about not being able to
override the other LSMs and introduce a new attack vector with some
arguments discussed at:

  https://lore.kernel.org/bpf/20200109194302.GA85350@google.com/

Let's say we have SELinux + BPF runnng on the system. BPF should still
respect any decisions made by SELinux. This hasn't got anything to
do with the usage of fexit trampolines.

> 
> >> 2- BPF hooks don't know what may be attached at any given time, so
> >>    ALL LSM hooks need to be universally hooked. THIS turns out to create
> >>    a measurable performance problem in that the cost of the indirect call
> >>    on the (mostly/usually) empty BPF policy is too high.
> > also no.
> 
> Um, then why not use the infrastructure as is?

I think what Kees meant is that BPF allows hooking to all the LSM
hooks and providing static LSM hook callbacks like traditional LSMs
has a measurable performance overhead and this is indeed correct. This
is why we want provide with the following characteristics:

- Without introducing a new attack surface, this was the reason for
  creating a mutable security_hook_heads in v1 which ran the hook
  after v1.

  This approach still had the issues of an indirect call and an
  extra check when not used. So this was not truly zero overhead even
  after special casing BPF.

- Having a truly zero performance overhead on the system. There are
  other tracing / attachment mechnaisms in the kernel which provide
  similar guarrantees (using static keys and direct calls) and it
  seems regressive for KRSI to not leverage these known patterns and
  sacrifice performance espeically in hotpaths. This provides users
  to use KRSI alongside other LSMs without paying extra cost for all
  the possible hooks.

> 
> >> So, trying to avoid the indirect calls is, as you say, an optimization,
> >> but it might be a needed one due to the other limitations.
> > I'm convinced that avoiding the cost of retpoline in critical path is a
> > requirement for any new infrastructure in the kernel.
> 
> Sorry, I haven't gotten that memo.
> 
> > Not only for security, but for any new infra.
> 
> The LSM infrastructure ain't new.

But the ability to attach BPF programs to LSM hooks is new. Also, we
have not had the whole implementation of the LSM hook be mutable
before and this is essentially what the KRSI provides.

> 
> > Networking stack converted all such places to conditional calls.
> > In BPF land we converted indirect calls to direct jumps and direct calls.
> > It took two years to do so. Adding new indirect calls is not an option.
> > I'm eagerly waiting for Peter's static_call patches to land to convert
> > a lot more indirect calls. May be existing LSMs will take advantage
> > of static_call patches too, but static_call is not an option for BPF.
> > That's why we introduced BPF trampoline in the last kernel release.
> 
> Sorry, but I don't see how BPF is so overwhelmingly special.

My analogy here is that if every tracepoint in the kernel were of the
type:

if (trace_foo_enabled) // <-- Overhead here, solved with static key
   trace_foo(a);  // <-- retpoline overhead, solved with fexit trampolines

It would be very hard to justify enabling them on a production system,
and the same can be said for BPF and KRSI.

- KP

> 
> >> b) Would there actually be a global benefit to using the static keys
> >>    optimization for other LSMs?
> > Yes. Just compiling with CONFIG_SECURITY adds "if (hlist_empty)" check
> > for every hook.
> 
> Err, no, it doesn't. It does an hlish_for_each_entry(), which
> may be the equivalent on an empty list, but let's not go around
> spreading misinformation.
> 
> >  Some of those hooks are in critical path. This load+cmp
> > can be avoided with static_key optimization. I think it's worth doing.
> 
> I admit to being unfamiliar with the static_key implementation,
> but if it would work for a list of hooks rather than a singe hook,
> I'm all ears.
> 
> >> If static keys are justified for KRSI
> > I really like that KRSI costs absolutely zero when it's not enabled.
> 
> And I dislike that there's security module specific code in security.c,
> security.h and/or lsm_hooks.h. KRSI *is not that special*.
> 
> > Attaching BPF prog to one hook preserves zero cost for all other hooks.
> > And when one hook is BPF powered it's using direct call instead of
> > super expensive retpoline.
> 
> I'm not objecting to the good it does for KRSI.
> I am *strongly* objecting to special casing KRSI.
> 
> > Overall this patch set looks good to me. There was a minor issue with prog
> > accounting. I expect only that bit to be fixed in v5.
> 
