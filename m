Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B01567A20
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiGEWhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiGEWhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:37:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10680BC32;
        Tue,  5 Jul 2022 15:37:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id fd6so17097921edb.5;
        Tue, 05 Jul 2022 15:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZjmOl+XPDMRqobDWe3O4pCC/uJ0SbhYv8qbfqlfTW6I=;
        b=WSGxRi8WKCDnii4etUgzqIxNQM3rhGpX7QKsQcuz3/C+19hmMjKrK/c80fsQqbsCI0
         0AyaMLdb7qeSm1luRgv79nO1310eripr+6KlekmSLJzciNiDUZJ0BnYniiLVNBm+JwOK
         HOdsrRK28Ts0r/H5OpgdNz74+4a7doEpJkarX7JNzsloBGvGgatOjAv4ZklDrWwdG8a6
         OWceeqRysaC1ih0clAStaEsBBy4HpjG31z7aOwKtLcM88YBFA2b6Itq8nok+0vlcWAI5
         j7UaPoTJg1oYj4jrCF9hkO0OSW96JXSxqGKVc1cDOfVvVgBU4p9clcpqZsBsha+SH3WY
         bItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjmOl+XPDMRqobDWe3O4pCC/uJ0SbhYv8qbfqlfTW6I=;
        b=Hnm8eUKzTXUYyofnIf0ocys64E0yjQYxd0N10WAz7BuEQAcZ6cPPZKZjjdJuKIhbyb
         5taf9uvNKDp4MIvuJ4bvyCHV7vUfiJ1znroJ46U2Zb5sH6ZdWNTvDfEpfzSAB5vBv10R
         /Ekiwmzx/BslmNoDw34t/gkLA2YrxvfjfBK1TfyivpCAESVgyvzVYeipMnRo0n+08l2t
         jhQIduZMqlLoJpHJo+grnefJ7EC0jqkkltYRYAlV2qhakH0yY7onB1+CiTNdlu+eh7Bg
         I5BwPvgY1NK9S54lPHCc+NhKaETWYTN+ybMN9/7ys79tae3isI+0Fa9dxSyEY5Xh7O5i
         v7Kg==
X-Gm-Message-State: AJIora/Rg4EjUi1gam8FS73N/vEbe6k8VcGsef+f0ePyqoRrxwsq/lOL
        X/0iUo9zEgVMnkNq41oTMOM9PoKaWdDkDVeSME9LaSrEaJw=
X-Google-Smtp-Source: AGRyM1u9KFws9HaHFEjaZILmVf8am4ZAJtS14MNBQ7Cve6zPVaXMgbVXV+xdOlw/Chdx41MK+qQ/2TP9vC05dQSJWcs=
X-Received: by 2002:a05:6402:510b:b0:437:28b0:8988 with SMTP id
 m11-20020a056402510b00b0043728b08988mr50627568edd.260.1657060632565; Tue, 05
 Jul 2022 15:37:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220331122822.14283-1-houtao1@huawei.com> <CAEf4Bzb7keBS8vXgV5JZzwgNGgMV0X3_guQ_m9JW3X6fJBDpPQ@mail.gmail.com>
 <5a990687-b336-6f44-589b-8bd972882beb@huawei.com> <CAEf4BzaUmqDUeKBjSQgLNULx=f-3ipK57Y2qEbND0XuuL9aNvw@mail.gmail.com>
 <8b4c1ad2-d6ba-a100-5438-a025ceb7f5e1@huawei.com> <CAEf4Bzbfct4G7AjVjbaL8LvSGy0NQWeEjoR1BCfeZzdmYx8Tpw@mail.gmail.com>
 <bcaef485-fca6-a5e3-68da-c895b802b352@huawei.com> <CAEf4Bzb5kiTgXwvR5DuTDJJQT=CtWhreyd=Y2eOMM19KTE_4kg@mail.gmail.com>
 <503873ca-b094-961b-0fd6-cf842b39cf84@huawei.com>
In-Reply-To: <503873ca-b094-961b-0fd6-cf842b39cf84@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Jul 2022 15:37:01 -0700
Message-ID: <CAEf4BzY+HRxgW_3=-b5Brp8BrEn4ZrCEb70q5FoNVusBu+VyLA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: Introduce ternary search tree for
 string key
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
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

On Wed, Jun 8, 2022 at 2:00 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> On 4/27/2022 11:57 AM, Andrii Nakryiko wrote:
> > On Tue, Apr 26, 2022 at 1:03 AM Hou Tao <houtao1@huawei.com> wrote:
> snip
> >>> I'm biased :) But I like the idea of qp-trie as a general purpose
> >>> ordered and dynamically sized BPF map. It makes no assumption about
> >>> data being string-like and sharing common prefixes. It can be made to
> >>> work just as fine with any array of bytes, making it very suitable as
> >>> a generic lookup table map. Note that upstream implementation does
> >>> assume zero-terminated strings and no key being a prefix of another
> >>> key. But all that can be removed. For fixed-length keys this can never
> >>> happen by construction, for variable-length keys (and we'll be able to
> >>> support this finally with bpf_dynptr's help very soon), we can record
> >>> length of the key in each leaf and use that during comparisons.
> >> Using the trailing zero byte to make sure no key will be a prefix of another is
> >> simple, but I will check whether or not there is other way to make the bytes
> >> array key work out. Alexei had suggest me to use the length of key as part of
> >> key just like bpf_lpm_trie_key does, maybe i can try it first.
> > Yeah, using key length as part of the key during comparison is what I
> > meant as well. I didn't mean to aritificially add trailing zero (this
> > idea doesn't work for arbitrary binary data).
> >
> >>> Also note that qp-trie can be internally used by BPF_MAP_TYPE_LPM_TRIE
> >>> very efficiently and speed it up considerable in the process (and
> >>> especially to get rid of the global lock).
> >>>
> >>> So if you were to invest in a proper full-featured production
> >>> implementation of a BPF map, I'd start with qp-trie. From available
> >>> benchmarks it's both faster and more memory efficient than Red-Black
> >>> trees, which could be an alternative underlying implementation of such
> >>> ordered and "resizable" map.
> Recently I tried to add concurrent update and deletion support for qp-trie, and
> found out that hand-over-hand lock scheme may don't work for qp-trie update. The
> short explanation is that update procedure needs traverse qp-trie twice and the
> position tuple got in the first pass may be stale due to concurrent updates
> occurred in the second pass. The detailed explanation is shown below.
>
> To reduce space usage for qp-trie, there is no common prefix saved in branch
> node, so the update of qp-trie needs to traversing qp-trie to find the most
> similar key firstly, comparing with it to get a (index, flag,) tuple for the
> leaf key, then traversing qp-trie again to find the insert position by using the
> tuple. The problem is that, the position tuple may be stale due to concurrent
> updates occurred in different branch. Considering the following case:
>
> When inserting "aa_bind_mount" and "aa_buffers_lock" concurrently into the
> following qp-trie. The most similar key for "aa_bind_mount" is leaf X, and for
> "aa_buffers_lock" it is leaf Y. The calculated index tuple for both new keys are
> the same: (index=3, flag=2). Assuming "aa_bind_mount" is inserted firstly, so
> when inserting "aa_buffers_lock", the correct index will be (index=4, flag=1)
> instead of (index=3, flag=2) and the result will be incorrect.
>
> branch: index  1 flags 1 bitmap 0x00088
> * leaf: a.81577 0
> * branch: index  4 flags 1 bitmap 0x00180
> * * branch: index  4 flags 2 bitmap 0x02080
> * * * leaf: aa_af_perm 1 (leaf X, for aa_bind_mount)
> * * branch: index  4 flags 2 bitmap 0x00052
> * * * leaf: aa_apply_modes_to_perms 6
> * * * leaf: aa_asprint_hashstr 7 (leaf Y, for aa_buffers_lock)
>
> In order to get a correct position tuple, the intuitive solution is adding
> common prefix in branch node and letting update procedure to find the insertion
> position by comparing with the prefix, so it only needs to traverse qp-trie once
> and hand-over-hand locking scheme can work. I plan to work on qp-trie with
> common prefix and will update its memory usage and concurrent update/insert
> speed in this thread once the demo is ready.  So any more suggestions ?
>

Yeah, that sucks. I'm not sure I completely understand the common
prefix solution and whether it will still be qp-trie after that, but
if you try that, it would be interesting to learn about the results
you get!

I think in the worst case we'll have to do tree-wide lock, perhaps
maybe having an initial 256-way root node for first byte, and each of
256 subtrees could have their own lock.

Alternatively we can do optimistic lockless lookup (in the hope to
find a match), but if that fails - take tree-wide lock, and perform
the search and insertion again. This will favor lookup hits,
obviously, but hopefully that's going to be a common use case where
keys are mostly matching.

WDYT?


> Regards,
> Tao
>
> >> Thanks for your suggestions. I will give it a try.
> > Awesome!
> >
> >> Regards,
> >> Tao
> >>
> >>>> Regards,
> >>>> Tao
> >>>>>>> This prefix sharing is nice when you have a lot of long common
> >>>>>>> prefixes, but I'm a bit skeptical that as a general-purpose BPF data
> >>>>>>> structure it's going to be that beneficial. 192 bytes of common
> >>>>>>> prefixes seems like a very unusual dataset :)
> >>>>>> Yes. The case with common prefix I known is full file path.
> >>>>>>> More specifically about TST implementation in your paches. One global
> >>>>>>> per-map lock I think is a very big downside. We have LPM trie which is
> >>>>>>> very slow in big part due to global lock. It might be possible to
> >>>>>>> design more granular schema for TST, but this whole in-place splitting
> >>>>>>> logic makes this harder. I think qp-trie can be locked in a granular
> >>>>>>> fashion much more easily by having a "hand over hand" locking: lock
> >>>>>>> parent, find child, lock child, unlock parent, move into child node.
> >>>>>>> Something like that would be more scalable overall, especially if the
> >>>>>>> access pattern is not focused on a narrow set of nodes.
> >>>>>> Yes. The global lock is a problem but the splitting is not in-place. I will try
> >>>>>> to figure out whether the lock can be more scalable after the benchmark test
> >>>>>> between qp-trie and tst.
> >>>>> Great, looking forward!
> >>>>>
> >>>>>> Regards,
> >>>>>> Tao
> >>>>>>
> >>>>>> [0]: https://github.com/Tessil/hat-trie
> >>>>>>> Anyways, I love data structures and this one is an interesting idea.
> >>>>>>> But just my few cents of "production-readiness" for general-purpose
> >>>>>>> data structures for BPF.
> >>>>>>>
> >>>>>>>   [0] https://dotat.at/prog/qp/README.html
> >>>>>>>
> >>>>>>>> Regards,
> >>>>>>>> Tao
> >>>>>>>>
> >>>>>>>> [1]: https://lore.kernel.org/bpf/CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com/
> >>>>>>>>
> >>>>>>>> Hou Tao (2):
> >>>>>>>>   bpf: Introduce ternary search tree for string key
> >>>>>>>>   selftests/bpf: add benchmark for ternary search tree map
> >>>>>>>>
> >>>>>>>>  include/linux/bpf_types.h                     |   1 +
> >>>>>>>>  include/uapi/linux/bpf.h                      |   1 +
> >>>>>>>>  kernel/bpf/Makefile                           |   1 +
> >>>>>>>>  kernel/bpf/bpf_tst.c                          | 411 +++++++++++++++++
> >>>>>>>>  tools/include/uapi/linux/bpf.h                |   1 +
> >>>>>>>>  tools/testing/selftests/bpf/Makefile          |   5 +-
> >>>>>>>>  tools/testing/selftests/bpf/bench.c           |   6 +
> >>>>>>>>  .../selftests/bpf/benchs/bench_tst_map.c      | 415 ++++++++++++++++++
> >>>>>>>>  .../selftests/bpf/benchs/run_bench_tst.sh     |  54 +++
> >>>>>>>>  tools/testing/selftests/bpf/progs/tst_bench.c |  70 +++
> >>>>>>>>  10 files changed, 964 insertions(+), 1 deletion(-)
> >>>>>>>>  create mode 100644 kernel/bpf/bpf_tst.c
> >>>>>>>>  create mode 100644 tools/testing/selftests/bpf/benchs/bench_tst_map.c
> >>>>>>>>  create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_tst.sh
> >>>>>>>>  create mode 100644 tools/testing/selftests/bpf/progs/tst_bench.c
> >>>>>>>>
> >>>>>>>> --
> >>>>>>>> 2.31.1
> >>>>>>>>
> >>>>>>> .
> >>>>> .
> >>> .
> > .
>
