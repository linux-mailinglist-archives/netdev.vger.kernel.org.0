Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBD355B19F
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 14:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiFZL7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 07:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiFZL7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 07:59:09 -0400
X-Greylist: delayed 2379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Jun 2022 04:59:06 PDT
Received: from bues.ch (bues.ch [IPv6:2a01:138:9005::1:4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87BC11460;
        Sun, 26 Jun 2022 04:59:06 -0700 (PDT)
Received: by bues.ch with esmtpsa (Exim 4.92)
        (envelope-from <m@bues.ch>)
        id 1o5QIF-0002eX-RG; Sun, 26 Jun 2022 13:19:07 +0200
Date:   Sun, 26 Jun 2022 13:18:37 +0200
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     Praghadeesh T K S <praghadeeshthevendria@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        praghadeeshtks@zohomail.in, skhan@linuxfoundation.org
Subject: Re: [PATCH] net: wireless/broadcom: fix possible condition with no
 effect
Message-ID: <20220626131837.622a36c5@barney>
In-Reply-To: <458bd8dd-29c2-8029-20f5-f746db57740a@newmedia-net.de>
References: <20220625192902.30050-1-praghadeeshthevendria@gmail.com>
 <458bd8dd-29c2-8029-20f5-f746db57740a@newmedia-net.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gLIzHQzsO8pBgS_8XdvwdPb";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gLIzHQzsO8pBgS_8XdvwdPb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Jun 2022 13:03:57 +0200
Sebastian Gottschall <s.gottschall@newmedia-net.de> wrote:

> Am 25.06.2022 um 21:29 schrieb Praghadeesh T K S:
> > Fix a coccinelle warning by removing condition with no possible
> > effect
> >
> > Signed-off-by: Praghadeesh T K S <praghadeeshthevendria@gmail.com>
> > ---
> >   drivers/net/wireless/broadcom/b43/xmit.c | 7 +------
> >   1 file changed, 1 insertion(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/broadcom/b43/xmit.c
> > b/drivers/net/wireless/broadcom/b43/xmit.c index 7651b1b..667a74b
> > 100644 --- a/drivers/net/wireless/broadcom/b43/xmit.c
> > +++ b/drivers/net/wireless/broadcom/b43/xmit.c
> > @@ -169,12 +169,7 @@ static u16 b43_generate_tx_phy_ctl1(struct
> > b43_wldev *dev, u8 bitrate) const struct b43_phy *phy =3D &dev->phy;
> >   	const struct b43_tx_legacy_rate_phy_ctl_entry *e;
> >   	u16 control =3D 0;
> > -	u16 bw;
> > -
> > -	if (phy->type =3D=3D B43_PHYTYPE_LP)
> > -		bw =3D B43_TXH_PHY1_BW_20;
> > -	else /* FIXME */
> > -		bw =3D B43_TXH_PHY1_BW_20;
> > +	u16 bw =3D B43_TXH_PHY1_BW_20; =20
> Can you check if this is a possible register typo?


I think use of this name was intentional.
The code is marked as being incomplete with /* FIXME */

This change removes the FIXME. Which is bad. It doesn't improve the
code. It reduces code quality by removing the
incompleteness documentation.

Please leave the code as-is.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/gLIzHQzsO8pBgS_8XdvwdPb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmK4QI0ACgkQ9TK+HZCN
iw6qfg//Xz4FgwF/d8Elx8vDBrIjZS+3IeOuZoLP3Ljiz/YHjDRKdcZHG8fcm4c5
zsxT27VyXc466fOKCM+dV7ArdXGdkAPBT+8G3Z0v7EBoBxbj91prW+dc2Oa8mdxH
o6YDR0cqjXT+/3tMO9hasuMoembusnmhMoiWkIm6Lc/s8MzvKPLRVxRqknhNMR1o
wiamTMmM8cUyBcalQWg1rJ0E8WWy7gq0RHb51vaqVpMe+KmfCQLKIm5q4YbOEXb2
ol5dC/RFPeCNgF2zQEJGrqnNPbAVgncsaA21W4D1lLlXNmz0FO+LwVuK5tIK7/5z
oDIBBIcbQsHR15j5fkmpe5ykhJfIs4q7XwauYTvaVwTC/eX+/0jPT3MuKplEEK/m
D6FGvVkvmnzSns/m1DOZB/gpuPZvf0qLi1X+AH4gtxp4PbLRTIgPkS0I7YNpdEju
xjc0IVK6a5LKwrseAZKCkT9EC9zPPkg1gN0VMNlP4H92UT2/CCOeIuDgdJitVkE5
waItsFQpIIvAcnkcYe5BEW4toqkFtD1snbKPHinDDpD6OmwvpQvdILwCmkOFBuQU
0W+F2d0BTcbVvJl8m/Qj9jv43FF5PUu5WsbGN7VKdOnFXFcnsyn+t5166P3tuy1n
wH6UR+MWJ+eo533M8jq9pZdv59A7S+rJlQ115di4Pa4YffWQ8z4=
=dwmE
-----END PGP SIGNATURE-----

--Sig_/gLIzHQzsO8pBgS_8XdvwdPb--
