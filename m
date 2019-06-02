Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1BB3216E
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 03:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfFBBK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 21:10:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45852 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFBBKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 21:10:25 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so1906048qtr.12;
        Sat, 01 Jun 2019 18:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zPL6I0Ni0qiEfW5Q6ko/dzZXqxO+ZreNRmeiZZCD7cc=;
        b=XvCP9m5bRoIqxqL7z1HhFZ4Sdm14cebZwdNQ49UOjkKgUiBXCyxe8gRX/rcIyCd0YP
         bO796P65dHO3Yg+WmJjgMVw6PXGBGAzMCM2eHAlg/E45r2pRXVnC+gEJ/A7VyaN2ZhFm
         Nd2eyG0xPsmWAJ5+D/RTXk84z9qjnRbRjtQ5qxwliXLTFlzfBrj87s7KGwUdXX2cqX/9
         7cJgUr0QfaTX2KopQPqTQKYzeiDmHiJmj6IkUFjKvZ4d8O72OV3MjrYLoInl2lfiXzpj
         LGVQkoZrxHFZsNhRbNCGKTawgp63OB3k/SuF5Bje6jl602AR5wrtr0VanP7PpIUFl78j
         d9Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPL6I0Ni0qiEfW5Q6ko/dzZXqxO+ZreNRmeiZZCD7cc=;
        b=qYLkjIPpq6qTQtcaF3Yr3Jfndfh3CNhiJHGX2llhH2OJOliUZPBCYsP6I+GdgcQVbC
         YdkeOXYPhGUvBg7OywT+ic+T9bMDbM/3JVbv80cruy2xdHbEaPvibSdxgbXMTLm8/j8s
         gkdlfLglCTJ0J/Ew9+nipl8TEr4eFoDDwav5K1awhDmmcNpgMk7gNJUq91HkDExnSHlf
         z0HpEIe9J5izXvUK5x5WAXFY+YfELjPCRjPYjnCyFSiAk0/XH5hzp0VVz4xQzHMeIxvf
         Y94PM8thjCoKBzum3WlIiyn2dxxBM20C6PaKouXctr1BTvfVyFBNCHvVVufUabmv88Bs
         XnUQ==
X-Gm-Message-State: APjAAAWXYNg6933cb2IqPS6C3/UghKaQBdYLYRubvmBKAcN4sl6yB0A/
        AGcGTb3l4inWln73Di2VWyfhfMQAU4m9V5ixiis=
X-Google-Smtp-Source: APXvYqxqdGoXeEBlE8yiqruf1q2I09gm3uEHAbWTtzqpINbG4lpQWY4sSPg3+hjrhWw1J/7u/W249boGPfnGJReB8L8=
X-Received: by 2002:ac8:2a63:: with SMTP id l32mr16869116qtl.117.1559437824411;
 Sat, 01 Jun 2019 18:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190601063952.2176919-1-andriin@fb.com> <20190601220503.7dabs472ixfbtjsf@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190601220503.7dabs472ixfbtjsf@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 1 Jun 2019 18:10:13 -0700
Message-ID: <CAEf4BzYCfEjwBErFh7QrVUoHQrUfJFFZwnzeUvYsGOA_Bmwm9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: add real-world BPF verifier scale
 test program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 1, 2019 at 3:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 11:39:52PM -0700, Andrii Nakryiko wrote:
> > This patch adds a new test program, based on real-world production
> > application, for testing BPF verifier scalability w/ realistic
> > complexity.
>
> Thanks!
>
> > -     const char *pyperf[] = {
> > +     const char *tp_progs[] = {
>
> I had very similar change in my repo :)
>
> > +struct strobemeta_payload {
> > +     /* req_id has valid request ID, if req_meta_valid == 1 */
> > +     int64_t req_id;
> > +     uint8_t req_meta_valid;
> > +     /*
> > +      * mask has Nth bit set to 1, if Nth metavar was present and
> > +      * successfully read
> > +      */
> > +     uint64_t int_vals_set_mask;
> > +     int64_t int_vals[STROBE_MAX_INTS];
> > +     /* len is >0 for present values */
> > +     uint16_t str_lens[STROBE_MAX_STRS];
> > +     /* if map_descrs[i].cnt == -1, metavar is not present/set */
> > +     struct strobe_map_descr map_descrs[STROBE_MAX_MAPS];
> > +     /*
> > +      * payload has compactly packed values of str and map variables in the
> > +      * form: strval1\0strval2\0map1key1\0map1val1\0map2key1\0map2val1\0
> > +      * (and so on); str_lens[i], key_lens[i] and val_lens[i] determines
> > +      * value length
> > +      */
> > +     char payload[STROBE_MAX_PAYLOAD];
> > +};
> > +
> > +struct strobelight_bpf_sample {
> > +     uint64_t ktime;
> > +     char comm[TASK_COMM_LEN];
> > +     pid_t pid;
> > +     int user_stack_id;
> > +     int kernel_stack_id;
> > +     int has_meta;
> > +     struct strobemeta_payload metadata;
> > +     /*
> > +      * makes it possible to pass (<real payload size> + 1) as data size to
> > +      * perf_submit() to avoid perf_submit's paranoia about passing zero as
> > +      * size, as it deduces that <real payload size> might be
> > +      * **theoretically** zero
> > +      */
> > +     char dummy_safeguard;
> > +};
>
> > +struct bpf_map_def SEC("maps") sample_heap = {
> > +     .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> > +     .key_size = sizeof(uint32_t),
> > +     .value_size = sizeof(struct strobelight_bpf_sample),
> > +     .max_entries = 1,
> > +};
>
> due to this design the stressfulness of the test is
> limited by bpf max map value limitation which comes from
> alloc_percpu limit.
> That makes it not as stressful as I was hoping for :)

What's the limit for per-cpu allocation?

You can reduce STROBE_MAX_STR_LEN to just 1 to save quite a lot of
space and push settings further.

>
> > +#define STROBE_MAX_INTS 25
> > +#define STROBE_MAX_STRS 25
> > +#define STROBE_MAX_MAPS 5
> > +#define STROBE_MAX_MAP_ENTRIES 20
>
> so I could bump STROBE_MAX_INTS to 300 and got:
> verification time 302401 usec // with kasan
> stack depth 464
> processed 40388 insns (limit 1000000) max_states_per_insn 6 total_states 8863 peak_states 8796 mark_read 4110
> test_scale:./strobemeta25.o:OK
>
> which is not that stressful comparing to some of the tests :)

INTS and STRS are less complicated, try playing with MAX_MAPS and
MAX_MAP_ENTRIES.

E.g., I can't seem to push farther than STROBE_MAX_MAPS 15 and
STROBE_MAX_MAP_ENTRIES 30, not sure if it's due to allocation limit.

On the other hand, trying STROBE_MAX_MAPS 30 and
STROBE_MAX_MAP_ENTRIES 15 (which should use pretty similar amount of
space), I hit stack size limit. So this combination (and higher
values, if possible), should be a good demo case for loops. I'm
curious for you to try and let me know if you could go higher with
loops support... :)

To save some more space, try removing cnt, tag_len, and id from struct
strobe_map_descr, you can try to reduce val_lens and key_lens to be
just uint8_t. Similar thing can be done to int_vals in struct
strobemeta_valid. I don't want to remove them, as they add to
complexity of the program, but reducing size should be ok.

BTW, it's kind of hard to understand why verif_scale case fails, would
be nice to get better log output (not just stats, which are missing on
failure). So consider that a feature request. ;)

>
> Without unroll:
> verification time 435963 usec // with kasan
> stack depth 488
> processed 52812 insns (limit 1000000) max_states_per_insn 26 total_states 6786 peak_states 1405 mark_read 777
> test_scale:./strobemeta25.o:OK
>
> So things are looking pretty good.
>
> I'll roll your test into my set with few tweaks. Thanks a lot!

sounds good!

>
> btw I consistently see better code and less insn_processed in alu32 mode.
> It's probably time to make it llvm default.
>

yep, I remember I had to explicitly cast a bunch of things to uint64_t
just to avoid those pesky <<= and >>= operations, where possible. :)
