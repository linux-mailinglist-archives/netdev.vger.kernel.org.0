Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EA9362232
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 16:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhDPO15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 10:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235814AbhDPO1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 10:27:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8450C061574;
        Fri, 16 Apr 2021 07:27:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u15so5516207plf.10;
        Fri, 16 Apr 2021 07:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rfVSAU7w1TUjJHnly91DDtvcNAkvESAcAghYh02RrtY=;
        b=a2GqMl6VOV2cr5Iedz0kelkhly+8jmMwigfr2QlnO90ZxR0yFrcxXuReV60tCd3+0R
         UQ8HsT9eAIi/cUt8TDAQtdGQGho2ZKZAm5kur3Q6G6MIw0VHzi8Hvcm7fxRzMVftRWhr
         C+W3ixZEb60TI3EE8SWzF0NMBQEBzUFChDoxdASE8QFKKg5g3eVr3pLueMXd7MQvvxmf
         skVNQKgwjz5IAS8BgNclp6G/NJ6mPTADZvi6Iap5UuOnkN6Qv60MX+bjZYnjKcDN+CKc
         5twR5FFr+adjEZg/HNKWAkuFR+0GpoQGzHWaIzPHkXAAsxD65nQm918S0kIJpXwXtYm9
         D/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rfVSAU7w1TUjJHnly91DDtvcNAkvESAcAghYh02RrtY=;
        b=Up/uzhVcEbWJFn+BD19VIxuslO40f+uYcpvit/WGxgef5PK9JLGfzJo+CO5tCLlFGg
         yKzI9iOwJS3fGV3PjYnh9gDY7lMKDnmN4P/x1GmdtxU5GhLxfvqxgOjW/qBwXqZ7/bt6
         d234MUvtkNWSfEg7c1clVx0ZFomPpgrnIKJn8ZYv6gi2yufLpu9DAIUD1JBiqq68CBKD
         6QxL1FH2oDwJCneVOjx8nq22HHnrZC8IhbCC4xRPtQxJwLNlC6bDkrfL89elqvVQ7aq3
         Fs38ZS9Nq+RUcsi26Ytb31dNkRTu56aY4rvDb0egdPWd08QMVlm3OZEBtY9ioqqm7qcn
         2aZQ==
X-Gm-Message-State: AOAM532D5YxmYamX2UYDrxPESSgkQYh3qXIBc6VFdzWio5eHGtAijUiW
        YMvhPd/Sv6WRpNZhrwNhLRyzM56zSUbqPZRunH4=
X-Google-Smtp-Source: ABdhPJzUKgeGp8hm7ihO8O30dTJbi7w6vPbzoNhbgq5TdrF/f3KT8LFKdhuQBcK1dFObMU9uJquCx+9EgkRxeT7UGgU=
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr10271368pjq.117.1618583249205;
 Fri, 16 Apr 2021 07:27:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1617885385.git.lorenzo@kernel.org>
In-Reply-To: <cover.1617885385.git.lorenzo@kernel.org>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 16 Apr 2021 16:27:18 +0200
Message-ID: <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        lorenzo.bianconi@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        sameehj@amazon.com, John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 2:51 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
>
> For now, to keep the design simple and to maintain performance, the XDP
> BPF-prog (still) only have access to the first-buffer. It is left for
> later (another patchset) to add payload access across multiple buffers.
> This patchset should still allow for these future extensions. The goal
> is to lift the XDP MTU restriction that comes with XDP, but maintain
> same performance as before.
>
> The main idea for the new multi-buffer layout is to reuse the same
> layout used for non-linear SKB. We introduced a "xdp_shared_info" data
> structure at the end of the first buffer to link together subsequent buff=
ers.
> xdp_shared_info will alias skb_shared_info allowing to keep most of the f=
rags
> in the same cache-line (while with skb_shared_info only the first fragmen=
t will
> be placed in the first "shared_info" cache-line). Moreover we introduced =
some
> xdp_shared_info helpers aligned to skb_frag* ones.
> Converting xdp_frame to SKB and deliver it to the network stack is shown =
in
> patch 07/14. Building the SKB, the xdp_shared_info structure will be conv=
erted
> in a skb_shared_info one.
>
> A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structure
> to notify the bpf/network layer if this is a xdp multi-buffer frame (mb =
=3D 1)
> or not (mb =3D 0).
> The mb bit will be set by a xdp multi-buffer capable driver only for
> non-linear frames maintaining the capability to receive linear frames
> without any extra cost since the xdp_shared_info structure at the end
> of the first buffer will be initialized only if mb is set.
>
> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=E2=80=99s use-case @ NetDevConf =
0x14, [0])
> - TSO
>
> A new frame_length field has been introduce in XDP ctx in order to notify=
 the
> eBPF layer about the total frame size (linear + paged parts).
>
> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take i=
nto
> account xdp multi-buff frames.
>
> More info about the main idea behind this approach can be found here [1][=
2].
>
> Changes since v7:
> - rebase on top of bpf-next
> - fix sparse warnings
> - improve comments for frame_length in include/net/xdp.h
>
> Changes since v6:
> - the main difference respect to previous versions is the new approach pr=
oposed
>   by Eelco to pass full length of the packet to eBPF layer in XDP context
> - reintroduce multi-buff support to eBPF kself-tests
> - reintroduce multi-buff support to bpf_xdp_adjust_tail helper
> - introduce multi-buffer support to bpf_xdp_copy helper
> - rebase on top of bpf-next
>
> Changes since v5:
> - rebase on top of bpf-next
> - initialize mb bit in xdp_init_buff() and drop per-driver initialization
> - drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
> - postpone introduction of frame_length field in XDP ctx to another serie=
s
> - minor changes
>
> Changes since v4:
> - rebase ontop of bpf-next
> - introduce xdp_shared_info to build xdp multi-buff instead of using the
>   skb_shared_info struct
> - introduce frame_length in xdp ctx
> - drop previous bpf helpers
> - fix bpf_xdp_adjust_tail for xdp multi-buff
> - introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
> - fix xdp_return_frame_bulk for xdp multi-buff
>
> Changes since v3:
> - rebase ontop of bpf-next
> - add patch 10/13 to copy back paged data from a xdp multi-buff frame to
>   userspace buffer for xdp multi-buff selftests
>
> Changes since v2:
> - add throughput measurements
> - drop bpf_xdp_adjust_mb_header bpf helper
> - introduce selftest for xdp multibuffer
> - addressed comments on bpf_xdp_get_frags_count
> - introduce xdp multi-buff support to cpumaps
>
> Changes since v1:
> - Fix use-after-free in xdp_return_{buff/frame}
> - Introduce bpf helpers
> - Introduce xdp_mb sample program
> - access skb_shared_info->nr_frags only on the last fragment
>
> Changes since RFC:
> - squash multi-buffer bit initialization in a single patch
> - add mvneta non-linear XDP buff support for tx side
>
> [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu=
-and-rx-zerocopy
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp=
-multi-buffer01-design.org
> [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to=
-a-NIC-driver (XDPmulti-buffers section)

Took your patches for a test run with the AF_XDP sample xdpsock on an
i40e card and the throughput degradation is between 2 to 6% depending
on the setup and microbenchmark within xdpsock that is executed. And
this is without sending any multi frame packets. Just single frame
ones. Tirtha made changes to the i40e driver to support this new
interface so that is being included in the measurements.

What performance do you see with the mvneta card? How much are we
willing to pay for this feature when it is not being used or can we in
some way selectively turn it on only when needed?

Thanks: Magnus

> Eelco Chaudron (4):
>   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
>   bpd: add multi-buffer support to xdp copy helpers
>   bpf: add new frame_length field to the XDP ctx
>   bpf: update xdp_adjust_tail selftest to include multi-buffer
>
> Lorenzo Bianconi (10):
>   xdp: introduce mb in xdp_buff/xdp_frame
>   xdp: add xdp_shared_info data structure
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   net: mvneta: enable jumbo frames for XDP
>   net: xdp: add multi-buff support to xdp_build_skb_from_fram
>   bpf: move user_size out of bpf_test_init
>   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
>   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
>     signature
>
>  drivers/net/ethernet/marvell/mvneta.c         | 182 ++++++++++--------
>  include/linux/filter.h                        |   7 +
>  include/net/xdp.h                             | 105 +++++++++-
>  include/uapi/linux/bpf.h                      |   1 +
>  net/bpf/test_run.c                            | 109 +++++++++--
>  net/core/filter.c                             | 134 ++++++++++++-
>  net/core/xdp.c                                | 103 +++++++++-
>  tools/include/uapi/linux/bpf.h                |   1 +
>  .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++----
>  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  17 +-
>  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   3 +-
>  13 files changed, 767 insertions(+), 159 deletions(-)
>
> --
> 2.30.2
>
