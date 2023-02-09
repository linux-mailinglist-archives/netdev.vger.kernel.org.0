Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F168690BD1
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 15:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBIObT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 09:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjBIObC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 09:31:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CF85D3DF;
        Thu,  9 Feb 2023 06:30:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7D695CE24F3;
        Thu,  9 Feb 2023 14:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C41C433EF;
        Thu,  9 Feb 2023 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675953052;
        bh=n5q92jtNB++4BoYIauYygzacB4DdXZvQYlYHsoaQZHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4cNRE4MQxZhPNyBF/08CXXf/FWNQlzUwcRLG/0S65J/4ZChTqeAH+gdyIm7+puo/
         e1NMfqyqjToGWx/m2stUfU7oe9VJ+8njI+o0jyklZ6aQ10e0wIfN7idp96BYLv9Fv3
         QhfxNouUc0qZTgyD3UIjJF1eoI/sa7sYlEflw9jIrrOTdIfoFZo0OmH5vYc0Tjwjlg
         7k/6gJhmjkwo6pEOCZrEJ5FmUMlxfm8y1s7LLhR+jeJXraVBKucJ1jUqjs66gKI0qH
         XjavWBRymrRU2MvlL95tjkP7Fwb0aTwHP4DAbOFosKC6AT8CudX5DVtLZ+LDNj9wE2
         dDufUua3aqd7w==
Date:   Thu, 9 Feb 2023 14:30:29 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        jic23@kernel.org, tudor.ambarus@microchip.com, pratyush@kernel.org,
        sanju.mehta@amd.com, chin-ting_kuo@aspeedtech.com, clg@kaod.org,
        kdasu.kdev@gmail.com, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, eajames@linux.ibm.com, olteanv@gmail.com,
        han.xu@nxp.com, john.garry@huawei.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, narmstrong@baylibre.com,
        khilman@baylibre.com, matthias.bgg@gmail.com, haibo.chen@nxp.com,
        linus.walleij@linaro.org, daniel@zonque.org,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        agross@kernel.org, bjorn.andersson@linaro.org, heiko@sntech.de,
        krzysztof.kozlowski@linaro.org, andi@etezian.org,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        wens@csie.org, jernej.skrabec@gmail.com, samuel@sholland.org,
        masahisa.kojima@linaro.org, jaswinder.singh@linaro.org,
        rostedt@goodmis.org, mingo@redhat.com, l.stelmach@samsung.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        kvalo@kernel.org, git@amd.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, andrew@aj.id.au,
        radu_nicolae.pirea@upb.ro, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        bcm-kernel-feedback-list@broadcom.com, fancer.lancer@gmail.com,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        avifishman70@gmail.com, tmaimon77@gmail.com, tali.perry1@gmail.com,
        venture@google.com, yuenn@google.com, benjaminfair@google.com,
        yogeshgaur.83@gmail.com, konrad.dybcio@somainline.org,
        alim.akhtar@samsung.com, ldewangan@nvidia.com,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        michal.simek@amd.com, linux-aspeed@lists.ozlabs.org,
        openbmc@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org, linux-wpan@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-mtd@lists.infradead.org, lars@metafoo.de,
        Michael.Hennerich@analog.com, linux-iio@vger.kernel.org,
        michael@walle.cc, palmer@dabbelt.com,
        linux-riscv@lists.infradead.org, amitrkcian2002@gmail.com,
        Dhruva Gole <d-gole@ti.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        William Zhang <william.zhang@broadcom.com>
Subject: Re: [PATCH v3 01/13] spi: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Message-ID: <Y+UDhWK6u9NkMTxv@sirena.org.uk>
References: <20230202152258.512973-1-amit.kumar-mahapatra@amd.com>
 <20230202152258.512973-2-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iWU3nY956KPhZko1"
Content-Disposition: inline
In-Reply-To: <20230202152258.512973-2-amit.kumar-mahapatra@amd.com>
X-Cookie: Androphobia:
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iWU3nY956KPhZko1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2023 at 08:52:46PM +0530, Amit Kumar Mahapatra wrote:
> Supporting multi-cs in spi drivers would require the chip_select & cs_gpi=
od
> members of struct spi_device to be an array. But changing the type of the=
se
> members to array would break the spi driver functionality. To make the
> transition smoother introduced four new APIs to get/set the

This break an arm multi_v7_defconfig build:

/build/stage/linux/drivers/spi/spi-pl022.c: In function =E2=80=98pl022_tran=
sfer_one_message=E2=80=99:
/build/stage/linux/drivers/spi/spi-pl022.c:1592:31: error: =E2=80=98struct =
spi_message=E2=80=99 has no member named =E2=80=98spi_get_csgpiod=E2=80=99
 1592 |         pl022->cur_gpiod =3D msg->spi_get_csgpiod(spi, 0);
      |                               ^~
/build/stage/linux/drivers/spi/spi-pl022.c:1592:49: error: =E2=80=98spi=E2=
=80=99 undeclared (first use in this function)
 1592 |         pl022->cur_gpiod =3D msg->spi_get_csgpiod(spi, 0);
      |                                                 ^~~
/build/stage/linux/drivers/spi/spi-pl022.c:1592:49: note: each undeclared i=
dentifier is reported only once for each function it appears in

--iWU3nY956KPhZko1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPlA4QACgkQJNaLcl1U
h9Ai+wf+IWbvrI/uIEjinXzailRkkSP40/uzdnv8AAKF5zA3laimeZYZPCoKfD4X
GzBSQEjiZOJmPZ0wBaHHFFaxHSBlL6rtUoA6r+EEktjzWc6vOsmoUVRt74R+ZMHw
1FyvWR07nFAstJD2rPfPhIZ5bt4yiRX/CmA2SxN1qW74IwjKYAy6jLvbpSAZ4byY
KRnij11f/xqUuiao0L/PTya+dYLUOBEQvXm5JBAIqhZaQVH4G7Ppov0MR15cEMug
OG9oMzu197RFh7WgO6lj8rI9Cssl4vvj6+3owDZ/nK+LFq62Z6AvBGbaP7SoHOOI
Xcz8JdTcCAH0XAgza9flmPUQME9cmQ==
=4wBC
-----END PGP SIGNATURE-----

--iWU3nY956KPhZko1--
