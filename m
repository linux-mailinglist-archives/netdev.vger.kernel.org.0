Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A02AD688
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgKJMm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:42:26 -0500
Received: from mail.katalix.com ([3.9.82.81]:59680 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgKJMm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 07:42:26 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 1C91296EE6;
        Tue, 10 Nov 2020 12:42:25 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605012145; bh=vwWKX5QwHjg7OvwDtbIY1e/xsYHdMPNtxX9uECmsRK0=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2010=20Nov=202020=2012:42:24=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20Jakub=20Kicinski=20<kuba@kernel.org>,=20netdev@vge
         r.kernel.org,=0D=0A=09jchapman@katalix.com|Subject:=20Re:=20[RFC=2
         0PATCH=200/2]=20add=20ppp_generic=20ioctl=20to=20bridge=20channels
         |Message-ID:=20<20201110124224.GC5635@katalix.com>|References:=20<
         20201106181647.16358-1-tparkin@katalix.com>=0D=0A=20<2020110915523
         7.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>=0D=0A=20
         <20201110092834.GA30007@linux.home>|MIME-Version:=201.0|Content-Di
         sposition:=20inline|In-Reply-To:=20<20201110092834.GA30007@linux.h
         ome>;
        b=gBwdgybVgMC4XR6rOAjAOGp4GI4ZlJ7G69ycgiLH1s6Mfl6R9tVj1XmdQgKkSaCWW
         cAp5P+cKLjwMoslr3eLMe/FLm7OQC/A6oHvxxH0J0+AYzPoBMa3iE+4VdNI6Px4/Bo
         I6OHhNZgMshTIFPVN95yUzFxJo79gi320/h8Ep0YFPNTgHMixJ9OV68B9tokavPKb6
         r/mJ23tQ6/lqUWrXI3cO9wwOonEKC4RDJ2xzgBhX/opADSN7KshgiXmNoe+7ze3HkH
         kQFhkRS2SSbFRL760dP/8Ay4X1M7T5Ip7RyymBKTOxoXDTP4gZDykEq3wcip6G3BGc
         qnfSjN8G3obGA==
Date:   Tue, 10 Nov 2020 12:42:24 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201110124224.GC5635@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201110092834.GA30007@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <20201110092834.GA30007@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Nov 10, 2020 at 10:28:34 +0100, Guillaume Nault wrote:
> On Mon, Nov 09, 2020 at 03:52:37PM -0800, Jakub Kicinski wrote:
> > On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote:
> > > This small RFC series implements a suggestion from Guillaume Nault in
> > > response to my previous submission to add an ac/pppoe driver to the l=
2tp
> > > subsystem[1].
> > >=20
> > > Following Guillaume's advice, this series adds an ioctl to the ppp co=
de
> > > to allow a ppp channel to be bridged to another.
> >=20
> > I have little understanding of the ppp code, but I can't help but
> > wonder why this special channel connection is needed? We have great
> > many ways to redirect traffic between interfaces - bpf, tc, netfilter,
> > is there anything ppp specific that is required here?
>=20
> I can see two viable ways to implement this feature. The one described
> in this patch series is the simplest. The reason why it doesn't reuse
> existing infrastructure is because it has to work at the link layer
> (no netfilter) and also has to work on PPP channels (no network
> device).
>=20
> The alternative, is to implement a virtual network device for the
> protocols we want to support (at least PPPoE and L2TP, maybe PPTP)
> and teach tunnel_key about them.

One potential downside of this approach is the addition of two virtual
interfaces for each pppoe->pppol2tp mapping: the concern here
primarily being the cost of doing so.

I'm not saying the cost is necessarily prohibitive, but the "bridge the
channels" approach in the RFC is certainly cheaper.

Another concern would be the possibility of the virtual devices being
misconfigured in such a way as to e.g. allow locally generated
broadcast packets to go out on one of the interfaces.  Possibly this
would be easy to avoid, I'm not sure.

> I think the question is more about long term maintainance. Do we want
> to keep PPP related module self contained, with low maintainance code
> (the current proposal)? Or are we willing to modernise the
> infrastructure, add support and maintain PPP features in other modules
> like flower, tunnel_key, etc.?

FWIW I would tend to agree.

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+qiqwACgkQlIwGZQq6
i9AL8Af8CKbg3rPpxSX3TuXHJiBGZjOEzvFmwbXQGlTKZv+3mS2WsHAO9PNmoSFS
iNv3jjyusUDb8vEmPrDGkGiMplDAUxfZ6lYj8SEWxH7klaZWKMbkrnyRWoP6cHo9
ncQawzD5q2N3NhC5zpo8J5N+jNiWoX7gNh80zAOXHn/kBUsnCIXZwpXyE3aARd61
IA9JIFK10mbdGjzj+00Km6apgGzWNXWdgwLASkcB6/C1UNnr6Nv0RnohCYCWQ/Ny
w2dunSifSYYX4+FbiE2jPBdjrF68o6AOdzNbEa9XIpIpup51WfG5fJAq4jNNySwk
ecPCe+EyB9CJcYqdqwT8xQf5byTaVg==
=1xIJ
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
