Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E456ACAA9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCFRfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjCFRff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:35:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9386A1F0;
        Mon,  6 Mar 2023 09:35:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27F39B8105F;
        Mon,  6 Mar 2023 17:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4725C433EF;
        Mon,  6 Mar 2023 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678123997;
        bh=oCRV/O5q3R94VDA67eta1+j60LSWpLxWhmxqrzbP2FY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tzMRw/rwKmj16OdXkTBYsEPVgFatAfUN3LJ33ZBFVzmWPChI0zegxz8a6lrSnpVNM
         a5WWAe2HioVWJtIPc/ttoZWVvhbbsyNHioBhNIQsfUp41fNu7Bsn12CrCVulbshfh3
         xaVbonUnnhiN36hPDyYZX/yUWExunxxxGCl97t7m1BbXS8j1Pcd3ba2pmytwNFlcuo
         A4JumTBBP3xhvGiEXHq6D5gvgXZpJRCL48CblfxVMHFohHME3UQpdMcaz7KQ0rX6Bi
         zb4ahU89uF20dlnC+V+KW34/XFSen5uQSXFbDSnNjd2h/1S6Rp+UFmOkj5NVaXulLq
         RxBBn71VZ8v1A==
Date:   Mon, 6 Mar 2023 17:32:49 +0000
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
Message-ID: <479f5b1e-6ac1-47c7-9f5b-4080e0c77c16@sirena.org.uk>
References: <20230306172109.595464-1-amit.kumar-mahapatra@amd.com>
 <20230306172109.595464-2-amit.kumar-mahapatra@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1RpCo94WkIg3XG9u"
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


--1RpCo94WkIg3XG9u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 06, 2023 at 10:50:55PM +0530, Amit Kumar Mahapatra wrote:
> Supporting multi-cs in spi drivers would require the chip_select & cs_gpiod
> members of struct spi_device to be an array. But changing the type of these
> members to array would break the spi driver functionality. To make the
> transition smoother introduced four new APIs to get/set the
> spi->chip_select & spi->cs_gpiod and replaced all spi->chip_select and
> spi->cs_gpiod references with get or set API calls.
> While adding multi-cs support in further patches the chip_select & cs_gpiod
> members of the spi_device structure would be converted to arrays & the
> "idx" parameter of the APIs would be used as array index i.e.,
> spi->chip_select[idx] & spi->cs_gpiod[idx] respectively.

This doesn't apply against current code, there was a rework of the
mpc512x-psc driver.  Please check and resend.

--1RpCo94WkIg3XG9u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmQGI8AACgkQJNaLcl1U
h9CIEwf/aZyH3WWgY7CUVh9W2WlSP5NnJGsbwRuFubTTP3ObZz0pCsJEwP8mAwdf
wpWZ2t/nCcibXSVknqIW+r7FPrfknmY5nJ9jal+WTp/hkYYJeVEebOg9nMUX+Nwh
fycQjw6AcKBn6mbRNf2c9ZVSKOpTnKNHFCdGSAfVWdMclSNADYerewze+WELEn9D
6YoQTAPR4B1PBZUkwpAympwP8+SR1wFKzN2dmCVFQSWgYJ834b4wWLD9eZFMrjEN
gf4+dIPQkjxzNMIErUCqVkaf/wgPkCAIjb2p1cWKU2b3IOG6di49DMsuImObYUAJ
8cVDQ8KP5PGcINenovKCKWd1awBmtw==
=ppxH
-----END PGP SIGNATURE-----

--1RpCo94WkIg3XG9u--
