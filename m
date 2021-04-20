Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169D8365D95
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhDTQnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbhDTQnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:43:05 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AB8C06174A;
        Tue, 20 Apr 2021 09:42:31 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id y2so41666371ybq.13;
        Tue, 20 Apr 2021 09:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vk8O28byMzwLniuOfmQhOjtQMDxzriN6bEOa49w7EEA=;
        b=OPHVLAOaTJdJZJecmtuxGoIqWZhbdgFzemnyLpxQ39K+iZ/8IaK5tJrnlAxiT7cIbQ
         YKhZMXqV3SBC3BtUvxGJnGe5/mkRUj8AO9Uojwf6hF3Br1/LZGZpIxW1nEEBNMrbiYrc
         gxky7wqjnI/VxKHAMb62JJQ1a6De4KUGh9+g5hQ+QLd+LM5LA/Kd13d0HtsNcgnkEmAA
         VqnSdbuAqefnEhFrj283ZgcgyE3+f6DZADHdJsiBy1IPV5Izcs+LC117zaTR2a+lldP/
         etaaK8DbtSyTsfl34FPg1sd3jEcrBF6lx4jRPLGt43h5BHFAL5m4SLsqtG1YqSHfkPHu
         eqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vk8O28byMzwLniuOfmQhOjtQMDxzriN6bEOa49w7EEA=;
        b=XcgLFMh94CxepKW0T9s222RreKkCLHxRNLR7pUb0jUP5kP42LtzsoRaPwbH7MKP9xw
         CZfuqVrSaEP6MOxSLBGJmTS6EwSof5JYEDrAryZR6Lw5hPtkr+NSAAXZhZVnIMdL0CZY
         OyfqsV36FB3nJQaxaxoQKnM83zxme3/ZRpSGrgLYRUJj7bbM1VcPwnXijkWOx7rWk3fk
         ojrwvDEosXApRtxthAj4N80xykBrmBJN2fluZPd3gHkLRe4uPXd1UCpCiLdceQgknefH
         UMqO7WLJja2LgecgtdegJqUieke/vAwsInUKExAFJAPFfoohNCIDNGiOv3J++2/KQamX
         0cVQ==
X-Gm-Message-State: AOAM532uZWH4pajU1yS1/goXvAykifQ1KlCl9tQ3amsMOUadbZhUUotJ
        DruBzozOZiP+3mhSh/0SBPkQpESxsVATHKYGaV3tlE01nwM=
X-Google-Smtp-Source: ABdhPJyFCp9ccTTLAsnpWI0mmUODTRodODBDhlxpJzawjqSg5cXSSCG2NVBqWBqIWj1Ccwxaf+7StzV3x9Ll3Wbz0eY=
X-Received: by 2002:a05:6902:1144:: with SMTP id p4mr21735523ybu.510.1618936950820;
 Tue, 20 Apr 2021 09:42:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210415174619.51229-1-pctammela@mojatatu.com>
 <20210415174619.51229-3-pctammela@mojatatu.com> <CAADnVQ+XtLj2vUmfazYu8-k3+bd0bJFJUTZWGRBALV1xy-vqFg@mail.gmail.com>
 <e9c5baa2-62e1-86eb-6cde-a6ceec8f05dc@iogearbox.net>
In-Reply-To: <e9c5baa2-62e1-86eb-6cde-a6ceec8f05dc@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Apr 2021 09:42:20 -0700
Message-ID: <CAEf4Bzau9AZrJ0zKAsVptwLtJsSY_n7DbcKD9GmZ-cyv2RNpYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: selftests: remove percpu macros from bpf_util.h
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 8:58 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 4/20/21 3:17 AM, Alexei Starovoitov wrote:
> > On Thu, Apr 15, 2021 at 10:47 AM Pedro Tammela <pctammela@gmail.com> wrote:
> >>
> >> Andrii suggested to remove this abstraction layer and have the percpu
> >> handling more explicit[1].
> >>
> >> This patch also updates the tests that relied on the macros.
> >>
> >> [1] https://lore.kernel.org/bpf/CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com/
> >>
> >> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> >> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> >> ---
> >>   tools/testing/selftests/bpf/bpf_util.h        |  7 --
> >>   .../bpf/map_tests/htab_map_batch_ops.c        | 87 +++++++++----------
> >>   .../selftests/bpf/prog_tests/map_init.c       |  9 +-
> >>   tools/testing/selftests/bpf/test_maps.c       | 84 +++++++++++-------
> >>   4 files changed, 96 insertions(+), 91 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
> >> index a3352a64c067..105db3120ab4 100644
> >> --- a/tools/testing/selftests/bpf/bpf_util.h
> >> +++ b/tools/testing/selftests/bpf/bpf_util.h
> >> @@ -20,13 +20,6 @@ static inline unsigned int bpf_num_possible_cpus(void)
> >>          return possible_cpus;
> >>   }
> >>
> >> -#define __bpf_percpu_val_align __attribute__((__aligned__(8)))
> >> -
> >> -#define BPF_DECLARE_PERCPU(type, name)                         \
> >> -       struct { type v; /* padding */ } __bpf_percpu_val_align \
> >> -               name[bpf_num_possible_cpus()]
> >> -#define bpf_percpu(name, cpu) name[(cpu)].v
> >> -
> >
> > Hmm. I wonder what Daniel has to say about it, since he
> > introduced it in commit f3515b5d0b71 ("bpf: provide a generic macro
> > for percpu values for selftests")
> > to address a class of bugs.
>
> I would probably even move those into libbpf instead. ;-) The problem is that this can
> be missed easily and innocent changes would lead to corruption of the applications
> memory if there's a map lookup. Having this at least in selftest code or even in libbpf
> would document code-wise that care needs to be taken on per cpu maps. Even if we'd put
> a note under Documentation/bpf/ or such, this might get missed easily and finding such
> bugs is like looking for a needle in a haystack.. so I don't think this should be removed.
>

See [0] for previous discussion. I don't mind leaving bpf_percpu() in
selftests. I'm not sure I ever suggested removing it from selftests,
but I don't think it's a good idea to add it to libbpf. I think it's
better to have an extra paragraph in bpf_lookup_map_elem() in
uapi/linux/bpf.h mentioning how per-CPU values should be read/updated.
I think we should just recommend to use u64 for primitive values (or
otherwise users can embed their int in custom aligned(8) struct, if
they insist on <u64) and __attribute__((aligned(8))) for structs.

  [0] https://lore.kernel.org/bpf/CAEf4BzaLKm_fy4oO4Rdp76q2KoC6yC1WcJLuehoZUu9JobG-Cw@mail.gmail.com/


> Thanks,
> Daniel
