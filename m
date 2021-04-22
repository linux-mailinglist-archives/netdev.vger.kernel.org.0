Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87221368732
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhDVT2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 15:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238883AbhDVT2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 15:28:12 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D367C06174A;
        Thu, 22 Apr 2021 12:27:37 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b17so38813393ilh.6;
        Thu, 22 Apr 2021 12:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xuDmrh1OvwduDwd6M9Cvq55SMCDRA0FBKSw2JtFu6io=;
        b=MamraHC0/hJ2POQWz34u9153HAfSzlOW+9CqkxMhLRThGskCq8G9+eH2acS9LjGrrH
         8cV0oyqUJDF39sneKgj0XZsjFkCRLvlwnCBepRhiSd6rYSQM/YajWTezwmgNKbf32/KB
         7oWcLkrKroHv5b54qz0kBTuiwtW5NwDYvoD11OmUk0o5BGP93G8WIi8Mvhn6Iuv+KR5I
         wEpuiLVIfv1uaPCwR0hz9Th9xxZJmBtj2dSShbdnjPBGP+nWSOAtGLKAP//Ah0pXvEUd
         LvcFZblW6s+xdz5auFXYOAZoFuq/mvgMH6fe2zV75lUxmCXl2DplcrFi0WSBKEYgFY7A
         g+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xuDmrh1OvwduDwd6M9Cvq55SMCDRA0FBKSw2JtFu6io=;
        b=IQn5DgscSryQr20KJXMMOizpCSYzW+1F0r6edkvVLgN/85DsqwpSukG7ZQeszXlyoC
         82+GR/oo9nLq1Zqzj/BTOCuoiHZkxbV9ity8qoypw08cCKK8kO+lEcpgmf9tOjb6JGkh
         0d2zH9WWhVhv6VNnGrXOyUEUOJweoeq0hpRs94PT5bfml6WYgExGbOSXgPWxJ5Y4HgiO
         TurBAw/SZR9+fHAgiX1jEYAsDYoCLbwX9YrXSIfrWomTlm2NwJgUCqstb04MznnW3EBn
         tAR7HVeP9cIrWWYmGargTZMSIg1Z90WcJw12ncFOiQKsBG/YKut+1YuWzcEPO0Uu1vF9
         Ih5Q==
X-Gm-Message-State: AOAM53338Mh6n1ZaS8bNTEfFnK+631vNoN2u9YmZ85VoNbR0Pdi9vUSA
        03m5AM0QWwEH3QrWokWmqBGiOCo961Iv/GVP8x+Wm51XoFaEO9to
X-Google-Smtp-Source: ABdhPJwCPU4UOXTPQQ4zWTNeQIegw9N/LuZmxH2TuabMxRBoRF/CNZuu2LfeW/5JjtDGIvetijJgVcP3vExoHO3Jb/0=
X-Received: by 2002:a05:6e02:4aa:: with SMTP id e10mr39524ils.188.1619119656556;
 Thu, 22 Apr 2021 12:27:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210415174619.51229-1-pctammela@mojatatu.com>
 <20210415174619.51229-3-pctammela@mojatatu.com> <CAADnVQ+XtLj2vUmfazYu8-k3+bd0bJFJUTZWGRBALV1xy-vqFg@mail.gmail.com>
 <e9c5baa2-62e1-86eb-6cde-a6ceec8f05dc@iogearbox.net> <CAEf4Bzau9AZrJ0zKAsVptwLtJsSY_n7DbcKD9GmZ-cyv2RNpYg@mail.gmail.com>
In-Reply-To: <CAEf4Bzau9AZrJ0zKAsVptwLtJsSY_n7DbcKD9GmZ-cyv2RNpYg@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Thu, 22 Apr 2021 16:27:25 -0300
Message-ID: <CAKY_9u2uUm5Q+sLnizbpjcaoYBC_ih_qgvq-dDbcVQ-Fc+CfjA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: selftests: remove percpu macros from bpf_util.h
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em ter., 20 de abr. de 2021 =C3=A0s 13:42, Andrii Nakryiko
<andrii.nakryiko@gmail.com> escreveu:
>
> On Tue, Apr 20, 2021 at 8:58 AM Daniel Borkmann <daniel@iogearbox.net> wr=
ote:
> >
> > On 4/20/21 3:17 AM, Alexei Starovoitov wrote:
> > > On Thu, Apr 15, 2021 at 10:47 AM Pedro Tammela <pctammela@gmail.com> =
wrote:
> > >>
> > >> Andrii suggested to remove this abstraction layer and have the percp=
u
> > >> handling more explicit[1].
> > >>
> > >> This patch also updates the tests that relied on the macros.
> > >>
> > >> [1] https://lore.kernel.org/bpf/CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopy=
sBNrdd9foHTfLZw@mail.gmail.com/
> > >>
> > >> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > >> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > >> ---
> > >>   tools/testing/selftests/bpf/bpf_util.h        |  7 --
> > >>   .../bpf/map_tests/htab_map_batch_ops.c        | 87 +++++++++------=
----
> > >>   .../selftests/bpf/prog_tests/map_init.c       |  9 +-
> > >>   tools/testing/selftests/bpf/test_maps.c       | 84 +++++++++++----=
---
> > >>   4 files changed, 96 insertions(+), 91 deletions(-)
> > >>
> > >> diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/=
selftests/bpf/bpf_util.h
> > >> index a3352a64c067..105db3120ab4 100644
> > >> --- a/tools/testing/selftests/bpf/bpf_util.h
> > >> +++ b/tools/testing/selftests/bpf/bpf_util.h
> > >> @@ -20,13 +20,6 @@ static inline unsigned int bpf_num_possible_cpus(=
void)
> > >>          return possible_cpus;
> > >>   }
> > >>
> > >> -#define __bpf_percpu_val_align __attribute__((__aligned__(8)))
> > >> -
> > >> -#define BPF_DECLARE_PERCPU(type, name)                         \
> > >> -       struct { type v; /* padding */ } __bpf_percpu_val_align \
> > >> -               name[bpf_num_possible_cpus()]
> > >> -#define bpf_percpu(name, cpu) name[(cpu)].v
> > >> -
> > >
> > > Hmm. I wonder what Daniel has to say about it, since he
> > > introduced it in commit f3515b5d0b71 ("bpf: provide a generic macro
> > > for percpu values for selftests")
> > > to address a class of bugs.
> >
> > I would probably even move those into libbpf instead. ;-) The problem i=
s that this can
> > be missed easily and innocent changes would lead to corruption of the a=
pplications
> > memory if there's a map lookup. Having this at least in selftest code o=
r even in libbpf
> > would document code-wise that care needs to be taken on per cpu maps. E=
ven if we'd put
> > a note under Documentation/bpf/ or such, this might get missed easily a=
nd finding such
> > bugs is like looking for a needle in a haystack.. so I don't think this=
 should be removed.
> >
>
> See [0] for previous discussion. I don't mind leaving bpf_percpu() in
> selftests. I'm not sure I ever suggested removing it from selftests,
> but I don't think it's a good idea to add it to libbpf. I think it's
> better to have an extra paragraph in bpf_lookup_map_elem() in
> uapi/linux/bpf.h mentioning how per-CPU values should be read/updated.
> I think we should just recommend to use u64 for primitive values (or
> otherwise users can embed their int in custom aligned(8) struct, if
> they insist on <u64) and __attribute__((aligned(8))) for structs.
>
>   [0] https://lore.kernel.org/bpf/CAEf4BzaLKm_fy4oO4Rdp76q2KoC6yC1WcJLueh=
oZUu9JobG-Cw@mail.gmail.com/
>
>
> > Thanks,
> > Daniel

OK, since this is not the main topic of this series I will revert this
patch in v5.
