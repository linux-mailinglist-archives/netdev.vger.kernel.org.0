Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0516408F1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiLBPFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiLBPF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:05:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F71B37F8D
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 07:05:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p17as-0004iX-Qd; Fri, 02 Dec 2022 16:04:50 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 135E2131753;
        Fri,  2 Dec 2022 15:04:48 +0000 (UTC)
Date:   Fri, 2 Dec 2022 16:04:39 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, krzysztof.kozlowski+dt@linaro.org,
        wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
Subject: Re: RE: RE: [PATCH v3 1/2] can: m_can: Move mram init to mcan device
 setup
Message-ID: <20221202150439.dmt7omdck7wdjpbv@pengutronix.de>
References: <20221122105455.39294-1-vivek.2311@samsung.com>
 <CGME20221122105022epcas5p3f5db1c5790b605bac8d319fe06ad915b@epcas5p3.samsung.com>
 <20221122105455.39294-2-vivek.2311@samsung.com>
 <20221123224146.iic52cuhhnwqk2te@pengutronix.de>
 <01a101d8ffe4$1797f290$46c7d7b0$@samsung.com>
 <20221124145405.d67cb6xmoiqfdsq3@pengutronix.de>
 <01f901d9053a$f138bdd0$d3aa3970$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nnzicvks5gam4beu"
Content-Disposition: inline
In-Reply-To: <01f901d9053a$f138bdd0$d3aa3970$@samsung.com>
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


--nnzicvks5gam4beu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 09:40:50, Vivek Yadav wrote:
> > That probably depends on you power management. If I add a regulator
> > to power the external tcan4x5x chip and power it up during open(), I
> > need to initialize the RAM.
> >=20
> Thanks for the clarification,
>
> There is one doubt for which I need clarity if I add ram init in
> m_can_chip_config.
>=20
> In the current implementation, m_can_ram_init is added in the probe
> and m_can_class_resume function.
>
> If I add the ram init function in chip_config which is getting called
> from m_can_start, then m_can_init_ram will be called two times, once
> in resume and next from m_can_start also.

As m_can_start() is called from resume, remove the direct call to
m_can_init_ram() from m_can_class_resume().

> Can we add ram init inside the m_can_open function itself? Because it
> is independent of m_can resume functionality.

See above.

mainline implementation:

m_can_class_resume()
        -> m_can_init_ram()

m_can_open()
        -> m_can_start()
        -> m_can_chip_config()
        -> ops->init
                m_can_init_ram() (for tcan only)


proposed:

m_can_class_resume()
        -> m_can_start()
        -> m_can_chip_config()
        -> m_can_init_ram()

m_can_open()
        -> m_can_start()
        -> m_can_chip_config()
        -> m_can_init_ram()

In mainline m_can_init_ram() is called for the tcan during open(). So if
you call m_can_init_ram() from m_can_chip_config(), remove it from the
tcan's tcan4x5x_init() functions, and from m_can_class_resume() it
should only be called once for open and once for resume.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nnzicvks5gam4beu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKFAUACgkQrX5LkNig
011Q9Af8D5n0O+psn9BhVDedhpW//hB/XQMMH7zksV1ocaFaqRhrKndNq/6VxvaQ
76p0XvaMDoItxBNZOQPFCNibWg8okFne0hyy1QiFmAxzxstuitQJmdsdRAAFZ3Sd
wheA/xiL2BYQtbRgDkK2ANmQawU9+tOyRmIRRWCki9vcZ4J346uhAzRs6G7BShOr
w1KH/8oTD5dDIwoyAXvaFeGKNgaf/YDV4JUhwrjFr9dpX4g7HrVsacPxD0V9gyVX
nI8hamSZM4JAB5tN16hCIsUlnejUHR7QRPy+/q88HyvULstvXWZJ64OERksd++7G
TCm0ycMZAmZ8WzJmxhCKz01go341Zg==
=1sZ5
-----END PGP SIGNATURE-----

--nnzicvks5gam4beu--
