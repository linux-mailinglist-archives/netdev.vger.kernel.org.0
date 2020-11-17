Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B4D2B5F10
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgKQM0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:26:40 -0500
Received: from mail.katalix.com ([3.9.82.81]:53304 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgKQM0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 07:26:40 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id ADECA96F3B;
        Tue, 17 Nov 2020 12:26:38 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1605615998; bh=0MR27wFcrrbdD/9MnLKKr2yIpSsWYlYeYYqgdPCR1g4=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2017=20Nov=202020=2012:26:38=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[RFC=20PATCH=201/2]=20ppp:=20add=20PPPIOCBRIDGECHAN=
         20ioctl|Message-ID:=20<20201117122638.GB4640@katalix.com>|Referenc
         es:=20<20201106181647.16358-1-tparkin@katalix.com>=0D=0A=20<202011
         06181647.16358-2-tparkin@katalix.com>=0D=0A=20<20201109232401.GM23
         66@linux.home>=0D=0A=20<20201110120429.GB5635@katalix.com>=0D=0A=2
         0<20201115162838.GF11274@linux.home>|MIME-Version:=201.0|Content-D
         isposition:=20inline|In-Reply-To:=20<20201115162838.GF11274@linux.
         home>;
        b=KsY6GLy9bqBhDHKyp+z6qE15g83YUj8tRSFjuo4zNA9Q/qPloZAYgQvGJaB7VssIW
         2nBCVmweDA7m7nrGMwAvRiA88YuT5oQYJDUW1bJUyDAdNJ4uGXgr9m7Go4KWKD6pmt
         xYcbroRkYQAoVp21ddpx/bMJJA5yyBVPlnQEKaC/iYkNwhsSFRlTkg04IhqCDBVbe+
         D2wP4BnrXMxGFVhNd33qTrGG+oNWh/aEFgK3mc6GqdBQPdKPqBD67VtS0P33S0M8lG
         vlnjIG/Dx1Qvg/arPpmr8xvPH7GB6yE6cYW4057Vhl23/H5zi2YIcbPWox2DfZy5G4
         tAj5tfwCa8FHw==
Date:   Tue, 17 Nov 2020 12:26:38 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 1/2] ppp: add PPPIOCBRIDGECHAN ioctl
Message-ID: <20201117122638.GB4640@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201106181647.16358-2-tparkin@katalix.com>
 <20201109232401.GM2366@linux.home>
 <20201110120429.GB5635@katalix.com>
 <20201115162838.GF11274@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <20201115162838.GF11274@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Sun, Nov 15, 2020 at 17:28:38 +0100, Guillaume Nault wrote:
> On Tue, Nov 10, 2020 at 12:04:29PM +0000, Tom Parkin wrote:
> > On  Tue, Nov 10, 2020 at 00:24:01 +0100, Guillaume Nault wrote:
> > > On Fri, Nov 06, 2020 at 06:16:46PM +0000, Tom Parkin wrote:
> > > > +				err =3D 0;
> > > > +			}
> > > > +			spin_unlock_bh(&pn->all_channels_lock);
> > > > +			break;
> > > >  		default:
> > > >  			down_read(&pch->chan_sem);
> > > >  			chan =3D pch->chan;
> > > > @@ -2100,6 +2120,12 @@ ppp_input(struct ppp_channel *chan, struct s=
k_buff *skb)
> > > >  		return;
> > > >  	}
> > > > =20
> > > > +	if (pch->bridge) {
> > > > +		skb_queue_tail(&pch->bridge->file.xq, skb);
> > >=20
> > > The bridged channel might reside in a different network namespace.
> > > So it seems that skb_scrub_packet() is needed before sending the
> > > packet.
> >=20
> > I'm not sure about this.
> >=20
> > PPPIOCBRIDGECHAN is looking up the bridged channel in the ppp_pernet
> > list.  Unless the channel can migrate across network namespaces after
> > the bridge is set up I don't think it would be possible for the
> > bridged channel to be in a different namespace.
> >=20
> > Am I missing something here?
>=20
> So yes, channels can't migrate across namespaces. However, the bridged
> channel is looked up from the caller's current namespace, which isn't
> guaranteed to be the same namespace as the channel used in the ioctl().
>=20
> For example:
>=20
> setns(ns1, CLONE_NEWNET);
> chan_ns1 =3D open("/dev/ppp");
> ...
> setns(ns2, CLONE_NEWNET);
> chan_ns2 =3D open("/dev/ppp");
> ...
> ioctl(chan_ns1, PPPIOCBRIDGECHAN, chan_ns2_id);
>=20
> Here, chan_ns1 belongs to ns1, but chan_ns2_id will be looked up in the
> context of ns2. I find it nice to have the possibility to bridge
> channels from different namespaces, but we have to handle the case
> correctly.

Ah, of course, I see what you're saying.

Agreed we should add the skb_scrub_packet() call.

> > > > +		ppp_channel_push(pch->bridge);
> > >=20
> > > I'm not sure if the skb_queue_tail()/ppp_channel_push() sequence real=
ly
> > > is necessary. We're not going through a PPP unit, so we have no risk =
of
> > > recursion here. Also, if ->start_xmit() fails, I see no reason for
> > > requeuing the skb, like __ppp_channel_push() does. I'd have to think
> > > more about it, but I believe that we could call the channel's
> > > ->start_xmit() function directly (respecting the locking constraints
> > > of course).
> >=20
> > I take your point about re-queuing based on the return of
> > ->start_xmit().  For pppoe and pppol2tp start_xmit just swallows the
> > skb on failure in any case, so for this specific usecase queuing is
> > not an issue.
>=20
> Indeed.
>=20
> > However, my primary motivation for using ppp_channel_push was actually
> > the handling for managing dropping the packet if the channel was
> > deregistered.
>=20
> I might be missing something, but I don't see what ppp_channel_push()
> does appart from holding the xmit lock and handling the xmit queue.
> If we agree that there's no need to use the xmit queue, all
> ppp_channel_push() does for us is taking pch->downl, which we probably
> can do on our own.
>=20
> > It'd be simple enough to add another function which performed the same
> > deregistration check but didn't transmit via. the queue.
>=20
> That's probably what I'm missing: what do you mean by "deregistration
> check"? I can't see anything like this in ppp_channel_push().

It's literally just the check on pch->chan once pch->downl is held.
So it would be trivial to do the same thing in a different codepath: I
just figured why reinvent the wheel :-)

Sorry for the confusion.

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl+zwXoACgkQlIwGZQq6
i9A6DAf/YuxaoRweT9fdLn+WZO0T1i3nts68klxWx1z5PZCpoA0cJFq6vjG//2a+
IGMnB7I2VQNB6VRVRmFKjPsqnnB8eh9D7Eyb9V047C3D29YO+dmWiKjDEwf0kji5
QBnXZLeI5tLVGNuGHmAXWcJKdf16Yi1EU5PA8gHzLzaI4RvfqlzAUKxb8tt/y6KN
gc0uAB1WasKFue/j75W4j9vKYZnr7ORrFNioQM9kfkMjQ5l67HzqfXIavpsGm1D9
fSkgqMiKb11+C58C1LUgaMwqy5jU6WAYDwrIFLGl887AlffFyXmX3C2qAsNK0X1E
ejeEndNrpY3eJ7FCO4LaR8mV9RhB/A==
=O6DT
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
