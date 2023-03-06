Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA36AD03B
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjCFV2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCFV2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:28:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137A22057B;
        Mon,  6 Mar 2023 13:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8056B81135;
        Mon,  6 Mar 2023 21:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA102C433A1;
        Mon,  6 Mar 2023 21:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678138079;
        bh=OPscq8j4gixbBXyx4rYRiqcOtug0pajWX+t3LwK0uPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PsQMxWTNyqmjmOyLA6f4aBxEbqjXLjGnQvTHUoE4f6zTvuB0TEbKKoow7O0Bl6lqg
         gYnqSQeBrO1rJ29HWmn+yvMly1eyD9pru67Ei5XhYPhftQR6cu4eDx5Y2uE63s5KIt
         s3zsZ4FOYFUkiy7gTDlGyR2DhiXrF2ddTXSUbWfDk94k+YWjCuHsJXdkT6LOyMmw3/
         OBMkdU9AXHfmpJlFP0bcKZdHq+IuioXEaW+oivplUHjLiBGkJeMjuBmdvu2rgkgh5Q
         WG7SALFgV1PPXh9MrSvGscl5OUXQrlqRl1aL8dYkfSYDeEvI72A6J1sMyBNHxpS7Fw
         LxAw7Z0FF0jTA==
Date:   Mon, 6 Mar 2023 21:27:32 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        jic23@kernel.org, tudor.ambarus@microchip.com, pratyush@kernel.org,
        Sanju.Mehta@amd.com, chin-ting_kuo@aspeedtech.com, clg@kaod.org,
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
        kvalo@kernel.org, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, tanureal@opensource.cirrus.com,
        rf@opensource.cirrus.com, perex@perex.cz, tiwai@suse.com,
        npiggin@gmail.com, christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        oss@buserror.net, windhl@126.com, yangyingliang@huawei.com,
        william.zhang@broadcom.com, kursad.oney@broadcom.com,
        jonas.gorski@gmail.com, anand.gore@broadcom.com, rafal@milecki.pl,
        git@amd.com, linux-spi@vger.kernel.org,
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
        linux-riscv@lists.infradead.org, alsa-devel@alsa-project.org,
        patches@opensource.cirrus.com, linuxppc-dev@lists.ozlabs.org,
        amitrkcian2002@gmail.com, Dhruva Gole <d-gole@ti.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>
Subject: Re: [PATCH V5 01/15] spi: Replace all spi->chip_select and
 spi->cs_gpiod references with function call
Message-ID: <00684da3-520f-459d-b6bd-55e728e93ebf@sirena.org.uk>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
 <20230306172109.595464-2-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RfYQ7lwbbyjtjTUN"
Content-Disposition: inline
In-Reply-To: <20230306172109.595464-2-amit.kumar-mahapatra@amd.com>
X-Cookie: teamwork, n.:
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RfYQ7lwbbyjtjTUN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 06, 2023 at 10:50:55PM +0530, Amit Kumar Mahapatra wrote:

>  drivers/spi/spi-omap-100k.c       |  2 +-

This is also not against -rc1, this file was removed in bcace9c4c9270292
("spi: remove omap 100K driver").

--RfYQ7lwbbyjtjTUN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQGWsMACgkQJNaLcl1U
h9C7Fwf+MqZVyi3PlI6YIKPDaaFyWnmjZtweIjxd+4E2eEmTZq9MbcCHS/W56cUk
TPWusPOjIa33XHC376rZpTYGqNTRjvOo8UwttJFAFQFbtMNui8BfC1bnrROwoyUE
AxcOxhCAi3r1P0nRIkS126TepySOo1qXD1gf6YUQydf6/iDxzq7VddVjfqtt3dPF
6rnt0G5xA5O0Z75Kc76h4ePCX7kXMqJhJSaJf7HFcGwD2P5HIeRcRyucD2q4Ddnr
KzkdziV90/s6X7Q9cfiA620jfm8jVdqqN3yC+JX/L2Iu8kpeefFFgD49yG2aMtxv
zgXP6uMpvQm5g7F9e/wo/JMWhjfh8g==
=uJRe
-----END PGP SIGNATURE-----

--RfYQ7lwbbyjtjTUN--
