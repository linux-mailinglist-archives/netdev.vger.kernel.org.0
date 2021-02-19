Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FA531FFB8
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 21:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBSUMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 15:12:45 -0500
Received: from mail.katalix.com ([3.9.82.81]:33384 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229515AbhBSUMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 15:12:44 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 45E4B7D3E9;
        Fri, 19 Feb 2021 20:12:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1613765522; bh=P7Lcrbr257xogzIurGn37yTXv6fSVBT0Lqyc2B7mOQ0=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Fri,=2019=20Feb=202021=2020:12:02=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Matthias=20Schiffer=20<mschiff
         er@universe-factory.net>|Cc:=20netdev@vger.kernel.org,=20"David=20
         S.=20Miller"=20<davem@davemloft.net>,=0D=0A=09Jakub=20Kicinski=20<
         kuba@kernel.org>,=20linux-kernel@vger.kernel.org|Subject:=20Re:=20
         [PATCH=20net]=20net:=20l2tp:=20reduce=20log=20level=20when=20passi
         ng=20up=20invalid=0D=0A=20packets|Message-ID:=20<20210219201201.GA
         4974@katalix.com>|References:=20<f2a482212eed80b5ba22cb590e89d3edb
         290a872.1613760125.git.mschiffer@universe-factory.net>|MIME-Versio
         n:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<f2a482212ee
         d80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-fa
         ctory.net>;
        b=EBDyLC3Thd0Mc01ldtVMByZGvLuayiozIO/ffe1wyYp+W1Fx9qNhn2452b6FqsOZz
         9noLinWDDF1Z6MzsuBXObgD5bkJb8Ocwm7Ub1J2jGA1ZrM2pntg9aHCd9HbJjf5hQe
         ASarwxT6UUp22wM0/9bnWb60Mt4PXMeJYgSb0VjZgRu6Or/GAFOmk4QrSCr7+rwx01
         PO+u9rGWX0HDy1y4vG81A4xQzshRBzfmXgFDYLcPQDsieLswbxhd0Fh1D6nuDFS74g
         K65nQ0fIO10RfgcPo6FkmRh58XzwqZAB8JAohtJenLiUJMIuU4Lio/ay/ZcVED7e6C
         knzriOGh2HOqA==
Date:   Fri, 19 Feb 2021 20:12:02 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <20210219201201.GA4974@katalix.com>
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthias,

Thanks for your patch!

On  Fri, Feb 19, 2021 at 20:06:15 +0100, Matthias Schiffer wrote:
> Before commit 5ee759cda51b ("l2tp: use standard API for warning log
> messages"), it was possible for userspace applications to use their own
> control protocols on the backing sockets of an L2TP kernel device, and as
> long as a packet didn't look like a proper L2TP data packet, it would be
> passed up to userspace just fine.

Hum.  I appreciate we're now logging where we previously were not, but
I would say these warning messages are valid.

It's still perfectly possible to use the L2TP socket for the L2TP control
protocol: packets per the RFCs won't trigger these warnings to the
best of my knowledge, although I'm happy to be proven wrong!

I wonder whether your application is sending non-L2TP packets over the
L2TP socket?  Could you describe the usecase?

> After the mentioned change, this approach would lead to significant log
> spam, as the previously hidden warnings are now shown by default. Not
> even setting the T flag on the custom control packets is sufficient to
> surpress these warnings, as packet length and L2TP version are checked
> before the T flag.

Possibly we could sidestep some of these warnings by moving the T flag
check further up in the function.

The code would need to pull the first byte of the header, check the type
bit, and skip further processing if the bit was set.  Otherwise go on to
pull the rest of the header.

I think I'd prefer this approach assuming the warnings are not
triggered by valid L2TP messages.

>=20
> Reduce all warnings debug level when packets are passed to userspace.
>=20
> Fixes: 5ee759cda51b ("l2tp: use standard API for warning log messages")
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> ---
>=20
> I'm unsure what to do about the pr_warn_ratelimited() in
> l2tp_recv_common(). It feels wrong to me that an incoming network packet
> can trigger a kernel message above debug level at all, so maybe they
> should be downgraded as well? I believe the only reason these were ever
> warnings is that they were not shown by default.
>=20
>=20
>  net/l2tp/l2tp_core.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 7be5103ff2a8..40852488c62a 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -809,8 +809,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tun=
nel, struct sk_buff *skb)
> =20
>  	/* Short packet? */
>  	if (!pskb_may_pull(skb, L2TP_HDR_SIZE_MAX)) {
> -		pr_warn_ratelimited("%s: recv short packet (len=3D%d)\n",
> -				    tunnel->name, skb->len);
> +		pr_debug_ratelimited("%s: recv short packet (len=3D%d)\n",
> +				     tunnel->name, skb->len);
>  		goto error;
>  	}
> @@ -824,8 +824,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tun=
nel, struct sk_buff *skb)
>  	/* Check protocol version */
>  	version =3D hdrflags & L2TP_HDR_VER_MASK;
>  	if (version !=3D tunnel->version) {
> -		pr_warn_ratelimited("%s: recv protocol version mismatch: got %d expect=
ed %d\n",
> -				    tunnel->name, version, tunnel->version);
> +		pr_debug_ratelimited("%s: recv protocol version mismatch: got %d expec=
ted %d\n",
> +				     tunnel->name, version, tunnel->version);
>  		goto error;
>  	}
> =20
> @@ -863,8 +863,8 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tun=
nel, struct sk_buff *skb)
>  			l2tp_session_dec_refcount(session);
> =20
>  		/* Not found? Pass to userspace to deal with */
> -		pr_warn_ratelimited("%s: no session found (%u/%u). Passing up.\n",
> -				    tunnel->name, tunnel_id, session_id);
> +		pr_debug_ratelimited("%s: no session found (%u/%u). Passing up.\n",
> +				     tunnel->name, tunnel_id, session_id);
>  		goto error;
>  	}
> =20

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmAwG4oACgkQlIwGZQq6
i9A47gf/VffJsF47C1/H+rReeMCzD5XLkWVrx9mwEgQiaRcbh4peQjHFUvecTWI8
ivHrZGL7JGNpSdfCvXbfhhqyVpXN2n24OVPQp79uGSte2w2jtWhHw8aVhm1c6DGx
IaTRDju6owErgDdJ075ClceAIYv1VbpsQ13fjhqVfzxmRnqyLcWWAhgLYFRYdDxJ
gC25E9KQSySq4uEtk29Khvs7YHtWODSB/1TKkK6mQkDzn5V+omu//WZi6cEXVY9z
B0DpdDbYhBfm1XMX31IcJLW+KJXOsBatK1RGGOtI+3b8P+pEs+4ErVs3jQbU7t1Z
HzHjU5zBh8r0CoO1CuTUk4rclb0JmQ==
=yRXz
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
