Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C102077A8
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404351AbgFXPhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:37:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404302AbgFXPh3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 11:37:29 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 673B1206FA;
        Wed, 24 Jun 2020 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593013049;
        bh=BLTpk1BJdDLwAiHdRWyO+yC7MM5BY7JdBYk57yhyizw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1mJUXgJDdRnbMEvPLpFSyc+cu+jOIG2PWMPVRg/og9be82zp89AnhdkRlcAm30H+u
         BPkXIvwkcJ/8R+e7fAVf7cBa6ZCgGnIwI3mum+oR+U06f7TlHuLrTkgNY67Gcr8AsC
         tWzxbCUznz5qzxa0pPMzyWwMyt4FHP43qkBqQE54=
Date:   Wed, 24 Jun 2020 17:37:23 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v3 bpf-next 9/9] selftest: add tests for XDP programs in
 CPUMAP entries
Message-ID: <20200624153723.GA342397@localhost.localdomain>
References: <cover.1592947694.git.lorenzo@kernel.org>
 <81ff56ab7ba1f0e48cba821563d311fa8f7e2e28.1592947694.git.lorenzo@kernel.org>
 <CAEf4BzZUfxv_zbuefAYM6gxQ2pdxYjQLjZTb=9qGJhoVztuZ3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CAEf4BzZUfxv_zbuefAYM6gxQ2pdxYjQLjZTb=9qGJhoVztuZ3Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jun 23, 2020 at 2:40 PM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > Similar to what have been done for DEVMAP, introduce tests to verify

[...]

> > +SEC("xdp_cpumap/dummy_cm")
> > +int xdp_dummy_cm(struct xdp_md *ctx)
> > +{
> > +       char fmt[] =3D "devmap redirect: dev %u len %u\n";
> > +       void *data_end =3D (void *)(long)ctx->data_end;
> > +       void *data =3D (void *)(long)ctx->data;
> > +       unsigned int len =3D data_end - data;
> > +
> > +       ingress_ifindex =3D ctx->ingress_ifindex;
>=20
> Have you checked the generated BPF assembly to verify
> ctx->ingress_ifindex is actually read? ingress_ifindex variable is
> declared static, so I'm guessing Clang just optimized it away. If you
> want to be sure this actually gets executed, make ingress_ifindex
> global var.

ack, thx for the review. I will fix it in v4.

Regards,
Lorenzo

>=20
> > +
> > +       return XDP_PASS;
> > +}
> > +
> > +char _license[] SEC("license") =3D "GPL";
> > --
> > 2.26.2
> >

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXvNzMAAKCRA6cBh0uS2t
rFtuAQDTSy491GEwZuaw4L+opmPebWbjP7n1K/FJ/HJ5Z45PZwEA5pTG3B/LTL2v
UNbZVjThhanw6tKAS0jUNarEytYsJg0=
=I3GU
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
