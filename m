Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E777430BF6
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 22:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242869AbhJQUSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 16:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242845AbhJQUSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 16:18:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E603C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 13:16:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcCa9-00054c-NX; Sun, 17 Oct 2021 22:16:33 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c215-888e-54eb-c2bc.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c215:888e:54eb:c2bc])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AC8B6695E7F;
        Sun, 17 Oct 2021 20:16:30 +0000 (UTC)
Date:   Sun, 17 Oct 2021 22:16:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver: net: can: delete napi if register_candev fails
Message-ID: <20211017201629.xb3d6ux5r2r6bfgj@pengutronix.de>
References: <20211013040349.2858773-1-mudongliangabcd@gmail.com>
 <CAD-N9QWTP8DLtAN70Xxap+WhNUfh9ixfeDMuNaB2NnpFhuAN8A@mail.gmail.com>
 <20211017123622.nfyis7o235tb2qad@pengutronix.de>
 <CAD-N9QXwHgTdPdp+RN4sDfzxx0oa9T0TNbSt1x9D3vddbY4CQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="he3rfgt7idbalay4"
Content-Disposition: inline
In-Reply-To: <CAD-N9QXwHgTdPdp+RN4sDfzxx0oa9T0TNbSt1x9D3vddbY4CQw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--he3rfgt7idbalay4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.10.2021 20:52:14, Dongliang Mu wrote:
> On Sun, Oct 17, 2021 at 8:36 PM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> >
> > On 13.10.2021 13:21:09, Dongliang Mu wrote:
> > > On Wed, Oct 13, 2021 at 12:04 PM Dongliang Mu <mudongliangabcd@gmail.=
com> wrote:
> > > >
> > > > If register_candev fails, xcan_probe does not clean the napi
> > > > created by netif_napi_add.
> > > >
> > >
> > > It seems the netif_napi_del operation is done in the free_candev
> > > (free_netdev precisely).
> > >
> > > list_for_each_entry_safe(p, n, &dev->napi_list, dev_list)
> > >           netif_napi_del(p);
> > >
> > > And list_add_rcu(&napi->dev_list, &dev->napi_list) is done in the
> > > netif_napi_add.
> > >
> > > Therefore, I suggest removing "netif_napi_del" operation in the
> > > xcan_remove to match probe and remove function.
> >
> > Sounds reasonable, can you create a patch for this.
>=20
> I have submitted one patch - https://lkml.org/lkml/2021/10/17/181

Thanks for the patch.

Regards,
Marc

BTW: Do you know the new kernel.org mailing list archive available at
https://lore.kernel.org ?
You can reference a mail using its Message-ID, in you case it's:
https://lore.kernel.org/all/20211017125022.3100329-1-mudongliangabcd@gmail.=
com

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--he3rfgt7idbalay4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFshJoACgkQqclaivrt
76nbhQgArihaNMxrE4COYbunSEx53aLydhCzP9WkKlwYCcjH8u4YdaJsUxVS2OFf
YTCTJJ0Oq5+aeyuNXwn/pVk3XDcTbdtLlFKAZPcfWtaGoApoKXB9qpaeHrxt/PZn
6LveUjg9E0y3CJ2wftQaO33lu+/xxZ+Wv7bG7DM+9QxHVn2pUmdUVNmaszlAV9fR
wtPkt7XqxK/v8A0MVUX/WlGFh6fwXsmVW4f6mwI98cqTZmNoaksT1rxP5FeIDbXz
8n10wjDwHl1uMUtzd5CTqJumnTAinz8P5WDIFphiERAUpLOPBHHCPTIpvy2AhWyl
Ga/VxaUwzmWEyICWTo97FT36ayutyQ==
=ZRPY
-----END PGP SIGNATURE-----

--he3rfgt7idbalay4--
