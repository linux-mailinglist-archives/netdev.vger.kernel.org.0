Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E4501D65
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 23:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbiDNV1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 17:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245669AbiDNV1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 17:27:52 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A96E6149;
        Thu, 14 Apr 2022 14:25:25 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q22so345308iod.2;
        Thu, 14 Apr 2022 14:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IYUAa9nSNmcQrcB+5ghi+Z+RhU+ABdLB3t8ekfCuSQQ=;
        b=EKHSzSCTYozeiWVy7kBxdsJ7f4xYoZWfOvZZG9ewBiU+/ViIqr8OQzRU32lm4wUVj8
         pv413wzLtwDsJgSm3/xvwnD/cDJPkCbOUzAxJEI26Ff/7ELrs2P1jdgEoCxpSLjBoUiL
         04LBZoP/1KGUx29t0HgWCwy5IfOmHo0QKzD+nBNiM/C3U8Iczl+HQU6tHU2mpsp56tE6
         82LrXQ/2/n07U1bb0J5MSkiSdaZTr179t37pW9pm9ehe5Bc36PPgibiXFngNIYsaH+/B
         dmxLO4JnWulR5ecPQL6SukV/kAza0WiReSgMA8AaWh5pB1kXtq3QFyOjlsUWshZI6ZYw
         YMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IYUAa9nSNmcQrcB+5ghi+Z+RhU+ABdLB3t8ekfCuSQQ=;
        b=Pu/dhgWyKSRpzh0ZjK74nFdFErJYaLLy2mJ5NoqmlMuhalxYdIff54jmyxd4r3KZqD
         QdA8s7DXLg3+fwsj5RpSc7UwrLD1YAIBEejjDlUbXHcnyCGNz2lUkNRceDXsbq8f0XZ8
         56qKTHO1UvART6nv6HaM7+KeMxTB9qFUfFf+LFZZdLHLlvotKHhaBuFO9/bjwuYLL2IB
         d8S0UqymX3pb6F1a6KErIBF5Bc+R+3/PcDwRC6Tl6AadkEVFUZva3RIqQdzAnuuSrUxP
         muSx2q2zax/OcCz02E8qEuaM2maNnNgRGVrIanJvA/x4BccVK3Nykd8glFRB8FOhP4yx
         q1nw==
X-Gm-Message-State: AOAM532tK3ekADxOqZ2XhVbDPzHGCrfb8GDid0xPAHI+YbvXI4ukCfVQ
        FZO7V2MTmaMy5ZmNPDoOuk3RKXiHld5RtDV98L8=
X-Google-Smtp-Source: ABdhPJwDU+M2g+qV7rD7u7z2HaprU0oHo4n76OJi8sxpi+mKtf8McJcZmCpSYOkBBnRd2dttDEyM2gK91o7Z9HJ6jqU=
X-Received: by 2002:a05:6638:2642:b0:323:756f:42a7 with SMTP id
 n2-20020a056638264200b00323756f42a7mr2156716jat.145.1649971525053; Thu, 14
 Apr 2022 14:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220331122822.14283-1-houtao1@huawei.com> <CAEf4Bzb7keBS8vXgV5JZzwgNGgMV0X3_guQ_m9JW3X6fJBDpPQ@mail.gmail.com>
 <5a990687-b336-6f44-589b-8bd972882beb@huawei.com> <CAEf4BzaUmqDUeKBjSQgLNULx=f-3ipK57Y2qEbND0XuuL9aNvw@mail.gmail.com>
 <8b4c1ad2-d6ba-a100-5438-a025ceb7f5e1@huawei.com>
In-Reply-To: <8b4c1ad2-d6ba-a100-5438-a025ceb7f5e1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 Apr 2022 14:25:13 -0700
Message-ID: <CAEf4Bzbfct4G7AjVjbaL8LvSGy0NQWeEjoR1BCfeZzdmYx8Tpw@mail.gmail.com>
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

On Wed, Apr 13, 2022 at 6:03 PM Hou Tao <houtao1@huawei.com> wrote:
>
> Hi,
>
> (I send my previous reply in HTML mode mistakenly and the mail list doesn't
> receive it, so send it again in the plain text mode.)
>
> On 4/13/2022 12:09 PM, Andrii Nakryiko wrote:
> > On Fri, Apr 8, 2022 at 8:08 PM Hou Tao <houtao1@huawei.com> wrote:
> >> Hi,
> >>
> >> On 4/7/2022 1:38 AM, Andrii Nakryiko wrote:
> >>> On Thu, Mar 31, 2022 at 5:04 AM Hou Tao <houtao1@huawei.com> wrote:
> >>>> Hi,
> >>>>
> >>>> The initial motivation for the patchset is due to the suggestion of Alexei.
> >>>> During the discuss of supporting of string key in hash-table, he saw the
> >>>> space efficiency of ternary search tree under our early test and suggest
> >>>> us to post it as a new bpf map [1].
> >>>>
> >>>> Ternary search tree is a special trie where nodes are arranged in a
> >>>> manner similar to binary search tree, but with up to three children
> >>>> rather than two. The three children correpond to nodes whose value is
> >>>> less than, equal to, and greater than the value of current node
> >>>> respectively.
> >>>>
> >>>> In ternary search tree map, only the valid content of string is saved.
> >>>> The trailing null byte and unused bytes after it are not saved. If there
> >>>> are common prefixes between these strings, the prefix is only saved once.
> >>>> Compared with other space optimized trie (e.g. HAT-trie, succinct trie),
> >>>> the advantage of ternary search tree is simple and being writeable.
> snip
> >>>>
> >>> Have you heard and tried qp-trie ([0]) by any chance? It is elegant
> >>> and simple data structure. By all the available benchmarks it handily
> >>> beats Red-Black trees in terms of memory usage and performance (though
> >>> it of course depends on the data set, just like "memory compression"
> >>> for ternary tree of yours depends on large set of common prefixes).
> >>> qp-trie based BPF map seems (at least on paper) like a better
> >>> general-purpose BPF map that is dynamically sized (avoiding current
> >>> HASHMAP limitations) and stores keys in sorted order (and thus allows
> >>> meaningful ordered iteration *and*, importantly for longest prefix
> >>> match tree, allows efficient prefix matches). I did a quick experiment
> >>> about a month ago trying to replace libbpf's internal use of hashmap
> >>> with qp-trie for BTF string dedup and it was slightly slower than
> >>> hashmap (not surprisingly, though, because libbpf over-sizes hashmap
> >>> to avoid hash collisions and long chains in buckets), but it was still
> >>> very decent even in that scenario. So I've been mulling the idea of
> >>> implementing BPF map based on qp-trie elegant design and ideas, but
> >>> can't find time to do this.
> >> I have heard about it when check the space efficient of HAT trie [0], because
> >> qp-trie needs to save the whole string key in the leaf node and its space
> >> efficiency can not be better than ternary search tree for strings with common
> >> prefix, so I did not consider about it. But I will do some benchmarks to check
> >> the lookup performance and space efficiency of qp-trie and tst for string with
> >> common prefix and strings without much common prefix.
> >> If qp-trie is better, I think I can take the time to post it as a bpf map if you
> >> are OK with that.
> > You can probably always craft a data set where prefix sharing is so
> > prevalent that space savings are very significant. But I think for a
> > lot of real-world data it won't be as extreme and qp-trie might be
> > very comparable (if not more memory-efficient) due to very compact
> > node layout (which was the point of qp-trie). So I'd be really curious
> > to see some comparisons. Would be great if you can try both!
> It is a bit surprised to me that qp-trie has better memory efficiency  (and
> better lookup performance sometimes) compared with tst when there are not so
> many common prefix between input strings (All tests below are conducted by
> implementing the data structure in user-space):

Thanks for a quick follow up and a benchmark!

Low memory use is probably due to the minimal amount of pointers and
extra metadata used per node in qp-trie. qp-trie approach is very
lean, which is why I was recommending trying it out.

>
> * all unique symbols in /proc/kallsyms (171428 sorted symbols,  4.2MB in total)
>
>                                         | qp-trie   | tst    | hash   |
> total memory used (MB) | 8.6       | 11.2   | 22.3   |
> total update time (us) | 94623     | 87396  | 24477  |
> total lookup time (us) | 50681     | 67395  | 22842  |
>
> * all strings in BTF string area (115980 unsorted strings, 2MB in total)
>
>                                         | qp-trie   | tst    | hash   |
> total memory used (MB) | 5.0       | 7.3    | 13.5   |
> total update time (us) | 67764     | 43484  | 16462  |
> total lookup time (us) | 33732     | 31612  | 16462  |
>
> * all strings in BTF string area (115980 sorted string, 2MB in total)
>
>                                        | qp-trie   | tst    | hash   |
> total memory used (MB) | 5.0       | 7.3    | 13.5   |
> total update time (us) | 58745     | 57756  | 16210  |
> total lookup time (us) | 26922     | 40850  | 16896  |
>
> * all files under Linux kernel (2.7MB, 74359 files generated by find utility
> with "./" stripped)
>
>                                         | qp-trie   | tst    | hash   |
> total memory used (MB) | 4.6       | 5.2    | 11.6   |
> total update time (us) | 50422     | 28842  | 15255  |
> total lookup time (us) | 22543     | 18252  | 11836  |

Seems like lookup time is more or less on par (and for kallsyms
noticeably faster), but update is sometimes a bit slower. I don't know
if you did your own code or used open-source implementation, but keep
in mind that performance of qp-trie very much depends on fast
__builtin_popcount, so make sure you are using proper -march when
compiling. See [0]

  [0] https://stackoverflow.com/questions/52161596/why-is-builtin-popcount-slower-than-my-own-bit-counting-function

>
> When the length of common prefix increases, ternary search tree becomes better
> than qp-trie.
>
> * all files under Linux kernel with a comm prefix (e.g. "/home/houtao")
>
>                                         | qp-trie   | tst    | hash   |
> total memory used (MB) | 5.5       | 5.2    | 12.2   |
> total update time (us) | 51558     | 29835  | 15345  |
> total lookup time (us) | 23121     | 19638  | 11540  |
>
> Because the lengthy prefix is not so common, and for string map I think the
> memory efficiency and lookup performance is more importance than update
> performance, so maybe qp-trie is a better choice for string map ?  Any suggestions ?
>

I'm biased :) But I like the idea of qp-trie as a general purpose
ordered and dynamically sized BPF map. It makes no assumption about
data being string-like and sharing common prefixes. It can be made to
work just as fine with any array of bytes, making it very suitable as
a generic lookup table map. Note that upstream implementation does
assume zero-terminated strings and no key being a prefix of another
key. But all that can be removed. For fixed-length keys this can never
happen by construction, for variable-length keys (and we'll be able to
support this finally with bpf_dynptr's help very soon), we can record
length of the key in each leaf and use that during comparisons.

Also note that qp-trie can be internally used by BPF_MAP_TYPE_LPM_TRIE
very efficiently and speed it up considerable in the process (and
especially to get rid of the global lock).

So if you were to invest in a proper full-featured production
implementation of a BPF map, I'd start with qp-trie. From available
benchmarks it's both faster and more memory efficient than Red-Black
trees, which could be an alternative underlying implementation of such
ordered and "resizable" map.


> Regards,
> Tao
> >>
> >>> This prefix sharing is nice when you have a lot of long common
> >>> prefixes, but I'm a bit skeptical that as a general-purpose BPF data
> >>> structure it's going to be that beneficial. 192 bytes of common
> >>> prefixes seems like a very unusual dataset :)
> >> Yes. The case with common prefix I known is full file path.
> >>> More specifically about TST implementation in your paches. One global
> >>> per-map lock I think is a very big downside. We have LPM trie which is
> >>> very slow in big part due to global lock. It might be possible to
> >>> design more granular schema for TST, but this whole in-place splitting
> >>> logic makes this harder. I think qp-trie can be locked in a granular
> >>> fashion much more easily by having a "hand over hand" locking: lock
> >>> parent, find child, lock child, unlock parent, move into child node.
> >>> Something like that would be more scalable overall, especially if the
> >>> access pattern is not focused on a narrow set of nodes.
> >> Yes. The global lock is a problem but the splitting is not in-place. I will try
> >> to figure out whether the lock can be more scalable after the benchmark test
> >> between qp-trie and tst.
> > Great, looking forward!
> >
> >> Regards,
> >> Tao
> >>
> >> [0]: https://github.com/Tessil/hat-trie
> >>> Anyways, I love data structures and this one is an interesting idea.
> >>> But just my few cents of "production-readiness" for general-purpose
> >>> data structures for BPF.
> >>>
> >>>   [0] https://dotat.at/prog/qp/README.html
> >>>
> >>>> Regards,
> >>>> Tao
> >>>>
> >>>> [1]: https://lore.kernel.org/bpf/CAADnVQJUJp3YBcpESwR3Q1U6GS1mBM=Vp-qYuQX7eZOaoLjdUA@mail.gmail.com/
> >>>>
> >>>> Hou Tao (2):
> >>>>   bpf: Introduce ternary search tree for string key
> >>>>   selftests/bpf: add benchmark for ternary search tree map
> >>>>
> >>>>  include/linux/bpf_types.h                     |   1 +
> >>>>  include/uapi/linux/bpf.h                      |   1 +
> >>>>  kernel/bpf/Makefile                           |   1 +
> >>>>  kernel/bpf/bpf_tst.c                          | 411 +++++++++++++++++
> >>>>  tools/include/uapi/linux/bpf.h                |   1 +
> >>>>  tools/testing/selftests/bpf/Makefile          |   5 +-
> >>>>  tools/testing/selftests/bpf/bench.c           |   6 +
> >>>>  .../selftests/bpf/benchs/bench_tst_map.c      | 415 ++++++++++++++++++
> >>>>  .../selftests/bpf/benchs/run_bench_tst.sh     |  54 +++
> >>>>  tools/testing/selftests/bpf/progs/tst_bench.c |  70 +++
> >>>>  10 files changed, 964 insertions(+), 1 deletion(-)
> >>>>  create mode 100644 kernel/bpf/bpf_tst.c
> >>>>  create mode 100644 tools/testing/selftests/bpf/benchs/bench_tst_map.c
> >>>>  create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_tst.sh
> >>>>  create mode 100644 tools/testing/selftests/bpf/progs/tst_bench.c
> >>>>
> >>>> --
> >>>> 2.31.1
> >>>>
> >>> .
> > .
>
