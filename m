Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE0053D698
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 13:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbiFDLqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 07:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiFDLqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 07:46:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC65D5F72
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 04:46:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxSEH-0002VK-4o; Sat, 04 Jun 2022 13:46:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 0B6118C2FA;
        Sat,  4 Jun 2022 11:46:03 +0000 (UTC)
Date:   Sat, 4 Jun 2022 13:46:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="2jjncl7znrrtvgd2"
Content-Disposition: inline
In-Reply-To: <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
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


--2jjncl7znrrtvgd2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Vincent,

wow! This is a great series which addresses a lot of long outstanding
issues. Great work!

As this cover letter brings so much additional information I'll ask
Jakub and David if they take pull request from me, which itself have
merges. This cover letter would be part of my merge. If I get the OK,
can you provide this series as a tag (ideally GPG signed) that I can
pull?

regards,
Marc

On 03.06.2022 19:28:41, Vincent Mailhol wrote:
> Aside of calc_bittiming.o which can be configured with
> CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
> unconditionally to can-dev.o even if not needed by the user.
>=20
> This series first goal it to split the can-dev modules so that the
> user can decide which features get built in during
> compilation. Additionally, the CAN Device Drivers menu is moved from
> the "Networking support" category to the "Device Drivers" category
> (where all drivers are supposed to be).
>=20
> Below diagrams illustrate the changes made.
> The arrow symbol "x --> y" denotes that "y depends on x".
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
> 	  |
>           +-> CAN bit-timing calculation  (optional for hardware drivers)
>           |   symbol: CONFIG_CAN_BITTIMING
> 	  |
> 	  +-> All other CAN devices
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
>           |   symbol: CONFIG_CAN_BITTIMING
> 	  |
> 	  +-> All other CAN devices not relying on RX offload
>           |
>           +-> CAN rx offload
>               symbol: CONFIG_CAN_RX_OFFLOAD
>               |
>               +-> CAN devices relying on rx offload
>                   (at time of writing: flexcan, ti_hecc and mcp251xfd)
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
>=20
> ** N.B. **
>=20
> This design results from the lengthy discussion in [1].
>=20
> I did one change from Oliver's suggestions in [2]. The initial idea
> was that the first two config symbols should be respectively
> CAN_DEV_SW and CAN_DEV instead of CAN_DEV and CAN_NETLINK as proposed
> in this series.
>=20
>   * First symbol is changed from CAN_DEV_SW to CAN_DEV. The rationale
>     is that it is this entry that will trigger the build of can-dev.o
>     and it makes more sense for me to name the symbol share the same
>     name as the module. Furthermore, this allows to create a menuentry
>     with an explicit name that will cover both the virtual and
>     physical devices (naming the menuentry "CAN Device Software" would
>     be inconsistent with the fact that physical devices would also be
>     present in a sub menu). And not using menuentry complexifies the
>     menu.
>=20
>   * Second symbol is renamed from CAN_DEV to CAN_NETLINK because
>     CAN_DEV is now taken by the previous menuconfig and netlink is the
>     predominant feature added at this level. I am opened to other
>     naming suggestion (CAN_DEV_NETLINK, CAN_DEV_HW...?).
>=20
> [1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vi=
ncent@wanadoo.fr/
> [2] https://lore.kernel.org/linux-can/22590a57-c7c6-39c6-06d5-11c6e4e1534=
b@hartkopp.net/
>=20
>=20
> ** Changelog **
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
>=20
> Vincent Mailhol (7):
>   can: Kbuild: rename config symbol CAN_DEV into CAN_NETLINK
>   can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using
>     CAN_DEV
>   can: bittiming: move bittiming calculation functions to
>     calc_bittiming.c
>   can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
>   net: Kconfig: move the CAN device menu to the "Device Drivers" section
>   can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid()
>     to skb.c
>   can: skb: drop tx skb if in listen only mode
>=20
>  drivers/net/Kconfig                   |   2 +
>  drivers/net/can/Kconfig               |  66 +++++++--
>  drivers/net/can/dev/Makefile          |  20 ++-
>  drivers/net/can/dev/bittiming.c       | 197 -------------------------
>  drivers/net/can/dev/calc_bittiming.c  | 202 ++++++++++++++++++++++++++
>  drivers/net/can/dev/dev.c             |   9 +-
>  drivers/net/can/dev/skb.c             |  72 +++++++++
>  drivers/net/can/spi/mcp251xfd/Kconfig |   1 +
>  include/linux/can/skb.h               |  59 +-------
>  net/can/Kconfig                       |   5 +-
>  10 files changed, 351 insertions(+), 282 deletions(-)
>  create mode 100644 drivers/net/can/dev/calc_bittiming.c
>=20
> --=20
> 2.35.1
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--2jjncl7znrrtvgd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbRfgACgkQrX5LkNig
010WtwgAjisk0+9iW56D4Ex0iNn+MT1ICrkf2OQhKxQezPO6klY6a6Fl7EbF8MJe
SIUbgJyzz8A9LXepHUf9cbgkXXg4OiJZQu0sHbU4bLqX3+rShN4AAzVVmRAgBewx
n3ZOog1jTl1dX05OeGqADZapQ4euTNckC4C38XFNIZkH3LWu3/wlK3s89eq8p0gs
PwqGyA2UIoGKJKr0DPJH6BQUqNgeYh1LfAfuO4it0VYswbo0h4tmc8eAcG56gXd3
AHz7YZK2Y0naPjS/SWxEWRgsGUZjQVcwruXxIJRwEyh3yOojHhkBfNtz9R4IFMjU
VaV7mM2cteZPzL7JFe7k3kZmR8dUdA==
=vadE
-----END PGP SIGNATURE-----

--2jjncl7znrrtvgd2--
