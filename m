Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93E848EE4B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbiANQf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiANQfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:35:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C347C061574;
        Fri, 14 Jan 2022 08:35:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B467CB8297C;
        Fri, 14 Jan 2022 16:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E437BC36AE5;
        Fri, 14 Jan 2022 16:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642178152;
        bh=gwy67pz0tY4ocaNohjQFB1ByLEZSQ+IzLwXuseNYKYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aeNr75g5prQmg3RrygDXt8VKqoe+iObLrEVVDWkJjEbbvL4jkgnyvsUGdtYxikWiw
         pjbDD4WvAwEZI0dNkMBsAMlVDUuJz84pPqVFEqtkn+nwkc0qAHdf1I+iZ5UUZCpq1y
         YokWx0GW2v5AQSfQtYWVqlZjUtrmqCEayVh2CBr2g03hGecsvf8X5zkv79OuuV2IB3
         kX5AGIKKmExsA2HdP1MtdVeB4UMAi/U4eeIRSFwBv/Ukb8GVGsRy8vMT2UFvpRot04
         DNrgUqhY1uLEbBaZAZbXwDsYz+D8e5/k/YROZoyx+gXaf3iq7X9Rd3Rg4VBlQ0tFv9
         P6z4YYl2+RSBQ==
Date:   Fri, 14 Jan 2022 17:35:48 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Message-ID: <YeGmZDI6etoB0hKx@lore-desk>
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk>
 <8735lshapk.fsf@toke.dk>
 <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk>
 <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qgtZDZjdAzKt06IF"
Content-Disposition: inline
In-Reply-To: <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qgtZDZjdAzKt06IF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, Jan 13, 2022 at 2:22 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> > > > >
> > > > > I would prefer to keep the "_mb" postfix, but naming is hard and =
I am
> > > > > polarized :)
> > > >
> > > > I would lean towards keeping _mb as well, but if it does have to be
> > > > changed why not _mbuf? At least that's not quite as verbose :)
> > >
> > > I dislike the "mb" abbreviation as I forget it stands for multi-buffe=
r.
> > > I like the "mbuf" suggestion, even-though it conflicts with (Free)BSD=
 mbufs
> > > (which is their SKB).
> >
> > If we all agree, I can go over the series and substitute mb postfix wit=
h mbuf.
> > Any objections?
>=20
> mbuf has too much bsd taste.
>=20
> How about ".frags" instead?
> Then xdp_buff_is_mb() will be xdp_buff_has_frags().
>=20
> I agree that it's not obvious what "mb" suffix stands for,
> but I don't buy at all that it can be confused with "megabyte".
> It's the context that matters.
> In "100mb" it's obvious that "mb" is likely "megabyte",
> but in "xdp.mb" it's certainly not "xdp megabyte".
> Such a sentence has no meaning.
> Imagine we used that suffix for "tc"...
> it would be "tc.mb"... "Traffic Control Megabyte" ??
>=20
> Anyway "xdp.frags" ?
>=20
> Btw "xdp_cpumap" should be cleaned up.
> xdp_cpumap is an attach type. It's not prog type.
> Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?

If we change xdp_devmap/ in xdp/devmap (and xdp_cpumap/ in xdp/cpumap),
are we going to break backward compatibility?
Maybe there are programs already deployed using it.
This is not a xdp multi-buff problem since we are not breaking backward
compatibility there, we can just use:

xdp.frags/devmap
xdp.frags/cpumap

Moreover in samples/bpf we have something like:

SEC("xdp_devmap/egress")

It seems to me the egress postfix is not really used, right? Can we just dr=
op
it?

Regards,
Lorenzo

>=20
> In patch 22 there is a comment:
> /* try to attach BPF_XDP_DEVMAP multi-buff program"
>=20
> It creates further confusion. There is no XDP_DEVMAP program type.
> It should probably read
> "Attach BPF_XDP program with frags to devmap"
>=20
> Patch 21 still has "CHECK". Pls replace it with ASSERT.

--qgtZDZjdAzKt06IF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYeGmZAAKCRA6cBh0uS2t
rIipAQCYHnNufNOJ1rZ7SAvd3fTwJmAVMiPjvH/JrAi2Azkk6QD5AeR+9GhgzOg0
eoYbtUI5Mhuths0PlmfMpZdi1TICMgA=
=LSsR
-----END PGP SIGNATURE-----

--qgtZDZjdAzKt06IF--
