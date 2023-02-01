Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803AE686C48
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBAQ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjBAQ6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:58:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E6A7B402;
        Wed,  1 Feb 2023 08:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D37961889;
        Wed,  1 Feb 2023 16:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4DFC433D2;
        Wed,  1 Feb 2023 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675270673;
        bh=wgoFWDzet3MEnQEk+UbM8HUIOsFtAK8npPJ49HGAO1o=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=u9X4Gr7TjZ6UkgVwjSehC9yfCUt//67EjPYTXTHnJ+aTE6aXNoDaG/fZz03jXnElM
         c315hFd6D+lNgE3Ekgg0QaNB3z7pxxWqm4plvstpHb14GQ0FGDiib2q7//3OZr4/JT
         i0jWp+SqAe/OVftlr6AN17B1kIJdLkIF0i/EuIo2IVSpqxiD6qKmMLkB+1ogV6NLc6
         JidEOiKwk15fIiFO+dc5Qsvoe66Y0tsqMeopIu++n7efbaGm5W5Uc31U7fqGait52w
         WnE8sOF8lc6h19Dd3hynSSTPWQGh4Vapzj+sPUAC+hBsgiEQz8Z/aI5T8L99Afd+Hr
         1f40qveSqB9TQ==
From:   Mark Brown <broonie@kernel.org>
To:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        jic23@kernel.org, tudor.ambarus@microchip.com, pratyush@kernel.org,
        sanju.mehta@amd.com, chin-ting_kuo@aspeedtech.com, clg@kaod.org,
        kdasu.kdev@gmail.com, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, eajames@linux.ibm.com, olteanv@gmail.com,
        han.xu@nxp.com, john.garry@huawei.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, khilman@baylibre.com,
        matthias.bgg@gmail.com, haibo.chen@nxp.com,
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
        kvalo@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        skomatineni@nvidia.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, j.neuschaefer@gmx.net,
        vireshk@kernel.org, rmfrfs@gmail.com, johan@kernel.org,
        elder@kernel.org, gregkh@linuxfoundation.org,
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
        linux-riscv@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, greybus-dev@lists.linaro.org,
        linux-staging@lists.linux.dev, amitrkcian2002@gmail.com
In-Reply-To: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
References: <20230119185342.2093323-1-amit.kumar-mahapatra@amd.com>
Subject: Re: (subset) [PATCH v2 00/13] spi: Add support for
 stacked/parallel memories
Message-Id: <167527065195.537421.10361370461620477483.b4-ty@kernel.org>
Date:   Wed, 01 Feb 2023 16:57:31 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 00:23:29 +0530, Amit Kumar Mahapatra wrote:
> This patch is in the continuation to the discussions which happened on
> 'commit f89504300e94 ("spi: Stacked/parallel memories bindings")' for
> adding dt-binding support for stacked/parallel memories.
> 
> This patch series updated the spi-nor, spi core and the spi drivers
> to add stacked and parallel memories support.
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git for-next

Thanks!

[01/13] spi: Add APIs in spi core to set/get spi->chip_select and spi->cs_gpiod
        commit: 303feb3cc06ac0665d0ee9c1414941200e60e8a3
[02/13] spi: Replace all spi->chip_select and spi->cs_gpiod references with function call
        (no commit info)
[03/13] net: Replace all spi->chip_select and spi->cs_gpiod references with function call
        (no commit info)
[04/13] iio: imu: Replace all spi->chip_select and spi->cs_gpiod references with function call
        (no commit info)
[05/13] mtd: devices: Replace all spi->chip_select and spi->cs_gpiod references with function call
        (no commit info)
[06/13] staging: Replace all spi->chip_select and spi->cs_gpiod references with function call
        (no commit info)
[07/13] platform/x86: serial-multi-instantiate: Replace all spi->chip_select and spi->cs_gpiod references with function call
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

