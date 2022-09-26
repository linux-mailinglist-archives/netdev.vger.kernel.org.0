Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793285EAFD5
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiIZS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiIZS0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B210B53038;
        Mon, 26 Sep 2022 11:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA96611FE;
        Mon, 26 Sep 2022 18:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A194C43141;
        Mon, 26 Sep 2022 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664216728;
        bh=Y5qLzRGdsOCwx5ouHFiN9SCKtz+YXlGNMDHQ/+qU8uw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kqWfLDMVQE1v+BdTxETwBYr6RTduIuEN9ZhkSh7vUXPSDzXB2F+slGOrt2kqlzxEx
         /zVFIziJ3HUzYkfuUMbxsLj8h28WG9e9bRCvIcfWMRN377I9MXqHmagFAclo1QY4nl
         QGu85R6bAd/4fCPjPl4w/HQbCZxvqIVln0uh7YtLv5FLV8XdBYSKzmyfLOw5I8dLZN
         pjVLxNFXkY1KdFuzJdoDsnADsrTBvxD9+1r5a2dismbZo9JeXq76luOIRnf3txmoR1
         IcSe1p+0EGqnliT8SYUV061yQstm3OtueYceF/9B6zUAouuaKzAVHQCxW4mTQ+uhHA
         y4k90bJv/SWTQ==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-351630b1728so8496877b3.1;
        Mon, 26 Sep 2022 11:25:28 -0700 (PDT)
X-Gm-Message-State: ACrzQf31pUUO5DH7itwV3LK7uY9YZM/sU080iiPL0FObNKDxbXZidwHA
        tqqKLfRImyDzHrHGb8ByNaYOMgKFaFYfEX9YDg==
X-Google-Smtp-Source: AMsMyM5WOL0fZfHYzWaw2DdaPSr6kh7DGRI2ScO+UdVg2zStt3aJXG4qtOOC5FFK87yV5Mi/AUvaSMeil9/+6K1KBfA=
X-Received: by 2002:a81:6608:0:b0:351:4cd2:d59a with SMTP id
 a8-20020a816608000000b003514cd2d59amr1485347ywc.432.1664216717388; Mon, 26
 Sep 2022 11:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220701012647.2007122-1-saravanak@google.com>
 <YwS5J3effuHQJRZ5@kroah.com> <CAOesGMivJ5Q-jdeGKw32yhjmNiYctHjpEAnoMMRghYqWD2m2tw@mail.gmail.com>
 <YygsEtxKz8dsEstc@kroah.com> <CAOesGMh5GHCONTQ9M1Ro7zW-hkL_1F7Xt=xRV0vYSfPY=7LYkQ@mail.gmail.com>
In-Reply-To: <CAOesGMh5GHCONTQ9M1Ro7zW-hkL_1F7Xt=xRV0vYSfPY=7LYkQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 26 Sep 2022 13:25:05 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK7auA8coB3DCqSDKw1ept_yQihVs-Me3bvU923os23xg@mail.gmail.com>
Message-ID: <CAL_JsqK7auA8coB3DCqSDKw1ept_yQihVs-Me3bvU923os23xg@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Fix console probe delay when stdout-path isn't set
To:     Olof Johansson <olof@lixom.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Al Cooper <alcooperx@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Russell King <linux@armlinux.org.uk>,
        Vineet Gupta <vgupta@kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Taichi Sugaya <sugaya.taichi@socionext.com>,
        Takao Orito <orito.takao@socionext.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Pali Rohar <pali@kernel.org>,
        Andreas Farber <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hammer Hsieh <hammerh0314@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Timur Tabi <timur@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        sascha hauer <sha@pengutronix.de>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org,
        linux-rpi-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-actions@lists.infradead.org,
        linux-unisoc@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 5:56 PM Olof Johansson <olof@lixom.net> wrote:
>
> On Mon, Sep 19, 2022 at 1:44 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Sep 18, 2022 at 08:44:27PM -0700, Olof Johansson wrote:
> > > On Tue, Aug 23, 2022 at 8:37 AM Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Thu, Jun 30, 2022 at 06:26:38PM -0700, Saravana Kannan wrote:
> > > > > These patches are on top of driver-core-next.
> > > > >
> > > > > Even if stdout-path isn't set in DT, this patch should take console
> > > > > probe times back to how they were before the deferred_probe_timeout
> > > > > clean up series[1].
> > > >
> > > > Now dropped from my queue due to lack of a response to other reviewer's
> > > > questions.
> > >
> > > What happened to this patch? I have a 10 second timeout on console
> > > probe on my SiFive Unmatched, and I don't see this flag being set for
> > > the serial driver. In fact, I don't see it anywhere in-tree. I can't
> > > seem to locate another patchset from Saravana around this though, so
> > > I'm not sure where to look for a missing piece for the sifive serial
> > > driver.
> > >
> > > This is the second boot time regression (this one not fatal, unlike
> > > the Layerscape PCIe one) from the fw_devlink patchset.
> > >
> > > Greg, can you revert the whole set for 6.0, please? It's obviously
> > > nowhere near tested enough to go in and I expect we'll see a bunch of
> > > -stable fixups due to this if we let it remain in.
> >
> > What exactly is "the whole set"?  I have the default option fix queued
> > up and will send that to Linus later this week (am traveling back from
> > Plumbers still), but have not heard any problems about any other issues
> > at all other than your report.
>
> I stand corrected in this case, the issue on the Hifive Unmatched was
> a regression due to a PWM clock change -- I just sent a patch for that
> (serial driver fix).
>
> So it seems like as long as the fw_devlink.strict=1 patch is reverted,
> things are back to a working state here.
>
> I still struggle with how the fw_devlink patchset is expected to work
> though, since DT is expected to describe the hardware configuration,
> and it has no knowledge of whether there are drivers that will be
> bound to any referenced supplier devnodes. It's not going to work well
> to assume that they will always be bound, and to add 10 second
> timeouts for those cases isn't a good solution. Seems like the number
> of special cases will keep adding up.

Since the introduction of deferred probe, the kernel has always
assumed if there is a device described, then there is or will be a
driver for it. The result is you can't use new DTs (if they add
providers) with older kernels.

We've ended up with a timeout because no one has come up with a better
way to handle it. What the kernel needs is userspace saying "I'm done
loading modules", but it's debatable whether that's a good solution
too.

Rob
