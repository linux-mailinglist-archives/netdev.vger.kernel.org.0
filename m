Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BC95E5DB4
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiIVIm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiIVImx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:42:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CD2CDCD3
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:42:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obHn8-00069v-Lf; Thu, 22 Sep 2022 10:42:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DE95DE9FCD;
        Thu, 22 Sep 2022 08:23:38 +0000 (UTC)
Date:   Thu, 22 Sep 2022 10:23:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        MPTCP Upstream <mptcp@lists.linux.dev>
Subject: Re: [PATCH net 2/3] can: gs_usb: gs_can_open(): fix race
 dev->can.state condition
Message-ID: <20220922082338.a6mbf2bbtznr3lvz@pengutronix.de>
References: <20220921083609.419768-1-mkl@pengutronix.de>
 <20220921083609.419768-3-mkl@pengutronix.de>
 <84f45a7d-92b6-4dc5-d7a1-072152fab6ff@tessares.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vaq73b4wttzzl5et"
Content-Disposition: inline
In-Reply-To: <84f45a7d-92b6-4dc5-d7a1-072152fab6ff@tessares.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vaq73b4wttzzl5et
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.09.2022 10:04:55, Matthieu Baerts wrote:
> On 21/09/2022 10:36, Marc Kleine-Budde wrote:
> > The dev->can.state is set to CAN_STATE_ERROR_ACTIVE, after the device
> > has been started. On busy networks the CAN controller might receive
> > CAN frame between and go into an error state before the dev->can.state
> > is assigned.
> >=20
> > Assign dev->can.state before starting the controller to close the race
> > window.
> >=20
> > Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN dev=
ices")
> > Link: https://lore.kernel.org/all/20220920195216.232481-1-mkl@pengutron=
ix.de
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> FYI, we got a small conflict when merging -net in net-next in the MPTCP
> tree due to this patch applied in -net:
>=20
>   5440428b3da6 ("can: gs_usb: gs_can_open(): fix race dev->can.state
> condition")
>=20
> and this one from net-next:
>=20
>   45dfa45f52e6 ("can: gs_usb: add RX and TX hardware timestamp support")
>=20
> The conflict has been resolved on our side[1] and the resolution we
> suggest is attached to this email.

That patch looks good to me.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vaq73b4wttzzl5et
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMsG4YACgkQrX5LkNig
013BAAf/e8dSMLbcldH9hd0PZggpl/ZVOZp4/l82rYQCWa4VWXHfLg+XUMmvvyxp
rwvvw4ku3d2RBX5V6OKP+Xtqhe7gaXdRm2miKGS8404n3Cr3AmxYSXs41e/pDkj5
xM0oUB+oAR2lP9ZDkICvA3ZbM4roVhEFimrPDoVrTP41t1L7YCyBqNrNZsqv4p9e
leKI3+TZQuJdVTnlZGhkLto7sXY2v1GgrlK97EqiekICB0MBwWIHBr/LIAnVLkfD
Yy4rDCD2Byhbmao9mhnCa/vg+yG5MFTDo58dvM5C6x5ABwvhpWTKtyyRQ0N+CI5F
sHpP4/DHzamLg0sUdNDklbMwDXoEDA==
=vFx/
-----END PGP SIGNATURE-----

--vaq73b4wttzzl5et--
