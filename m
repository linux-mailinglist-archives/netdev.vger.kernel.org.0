Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46BB28176E
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbgJBQGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387688AbgJBQGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 12:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601654794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f37y1NeOmt1jMzW727aJwskGl0zLABG5qEvMjStTgzM=;
        b=IaLWWYMFZz0AUO/57nbq/+O9+lTfz9vzIIulHsz1NiuwQuZ94FCRZtrSzAX05b2f9w5YVu
        kxOxdrUUdNvYRSLYSUoFclNE+BDADLig/KzY6k5V05sv3CZIVRXPDdzhjGXdF/Jo7cRdu3
        MIiHsmNyEwuAAZEQ3F54nsyOGkTiIpM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-gCc5fZndMRWgnBUBktzGQQ-1; Fri, 02 Oct 2020 12:06:30 -0400
X-MC-Unique: gCc5fZndMRWgnBUBktzGQQ-1
Received: by mail-wm1-f71.google.com with SMTP id l15so678518wmh.9
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 09:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f37y1NeOmt1jMzW727aJwskGl0zLABG5qEvMjStTgzM=;
        b=XRBcrFh3/HOFqFPnTvmxaA1UcN5esLVHIaPUgxE7zQDoBavdvnxtQcQ3JFc54EnETs
         puTQB8JiRHxv5DUBgb9ABMV69DwgncEQq/lg4TP95u7czLirRxaxZPAXQV2CZVa8O7Qw
         ayUD2o7or1tVLJGfT7wTfuCs4cq9WvRVgoqg9hYkMxRqyHVy4PzPhOkwPYlB4XJlZO6M
         Bs+byggUsD4cxmv+XdW3I89EzPXoUCy1/qdKcg0eCPhEAbBHzWB1JSN61PNfVxCZgdxm
         cifCWDz8S5qJepqgdoNkw9vJsMQHBbLICqzeR6Ei9sjujVQPiqCnoWDE5Y03YHtFm3jz
         CLNA==
X-Gm-Message-State: AOAM530SemkuXd7OPN4Qe6RvdcXtLU0DyrxemRdfqRZ9Kd0owwe100RL
        2d4Bk6pWnkj/5DggTWPxvmTzbu6+5/qElGv3pRHQEFsB+t9OvL2SF50mZWk1l9NpV+vUzgwOqy/
        DmlLzU4PsJoOPMhha
X-Received: by 2002:a1c:2903:: with SMTP id p3mr3789775wmp.170.1601654788846;
        Fri, 02 Oct 2020 09:06:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxzUC/G45T3wmsBxcEZe6q2wPURQSbmB2F/nRB0nbAOUKdHdQUP3bCRU7bSNd7zD7y3073qQ==
X-Received: by 2002:a1c:2903:: with SMTP id p3mr3789740wmp.170.1601654788519;
        Fri, 02 Oct 2020 09:06:28 -0700 (PDT)
Received: from localhost ([176.207.245.61])
        by smtp.gmail.com with ESMTPSA id m3sm2658963wme.3.2020.10.02.09.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 09:06:26 -0700 (PDT)
Date:   Fri, 2 Oct 2020 18:06:23 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20201002160623.GA40027@lore-desk>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--envbJBWh7q8WU6mo
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
> > For now, to keep the design simple and to maintain performance, the XDP
> > BPF-prog (still) only have access to the first-buffer. It is left for
> > later (another patchset) to add payload access across multiple buffers.
> > This patchset should still allow for these future extensions. The goal
> > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > same performance as before.
> >=20
> > The main idea for the new multi-buffer layout is to reuse the same
> > layout used for non-linear SKB. This rely on the "skb_shared_info"
> > struct at the end of the first buffer to link together subsequent
> > buffers. Keeping the layout compatible with SKBs is also done to ease
> > and speedup creating an SKB from an xdp_{buff,frame}. Converting
> > xdp_frame to SKB and deliver it to the network stack is shown in cpumap
> > code (patch 13/13).
>=20
> Using the end of the buffer for the skb_shared_info struct is going to
> become driver API so unwinding it if it proves to be a performance issue
> is going to be ugly. So same question as before, for the use case where
> we receive packet and do XDP_TX with it how do we avoid cache miss
> overhead? This is not just a hypothetical use case, the Facebook
> load balancer is doing this as well as Cilium and allowing this with
> multi-buffer packets >1500B would be useful.
>=20
> Can we write the skb_shared_info lazily? It should only be needed once
> we know the packet is going up the stack to some place that needs the
> info. Which we could learn from the return code of the XDP program.

Hi John,

I agree, I think for XDP_TX use-case it is not strictly necessary to fill t=
he
skb_hared_info. The driver can just keep this info on the stack and use it
inserting the packet back to the DMA ring.
For mvneta I implemented it in this way to keep the code aligned with ndo_x=
dp_xmit
path since it is a low-end device. I guess we are not introducing any API c=
onstraint
for XDP_TX. A high-end device can implement multi-buff for XDP_TX in a diff=
erent way
in order to avoid the cache miss.

We need to fill the skb_shared info only when we want to pass the frame to =
the
network stack (build_skb() can directly reuse skb_shared_info->frags[]) or =
for
XDP_REDIRECT use-case.

>=20
> >=20
> > A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structu=
re
> > to notify the bpf/network layer if this is a xdp multi-buffer frame (mb=
 =3D 1)
> > or not (mb =3D 0).
> > The mb bit will be set by a xdp multi-buffer capable driver only for
> > non-linear frames maintaining the capability to receive linear frames
> > without any extra cost since the skb_shared_info structure at the end
> > of the first buffer will be initialized only if mb is set.
>=20
> Thanks above is clearer.
>=20
> >=20
> > In order to provide to userspace some metdata about the non-linear
> > xdp_{buff,frame}, we introduced 2 bpf helpers:
> > - bpf_xdp_get_frags_count:
> >   get the number of fragments for a given xdp multi-buffer.
> > - bpf_xdp_get_frags_total_size:
> >   get the total size of fragments for a given xdp multi-buffer.
>=20
> Whats the use case for these? Do you have an example where knowing
> the frags count is going to be something a BPF program will use?
> Having total size seems interesting but perhaps we should push that
> into the metadata so its pulled into the cache if users are going to
> be reading it on every packet or something.

At the moment we do not have any use-case for these helpers (not considering
the sample in the series :)). We introduced them to provide some basic meta=
data
about the non-linear xdp_frame.
IIRC we decided to introduce some helpers instead of adding this info in xd=
p_frame
in order to save space on it (for xdp it is essential xdp_frame to fit in a=
 single
cache-line).

Regards,
Lorenzo

>=20
> >=20
> > Typical use cases for this series are:
> > - Jumbo-frames
> > - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> > - TSO
> >=20
> > More info about the main idea behind this approach can be found here [1=
][2].
> >=20
> > We carried out some throughput tests in a standard linear frame scenari=
o in order
> > to verify we did not introduced any performance regression adding xdp m=
ulti-buff
> > support to mvneta:
> >=20
> > offered load is ~ 1000Kpps, packet size is 64B, mvneta descriptor size =
is one PAGE
> >=20
> > commit: 879456bedbe5 ("net: mvneta: avoid possible cache misses in mvne=
ta_rx_swbm")
> > - xdp-pass:      ~162Kpps
> > - xdp-drop:      ~701Kpps
> > - xdp-tx:        ~185Kpps
> > - xdp-redirect:  ~202Kpps
> >=20
> > mvneta xdp multi-buff:
> > - xdp-pass:      ~163Kpps
> > - xdp-drop:      ~739Kpps
> > - xdp-tx:        ~182Kpps
> > - xdp-redirect:  ~202Kpps
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
> > Lorenzo Bianconi (11):
> >   xdp: introduce mb in xdp_buff/xdp_frame
> >   xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
> >   xdp: add multi-buff support to xdp_return_{buff/frame}
> >   net: mvneta: add multi buffer support to XDP_TX
> >   bpf: move user_size out of bpf_test_init
> >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> >   bpf: test_run: add skb_shared_info pointer in bpf_test_finish
> >     signature
> >   bpf: add xdp multi-buffer selftest
> >   net: mvneta: enable jumbo frames for XDP
> >   bpf: cpumap: introduce xdp multi-buff support
> >=20
> > Sameeh Jubran (2):
> >   bpf: introduce bpf_xdp_get_frags_{count, total_size} helpers
> >   samples/bpf: add bpf program that uses xdp mb helpers
> >=20
> >  drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
> >  .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
> >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
> >  drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
> >  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
> >  drivers/net/ethernet/marvell/mvneta.c         | 131 +++++++------
> >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   1 +
> >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 +
> >  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
> >  .../ethernet/netronome/nfp/nfp_net_common.c   |   1 +
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
> >  drivers/net/ethernet/sfc/rx.c                 |   1 +
> >  drivers/net/ethernet/socionext/netsec.c       |   1 +
> >  drivers/net/ethernet/ti/cpsw.c                |   1 +
> >  drivers/net/ethernet/ti/cpsw_new.c            |   1 +
> >  drivers/net/hyperv/netvsc_bpf.c               |   1 +
> >  drivers/net/tun.c                             |   2 +
> >  drivers/net/veth.c                            |   1 +
> >  drivers/net/virtio_net.c                      |   2 +
> >  drivers/net/xen-netfront.c                    |   1 +
> >  include/net/xdp.h                             |  31 ++-
> >  include/uapi/linux/bpf.h                      |  14 ++
> >  kernel/bpf/cpumap.c                           |  45 +----
> >  net/bpf/test_run.c                            | 118 ++++++++++--
> >  net/core/dev.c                                |   1 +
> >  net/core/filter.c                             |  42 ++++
> >  net/core/xdp.c                                | 104 ++++++++++
> >  samples/bpf/Makefile                          |   3 +
> >  samples/bpf/xdp_mb_kern.c                     |  68 +++++++
> >  samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h                |  14 ++
> >  .../testing/selftests/bpf/prog_tests/xdp_mb.c |  79 ++++++++
> >  .../selftests/bpf/progs/test_xdp_multi_buff.c |  24 +++
> >  36 files changed, 757 insertions(+), 123 deletions(-)
> >  create mode 100644 samples/bpf/xdp_mb_kern.c
> >  create mode 100644 samples/bpf/xdp_mb_user.c
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_mb.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_multi_bu=
ff.c
> >=20
> > --=20
> > 2.26.2
> >=20
>=20
>=20

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3dP/AAKCRA6cBh0uS2t
rD8zAQDU7k0ftzqRP/hgA39qT4NWVKf4BwdzYoG+TioHfH3xBQD/XzL2q+EqClag
GOJpY5CLGqAjaJQE1gho8VQsQ3RhCgs=
=2aH5
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

