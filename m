Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C174F5379
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2359881AbiDFEYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1849917AbiDFCpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 22:45:07 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24909291BB2;
        Tue,  5 Apr 2022 16:47:24 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id r2so1071995iod.9;
        Tue, 05 Apr 2022 16:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c+XYrd0Oyx5bZokyYgKdQAHq6tFoBY4IZr2oyMITbE8=;
        b=XHy9gts7ur+Kuy4KpYalW0V+9qqmnaSmfkL+H0hvD5mZrNCwFSv3wDlp5F+BLGvrfy
         xmF2TRe+9UWg6WXAWB7ZU5g5TlJAtKFJ7l9mlCGANs/pGwqKlduEvf6sNl2G3MRXdJFl
         e1c6gEndG9gJQM6tSSvKF3BOzqWUSfbsua7DSJDNxNpY8Oph2EIaYmiu1Utbn1UYyZCM
         ZXiL8Y76UXUI6ezDHhJWzd80OwZJaTJRaoOnI2QaKQrh5jHG9XUTCZPDNNBjH7eimIQ4
         +v0zdAFoIl4+7im1VIY7IyUZyeimH9dLY3Uo+xi8IWeWkjNa3ybmZI1/Y7nrONfPqqld
         OmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c+XYrd0Oyx5bZokyYgKdQAHq6tFoBY4IZr2oyMITbE8=;
        b=htRv9bYYn7In7j/AChHoufLS24OE8MLEOQ4o96PoSwnzQsR/0SxwJDUcpXEKQBHWfA
         5YAEbpFXxg+s9c8yea1yrYPh2Nc+u56yvz0ScbWlK0AwKAGGwUVuE1hfXeH1JBcsxRby
         /NTVRN/f/Iy1ccegEcz5kHhMumcOxlCw652lqrAdsV/LcQLc0MITyNF9GAU9PzTxbHXg
         jEwjhcpjvcFr6bzOUpGXi/0/GzDLiJ/FQ9KJuiiHkFh6UOT3fOc8rjWy3LQA2VY0goHi
         Pt+3ayFIzTOxadp3R+BM94AKZzdEdsTyPhbEITK6f+lmFO24hY9PJ9x94o/tWaKdM5rn
         MDgA==
X-Gm-Message-State: AOAM530iPll2XM0s2TPRa19UOVCVcgEBdxi8JNmtGHBiMtuLSdwgwakv
        7nx/hk0QOCY/+IhrugOV8alDBS3cOlVOx5LxF0g=
X-Google-Smtp-Source: ABdhPJxMFIZrH/Vkj5PwnSRm6Lo8J2BA5ONUmBR4cQxKL0V8Cu/CrwzAKcERZ/PqaPaAwcz2NcGa+f4MHUMQ5kS1LLw=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr2796386ioi.154.1649202443390; Tue, 05
 Apr 2022 16:47:23 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzZdV60ZeNt1YfS8qoB69pggSe+=gjnDZ1tZy00L4Quazw@mail.gmail.com> <alpine.LRH.2.23.451.2204051116110.9651@MyRouter>
In-Reply-To: <alpine.LRH.2.23.451.2204051116110.9651@MyRouter>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Apr 2022 16:47:12 -0700
Message-ID: <CAEf4Bzam5qnm16fc2g1--GLokN3KpdJpoDrTK27ZcbVWYCcYYg@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/5] libbpf: name-based u[ret]probe attach
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Tue, Apr 5, 2022 at 3:28 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Mon, 4 Apr 2022, Andrii Nakryiko wrote:
>
> > On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > This patch series focuses on supporting name-based attach - similar
> > > to that supported for kprobes - for uprobe BPF programs.
> > >
> > > Currently attach for such probes is done by determining the offset
> > > manually, so the aim is to try and mimic the simplicity of kprobe
> > > attach, making use of uprobe opts to specify a name string.
> > > Patch 1 supports expansion of the binary_path argument used for
> > > bpf_program__attach_uprobe_opts(), allowing it to determine paths
> > > for programs and shared objects automatically, allowing for
> > > specification of "libc.so.6" rather than the full path
> > > "/usr/lib64/libc.so.6".
> > >
> > > Patch 2 adds the "func_name" option to allow uprobe attach by
> > > name; the mechanics are described there.
> > >
> > > Having name-based support allows us to support auto-attach for
> > > uprobes; patch 3 adds auto-attach support while attempting
> > > to handle backwards-compatibility issues that arise.  The format
> > > supported is
> > >
> > > u[ret]probe/binary_path:[raw_offset|function[+offset]]
> > >
> > > For example, to attach to libc malloc:
> > >
> > > SEC("uprobe//usr/lib64/libc.so.6:malloc")
> > >
> > > ..or, making use of the path computation mechanisms introduced in patch 1
> > >
> > > SEC("uprobe/libc.so.6:malloc")
> > >
> > > Finally patch 4 add tests to the attach_probe selftests covering
> > > attach by name, with patch 5 covering skeleton auto-attach.
> > >
> > > Changes since v4 [1]:
> > > - replaced strtok_r() usage with copying segments from static char *; avoids
> > >   unneeded string allocation (Andrii, patch 1)
> > > - switched to using access() instead of stat() when checking path-resolved
> > >   binary (Andrii, patch 1)
> > > - removed computation of .plt offset for instrumenting shared library calls
> > >   within binaries.  Firstly it proved too brittle, and secondly it was somewhat
> > >   unintuitive in that this form of instrumentation did not support function+offset
> > >   as the "local function in binary" and "shared library function in shared library"
> > >   cases did.  We can still instrument library calls, just need to do it in the
> > >   library .so (patch 2)
> >
> > ah, that's too bad, it seemed like a nice and clever idea. What was
> > brittle? Curious to learn for the future.
> >
>
> On Ubuntu, Daniel reported selftest failures which corresponded to the
> cases where we attached to a library function in a non-library - i.e. used
> the .plt computations.  I reproduced this failure myself, and it seemed
> that although we were correctly computing the size of the .plt initial
> code - 16 bytes - and each .plt entry - again 16 bytes - finding the
> .rela.plt entry and using its index as the basis for figuring out which
> .plt entry to instrument wasn't working.
>
> Specifically, the .rela.plt entry for "free" was 146, but the actual .plt
> location of free was the 372 entry in the .plt table.  I'm not clear on
> why, but the the correspondence betweeen .rela.plt and .plt order
> isn't present on Ubuntu.

Ok, curious. I'm not a big expert on PLT and stuff, but would be
curious to look at such an ELF file and see if we are missing
something that can be recovered from PLT relocations maybe? If you
happen to have a small ELF with repro case, please share.

>
> > The fact that function+offset isn't supported int this "mode"
> seems
> > totally fine to me, we can provide a nice descriptive error in this
> > case anyways.
> >
>
> I'll try and figure out exactly what's going on above; would be nice if we
> can still add this in the future.

Yep, definitely, provided we are sure it will keep working reliably :)

>
> > Anyways, all the added functionality makes sense and we can further
> > improve on it if necessary and possible. I've found a few small issues
> > with your patches and fixed some of them while applying, please do a
> > follow up for the rest.
>
> Yep, will do, thanks for the fix-ups! Ilya has fixed a few of the issues
> too, so I'll have some follow-ups for the rest shortly. I'll take a look
> at adding aarch64 to libbpf CI too, that would be great.

Awesome, aarch64 seems like a logical addition, thanks!

>
> > Thanks, great work and great addition to
> > libbpf!
> >
>
> Thanks again!
