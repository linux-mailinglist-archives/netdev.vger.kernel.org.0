Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C420575049
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 16:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiGNOF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 10:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbiGNOFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 10:05:24 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DBCE64
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:05:22 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so2481346fac.13
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 07:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JfRxTplyI2lwcDYa7TQ/LwlPYc7ao8mlAURfNnoAxIo=;
        b=rBTrosycLvk+1V4f2mxhgpTvUG58x89AhdZb2kAiIsF/Ia5l15xYX6MmU5pskwNaCZ
         uzF+uuVtzmxbm0RuhJCt3bC6GgGxVz1l+u6FIRuDCPHDOCERQd3Be+SNwBY+RJObKxof
         XPngSO3ka7RQdCMB4lnjLcPCNJ7kzRijxWTfS49+CNPRGGVM5nVLu/8nXyrNBLdwPqDb
         cyyrGnniTe2dMlJhRmvhna4Bj8B2Jm9UtrfcCyyCbt8ROAOb2KcxGpHmgNIPFILK91Le
         h/zNvRiq11/CmvNh0/7UlPhM/ZgXI6HPPacmCOFXt5N9n2Z+vx9MvsRvKMV+xn4k+66a
         CKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JfRxTplyI2lwcDYa7TQ/LwlPYc7ao8mlAURfNnoAxIo=;
        b=Kw77LkHochALxch97mwShyKJ21zaCsEsZ8p8HE6XeiL3gsrfPmh2ZskhiajuCL/9VC
         JxouU6zoR6JBrpqKE0MdyrNlTBIToNg/p9IwHsmszZCgB8K7kChWZ6azL0DKtdbkacJN
         OlYnB6Hw81UGOXsVMbhIlWTe3geRDVhso06Jp1LLxJliNapCS6qgYq2PpT30bWKLiu6Y
         vPA6imJ992n4B9KA4yrORS3hxY3Uc9+D2WOWm0/p/NVYLGMH29iG9Uq+x/p4SY8WItdh
         Hlcuti1Hg4jIElOvgvt0lsbR0FfE80T9Z7Hi1BCJB3f3leVre94vKYUK111A6y+z+vJP
         G6Rw==
X-Gm-Message-State: AJIora8wYoMWib6F6Vb8wQVsiZ6V7t7hf0oiXdGAfHFn59kgX4Oft3JZ
        59x2njnnXTpH+Q0Ddi+EeJE1vJwtEYJO6Otrpj3ykA==
X-Google-Smtp-Source: AGRyM1vzrhcbSQV0vt9ujV6aOUD8gsa84NETCdOZ1UoZqgyUdT9IjkD1J+doRyLQMes74F1zGQeOydXql8zYJPcCOhw=
X-Received: by 2002:a05:6870:a191:b0:10b:f366:8d1b with SMTP id
 a17-20020a056870a19100b0010bf3668d1bmr4472273oaf.2.1657807520679; Thu, 14 Jul
 2022 07:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220713111430.134810-1-toke@redhat.com>
In-Reply-To: <20220713111430.134810-1-toke@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 14 Jul 2022 10:05:09 -0400
Message-ID: <CAM0EoM=Pz_EWHsWzVZkZfojoRyUgLPVhGRHq6aGVhdcLC2YvHw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] xdp: Add packet queueing and scheduling capabilities
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Mykola Lysenko <mykolal@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think what would be really interesting is to see the performance numbers =
when
you have multiple producers/consumers(translation multiple
threads/softirqs) in play
targeting the same queues. Does PIFO alleviate the synchronization challeng=
e
when you have multiple concurrent readers/writers? Or maybe for your use ca=
se
this would not be a common occurrence or not something you care about?

As I mentioned previously, I think this is what Cong's approach gets for fr=
ee.

cheers,
jamal


cheers,
jamal

On Wed, Jul 13, 2022 at 7:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Packet forwarding is an important use case for XDP, which offers
> significant performance improvements compared to forwarding using the
> regular networking stack. However, XDP currently offers no mechanism to
> delay, queue or schedule packets, which limits the practical uses for
> XDP-based forwarding to those where the capacity of input and output link=
s
> always match each other (i.e., no rate transitions or many-to-one
> forwarding). It also prevents an XDP-based router from doing any kind of
> traffic shaping or reordering to enforce policy.
>
> This series represents a first RFC of our attempt to remedy this lack. Th=
e
> code in these patches is functional, but needs additional testing and
> polishing before being considered for merging. I'm posting it here as an
> RFC to get some early feedback on the API and overall design of the
> feature.
>
> DESIGN
>
> The design consists of three components: A new map type for storing XDP
> frames, a new 'dequeue' program type that will run in the TX softirq to
> provide the stack with packets to transmit, and a set of helpers to deque=
ue
> packets from the map, optionally drop them, and to schedule an interface
> for transmission.
>
> The new map type is modelled on the PIFO data structure proposed in the
> literature[0][1]. It represents a priority queue where packets can be
> enqueued in any priority, but is always dequeued from the head. From the
> XDP side, the map is simply used as a target for the bpf_redirect_map()
> helper, where the target index is the desired priority.
>
> The dequeue program type is a new BPF program type that is attached to an
> interface; when an interface is scheduled for transmission, the stack wil=
l
> execute the attached dequeue program and, if it returns a packet to
> transmit, that packet will be transmitted using the existing ndo_xdp_xmit=
()
> driver function.
>
> The dequeue program can obtain packets by pulling them out of a PIFO map
> using the new bpf_packet_dequeue() helper. This returns a pointer to an
> xdp_md structure, which can be dereferenced to obtain packet data and
> data_meta pointers like in an XDP program. The returned packets are also
> reference counted, meaning the verifier enforces that the dequeue program
> either drops the packet (with the bpf_packet_drop() helper), or returns i=
t
> for transmission. Finally, a helper is added that can be used to actually
> schedule an interface for transmission using the dequeue program type; th=
is
> helper can be called from both XDP and dequeue programs.
>
> PERFORMANCE
>
> Preliminary performance tests indicate about 50ns overhead of adding
> queueing to the xdp_fwd example (last patch), which translates to a 20% P=
PS
> overhead (but still 2x the forwarding performance of the netstack):
>
> xdp_fwd :     4.7 Mpps  (213 ns /pkt)
> xdp_fwd -Q:   3.8 Mpps  (263 ns /pkt)
> netstack:       2 Mpps  (500 ns /pkt)
>
> RELATION TO BPF QDISC
>
> Cong Wang's BPF qdisc patches[2] share some aspects of this series, in
> particular the use of a map to store packets. This is no accident, as we'=
ve
> had ongoing discussions for a while now. I have no great hope that we can
> completely converge the two efforts into a single BPF-based queueing
> API (as has been discussed before[3], consolidating the SKB and XDP paths
> is challenging). Rather, I'm hoping that we can converge the designs enou=
gh
> that we can share BPF code between XDP and qdisc layers using common
> functions, like it's possible to do with XDP and TC-BPF today. This would
> imply agreeing on the map type and API, and possibly on the set of helper=
s
> available to the BPF programs.
>
> PATCH STRUCTURE
>
> This series consists of a total of 17 patches, as follows:
>
> Patches 1-3 are smaller preparatory refactoring patches used by subsequen=
t
> patches.
>
> Patches 4-5 introduce the PIFO map type, and patch 6 introduces the deque=
ue
> program type.
>
> Patches 7-10 adds the dequeue helpers and the verifier features needed to
> recognise packet pointers, reference count them, and allow dereferencing
> them to obtain packet data pointers.
>
> Patches 11 and 12 add the dequeue program hook to the TX path, and the
> helpers to schedule an interface.
>
> Patches 13-16 add libbpf support for the new types, and selftests for the
> new features.
>
> Finally, patch 17 adds queueing support to the xdp_fwd program in
> samples/bpf to provide an easy-to-use way of testing the feature; this is
> for illustrative purposes for the RFC only, and will not be included in t=
he
> final submission.
>
> SUPPLEMENTARY MATERIAL
>
> A (WiP) test harness for implementing and unit-testing scheduling
> algorithms using this framework (and the bpf_prog_run() hook) is availabl=
e
> as part of the bpf-examples repository[4]. We plan to expand this with mo=
re
> test algorithms to smoke-test the API, and also add ready-to-use queueing
> algorithms for use for forwarding (to replace the xdp_fwd patch included =
as
> part of this RFC submission).
>
> The work represented in this series was done in collaboration with severa=
l
> people. Thanks to Kumar Kartikeya Dwivedi for writing the verifier
> enhancements in this series, to Frey Alfredsson for his work on the testi=
ng
> harness in [4], and to Jesper Brouer, Per Hurtig and Anna Brunstrom for
> their valuable input on the design of the queueing APIs.
>
> This series is also available as a git tree on git.kernel.org[5].
>
> NOTES
>
> [0] http://web.mit.edu/pifo/
> [1] https://arxiv.org/abs/1810.03060
> [2] https://lore.kernel.org/r/20220602041028.95124-1-xiyou.wangcong@gmail=
.com
> [3] https://lore.kernel.org/r/b4ff6a2b-1478-89f8-ea9f-added498c59f@gmail.=
com
> [4] https://github.com/xdp-project/bpf-examples/pull/40
> [5] https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=
=3Dxdp-queueing-06
>
> Kumar Kartikeya Dwivedi (5):
>   bpf: Use 64-bit return value for bpf_prog_run
>   bpf: Teach the verifier about referenced packets returned from dequeue
>     programs
>   bpf: Introduce pkt_uid member for PTR_TO_PACKET
>   bpf: Implement direct packet access in dequeue progs
>   selftests/bpf: Add verifier tests for dequeue prog
>
> Toke H=C3=B8iland-J=C3=B8rgensen (12):
>   dev: Move received_rps counter next to RPS members in softnet data
>   bpf: Expand map key argument of bpf_redirect_map to u64
>   bpf: Add a PIFO priority queue map type
>   pifomap: Add queue rotation for continuously increasing rank mode
>   xdp: Add dequeue program type for getting packets from a PIFO
>   bpf: Add helpers to dequeue from a PIFO map
>   dev: Add XDP dequeue hook
>   bpf: Add helper to schedule an interface for TX dequeue
>   libbpf: Add support for dequeue program type and PIFO map type
>   libbpf: Add support for querying dequeue programs
>   selftests/bpf: Add test for XDP queueing through PIFO maps
>   samples/bpf: Add queueing support to xdp_fwd sample
>
>  include/linux/bpf-cgroup.h                    |  12 +-
>  include/linux/bpf.h                           |  64 +-
>  include/linux/bpf_types.h                     |   4 +
>  include/linux/bpf_verifier.h                  |  14 +-
>  include/linux/filter.h                        |  63 +-
>  include/linux/netdevice.h                     |   8 +-
>  include/net/xdp.h                             |  16 +-
>  include/uapi/linux/bpf.h                      |  50 +-
>  include/uapi/linux/if_link.h                  |   4 +-
>  kernel/bpf/Makefile                           |   2 +-
>  kernel/bpf/cgroup.c                           |  12 +-
>  kernel/bpf/core.c                             |  14 +-
>  kernel/bpf/cpumap.c                           |   4 +-
>  kernel/bpf/devmap.c                           |  92 ++-
>  kernel/bpf/offload.c                          |   4 +-
>  kernel/bpf/pifomap.c                          | 635 ++++++++++++++++++
>  kernel/bpf/syscall.c                          |   3 +
>  kernel/bpf/verifier.c                         | 148 +++-
>  net/bpf/test_run.c                            |  54 +-
>  net/core/dev.c                                | 109 +++
>  net/core/dev.h                                |   2 +
>  net/core/filter.c                             | 307 ++++++++-
>  net/core/rtnetlink.c                          |  30 +-
>  net/packet/af_packet.c                        |   7 +-
>  net/xdp/xskmap.c                              |   4 +-
>  samples/bpf/xdp_fwd_kern.c                    |  65 +-
>  samples/bpf/xdp_fwd_user.c                    | 200 ++++--
>  tools/include/uapi/linux/bpf.h                |  48 ++
>  tools/include/uapi/linux/if_link.h            |   4 +-
>  tools/lib/bpf/libbpf.c                        |   1 +
>  tools/lib/bpf/libbpf.h                        |   1 +
>  tools/lib/bpf/libbpf_probes.c                 |   5 +
>  tools/lib/bpf/netlink.c                       |   8 +
>  .../selftests/bpf/prog_tests/pifo_map.c       | 125 ++++
>  .../bpf/prog_tests/xdp_pifo_test_run.c        | 154 +++++
>  tools/testing/selftests/bpf/progs/pifo_map.c  |  54 ++
>  .../selftests/bpf/progs/test_xdp_pifo.c       | 110 +++
>  tools/testing/selftests/bpf/test_verifier.c   |  29 +-
>  .../testing/selftests/bpf/verifier/dequeue.c  | 160 +++++
>  39 files changed, 2426 insertions(+), 200 deletions(-)
>  create mode 100644 kernel/bpf/pifomap.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/pifo_map.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_pifo_test_=
run.c
>  create mode 100644 tools/testing/selftests/bpf/progs/pifo_map.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_pifo.c
>  create mode 100644 tools/testing/selftests/bpf/verifier/dequeue.c
>
> --
> 2.37.0
>
