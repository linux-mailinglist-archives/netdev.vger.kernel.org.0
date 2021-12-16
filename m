Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C6A477CFB
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbhLPUEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLPUEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:04:10 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9CCC061574;
        Thu, 16 Dec 2021 12:04:09 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id d10so325505ybe.3;
        Thu, 16 Dec 2021 12:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GdDT7fgaRT12dHtkLlXU8bb/jY5+OF81ewRwhn48r6k=;
        b=cDV3WjRyiOm+kOhD5xF5xysuN2erCnSE/CV+ORT/DW+K3FBLLGY6NpxSHHPB5EmrNq
         TBwPXsoat88ZSzGdCzQ94co1mqOz/6AF3ugwmwGiATib2jS5qTTwtQgsBrText0WhmmH
         b1VJhGjGSJxhg9nbBn+zuNnmoNS+3cQwGiLFY1nF/M7sxqZ3MnPkyzDOrduLihk+kfYh
         1yoSHYMGQbQbcbnICVG77YO8XHoPu6CFmCCrHBvkFWPt47oOOjZVmSl9131UhpsgXtbm
         KFLG3xKuTZtkq+FNkhmX7qE97WmEgAcpAvGzbawo8SldtYryUsN7kKcZHFKTXwH+UhP3
         t2vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GdDT7fgaRT12dHtkLlXU8bb/jY5+OF81ewRwhn48r6k=;
        b=an9vZX0r7Yhna0Sn2qmiGKtgaGJ6FELGX2c9C1CrEBr8QsEHYcQzWCbXBeJsqJg3aP
         O8ZVTZECNtV94RxDpccncP9dXZBTQSK9CdI56arPSV7w2LnQuBXjJ0ZUPwxxVWdREbE7
         mo10wuKaPbnEDqE0K890rBnsY6p9YTGh8LH4R0O1TQW/Ryi8eIUOEtp2QQvRb8VGaz04
         Rb9h8P1jzfEVPCMTZdidSZacDNboANXzAFfBFkudUg+gmkW3BmcizLoBqgD5WvUuVp2R
         EtipT9YSttZ2oppZ22fPkFk+0k5dG3PrNu8yGQ162h00aEGB81cZbZTuF3R25id++wZv
         LYkw==
X-Gm-Message-State: AOAM531o3/WWQpuqVKNDDM2vb3UJlbakoTB55+ESrQezIdMEqTPN80x7
        cKrMagjCWtRMVie67Ri0IBjktj+t3cMWoPYYBRg=
X-Google-Smtp-Source: ABdhPJya9BM+Mcmy7aJRR+XGyA5T2i3+ELM7RIX4XCVoURcpUHy4KSU6X0TqMTnlxvzQSQy6D25MfEBYnihj93grjfY=
X-Received: by 2002:a25:37cb:: with SMTP id e194mr15740944yba.449.1639685049006;
 Thu, 16 Dec 2021 12:04:09 -0800 (PST)
MIME-Version: 1.0
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
 <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
 <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
 <CAEf4BzahZhCEroeMWNTu-kGsuFCDaNCvbkiFW7ci0EUOWTwmqQ@mail.gmail.com>
 <d3c1b7f4-5363-c23e-4837-5eaf07f63ebc@linuxfoundation.org>
 <CAEf4BzYKnoD_x7fZ4Fwp0Kg-wT6HMXOG0CMRSG4U+qQ0R27yzQ@mail.gmail.com> <53490dba-b7fd-a3f8-6574-5736c83aa90d@linuxfoundation.org>
In-Reply-To: <53490dba-b7fd-a3f8-6574-5736c83aa90d@linuxfoundation.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Dec 2021 12:03:57 -0800
Message-ID: <CAEf4BzYA1h2kVF3945hxdcR8gf08GFpLiN1OwjedzTrzaAparA@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: remove ARRAY_SIZE defines from tests
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 11:51 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 12/16/21 12:30 PM, Andrii Nakryiko wrote:
> > On Thu, Dec 16, 2021 at 6:42 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>
> >> On 12/15/21 9:04 PM, Andrii Nakryiko wrote:
> >>> On Tue, Dec 14, 2021 at 12:27 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>>
> >>>> On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
> >>>>> On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>>>>
> >>>>>> ARRAY_SIZE is defined in multiple test files. Remove the definitions
> >>>>>> and include header file for the define instead.
> >>>>>>
> >>>>>> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
> >>>>>> define.
> >>>>>>
> >>>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> >>>>>> ---
> >>>>>>     tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
> >>>>>>     tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
> >>>>>>     tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
> >>>>>>     tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
> >>>>>>     tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
> >>>>>>     5 files changed, 5 insertions(+), 19 deletions(-)
> >>>>>>
> >>>>>> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>>>> index 1d8918dfbd3f..7a5ebd330689 100644
> >>>>>> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>>>> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>>>> @@ -5,6 +5,7 @@
> >>>>>>     #include <bpf/bpf_helpers.h>
> >>>>>>     #include <bpf/bpf_tracing.h>
> >>>>>>     #include <bpf/bpf_core_read.h>
> >>>>>> +#include <bpf/bpf_util.h>
> >>>>>
> >>>>> It doesn't look like you've built it.
> >>>>>
> >>>>> progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> >>>>> #include <bpf/bpf_util.h>
> >>>>>             ^~~~~~~~~~~~~~~~
> >>>>>      CLNG-BPF [test_maps] socket_cookie_prog.o
> >>>>> progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> >>>>> #include <bpf/bpf_util.h>
> >>>>>             ^~~~~~~~~~~~~~~~
> >>>>> 1 error generated.
> >>>>> In file included from progs/profiler2.c:6:
> >>>>> progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
> >>>>> #include <bpf/bpf_util.h>
> >>>>>             ^~~~~~~~~~~~~~~~
> >>>>>
> >>>>
> >>>> Sorry about that. I built it - I think something is wrong in my env. Build
> >>>> fails complaining about not finding vmlinux - I overlooked that the failure
> >>>> happened before it got to progs.
> >>>>
> >>>> Error: failed to load BTF from .../vmlinux: No such file or directory
> >>>
> >>> Please make sure that you build vmlinux before you build selftests,
> >>> BPF selftests use vmlinux to generate vmlinux.h with all kernel types
> >>> (among other things). So please also make sure that all the setting in
> >>> selftests/bpf/config were used in your Kconfig.
> >>>
> >>>>
> >>
> >> The problem in my env. is that I don't have CONFIG_DEBUG_INFO_BTF in
> >> my config and then don't have the dwarves and llvm-strip on my system.
> >> Pains of upgrading.
> >>
> >> I am all set now. On the other hand the vmlinux.h is a mess. It has
> >> no guards for defines and including stdio.h and this generated
> >> vmlinux.h causes all sorts of problems.
> >
> > It does have
> >
> > #ifndef __VMLINUX_H__
> > #define __VMLINUX_H__
> >
> > Are we talking about the same vmlinux.h here?
> >
>
> Yes we are. The guard it has works when vmlinux.h is included
> twice. It defines a lot of common defines which are the problem.
> Unless you add guards around each one of them, including vmlinux.h
> is problematic if you also include other standard includes.
>
> You can try to include bpf_util.h for example from one of the
> test in progs to see the problem.

bpf_util.h is a user-space header, it's not going to work from the BPF
program side. If you look at any of progs/*.c (all of which are BPF
program-side source code), not a single one is including bpf_util.h.

>
> thanks,
> -- Shuah
