Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC224781E1
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhLQBDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhLQBDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:03:52 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72237C061574;
        Thu, 16 Dec 2021 17:03:52 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id q74so1752291ybq.11;
        Thu, 16 Dec 2021 17:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=esp5q/yMslV4XhtOkSMlOozHd3IJiE7INI35/+PGDPo=;
        b=pMLpNZFo5PgsMaYgd/8fgoPkD5dUOEMb81W63b8U4WVoqtNMOyseQ7DoGimtHnMMnV
         Qd+ksiTOMBVNHPkzpfG+lPA7R37XTrQwAdC7qxdKbhuMbCKkiNEHSBv+9sUt8tPU5Cam
         sDnBWKo6Ugs2JyJDytDcCYnPApIRrHtQ113/clIvX+U9Mw/UdUF4NWcr0+8ePKByYE+W
         1kq8HGmsOZtFgqwSy70ebDweE6WImC6lZFv0Gz4d04k+U5jwkliL0F2zRTyJ5K+7b4rd
         mxRtDg77ZE/3LnlNamIDq0zFavbsOyJwHF769pKW5gh9SvxfnsBJWVU7XiGhmKzO2p6r
         pMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=esp5q/yMslV4XhtOkSMlOozHd3IJiE7INI35/+PGDPo=;
        b=kkaP4TS3xpLhmqf7QitQL8sZMj1KupGVLzqRIjLRtWuhmzU6M2yR3mBjQC3SjQD+FB
         W9F/PviHwta0HtxT4GjRLFBDXGkfXKHHuimPPlLdSfyr8v6H0QPJIfg7fOeCPKGoldzJ
         6O7uDSejiyzXiBGV8NLAzPbAe0k9mL+mZk9tPU9fFWHOEBSFbxl7Fe+Sn9ijCKi9FdW8
         CYwCLaozlFHXMzPDxCQnhOPz4kcpjZvSEacoOA7F5JJM++eWz0lCk9sdVkeBP0V5j7jN
         K0cVOMx4RpZEH5HuVofScd5fdgNJXME8eGdgl74FOeFZJ5x4DqmLf9TWh1tft/KfyYsY
         uKpg==
X-Gm-Message-State: AOAM532g+lePPJdNa7Rbx9mfU9sSrNwqEbItcFneFFVDoV4tSVX6j1Ww
        1dWinwt/YscKAwoqoi8Kzv7/oNa8aLDGv0rhTH4=
X-Google-Smtp-Source: ABdhPJwWkFRTrpXiBRSyqwIlsAo7elgTEuvCMvdSSw06QmN1c7fQw6DfCVYGfXXISiEbvVjSOot+NY2Zn+eXVj5s1s0=
X-Received: by 2002:a5b:1c2:: with SMTP id f2mr1160509ybp.150.1639703031653;
 Thu, 16 Dec 2021 17:03:51 -0800 (PST)
MIME-Version: 1.0
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
 <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
 <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
 <CAEf4BzahZhCEroeMWNTu-kGsuFCDaNCvbkiFW7ci0EUOWTwmqQ@mail.gmail.com>
 <d3c1b7f4-5363-c23e-4837-5eaf07f63ebc@linuxfoundation.org>
 <CAEf4BzYKnoD_x7fZ4Fwp0Kg-wT6HMXOG0CMRSG4U+qQ0R27yzQ@mail.gmail.com>
 <53490dba-b7fd-a3f8-6574-5736c83aa90d@linuxfoundation.org>
 <CAEf4BzYA1h2kVF3945hxdcR8gf08GFpLiN1OwjedzTrzaAparA@mail.gmail.com> <cc4d6562-3d2e-2c0a-cb31-2733d2189f5c@linuxfoundation.org>
In-Reply-To: <cc4d6562-3d2e-2c0a-cb31-2733d2189f5c@linuxfoundation.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Dec 2021 17:03:40 -0800
Message-ID: <CAEf4BzZ1K9uQ-K1Q2BCSBesR3RUj_NW8uHu6NduoX7uLBdfukQ@mail.gmail.com>
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

On Thu, Dec 16, 2021 at 12:22 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 12/16/21 1:03 PM, Andrii Nakryiko wrote:
> > On Thu, Dec 16, 2021 at 11:51 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>
> >> On 12/16/21 12:30 PM, Andrii Nakryiko wrote:
> >>> On Thu, Dec 16, 2021 at 6:42 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>>
> >>>> On 12/15/21 9:04 PM, Andrii Nakryiko wrote:
> >>>>> On Tue, Dec 14, 2021 at 12:27 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>>>>
> >>>>>> On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
> >>>>>>> On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>>>>>>
> >>>>>>>> ARRAY_SIZE is defined in multiple test files. Remove the definitions
> >>>>>>>> and include header file for the define instead.
> >>>>>>>>
> >>>>>>>> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
> >>>>>>>> define.
> >>>>>>>>
> >>>>>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> >>>>>>>> ---
> >>>>>>>>      tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
> >>>>>>>>      tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
> >>>>>>>>      tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
> >>>>>>>>      tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
> >>>>>>>>      tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
> >>>>>>>>      5 files changed, 5 insertions(+), 19 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>>>>>> index 1d8918dfbd3f..7a5ebd330689 100644
> >>>>>>>> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>>>>>> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>>>>>> @@ -5,6 +5,7 @@
> >>>>>>>>      #include <bpf/bpf_helpers.h>
> >>>>>>>>      #include <bpf/bpf_tracing.h>
> >>>>>>>>      #include <bpf/bpf_core_read.h>
> >>>>>>>> +#include <bpf/bpf_util.h>
> >>>>>>>
> >>>>>>> It doesn't look like you've built it.
> >>>>>>>
> >>>>>>> progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> >>>>>>> #include <bpf/bpf_util.h>
> >>>>>>>              ^~~~~~~~~~~~~~~~
> >>>>>>>       CLNG-BPF [test_maps] socket_cookie_prog.o
> >>>>>>> progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> >>>>>>> #include <bpf/bpf_util.h>
> >>>>>>>              ^~~~~~~~~~~~~~~~
> >>>>>>> 1 error generated.
> >>>>>>> In file included from progs/profiler2.c:6:
> >>>>>>> progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
> >>>>>>> #include <bpf/bpf_util.h>
> >>>>>>>              ^~~~~~~~~~~~~~~~
> >>>>>>>
> >>>>>>
> >>>>>> Sorry about that. I built it - I think something is wrong in my env. Build
> >>>>>> fails complaining about not finding vmlinux - I overlooked that the failure
> >>>>>> happened before it got to progs.
> >>>>>>
> >>>>>> Error: failed to load BTF from .../vmlinux: No such file or directory
> >>>>>
> >>>>> Please make sure that you build vmlinux before you build selftests,
> >>>>> BPF selftests use vmlinux to generate vmlinux.h with all kernel types
> >>>>> (among other things). So please also make sure that all the setting in
> >>>>> selftests/bpf/config were used in your Kconfig.
> >>>>>
> >>>>>>
> >>>>
> >>>> The problem in my env. is that I don't have CONFIG_DEBUG_INFO_BTF in
> >>>> my config and then don't have the dwarves and llvm-strip on my system.
> >>>> Pains of upgrading.
> >>>>
> >>>> I am all set now. On the other hand the vmlinux.h is a mess. It has
> >>>> no guards for defines and including stdio.h and this generated
> >>>> vmlinux.h causes all sorts of problems.
> >>>
> >>> It does have
> >>>
> >>> #ifndef __VMLINUX_H__
> >>> #define __VMLINUX_H__
> >>>
> >>> Are we talking about the same vmlinux.h here?
> >>>
> >>
> >> Yes we are. The guard it has works when vmlinux.h is included
> >> twice. It defines a lot of common defines which are the problem.
> >> Unless you add guards around each one of them, including vmlinux.h
> >> is problematic if you also include other standard includes.
> >>
> >> You can try to include bpf_util.h for example from one of the
> >> test in progs to see the problem.
> >
> > bpf_util.h is a user-space header, it's not going to work from the BPF
> > program side. If you look at any of progs/*.c (all of which are BPF
> > program-side source code), not a single one is including bpf_util.h.
> >
>
> Whether bpf_util.h can be included from progs isn't the main thing here.
> progs/test*.c including vmlinux.h (most of them seem to) can,'t include
> any standard .h files.
>
> "including vmlinux.h is problematic if a test also had to include other
>   standard includes."
>
> This makes this header file restrictive and works in one case and one
> case only when no other standard headers aren't included.
>

It does work with other BPF-side headers that libbpf provides:
bpf_tracing.h, bpf_core_read.h, etc. Yes, it doesn't work with other
kernel or non-kernel headers. We are well aware of this limitation and
are currently trying to convince the Clang community to let us fix
that with a new attribute for Clang.

But I'm not sure what we are discussing at this point. I think we
established that bpf_util.h is a user-space header and can't be used
from the BPF side.

> thanks,
> -- Shuah
