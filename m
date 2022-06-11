Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B28E54760B
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiFKPSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 11:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238472AbiFKPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 11:18:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CB04ECFC
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 08:18:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o02s9-00086f-QT; Sat, 11 Jun 2022 17:17:57 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1593092EAD;
        Sat, 11 Jun 2022 15:17:55 +0000 (UTC)
Date:   Sat, 11 Jun 2022 17:17:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v6 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220611151754.2agcczimjcgr25xl@pengutronix.de>
References: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kg5j2blhufuqdrtx"
Content-Disposition: inline
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kg5j2blhufuqdrtx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.06.2022 23:30:02, Vincent Mailhol wrote:
> Aside of calc_bittiming.o which can be configured with
> CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
> unconditionally to can-dev.o even if not needed by the user.
>=20
> This series first goal it to split the can-dev modules so that the
> only the needed features get built in during compilation.
> Additionally, the CAN Device Drivers menu is moved from the
> "Networking support" category to the "Device Drivers" category (where
> all drivers are supposed to be).
>=20
>=20
> * menu before this series *
>=20
> CAN bus subsystem support
>   symbol: CONFIG_CAN
>   |
>   +-> CAN Device Drivers
>       (no symbol)
>       |
>       +-> software/virtual CAN device drivers
>       |   (at time of writing: slcan, vcan, vxcan)
>       |
>       +-> Platform CAN drivers with Netlink support
>           symbol: CONFIG_CAN_DEV
>           |
>           +-> CAN bit-timing calculation  (optional for hardware drivers)
>           |   symbol: CONFIG_CAN_CALC_BITTIMING
>           |
>           +-> All other CAN devices drivers
>=20
> * menu after this series *
>=20
> Network device support
>   symbol: CONFIG_NETDEVICES
>   |
>   +-> CAN Device Drivers
>       symbol: CONFIG_CAN_DEV
>       |
>       +-> software/virtual CAN device drivers
>       |   (at time of writing: slcan, vcan, vxcan)
>       |
>       +-> CAN device drivers with Netlink support
>           symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
>           |
>           +-> CAN bit-timing calculation (optional for all drivers)
>           |   symbol: CONFIG_CAN_CALC_BITTIMING
>           |
>           +-> All other CAN devices drivers
>               (some may select CONFIG_CAN_RX_OFFLOAD)
>               |
>               +-> CAN rx offload (automatically selected by some drivers)
>                   (hidden symbol: CONFIG_CAN_RX_OFFLOAD)
>=20
> Patches 1 to 5 of this series do above modification.
>=20
> The last two patches add a check toward CAN_CTRLMODE_LISTENONLY in
> can_dropped_invalid_skb() to discard tx skb (such skb can potentially
> reach the driver if injected via the packet socket). In more details,
> patch 6 moves can_dropped_invalid_skb() from skb.h to skb.o and patch
> 7 is the actual change.
>=20
> Those last two patches are actually connected to the first five ones:
> because slcan and v(x)can requires can_dropped_invalid_skb(), it was
> necessary to add those three devices to the scope of can-dev before
> moving the function to skb.o.
>=20
> This design results from the lengthy discussion in [1].
>=20
> [1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vi=
ncent@wanadoo.fr/
>=20
>=20
> ** Changelog **
>=20
> v5 -> v6:
>=20
>   * fix typo in patch #1's title: Kbuild -> Kconfig.
>=20
>   * make CONFIG_RX_CAN an hidden config symbol and modify the diagram
>     in the cover letter accordingly.
>=20
>     @Oliver, with CONFIG_CAN_RX_OFFLOAD now being an hidden config,
>     that option fully depends on the drivers. So contrary to your
>     suggestion, I put CONFIG_CAN_RX_OFFLOAD below the device drivers
>     in the diagram.
>=20
>   * fix typo in cover letter: CONFIG_CAN_BITTIMING -> CONFIG_CAN_CALC_BIT=
TIMING.
>=20
> v4 -> v5:
>=20
>   * m_can is also requires RX offload. Add the "select CAN_RX_OFFLOAD"
>     to its Makefile.
>=20
>   * Reorder the lines of drivers/net/can/dev/Makefile.
>=20
>   * Remove duplicated rx-offload.o target in drivers/net/can/dev/Makefile
>=20
>   * Remove the Nota Bene in the cover letter.
>=20
>=20
> v3 -> v4:
>=20
>   * Five additional patches added to split can-dev module and refactor
>     Kbuild. c.f. below (lengthy) thread:
>     https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vi=
ncent@wanadoo.fr/
>=20
>=20
> v2 -> v3:
>=20
>   * Apply can_dropped_invalid_skb() to slcan.
>=20
>   * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
>     modifying Kbuild.
>=20
>   * fix small typos.
>=20
> v1 -> v2:
>=20
>   * move can_dropped_invalid_skb() to skb.c instead of dev.h
>=20
>   * also move can_skb_headroom_valid() to skb.c

Applied to can-next/master....as a merge with the above message!
Congrats on this series and the first ever merge to the linux-can
branch!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kg5j2blhufuqdrtx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKksh8ACgkQrX5LkNig
011r/Qf/WO5jEO9TYcsuTPqF7I3rFy71Sm5lwROlTfTJZ4cbRYwGfZUgVD3eKHXj
Xd89LAKzaKlcf85PugUxstqG80Tpnw7OcZYLZTDqzcxWKhkppmqX+aFUGazg2Wfa
P5oXNltWWSpIXCSdry/hEC1COpjYOJvKmTS8TR9JDaOVE6s5BK/5UlAMePQ/hlYV
GTgst4wTxf9UPSyH+NTOXZ+Kb9aQPMurJDP72bhFCDD6ND784zJOOHYMshJ0nexs
nmSPhxYLqBCqEbsoxX90fGkSV6f8AxOLxSU3KPKb2/DDeMo0/aV8D2jonaXShR+X
wB+0t4DI9BV4Ut5lpo9QuQQ4/6KslQ==
=lzWg
-----END PGP SIGNATURE-----

--kg5j2blhufuqdrtx--
