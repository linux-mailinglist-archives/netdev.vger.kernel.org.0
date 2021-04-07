Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5D3357464
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355342AbhDGScF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhDGScD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:32:03 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0864C06175F;
        Wed,  7 Apr 2021 11:31:53 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id e188so10166049ybb.13;
        Wed, 07 Apr 2021 11:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kn69rhRMMVrayDs5H+UzYud2Z7b87MPu6OYNo7BSq9A=;
        b=Q2cgRQjRQoFVUE6O76KGZGQ0T10GT/8WWUQ4aLFIvZB1FdDAVI7p0zTOtKA3w5gmxC
         GJ9+qEn9Pl6LOQDUOz/2AscK4HGX/1pzTtrWrclrliS9UWu2vetCXRLORs9r1/0BGOll
         z4+IUGKVMpbbjvfjr/Cer+mqJQIqGPMQaVcF5Wyn9jFeVGrczf9AvISUdu3E3Z08gfCa
         tqIR2B9NeRkhhNaVWenAAVcYue4UsqlMAHKD8aTXMxbjTHbTowFcZ9tqnt9JmYZmEz7E
         /9dWXUufoX7o7RKzVcI7hhwlnKcS3T8x6l6I9Z/4vTJoPub06WYZ4jEsnzbDbBkuD1Tm
         E7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kn69rhRMMVrayDs5H+UzYud2Z7b87MPu6OYNo7BSq9A=;
        b=tjp51UgVsUw9dveE7K+1oE+bd3Ctnq4pJWYA80F2s6HXG/IPD6zUI1wBC5aQ09xQ24
         aLD50NVBF0W3F/VorcOvnLwIkztiN/jne3Yx12u/0sEQvqHKqTmktiD7nHPa3NsoxP65
         /20f+ukdNa15M93YFwfoPnVJ1HMx/QrnvPkLVFsGUPGRZjdtNURNhdpL0JTJf4xhVUWx
         lHgurknNNJ8op4EfRYXJqhWG9U7ORFdhNcA1tDZ8ZvY2iBxSA999yUS5tA3dZ4m9U4LV
         b2A408wYtpDIbCDVr+ciAS6DqKHZ+EJPyVrm4E1sVOfX2d9uVeiorzisCFwp5CfQj4Bz
         GHmA==
X-Gm-Message-State: AOAM532eVSixlRrilev70gKpirjFw1UwiE5lI6tmv/ZWNOjEi6qHK1GH
        kA1uc41GWFfz5BAHqpgFgXp2jQIqm+IdmCtEC1c=
X-Google-Smtp-Source: ABdhPJwyD46iJ/cTYmc9rpHBrMJfjKJ5VR+417ZI8GKSj4oYvi0t0OHizfMM7YPKvVsq94rSk7oftNhfxDjL2qjXeCo=
X-Received: by 2002:a25:9942:: with SMTP id n2mr6307629ybo.230.1617820312912;
 Wed, 07 Apr 2021 11:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210406185400.377293-1-pctammela@mojatatu.com> <20210406185400.377293-3-pctammela@mojatatu.com>
In-Reply-To: <20210406185400.377293-3-pctammela@mojatatu.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 11:31:42 -0700
Message-ID: <CAEf4BzYmj_ZPDq8Zi4dbntboJKRPU2TVopysBNrdd9foHTfLZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: selftests: refactor
 'BPF_PERCPU_TYPE()' and 'bpf_percpu()' macros
To:     Pedro Tammela <pctammela@gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 6, 2021 at 11:55 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> This macro was refactored out of the bpf selftests.
>
> Since percpu values are rounded up to '8' in the kernel, a careless
> user in userspace might encounter unexpected values when parsing the
> output of the batched operations.

I wonder if a user has to be more careful, though? This
BPF_PERCPU_TYPE, __bpf_percpu_align and bpf_percpu macros seem to
create just another opaque layer. It actually seems detrimental to me.

I'd rather emphasize in the documentation (e.g., in
bpf_map_lookup_elem) that all per-cpu maps are aligning values at 8
bytes, so user has to make sure that array of values provided to
bpf_map_lookup_elem() has each element size rounded up to 8.

In practice, I'd recommend users to always use __u64/__s64 when having
primitive integers in a map (they are not saving anything by using
int, it just creates an illusion of savings). Well, maybe on 32-bit
arches they would save a bit of CPU, but not on typical 64-bit
architectures. As for using structs as values, always mark them as
__attribute__((aligned(8))).

Basically, instead of obscuring the real use some more, let's clarify
and maybe even provide some examples in documentation?

>
> Now that both array and hash maps have support for batched ops in the
> percpu variant, let's provide a convenient macro to declare percpu map
> value types.
>
> Updates the tests to a "reference" usage of the new macro.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  tools/lib/bpf/bpf.h                           | 10 ++++
>  tools/testing/selftests/bpf/bpf_util.h        |  7 ---
>  .../bpf/map_tests/htab_map_batch_ops.c        | 48 ++++++++++---------
>  .../selftests/bpf/prog_tests/map_init.c       |  5 +-
>  tools/testing/selftests/bpf/test_maps.c       | 16 ++++---
>  5 files changed, 46 insertions(+), 40 deletions(-)
>

[...]

> @@ -400,11 +402,11 @@ static void test_arraymap(unsigned int task, void *data)
>  static void test_arraymap_percpu(unsigned int task, void *data)
>  {
>         unsigned int nr_cpus = bpf_num_possible_cpus();
> -       BPF_DECLARE_PERCPU(long, values);
> +       pcpu_map_value_t values[nr_cpus];
>         int key, next_key, fd, i;
>
>         fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
> -                           sizeof(bpf_percpu(values, 0)), 2, 0);
> +                           sizeof(long), 2, 0);
>         if (fd < 0) {
>                 printf("Failed to create arraymap '%s'!\n", strerror(errno));
>                 exit(1);
> @@ -459,7 +461,7 @@ static void test_arraymap_percpu(unsigned int task, void *data)
>  static void test_arraymap_percpu_many_keys(void)
>  {
>         unsigned int nr_cpus = bpf_num_possible_cpus();

This just sets a bad example for anyone using selftests as an
aspiration for their own code. bpf_num_possible_cpus() does exit(1)
internally if libbpf_num_possible_cpus() returns error. No one should
write real production code like that. So maybe let's provide a better
example instead with error handling and malloc (or perhaps alloca)?

> -       BPF_DECLARE_PERCPU(long, values);
> +       pcpu_map_value_t values[nr_cpus];
>         /* nr_keys is not too large otherwise the test stresses percpu
>          * allocator more than anything else
>          */
> @@ -467,7 +469,7 @@ static void test_arraymap_percpu_many_keys(void)
>         int key, fd, i;
>
>         fd = bpf_create_map(BPF_MAP_TYPE_PERCPU_ARRAY, sizeof(key),
> -                           sizeof(bpf_percpu(values, 0)), nr_keys, 0);
> +                           sizeof(long), nr_keys, 0);
>         if (fd < 0) {
>                 printf("Failed to create per-cpu arraymap '%s'!\n",
>                        strerror(errno));
> --
> 2.25.1
>
