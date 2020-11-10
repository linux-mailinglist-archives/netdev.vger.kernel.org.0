Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA582AD5D7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 13:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgKJMEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 07:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgKJMEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 07:04:30 -0500
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1915DC0613CF
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 04:04:30 -0800 (PST)
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 719C696F0A;
        Tue, 10 Nov 2020 12:04:29 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605009869; bh=kZh7lkkjlw+156YFO4ZDORzAZQn9JyYjC3oJB4Ui5Mg=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2010=20Nov=202020=2012:04:29=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[RFC=20PATCH=201/2]=20ppp:=20add=20PPPIOCBRIDGECHAN=
         20ioctl|Message-ID:=20<20201110120429.GB5635@katalix.com>|Referenc
         es:=20<20201106181647.16358-1-tparkin@katalix.com>=0D=0A=20<202011
         06181647.16358-2-tparkin@katalix.com>=0D=0A=20<20201109232401.GM23
         66@linux.home>|MIME-Version:=201.0|Content-Disposition:=20inline|I
         n-Reply-To:=20<20201109232401.GM2366@linux.home>;
        b=EUbwpGGXqC4+kBFI5EIBMJXne6F+tifqciInuVfYG5mLhNDbhwfk5z7/eG71yhMZ4
         481n2eTJhp9QtF21wiFqxDi4r7mLOkutMk/xkorFCKeGaJr/W1wOjfTCPgZUGaGAFd
         skktSf0hlEjDD2mxp4Z/s7Kb7fwnW2RIOjBfBXFD0fNwtR2anM+Yr4GKwPsx/vDzQ7
         PjbW4wGbDYKWXmQXzHLQFMPcprEUvuuZ2NEH2S0zjc3T8GrQBL1B1PhKneCj32Fbzt
         DMPRUTbrRmK4N4Ld/m/R9Wb8c7AvV58w6jlIcQ/ShnztdGlpN8hpiRrBdT2y4E7fyO
         TdC8BPP+1EMDQ==
Date:   Tue, 10 Nov 2020 12:04:29 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 1/2] ppp: add PPPIOCBRIDGECHAN ioctl
Message-ID: <20201110120429.GB5635@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201106181647.16358-2-tparkin@katalix.com>
 <20201109232401.GM2366@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20201109232401.GM2366@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Nov 10, 2020 at 00:24:01 +0100, Guillaume Nault wrote:
> On Fri, Nov 06, 2020 at 06:16:46PM +0000, Tom Parkin wrote:
> > +		case PPPIOCBRIDGECHAN:
> > +			if (get_user(unit, p))
> > +				break;
> > +			err =3D -ENXIO;
> > +			if (pch->bridge) {
> > +				err =3D -EALREADY;
> > +				break;
> > +			}
> > +			pn =3D ppp_pernet(current->nsproxy->net_ns);
> > +			spin_lock_bh(&pn->all_channels_lock);
> > +			pchb =3D ppp_find_channel(pn, unit);
> > +			if (pchb) {
> > +				refcount_inc(&pchb->file.refcnt);
> > +				pch->bridge =3D pchb;
>=20
> I think we shouldn't modify ->bridge if it's already set or if the
> channel is already part of of a PPP unit  (that is, if pch->ppp or
> pch->bridge is not NULL).
>=20
> This also means that we have to use appropriate locking.

Yes, good point about checking for the channel being part of a PPP
unit.

> > +				err =3D 0;
> > +			}
> > +			spin_unlock_bh(&pn->all_channels_lock);
> > +			break;
> >  		default:
> >  			down_read(&pch->chan_sem);
> >  			chan =3D pch->chan;
> > @@ -2100,6 +2120,12 @@ ppp_input(struct ppp_channel *chan, struct sk_bu=
ff *skb)
> >  		return;
> >  	}
> > =20
> > +	if (pch->bridge) {
> > +		skb_queue_tail(&pch->bridge->file.xq, skb);
>=20
> The bridged channel might reside in a different network namespace.
> So it seems that skb_scrub_packet() is needed before sending the
> packet.

I'm not sure about this.

PPPIOCBRIDGECHAN is looking up the bridged channel in the ppp_pernet
list.  Unless the channel can migrate across network namespaces after
the bridge is set up I don't think it would be possible for the
bridged channel to be in a different namespace.

Am I missing something here?

>=20
> > +		ppp_channel_push(pch->bridge);
>=20
> I'm not sure if the skb_queue_tail()/ppp_channel_push() sequence really
> is necessary. We're not going through a PPP unit, so we have no risk of
> recursion here. Also, if ->start_xmit() fails, I see no reason for
> requeuing the skb, like __ppp_channel_push() does. I'd have to think
> more about it, but I believe that we could call the channel's
> ->start_xmit() function directly (respecting the locking constraints
> of course).

I take your point about re-queuing based on the return of
->start_xmit().  For pppoe and pppol2tp start_xmit just swallows the
skb on failure in any case, so for this specific usecase queuing is
not an issue.

However, my primary motivation for using ppp_channel_push was actually
the handling for managing dropping the packet if the channel was
deregistered.

It'd be simple enough to add another function which performed the same
deregistration check but didn't transmit via. the queue.

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+qgcgACgkQlIwGZQq6
i9B99QgAnolpcl0Y2rmetdjyGnRy5bqxvYo23X+sRyIi+SS9OvcSAZpfmDNIx1gz
lY8BIYRdB5mG6EyZ8ZjINnJq38HRkCQlZP5Tyfqtk1shKkE3SgYLrLtetnSgSXfg
PriqB0U1LgPoN4o5MGtRkUAnxlqTBVAnapsMKkSJ/PGMiXBslbDyiZZLwMSkkeH3
huvpuriUCw7FSBGqoy5ZaAqdgQ6noZDPl2d0a334NLobUE2lHIjbs+h4XaU7UiBH
h06GWzxHEJM4W0Fvsz3kkTDkX6f6PnsGLY4KzUpeFoBSEdgP9I2FMBbYcTGHjbrW
cIobTjcQEDISvgxsWKgEQkmq/6CPvA==
=3xbk
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
