Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB17A28D426
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgJMS74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 14:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727733AbgJMS74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 14:59:56 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Oct 2020 11:59:55 PDT
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2001:678:a40:7000:2::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E28C0613D0;
        Tue, 13 Oct 2020 11:59:55 -0700 (PDT)
Subject: Re: [PATCH 2/2] Revert "dccp: don't free ccid2_hc_tx_sock struct in
 dccp_disconnect()"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1602615592;
        bh=Aa9pyHjOcVbUByGQfquuzPxzq9f9clmIPBURVdjhxXc=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=6IHpWSmB8zoYG6asQFqI8pGauKxsUSqDu54yoOvi2XetGybBYXP9qOyhSM/eX99qw
         KDfiHCuIco4JN2p2GOlyy0L0gEbI2QbgjHAHPiW/RbrZqCIie8WLvl8lG/ttNki/4W
         a1xlVs+sGxTprEXOkSFVo3M9RWePNPZ+qZPdyBE3zFs5uBvbhUSlf+jphwhS5GbXYv
         GY7xBc54ZHolUrMUonOhiDCWTVHZ9K6WavbdCrvbdX50aEPWmpqfO13nHeF4QcUiok
         IBlnGdXj6TvoiSZRB76SOqEhM8I7V/tutv4vQ9DOSPbiJoznk30mcSK89D3lHAgqc8
         MRHB9+9kLA0Eg==
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
 <20201013171849.236025-3-kleber.souza@canonical.com>
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
Message-ID: <bb2755d3-cb80-5761-f01f-4c6da9bd31c2@systemli.org>
Date:   Tue, 13 Oct 2020 20:59:50 +0200
MIME-Version: 1.0
In-Reply-To: <20201013171849.236025-3-kleber.souza@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="J1wNxwe2U3hUL6xUfMbG23kWMkDthUjal"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J1wNxwe2U3hUL6xUfMbG23kWMkDthUjal
Content-Type: multipart/mixed; boundary="WxePmLM0IhiWSQnQjcpdYpcvAqMuNppWd";
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
Message-ID: <bb2755d3-cb80-5761-f01f-4c6da9bd31c2@systemli.org>
Subject: Re: [PATCH 2/2] Revert "dccp: don't free ccid2_hc_tx_sock struct in
 dccp_disconnect()"
References: <20201013171849.236025-1-kleber.souza@canonical.com>
 <20201013171849.236025-3-kleber.souza@canonical.com>
In-Reply-To: <20201013171849.236025-3-kleber.souza@canonical.com>

--WxePmLM0IhiWSQnQjcpdYpcvAqMuNppWd
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13/10/2020 19:18, Kleber Sacilotto de Souza wrote:
> rom: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>=20
> This reverts commit 2677d20677314101293e6da0094ede7b5526d2b1.
>=20
> This fixes an issue that after disconnect, dccps_hc_tx_ccid will still =
be
> kept, allowing the socket to be reused as a listener socket, and the cl=
oned
> socket will free its dccps_hc_tx_ccid, leading to a later use after fre=
e,
> when the listener socket is closed.
>=20
> This addresses CVE-2020-16119.
>=20
> Fixes: 2677d2067731 (dccp: don't free ccid2_hc_tx_sock struct in dccp_d=
isconnect())
> Reported-by: Hadar Manor
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
> ---
Acked-by: Richard Sailer <richard_siegfried@systemli.org>


--WxePmLM0IhiWSQnQjcpdYpcvAqMuNppWd--

--J1wNxwe2U3hUL6xUfMbG23kWMkDthUjal
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEBgAhuYrOnl9UC7I39kE5zAWb4eEFAl+F+ScACgkQ9kE5zAWb
4eH6sQf/Tqw4Q9r0PAI1c+stYzlcCikkYpFE33vnoG+SbiIQCBhB83rs/BxTNmxO
mKRJpzTswAQsqrnGRCrFGcazAUJKWqhAxC6N+g0nZCDZuSVfSAAh5e6ayHP4HLJw
SW0daEUNYkdGvYkl5Dhom35pjziR+m1RTWE2EXesA4vMpOG+WBsNyzZ1tmDDb/Ad
nYQNfRZOZjXpFWwGg4yVl9q0kddB5RYxkYXHH1gRsMK8uvJRjGXmaj/XdNlcdyLQ
BfwUINi94v9arFQZwnjtiKDTkpN5YaD4GLPT+ffQLcBc6P6ixa6CcCCG0khkjLu5
dfBZ8s+blxKb/APl8JUsI6Ud9YMLVw==
=+HsJ
-----END PGP SIGNATURE-----

--J1wNxwe2U3hUL6xUfMbG23kWMkDthUjal--
