Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162844308AE
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245672AbhJQMcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245666AbhJQMcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:32:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A33C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 05:29:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc5IO-0004A5-NX; Sun, 17 Oct 2021 14:29:44 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-7b24-848c-3829-1203.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7b24:848c:3829:1203])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BD40E695CCE;
        Sun, 17 Oct 2021 12:29:43 +0000 (UTC)
Date:   Sun, 17 Oct 2021 14:29:43 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: peak_pci: Fix UAF in peak_pci_remove
Message-ID: <20211017122943.q4ic472sigcrk4l2@pengutronix.de>
References: <1634192913-15639-1-git-send-email-zheyuma97@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5pdcbj2in2nebprh"
Content-Disposition: inline
In-Reply-To: <1634192913-15639-1-git-send-email-zheyuma97@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5pdcbj2in2nebprh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2021 06:28:33, Zheyu Ma wrote:
> When remove the module peek_pci, referencing 'chan' again after
> releasing 'dev' will cause UAF.
>=20
> Fix this by releasing 'dev' later.
>=20
> The following log reveals it:
>=20
> [   35.961814 ] BUG: KASAN: use-after-free in peak_pci_remove+0x16f/0x270=
 [peak_pci]
> [   35.963414 ] Read of size 8 at addr ffff888136998ee8 by task modprobe/=
5537
> [   35.965513 ] Call Trace:
> [   35.965718 ]  dump_stack_lvl+0xa8/0xd1
> [   35.966028 ]  print_address_description+0x87/0x3b0
> [   35.966420 ]  kasan_report+0x172/0x1c0
> [   35.966725 ]  ? peak_pci_remove+0x16f/0x270 [peak_pci]
> [   35.967137 ]  ? trace_irq_enable_rcuidle+0x10/0x170
> [   35.967529 ]  ? peak_pci_remove+0x16f/0x270 [peak_pci]
> [   35.967945 ]  __asan_report_load8_noabort+0x14/0x20
> [   35.968346 ]  peak_pci_remove+0x16f/0x270 [peak_pci]
> [   35.968752 ]  pci_device_remove+0xa9/0x250
>=20
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Applied to linux-can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--5pdcbj2in2nebprh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFsFzQACgkQqclaivrt
76l+jAf/YD2qprHjvgyGwkm0pxyq8/7j2vxoknztrO65wqUoT51GTKnaarLL8Duh
b3Wslyvw0F2qQH3ATWdPDr6Nn8OaA4cNxN/sb+BSKyiAWdn2DkY7Fk3s0weskLuh
jUQFs5ejfkUolKSYQQ/jXHNtZoWfgv9AliBMzZovOAMWvlVQDn+7wLQTcmg/OFLJ
wZJyd/pBIuRQdz6WfYzf6ovt9h4fJtryBF5zlVifyNHT4RBreklCCAsc5fUmFKDX
IsvNvLPCh1CBH3GLpQkFFAVfKDFakU2oSk4I1qPuG/Cg69aDv4hKAZ4pXzfCtIfk
8TuQEPj01nxpKiO0ejfeplmJp174dA==
=6OLJ
-----END PGP SIGNATURE-----

--5pdcbj2in2nebprh--
