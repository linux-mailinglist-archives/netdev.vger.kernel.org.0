Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94E51ED575
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 19:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgFCR4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 13:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgFCR4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 13:56:16 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2c0f:f930:0:5::214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC34C08C5C0;
        Wed,  3 Jun 2020 10:56:16 -0700 (PDT)
Subject: Re: [PATCH v3] net: dccp: Add SIOCOUTQ IOCTL support (send buffer
 fill)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1591206970;
        bh=R4UTnGlRdgQcgtTv61Z45KO1u0qKIntnh7ReDoaJjjI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=b01pRUdRtSDkVOmBBgLTwH7W+XJoql/gb3sBvYNzzpx7qXMmsBHWyAnLb8t7L/ZO8
         xjug+zqXkSV3eAdRjEUp9jaad4gX+BxH7g2kw4YkzjLY1Hv/TR5MuvfC0ojfkW2LZK
         ptn+Pg7ZGKVAaqljU+FHpcoypUDDIzS6CEyYriU14QmXD2hHjXVclSFfdlB49c/eYp
         UwKmZiDsTvb415/Evfc/Hw9Xzesku7AZhObSejE/e2aM10qe7u2A5CjEDLTB/iaHKK
         BEVa3RsHLWmQTI3b36qze/QBtK9gKlx4lfs1QlUu2mPz+IfC7hWPcp2C6L+cvXNZ+O
         KdorfIzBk3EaA==
To:     David Miller <davem@davemloft.net>
Cc:     gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org, netdev@vger.kernel.org
References: <20200603111051.12224-1-richard_siegfried@systemli.org>
 <20200603.104725.187287052578354245.davem@davemloft.net>
From:   Richard Siegfried <richard_siegfried@systemli.org>
Openpgp: preference=signencrypt
Autocrypt: addr=richard_siegfried@systemli.org; prefer-encrypt=mutual;
 keydata=
 mQENBE3hr2UBCACos1E12camcYIlpe25jaqwu+ATrfuFcCIPsLmff7whzxClsaC78lsxQ3jD
 4MIlOpkIBWJvc4sziai1P/CrafvM0DTuUasCv+mQpup6cFMWy1JmDtJ8X0Ccy/PH83e9Yjnv
 xJu0NhoQAqMZrVmXx4Q7DKcgpvkk9Oyd5u6ocfdb2GhF0Bxa7GySZyYOc4rQvduRLOdNMbnS
 6SM+cTAhMOHtoqKWCP4EogXKALg6LDFcx8yUoMzLRy/YXsnWa1/WayG8Zr6kX84VKhTGUrdG
 Pw4Zg1cQ6vqwMZ4RwaR/9RWK2WnYr7XyOTDBgmCix5c5lu+GeLqUYUIPTvdQ7Xgwx0UhABEB
 AAG0OVJpY2hhcmQgU2llZ2ZyaWVkIFNhaWxlciA8cmljaGFyZF9zaWVnZnJpZWRAc3lzdGVt
 bGkub3JnPokBVwQTAQgAQQIbIwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAIZARYhBAYAIbmK
 zp5fVAuyN/ZBOcwFm+HhBQJanueLBQkSYNKmAAoJEPZBOcwFm+Hh+ugH/2P0yClrZkkMK5y2
 L389qNPlF8i1H77S4NE9zxiHI38jnIFLqjD4F+KzGAXNmOXCw+QYqLL+TmsuGY+5LOLtp/M4
 lG6ajVC1JCcF2+bQrDc11g7AG7A+rySX5JpqSFO7ARfLTs3iW1DoyLN7lBUtL9dV+yx9mRUv
 fx/TcB9ItPhK4rtJuWy3yg6SNBZzkgc0zsCyIkJ4dEtdEW6IgW6Qk242kMVya8fytM02EwEM
 vBTdca/duCO2tEComPeF+8WExM+BfQ+6o3kpqRsOR6Ek6wDsnalFHy8NHaicbEy7qjybGOKZ
 IdvzAyAhsmpu+5ltOfQWViNBseqRk1H9ikuTKTq5AQ0ETeGvZQEIANRmPSJX9qVU+Hi74uvD
 /LYC3wPm5kCAS0Q5jT3AC5cisu8z92b/Bt8DRKwwpu4esZisQu3RSFvnmkrllkuokSAVKxXo
 bZG2yTq+qecrvKtVH99lA0leiy5TdcJdmhJvkcQv7kvIgKYdXSW1BAhUbtX827IGAW1LCvJL
 gKqox3Ftxpi5pf/gVh7NFXU/7n6Nr3NGi5havoReeIy8iVKGFjyCFN67vlyzaTV6yTUIdrko
 StTJJ8c7ECjJSkCW34lj8mR0y9qCRK5gIZURf3jjMQBDuDvHO0XQ4mog6/oOov4vJRyNMhWT
 2b0LG5CFJeOQTQVgfaT1MckluRBvYMZAOmkAEQEAAYkBPAQYAQIAJgIbDBYhBAYAIbmKzp5f
 VAuyN/ZBOcwFm+HhBQJanueQBQkSYNKrAAoJEPZBOcwFm+HhrCAH/2doMkTKWrIzKmBidxOR
 +hvqJfBB4GvoHBsQoqWj85DtgvE5jKc11FYzSDzQjmMKIIBwaOjjrQ8QyXm2CYJlx7/GiEJc
 F3QNa5q3GBgiyZ0h78b2Lbu/sBhaCFSXHfnriRGvIXqsxyPMllqb+LBRy56ed97OQBQX8nFI
 umdUMtt8EFK2SM0KYY1V0COcYqGHMRUiVosTV1aVwoLm2SXsB9jicPUaQbRgsPfglTn00wnl
 fhJ8bAO800MtG+LW6pzP+6EZPvnHhKBS7Xbl6bn6r2OW32T7TeFg0RJbpE/MW1gY0NjgmtWj
 vdhuvK9nHCRL2O/xLofm9aoELUaXGHoxMn4=
Message-ID: <258679e7-9bce-1759-b33f-bdbe8efbcfe5@systemli.org>
Date:   Wed, 3 Jun 2020 19:56:03 +0200
MIME-Version: 1.0
In-Reply-To: <20200603.104725.187287052578354245.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="vQHYZDnDX6Y1IiS59lCMdX5ANX74K6vqL"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vQHYZDnDX6Y1IiS59lCMdX5ANX74K6vqL
Content-Type: multipart/mixed; boundary="89ZoFm6EpSA8mjs7yRDFiFipwN8OfdQUl";
 protected-headers="v1"
From: Richard Siegfried <richard_siegfried@systemli.org>
To: David Miller <davem@davemloft.net>
Cc: gerrit@erg.abdn.ac.uk, dccp@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <258679e7-9bce-1759-b33f-bdbe8efbcfe5@systemli.org>
Subject: Re: [PATCH v3] net: dccp: Add SIOCOUTQ IOCTL support (send buffer
 fill)
References: <20200603111051.12224-1-richard_siegfried@systemli.org>
 <20200603.104725.187287052578354245.davem@davemloft.net>
In-Reply-To: <20200603.104725.187287052578354245.davem@davemloft.net>

--89ZoFm6EpSA8mjs7yRDFiFipwN8OfdQUl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

>=20
> net-next is CLOSED
>=20
Okay, I will resend in next merge window


--89ZoFm6EpSA8mjs7yRDFiFipwN8OfdQUl--

--vQHYZDnDX6Y1IiS59lCMdX5ANX74K6vqL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEBgAhuYrOnl9UC7I39kE5zAWb4eEFAl7X5DgACgkQ9kE5zAWb
4eH+3gf8CsELBtW00HNITSoI2eYgKFKRVMK56gAjj6wcS0BUCZaGjoDHWRGoUFF0
8tqzXr17VQhQKVWhpdl7kpXMhTHhkjxk2OyaMPHiOp8qHt0VrcFvyAk2qgMT9Kww
oj0vsxYfzhdhcv+zx7sR/FqC/NUoQRp1NYj0LlzR67+7lH09n0WZz0xKZdXmSOCS
JHV9xAg/PSJCNTxPbTSShOoENN85C8KxZaWJDQx3SJfmoroI5vGkvpRB/XiWZ+yh
zEC+iej9PoBl1pkYLX+n09xgc6A+CY8pN/14m8aNTA+Ddu+FBFnZjy96vgl5B8/M
+z1BFCEB8NGEPL75BnkCTrI8E+fqoA==
=GAL6
-----END PGP SIGNATURE-----

--vQHYZDnDX6Y1IiS59lCMdX5ANX74K6vqL--
