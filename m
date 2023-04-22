Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F01E6EBAAC
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 19:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjDVR3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 13:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjDVR3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 13:29:33 -0400
Received: from bues.ch (bues.ch [IPv6:2a01:138:9005::1:4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E01BF7;
        Sat, 22 Apr 2023 10:29:30 -0700 (PDT)
Received: by bues.ch with esmtpsa (Exim 4.94.2)
        (envelope-from <m@bues.ch>)
        id 1pqH2e-0008h1-Tl; Sat, 22 Apr 2023 19:28:54 +0200
Date:   Sat, 22 Apr 2023 19:28:20 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        Natalia Petrova <n.petrova@fintech.ru>
Subject: Re: [PATCH v2] b43legacy: Add checking for null for
 ssb_get_devtypedata(dev)
Message-ID: <20230422192820.59e8e423@barney>
In-Reply-To: <95cff855-cb12-cf66-888f-b296a712d37d@lwfinger.net>
References: <20230418142918.70510-1-n.zhandarovich@fintech.ru>
 <95cff855-cb12-cf66-888f-b296a712d37d@lwfinger.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2UmYtPuo=8I_Omt_ytOLG9A";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2UmYtPuo=8I_Omt_ytOLG9A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Apr 2023 17:14:18 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > (err) goto out;
> >   		wl =3D ssb_get_devtypedata(dev);
> > -		B43legacy_WARN_ON(!wl);
> > +		if (!wl) {
> > +			B43legacy_WARN_ON(!wl);
> > +			err =3D -ENODEV;
> > +			goto out;
> > +		}
> >   	}
> >   	err =3D b43legacy_one_core_attach(dev, wl);
> >   	if (err) =20
>=20
> I do not recall seeing v1. One additional nitpick: The latest
> convention would have the subject as "wifi: b43legacy:...". Kalle may
> be able to fix this on merging, but it not, a v3 might be required.
> Otherwise, the patch is good.
>=20
> Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>

No, it's not good. It's wrong. I already replied to it.
wl can never be NULL here and the goto-out path is wrong (if there
was a chance for it to trigger).

Please drop this patch, Kalle.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/2UmYtPuo=8I_Omt_ytOLG9A
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmREGTUACgkQ9TK+HZCN
iw5QnxAAsP4FHvqBSFyCpRPrOwj512Kwf4RtO4TYNO/FC3zv09UAgjzILHDVJFDD
nPmFfNaPsGiVqDUHTIfuPzBYFMdvDsZyibynDU4Fv24YFNXx9YkrytMAZH+Rzh6t
4cID7MG82odxIJJP3ERs7vA0MX1HhD2cKR2BA2g6470gf1M1+EEqGt+xiu8Q09ja
rJNpcZB616jmOd3kCxRtSmEVuksPZfVYFFm3Nj77MIUiO/DlIcn2abkFPDMGYpOf
9GGCHTLc0DSTlZ2vTxmmnYQW/Jqhe6DAjjdY2v7OAN8Ma87VCKVWsCdjIKEhUSyf
vKY8uxLK9mG5wE8NSD7MqKNALqBewpEcHJy9FyVsxPdq92FpbqfkQh8sWRZFPDC0
kOT+Y9YqFaec9Ffe+jrISqN/lflkspnvCv4DJn2616NoaFa97zVMv43Oz+o5DYps
H5TcuwMr/xGlXxHOTRYlxZUFPNMlarkkv6ZoXrhBJncjgZROTRvwjbzgsEeRSO1+
OPUzTIIobbScYn3XNmNz85Ag8uBx/LrXqSW7F+N4dKyEhXs/EGXKjx/PnZIxSDNF
s05UhkHRz6N624hRVSEIOS7R4HuZQxIg83usyAkhTT/o58UsHd9sjrK1Tv63m+wE
XqbKdiC5cKgaN4Mhoeil2Cz6AZsSizVV4PYsAN7zGuk/iGOhC1Q=
=vx0A
-----END PGP SIGNATURE-----

--Sig_/2UmYtPuo=8I_Omt_ytOLG9A--
