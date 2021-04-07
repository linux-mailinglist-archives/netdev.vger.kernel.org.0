Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A94453574F7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345638AbhDGTbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 15:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236379AbhDGTa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 15:30:58 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B44BC06175F;
        Wed,  7 Apr 2021 12:30:47 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id o15so13097067ilf.11;
        Wed, 07 Apr 2021 12:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mZV5oPtIqis6sHUZCb+ofyTYBJYlys/yTPjbRl90xlc=;
        b=IOKTDh4+NPI4TT/SR4JDEAKOt6hcHk2hyY8PdGqaJoQcbPUHQvN7BJQ81OEKkeruXT
         3y1/z7pyTF50/aWSHJC74G1vwGZ1NJm7mHgEg/kzse4jMWXCUmsjtK7KwUB2IsIG1cP6
         2mWtcYIsK+VU9KvRYEBNILmvAImEh9MKgNVoufRoSJa/nsSm2L+eXdSCDQqhzRTe08yL
         8UNH5AiJzeQ7GqZpbmZw7ixUx/1Ma9cltSzuvak8BHU5GYPN+XXOJC+TXkXUZFOn3QGT
         hzHz7qEEHofZLdVur7eslE6sMevgptUam6jH83ThBEYOn/YaIPnrBy4TsUEqynrpS17T
         ivLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mZV5oPtIqis6sHUZCb+ofyTYBJYlys/yTPjbRl90xlc=;
        b=KGIR8sYZISZxmi3e0wNcwddP2YCeXs2kst1OTNmEkuIrgdFb3fRljvis+Poxg/YyOu
         5DXKCncgDsl6ZQHvCCo/NgdbO4hVdJaMXtU5OykBOY1yVCHBC3cQqphFaO3WZxT2gmh2
         R8VWhHO+E7KGkE7KXH5N+Zh8Mo+yjDZn8fk1ay9qWcXxH0pgyaKja//TCAzJM+28vLf1
         LKiF8GnovXNwM4TR4YX+y5WnEAHNelKRhuD7BVfHHsAcxkTocrQArZpuKv7kqusuBYiz
         P/4re+YFKNuByXr7U7w6t1b/m6AUatxbYDkgg95DZXsohkEKpI/aRoiiiAc3o7p4ZaTN
         s+1w==
X-Gm-Message-State: AOAM530yyLAaZ0rqwqtkZU9rBzGtxZFzMGgDMmBEkA0PRiHT00vj1XiZ
        khBzoVik93Qwrw2gbH52wzokY13wid35TDf2ln6QPpjYO0A=
X-Google-Smtp-Source: ABdhPJyZkGCqajzLmOnVtAnY7el+W9khXSigGblYto1zBClyq437Nfym/5/pYVLxPzds4ZiQSdS3Vbh4qzEv0kO5+8o=
X-Received: by 2002:a05:6e02:1a24:: with SMTP id g4mr3765765ile.56.1617823846602;
 Wed, 07 Apr 2021 12:30:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210406185400.377293-1-pctammela@mojatatu.com>
 <20210406185400.377293-3-pctammela@mojatatu.com> <CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com>
In-Reply-To: <CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Wed, 7 Apr 2021 16:30:35 -0300
Message-ID: <CAKY_9u3Y9Ay6yBwt27MaCCm=5aVmH92OkFe2aaoD6YWkCkYjBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: selftests: refactor
 'BPF_PERCPU_TYPE()' and 'bpf_percpu()' macros
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        David Verbeiren <david.verbeiren@tessares.net>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em qua., 7 de abr. de 2021 =C3=A0s 15:31, Andrii Nakryiko
<andrii.nakryiko@gmail.com> escreveu:
>
> On Tue, Apr 6, 2021 at 11:55 AM Pedro Tammela <pctammela@gmail.com> wrote=
:
> >
> > This macro was refactored out of the bpf selftests.
> >
> > Since percpu values are rounded up to '8' in the kernel, a careless
> > user in userspace might encounter unexpected values when parsing the
> > output of the batched operations.
>
> I wonder if a user has to be more careful, though? This
> BPF_PERCPU_TYPE, __bpf_percpu_align and bpf_percpu macros seem to
> create just another opaque layer. It actually seems detrimental to me.
>
> I'd rather emphasize in the documentation (e.g., in
> bpf_map_lookup_elem) that all per-cpu maps are aligning values at 8
> bytes, so user has to make sure that array of values provided to
> bpf_map_lookup_elem() has each element size rounded up to 8.

From my own experience, the documentation has been a very unreliable
source, to the point that I usually jump to the code first rather than
to the documentation nowadays[1].
Tests, samples and projects have always been my source of truth and we
are already lacking a bit on those as well. For instance, the samples
directory contains programs that are very outdated (I didn't check if
they are still functional).
I think macros like these will be present in most of the project
dealing with batched operations and as a daily user of libbpf I don't
see how this could not be offered by libbpf as a standardized way to
declare percpu types.

[1] So batched operations were introduced a little bit over a 1 year
ago and yet the only reference I had for it was the selftests. The
documentation is on my TODO list, but that's just because I have to
deal with it daily.

>
> In practice, I'd recommend users to always use __u64/__s64 when having
> primitive integers in a map (they are not saving anything by using
> int, it just creates an illusion of savings). Well, maybe on 32-bit
> arches they would save a bit of CPU, but not on typical 64-bit
> architectures. As for using structs as values, always mark them as
> __attribute__((aligned(8))).
>
> Basically, instead of obscuring the real use some more, let's clarify
> and maybe even provide some examples in documentation?

Why not do both?

Provide a standardized way to declare a percpu value with examples and
a good documentation with examples.
Let the user decide what is best for his use case.

>
> >
> > Now that both array and hash maps have support for batched ops in the
> > percpu variant, let's provide a convenient macro to declare percpu map
> > value types.
> >
> > Updates the tests to a "reference" usage of the new macro.
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
> >  tools/lib/bpf/bpf.h                           | 10 ++++
> >  tools/testing/selftests/bpf/bpf_util.h        |  7 ---
> >  .../bpf/map_tests/htab_map_batch_ops.c        | 48 ++++++++++---------
> >  .../selftests/bpf/prog_tests/map_init.c       |  5 +-
> >  tools/testing/selftests/bpf/test_maps.c       | 16 ++++---
> >  5 files changed, 46 insertions(+), 40 deletions(-)
> >
>
> [...]
>
> > @@ -400,11 +402,11 @@ static void test_arraymap(unsigned int task, void=
 *data)
> >  static void test_arraymap_percpu(unsigned int task, void *data)
> >  {
> >         unsigned int nr_cpus =3D bpf_num_possible_cpus();
> > -       BPF_DECLARE_PERCPU(long, values);
> > +       pcpu_map_value_t values[nr_cpus];
> >         int key, next_key, fd, i;
> >
> >         fd =3D bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
> > -                           sizeof(bpf_percpu(values, 0)), 2, 0);
> > +                           sizeof(long), 2, 0);
> >         if (fd < 0) {
> >                 printf("Failed to create arraymap '%s'!\n", strerror(er=
rno));
> >                 exit(1);
> > @@ -459,7 +461,7 @@ static void test_arraymap_percpu(unsigned int task,=
 void *data)
> >  static void test_arraymap_percpu_many_keys(void)
> >  {
> >         unsigned int nr_cpus =3D bpf_num_possible_cpus();
>
> This just sets a bad example for anyone using selftests as an
> aspiration for their own code. bpf_num_possible_cpus() does exit(1)
> internally if libbpf_num_possible_cpus() returns error. No one should
> write real production code like that. So maybe let's provide a better
> example instead with error handling and malloc (or perhaps alloca)?

OK. Makes sense.

>
> > -       BPF_DECLARE_PERCPU(long, values);
> > +       pcpu_map_value_t values[nr_cpus];
> >         /* nr_keys is not too large otherwise the test stresses percpu
> >          * allocator more than anything else
> >          */
> > @@ -467,7 +469,7 @@ static void test_arraymap_percpu_many_keys(void)
> >         int key, fd, i;
> >
> >         fd =3D bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
> > -                           sizeof(bpf_percpu(values, 0)), nr_keys, 0);
> > +                           sizeof(long), nr_keys, 0);
> >         if (fd < 0) {
> >                 printf("Failed to create per-cpu arraymap '%s'!\n",
> >                        strerror(errno));
> > --
> > 2.25.1
> >
