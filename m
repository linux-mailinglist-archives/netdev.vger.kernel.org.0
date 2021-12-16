Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06984768EF
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 05:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhLPEEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 23:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhLPEEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 23:04:51 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A72C061574;
        Wed, 15 Dec 2021 20:04:50 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id 131so60926112ybc.7;
        Wed, 15 Dec 2021 20:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M5hd03nfR2iBOHfB3tDlcvjjCHo3CH/+wbQDgx81RYY=;
        b=K3rgGhVTVos+g/w1iD9fZq9xwYQ9WkQIUJydeTgOnicasY3rlqQ0cXEbvS1pKHBXMT
         vZsHQQ2eNPWJwjbdze+LyOD7DJHN4+0RjOYhv+//BYW5BHT7hgIxHOnD8hn7r1Vub0IT
         sRbfzrt0P/+CiT9g9GihznyzH2/9b7DTuH54xJefwNT4D9MHXVGGpdkjUz729bDf4bak
         rPbGuV509xe6N7ElDwiw4CJpVACWOpz+MCtb9ByUmCQ1zjynqAo56HN7Ksy2mn8Z56Ok
         wwIHMNOzyFq4Bik0kkiQSbvlZFx262wa/BOqXdAc3LBPWtIQ8MEj+j1OrAc1Cminyq3N
         x5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M5hd03nfR2iBOHfB3tDlcvjjCHo3CH/+wbQDgx81RYY=;
        b=4reYgR8fC1doyF+3OnU35TV0v78mxMh3IWoII5XQc72NSBvV1ENxN5YSxBwQcHqPCJ
         QHRUIdmVgRZHxADaPGKR+PiCeGEtHNv9JQ1SbejEl/uIbB6eLphO66H21AenTlwcXTxi
         MbqTSDFNpkYgTSgKaNnDh0WdoZ+aGXulaC1nLHzAQLkDzMNcEsTr7U8AIsB8A2NEKgoQ
         kXuYe+XYQ4H2VEfmuelXpiI1PJxfbZKBODRD0bJoWa6ZHAvPK0EoEmB2zue15Lwq8ilc
         MO45U8UdkuZBKhHNTomlJMsN+qZfZaElsE3ud7HWHyapNJOViIpIw3s/ytmDJn1vBbLE
         iStQ==
X-Gm-Message-State: AOAM532eFcB8RoEYGsQDdbvxajEbCX34SOGJRYnb2CVaAPVBVfDKdwO/
        Ycu+tfyLgFHPkrvcPa1n1TzhY5Wr70BPy7mrTdUGZr2ANi8=
X-Google-Smtp-Source: ABdhPJw2qFftLQX+HGUz0zp8VC9JMlFEuHxdrxULCH34QjNd3jPjLUuzcGgQ/hSPi/B290KANWj2o/3rcHqab1V1PL8=
X-Received: by 2002:a25:2a89:: with SMTP id q131mr11702009ybq.436.1639627489988;
 Wed, 15 Dec 2021 20:04:49 -0800 (PST)
MIME-Version: 1.0
References: <20211210173433.13247-1-skhan@linuxfoundation.org>
 <CAADnVQ+Fnn-NuGoLq1ZYbHM=kR_W01GB1DCFOnQTHhgfDOrnaA@mail.gmail.com> <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
In-Reply-To: <d367441f-bba0-30eb-787a-89b0c06a65dd@linuxfoundation.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Dec 2021 20:04:38 -0800
Message-ID: <CAEf4BzahZhCEroeMWNTu-kGsuFCDaNCvbkiFW7ci0EUOWTwmqQ@mail.gmail.com>
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

On Tue, Dec 14, 2021 at 12:27 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>
> On 12/11/21 6:53 PM, Alexei Starovoitov wrote:
> > On Fri, Dec 10, 2021 at 9:34 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
> >>
> >> ARRAY_SIZE is defined in multiple test files. Remove the definitions
> >> and include header file for the define instead.
> >>
> >> Remove ARRAY_SIZE define and add include bpf_util.h to bring in the
> >> define.
> >>
> >> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> >> ---
> >>   tools/testing/selftests/bpf/progs/netif_receive_skb.c | 5 +----
> >>   tools/testing/selftests/bpf/progs/profiler.inc.h      | 5 +----
> >>   tools/testing/selftests/bpf/progs/test_sysctl_loop1.c | 5 +----
> >>   tools/testing/selftests/bpf/progs/test_sysctl_loop2.c | 4 +---
> >>   tools/testing/selftests/bpf/progs/test_sysctl_prog.c  | 5 +----
> >>   5 files changed, 5 insertions(+), 19 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >> index 1d8918dfbd3f..7a5ebd330689 100644
> >> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> >> @@ -5,6 +5,7 @@
> >>   #include <bpf/bpf_helpers.h>
> >>   #include <bpf/bpf_tracing.h>
> >>   #include <bpf/bpf_core_read.h>
> >> +#include <bpf/bpf_util.h>
> >
> > It doesn't look like you've built it.
> >
> > progs/test_sysctl_prog.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> > #include <bpf/bpf_util.h>
> >           ^~~~~~~~~~~~~~~~
> >    CLNG-BPF [test_maps] socket_cookie_prog.o
> > progs/test_sysctl_loop2.c:11:10: fatal error: 'bpf/bpf_util.h' file not found
> > #include <bpf/bpf_util.h>
> >           ^~~~~~~~~~~~~~~~
> > 1 error generated.
> > In file included from progs/profiler2.c:6:
> > progs/profiler.inc.h:7:10: fatal error: 'bpf/bpf_util.h' file not found
> > #include <bpf/bpf_util.h>
> >           ^~~~~~~~~~~~~~~~
> >
>
> Sorry about that. I built it - I think something is wrong in my env. Build
> fails complaining about not finding vmlinux - I overlooked that the failure
> happened before it got to progs.
>
> Error: failed to load BTF from .../vmlinux: No such file or directory

Please make sure that you build vmlinux before you build selftests,
BPF selftests use vmlinux to generate vmlinux.h with all kernel types
(among other things). So please also make sure that all the setting in
selftests/bpf/config were used in your Kconfig.

>
> I do have the kernel built with gcc. Is there a clang dependency?

Yes, you'll need recent enough Clang. Probably the easiest is to get
one of the latest nightly packages.

>
> thanks,
> -- Shuah
>
