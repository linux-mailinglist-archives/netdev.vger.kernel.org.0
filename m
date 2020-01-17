Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14BF140A90
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgAQNSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:18:51 -0500
Received: from mail.katalix.com ([3.9.82.81]:36538 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726587AbgAQNSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 08:18:51 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 63E3B86ACB;
        Fri, 17 Jan 2020 13:18:49 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579267129; bh=QT5gx73gq77Yfnvv9SHZ2TKLPiV3QdDcQggOaKmz388=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BsDIw1Kg92lXEMAGfhFkrR3J0SjB2zrMzKLB6Qkove+FksNZ+FUXRWoPWSO1OSnD/
         9fQ90aIOqvNKhVwSvpq5J0xklR1JUHlhLWBw/gHA4W9jDucl1hTtNjkVsfn92CHZwc
         SkOCPUBKrO5wazQUi7XCjp9Dn8VJEUHCDBB5f8ySATDfc4ccdUnHyep/c0KLBnBHxr
         KSaLKU8yaRnD4dxDypwX1IF4+cmKRfO32yrn8lfs6ISigbWzXPS4sRp/giU60URy6k
         Ku1C04dVXo5sZsnYR3af0SkOBpJomyteAdSeCfv4rtuUDGhGA5/eOHnVe3i9ZfiDHE
         JQoVJ06p6ngow==
Date:   Fri, 17 Jan 2020 13:18:49 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117131848.GA3405@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Jan 17, 2020 at 10:50:55 +1300, Ridge Kennedy wrote:
> On Thu, 16 Jan 2020, Tom Parkin wrote:
>=20
> > On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
> > > On Thu, Jan 16, 2020 at 01:12:24PM +0000, Tom Parkin wrote:
> > > > I agree with you about the possibility for cross-talk, and I would
> > > > welcome l2tp_ip/ip6 doing more validation.  But I don't think we sh=
ould
> > > > ditch the global list.
> > > >=20
> > > > As per the RFC, for L2TPv3 the session ID should be a unique
> > > > identifier for the LCCE.  So it's reasonable that the kernel should
> > > > enforce that when registering sessions.
> > > >=20
> > > I had never thought that the session ID could have global significance
> > > in L2TPv3, but maybe that's because my experience is mostly about
> > > L2TPv2. I haven't read RFC 3931 in detail, but I can't see how
> > > restricting the scope of sessions to their parent tunnel would confli=
ct
> > > with the RFC.
> >=20
> > Sorry Guillaume, I responded to your other mail without reading this
> > one.
> >=20
> > I gave more detail in my other response: it boils down to how RFC 3931
> > changes the use of IDs in the L2TP header.  Data packets for IP or UDP
> > only contain the 32-bit session ID, and hence this must be unique to
> > the LCCE to allow the destination session to be successfully
> > identified.
> >=20
> > > > When you're referring to cross-talk, I wonder whether you have in m=
ind
> > > > normal operation or malicious intent?  I suppose it would be possib=
le
> > > > for someone to craft session data packets in order to disrupt a
> > > > session.
> > > >=20
> > > What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 modu=
le
> > > is loaded, a peer can reach whatever L2TPv3 session exists on the host
> > > just by sending an L2TP_IP packet to it.
> > > I don't know how practical it is to exploit this fact, but it looks
> > > like it's asking for trouble.
> >=20
> > Yes, I agree, although practically it's only a slightly easier
> > "exploit" than L2TP/UDP offers.
> >=20
> > The UDP case requires a rogue packet to be delivered to the correct
> > socket AND have a session ID matching that of one in the associated
> > tunnel.
> >=20
> > It's a slightly more arduous scenario to engineer than the existing
> > L2TPv3/IP case, but only a little.
> >=20
> > I also don't know how practical this would be to leverage to cause
> > problems.
> >=20
> > > > For normal operation, you just need to get the wrong packet on the
> > > > wrong socket to run into trouble of course.  In such a situation
> > > > having a unique session ID for v3 helps you to determine that
> > > > something has gone wrong, which is what the UDP encap recv path does
> > > > if the session data packet's session ID isn't found in the context =
of
> > > > the socket that receives it.
> > > Unique global session IDs might help troubleshooting, but they also
> > > break some use cases, as reported by Ridge. At some point, we'll have
> > > to make a choice, or even add a knob if necessary.
> >=20
> > I suspect we need to reach agreement on what RFC 3931 implies before
> > making headway on what the kernel should ideally do.
> >=20
> > There is perhaps room for pragmatism given that the kernel
> > used to be more permissive prior to dbdbc73b4478, and we weren't
> > inundated with reports of session ID clashes.
> >=20
>=20
> A knob (module_param?) to enable the permissive behaviour would certainly
> work for me.

I think a knob might be the worst of both worlds.  It'd be more to test,
and more to document.  I think explaining to a user when they'd want
to use the knob might be quite involved.  So personally I'd sooner
either make the change or not.

More generally, for v3 having the session ID be unique to the LCCE is
required to make IP-encap work at all.  We can't reliably obtain the
tunnel context from the socket because we've only got a 3-tuple
address to direct an incoming frame to a given socket; and the L2TPv3
IP-encap data packet header only contains the session ID, so that's
literally all there is to work with.

If we relax the restriction for UDP-encap then it fixes your (Ridge's)
use case; but it does impose some restrictions:

 1. The l2tp subsystem has an existing bug for UDP encap where
 SO_REUSEADDR is used, as I've mentioned.  Where the 5-tuple address of
 two sockets clashes, frames may be directed to either socket.  So
 determining the tunnel context from the socket isn't valid in this
 situation.

 For L2TPv2 we could fix this by looking the tunnel context up using
 the tunnel ID in the header.

 For L2TPv3 there is no tunnel ID in the header.  If we allow
 duplicated session IDs for L2TPv3/UDP, there's no way to fix the
 problem.

 This sounds like a bit of a corner case, although its surprising how
 many implementations expect all traffic over port 1701, making
 5-tuple clashes more likely.

 2. Part of the rationale for L2TPv3's approach to IDs is that it
 allows the data plane to potentially be more efficient since a
 session can be identified by session ID alone.
=20
 The kernel hasn't really exploited that fact fully (UDP encap
 still uses the socket to get the tunnel context), but if we make
 this change we'll be restricting the optimisations we might make
 in the future.

Ultimately it comes down to a judgement call.  Being unable to fix
the SO_REUSEADDR bug would be the biggest practical headache I
think.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4htDMACgkQlIwGZQq6
i9B9swf+J1AixeGWYWxKXRI1kUQVJw6tJUjneD4sPhk4hvMwKEur8sDeL5MY4k5F
sxlpxzVzg96EwPXQZXlUWR0Ts/U3Er/Ph6qQXGPk7A1czM2QnXNpRxZ53nDr9TyR
g+bklDyF2GSXzZwBc1M2CZDixEGG/V6GhJ3H+nQnkytB+t1b9rDCI5c/F6NMk6qF
ss7XSE+N/ecaupJT3PcCZhcWqWIFcBY5i8M8bQJKzvPoSDPx6ODrYUGAqpZtyfv8
0FSZs8REKoCQmD8Ljr3mOcN3aMnvJxgvkdvtxe4fE+bT/qlAP81C6zoV2Q/gK10I
pIwzL3LxaQL5N+p8tXC3UKFVyDeutg==
=Gb80
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
