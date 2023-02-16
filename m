Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA81A699A19
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBPQeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjBPQeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:34:05 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427C85598;
        Thu, 16 Feb 2023 08:34:04 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id bx13so2178463oib.13;
        Thu, 16 Feb 2023 08:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E79bszEkXyL1Uu31TCsUIZ1fuRm4uTXgVjD82UOvLNg=;
        b=mXIUJOFESnTCW9zgXIbH9abaoM55eYqd1x1fVpqaGMljasCSC9zujdlWs/27iLVbKM
         2uENKp5LBCdAigHCLe9IjDLD/WGMJaYsiweCUUeao43PNW4tcKuWrj5xxDugmPj7yQ9T
         KIzWHMZxu3FH6nWcPOcbcj0ve4FHvQJCJeIxWsqiWt/i1gVAqMtqk9KJjilIRluXexH5
         eFyeWNI5rbF2gyEauDv1ngdN0BTZ9n3Es1zD/RpBVk8nQD48pRZyX+bgv5mgl4AmWyzf
         NaRZk8X9HOB0P6Dr8t2Fcc1mdHawyC7Ar1ztm0IqecrLHEfCK34qDdSdHqLlo3/c9fDH
         bu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E79bszEkXyL1Uu31TCsUIZ1fuRm4uTXgVjD82UOvLNg=;
        b=p7bKRsTHek+5qVM1aAAu93BD0CpkI7rEd7lEqQtOll34SF/+a7YJyC0uuh4+ZQWEwo
         rE+QOklSAyhFB6TFDvKT86+mXo2srf+lla2WJqWBVoKV57KwssiKwMekMNhZKOLKl350
         LVFF8bdyq7Fp2gXo4nJi9jDWF/0PXGd3nRBHl1VDjB2K2x6WICZFWew+MGl6LMgFunsv
         O3EIATL57TIbD5jq3/jQ0dPhQzliujO9UHIH0a7HmG3qDtbF+q3dG+N9wsLxasuO18et
         wzL8EZo2XO4OSbLQ0+c1Jg+lOg76N3g+p+z2NblzTwRYC0+okEhCDxV0tdQo6EhMEtsH
         MeJw==
X-Gm-Message-State: AO0yUKW9dzIQLz0QuYJ/lWoQT1sVJkLjdgTZL7e7DCVCoFkNpnVoNtt0
        EIcTDb7HZPgI5vEYtJF0jT4=
X-Google-Smtp-Source: AK7set8WjWN4IRN6hCos+ikWEjoLPG5CWeffObm5hlvBSLlXznDUfgFXJbzE18uxiuy9u/O4+xb+aA==
X-Received: by 2002:a05:6808:1d1:b0:37a:bc9b:5a4f with SMTP id x17-20020a05680801d100b0037abc9b5a4fmr2870917oic.55.1676565243458;
        Thu, 16 Feb 2023 08:34:03 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id j83-20020acab956000000b00369a721732asm697581oif.41.2023.02.16.08.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 08:34:02 -0800 (PST)
Date:   Thu, 16 Feb 2023 08:34:00 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Kees Cook <kees@kernel.org>
Cc:     Bruno Goncalves <bgoncalv@redhat.com>,
        Networking <netdev@vger.kernel.org>, alan.maguire@oracle.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [6.2.0-rc7] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
Message-ID: <Y+5a+LN+h/v91cd0@yury-laptop>
References: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com>
 <Y+ubkJtpmc6l0gOt@yury-laptop>
 <CA+QYu4rBbstxtewRVF2hSaVK1i3-CzifPnchfSaxe_EALhR1rA@mail.gmail.com>
 <Y+15ZIVyiOWNnTZ8@yury-laptop>
 <1CAE4AF4-D557-4A18-891D-BAC1B2156B66@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1CAE4AF4-D557-4A18-891D-BAC1B2156B66@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 05:51:39PM -0800, Kees Cook wrote:
> On February 15, 2023 4:31:32 PM PST, Yury Norov <yury.norov@gmail.com> wrote:
> >+ Kees Cook <keescook@chromium.org>
> >+ Miguel Ojeda <ojeda@kernel.org>
> >+ Nick Desaulniers <ndesaulniers@google.com>
> >
> >On Wed, Feb 15, 2023 at 09:24:52AM +0100, Bruno Goncalves wrote:
> >> On Tue, 14 Feb 2023 at 15:32, Yury Norov <yury.norov@gmail.com> wrote:
> >> >
> >> > On Tue, Feb 14, 2023 at 02:23:06PM +0100, Bruno Goncalves wrote:
> >> > > Hello,
> >> > >
> >> > > recently when testing kernel with debug options set from net-next [1]
> >> > > and bpf-next [2] the following call trace happens:
> >> > >
> >> > Hi Bruno,
> >> >
> >> > Thanks for report.
> >> >
> >> > This looks weird, because the hop_cmp() spent for 3 month in -next till
> >> > now. Anyways, can you please share your NUMA configuration so I'll try
> >> > to reproduce the bug locally? What 'numactl -H' outputs?
> >> >
> >> 
> >> Here is the output:
> >> 
> >> numactl -H
> >> available: 4 nodes (0-3)
> >> node 0 cpus: 0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39
> >> node 0 size: 32063 MB
> >> node 0 free: 31610 MB
> >> node 1 cpus: 8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47
> >> node 1 size: 32248 MB
> >> node 1 free: 31909 MB
> >> node 2 cpus: 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55
> >> node 2 size: 32248 MB
> >> node 2 free: 31551 MB
> >> node 3 cpus: 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63
> >> node 3 size: 32239 MB
> >> node 3 free: 31468 MB
> >> node distances:
> >> node   0   1   2   3
> >>   0:  10  21  31  21
> >>   1:  21  10  21  31
> >>   2:  31  21  10  21
> >>   3:  21  31  21  10
> >> 
> >> Bruno
> >
> >So, I was able to reproduce it, and it seems like a compiler issue.
> >
> >The problem is that hop_cmp() calculates pointer to a previous hop
> >object unconditionally at the beginning of the function:
> >
> >       struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
> > 
> >Obviously, for the first hop, there's no such thing like a previous
> >one, and later in the code 'prev_hop' is used conditionally on that:
> >
> >       k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
> >
> >To me the code above looks like it instructs the compiler to dereference
> >'b - 1' only if b != k->masks, i.e. when b is not the first hop. But GCC
> >does that unconditionally, which looks wrong.
> >
> >If I defer dereferencing manually like in the snippet below, the kasan
> >warning goes away.
> >
> >diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> >index 48838a05c008..5f297f81c574 100644
> >--- a/kernel/sched/topology.c
> >+++ b/kernel/sched/topology.c
> >@@ -2081,14 +2081,14 @@ struct __cmp_key {
> >
> > static int hop_cmp(const void *a, const void *b)
> > {
> >-       struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
> >        struct cpumask **cur_hop = *(struct cpumask ***)b;
> >        struct __cmp_key *k = (struct __cmp_key *)a;
> >
> >        if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
> >                return 1;
> >
> >-       k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
> >+       k->w = (b == k->masks) ? 0 :
> >+               cpumask_weight_and(k->cpus, (*((struct cpumask ***)b - 1))[k->node]);
> >        if (k->w <= k->cpu)
> >                return 0;
> >
> >I don't understand why GCC doesn't optimize out unneeded dereferencing.
> >It does that even if I replace ternary operator with if-else construction.
> >To me it looks like a compiler bug.
> >
> >However, I acknowledge that I'm not a great expert in C standard, so
> >it's quite possible that there may be some rule that prevents from
> >doing such optimizations, even for non-volatile variables.
> >
> >Adding compiler people. Guys, could you please clarify on that?
> >If it's my fault, I'll submit fix shortly.
> 
> My understanding is that without getting inlined, the compiler cannot evaluate "b == k->masks" at compile time (if it can at all). So since the dereference is part of variable initialization, it's not executed later: it's executed at function entry.
> 
> Regardless, this whole function looks kind of hard to read. Why not fully expand it with the if/else logic and put any needed variables into the respective clauses? Then humans can read it and the compiler will optimize it down just as efficiently.

Yes, changing it to if-else would be a simplest solution.

Thanks,
Yury
