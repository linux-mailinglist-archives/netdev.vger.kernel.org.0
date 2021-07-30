Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7A3DC16A
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhG3XA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhG3XA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 19:00:27 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BF8C0613D3;
        Fri, 30 Jul 2021 16:00:20 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id x192so18588685ybe.0;
        Fri, 30 Jul 2021 16:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G03xh2kAEbzlimx7cJbVe+bLXkoyZqrXclrus0q2F4E=;
        b=MIaoNMVH6LJl09DjX0vC5H8SNneLdqQcfNsc80BvzBlZkKoC2DtrvschrDusLA0gfQ
         qkN9pjKZYagMu/Eyzfcl8IaG/Y9mkpeblkfRi4S0alFUFD3cmEC5a4tJhz3N2kn8Bz2V
         sGHgkvXGTUDNqCbvWENL9d7n1DYBW9PsBi18cMnnb+1qGUBLYHlFK6ixCEENvk524gRP
         jzcVgdabhqC6aONuKuS9I6hsIJxnTFuwoai2RyP95bfFkwWeNPeArbYeySwTswi+AHkt
         /FZkKF1zTns6MS7b8xiaSYHlwbtCivL4Y+pDPawp4dGkcBzInvhVbUeQRYkA7UOezb6l
         BwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G03xh2kAEbzlimx7cJbVe+bLXkoyZqrXclrus0q2F4E=;
        b=hcm8GKM5jie2qfHSQMJNqTmiRS1Uqo5USmLw9Bm4qz0xyBv8qrKGpkgMm6zVIdFSJz
         RMr11ObmvrU2ca5Cert005UBN52XEejjm2UzXO3K9pTy8zaZ3GgM6SytRhkS1lCG+fCv
         jgbBFJI1Lr8AGnSgsL/DJo1wIdm8f5G+5gRxj3EIziMcLFWqy23liTecaIJKdemDo3Th
         cpAEeyORhk/gq6e1AfF3rEKB7frgbMDU2uh68txmj5zdqd14+YSriCp7KwtP2jeiFVVs
         KzrhN6UAT1W7aNn0OHW3254yb0CfzL6uTyCCQQ4fxkydWsHhkFNGAHVx2o17WAFaBhR7
         tLOQ==
X-Gm-Message-State: AOAM530vJLPEvKAYmwvpedYgRahfq+boJfy1aSUcchOREXscArhgi5B3
        aKWbXpSCZAmTxdWjlnPSyEZuXBILIhpUJQ8qPZM=
X-Google-Smtp-Source: ABdhPJzR3hu9wEK1ei/jdw+SsQqgvL2GQEp6u/NefeZQmwQMIWqBVbK/5v3hEAmdh4wIl57oNGwI3op7jJsExO8uYf0=
X-Received: by 2002:a25:9942:: with SMTP id n2mr6411359ybo.230.1627686020211;
 Fri, 30 Jul 2021 16:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1627463617.git.lorenzo@kernel.org> <YQEnsALmUCp2w/fL@lore-desk>
In-Reply-To: <YQEnsALmUCp2w/fL@lore-desk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 16:00:08 -0700
Message-ID: <CAEf4BzYpOxegBwBWAfhn-2eq6DXkph7LiiCNN=HmgqN3ng6hAg@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next 00/18] mvneta: introduce XDP multi-buffer support
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <me@lorenzobianconi.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 2:47 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > From: Lorenzo Bianconi <lorenzo@kernel.org>
> >
> > This series introduce XDP multi-buffer support. The mvneta driver is
> > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > please focus on how these new types of xdp_{buff,frame} packets
> > traverse the different layers and the layout design. It is on purpose
> > that BPF-helpers are kept simple, as we don't want to expose the
> > internal layout to allow later changes.
>
> I sent the cover-letter. Sorry for the noise.
>
> Regards,
> Lorenzo
>
> >
> > The main idea for the new multi-buffer layout is to reuse the same
> > layout used for non-linear SKB. This rely on the "skb_shared_info"
> > struct at the end of the first buffer to link together subsequent
> > buffers. Keeping the layout compatible with SKBs is also done to ease
> > and speedup creating a SKB from an xdp_{buff,frame}.
> > Converting xdp_frame to SKB and deliver it to the network stack is show=
n
> > in patch 05/18 (e.g. cpumaps).
> >
> > A multi-buffer bit (mb) has been introduced in the flags field of xdp_{=
buff,frame}
> > structure to notify the bpf/network layer if this is a xdp multi-buffer=
 frame
> > (mb =3D 1) or not (mb =3D 0).
> > The mb bit will be set by a xdp multi-buffer capable driver only for
> > non-linear frames maintaining the capability to receive linear frames
> > without any extra cost since the skb_shared_info structure at the end
> > of the first buffer will be initialized only if mb is set.
> > Moreover the flags field in xdp_{buff,frame} will be reused even for
> > xdp rx csum offloading in future series.
> >
> > Typical use cases for this series are:
> > - Jumbo-frames
> > - Packet header split (please see Google=E2=80=99s use-case @ NetDevCon=
f 0x14, [0])
> > - TSO
> >
> > The two following ebpf helpers (and related selftests) has been introdu=
ced:
> > - bpf_xdp_adjust_data:
> >   Move xdp_md->data and xdp_md->data_end pointers in subsequent fragmen=
ts
> >   according to the offset provided by the ebpf program. This helper can=
 be
> >   used to read/write values in frame payload.
> > - bpf_xdp_get_buff_len:
> >   Return the total frame size (linear + paged parts)
> >
> > bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take=
 into
> > account xdp multi-buff frames.
> >

Seems like your changes are breaking selftests in no-alu32 mode ([0]).
Please take a look.

  [0] https://github.com/kernel-patches/bpf/runs/3197530080?check_suite_foc=
us=3Dtrue

> > More info about the main idea behind this approach can be found here [1=
][2].
> >
> > Changes since v9:
> > - introduce bpf_xdp_adjust_data helper and related selftest
> > - add xdp_frags_size and xdp_frags_tsize fields in skb_shared_info
> > - introduce xdp_update_skb_shared_info utility routine in ordere to not=
 reset
> >   frags array in skb_shared_info converting from a xdp_buff/xdp_frame t=
o a skb
> > - simplify bpf_xdp_copy routine
> >
> > Changes since v8:
> > - add proper dma unmapping if XDP_TX fails on mvneta for a xdp multi-bu=
ff
> > - switch back to skb_shared_info implementation from previous xdp_share=
d_info
> >   one
> > - avoid using a bietfield in xdp_buff/xdp_frame since it introduces per=
formance
> >   regressions. Tested now on 10G NIC (ixgbe) to verify there are no per=
formance
> >   penalties for regular codebase
> > - add bpf_xdp_get_buff_len helper and remove frame_length field in xdp =
ctx
> > - add data_len field in skb_shared_info struct
> > - introduce XDP_FLAGS_FRAGS_PF_MEMALLOC flag
> >
> > Changes since v7:
> > - rebase on top of bpf-next
> > - fix sparse warnings
> > - improve comments for frame_length in include/net/xdp.h
> >
> > Changes since v6:
> > - the main difference respect to previous versions is the new approach =
proposed
> >   by Eelco to pass full length of the packet to eBPF layer in XDP conte=
xt
> > - reintroduce multi-buff support to eBPF kself-tests
> > - reintroduce multi-buff support to bpf_xdp_adjust_tail helper
> > - introduce multi-buffer support to bpf_xdp_copy helper
> > - rebase on top of bpf-next
> >
> > Changes since v5:
> > - rebase on top of bpf-next
> > - initialize mb bit in xdp_init_buff() and drop per-driver initializati=
on
> > - drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
> > - postpone introduction of frame_length field in XDP ctx to another ser=
ies
> > - minor changes
> >
> > Changes since v4:
> > - rebase ontop of bpf-next
> > - introduce xdp_shared_info to build xdp multi-buff instead of using th=
e
> >   skb_shared_info struct
> > - introduce frame_length in xdp ctx
> > - drop previous bpf helpers
> > - fix bpf_xdp_adjust_tail for xdp multi-buff
> > - introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
> > - fix xdp_return_frame_bulk for xdp multi-buff
> >
> > Changes since v3:
> > - rebase ontop of bpf-next
> > - add patch 10/13 to copy back paged data from a xdp multi-buff frame t=
o
> >   userspace buffer for xdp multi-buff selftests
> >
> > Changes since v2:
> > - add throughput measurements
> > - drop bpf_xdp_adjust_mb_header bpf helper
> > - introduce selftest for xdp multibuffer
> > - addressed comments on bpf_xdp_get_frags_count
> > - introduce xdp multi-buff support to cpumaps
> >
> > Changes since v1:
> > - Fix use-after-free in xdp_return_{buff/frame}
> > - Introduce bpf helpers
> > - Introduce xdp_mb sample program
> > - access skb_shared_info->nr_frags only on the last fragment
> >
> > Changes since RFC:
> > - squash multi-buffer bit initialization in a single patch
> > - add mvneta non-linear XDP buff support for tx side
> >
> > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-m=
tu-and-rx-zerocopy
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-=
to-a-NIC-driver (XDPmulti-buffers section)
> >
> > Eelco Chaudron (3):
> >   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
> >   bpf: add multi-buffer support to xdp copy helpers
> >   bpf: update xdp_adjust_tail selftest to include multi-buffer
> >
> > Lorenzo Bianconi (15):
> >   net: skbuff: add size metadata to skb_shared_info for xdp
> >   xdp: introduce flags field in xdp_buff/xdp_frame
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF laye=
r
> >   net: mvneta: simplify mvneta_swbm_add_rx_fragment management
> >   net: xdp: add xdp_update_skb_shared_info utility routine
> >   net: marvell: rely on xdp_update_skb_shared_info utility routine
> >   xdp: add multi-buff support to xdp_return_{buff/frame}
> >   net: mvneta: add multi buffer support to XDP_TX
> >   net: mvneta: enable jumbo frames for XDP
> >   bpf: introduce bpf_xdp_get_buff_len helper
> >   bpf: move user_size out of bpf_test_init
> >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> >   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
> >     signature
> >   net: xdp: introduce bpf_xdp_adjust_data helper
> >   bpf: add bpf_xdp_adjust_data selftest
> >
> >  drivers/net/ethernet/marvell/mvneta.c         | 213 ++++++++++--------
> >  include/linux/skbuff.h                        |   6 +-
> >  include/net/xdp.h                             |  95 +++++++-
> >  include/uapi/linux/bpf.h                      |  38 ++++
> >  kernel/trace/bpf_trace.c                      |   3 +
> >  net/bpf/test_run.c                            | 117 ++++++++--
> >  net/core/filter.c                             | 210 ++++++++++++++++-
> >  net/core/xdp.c                                |  76 ++++++-
> >  tools/include/uapi/linux/bpf.h                |  38 ++++
> >  .../bpf/prog_tests/xdp_adjust_data.c          |  55 +++++
> >  .../bpf/prog_tests/xdp_adjust_tail.c          | 118 ++++++++++
> >  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++++----
> >  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
> >  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
> >  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
> >  .../bpf/progs/test_xdp_update_frags.c         |  49 ++++
> >  16 files changed, 1044 insertions(+), 169 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_d=
ata.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_f=
rags.c
> >
> > --
> > 2.31.1
> >
