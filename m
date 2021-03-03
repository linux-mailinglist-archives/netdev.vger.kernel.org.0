Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B832C4AB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450242AbhCDAP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:59 -0500
Received: from mail.katalix.com ([3.9.82.81]:58932 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354763AbhCCWet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 17:34:49 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id D3EBF7D718;
        Wed,  3 Mar 2021 22:32:06 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1614810726; bh=JgojL7uEE8S0Atixqtrf9rO9YOzCU+W2zwfhGb2Vqaw=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=203=20Mar=202021=2022:32:06=20+0000|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Matthias=20Schiffer=20<mschiffe
         r@universe-factory.net>|Cc:=20netdev@vger.kernel.org,=20"David=20S
         .=20Miller"=20<davem@davemloft.net>,=0D=0A=09Jakub=20Kicinski=20<k
         uba@kernel.org>,=20linux-kernel@vger.kernel.org|Subject:=20Re:=20[
         PATCH=20net=20v2]=20net:=20l2tp:=20reduce=20log=20level=20of=20mes
         sages=20in=0D=0A=20receive=20path,=20add=20counter=20instead|Messa
         ge-ID:=20<20210303223206.GA7374@katalix.com>|References:=20<bd6f11
         7b433969634b613153ec86ccd9d5fa3fb9.1614707999.git.mschiffer@univer
         se-factory.net>|MIME-Version:=201.0|Content-Disposition:=20inline|
         In-Reply-To:=20<bd6f117b433969634b613153ec86ccd9d5fa3fb9.161470799
         9.git.mschiffer@universe-factory.net>;
        b=bK+8OADEbtVmvEES+L1agA1ssHqKnODjTPqqxzVAb0B4ovgOujLqmqX0GvWOkgZvJ
         0HgSI/UFg2NA596UEn7MO8NSTqIjVxX02Vngb/ogSY7loFpetVpjIWIoI4ABvIXTXg
         Q1c/r70RPFeTDps3N4VEXF6lVWPfnyZ6Yrv6D9MDFmPxgLh6y8cB2q0s+yRiLAbEDa
         MELLgsdEaPOu3BO45LiVG0G4YWH33p8OLdpEYLQl5jv7tTd8IooQRDUt2fTckXWd/V
         7LSZdaDMCFVOzfXPt8JFjktIU3lscmOLpV9IG7o35d0rcAEGXCzJk8/INLAV6nJf9V
         1oFZMIQUbKh7A==
Date:   Wed, 3 Mar 2021 22:32:06 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: l2tp: reduce log level of messages in
 receive path, add counter instead
Message-ID: <20210303223206.GA7374@katalix.com>
References: <bd6f117b433969634b613153ec86ccd9d5fa3fb9.1614707999.git.mschiffer@universe-factory.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <bd6f117b433969634b613153ec86ccd9d5fa3fb9.1614707999.git.mschiffer@universe-factory.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Wed, Mar 03, 2021 at 16:50:49 +0100, Matthias Schiffer wrote:
> Commit 5ee759cda51b ("l2tp: use standard API for warning log messages")
> changed a number of warnings about invalid packets in the receive path
> so that they are always shown, instead of only when a special L2TP debug
> flag is set. Even with rate limiting these warnings can easily cause
> significant log spam - potentially triggered by a malicious party
> sending invalid packets on purpose.
>=20
> In addition these warnings were noticed by projects like Tunneldigger [1],
> which uses L2TP for its data path, but implements its own control
> protocol (which is sufficiently different from L2TP data packets that it
> would always be passed up to userspace even with future extensions of
> L2TP).
>=20
> Some of the warnings were already redundant, as l2tp_stats has a counter
> for these packets. This commit adds one additional counter for invalid
> packets that are passed up to userspace. Packets with unknown session are
> not counted as invalid, as there is nothing wrong with the format of
> these packets.
>=20
> With the additional counter, all of these messages are either redundant
> or benign, so we reduce them to pr_debug_ratelimited().

This looks good to me -- thanks Matthias! :-)

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmBADmIACgkQlIwGZQq6
i9AYpwgAqkpw/Vw8I9Zk6EMpQz8rIw7uRP1RHjJKz94ReoaQUmfPT2Fx87CSm5D4
7ojWyOt7dly9aFKvXF6bvi+KWA6AhzyXrVU0c8SjOxtb86J677HI2w4njsptKvxo
5XPLfLKgo4fFyO4KWMAQqdnZxN8o1w1MKdjc/+B9EEKB9/XO7hf613Sl66eBBBaS
GWSUH1IUYlgRF2JBR3RAq85pZPABzU5oseh10koBB8haSFSltQFbzpdmVuIdFrBp
xQxXjYYf1m4MVYBN/exmifyKicpG0QHGz3kyjWn2SzkC44KCvhdXKpw5Sy9+mIFO
GM11OWGGjNbk1cg9nqs1l58CFe4/mg==
=EHmr
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
