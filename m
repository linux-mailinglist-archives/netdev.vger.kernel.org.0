Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156BE4EB7FC
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241733AbiC3BxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiC3BxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:53:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAA03EAB9;
        Tue, 29 Mar 2022 18:51:33 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p8so17484472pfh.8;
        Tue, 29 Mar 2022 18:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B4rWblJL0MZ8T0ZIBif5AzrJ8ETA+UM8GaU5wY6h6a8=;
        b=ZVDjFC+m48ojVug53qjqKEIja96Wodjrory0myyCfeHYG8PRrhiTIHDUjGJNZNDkJl
         ePHq8LTqUR0+qKrNpeBcpquUjbyVbE53AnBf7jbvIA+w6t/5oXnp90bUueSFirSx4xWE
         O4/kRo41e5ho3nIveNuIM3GbQW0aLpdPP49uND/2372N4aItDUn9pRwi45bHONCsmPEe
         A3dSYJD9BJUjRq7+UXIB4KefM9eRBRWCDQ5wvVtJbElImSrxyC215hOBJ97wG/iqPUYQ
         VBfC+HjOjMfXOVSLuOJrNYBDP43hQP5EV+sxVS5OtD8sPtiTmkYNfDLN6kmA3+nVSSi0
         RGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B4rWblJL0MZ8T0ZIBif5AzrJ8ETA+UM8GaU5wY6h6a8=;
        b=ePfDcNON3pMw4u6ZWYEiRTJyoQBDNYoiztuxrN2A1YUbEMzjFPWSWhAyMDW8/haz/P
         qdjuvOVAMtQixAsNzlQHY1d46TwdHv8zxaN45FwMIVWkd/v+ZvqjdAfzXINCWtXFjVDX
         iWEkQ1h/FPf0dQrLZ0T1uTrx+BxvaQuh10T4oOJOdDBzvFpMnq/fa4KGbwmUlHOCxR1b
         PWIWWX8BsKpRrd9tEyzcm7laEbRrhtip1CWaF72fxkR14NoP0GcSFKigY3m+a3J8XfML
         0e5NA66EvqDRenP+YCwWyszXMCvNdaBluEL8fShD98gOFD4prjALaIcnbDuz5jxRIMN1
         PCMQ==
X-Gm-Message-State: AOAM531MYgfkAZFhxO5jKj+jQzkzBuSrbJuiqiHgRYHg/cBpn1fucKJH
        ZJCwr7UQT/e5GXCWeFQIjujRYUSaviERj9nJahVNYYcI
X-Google-Smtp-Source: ABdhPJxQUkmXlqqI8D9AGbP1BYhc/Dp3VVUybsDR2QMimKqjrQxJUHnOBOJLsT8rl3Qim7PU6wAQtlfMGIFckFBxtOY=
X-Received: by 2002:a63:3e4c:0:b0:398:3448:e0d1 with SMTP id
 l73-20020a633e4c000000b003983448e0d1mr4239254pga.336.1648605093203; Tue, 29
 Mar 2022 18:51:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220329234924.39053-1-alexei.starovoitov@gmail.com> <20220329184123.59cfad63@kernel.org>
In-Reply-To: <20220329184123.59cfad63@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Mar 2022 18:51:22 -0700
Message-ID: <CAADnVQJNS_U97aqaNxtAhuvZCK6oiDA-tDoAEyDMYnCBbfaZkg@mail.gmail.com>
Subject: Re: pull-request: bpf 2022-03-29
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 6:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 29 Mar 2022 16:49:24 -0700 Alexei Starovoitov wrote:
> > Hi David, hi Jakub,
> >
> > The following pull-request contains BPF updates for your *net* tree.
> >
> > We've added 16 non-merge commits during the last 1 day(s) which contain
> > a total of 24 files changed, 354 insertions(+), 187 deletions(-).
> >
> > The main changes are:
> >
> > 1) x86 specific bits of fprobe/rethook, from Masami and Peter.
> >
> > 2) ice/xsk fixes, from Maciej and Magnus.
> >
> > 3) Various small fixes, from Andrii, Yonghong, Geliang and others.
>
> There are some new sparse warnings here that look semi-legit.
> As in harmless but not erroneous.

Both are new warnings and not due to these patches, right?

> kernel/trace/rethook.c:68:9: error: incompatible types in comparison expression (different address spaces):
> kernel/trace/rethook.c:68:9:    void ( [noderef] __rcu * )( ... )
> kernel/trace/rethook.c:68:9:    void ( * )( ... )
>
> 66 void rethook_free(struct rethook *rh)
> 67 {
> 68         rcu_assign_pointer(rh->handler, NULL);
> 69
> 70         call_rcu(&rh->rcu, rethook_free_rcu);
> 71 }
>
> Looks like this should be a WRITE_ONCE() ?

Masami, please take a look.

> And the __user annotations in bpf_trace.c are still not right,
> first arg of kprobe_multi_resolve_syms() should __user:
>
> kernel/trace/bpf_trace.c:2370:34: warning: incorrect type in argument 2 (different address spaces)
> kernel/trace/bpf_trace.c:2370:34:    expected void const [noderef] __user *from
> kernel/trace/bpf_trace.c:2370:34:    got void const *usyms
> kernel/trace/bpf_trace.c:2376:51: warning: incorrect type in argument 2 (different address spaces)
> kernel/trace/bpf_trace.c:2376:51:    expected char const [noderef] __user *src
> kernel/trace/bpf_trace.c:2376:51:    got char const *
> kernel/trace/bpf_trace.c:2443:49: warning: incorrect type in argument 1 (different address spaces)
> kernel/trace/bpf_trace.c:2443:49:    expected void const *usyms
> kernel/trace/bpf_trace.c:2443:49:    got void [noderef] __user *[assigned] usyms

This one is known. Still waiting for the fix from Jiri.

> How do you wanna proceed?

If they both are old I would proceed.
I don't consider sparse warnings as a blocker in general.
