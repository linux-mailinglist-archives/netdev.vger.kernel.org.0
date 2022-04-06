Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A6E4F6AF0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiDFUMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiDFULm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:11:42 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABAF4FA20D;
        Wed,  6 Apr 2022 10:38:29 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z7so3868751iom.1;
        Wed, 06 Apr 2022 10:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Cs5Vt6UkYq7u69hUCTmkTbEACL4NrNkmG728WDKAXo=;
        b=dRM9cimVa9u5yQTeb5E/b3pEEpGMKhqQhh0C0hfaHczGVxKqcJVYXdywmB0Qyt5IQr
         ZLr0wF3b7TCKNFac0KQMi2rgI1SililYJikap/OA4S2Dvcgb6KrzpgcEGStqFFANof2a
         t2iZIznAjQAFQ+nhIJ19UJygwo5hAsq1CVxJIsbdjfM7fMWM/sZdJr61SHqlvbrtw1qe
         VdvX5tHGSemsl1rtCzvd8/AVMG4brIUZnWXc/JvYUJ24fbXJE33HoIDYCotGjngs2+V3
         7BhrwwL3hjolOg+SiH/KEZAQjAq6ixLxdIMxEByYkz0vkdsGJivdtXGLw6NlFV3felf3
         Hdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Cs5Vt6UkYq7u69hUCTmkTbEACL4NrNkmG728WDKAXo=;
        b=7dLIXLbiREI0pxgg0zyF+3BFd93Qe72gmHWvoH0TWC/GOA8Xq+7At8o58SkV1m6YVl
         cQcurQJsoJZOmzqu/Oow0HpQ/ZvSHsiuGwhI2WiiVxJatmMfkKiCfTmba2ZjrOAR8ayM
         kI77XhPd7UVXNBhYz45klgLqDOv3IC01FW4KegE6IQw8M62y2i8S0m5CvAuybL+QWRGw
         SkZZHWUo7qO4+P77l6JOeY81SKWIpW7UmMyQoCZlFRGoxTfJOh9awdkW5XbZj9zHVDYL
         FN7awgNTAeqNd8R8hLryoqNsuhxpkpdNHTfQdv7x4znPWjnacm4vqPWf++GzBefYGb7a
         Cqzw==
X-Gm-Message-State: AOAM531jhkBuVaXKN9zyV4oU7FfMMTJhukd+f1PWVfbFFxL9WzNpK4wq
        W6HZQhgbewyr2Lmv6tlWURKce9pjB5ptlfAP6uM=
X-Google-Smtp-Source: ABdhPJzux8tLoiukInAccV8nyJJYFr4Dhs3C5r+F4yrLd4iVkCofupMNKWBuPIDrcdxYKm6ukf7P3lVMgituvE9eX1M=
X-Received: by 2002:a05:6638:1685:b0:323:9fed:890a with SMTP id
 f5-20020a056638168500b003239fed890amr5168085jat.103.1649266708930; Wed, 06
 Apr 2022 10:38:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220331122822.14283-1-houtao1@huawei.com>
In-Reply-To: <20220331122822.14283-1-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Apr 2022 10:38:18 -0700
Message-ID: <CAEf4Bzb7keBS8vXgV5JZzwgNGgMV0X3_guQ_m9JW3X6fJBDpPQ@mail.gmail.com>
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

On Thu, Mar 31, 2022 at 5:04 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> The initial motivation for the patchset is due to the suggestion of Alexei.
> During the discuss of supporting of string key in hash-table, he saw the
> space efficiency of ternary search tree under our early test and suggest
> us to post it as a new bpf map [1].
>
> Ternary search tree is a special trie where nodes are arranged in a
> manner similar to binary search tree, but with up to three children
> rather than two. The three children correpond to nodes whose value is
> less than, equal to, and greater than the value of current node
> respectively.
>
> In ternary search tree map, only the valid content of string is saved.
> The trailing null byte and unused bytes after it are not saved. If there
> are common prefixes between these strings, the prefix is only saved once.
> Compared with other space optimized trie (e.g. HAT-trie, succinct trie),
> the advantage of ternary search tree is simple and being writeable.
>
> Below are diagrams for ternary search map when inserting hello, he,
> test and tea into it:
>
> 1. insert "hello"
>
>         [ hello ]
>
> 2. insert "he": need split "hello" into "he" and "llo"
>
>          [ he ]
>             |
>             *
>             |
>          [ llo ]
>
> 3. insert "test": add it as right child of "he"
>
>          [ he ]
>             |
>             *-------x
>             |       |
>          [ llo ] [ test ]
>
> 5. insert "tea": split "test" into "te" and "st",
>    and insert "a" as left child of "st"
>
>          [ he ]
>             |
>      x------*-------x
>      |      |       |
>   [ ah ] [ llo ] [ te ]
>                     |
>                     *
>                     |
>                  [ st ]
>                     |
>                x----*
>                |
>              [ a ]
>
> As showed in above diagrams, the common prefix between "test" and "tea"
> is "te" and it only is saved once. Also add benchmarks to compare the
> memory usage and lookup performance between ternary search tree and
> hash table. When the common prefix is lengthy (~192 bytes) and the
> length of suffix is about 64 bytes, there are about 2~3 folds memory
> saving compared with hash table. But the memory saving comes at prices:
> the lookup performance of tst is about 2~3 slower compared with hash
> table. See more benchmark details on patch #2.
>
> Comments and suggestions are always welcome.
>

Have you heard and tried qp-trie ([0]) by any chance? It is elegant
and simple data structure. By all the available benchmarks it handily
beats Red-Black trees in terms of memory usage and performance (though
it of course depends on the data set, just like "memory compression"
for ternary tree of yours depends on large set of common prefixes).
qp-trie based BPF map seems (at least on paper) like a better
general-purpose BPF map that is dynamically sized (avoiding current
HASHMAP limitations) and stores keys in sorted order (and thus allows
meaningful ordered iteration *and*, importantly for longest prefix
match tree, allows efficient prefix matches). I did a quick experiment
about a month ago trying to replace libbpf's internal use of hashmap
with qp-trie for BTF string dedup and it was slightly slower than
hashmap (not surprisingly, though, because libbpf over-sizes hashmap
to avoid hash collisions and long chains in buckets), but it was still
very decent even in that scenario. So I've been mulling the idea of
implementing BPF map based on qp-trie elegant design and ideas, but
can't find time to do this.

This prefix sharing is nice when you have a lot of long common
prefixes, but I'm a bit skeptical that as a general-purpose BPF data
structure it's going to be that beneficial. 192 bytes of common
prefixes seems like a very unusual dataset :)

More specifically about TST implementation in your paches. One global
per-map lock I think is a very big downside. We have LPM trie which is
very slow in big part due to global lock. It might be possible to
design more granular schema for TST, but this whole in-place splitting
logic makes this harder. I think qp-trie can be locked in a granular
fashion much more easily by having a "hand over hand" locking: lock
parent, find child, lock child, unlock parent, move into child node.
Something like that would be more scalable overall, especially if the
access pattern is not focused on a narrow set of nodes.

Anyways, I love data structures and this one is an interesting idea.
But just my few cents of "production-readiness" for general-purpose
data structures for BPF.

  [0] https://dotat.at/prog/qp/README.html

> Regards,
> Tao
>
> [1]: https://lore.kernel.org/bpf/CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com/
>
> Hou Tao (2):
>   bpf: Introduce ternary search tree for string key
>   selftests/bpf: add benchmark for ternary search tree map
>
>  include/linux/bpf_types.h                     |   1 +
>  include/uapi/linux/bpf.h                      |   1 +
>  kernel/bpf/Makefile                           |   1 +
>  kernel/bpf/bpf_tst.c                          | 411 +++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |   1 +
>  tools/testing/selftests/bpf/Makefile          |   5 +-
>  tools/testing/selftests/bpf/bench.c           |   6 +
>  .../selftests/bpf/benchs/bench_tst_map.c      | 415 ++++++++++++++++++
>  .../selftests/bpf/benchs/run_bench_tst.sh     |  54 +++
>  tools/testing/selftests/bpf/progs/tst_bench.c |  70 +++
>  10 files changed, 964 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/bpf_tst.c
>  create mode 100644 tools/testing/selftests/bpf/benchs/bench_tst_map.c
>  create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_tst.sh
>  create mode 100644 tools/testing/selftests/bpf/progs/tst_bench.c
>
> --
> 2.31.1
>
