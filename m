Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6114836CB16
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 20:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbhD0S3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 14:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230219AbhD0S3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 14:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1319061001;
        Tue, 27 Apr 2021 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619548107;
        bh=QNDch69z8o0RrJ9jNFXhkcE/fN5/M67I+3jCEi22zIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PtVqeekhpvQarlyi7x4skHBuZVZKCkZ5PrdI12ZxBDznW0Yg2EN8uBIPZXxjne/3C
         PaKwuTt2SH7cNPy3zcJ3s2PXzGXjb7Mnq3YWOc18pHRmF00OOQqYltxQc6SC+LKnyo
         URMEPMXCceh2UO1/NaHnc7+EJ7k1//X6aBKOglHkiWhFqrBJGdtYyNLiY4PBHTMuF8
         Rifx3zcsfOAuGvNK0ljIjSmGXMwcujnEfR3Qf8jAL9bmmPVh2++IoCUCp7AHj3L4g7
         GmFlxNyBxROY9mJUiWvn+had5lVe+skptpZ+G606BNBdbIe2FkUy1+k4FoQ5FEEtyf
         zfn9S+c+ihbIQ==
Date:   Tue, 27 Apr 2021 20:28:22 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
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
Subject: Re: [PATCH v8 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YIhXxmXdjQdrrPbT@lore-desk>
References: <cover.1617885385.git.lorenzo@kernel.org>
 <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BGwRV/j/BiBdnsJe"
Content-Disposition: inline
In-Reply-To: <CAJ8uoz1MOYLzyy7xXq_fmpKDEakxSomzfM76Szjr5gWsqHc9jQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BGwRV/j/BiBdnsJe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]

> Took your patches for a test run with the AF_XDP sample xdpsock on an
> i40e card and the throughput degradation is between 2 to 6% depending
> on the setup and microbenchmark within xdpsock that is executed. And
> this is without sending any multi frame packets. Just single frame
> ones. Tirtha made changes to the i40e driver to support this new
> interface so that is being included in the measurements.
>=20
> What performance do you see with the mvneta card? How much are we
> willing to pay for this feature when it is not being used or can we in
> some way selectively turn it on only when needed?

Hi Magnus,

Today I carried out some comparison tests between bpf-next and bpf-next +
xdp_multibuff series on mvneta running xdp_rxq_info sample. Results are
basically aligned:

bpf-next:
- xdp drop ~ 665Kpps
- xdp_tx   ~ 291Kpps
- xdp_pass ~ 118Kpps

bpf-next + xdp_multibuff:
- xdp drop ~ 672Kpps
- xdp_tx   ~ 288Kpps
- xdp_pass ~ 118Kpps

I am not sure if results are affected by the low power CPU, I will run some
tests on ixgbe card.

Regards,
Lorenzo

>=20
> Thanks: Magnus
>=20
> > Eelco Chaudron (4):
> >   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
> >   bpd: add multi-buffer support to xdp copy helpers
> >   bpf: add new frame_length field to the XDP ctx
> >   bpf: update xdp_adjust_tail selftest to include multi-buffer
> >
> > Lorenzo Bianconi (10):
> >   xdp: introduce mb in xdp_buff/xdp_frame
> >   xdp: add xdp_shared_info data structure
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
> >   xdp: add multi-buff support to xdp_return_{buff/frame}
> >   net: mvneta: add multi buffer support to XDP_TX
> >   net: mvneta: enable jumbo frames for XDP
> >   net: xdp: add multi-buff support to xdp_build_skb_from_fram
> >   bpf: move user_size out of bpf_test_init
> >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> >   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
> >     signature
> >
> >  drivers/net/ethernet/marvell/mvneta.c         | 182 ++++++++++--------
> >  include/linux/filter.h                        |   7 +
> >  include/net/xdp.h                             | 105 +++++++++-
> >  include/uapi/linux/bpf.h                      |   1 +
> >  net/bpf/test_run.c                            | 109 +++++++++--
> >  net/core/filter.c                             | 134 ++++++++++++-
> >  net/core/xdp.c                                | 103 +++++++++-
> >  tools/include/uapi/linux/bpf.h                |   1 +
> >  .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++
> >  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 ++++++++----
> >  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  17 +-
> >  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
> >  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   3 +-
> >  13 files changed, 767 insertions(+), 159 deletions(-)
> >
> > --
> > 2.30.2
> >

--BGwRV/j/BiBdnsJe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYIhXwwAKCRA6cBh0uS2t
rDBbAP97aFwKh4hbVWji/WAk4qNXTtRmLcFdhnUMzjs9UJCwLQD/aKxN2U5fBrf3
xAjPBE8RWndr6pfoba20ObmWU1G3JwY=
=p8bo
-----END PGP SIGNATURE-----

--BGwRV/j/BiBdnsJe--
