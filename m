Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079B83B1078
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 01:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhFVXVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 19:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhFVXVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 19:21:03 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED5AC061574;
        Tue, 22 Jun 2021 16:18:46 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id x12so854241ill.4;
        Tue, 22 Jun 2021 16:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=cFqGAsTTTlJTGo4Tx1GsFKqcvbYIFd9qzMiM4bxZi+E=;
        b=Inq83SyMqHb2rnJTKgcp1zamj8srmO7j+VvR8l/HGtc21sOGG4TjZQjFaydtDTYi4j
         S8kpEZpr9EU6W/ATjYnefNt1MZpgWWpo++gMAuqpnERlRCXaWJ4JlQv1dxkBtxVjDAwo
         2QCOmx9HFlqRo5OJpX0gl5ZideKl5pIJUAHxvooaaONVnAqbXYHawc/sJ4Tqua7KDy+I
         N0dn+04fgKPW5CXULyWFcn6lJ5dK+IvMM5lUlDA1R3J7Y3aZqiT/AKTt+w7+/r8SFUtC
         8xQfFinlFBJlLyLW7nfvF5BuEHtP667b4UOMZlObeQmNtYq5XmJQ3GpaQHycoDIDKvq4
         rAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=cFqGAsTTTlJTGo4Tx1GsFKqcvbYIFd9qzMiM4bxZi+E=;
        b=Gc6jj6N1r27PYYrZJKYtl/8s9nOkfKt07nqGOMuZzARwP/+g94ZA+cl2+so7aTAHE5
         6Kc9uJvLXGDmNCUO0NeykmDAVyWtzqA+8x/UlWJwKAsvujZDVVPtOTMr2WpJn0n2YNed
         3/UEzNFuTITG1Rcl7bFdaMQoanmrxuHno6Ooa1Iqi/a+SS/hZkCbqQ3Nvvku9/2yf3oO
         s+Nrs1EDpw7+37Ttunu0EygSJYtyKLDmCiYzqlBGwSh7AG3rXH75DCC0y+6dB0S/p8EL
         hpmEey/OloF94LOGxomc8+15TRz/yC40IHNh8M8PzfO0Jd/yyvR4ivAiutU+dBZn1Vaa
         XHsw==
X-Gm-Message-State: AOAM533Z/vR0QRoiZXcwK+opnzcvTkAod6PLfD8B/YDVSLAC25mn4Tx7
        F7Xd1iC07AfgOR1SVnxTb7k=
X-Google-Smtp-Source: ABdhPJwgUWoMb2MEX8lfjJMNd/5lKCtijBNucSP+p0heYixyalJ5gkyx0U3Oo5O6gXhyjpKKgyyKkQ==
X-Received: by 2002:a92:c0ca:: with SMTP id t10mr768476ilf.241.1624403925764;
        Tue, 22 Jun 2021 16:18:45 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id m184sm7272630ioa.17.2021.06.22.16.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 16:18:45 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:18:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d26fcdbd5c7_1342e208f6@john-XPS-13-9370.notmuch>
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
Subject: RE: [PATCH v9 bpf-next 00/14] mvneta: introduce XDP multi-buffer
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

> For now, to keep the design simple and to maintain performance, the XDP=

> BPF-prog (still) only have access to the first-buffer. It is left for
> later (another patchset) to add payload access across multiple buffers.=

> This patchset should still allow for these future extensions. The goal
> is to lift the XDP MTU restriction that comes with XDP, but maintain
> same performance as before.

At this point I don't think we can have a partial implementation. At
the moment we have packet capture applications and protocol parsers
running in production. If we allow this to go in staged we are going
to break those applications that make the fundamental assumption they
have access to all the data in the packet.

There will be no way to fix it when it happens. The teams running the
applications wont necessarily be able to change the network MTU. Now
it doesn't work, hard stop. This is better than it sort of works some
of the time. Worse if we get in a situation where some drivers support
partial access and others support full access the support matrix gets wor=
se.

I think we need to get full support and access to all bytes. I believe
I said this earlier, but now we've deployed apps that really do need
access to the payloads so its not a theoritical concern anymore, but
rather a real one based on deployed BPF programs.

> =

> The main idea for the new multi-buffer layout is to reuse the same
> layout used for non-linear SKB. This rely on the "skb_shared_info"
> struct at the end of the first buffer to link together subsequent
> buffers. Keeping the layout compatible with SKBs is also done to ease
> and speedup creating an SKB from an xdp_{buff,frame}.
> Converting xdp_frame to SKB and deliver it to the network stack is show=
n
> in patch 07/14 (e.g. cpumaps).
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

> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> - TSO
> =

> A new bpf helper (bpf_xdp_get_buff_len) has been introduce in order to =
notify
> the eBPF layer about the total frame size (linear + paged parts).

Is it possible to make currently working programs continue to work?
For a simple packet capture example a program might capture the
entire packet of bytes '(data_end - data_start)'. With above implementati=
on
the program will continue to run, but will no longer be capturing
all the bytes... so its a silent failure. Otherwise I'll need to
backport fixes into my BPF programs and releases to ensure they
don't walk onto a new kernel with multi-buffer support enabled.
Its not ideal.

> =

> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take=
 into
> account xdp multi-buff frames.
> =

> More info about the main idea behind this approach can be found here [1=
][2].

Will read [1],[2].

Where did the perf data for the 40gbps NIC go? I think we want that
done again on this series with at least 40gbps NICs and better
yet 100gbps drivers. If its addressed in a patch commit message
I'm reading the series now.

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

> Lorenzo Bianconi (11):
>   net: skbuff: add data_len field to skb_shared_info
>   xdp: introduce flags field in xdp_buff/xdp_frame
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF laye=
r
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   net: mvneta: enable jumbo frames for XDP
>   net: xdp: add multi-buff support to xdp_build_skb_from_frame
>   bpf: introduce bpf_xdp_get_buff_len helper
>   bpf: move user_size out of bpf_test_init
>   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
>   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
>     signature
> =

>  drivers/net/ethernet/marvell/mvneta.c         | 143 ++++++++++------
>  include/linux/skbuff.h                        |   5 +-
>  include/net/xdp.h                             |  56 ++++++-
>  include/uapi/linux/bpf.h                      |   7 +
>  kernel/trace/bpf_trace.c                      |   3 +
>  net/bpf/test_run.c                            | 108 +++++++++---
>  net/core/filter.c                             | 157 +++++++++++++++++-=

>  net/core/xdp.c                                |  72 +++++++-
>  tools/include/uapi/linux/bpf.h                |   7 +
>  .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++++
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 +++++++++-----
>  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
>  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 +++-
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>  14 files changed, 705 insertions(+), 129 deletions(-)
> =

> -- =

> 2.31.1
> =



