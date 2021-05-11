Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8507237A42B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 12:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhEKKCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 06:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhEKKCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 06:02:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5C0C06175F
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 03:01:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lgPCf-00089z-WA; Tue, 11 May 2021 12:01:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:9fa4:6162:2385:92e7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E9A01622099;
        Tue, 11 May 2021 10:01:24 +0000 (UTC)
Date:   Tue, 11 May 2021 12:01:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Torin Cooper-Bennun <torin@maxiluxsystems.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: CAN: TX frames marked as RX after the sending socket is closed
Message-ID: <20210511100124.cs2xifsrv3uejvft@pengutronix.de>
References: <20210510142302.ijbwowv4usoiqkxq@bigthink>
 <20210510181807.sel6igxglzwqoi44@pengutronix.de>
 <20210511092828.okg6p7n6efoi2yf2@bigthink>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qrkicttczmdgury4"
Content-Disposition: inline
In-Reply-To: <20210511092828.okg6p7n6efoi2yf2@bigthink>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qrkicttczmdgury4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.05.2021 10:28:28, Torin Cooper-Bennun wrote:
> On Mon, May 10, 2021 at 08:18:07PM +0200, Marc Kleine-Budde wrote:
> > I have a git feeling that I've found the problem. Can you revert
> > e940e0895a82 ("can: skb: can_skb_set_owner(): fix ref counting if socket
> > was closed before setting skb ownership") and check if that fixes your
> > problem? This might trigger the problem described in the patch:
> >=20
> > | WARNING: CPU: 0 PID: 280 at lib/refcount.c:25 refcount_warn_saturate+=
0x114/0x134
> > | refcount_t: addition on 0; use-after-free.
> > | Modules linked in: coda_vpu(E) v4l2_jpeg(E) videobuf2_vmalloc(E) imx_=
vdoa(E)
> > | CPU: 0 PID: 280 Comm: test_can.sh Tainted: G            E     5.11.0-=
04577-gf8ff6603c617 #203
> > | Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> > | Backtrace:
> > | [<80bafea4>] (dump_backtrace) from [<80bb0280>] (show_stack+0x20/0x24=
) r7:00000000 r6:600f0113 r5:00000000 r4:81441220
> > | [<80bb0260>] (show_stack) from [<80bb593c>] (dump_stack+0xa0/0xc8)
> > | [<80bb589c>] (dump_stack) from [<8012b268>] (__warn+0xd4/0x114) r9:00=
000019 r8:80f4a8c2 r7:83e4150c r6:00000000 r5:00000009 r4:80528f90
> > | [<8012b194>] (__warn) from [<80bb09c4>] (warn_slowpath_fmt+0x88/0xc8)=
 r9:83f26400 r8:80f4a8d1 r7:00000009 r6:80528f90 r5:00000019 r4:80f4a8c2
> > | [<80bb0940>] (warn_slowpath_fmt) from [<80528f90>] (refcount_warn_sat=
urate+0x114/0x134) r8:00000000 r7:00000000 r6:82b44000 r5:834e5600 r4:83f4d=
540
> > | [<80528e7c>] (refcount_warn_saturate) from [<8079a4c8>] (__refcount_a=
dd.constprop.0+0x4c/0x50)
> > | [<8079a47c>] (__refcount_add.constprop.0) from [<8079a57c>] (can_put_=
echo_skb+0xb0/0x13c)
> > | [<8079a4cc>] (can_put_echo_skb) from [<8079ba98>] (flexcan_start_xmit=
+0x1c4/0x230) r9:00000010 r8:83f48610 r7:0fdc0000 r6:0c080000 r5:82b44000 r=
4:834e5600
> > | [<8079b8d4>] (flexcan_start_xmit) from [<80969078>] (netdev_start_xmi=
t+0x44/0x70) r9:814c0ba0 r8:80c8790c r7:00000000 r6:834e5600 r5:82b44000 r4=
:82ab1f00
> > | [<80969034>] (netdev_start_xmit) from [<809725a4>] (dev_hard_start_xm=
it+0x19c/0x318) r9:814c0ba0 r8:00000000 r7:82ab1f00 r6:82b44000 r5:00000000=
 r4:834e5600
> > | [<80972408>] (dev_hard_start_xmit) from [<809c6584>] (sch_direct_xmit=
+0xcc/0x264) r10:834e5600 r9:00000000 r8:00000000 r7:82b44000 r6:82ab1f00 r=
5:834e5600 r4:83f27400
> > | [<809c64b8>] (sch_direct_xmit) from [<809c6c0c>] (__qdisc_run+0x4f0/0=
x534)
> >=20
> > Can you give me feedback if
> > 1. the revert "fixes" your problem
> > 2. the revert triggers the above backtrace
>=20
> Always trust your git, it seems... I can confirm this revert both
> 'fixes' the problem and triggers that backtrace originating from
> m_can_tx_handler.

\o/

> I got two of those backtraces during the run, and
> sandwiched between them a backtrace from the rx path:
>=20
> | WARNING: CPU: 2 PID: 22 at lib/refcount.c:28 refcount_warn_saturate+0x1=
3c/0x174
> | refcount_t: underflow; use-after-free.

Now please test if
https://lore.kernel.org/linux-can/20210510182038.1528631-1-mkl@pengutronix.=
de/
fixes your problem.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qrkicttczmdgury4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCaVfEACgkQqclaivrt
76lp4Af9E7ytXMsGOwn7y2Kp01Zn3cHly+1LVL9a0YfzXX++L5hXHI+qNvT/sKib
3fvlNi1tnmMgikAHap8yEiWA/5Rp819YlFKYJ1bdvMyVxEQdQiDbARf6g6qIuv8I
sYrowPolPG27omfdYNVLXY487HRyL/raK8Eq6Ue6etkYsARmlkVAGRQsrtMlBwRf
o6W48Up+kW3LGFZxVGo5MOeIJ+c/3F60eS8M339IREd18/lwkuIw7X51hp1ortR6
tVKDaiPwRIMG5MNoSmQ3SH1E+Kn4/pfHxDJAdtOBynfz2Z5HY84aEGoELr2KgEQ1
kGwpY2GxDYZkCvIpnx4NaLTDyPf09Q==
=GPes
-----END PGP SIGNATURE-----

--qrkicttczmdgury4--
