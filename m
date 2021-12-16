Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE851477C93
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 20:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbhLPTaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 14:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhLPTaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 14:30:14 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D05EC061574;
        Thu, 16 Dec 2021 11:30:14 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id y68so124418ybe.1;
        Thu, 16 Dec 2021 11:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vBq/AIjoYwp53RAGyy2WVyA7H7oGamWg7hkUDS5jhZc=;
        b=eChcv9h6UQyg6fZiNcX5tvhyN9alMPHXiZnA9LIry3iilpyveWARl7XZ6V0SAr2/np
         QE+/WTc+yD5qr4kuAscG5VgUbdTpUuZ2FAEsARchaNb9236f34jgzXDT6/kTjW8IKFgP
         L+/BNX9paBcDi43esbhII2sSY8GO7aXFY9w0yOQGphFKqVlZEzG5iKj0uq6go5fKFvIP
         q0XFgnHH6q2Oo1SNg9qonU0JUofBXzmawmZceezmsFXcPtxIiimTorh+8S+lYQAQ+HYF
         51l0F3FQojJKpb1tp0jNMLmmqfOdJRG7zxIYHbRfjWMyRiUOsAewnpWGNIZOKQKM1ST+
         U1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vBq/AIjoYwp53RAGyy2WVyA7H7oGamWg7hkUDS5jhZc=;
        b=7gJf9L1Q9ATL6pR30iOPUyzmsohK+K33b4wCGh+0oKmm0yG8/p/vRSbud2WSwDdySm
         NHFhBh79lOyazj6bhqV5w5YSCIKXNPwi+4ntRGwsMyyF6cTCTzEe9r3+fcmHW5mYzA+O
         aljCb6S4gOPmIWmAOs8QHDRm2DarPBe0Bt5ZKXdOCv3tLMFqEb9Aql6DQ/kLcEMHA+qj
         w0jFCfpt1jhWegWWfswz+xIKBIcjsoYgMTQmPdTqhUfyEYRhmy47fOkXrd+eW9QxLqtK
         qIrSMJV/epmpAyMeC/QmJIEZyFGoe2DP8sB5FKLfoJr+Sub+aIOekhJB7s6+WC6VGdCW
         TGRw==
X-Gm-Message-State: AOAM531Hew1+aQUKRxh+hvtQpe5NfmFa5PamrNcKFI/ndsvB7jaLKVej
        lgm/bj9YSrz9H1CDrP9KsDePcyY/nf6hnqQaedA=
X-Google-Smtp-Source: ABdhPJzJlt1GSC0aOS1XabcCyDX17a23mLFqWmYFQH5e7ix/HymjdWC09/g/yYCOtjr4mQ0MC+YCLVWhrdXpKCVDUek=
X-Received: by 2002:a25:e90a:: with SMTP id n10mr14717023ybd.180.1639683013244;
 Thu, 16 Dec 2021 11:30:13 -0800 (PST)
MIME-Version: 1.0
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
 <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com>
 <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
 <CAEf4BzahZhCEroeMWNTu-kGsuFCDaNCvbkiFW7ci0EUOWTwmqQ@mail.gmail.com> <d3c1b7f4-5363-c23e-4837-5eaf07f63ebc@linuxfoundation.org>
In-Reply-To: <d3c1b7f4-5363-c23e-4837-5eaf07f63ebc@linuxfoundation.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Dec 2021 11:30:01 -0800
Message-ID: <CAEf4BzYKnoD_x7fZ4Fwp0Kg-wT6HMXOG0CMRSG4U+qQ0R27yzQ@mail.gmail.com>
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

On Thu, Dec 16, 2021 at 6:42 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 12/15/21 9:04 PM, Andrii Nakryiko wrote:
> > On Tue, Dec 14, 2021 at 12:27 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>
> >> On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
> >>> On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>>>
> >>>> ARRAY_SIZE is defined in multiple test files. Remove the definitions
> >>>> and include header file for the define instead.
> >>>>
> >>>> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
> >>>> define.
> >>>>
> >>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> >>>> ---
> >>>>    tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
> >>>>    tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
> >>>>    tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
> >>>>    tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
> >>>>    tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
> >>>>    5 files changed, 5 insertions(+), 19 deletions(-)
> >>>>
> >>>> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>> index 1d8918dfbd3f..7a5ebd330689 100644
> >>>> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >>>> @@ -5,6 +5,7 @@
> >>>>    #include <bpf/bpf_helpers.h>
> >>>>    #include <bpf/bpf_tracing.h>
> >>>>    #include <bpf/bpf_core_read.h>
> >>>> +#include <bpf/bpf_util.h>
> >>>
> >>> It doesn't look like you've built it.
> >>>
> >>> progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> >>> #include <bpf/bpf_util.h>
> >>>            ^~~~~~~~~~~~~~~~
> >>>     CLNG-BPF [test_maps] socket_cookie_prog.o
> >>> progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> >>> #include <bpf/bpf_util.h>
> >>>            ^~~~~~~~~~~~~~~~
> >>> 1 error generated.
> >>> In file included from progs/profiler2.c:6:
> >>> progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
> >>> #include <bpf/bpf_util.h>
> >>>            ^~~~~~~~~~~~~~~~
> >>>
> >>
> >> Sorry about that. I built it - I think something is wrong in my env. Build
> >> fails complaining about not finding vmlinux - I overlooked that the failure
> >> happened before it got to progs.
> >>
> >> Error: failed to load BTF from .../vmlinux: No such file or directory
> >
> > Please make sure that you build vmlinux before you build selftests,
> > BPF selftests use vmlinux to generate vmlinux.h with all kernel types
> > (among other things). So please also make sure that all the setting in
> > selftests/bpf/config were used in your Kconfig.
> >
> >>
>
> The problem in my env. is that I don't have CONFIG_DEBUG_INFO_BTF in
> my config and then don't have the dwarves and llvm-strip on my system.
> Pains of upgrading.
>
> I am all set now. On the other hand the vmlinux.h is a mess. It has
> no guards for defines and including stdio.h and this generated
> vmlinux.h causes all sorts of problems.

It does have

#ifndef __VMLINUX_H__
#define __VMLINUX_H__

Are we talking about the same vmlinux.h here?

As for stdio.h. vmlinux.h doesn't co-exist with other headers well,
it's a known inconvenience we are trying to fix at Clang side. But
stdio.h makes no sense as vmlinux.h is supposed to be used only from
the BPF program side, where stdio.h never worked. So not sure what you
are trying to do, but vmlinux.h works fine for cases it was created
for.

>
> thanks,
> -- Shuah
