Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292C423AC21
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgHCSIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:08:53 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1570DC06174A;
        Mon,  3 Aug 2020 11:08:53 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id q16so18372196ybk.6;
        Mon, 03 Aug 2020 11:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=43FIygflrP4nZzCzM391hzVnqu/34/YNK7sTtCa/sIU=;
        b=Ven5Tnv//6OlbBX0ZnZOzYotpGinzcEgkUuYl49w66Wui2AUjfIOSxyLSBJSqc4K+C
         oalAwAo7FJ8GEJKN6ju4PcWJ+/YzBv/+Xivsf4Dx56Z/g3IIcGtTVJihQxJTrT+nHpbD
         qNM1RJPmgiQhzeruMcvKmDm29ChIXmn6BnVthd4fq9uTNKZT2TjvR/iYjXfQGLSBZkEJ
         n5Ay5cgLrKevxMtwlLw/WWyUpjDQTm5xzWWxYU9b9I0sjKIGE4sSiwRzehl/4AzEDxTQ
         ohDMREy6GzJkuNH9ryiLF/G1nmnieKOMQq9R8TxX7bOXi9SFl94LLL9i694z59FZffrb
         mhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=43FIygflrP4nZzCzM391hzVnqu/34/YNK7sTtCa/sIU=;
        b=Xk/2tYHg/AeuzOQc8jSSo6qkN8LWVvLMyo+xbVabnzDRTylh6QFPpFzdWd0nWRwmML
         QgToyoNGZzIcrvW0pi9TOl8jb1F3H6+8A2VrTZPg4vvTGjx8OgRayRy08Za8DX7IgHGB
         YdfioxyoooqE6D5ca6rtcbzDl/5dwJo5cevYmT8ra7UF9GXGVdKxdcVSKdHh+GXnKBCe
         yHTSzFI5lYJnvIrqww4XG9DAQnSrSf/RHNb90KWuBFV8NU2G985v8UySV42OjIldkgWD
         40V4vxEk2Kr6FiozdRbiYWiVzGt3B95gpbDtYRvhOzDJLwAQIo+LL50at6WttgXZ4HGG
         9XPw==
X-Gm-Message-State: AOAM530PwL4AyuTCokgj+h+HQ4ZX+vQq/p1PqYUn3Imf7Y52g+cRYg6t
        J5/X7VpwrhbhzuAVGqlSOSVywqJz4p4UVi1sUwo=
X-Google-Smtp-Source: ABdhPJw2f5UOFtpKfBmujaqlA3CJko6XTdyPcr6ow+Gfy4eJZ4LEZsH6m92ThODYEcXr/8sCShEeycydghQq7xotsoQ=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr29271679ybg.347.1596478132146;
 Mon, 03 Aug 2020 11:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
 <20200802222950.34696-4-alexei.starovoitov@gmail.com> <33d2db5b-3f81-e384-bed8-96f1d7f1d4c7@iogearbox.net>
 <430839eb-2761-0c1a-4b99-dffb07b9f502@iogearbox.net> <736dc34e-254d-de46-ac91-512029f675e7@iogearbox.net>
 <CAEf4BzY-RHiG+0u1Ug+k0VC01Fqp3BUQ60OenRv+na4fuYRW=Q@mail.gmail.com> <181ce3e4-c960-3470-5c08-3e56ea7f28b2@iogearbox.net>
In-Reply-To: <181ce3e4-c960-3470-5c08-3e56ea7f28b2@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 Aug 2020 11:08:40 -0700
Message-ID: <CAEf4BzZp+uc0n=A9=x3T=5ii2J5x_tu_0ZOYKoUQ-r39GJM3DQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/4] bpf: Add kernel module with user mode
 driver that populates bpffs.
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 10:56 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 8/3/20 7:51 PM, Andrii Nakryiko wrote:
> > On Mon, Aug 3, 2020 at 10:41 AM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
> >> On 8/3/20 7:34 PM, Daniel Borkmann wrote:
> >>> On 8/3/20 7:15 PM, Daniel Borkmann wrote:
> >>>> On 8/3/20 12:29 AM, Alexei Starovoitov wrote:
> >>>>> From: Alexei Starovoitov <ast@kernel.org>
> >>>>>
> >>>>> Add kernel module with user mode driver that populates bpffs with
> >>>>> BPF iterators.
> >>>>>
> >
> > [...]
> >
> >>     CC      kernel/events/ring_buffer.o
> >>     CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/bpf.o
> >>     CC [U]  kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o
> >> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libb=
pf.c:47:0:
> >> ./tools/include/tools/libc_compat.h:11:21: error: static declaration o=
f =E2=80=98reallocarray=E2=80=99 follows non-static declaration
> >>    static inline void *reallocarray(void *ptr, size_t nmemb, size_t si=
ze)
> >>                        ^~~~~~~~~~~~
> >> In file included from kernel/bpf/preload/./../../../tools/lib/bpf/libb=
pf.c:16:0:
> >> /usr/include/stdlib.h:558:14: note: previous declaration of =E2=80=98r=
eallocarray=E2=80=99 was here
> >>    extern void *reallocarray (void *__ptr, size_t __nmemb, size_t __si=
ze)
> >>                 ^~~~~~~~~~~~
> >
> > A bit offtopic. reallocarray and related feature detection causes so
> > much hassle, that I'm strongly tempted to just get rid of it in the
> > entire libbpf. Or just unconditionally implement libbpf-specific
> > reallocarray function. Any objections?
>
> Agree that it's continuously causing pain; no objection from my side to h=
ave
> something libbpf-specifc for example (along with a comment on /why/ we're=
 not
> reusing it anymore).

Sounds good!

>
> >>     CC      kernel/user-return-notifier.o
> >> scripts/Makefile.userprogs:43: recipe for target 'kernel/bpf/preload/.=
/../../../tools/lib/bpf/libbpf.o' failed
> >> make[3]: *** [kernel/bpf/preload/./../../../tools/lib/bpf/libbpf.o] Er=
ror 1
> >> scripts/Makefile.build:497: recipe for target 'kernel/bpf/preload' fai=
led
> >> make[2]: *** [kernel/bpf/preload] Error 2
> >> scripts/Makefile.build:497: recipe for target 'kernel/bpf' failed
> >> make[1]: *** [kernel/bpf] Error 2
> >> make[1]: *** Waiting for unfinished jobs....
> >> [...]
