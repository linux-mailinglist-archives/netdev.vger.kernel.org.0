Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64C641E952
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352787AbhJAJFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhJAJFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:05:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4ADE061A51;
        Fri,  1 Oct 2021 09:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633079041;
        bh=iwd69jO+HUZ5Wr9iGcz1eQEUZyYDvXgW0N/7XTUzUms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=owffkWakkynFhh0RZ7OilXtduRA5POi9p25zNXAgUcF6GyG+F2s970xLfmME8gkf4
         XSvX2yUzl3meXbMj6SdsglCB/Z8rZVkShLzFNnC5Cgb0j1ZgoWuDHBtDqOXXU5WBtY
         bHn0f4oFJp9oVbupt+BuW4n4fMQoEv5ZkT7AmdcW8+IngA7Q1PNOgi9yBA6rl6LtHB
         /KMcluDYSfunFmWzBq7s/98kXBUUPOKxIGOIoaAXuX9ERmRlA0R7MXUztCkKbPrAex
         9O5y1UJ+MJNZ/mJ4Os0DeHpSbo4Vu/dF7yTh3qZH9l3XVJQyfIogd0IsPCm4DXr6Pa
         iTkO8zbm3Jz6w==
Date:   Fri, 1 Oct 2021 11:03:58 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YVbO/kit/mjWTrv6@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACAyw9-8t8RpJgJUTd7u6bOLnJ1xQsgK7z37QrL9T1FUaJ7WNQ@mail.gmail.com>
 <87v92jinv7.fsf@toke.dk>
 <CACAyw99S9v658UyiKz3ad4kja7rDNfYv+9VOXZHCUOtam_C8Wg@mail.gmail.com>
 <CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com>
 <20210929122229.1d0c4960@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87mtnvi0bc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="88BAqEkjHIrKkCZm"
Content-Disposition: inline
In-Reply-To: <87mtnvi0bc.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--88BAqEkjHIrKkCZm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > On Wed, 29 Sep 2021 11:54:46 -0700 Alexei Starovoitov wrote:
> >> I'm missing something. Why do we need a separate flush() helper?
> >> Can't we do:
> >> char buf[64], *p;
> >> p =3D xdp_mb_pointer(ctx, flags, off, len, buf);
> >> read/write p[]
> >> if (p =3D=3D buf)
> >>     xdp_store_bytes(ctx, off, buf, len, flags);
> >
> > Sure we can. That's what I meant by "leave the checking to the program".
> > It's bike shedding at this point.
>=20
> Yeah, let's discuss the details once we have a patch :)
>=20
> -Toke
>=20

Hi,

I implemented the xdp_mb_pointer/xdp_mb_pointer_flush logic here (according=
 to
current discussion):
https://github.com/LorenzoBianconi/bpf-next/commit/a5c61c0fa6cb05bab8caebd9=
6aca5fbbd9510867

For the moment I have only defined two utility routines and I have not expo=
rted
them in ebpf helpers since I need to check what are missing bits in the ver=
ifier
code (but afaik this would be orthogonal with respect to the "helper code"):
- bpf_xdp_pointer --> xdp_mb_pointer
- bpf_xdp_copy_buf --> xdp_mb_pointer_flush

In order to test them I have defined two new ebpf helpers (they use
bpf_xdp_pointer/bpf_xdp_copy_buf internally):
- bpf_xdp_load_bytes
- bpf_xdp_store_bytes

In order to test bpf_xdp_load_bytes/bpf_xdp_store_bytes +
bpf_xdp_pointer/bpf_xdp_copy_buf I added some selftests here:
https://github.com/LorenzoBianconi/bpf-next/commit/5661a491a890c00db744f288=
4b7ee3a6d0319384

Can you please check if the code above is aligned to current requirements o=
r if
it is missing something?
If this code it is fine, I guess we have two option here:
- integrate the commits above in xdp multi-buff series (posting v15) and wo=
rk on
  the verfier code in parallel (if xdp_mb_pointer helper is not required fr=
om day0)
- integrate verfier changes in xdp multi-buff series, drop bpf_xdp_load_byt=
es
  helper (probably we will still need bpf_xdp_store_bytes) and introduce
  bpf_xdp_pointer as new ebpf helper.

I am fine both ways. If we decide for the second option I would need some
guidance on verifier changes since I am not so familiar with that code.

Regards,
Lorenzo

--88BAqEkjHIrKkCZm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYVbO/gAKCRA6cBh0uS2t
rJ8JAP9D2kamqTzQ+NFNbMWI7liuogHec6NtoHZLAXQFh7SyugEAogNjLCtZ4jbP
fYNYLuqqmWHBppry7h3u8tRUhjT9mwU=
=FrL+
-----END PGP SIGNATURE-----

--88BAqEkjHIrKkCZm--
