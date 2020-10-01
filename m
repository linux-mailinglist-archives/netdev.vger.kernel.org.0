Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816B02801CB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732616AbgJAO5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:57:34 -0400
Received: from mail.katalix.com ([3.9.82.81]:42614 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732594AbgJAO5b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 10:57:31 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 420948AD68;
        Thu,  1 Oct 2020 15:57:29 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601564249; bh=ODU+ecc/TJexyeOy+Dr8Q47qo0cPcZWtLatWf7Co2Jk=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=201=20Oct=202020=2015:57:29=20+0100|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@red
         hat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Subj
         ect:=20Re:=20[PATCH=20net-next=200/6]=20l2tp:=20add=20ac/pppoe=20d
         river|Message-ID:=20<20201001145728.GA4708@katalix.com>|References
         :=20<20200930210707.10717-1-tparkin@katalix.com>=0D=0A=20<20201001
         122617.GA9528@pc-2.home>|MIME-Version:=201.0|Content-Disposition:=
         20inline|In-Reply-To:=20<20201001122617.GA9528@pc-2.home>;
        b=2gl+ODcfgDl0/Fi5Le4B8trM69ug3e3O47nPUwAwzkP07wwd7GzH/0uj5Vu+vZmmI
         5SwJtfrQJ6U9ueqiRQCbF/JjUFNLFTJmyJ1zE1wnpmd8dgA4WljqOxqPNEy4+riGgI
         lyOPsP2dBMwC3h4uIadAnY6cRVzNlJ8nTk1pUCH0dv+taaY4LpIuKxWOhnAtUbWWXH
         lf3DwHAfna3C3K7/gNBSk3ZcEVmqgG2DRYgS2rAWuepIQJlqKcdirQAgw5CDsFJa+p
         edEP6ZBDtPpbde1iDZEnaSTIVbhlRjBZRzRBQOHHBQi+77QIjUz3HPsTHfY0+3X68U
         Raxx3ZDQO2l8w==
Date:   Thu, 1 Oct 2020 15:57:29 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 0/6] l2tp: add ac/pppoe driver
Message-ID: <20201001145728.GA4708@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
 <20201001122617.GA9528@pc-2.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20201001122617.GA9528@pc-2.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Oct 01, 2020 at 14:26:17 +0200, Guillaume Nault wrote:
> On Wed, Sep 30, 2020 at 10:07:01PM +0100, Tom Parkin wrote:
> > L2TPv2 tunnels are often used as a part of a home broadband connection,
> > using a PPP link to connect the subscriber network into the Internet
> > Service Provider's network.
> >=20
> > In this scenario, PPPoE is widely used between the L2TP Access
> > Concentrator (LAC) and the subscriber.  The LAC effectively acts as a
> > PPPoE server, switching PPP frames from incoming PPPoE packets into an
> > L2TP session.  The PPP session is then terminated at the L2TP Network
> > Server (LNS) on the edge of the ISP's IP network.
> >=20
> > This patchset adds a driver to the L2TP subsystem to support this mode
> > of operation.
>=20
> Hi Tom,
>=20
> Nice to see someone working on this use case. However, have you
> considered other implementation approaches?
>=20
> This new module reimplements PPPoE in net/l2tp (ouch!), so we'd now
> have two PPPoE implementations with two different packet handlers for
> ETH_P_PPP_SES. Also this implementation doesn't take into account other
> related use cases, like forwarding PPP frames between two L2TP sessions
> (not even talking about PPTP).
>=20
> A much simpler and more general approach would be to define a new PPP
> ioctl, to "bridge" two PPP channels together. I discussed this with
> DaveM at netdevconf 2.2 (Seoul, 2017) and we agreed that it was
> probably the best way forward.

Hi Guillaume,

Thank you for reviewing the patchset.

I hadn't considered supporting this usecase in the ppp subsystem
directly, so thank you for that suggestion.  I can definitely see the
appeal of avoiding reimplementing the PPPoE session packet handling.
Having looked at the ppp code, I think it'd be a smaller change
overall than this series, so that's also appealing.

I'll wait on a little to let any other review comments come in, but
if doing as you suggest is still the preferred approach I'll happily
look at implementing it -- assuming you don't have a patch ready to go?

Best regards,
Tom

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl917lQACgkQlIwGZQq6
i9CUuwf/bCkR5P3jEo/kn53yQQhU0p5i7AxZPt0aoxCwNrJ70820Dkv640yHxrms
AwiWprQqkQZd/yrvJaSDGwCtvIGVDsJtUMm/eaN+IVC0EH/yxQP44NzZo98MZlAy
eyq2hYeG+n7h0+gSxsiC28UsaPgKUCzUtSP+W4HTxS3rDCpZlJuqmrcmukpfkOeh
DWPhEP7eHgHwu7D45ryor/4kBb3l8wJrRWTMji02tUVtK4YfrvNBzAMoZjOLshdz
bt8gEbhQ0WgNeC+1ykGa+BQHvK6cvls6IGL03uuznKmOjPDsd/GI/AIt+qHa02Uy
B+36Qi1TSun1KqGmAUbL23nLhWPMlQ==
=lijL
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
