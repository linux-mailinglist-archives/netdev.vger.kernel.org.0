Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751C1522EAD
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243909AbiEKIr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241909AbiEKIr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:47:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C94674C6
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:47:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nohzx-000642-LL; Wed, 11 May 2022 10:47:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4AF667B9AC;
        Wed, 11 May 2022 08:47:06 +0000 (UTC)
Date:   Wed, 11 May 2022 10:47:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     z <zhaojunkui2008@126.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bernard@vivo.com
Subject: Re: [PATCH] usb/peak_usb: cleanup code
Message-ID: <20220511084705.zh5fdetggullt75i@pengutronix.de>
References: <20220511063850.649012-1-zhaojunkui2008@126.com>
 <20220511064450.phisxc7ztcc3qkpj@pengutronix.de>
 <4986975d.3de3.180b1f57189.Coremail.zhaojunkui2008@126.com>
 <CAMZ6RqKHs4gdcNjVONfOTsHh6ZFEt0qpbEaKqDM7c1Cbc1OLdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kn225256pnovgin4"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKHs4gdcNjVONfOTsHh6ZFEt0qpbEaKqDM7c1Cbc1OLdQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kn225256pnovgin4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11.05.2022 17:28:26, Vincent MAILHOL wrote:
> On Wed. 11 May 2022 at 16:11, z <zhaojunkui2008@126.com> wrote:
> > At 2022-05-11 14:44:50, "Marc Kleine-Budde" <mkl@pengutronix.de> wrote:
> > >On 10.05.2022 23:38:38, Bernard Zhao wrote:
> > >> The variable fi and bi only used in branch if (!dev->prev_siblings)
> > >> , fi & bi not kmalloc in else branch, so move kfree into branch
> > >> if (!dev->prev_siblings),this change is to cleanup the code a bit.
> > >
> > >Please move the variable declaration into that scope, too. Adjust the
> > >error handling accordingly.
> >
> > Hi Marc:
> >
> > I am not sure if there is some gap.
> > If we move the variable declaration into that scope, then each error br=
anch has to do the kfree job, like:
> > if (err) {
> >                         dev_err(dev->netdev->dev.parent,
> >                                 "unable to read %s firmware info (err %=
d)\n",
> >                                 pcan_usb_pro.name, err);
> >                         kfree(bi);
> >                         kfree(fi);
> >                         kfree(usb_if);
> >
> >                        return err;
> >                 }
> > I am not sure if this looks a little less clear?
> > Thanks!
>=20
> A cleaner way would be to move all the content of the if
> (!dev->prev_siblings) to a new function.

Good idea.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kn225256pnovgin4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ7eAcACgkQrX5LkNig
010O0Qf8CEz2CHRSRsSKBUb5rg8XhWgg+Z/1qLnQ+fnIwut2NRazLzJxfxhU7+vo
5xIA+7lc4K/N7TQXGKDHtgCt/o4znlfnHYAaUWEJE/B0O0XLq/bxu/feg1///eZz
rJqWtUCCDHDyIVENF8QNQ66ZKAjmqtxZio4xtrO2EmOihktlokp/2fmt0kd+Jh03
0vRz9mRJrKVj3Nb2n4MXerCSDuEK5Ne9Kco8UhGkuqY0+nlc/p7ZQv7aYCMxAj5g
p/W7tVcDXNOqis6ywRUiI4YTTdXG26Hj9GcnSx1COmXzSdolYcmU0MOpQjsH/iYU
y4EWtwp6ixPf389CUGsqTkrMXx63gQ==
=UVby
-----END PGP SIGNATURE-----

--kn225256pnovgin4--
