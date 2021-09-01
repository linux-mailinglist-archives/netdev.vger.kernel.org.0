Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3C3FD065
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 02:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbhIAAqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238552AbhIAAqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 20:46:15 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABD3C061575;
        Tue, 31 Aug 2021 17:45:19 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id y3so1621939ilm.6;
        Tue, 31 Aug 2021 17:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=h/3ruHK47wGgH29dqx//nD0QIAx1W3jYuGsHHornQ6k=;
        b=FAy8iImR0vUypj1oQOML7EovULhgEx87lnozkts3Ku5wdCy+cT8eeugfQYHvi3nbp8
         ET5WyIwpKXX16Yut/gqYtswgVvpCNwKGHbBh3vjTkR3X0aSMSrYgbqV4zCVPoNCsNQ7p
         ELcJ8HHhvaEpSXtYPzm1T+O0lJ93setV0M32yPldWo5Fn1pwhcJT6nhDw3J93fTndEgR
         3PMzvfKZBHZQIGWQkLRFWFKVYNCGpV9r2NKV4N2JWomiJN43yNA1SrLG+2d5eBurKByu
         sh4YHJjhoCFWL5aBDaVTubhQq4/IA8fryS/PPJTiXDI5sYjqC7VCr8LbZtZoklAVpOzo
         6Zlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=h/3ruHK47wGgH29dqx//nD0QIAx1W3jYuGsHHornQ6k=;
        b=aSJZht0gbUlZ3GE6OSTRyEQTWQ57Cf+dP3+HcdaJx654wVkEC0dw4SbzSjoCAKKYrn
         6locrn9I2hn7I/IqTn3OA+VjX66GnYQDtLjM/y8kaQ8VDe0OsQpNEUwSO60QKmq993IC
         fjdvrRfzWIwsPK5xlBGNNZlujpqEA3U9UapWZ1Jf7fBR0o7VQkFKMYErqCNuwIpULneb
         jQ/1L3t05wvQW1g5OwSPqgY1r7JAFBaXd7Q8WDDqDIXegOI5zp3Lg9+U4VZcVazzE3Sv
         o7CTIFAOlVeNmRR7dIx/KEC6FmHOL3lTyqhXGdVa6BV4vy5Ssuf+qdEZXoIj/Ll1lZ3h
         b9kg==
X-Gm-Message-State: AOAM533X1TpEQtFuni1A2N+gXvO3LFV3Vn3eZN2KGA3zgySTk4tS9+Uc
        esqyasJNDZfOShE/rHp0hcQ=
X-Google-Smtp-Source: ABdhPJzhHbfs/Z+9p03bgprO2sAhUTzSBqKMs6TR+4OM/PQ8W9OtGGabtE1wuSKaZGe8j/AVY5pZLA==
X-Received: by 2002:a92:870f:: with SMTP id m15mr22867161ild.2.1630457118586;
        Tue, 31 Aug 2021 17:45:18 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id z16sm11131312ile.72.2021.08.31.17.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:45:17 -0700 (PDT)
Date:   Tue, 31 Aug 2021 17:45:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ecd169d9c7_6b87208d7@john-XPS-13-9370.notmuch>
In-Reply-To: <cover.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers=

> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
> =

> The main idea for the new multi-buffer layout is to reuse the same
> structure used for non-linear SKB. This rely on the "skb_shared_info"
> struct at the end of the first buffer to link together subsequent
> buffers. Keeping the layout compatible with SKBs is also done to ease
> and speedup creating a SKB from an xdp_{buff,frame}.
> Converting xdp_frame to SKB and deliver it to the network stack is show=
n
> in patch 05/18 (e.g. cpumaps).
> =

> A multi-buffer bit (mb) has been introduced in the flags field of xdp_{=
buff,frame}
> structure to notify the bpf/network layer if this is a xdp multi-buffer=
 frame
> (mb =3D 1) or not (mb =3D 0).
> The mb bit will be set by a xdp multi-buffer capable driver only for
> non-linear frames maintaining the capability to receive linear frames
> without any extra cost since the skb_shared_info structure at the end
> of the first buffer will be initialized only if mb is set.
> Moreover the flags field in xdp_{buff,frame} will be reused even for
> xdp rx csum offloading in future series.
> =


The series is looking really close to me. Couple small comments/questions=

inline. Also I think we should call out the potential issues in the cover=

letter with regards to backwards compatibility. Something like, =


"
A multi-buffer enabled NIC may receive XDP frames with multiple frags.
If a BPF program does not understand mb layouts its possible to contrive
a BPF program that incorrectly views data_end as the end of data when
there is more data in the payload. Note helpers will generally due the
correct thing, for example perf_output will consume entire payload. But,
it is still possible some programs could do the wrong thing even if in
an edge case. Although we expect most BPF programs not to be impacted
we can't rule out, you've been warned.
"

I can't think of an elegant way around this and it does require at least
some type of opt-in by increasing the MTU limit so I'm OK with it given
I think it should impact few (no?) real programs.

> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> - TSO/GRO
> =

> The two following ebpf helpers (and related selftests) has been introdu=
ced:
> - bpf_xdp_adjust_data:
>   Move xdp_md->data and xdp_md->data_end pointers in subsequent fragmen=
ts
>   according to the offset provided by the ebpf program. This helper can=
 be
>   used to read/write values in frame payload.
> - bpf_xdp_get_buff_len:
>   Return the total frame size (linear + paged parts)
> =

> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take=
 into
> account xdp multi-buff frames.
> =

> More info about the main idea behind this approach can be found here [1=
][2].
> =

> Changes since v11:
> - add missing static to bpf_xdp_get_buff_len_proto structure
> - fix bpf_xdp_adjust_data helper when offset is smaller than linear are=
a length.
> =

> Changes since v10:
> - move xdp->data to the requested payload offset instead of to the begi=
nning of
>   the fragment in bpf_xdp_adjust_data()
> =

> Changes since v9:
> - introduce bpf_xdp_adjust_data helper and related selftest
> - add xdp_frags_size and xdp_frags_tsize fields in skb_shared_info
> - introduce xdp_update_skb_shared_info utility routine in ordere to not=
 reset
>   frags array in skb_shared_info converting from a xdp_buff/xdp_frame t=
o a skb =

> - simplify bpf_xdp_copy routine
> =

> Changes since v8:
> - add proper dma unmapping if XDP_TX fails on mvneta for a xdp multi-bu=
ff
> - switch back to skb_shared_info implementation from previous xdp_share=
d_info
>   one
> - avoid using a bietfield in xdp_buff/xdp_frame since it introduces per=
formance
>   regressions. Tested now on 10G NIC (ixgbe) to verify there are no per=
formance
>   penalties for regular codebase
> - add bpf_xdp_get_buff_len helper and remove frame_length field in xdp =
ctx
> - add data_len field in skb_shared_info struct
> - introduce XDP_FLAGS_FRAGS_PF_MEMALLOC flag
> =

> Changes since v7:
> - rebase on top of bpf-next
> - fix sparse warnings
> - improve comments for frame_length in include/net/xdp.h
> =

> Changes since v6:
> - the main difference respect to previous versions is the new approach =
proposed
>   by Eelco to pass full length of the packet to eBPF layer in XDP conte=
xt
> - reintroduce multi-buff support to eBPF kself-tests
> - reintroduce multi-buff support to bpf_xdp_adjust_tail helper
> - introduce multi-buffer support to bpf_xdp_copy helper
> - rebase on top of bpf-next
> =

> Changes since v5:
> - rebase on top of bpf-next
> - initialize mb bit in xdp_init_buff() and drop per-driver initializati=
on
> - drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
> - postpone introduction of frame_length field in XDP ctx to another ser=
ies
> - minor changes
> =

> Changes since v4:
> - rebase ontop of bpf-next
> - introduce xdp_shared_info to build xdp multi-buff instead of using th=
e
>   skb_shared_info struct
> - introduce frame_length in xdp ctx
> - drop previous bpf helpers
> - fix bpf_xdp_adjust_tail for xdp multi-buff
> - introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
> - fix xdp_return_frame_bulk for xdp multi-buff
> =

> Changes since v3:
> - rebase ontop of bpf-next
> - add patch 10/13 to copy back paged data from a xdp multi-buff frame t=
o
>   userspace buffer for xdp multi-buff selftests
> =

> Changes since v2:
> - add throughput measurements
> - drop bpf_xdp_adjust_mb_header bpf helper
> - introduce selftest for xdp multibuffer
> - addressed comments on bpf_xdp_get_frags_count
> - introduce xdp multi-buff support to cpumaps
> =

> Changes since v1:
> - Fix use-after-free in xdp_return_{buff/frame}
> - Introduce bpf helpers
> - Introduce xdp_mb sample program
> - access skb_shared_info->nr_frags only on the last fragment
> =

> Changes since RFC:
> - squash multi-buffer bit initialization in a single patch
> - add mvneta non-linear XDP buff support for tx side
> =

> [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-m=
tu-and-rx-zerocopy
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-=
to-a-NIC-driver (XDPmulti-buffers section)
> =

> Eelco Chaudron (3):
>   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
>   bpf: add multi-buffer support to xdp copy helpers
>   bpf: update xdp_adjust_tail selftest to include multi-buffer
> =

> Lorenzo Bianconi (15):
>   net: skbuff: add size metadata to skb_shared_info for xdp
>   xdp: introduce flags field in xdp_buff/xdp_frame
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF laye=
r
>   net: mvneta: simplify mvneta_swbm_add_rx_fragment management
>   net: xdp: add xdp_update_skb_shared_info utility routine
>   net: marvell: rely on xdp_update_skb_shared_info utility routine
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   net: mvneta: enable jumbo frames for XDP
>   bpf: introduce bpf_xdp_get_buff_len helper
>   bpf: move user_size out of bpf_test_init
>   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
>   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
>     signature
>   net: xdp: introduce bpf_xdp_adjust_data helper
>   bpf: add bpf_xdp_adjust_data selftest
> =

>  drivers/net/ethernet/marvell/mvneta.c         | 204 ++++++++++-------
>  include/linux/skbuff.h                        |   6 +-
>  include/net/xdp.h                             |  95 +++++++-
>  include/uapi/linux/bpf.h                      |  39 ++++
>  kernel/trace/bpf_trace.c                      |   3 +
>  net/bpf/test_run.c                            | 117 ++++++++--
>  net/core/filter.c                             | 213 +++++++++++++++++-=

>  net/core/xdp.c                                |  76 ++++++-
>  tools/include/uapi/linux/bpf.h                |  39 ++++
>  .../bpf/prog_tests/xdp_adjust_data.c          |  55 +++++
>  .../bpf/prog_tests/xdp_adjust_tail.c          | 118 ++++++++++
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++++----
>  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
>  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>  .../bpf/progs/test_xdp_update_frags.c         |  41 ++++
>  16 files changed, 1036 insertions(+), 165 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_d=
ata.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_f=
rags.c
> =

> -- =

> 2.31.1
> =



