Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D74282DBF
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgJDVYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:24:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43516 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgJDVYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:24:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C01CD1C0B76; Sun,  4 Oct 2020 23:24:12 +0200 (CEST)
Date:   Sun, 4 Oct 2020 23:24:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     ashiduka@fujitsu.com, sergei.shtylyov@gmail.com,
        davem@davemloft.net, yoshihiro.shimoda.uh@renesas.com,
        damm+renesas@opensource.se, tho.vu.wh@rvc.renesas.com,
        kazuya.mizuguchi.ks@renesas.com, horms+renesas@verge.net.au,
        fabrizio.castro@bp.renesas.com, netdev@vger.kernel.org
Cc:     Chris.Paterson2@renesas.com
Subject: ravb ethernet failures in 4.19.148 and -cip kernels
Message-ID: <20201004212412.GA12452@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

It seems

commit fb3a780e7a76cf8efb055f8322ec039923cee41f
Author: Yuusuke Ashizuka <ashiduka@fujitsu.com>
Date:   Thu Aug 20 18:43:07 2020 +0900

    ravb: Fixed to be able to unload modules

causes problems in at least -cip-rt kernels. (I'd have to verify it is
present in -cip and plain -stable). Symptoms are like this:

[    2.798301] [drm] Cannot find any crtc or sizes
[    2.805866] hctosys: unable to open rtc device (rtc0)
[    2.811937] libphy: ravb_mii: probed
[    2.821001] RTL8211E Gigabit Ethernet e6800000.ethernet-ffffffff:00: att=
ached PHY driver [RTL8211E Gigabit Ethernet] (mii_bus:phy_addr=3De6800000.e=
thernet-ffffffff:00, irq=3D190)
[    2.838052] RTL8211E Gigabit Ethernet e6800000.ethernet-ffffffff:00: Mas=
ter/Slave resolution failed, maybe conflicting manual settings?
[   12.841484] Waiting up to 110 more seconds for network.
[   22.853482] Waiting up to 100 more seconds for network.
[   32.865482] Waiting up to 90 more seconds for network.
[   42.877482] Waiting up to 80 more seconds for network.
[   52.889482] Waiting up to 70 more seconds for network.
[   62.901482] Waiting up to 60 more seconds for network.
[   72.913482] Waiting up to 50 more seconds for network.
[   82.925482] Waiting up to 40 more seconds for network.
[   92.937482] Waiting up to 30 more seconds for network.
[  102.949482] Waiting up to 20 more seconds for network.
[  112.961482] Waiting up to 10 more seconds for network.
[  122.861490] Sending DHCP requests ...... timed out!
[  209.890289] IP-Config: Retrying forever (NFS root)...
[  209.895535] libphy: ravb_mii: probed
[  209.899386] mdio_bus e6800000.ethernet-ffffffff: MDIO device at address =
0 is missing.
[  209.910604] ravb e6800000.ethernet eth0: failed to connect PHY
[  209.916705] IP-Config: Failed to open eth0
[  219.925483] Waiting up to 110 more seconds for network.
[  229.937481] Waiting up to 100 more seconds for network.
[  239.949481] Waiting up to 90 more seconds for network.
[  249.961481] Waiting up to 80 more seconds for network.

Full log is available at
https://lava.ciplatform.org/scheduler/job/56398 .

Reverting the above patch fixes the problems.

If you have any ideas what could be going on there, let me know.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3o9fAAKCRAw5/Bqldv6
8joZAJ4jZQDbzFRUEZdRL5mGuj7lbhVZwgCglv7GPY10Cu2MsOW26cbB9ZchBE0=
=Doaa
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
