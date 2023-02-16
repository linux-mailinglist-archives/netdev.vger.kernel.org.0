Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3334B698947
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBPAbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjBPAbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:31:37 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BB942BC9;
        Wed, 15 Feb 2023 16:31:36 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id t5so234976oiw.1;
        Wed, 15 Feb 2023 16:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iVrrRlGXt+tU2jQz14Ueq33ChGNBSAVNSFytqXCqf5M=;
        b=kigpvrQNnggC1qsASExSzpBIxjDP61w8/6hkbob6Byddg7PutyFfbm/oFA9X/k0Kw9
         fOYv6EZYAQ+LzujozK+qv/nP0bpJqySKRxQ10BWprPp+CwusvxshgL34WmP+nube0oNL
         q+kWLsecRXiJ4pXeDidZB4+6AqAm3wB2mLuHxUtmc1G9P09ET2QEN2FdHZxKH2nzvOXn
         jOCLz30R/a1ycGZ5WHCWyMc4/OMxEjxTTJT8+ln+i9ObP8LBGGqvLfWVvJ1mKeByi7vZ
         kJfW/5rH68py4XMloDDzW11TSErH7Lm/D0IdLBu1Nexiy72rw0L4yS4mhWS2kHHnSFJk
         KdBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVrrRlGXt+tU2jQz14Ueq33ChGNBSAVNSFytqXCqf5M=;
        b=fq8+Pg/XPMAGfiF+BUNVsyWxbyy+GpbqHP7YXg5XY5+tRn+jyLCLIVpi4BLc0JMTMe
         k63Ry4QxRT7xLaeZOFTDyTTbr56g/l344DuibFJWMTQOJ3E0Jc5573Cv5LkuYDzepRb9
         AUdrNBw7noIkfIw19g1OafEC++9dBgI+K7WmZrEiC+SErtyD583fVywn9vzO82FbSgiX
         MpflcqWKE/SdU842niKuAxjh4xLu3GDpb5BtkQXRt0J3GskohWRnYZPp0ZF7nMiS8m9b
         HTJysw+7Obpcdw+1czCnTjPG2G5T09hLdgXelw+3RyVmTrV6ZlBIhM8sis7z93OOccs9
         oXkw==
X-Gm-Message-State: AO0yUKU6gcc9NnRZKuWY98R1QDfkmxCxoxoJHSVTpx9LWyYRjWaEZG4D
        B0to1cLhKMCkvaaFcradUow=
X-Google-Smtp-Source: AK7set8cTCE1WjeM68Ki7l28jimn2FfmNctBooDBcHIHMCktu7f0rSMIP7yaIiQFuUl0Bxjo4YDO1A==
X-Received: by 2002:aca:2412:0:b0:364:e7cd:747a with SMTP id n18-20020aca2412000000b00364e7cd747amr1895629oic.43.1676507495385;
        Wed, 15 Feb 2023 16:31:35 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id x189-20020acae0c6000000b0037868f9e657sm1761545oig.37.2023.02.15.16.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 16:31:34 -0800 (PST)
Date:   Wed, 15 Feb 2023 16:31:32 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Bruno Goncalves <bgoncalv@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, alan.maguire@oracle.com,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CKI Project <cki-project@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [6.2.0-rc7] BUG: KASAN: slab-out-of-bounds in hop_cmp+0x26/0x110
Message-ID: <Y+15ZIVyiOWNnTZ8@yury-laptop>
References: <CA+QYu4qkVzZaB2OTaTLniZB9OCbTYUr2qvvvCmAnMkaq43OOLA@mail.gmail.com>
 <Y+ubkJtpmc6l0gOt@yury-laptop>
 <CA+QYu4rBbstxtewRVF2hSaVK1i3-CzifPnchfSaxe_EALhR1rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+QYu4rBbstxtewRVF2hSaVK1i3-CzifPnchfSaxe_EALhR1rA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Kees Cook <keescook@chromium.org>
+ Miguel Ojeda <ojeda@kernel.org>
+ Nick Desaulniers <ndesaulniers@google.com>

On Wed, Feb 15, 2023 at 09:24:52AM +0100, Bruno Goncalves wrote:
> On Tue, 14 Feb 2023 at 15:32, Yury Norov <yury.norov@gmail.com> wrote:
> >
> > On Tue, Feb 14, 2023 at 02:23:06PM +0100, Bruno Goncalves wrote:
> > > Hello,
> > >
> > > recently when testing kernel with debug options set from net-next [1]
> > > and bpf-next [2] the following call trace happens:
> > >
> > Hi Bruno,
> >
> > Thanks for report.
> >
> > This looks weird, because the hop_cmp() spent for 3 month in -next till
> > now. Anyways, can you please share your NUMA configuration so I'll try
> > to reproduce the bug locally? What 'numactl -H' outputs?
> >
> 
> Here is the output:
> 
> numactl -H
> available: 4 nodes (0-3)
> node 0 cpus: 0 1 2 3 4 5 6 7 32 33 34 35 36 37 38 39
> node 0 size: 32063 MB
> node 0 free: 31610 MB
> node 1 cpus: 8 9 10 11 12 13 14 15 40 41 42 43 44 45 46 47
> node 1 size: 32248 MB
> node 1 free: 31909 MB
> node 2 cpus: 16 17 18 19 20 21 22 23 48 49 50 51 52 53 54 55
> node 2 size: 32248 MB
> node 2 free: 31551 MB
> node 3 cpus: 24 25 26 27 28 29 30 31 56 57 58 59 60 61 62 63
> node 3 size: 32239 MB
> node 3 free: 31468 MB
> node distances:
> node   0   1   2   3
>   0:  10  21  31  21
>   1:  21  10  21  31
>   2:  31  21  10  21
>   3:  21  31  21  10
> 
> Bruno

So, I was able to reproduce it, and it seems like a compiler issue.

The problem is that hop_cmp() calculates pointer to a previous hop
object unconditionally at the beginning of the function:

       struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
 
Obviously, for the first hop, there's no such thing like a previous
one, and later in the code 'prev_hop' is used conditionally on that:

       k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);

To me the code above looks like it instructs the compiler to dereference
'b - 1' only if b != k->masks, i.e. when b is not the first hop. But GCC
does that unconditionally, which looks wrong.

If I defer dereferencing manually like in the snippet below, the kasan
warning goes away.

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 48838a05c008..5f297f81c574 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2081,14 +2081,14 @@ struct __cmp_key {

 static int hop_cmp(const void *a, const void *b)
 {
-       struct cpumask **prev_hop = *((struct cpumask ***)b - 1);
        struct cpumask **cur_hop = *(struct cpumask ***)b;
        struct __cmp_key *k = (struct __cmp_key *)a;

        if (cpumask_weight_and(k->cpus, cur_hop[k->node]) <= k->cpu)
                return 1;

-       k->w = (b == k->masks) ? 0 : cpumask_weight_and(k->cpus, prev_hop[k->node]);
+       k->w = (b == k->masks) ? 0 :
+               cpumask_weight_and(k->cpus, (*((struct cpumask ***)b - 1))[k->node]);
        if (k->w <= k->cpu)
                return 0;

I don't understand why GCC doesn't optimize out unneeded dereferencing.
It does that even if I replace ternary operator with if-else construction.
To me it looks like a compiler bug.

However, I acknowledge that I'm not a great expert in C standard, so
it's quite possible that there may be some rule that prevents from
doing such optimizations, even for non-volatile variables.

Adding compiler people. Guys, could you please clarify on that?
If it's my fault, I'll submit fix shortly.

Thanks,
Yury
