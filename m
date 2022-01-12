Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EC448CB5E
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356347AbiALS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:56:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46936 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356325AbiALS4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:56:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642013762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nR0MkLVySUC2fjV8phVzS8O3npSV6j9wvJSsJEnmePQ=;
        b=cNlTluQmDYFXjQWXR0EILh8emtaGyOjiov0FLFcXHQg2wiUHPGI0DgOr38EIzOgkKYHX1e
        w19xTNEKFZm33EKEvXyx8Zf1xx3Rt2HF/Av1vmqgyO/4HL6/NJbUo2BnsTS+k+VhV83CGG
        XlWu4/dA5EhXJOX4jNEwDv12LXzUrZg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-C1VJYSmfPTCRGK092-t99Q-1; Wed, 12 Jan 2022 13:56:00 -0500
X-MC-Unique: C1VJYSmfPTCRGK092-t99Q-1
Received: by mail-wm1-f71.google.com with SMTP id l20-20020a05600c1d1400b003458e02cea0so4207359wms.7
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 10:56:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nR0MkLVySUC2fjV8phVzS8O3npSV6j9wvJSsJEnmePQ=;
        b=AIbhJwgCVpp0m2pBlEz4DsFZgIz//+Z4Q22qDRNBDs60IJSA0LmKMxb03cx5yxw+nH
         OyBz7AB7zRYyO/rBOO1Mt2Tkqx7eprL+hLI2u56LpoM6H194QyGw9MYmF3wsWKtxe0QR
         XmJn5bZXg5Twp4hq5fr9kqDHPn1mmtdJ8PN02Tblo7TkqebHS24R6LhfJ/X6QURupx9H
         9r1uTfsOzGBxWCErkRWP/9IvzAeOUMSNF3iE+1Rjf6Fq2meykuqXCGyOv8kPZiKB1ks8
         HHTdBWiufDL8QylkyB/4vn7ZOUX1XpuCnYWtOnmlFq8FbRgkjzxIj02lfcotMFXjHePI
         2SQQ==
X-Gm-Message-State: AOAM531lLJWNDeAT+D+YtLqYTifuaxRx6N52HXOmp+AilVHquxONmAbJ
        5zjCsL3TdU/3j4YWyJSvi4qxB0BOhJVbWkOry4dYp6rq7PLC3CrgnKdaTj6a8b1CuZ67fM/MMFk
        ZAH/AEV6cKbZZrQbW
X-Received: by 2002:adf:f14f:: with SMTP id y15mr945926wro.564.1642013759323;
        Wed, 12 Jan 2022 10:55:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTVM969fOR6YU94aoNWyh+/bW+W4If48mBELgrWCN+/5uZ85jMY+0XHSw50tOGJZVlOny67Q==
X-Received: by 2002:adf:f14f:: with SMTP id y15mr945901wro.564.1642013758980;
        Wed, 12 Jan 2022 10:55:58 -0800 (PST)
Received: from localhost (net-93-146-37-237.cust.vodafonedsl.it. [93.146.37.237])
        by smtp.gmail.com with ESMTPSA id m7sm486532wmi.13.2022.01.12.10.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 10:55:58 -0800 (PST)
Date:   Wed, 12 Jan 2022 19:55:56 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v21 bpf-next 00/23] mvneta: introduce XDP multi-buffer
 support
Message-ID: <Yd8kPOsDbv4mJFH9@lore-desk>
References: <cover.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+zvwgDbZTmJG5roI"
Content-Disposition: inline
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+zvwgDbZTmJG5roI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

@Daniel: Alexei reported you have some comments about the series.
Any objections about posting v22?

Regards,
Lorenzo

> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.
>=20
> The main idea for the new multi-buffer layout is to reuse the same
> structure used for non-linear SKB. This rely on the "skb_shared_info"
> struct at the end of the first buffer to link together subsequent
> buffers. Keeping the layout compatible with SKBs is also done to ease
> and speedup creating a SKB from an xdp_{buff,frame}.
> Converting xdp_frame to SKB and deliver it to the network stack is shown
> in patch 05/18 (e.g. cpumaps).
>=20
> A multi-buffer bit (mb) has been introduced in the flags field of xdp_{bu=
ff,frame}
> structure to notify the bpf/network layer if this is a xdp multi-buffer f=
rame
> (mb =3D 1) or not (mb =3D 0).
> The mb bit will be set by a xdp multi-buffer capable driver only for
> non-linear frames maintaining the capability to receive linear frames
> without any extra cost since the skb_shared_info structure at the end
> of the first buffer will be initialized only if mb is set.
> Moreover the flags field in xdp_{buff,frame} will be reused even for
> xdp rx csum offloading in future series.
>=20
> Typical use cases for this series are:
> - Jumbo-frames
> - Packet header split (please see Google=E2=80=99s use-case @ NetDevConf =
0x14, [0])
> - TSO/GRO for XDP_REDIRECT
>=20
> The three following ebpf helpers (and related selftests) has been introdu=
ced:
> - bpf_xdp_load_bytes:
>   This helper is provided as an easy way to load data from a xdp buffer. =
It
>   can be used to load len bytes from offset from the frame associated to
>   xdp_md, into the buffer pointed by buf.
> - bpf_xdp_store_bytes:
>   Store len bytes from buffer buf into the frame associated to xdp_md, at
>   offset.
> - bpf_xdp_get_buff_len:
>   Return the total frame size (linear + paged parts)
>=20
> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take i=
nto
> account xdp multi-buff frames.
> Moreover, similar to skb_header_pointer, we introduced bpf_xdp_pointer ut=
ility
> routine to return a pointer to a given position in the xdp_buff if the
> requested area (offset + len) is contained in a contiguous memory area
> otherwise it must be copied in a bounce buffer provided by the caller run=
ning
> bpf_xdp_copy_buf().
>=20
> BPF_F_XDP_MB flag for bpf_attr has been introduced to notify the kernel t=
he
> eBPF program fully support xdp multi-buffer.
> SEC("xdp_mb/"), SEC_DEF("xdp_devmap_mb/") and SEC_DEF("xdp_cpumap_mb/" ha=
ve been
> introduced to declare xdp multi-buffer support.
> The NIC driver is expected to reject an eBPF program if it is running in =
XDP
> multi-buffer mode and the program does not support XDP multi-buffer.
> In the same way it is not possible to mix xdp multi-buffer and xdp legacy
> programs in a CPUMAP/DEVMAP or tailcall a xdp multi-buffer/legacy program=
 from
> a legacy/multi-buff one.
>=20
> More info about the main idea behind this approach can be found here [1][=
2].
>=20
> Changes since v20:
> - rebase to current bpf-next
>=20
> Changes since v19:
> - do not run deprecated bpf_prog_load()
> - rely on skb_frag_size_add/skb_frag_size_sub in
>   bpf_xdp_mb_increase_tail/bpf_xdp_mb_shrink_tail
> - rely on sinfo->nr_frags in bpf_xdp_mb_shrink_tail to check if the frame=
 has
>   been shrunk to a single-buffer one
> - allow XDP_REDIRECT of a xdp-mb frame into a CPUMAP
>=20
> Changes since v18:
> - fix bpf_xdp_copy_buf utility routine when we want to load/store data
>   contained in frag<n>
> - add a selftest for bpf_xdp_load_bytes/bpf_xdp_store_bytes when the call=
er
>   accesses data contained in frag<n> and frag<n+1>
>=20
> Changes since v17:
> - rework bpf_xdp_copy to squash base and frag management
> - remove unused variable in bpf_xdp_mb_shrink_tail()
> - move bpf_xdp_copy_buf() out of bpf_xdp_pointer()
> - add sanity check for len in bpf_xdp_pointer()
> - remove EXPORT_SYMBOL for __xdp_return()
> - introduce frag_size field in xdp_rxq_info to let the driver specify max=
 value
>   for xdp fragments. frag_size set to 0 means the tail increase of last t=
he
>   fragment is not supported.
>=20
> Changes since v16:
> - do not allow tailcalling a xdp multi-buffer/legacy program from a
>   legacy/multi-buff one.
> - do not allow mixing xdp multi-buffer and xdp legacy programs in a
>   CPUMAP/DEVMAP
> - add selftests for CPUMAP/DEVMAP xdp mb compatibility
> - disable XDP_REDIRECT for xdp multi-buff for the moment
> - set max offset value to 0xffff in bpf_xdp_pointer
> - use ARG_PTR_TO_UNINIT_MEM and ARG_CONST_SIZE for arg3_type and arg4_type
>   of bpf_xdp_store_bytes/bpf_xdp_load_bytes
>=20
> Changes since v15:
> - let the verifier check buf is not NULL in
>   bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
> - return an error if offset + length is over frame boundaries in
>   bpf_xdp_pointer routine
> - introduce BPF_F_XDP_MB flag for bpf_attr to notify the kernel the eBPF
>   program fully supports xdp multi-buffer.
> - reject a non XDP multi-buffer program if the driver is running in
>   XDP multi-buffer mode.
>=20
> Changes since v14:
> - intrudce bpf_xdp_pointer utility routine and
>   bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
> - drop bpf_xdp_adjust_data helper
> - drop xdp_frags_truesize in skb_shared_info
> - explode bpf_xdp_mb_adjust_tail in bpf_xdp_mb_increase_tail and
>   bpf_xdp_mb_shrink_tail
>=20
> Changes since v13:
> - use u32 for xdp_buff/xdp_frame flags field
> - rename xdp_frags_tsize in xdp_frags_truesize
> - fixed comments
>=20
> Changes since v12:
> - fix bpf_xdp_adjust_data helper for single-buffer use case
> - return -EFAULT in bpf_xdp_adjust_{head,tail} in case the data pointers =
are not
>   properly reset
> - collect ACKs from John
>=20
> Changes since v11:
> - add missing static to bpf_xdp_get_buff_len_proto structure
> - fix bpf_xdp_adjust_data helper when offset is smaller than linear area =
length.
>=20
> Changes since v10:
> - move xdp->data to the requested payload offset instead of to the beginn=
ing of
>   the fragment in bpf_xdp_adjust_data()
>=20
> Changes since v9:
> - introduce bpf_xdp_adjust_data helper and related selftest
> - add xdp_frags_size and xdp_frags_tsize fields in skb_shared_info
> - introduce xdp_update_skb_shared_info utility routine in ordere to not r=
eset
>   frags array in skb_shared_info converting from a xdp_buff/xdp_frame to =
a skb=20
> - simplify bpf_xdp_copy routine
>=20
> Changes since v8:
> - add proper dma unmapping if XDP_TX fails on mvneta for a xdp multi-buff
> - switch back to skb_shared_info implementation from previous xdp_shared_=
info
>   one
> - avoid using a bietfield in xdp_buff/xdp_frame since it introduces perfo=
rmance
>   regressions. Tested now on 10G NIC (ixgbe) to verify there are no perfo=
rmance
>   penalties for regular codebase
> - add bpf_xdp_get_buff_len helper and remove frame_length field in xdp ctx
> - add data_len field in skb_shared_info struct
> - introduce XDP_FLAGS_FRAGS_PF_MEMALLOC flag
>=20
> Changes since v7:
> - rebase on top of bpf-next
> - fix sparse warnings
> - improve comments for frame_length in include/net/xdp.h
>=20
> Changes since v6:
> - the main difference respect to previous versions is the new approach pr=
oposed
>   by Eelco to pass full length of the packet to eBPF layer in XDP context
> - reintroduce multi-buff support to eBPF kself-tests
> - reintroduce multi-buff support to bpf_xdp_adjust_tail helper
> - introduce multi-buffer support to bpf_xdp_copy helper
> - rebase on top of bpf-next
>=20
> Changes since v5:
> - rebase on top of bpf-next
> - initialize mb bit in xdp_init_buff() and drop per-driver initialization
> - drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
> - postpone introduction of frame_length field in XDP ctx to another series
> - minor changes
>=20
> Changes since v4:
> - rebase ontop of bpf-next
> - introduce xdp_shared_info to build xdp multi-buff instead of using the
>   skb_shared_info struct
> - introduce frame_length in xdp ctx
> - drop previous bpf helpers
> - fix bpf_xdp_adjust_tail for xdp multi-buff
> - introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
> - fix xdp_return_frame_bulk for xdp multi-buff
>=20
> Changes since v3:
> - rebase ontop of bpf-next
> - add patch 10/13 to copy back paged data from a xdp multi-buff frame to
>   userspace buffer for xdp multi-buff selftests
>=20
> Changes since v2:
> - add throughput measurements
> - drop bpf_xdp_adjust_mb_header bpf helper
> - introduce selftest for xdp multibuffer
> - addressed comments on bpf_xdp_get_frags_count
> - introduce xdp multi-buff support to cpumaps
>=20
> Changes since v1:
> - Fix use-after-free in xdp_return_{buff/frame}
> - Introduce bpf helpers
> - Introduce xdp_mb sample program
> - access skb_shared_info->nr_frags only on the last fragment
>=20
> Changes since RFC:
> - squash multi-buffer bit initialization in a single patch
> - add mvneta non-linear XDP buff support for tx side
>=20
> [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu=
-and-rx-zerocopy
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp=
-multi-buffer01-design.org
> [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to=
-a-NIC-driver (XDPmulti-buffers section)
>=20
> Eelco Chaudron (3):
>   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
>   bpf: add multi-buffer support to xdp copy helpers
>   bpf: selftests: update xdp_adjust_tail selftest to include
>     multi-buffer
>=20
> Lorenzo Bianconi (19):
>   net: skbuff: add size metadata to skb_shared_info for xdp
>   xdp: introduce flags field in xdp_buff/xdp_frame
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
>   net: mvneta: simplify mvneta_swbm_add_rx_fragment management
>   net: xdp: add xdp_update_skb_shared_info utility routine
>   net: marvell: rely on xdp_update_skb_shared_info utility routine
>   xdp: add multi-buff support to xdp_return_{buff/frame}
>   net: mvneta: add multi buffer support to XDP_TX
>   bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf
>     program
>   net: mvneta: enable jumbo frames if the loaded XDP program support mb
>   bpf: introduce bpf_xdp_get_buff_len helper
>   bpf: move user_size out of bpf_test_init
>   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
>   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
>     signature
>   libbpf: Add SEC name for xdp_mb programs
>   net: xdp: introduce bpf_xdp_pointer utility routine
>   bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
>   bpf: selftests: add CPUMAP/DEVMAP selftests for xdp multi-buff
>   xdp: disable XDP_REDIRECT for xdp multi-buff
>=20
> Toke Hoiland-Jorgensen (1):
>   bpf: generalise tail call map compatibility check
>=20
>  drivers/net/ethernet/marvell/mvneta.c         | 204 +++++++++------
>  include/linux/bpf.h                           |  31 ++-
>  include/linux/skbuff.h                        |   1 +
>  include/net/xdp.h                             | 108 +++++++-
>  include/uapi/linux/bpf.h                      |  30 +++
>  kernel/bpf/arraymap.c                         |   4 +-
>  kernel/bpf/core.c                             |  28 +-
>  kernel/bpf/cpumap.c                           |   8 +-
>  kernel/bpf/devmap.c                           |   3 +-
>  kernel/bpf/syscall.c                          |  25 +-
>  kernel/trace/bpf_trace.c                      |   3 +
>  net/bpf/test_run.c                            | 115 +++++++--
>  net/core/filter.c                             | 244 +++++++++++++++++-
>  net/core/xdp.c                                |  78 +++++-
>  tools/include/uapi/linux/bpf.h                |  30 +++
>  tools/lib/bpf/libbpf.c                        |   8 +
>  .../bpf/prog_tests/xdp_adjust_frags.c         | 103 ++++++++
>  .../bpf/prog_tests/xdp_adjust_tail.c          | 131 ++++++++++
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 ++++++++---
>  .../bpf/prog_tests/xdp_cpumap_attach.c        |  65 ++++-
>  .../bpf/prog_tests/xdp_devmap_attach.c        |  56 ++++
>  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
>  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>  .../bpf/progs/test_xdp_update_frags.c         |  42 +++
>  .../bpf/progs/test_xdp_with_cpumap_helpers.c  |   6 +
>  .../progs/test_xdp_with_cpumap_mb_helpers.c   |  27 ++
>  .../bpf/progs/test_xdp_with_devmap_helpers.c  |   7 +
>  .../progs/test_xdp_with_devmap_mb_helpers.c   |  27 ++
>  29 files changed, 1367 insertions(+), 212 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_fra=
gs.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_fra=
gs.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpuma=
p_mb_helpers.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devma=
p_mb_helpers.c
>=20
> --=20
> 2.33.1
>=20

--+zvwgDbZTmJG5roI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYd8kPAAKCRA6cBh0uS2t
rAYxAQCfFZwBUfb1qWkoA9wQ7GNraZsoNpeBg6wHF4uV++70QQD8Dk5eG4NGhjiN
b2thMmuIOQ37DP0nUfxK643eKSQbsgo=
=cBrD
-----END PGP SIGNATURE-----

--+zvwgDbZTmJG5roI--

