Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B17143D024
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbhJ0R4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbhJ0R4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:56:33 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D6CC061570;
        Wed, 27 Oct 2021 10:54:07 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id q74so2489191ybq.11;
        Wed, 27 Oct 2021 10:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WK26rKUn9dfrEu+5qJRzS35C3Qm3H+r6uq+OcRK5q7Y=;
        b=IHZ0Z05jE3OSebTTZDJjyChiUymm+sbRBQQQ674d+q/hnSM/Adgkhtlh8pv8THpK4N
         RZBf23Ey4Qiyi2iA9epMS7E5MPaIXBCSTWdKLNQRTrA4d/VdbggOiEBGmGQ7IvGdkxzu
         Ek2MFr6/kLte+XYy5rwmIoid1+MrdC8L/aeH25sI+or5K6ep40nUG5yCKWVI0mAtZTbr
         uC9pQw2Zg14czhJX6hCEqfoB0NVdhyQjUFYkZeHoXGw5ZvKU/Pi2WxYMOQkP7cDIrVsa
         8sRwHg7HTMsEu8aXWZX7sirnwSKmftEmvoSI8w9gEQo99VXEXNhECF5B+1ymbgJsrCNK
         0U7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WK26rKUn9dfrEu+5qJRzS35C3Qm3H+r6uq+OcRK5q7Y=;
        b=iIfA67oT9ejF4u5dFD7RVvMPmpytpkQ81Hvxh9BdOqau5fGqgvsq0ZJXf2FFIXSXYG
         FzFvd9Sr1N4fFJa+N/KkusSbydePLpUNJ+pHmM/dHMqCOLgkCI3cGbkm7nTCfrelB6W/
         2BXxhemoi+U4LXjSL4Np6ytOnGnxLjJgLs79qZ30+6iRlm08X488HKnmTz953X6l4K0h
         h6Cj+jIPLSPUOnHLqUbV1hfRp5dK7AB2tdg4F7xedkJq22T0KD2JCy35WQdKZFX/K/CI
         h6en3qme30jGmbVoEalSBmgzVjFhEp/wr8NhfoGGi/mxJvfctJLcVzZsNqn8diEQUycn
         wQSw==
X-Gm-Message-State: AOAM532nSbOjU4EUrsT8UZ+Dw2+V8sFNPbTjsrU7HS2SQwtGDPc3Ugpo
        hFOX5r36Z3wt2RMyEolkZndWwP87V7n8lPy0GRM=
X-Google-Smtp-Source: ABdhPJwve+afpkS4fRBibZZoHFqX4PRw66vUEQX7fAaJr427n1Bgopx+TsTNjtgTjEDIGgnTAKuaQ+qw6XJgeXT7QNQ=
X-Received: by 2002:a25:aa0f:: with SMTP id s15mr26564691ybi.51.1635357246433;
 Wed, 27 Oct 2021 10:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211023120452.212885-1-jolsa@kernel.org> <CAEf4BzbaD60KFsUB4VkTAH2v3+GFkRvRbY_O-bNSpNG0=8pJ0Q@mail.gmail.com>
 <YXfulitQY1+Gd35h@krava> <CAEf4BzabyAdsrUoRx58MZKbwVBGa93247sw8pwU62N_wNhSZSQ@mail.gmail.com>
 <YXkTihiRKKJIc9M6@krava>
In-Reply-To: <YXkTihiRKKJIc9M6@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Oct 2021 10:53:55 -0700
Message-ID: <CAEf4BzYP8eK0qxF+1UK7=TZ+vFRVMfmnm9AN=B2JHROoDwaHeg@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 1:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Oct 26, 2021 at 09:12:31PM -0700, Andrii Nakryiko wrote:
> > On Tue, Oct 26, 2021 at 5:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Mon, Oct 25, 2021 at 09:54:48PM -0700, Andrii Nakryiko wrote:
> > > > On Sat, Oct 23, 2021 at 5:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > >
> > > > > hi,
> > > > > I'm trying to enable BTF for kernel module in fedora,
> > > > > and I'm getting big increase on modules sizes on s390x arch.
> > > > >
> > > > > Size of modules in total - kernel dir under /lib/modules/VER/
> > > > > from kernel-core and kernel-module packages:
> > > > >
> > > > >                current   new
> > > > >       aarch64      60M   76M
> > > > >       ppc64le      53M   66M
> > > > >       s390x        21M   41M
> > > > >       x86_64       64M   79M
> > > > >
> > > > > The reason for higher increase on s390x was that dedup algorithm
> > > > > did not detect some of the big kernel structs like 'struct module',
> > > > > so they are duplicated in the kernel module BTF data. The s390x
> > > > > has many small modules that increased significantly in size because
> > > > > of that even after compression.
> > > > >
> > > > > First issues was that the '--btf_gen_floats' option is not passed
> > > > > to pahole for kernel module BTF generation.
> > > > >
> > > > > The other problem is more tricky and is the reason why this patchset
> > > > > is RFC ;-)
> > > > >
> > > > > The s390x compiler generates multiple definitions of the same struct
> > > > > and dedup algorithm does not seem to handle this at the moment.
> > > > >
> > > > > I put the debuginfo and btf dump of the s390x pnet.ko module in here:
> > > > >   http://people.redhat.com/~jolsa/kmodbtf/
> > > > >
> > > > > Please let me know if you'd like to see other info/files.
> > > > >
> > > >
> > > > Hard to tell what's going on without vmlinux itself. Can you upload a
> > > > corresponding kernel image with BTF in it?
> > >
> > > sure, uploaded
> > >
> >
> > vmlinux.btfdump:
> >
> > [174] FLOAT 'float' size=4
> > [175] FLOAT 'double' size=8
> >
> > VS
> >
> > pnet.btfdump:
> >
> > [89318] INT 'float' size=4 bits_offset=0 nr_bits=32 encoding=(none)
> > [89319] INT 'double' size=8 bits_offset=0 nr_bits=64 encoding=(none)
>
> ugh, that's with no fix applied, sry
>
> I applied the first patch and uploaded new files
>
> now when I compare the 'module' struct from vmlinux:
>
>         [885] STRUCT 'module' size=1280 vlen=70
>
> and same one from pnet.ko:
>
>         [89323] STRUCT 'module' size=1280 vlen=70
>
> they seem to completely match, all the fields
> and yet it still appears in the kmod's BTF
>

Ok, now struct module is identical down to the types referenced from
the fields, which means it should have been deduplicated completely.
This will require a more time-consuming debugging, though, so I'll put
it on my TODO list for now. If you get to this earlier, see where the
equivalence check fails in btf_dedup (sprinkle debug outputs around to
see what's going on).

> thanks,
> jirka
>
> >
> >
> > > jirka
> > >
> > > >
> > > > > I found code in dedup that seems to handle such situation for arrays,
> > > > > and added 'some' fix for structs. With that change I can no longer
> > > > > see vmlinux's structs in kernel module BTF data, but I have no idea
> > > > > if that breaks anything else.
> > > > >
> > > > > thoughts? thanks,
> > > > > jirka
> > > > >
> > > > >
> > > > > ---
> > > > > Jiri Olsa (2):
> > > > >       kbuild: Unify options for BTF generation for vmlinux and modules
> > > > >       bpf: Add support to detect and dedup instances of same structs
> > > > >
> > > > >  Makefile                  |  3 +++
> > > > >  scripts/Makefile.modfinal |  2 +-
> > > > >  scripts/link-vmlinux.sh   | 11 +----------
> > > > >  scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
> > > > >  tools/lib/bpf/btf.c       | 12 ++++++++++--
> > > > >  5 files changed, 35 insertions(+), 13 deletions(-)
> > > > >  create mode 100755 scripts/pahole-flags.sh
> > > > >
> > > >
> > >
> >
>
