Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A926402536
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 10:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242844AbhIGIhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 04:37:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242837AbhIGIgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 04:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631003734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/1tzDx8U1PWY5C5B/RCN/s1/YDYu2JH+7J0+jVgi6i4=;
        b=RyoLjwcPmot2FBdeamxlVOl0ex09byx7xfF3M62QNSfhGLI6/WlC1XBl2uljmkZzOp51rJ
        KvJ+YZW0sIPCItUN6igPh6DcMoa819hzYmsIkNOSOMhp/Nw2jZY+F0hO0ulOR32eXxyGq1
        08zhCLwDHVJAGELyYHJml/+RqN2lIyk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-uhfhPDqdNC-257B5dG_x1Q-1; Tue, 07 Sep 2021 04:35:32 -0400
X-MC-Unique: uhfhPDqdNC-257B5dG_x1Q-1
Received: by mail-ej1-f72.google.com with SMTP id n18-20020a170906089200b005dc91303dfeso3308046eje.15
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 01:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/1tzDx8U1PWY5C5B/RCN/s1/YDYu2JH+7J0+jVgi6i4=;
        b=Kd256BIU18OE0HW3+mzIXlhqvUc/WRyBXA4zBYmiAsbVFjL/6leTMa+zt7s/9HP2Eo
         0yqu9G1KfkMtHmvYdyXPxrEWM6UJedB1R3//jwymjNuE0WSHaX8lVLKFaHS9paCaYY0B
         kcjFbVcrK3m6dmaiCdNcIdTpnylgO6KcoEmhKOnXVUKIVnR4aAuXCzlxgsn2NqBxhbM7
         YLYTk+oTTufpFBB54ooaEvQJd5H0FYR+ciXj9nvuXm7/E5+AHhSyo+zT64QLXyERghxT
         NEZT2cB8nCC2xK2LPOaO6JcdpXubUpWxhGPaGIIyYRW5I6eGudDKM4mtIWXs3iWvzR/G
         QKGA==
X-Gm-Message-State: AOAM533Dhy5BRJzNBGhmgMymF7cUhPnt4WTj/Ql+zTa+7DAxV3k5CMtS
        KmCM85ZhouGtHPio6+7ctXZwsqy67cqo5kWSZyJyEtZIxJFX0FJ44WgaWjQ9Cr5adkxSw6Gy4BF
        TOGtGMfQPX4dHI1Cu
X-Received: by 2002:aa7:c9d6:: with SMTP id i22mr17440096edt.307.1631003731628;
        Tue, 07 Sep 2021 01:35:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxwdVqi2q8sejffcKnVijv+cnK/9z8u4vYOSSDkhuyLXVE3UBsjoKIuv7TuOS3Md5tQH3e3w==
X-Received: by 2002:aa7:c9d6:: with SMTP id i22mr17440076edt.307.1631003731438;
        Tue, 07 Sep 2021 01:35:31 -0700 (PDT)
Received: from localhost (net-37-116-49-210.cust.vodafonedsl.it. [37.116.49.210])
        by smtp.gmail.com with ESMTPSA id a15sm6408262edr.2.2021.09.07.01.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 01:35:30 -0700 (PDT)
Date:   Tue, 7 Sep 2021 10:35:27 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v12 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YTckT0k3MV8+Pte/@lore-desk>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <612ecd169d9c7_6b87208d7@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2WhikOjJbw4rzvu2"
Content-Disposition: inline
In-Reply-To: <612ecd169d9c7_6b87208d7@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2WhikOjJbw4rzvu2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > This series introduce XDP multi-buffer support. The mvneta driver is
> > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > please focus on how these new types of xdp_{buff,frame} packets
> > traverse the different layers and the layout design. It is on purpose
> > that BPF-helpers are kept simple, as we don't want to expose the
> > internal layout to allow later changes.
> >=20
> > The main idea for the new multi-buffer layout is to reuse the same
> > structure used for non-linear SKB. This rely on the "skb_shared_info"
> > struct at the end of the first buffer to link together subsequent
> > buffers. Keeping the layout compatible with SKBs is also done to ease
> > and speedup creating a SKB from an xdp_{buff,frame}.
> > Converting xdp_frame to SKB and deliver it to the network stack is shown
> > in patch 05/18 (e.g. cpumaps).
> >=20
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
> >=20
>=20
> The series is looking really close to me. Couple small comments/questions
> inline. Also I think we should call out the potential issues in the cover
> letter with regards to backwards compatibility. Something like,=20
>=20
> "
> A multi-buffer enabled NIC may receive XDP frames with multiple frags.
> If a BPF program does not understand mb layouts its possible to contrive
> a BPF program that incorrectly views data_end as the end of data when
> there is more data in the payload. Note helpers will generally due the
> correct thing, for example perf_output will consume entire payload. But,
> it is still possible some programs could do the wrong thing even if in
> an edge case. Although we expect most BPF programs not to be impacted
> we can't rule out, you've been warned.

ack, I will add it to the cover letter in v13.

Regards,
Lorenzo

> "
>=20
> I can't think of an elegant way around this and it does require at least
> some type of opt-in by increasing the MTU limit so I'm OK with it given
> I think it should impact few (no?) real programs.
>=20
> > Typical use cases for this series are:
> > - Jumbo-frames
> > - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> > - TSO/GRO
> >=20
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
> >=20
> > bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take=
 into
> > account xdp multi-buff frames.
> >=20
> > More info about the main idea behind this approach can be found here [1=
][2].
> >=20
> > Changes since v11:
> > - add missing static to bpf_xdp_get_buff_len_proto structure
> > - fix bpf_xdp_adjust_data helper when offset is smaller than linear are=
a length.
> >=20
> > Changes since v10:
> > - move xdp->data to the requested payload offset instead of to the begi=
nning of
> >   the fragment in bpf_xdp_adjust_data()
> >=20
> > Changes since v9:
> > - introduce bpf_xdp_adjust_data helper and related selftest
> > - add xdp_frags_size and xdp_frags_tsize fields in skb_shared_info
> > - introduce xdp_update_skb_shared_info utility routine in ordere to not=
 reset
> >   frags array in skb_shared_info converting from a xdp_buff/xdp_frame t=
o a skb=20
> > - simplify bpf_xdp_copy routine
> >=20
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
> >=20
> > Changes since v7:
> > - rebase on top of bpf-next
> > - fix sparse warnings
> > - improve comments for frame_length in include/net/xdp.h
> >=20
> > Changes since v6:
> > - the main difference respect to previous versions is the new approach =
proposed
> >   by Eelco to pass full length of the packet to eBPF layer in XDP conte=
xt
> > - reintroduce multi-buff support to eBPF kself-tests
> > - reintroduce multi-buff support to bpf_xdp_adjust_tail helper
> > - introduce multi-buffer support to bpf_xdp_copy helper
> > - rebase on top of bpf-next
> >=20
> > Changes since v5:
> > - rebase on top of bpf-next
> > - initialize mb bit in xdp_init_buff() and drop per-driver initializati=
on
> > - drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
> > - postpone introduction of frame_length field in XDP ctx to another ser=
ies
> > - minor changes
> >=20
> > Changes since v4:
> > - rebase ontop of bpf-next
> > - introduce xdp_shared_info to build xdp multi-buff instead of using the
> >   skb_shared_info struct
> > - introduce frame_length in xdp ctx
> > - drop previous bpf helpers
> > - fix bpf_xdp_adjust_tail for xdp multi-buff
> > - introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
> > - fix xdp_return_frame_bulk for xdp multi-buff
> >=20
> > Changes since v3:
> > - rebase ontop of bpf-next
> > - add patch 10/13 to copy back paged data from a xdp multi-buff frame to
> >   userspace buffer for xdp multi-buff selftests
> >=20
> > Changes since v2:
> > - add throughput measurements
> > - drop bpf_xdp_adjust_mb_header bpf helper
> > - introduce selftest for xdp multibuffer
> > - addressed comments on bpf_xdp_get_frags_count
> > - introduce xdp multi-buff support to cpumaps
> >=20
> > Changes since v1:
> > - Fix use-after-free in xdp_return_{buff/frame}
> > - Introduce bpf helpers
> > - Introduce xdp_mb sample program
> > - access skb_shared_info->nr_frags only on the last fragment
> >=20
> > Changes since RFC:
> > - squash multi-buffer bit initialization in a single patch
> > - add mvneta non-linear XDP buff support for tx side
> >=20
> > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-m=
tu-and-rx-zerocopy
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-=
to-a-NIC-driver (XDPmulti-buffers section)
> >=20
> > Eelco Chaudron (3):
> >   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
> >   bpf: add multi-buffer support to xdp copy helpers
> >   bpf: update xdp_adjust_tail selftest to include multi-buffer
> >=20
> > Lorenzo Bianconi (15):
> >   net: skbuff: add size metadata to skb_shared_info for xdp
> >   xdp: introduce flags field in xdp_buff/xdp_frame
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
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
> >=20
> >  drivers/net/ethernet/marvell/mvneta.c         | 204 ++++++++++-------
> >  include/linux/skbuff.h                        |   6 +-
> >  include/net/xdp.h                             |  95 +++++++-
> >  include/uapi/linux/bpf.h                      |  39 ++++
> >  kernel/trace/bpf_trace.c                      |   3 +
> >  net/bpf/test_run.c                            | 117 ++++++++--
> >  net/core/filter.c                             | 213 +++++++++++++++++-
> >  net/core/xdp.c                                |  76 ++++++-
> >  tools/include/uapi/linux/bpf.h                |  39 ++++
> >  .../bpf/prog_tests/xdp_adjust_data.c          |  55 +++++
> >  .../bpf/prog_tests/xdp_adjust_tail.c          | 118 ++++++++++
> >  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++++----
> >  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
> >  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
> >  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
> >  .../bpf/progs/test_xdp_update_frags.c         |  41 ++++
> >  16 files changed, 1036 insertions(+), 165 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_d=
ata.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_f=
rags.c
> >=20
> > --=20
> > 2.31.1
> >=20
>=20
>=20

--2WhikOjJbw4rzvu2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYTckTAAKCRA6cBh0uS2t
rNx4AQC9L+G3C5OPyH297WPcctruEMYPy4JlLEau+rWXXShmTwD/dPBwhMyzLzmd
1VPCh6IiLz6n/kA6TSA54rokvrLU4wQ=
=iAzu
-----END PGP SIGNATURE-----

--2WhikOjJbw4rzvu2--

