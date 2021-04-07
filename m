Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF73575B4
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356031AbhDGUPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356000AbhDGUPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:15:19 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D356FC061762;
        Wed,  7 Apr 2021 13:15:07 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z136so12084799iof.10;
        Wed, 07 Apr 2021 13:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LRuE+9dFL4WFvVQEJqBfY52H5/Qu+M9AiexYVTW5Uog=;
        b=RlJnabMztN4uV7HlCJQowJsZSfjISIu+vrbDnXIpKELUB3alrOF6KKNtT9oAtt+fLH
         jDe//vpbXeeBK0N8GWCsnN+6k6A11+xNTkUmkhH4XW45t0pVEl4QN+nAMROGCMJOfZ6X
         N5O6NRHJAdAeOH9A6lyMlLYMprOFYVhgH79gAFuYGxzbheT/0vODks3KlwDxoIQAi5wl
         WLv8EeqgWa5be/vGgA9keWmF6/MuP9pSxzcD5kU4TTNmlcv59bSaRl0RlzoPOFS1dSLl
         fwy7y4APZAnwNIfkC0gYerAkifH4SjuPUNBliEJcOlGoCL+O0jx4l6TlbX+NgpnQgEDI
         NULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LRuE+9dFL4WFvVQEJqBfY52H5/Qu+M9AiexYVTW5Uog=;
        b=Y4fB/9OWEmPwpnVcbZvvi6P2IL+ogVO9UaghL/TYh+fKkRS/zOv5GaFmv3aVA9JnYc
         qqzByqzGRpl2vRvdH323jq0qJrJyiKcQ5njE7r8hmyxBISf1prYjuHl9HgSYKLUMp/hx
         3rx5cGR+4CrM8Qo+rB2acrXan1gTse8C0TJFdaYSpAJZQ9yV5enioIT0FA2TqOBsZj27
         y/h15s2Pyu/AQAemMvqdaTBbxi3KirjWwXY0+obXOCYh+Rn6v5eJX+Lw7lNyqTkatXv7
         73qKuW/56vS1+fBjuGHQfQoDhAbhs0b06a6xU5F9/L54rOfazFy+NbqkWrdqVI/gXdtX
         EhNw==
X-Gm-Message-State: AOAM532x9vvhiBCp8laP9cKtAIzQwb8TQm49VXBRQnsubl2fjO3ec/+G
        Y1LIgvtCkscy0kgXAYpZGuYKsbfKMauwg4toRwU=
X-Google-Smtp-Source: ABdhPJzLtaCO8ANq2TMWliw2a/tpqKzmp02xtyvT6ZdysEktuimxrfK01zQ6evptfx1iACKdUjAxdKNI2hDSYA9UCXw=
X-Received: by 2002:a6b:e509:: with SMTP id y9mr3976807ioc.191.1617826507281;
 Wed, 07 Apr 2021 13:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210406185400.377293-1-pctammela@mojatatu.com>
 <20210406185400.377293-3-pctammela@mojatatu.com> <CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com>
 <CAKY_9u3Y9Ay6yBwt27MaCCm=5aVmH92OkFe2aaoD6YWkCkYjBw@mail.gmail.com> <CAEf4BzaLKm_fy4oO4Rdp76q2KoC6yC1WcJLuehoZUu9JobG-Cw@mail.gmail.com>
In-Reply-To: <CAEf4BzaLKm_fy4oO4Rdp76q2KoC6yC1WcJLuehoZUu9JobG-Cw@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Wed, 7 Apr 2021 17:14:56 -0300
Message-ID: <CAKY_9u1iyyuJaYz3csoHnW_apvB=hWBosvQm+jxm6Gc4yFM9kA@mail.gmail.com>
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

Em qua., 7 de abr. de 2021 =C3=A0s 16:51, Andrii Nakryiko
<andrii.nakryiko@gmail.com> escreveu:
>
> On Wed, Apr 7, 2021 at 12:30 PM Pedro Tammela <pctammela@gmail.com> wrote=
:
> >
> > Em qua., 7 de abr. de 2021 =C3=A0s 15:31, Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> escreveu:
> > >
> > > On Tue, Apr 6, 2021 at 11:55 AM Pedro Tammela <pctammela@gmail.com> w=
rote:
> > > >
> > > > This macro was refactored out of the bpf selftests.
> > > >
> > > > Since percpu values are rounded up to '8' in the kernel, a careless
> > > > user in userspace might encounter unexpected values when parsing th=
e
> > > > output of the batched operations.
> > >
> > > I wonder if a user has to be more careful, though? This
> > > BPF_PERCPU_TYPE, __bpf_percpu_align and bpf_percpu macros seem to
> > > create just another opaque layer. It actually seems detrimental to me=
.
> > >
> > > I'd rather emphasize in the documentation (e.g., in
> > > bpf_map_lookup_elem) that all per-cpu maps are aligning values at 8
> > > bytes, so user has to make sure that array of values provided to
> > > bpf_map_lookup_elem() has each element size rounded up to 8.
> >
> > From my own experience, the documentation has been a very unreliable
> > source, to the point that I usually jump to the code first rather than
> > to the documentation nowadays[1].
>
> I totally agree, which is why I think improving docs is necessary.
> Unfortunately docs are usually lagging behind, because generally
> people hate writing documentation and it's just a fact of life.
>
> > Tests, samples and projects have always been my source of truth and we
> > are already lacking a bit on those as well. For instance, the samples
> > directory contains programs that are very outdated (I didn't check if
> > they are still functional).
>
> Yeah, samples/bpf is bitrotting. selftests/bpf, though, are maintained
> and run regularly and vigorously, so making sure they set a good and
> realistic example is a good.
>
>
> > I think macros like these will be present in most of the project
> > dealing with batched operations and as a daily user of libbpf I don't
> > see how this could not be offered by libbpf as a standardized way to
> > declare percpu types.
>
> If I were using per-CPU maps a lot, I'd make sure I use u64 and
> aligned(8) types and bypass all the macro ugliness, because there is
> no need in it and it just hurts readability. So I don't want libbpf to
> incentivize bad choices here by providing seemingly convenient macros.
> Users have to be aware that values are 8-byte aligned/extended. That's
> not a big secret and not a very obscure thing to learn anyways.
>
> >
> > [1] So batched operations were introduced a little bit over a 1 year
> > ago and yet the only reference I had for it was the selftests. The
> > documentation is on my TODO list, but that's just because I have to
> > deal with it daily.
> >
>
> Yeah, please do contribute them!
>
> > >
> > > In practice, I'd recommend users to always use __u64/__s64 when havin=
g
> > > primitive integers in a map (they are not saving anything by using
> > > int, it just creates an illusion of savings). Well, maybe on 32-bit
> > > arches they would save a bit of CPU, but not on typical 64-bit
> > > architectures. As for using structs as values, always mark them as
> > > __attribute__((aligned(8))).
> > >
> > > Basically, instead of obscuring the real use some more, let's clarify
> > > and maybe even provide some examples in documentation?
> >
> > Why not do both?
> >
> > Provide a standardized way to declare a percpu value with examples and
> > a good documentation with examples.
> > Let the user decide what is best for his use case.
>
> What is a standardized way? A custom macro with struct { T v; }
> inside? That's just one way of doing this, and it requires another
> macro to just access the value (because no one wants to write
> my_values[cpu].v, right?). I'd say the standardized way of reading
> values should look like `my_values[cpu]`, that's it. For that you use
> 64-bit integers or 8-byte aligned structs. And don't mess with macros
> for that at all.
>
> So if a user insists on using int/short/char as value, they can do
> their own struct { char v} __aligned(8) trick. But I'd advise such
> users to reconsider and use u64. If they are using structs for values,
> always mark __aligned(8) and forget about this in the rest of your
> code.
>
> As for allocating memory for array of per-cpu values, there is also no
> single standardized way we can come up with. It could be malloc() on
> the heap. Or alloca() on the stack. Or it could be pre-allocated one
> for up to maximum supported CPUs. Or... whatever makes sense.
>
> So I think the best way to handle all that is to clearly explain how
> reading per-CPU values from per-CPU maps works in BPF and what are the
> memory layout expectations.

I understand your points much better now. Thanks.

I will do what you suggested on v2.

>
> >
> > >
> > > >
> > > > Now that both array and hash maps have support for batched ops in t=
he
> > > > percpu variant, let's provide a convenient macro to declare percpu =
map
> > > > value types.
> > > >
> > > > Updates the tests to a "reference" usage of the new macro.
> > > >
> > > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > > ---
> > > >  tools/lib/bpf/bpf.h                           | 10 ++++
> > > >  tools/testing/selftests/bpf/bpf_util.h        |  7 ---
> > > >  .../bpf/map_tests/htab_map_batch_ops.c        | 48 ++++++++++-----=
----
> > > >  .../selftests/bpf/prog_tests/map_init.c       |  5 +-
> > > >  tools/testing/selftests/bpf/test_maps.c       | 16 ++++---
> > > >  5 files changed, 46 insertions(+), 40 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > > @@ -400,11 +402,11 @@ static void test_arraymap(unsigned int task, =
void *data)
> > > >  static void test_arraymap_percpu(unsigned int task, void *data)
> > > >  {
> > > >         unsigned int nr_cpus =3D bpf_num_possible_cpus();
> > > > -       BPF_DECLARE_PERCPU(long, values);
> > > > +       pcpu_map_value_t values[nr_cpus];
> > > >         int key, next_key, fd, i;
> > > >
> > > >         fd =3D bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key=
),
> > > > -                           sizeof(bpf_percpu(values, 0)), 2, 0);
> > > > +                           sizeof(long), 2, 0);
> > > >         if (fd < 0) {
> > > >                 printf("Failed to create arraymap '%s'!\n", strerro=
r(errno));
> > > >                 exit(1);
> > > > @@ -459,7 +461,7 @@ static void test_arraymap_percpu(unsigned int t=
ask, void *data)
> > > >  static void test_arraymap_percpu_many_keys(void)
> > > >  {
> > > >         unsigned int nr_cpus =3D bpf_num_possible_cpus();
> > >
> > > This just sets a bad example for anyone using selftests as an
> > > aspiration for their own code. bpf_num_possible_cpus() does exit(1)
> > > internally if libbpf_num_possible_cpus() returns error. No one should
> > > write real production code like that. So maybe let's provide a better
> > > example instead with error handling and malloc (or perhaps alloca)?
> >
> > OK. Makes sense.
> >
> > >
> > > > -       BPF_DECLARE_PERCPU(long, values);
> > > > +       pcpu_map_value_t values[nr_cpus];
> > > >         /* nr_keys is not too large otherwise the test stresses per=
cpu
> > > >          * allocator more than anything else
> > > >          */
> > > > @@ -467,7 +469,7 @@ static void test_arraymap_percpu_many_keys(void=
)
> > > >         int key, fd, i;
> > > >
> > > >         fd =3D bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key=
),
> > > > -                           sizeof(bpf_percpu(values, 0)), nr_keys,=
 0);
> > > > +                           sizeof(long), nr_keys, 0);
> > > >         if (fd < 0) {
> > > >                 printf("Failed to create per-cpu arraymap '%s'!\n",
> > > >                        strerror(errno));
> > > > --
> > > > 2.25.1
> > > >
