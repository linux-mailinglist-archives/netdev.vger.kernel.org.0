Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC5235A85
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHBU3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:29:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50126 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbgHBU3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:29:18 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1k2Kbc-0001V4-O7; Sun, 02 Aug 2020 21:29:16 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1k2Kbc-000zkL-Bg; Sun, 02 Aug 2020 21:29:16 +0100
Message-ID: <e1beb0b98109d90738e054683f5eb1dd483011dd.camel@decadent.org.uk>
Subject: Re: Bug#966459: linux: traffic class socket options (both
 IPv4/IPv6) inconsistent with docs/standards
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     966459@bugs.debian.org, netdev <netdev@vger.kernel.org>
Date:   Sun, 02 Aug 2020 21:29:07 +0100
In-Reply-To: <Pine.BSM.4.64L.2008021919500.2148@herc.mirbsd.org>
References: <159596111771.2639.6929056987566441726.reportbug@tglase-nb.lan.tarent.de>
         <e67190b7de22fff20fb4c5c084307e0b76001248.camel@decadent.org.uk>
         <Pine.BSM.4.64L.2008021919500.2148@herc.mirbsd.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-16xI0CSsIowPifpy18+9"
User-Agent: Evolution 3.36.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-16xI0CSsIowPifpy18+9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2020-08-02 at 19:29 +0000, Thorsten Glaser wrote:
> Ben Hutchings dixit:
>=20
> >ip(7) also doesn't document IP_PKTOPIONS.
>=20
> Hmm, I don=E2=80=99t use IP_PKTOPIONS though. I=E2=80=99m not exactly sur=
e I found
> the correct place in the kernel for what I do.

The first instance of put_cmsg(...IP_TOS...) you found in
net/ipv4/ip_sockglue.c implements that socket option.

[...]
> >I see no point in changing the IPv6 behaviour: it seems to be
> >consistent with itself and with the standard
>=20
> Not really: if the kernel writes an int and userspace reads
> its first byte, it only works by accident on little endian,
> but not elsewhere.

The RFC says that the IPV6_TCLASS option's value is an int, and that
"the first byte of cmsg_data[] will be the *first byte of the integer*
traffic class" (my emphasis).  We can infer from "the first byte of"
that cmsg_data[] will hold more than one byte.  And "the integer"
suggests that it's a C int, like the socket option.

> >so only risks breaking user-space that works today.
>=20
> Hrm. It risks breaking userspace that reads an int. But the
> RFC clearly says it should read the first byte, not an int.
[...]

No, the wording is *not* clear.

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program
than to understand a correct one.

--=-16xI0CSsIowPifpy18+9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl8nIhMACgkQ57/I7JWG
EQkWgg//bRx1uElityp153erOFuTtWd/bM3gYoyeimSMQKDmkBVLWi3ZuJlBMKbc
glEP8tqtTGxlhg9uUKVzgiFGO6ghEbF4rggNcvoPvZE35YjS/+bQtbEVHOkqhDX+
sMbEJamdLKxPYD0w/dtxcmLoD6BY0R8DJIpKpwN18xIvFWARBgmDkZG0/Wngtp8i
7ZErjYc34l8FgUmFOm3KecqYNe+sdHg7hDqK+Am15sMn3n3rjXSPI+XthHSQIWfb
M7QmvL6G6sUbNns3CkeFn0kLMJamDYPaloPpVt3LUS5NpavNniJpx+ZsyQWBezwz
jv1W0CMahYWs6ZFOehyL/0z8JmYhzIYXlz+RbGsBThy5/miN6Zar1tqfYtqh6xwr
iZWdBPpfcQchYEJLi657iWuQqenCjRdO0VNctJpkJukJWTm88doaG8IhVK5afymH
BcyxZAYODcDWTObKdf3yPFOBWbPWrVJkh7EsQ59mAksd8614dQlOkdj66kFz3XfU
Vcf2/h6+8iENluPme1L4xWJAmq5bamJXR++xOJqjGVELCv1NR1CHOnQOjmV6MsjG
g6M3SxT9Rvo3J5JOkiCD9nSTRFiMW3tEhhaWQnnr+tCsrpt6GEn7n1WCxkhaoNrb
cwsChYOMn6Kp11CgVc/dBiXjNsyxxcf3ruyEBrSqVJrYrpgCXac=
=gIFu
-----END PGP SIGNATURE-----

--=-16xI0CSsIowPifpy18+9--
