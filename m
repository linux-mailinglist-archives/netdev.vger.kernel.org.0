Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB5F2803DA
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732830AbgJAQY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:24:56 -0400
Received: from mail.katalix.com ([3.9.82.81]:43316 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732342AbgJAQY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 12:24:56 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 2902A86B47;
        Thu,  1 Oct 2020 17:24:54 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1601569494; bh=AjPba7j+bjkR9lgwROnypyrxs31pPjP/IgeE0SknijA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=201=20Oct=202020=2017:24:53=20+0100|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Jakub=20Kicinski=20<kuba@kernel
         .org>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Subject
         :=20Re:=20[PATCH=20net-next=205/6]=20l2tp:=20add=20ac_pppoe=20pseu
         dowire=20driver|Message-ID:=20<20201001162453.GB4708@katalix.com>|
         References:=20<20200930210707.10717-1-tparkin@katalix.com>=0D=0A=2
         0<20200930210707.10717-6-tparkin@katalix.com>=0D=0A=20<20201001075
         640.16212741@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>|MIME-V
         ersion:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<202010
         01075640.16212741@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>;
        b=15Ak7Mzw88f/JUH+QhlpsOJRWT6cs+slmlvRrk0EYt3IgjVUxCY6e+QiSm6mi0y6f
         qL2QrMlLLLKe/SXuRS8lMJsq2jEC+o7kqBkrs1XE/pGCups0AUYB1f+PZ5w7y6hS7e
         X2iXeLgZKDLZrsqGjnXtTVO3sWYKBHnP7ptdCtbeUJIJm3Z9M/YjdnqvU9pnmxHWl0
         EkNu7z2GZFG7PXG7QkyTjuEP5xWl7b4iGkWPG4UJl/yPiOfIQMWrTqIaTqYGW8PZEO
         +WmflHM38YPq2pwP2isocEscV5M96rULLskcZet30cidlNMGPlQodxU19DpRSsgmFs
         AUveNQBBc2mbA==
Date:   Thu, 1 Oct 2020 17:24:53 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 5/6] l2tp: add ac_pppoe pseudowire driver
Message-ID: <20201001162453.GB4708@katalix.com>
References: <20200930210707.10717-1-tparkin@katalix.com>
 <20200930210707.10717-6-tparkin@katalix.com>
 <20201001075640.16212741@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <20201001075640.16212741@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Oct 01, 2020 at 07:56:40 -0700, Jakub Kicinski wrote:
> On Wed, 30 Sep 2020 22:07:06 +0100 Tom Parkin wrote:
> > The AC/PPPoE driver implements pseudowire type L2TP_PWTYPE_PPP_AC, for
> > use in a PPPoE Access Concentrator configuration.  Rather than
> > terminating the PPP session locally, the AC/PPPoE driver forwards PPP
> > packets over an L2TP tunnel for termination at the LNS.
> >=20
> > l2tp_ac_pppoe provides a data path for PPPoE session packets, and
> > should be instantiated once a userspace process has completed the PPPoE
> > discovery process.
> >=20
> > To create an instance of an L2TP_PWTYPE_PPP_AC pseudowire, userspace
> > must use the L2TP_CMD_SESSION_CREATE netlink command, and pass the
> > following attributes:
> >=20
> >  * L2TP_ATTR_IFNAME, to specify the name of the interface associated
> >    with the PPPoE session;
> >  * L2TP_ATTR_PPPOE_SESSION_ID, to specify the PPPoE session ID assigned
> >    to the session;
> >  * L2TP_ATTR_PPPOE_PEER_MAC_ADDR, to specify the MAC address of the
> >    PPPoE peer
>=20
> C=3D1 generates:
>=20
> net/l2tp/l2tp_ac_pppoe.c:234:20: warning: incorrect type in argument 1 (d=
ifferent address spaces)
> net/l2tp/l2tp_ac_pppoe.c:234:20:    expected struct net_device *dev
> net/l2tp/l2tp_ac_pppoe.c:234:20:    got struct net_device [noderef] __rcu=
 *dev
> net/l2tp/l2tp_ac_pppoe.c:380:45: error: incompatible types in comparison =
expression (different address spaces):
> net/l2tp/l2tp_ac_pppoe.c:380:45:    struct net_device [noderef] __rcu *
> net/l2tp/l2tp_ac_pppoe.c:380:45:    struct net_device *

Thanks Jakub, and apologies for that slipping through.  My Sparse
installation on Ubuntu wasn't working -- I've updated it now and can
see the error you reported.

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl92AtEACgkQlIwGZQq6
i9Aa9wgAg7dnQfVSTlMSATI7HvmDe+brqaysdLLMfF3ltn2nfcRB21IwjqNIq9fi
W6zAg/4LJ2wqQL1jxw0beH++7vK0yN+laE7G/ugkS75Wkk9NPcbkqYZHR+68+eZ+
wtz7MknXLyj98H5VXkFtW0+8lAnN1fJ1nn+sZIH96NaJq3yAcKp0ipeCu1olSku8
LeO6rGiExt11PsqVEaqH34ePlDWiR0u2Y89jsTNWYFtfsX0KrCQPXVukggRAk/44
KAtu0cCe9OKPgatXT+R/oO5ALE6mIQ/TzhYdUem54A/CaXNnKKpGKxSo+D+i7Mxf
N5PCsix6rDpkyuZMFxeV8cKOQ0E7og==
=6K4o
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
