Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8410E28D439
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgJMTIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 15:08:05 -0400
Received: from mail1.systemli.org ([192.68.11.209]:34344 "EHLO
        mail1.systemli.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgJMTIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 15:08:04 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 15:08:02 EDT
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1602615523;
        bh=PHt1+Y+M9O7RcuFbfb1lsOWaqXA0PJHKNi0LYmRfAEk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=veaxFPxMCSHBFnG+4P7/Wl8dPZNMcwsB8JgF4VP2mgcfzHyLkdHq/alL8N4s2z/NS
         mPJJvCzZtsljZefrPAtIyGYpyFSmiJ7/wfut5wnjMhGg3qFdQEOFdO5dXzLTYmLR7F
         0UAYcoGsk9IAMYBilLzOeeINGlsGen9RH/W0nzZieyxcR4/p6DzCMxXnIx2AlOikhM
         ouoYD1lK3gLR0NefMjXuAIMhl8ccv4dFIv07RnO23r/S0hedHHILh3SXaQgRVomSA9
         WGTSiMrKv9zs0BzOVEtT1gGeQIdxvxceJADF4Heaqc0Vlyv+BB9kEM8uCG7KO/Rf3g
         GF2JFb8M+AdYQ==
To:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>,
        netdev@vger.kernel.org
Cc:     Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        dccp@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-2-kleber.souza@canonical.com>
From:   Richard Sailer <richard_siegfried@systemli.org>
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
Message-ID: <0de6cc66-8825-6631-843e-68fc9e2c1517@systemli.org>
Date:   Tue, 13 Oct 2020 20:58:34 +0200
MIME-Version: 1.0
In-Reply-To: <20201013171849.236025-2-kleber.souza@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="KHVaNnR0CtdkaZCgAsBVhWbXcrEqCZBOz"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KHVaNnR0CtdkaZCgAsBVhWbXcrEqCZBOz
Content-Type: multipart/mixed; boundary="dfjn9C3XkBZ9ZjEm6mKvr0DLGL7w3liEv";
 protected-headers="v1"
From: Richard Sailer <richard_siegfried@systemli.org>
To: Kleber Sacilotto de Souza <kleber.souza@canonical.com>,
 netdev@vger.kernel.org
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Alexander A. Klimov" <grandmaster@al2klimov.de>,
 Kees Cook <keescook@chromium.org>, Eric Dumazet <edumazet@google.com>,
 Alexey Kodanev <alexey.kodanev@oracle.com>, dccp@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <0de6cc66-8825-6631-843e-68fc9e2c1517@systemli.org>
Subject: Re: [PATCH 1/2] dccp: ccid: move timers to struct dccp_sock
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-2-kleber.souza@canonical.com>
In-Reply-To: <20201013171849.236025-2-kleber.souza@canonical.com>

--dfjn9C3XkBZ9ZjEm6mKvr0DLGL7w3liEv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/10/2020 19:18, Kleber Sacilotto de Souza wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>=20
> When dccps_hc_tx_ccid is freed, ccid timers may still trigger. The reas=
on
> del_timer_sync can't be used is because this relies on keeping a refere=
nce
> to struct sock. But as we keep a pointer to dccps_hc_tx_ccid and free t=
hat
> during disconnect, the timer should really belong to struct dccp_sock.
>=20
> This addresses CVE-2020-16119.
>=20
> Fixes: 839a6094140a (net: dccp: Convert timers to use timer_setup())
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>

Acked-bd: Richard Sailer <richard_siegfried@systemli.org>

Implementation and concept looks fine to me


--dfjn9C3XkBZ9ZjEm6mKvr0DLGL7w3liEv--

--KHVaNnR0CtdkaZCgAsBVhWbXcrEqCZBOz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEBgAhuYrOnl9UC7I39kE5zAWb4eEFAl+F+N8ACgkQ9kE5zAWb
4eH0WQf/UWTTCBzTGhg11Zme2bEngbGDoD/xYPUZ8TvPD7cXCoq0WGSVG9yqaTc1
vXwH1+jvNoJHQ7NvXOoUEe1fGmgNVdFNIw5RzEy/9Oi8rukTpvjloFCproonNeNs
mVAS95hbRHKho+NG+MmtR3yuH52SLtgtCdn64lJjAaNeX1oWGbUNwSK7TNY9Wrjj
ubteuQz3mFOFyca/V4xJZU58jz5Ikp420w/UdQGGtmUf133L3rZxDrT0ilKkZEiS
eeDfKRDQlkBbCvOlkuG6dER/nPUF0in8n1Ci6Jycwk2gsMIKSt3La178e3di6NHB
zdVms9QK+dASFjYym7NaXmjTjXS+cQ==
=WF3A
-----END PGP SIGNATURE-----

--KHVaNnR0CtdkaZCgAsBVhWbXcrEqCZBOz--
