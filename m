Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400F76B60E6
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 22:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCKVQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 16:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCKVQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 16:16:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDCD7203C;
        Sat, 11 Mar 2023 13:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D13460DF7;
        Sat, 11 Mar 2023 21:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CADC433EF;
        Sat, 11 Mar 2023 21:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678569403;
        bh=+DzB7/8CoWnkO/XRI1leyDdvUnpN9ch8MSd2GNMDJTM=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=MtiLuqbg+ewNrORM7gYuVWtDY1WITP8fnDMohaMDfvWiK44HvE3TXPL+xscranYBF
         yf1cemIotmGqM2ROCJKFIbsDGJT3UhZqQwDXgx6UPzbcJrejJnMC8imhMQDvh/3otz
         wQ6QvUFpmKZqwcQ0FlnWNou2FH119vYfI+6XYOoc4Eq2rGIbp0vxaPq+RgishnR9ku
         DRAHcvNCbawn8KZYF6NlW5WDU1hyJ4TX6kHb4jQ03jf2xQJXjTCRrFF2p/607748IQ
         RgZSHqHtQF0djp0rR09WieyymQvaZ306PNgk7wdUdd9UxHPOis6usgGrTDI1JSrbQM
         TV9gW7JLoVEeg==
From:   Mark Brown <broonie@kernel.org>
To:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        jic23@kernel.org, pratyush@kernel.org, sanju.mehta@amd.com,
        chin-ting_kuo@aspeedtech.com, clg@kaod.org, kdasu.kdev@gmail.com,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        eajames@linux.ibm.com, olteanv@gmail.com, han.xu@nxp.com,
        john.garry@huawei.com, shawnguo@kernel.org, s.hauer@pengutronix.de,
        khilman@baylibre.com, matthias.bgg@gmail.com, haibo.chen@nxp.com,
        linus.walleij@linaro.org, daniel@zonque.org,
        haojian.zhuang@gmail.com, robert.jarzmik@free.fr,
        agross@kernel.org, heiko@sntech.de, krzysztof.kozlowski@linaro.org,
        andi@etezian.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        masahisa.kojima@linaro.org, jaswinder.singh@linaro.org,
        rostedt@goodmis.org, mingo@redhat.com, l.stelmach@samsung.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.aring@gmail.com, stefan@datenfreihafen.org,
        kvalo@kernel.org, james.schulman@cirrus.com,
        david.rhodes@cirrus.com, tanureal@opensource.cirrus.com,
        rf@opensource.cirrus.com, perex@perex.cz, tiwai@suse.com,
        npiggin@gmail.com, christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        oss@buserror.net, windhl@126.com, yangyingliang@huawei.com,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Cc:     git@amd.com, linux-spi@vger.kernel.org,
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
        amitrkcian2002@gmail.com
In-Reply-To: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
References: <20230210193647.4159467-1-amit.kumar-mahapatra@amd.com>
Subject: Re: (subset) [PATCH v4 00/15] spi: Add support for
 stacked/parallel memories
Message-Id: <167856937606.964268.6047676283886463336.b4-ty@kernel.org>
Date:   Sat, 11 Mar 2023 21:16:16 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Feb 2023 01:06:31 +0530, Amit Kumar Mahapatra wrote:
> This patch is in the continuation to the discussions which happened on
> 'commit f89504300e94 ("spi: Stacked/parallel memories bindings")' for
> adding dt-binding support for stacked/parallel memories.
> 
> This patch series updated the spi-nor, spi core and the spi drivers
> to add stacked and parallel memories support.
> 
> [...]

Applied to

   broonie/spi.git for-next

Thanks!

[01/15] spi: Replace all spi->chip_select and spi->cs_gpiod references with function call
        commit: 9e264f3f85a56cc109cc2d6010a48aa89d5c1ff1
[02/15] net: Replace all spi->chip_select and spi->cs_gpiod references with function call
        commit: 25fd0550d9b9c92288a17fb7d605cdcdb4a65a64
[03/15] iio: imu: Replace all spi->chip_select and spi->cs_gpiod references with function call
        commit: 0183f81fce154ae1d4df2bb28d22ad6612317148
[04/15] mtd: devices: Replace all spi->chip_select and spi->cs_gpiod references with function call
        commit: 0817bcef53e4e3df23c023eddaa2b35b7288400e
[05/15] staging: Replace all spi->chip_select and spi->cs_gpiod references with function call
        commit: caa9d3475b1c5566f0272273c147cc9b72f2be28
[06/15] platform/x86: serial-multi-instantiate: Replace all spi->chip_select and spi->cs_gpiod references with function call
        commit: e20451f44ca33ec40422e9868775e117ef2da935
[07/15] powerpc/83xx/mpc832x_rdb: Replace all spi->chip_select references with function call
        commit: 3aba06a9fee04f6fefa9df71d3ee27dd4c464ad5
[08/15] ALSA: hda: cs35l41: Replace all spi->chip_select references with function call
        commit: 06b5e53c8b2b016e06a53ab6f01006ca7bbfa5df
[09/15] spi: Add stacked and parallel memories support in SPI core
        (no commit info)

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

