Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3693D8B12
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235612AbhG1Jrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:47:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235012AbhG1Jri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:47:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627465657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WDaMubqK0Fd8+wWZIhOupnRVnlJaFggSC8O1W6H2+y4=;
        b=YynlkzunNRgMzcZhdL+7OSO1Dpy/o26ZoQPWRgEj+DWFpc91YgQ/3vjWFrXTGQvX/raD2w
        q3Vyb5KQYcKoEfB8zpYIFr31zAB14WLy9aOv+bd2XJspcYsp1ApKT/pXh+ChUO/CEeGFM/
        H22FLsETczHDX/6u2JBjmz/MK8ZKro0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-nCIf0RO8NterIUthqlN-PQ-1; Wed, 28 Jul 2021 05:47:33 -0400
X-MC-Unique: nCIf0RO8NterIUthqlN-PQ-1
Received: by mail-ed1-f72.google.com with SMTP id y39-20020a50bb2a0000b02903bc05daccbaso986024ede.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 02:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WDaMubqK0Fd8+wWZIhOupnRVnlJaFggSC8O1W6H2+y4=;
        b=ZvVduZYg74xNcnZ6l8tHXf9F9lgG48Ur35mqLSHoynJEwAg6P+zAPPKi+s4C74yMjz
         WRT8j2/rMjNVaGSQYSfqvwTOj9mTaPgLA13HTQYBDySyp77Ivlpn69rxWVHDw61KR5bR
         04zNDObAEEP3GnElz2l+HruLfEWDwMNO02izvoelUQKLVGYcE9oVc5XJ0wSxGhi7+Kxf
         pUns7Gf1CsuPUPYSNkj8uJdu5DYX0YEpTFP3TG74mmUoDeeU2cE7rJBSe6j/sKG/FA3c
         Nr5pm64+d0ZNJVxYr5a6GmSV99xeewZZWPbZIeKTG4Ivl1jUu3nHeEW3lX5YsfQMigdp
         p45w==
X-Gm-Message-State: AOAM533/cmJNHswNBsyNvu5Fvqas7iJKuHTNO7kOiI4jTSvMUw9YJJxw
        2EEmHMfj1dHfiDEF4m8rek3Zyi0z8twP7neGR5rR3YpNTDgB7q3yjV9/OuC3QYkR7ce88LF88/h
        AAGlN8ZvCykhXz2VC
X-Received: by 2002:a17:906:6b1b:: with SMTP id q27mr25794860ejr.169.1627465652323;
        Wed, 28 Jul 2021 02:47:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxexPbM9qAg077pwD8pYOWNBOZRGV+IXB+EZCCH7ky8P6pZSrovPj1jH7ZktgOZ/Xs96h1Lqg==
X-Received: by 2002:a17:906:6b1b:: with SMTP id q27mr25794826ejr.169.1627465652132;
        Wed, 28 Jul 2021 02:47:32 -0700 (PDT)
Received: from localhost (net-130-25-106-225.cust.vodafonedsl.it. [130.25.106.225])
        by smtp.gmail.com with ESMTPSA id bx11sm1828409ejb.107.2021.07.28.02.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 02:47:31 -0700 (PDT)
Date:   Wed, 28 Jul 2021 11:47:28 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <me@lorenzobianconi.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH v10 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YQEnsALmUCp2w/fL@lore-desk>
References: <cover.1627463617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wPo4DG1yq8ErvLYq"
Content-Disposition: inline
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wPo4DG1yq8ErvLYq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.

I sent the cover-letter. Sorry for the noise.

Regards,
Lorenzo

>=20
> The main idea for the new multi-buffer layout is to reuse the same
> layout used for non-linear SKB. This rely on the "skb_shared_info"
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
> - TSO
>=20
> The two following ebpf helpers (and related selftests) has been introduce=
d:
> - bpf_xdp_adjust_data:
>   Move xdp_md->data and xdp_md->data_end pointers in subsequent fragments
>   according to the offset provided by the ebpf program. This helper can be
>   used to read/write values in frame payload.
> - bpf_xdp_get_buff_len:
>   Return the total frame size (linear + paged parts)
>=20
> bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take i=
nto
> account xdp multi-buff frames.
>=20
> More info about the main idea behind this approach can be found here [1][=
2].
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
>   bpf: update xdp_adjust_tail selftest to include multi-buffer
>=20
> Lorenzo Bianconi (15):
>   net: skbuff: add size metadata to skb_shared_info for xdp
>   xdp: introduce flags field in xdp_buff/xdp_frame
>   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
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
>=20
>  drivers/net/ethernet/marvell/mvneta.c         | 213 ++++++++++--------
>  include/linux/skbuff.h                        |   6 +-
>  include/net/xdp.h                             |  95 +++++++-
>  include/uapi/linux/bpf.h                      |  38 ++++
>  kernel/trace/bpf_trace.c                      |   3 +
>  net/bpf/test_run.c                            | 117 ++++++++--
>  net/core/filter.c                             | 210 ++++++++++++++++-
>  net/core/xdp.c                                |  76 ++++++-
>  tools/include/uapi/linux/bpf.h                |  38 ++++
>  .../bpf/prog_tests/xdp_adjust_data.c          |  55 +++++
>  .../bpf/prog_tests/xdp_adjust_tail.c          | 118 ++++++++++
>  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++++----
>  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
>  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
>  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
>  .../bpf/progs/test_xdp_update_frags.c         |  49 ++++
>  16 files changed, 1044 insertions(+), 169 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_dat=
a.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_fra=
gs.c
>=20
> --=20
> 2.31.1
>=20

--wPo4DG1yq8ErvLYq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYQEnrgAKCRA6cBh0uS2t
rAD5AQDhrF+/pHgQX5mUOmTyuGht46lwzCeL6nh/pqZa0XKhlwEA4lPHPsqZ0i0l
mn37rBuEbGO45HY28twoQYsQ8vbY5Qk=
=f9BA
-----END PGP SIGNATURE-----

--wPo4DG1yq8ErvLYq--

