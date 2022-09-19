Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D73D5BD7B4
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 00:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiISW4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 18:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiISW42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 18:56:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C2E459B4
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:56:23 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l14so2074147eja.7
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 15:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5S9VBftUHA8Ab+AfT1DhnDF/jWnQCvfphMhw9w+YVhc=;
        b=pT3AVw/XaQKfMJa28M67X6CWfwalI0Uvo6unsRjOTD2Z+d/hMLJagRy91+fB9mWt/H
         RvjlLsn+3FsNx74QkbruJHKtTQ+30w35PYmoN36zBZvRhmzaaut2t/ejO0VHEYQ77EDj
         OXDYFEqkBBbGSPaGws21i+7eNFUtsVpC10Ocfp53V0C+AqpxtnC2gWLf09NvoZb8DNZe
         nefkWz5Q2xpTnqPE/9sJZpmszdShkKibcjHKjjaL4N2+oQKOJucjE0sZV5m8l2gxJQLL
         eUTG5Bs9Z5UoBJW4L2zlLkhjGsOc0HVn5guvp/vsJvOqjFnEQJHDOGaHy7aMupntX7WF
         7vTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5S9VBftUHA8Ab+AfT1DhnDF/jWnQCvfphMhw9w+YVhc=;
        b=FUg0NAqOJCxx4svSV5W2HuFLlnoS9TEThAwVL4YG+BYhVJc/msEyqQMdWn81hf04w6
         5AEzfnw5qnvW+aEvlqMwd/1HwxHL/ONWgj49qKhEVJu3nbWCwvtj1jZK5BJmPHUl515k
         Wm5GPXHuh/kqjMeJ/zklJ9AtUz3m61vTRYbRjuwzeGrhS+NyJeFyBWM+ZYB1NctYfM9O
         zRJt+HuT1M9N58SzaflSEP7LzQoCwchkgSObIDRQRehnDhVu48p1faGZbiWxu3HByJWY
         BpEyl4ur5TmU+f5x16d6i0FxIjMCYpbfqWMwn3y8/9o4OZRiPuZiW1mFFbsibw5Se7/D
         cDjA==
X-Gm-Message-State: ACrzQf2RXi7LPHuFn6W/xnznzB0V578nmfEAjFJ50rUnRJbkeOIPRCZb
        mcmAfPH6OHgwPBTX78RHCvMJH0T3GgPscDEDrobfSA==
X-Google-Smtp-Source: AMsMyM5kdxcAfNB78ChbidtnpNAMschNYMIGpvHRr7zgKTZ4CCEGx6bhJgHHTNr9SAgKH+LAmfDCBtvH2R9hQBackB8=
X-Received: by 2002:a17:906:ef8c:b0:77c:8f77:330 with SMTP id
 ze12-20020a170906ef8c00b0077c8f770330mr14503775ejb.604.1663628181793; Mon, 19
 Sep 2022 15:56:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220701012647.2007122-1-saravanak@google.com>
 <YwS5J3effuHQJRZ5@kroah.com> <CAOesGMivJ5Q-jdeGKw32yhjmNiYctHjpEAnoMMRghYqWD2m2tw@mail.gmail.com>
 <YygsEtxKz8dsEstc@kroah.com>
In-Reply-To: <YygsEtxKz8dsEstc@kroah.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Mon, 19 Sep 2022 15:56:09 -0700
Message-ID: <CAOesGMh5GHCONTQ9M1Ro7zW-hkL_1F7Xt=xRV0vYSfPY=7LYkQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Fix console probe delay when stdout-path isn't set
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Saravana Kannan <saravanak@google.com>,
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
        Rob Herring <robh@kernel.org>,
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 1:44 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Sun, Sep 18, 2022 at 08:44:27PM -0700, Olof Johansson wrote:
> > On Tue, Aug 23, 2022 at 8:37 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Jun 30, 2022 at 06:26:38PM -0700, Saravana Kannan wrote:
> > > > These patches are on top of driver-core-next.
> > > >
> > > > Even if stdout-path isn't set in DT, this patch should take console
> > > > probe times back to how they were before the deferred_probe_timeout
> > > > clean up series[1].
> > >
> > > Now dropped from my queue due to lack of a response to other reviewer's
> > > questions.
> >
> > What happened to this patch? I have a 10 second timeout on console
> > probe on my SiFive Unmatched, and I don't see this flag being set for
> > the serial driver. In fact, I don't see it anywhere in-tree. I can't
> > seem to locate another patchset from Saravana around this though, so
> > I'm not sure where to look for a missing piece for the sifive serial
> > driver.
> >
> > This is the second boot time regression (this one not fatal, unlike
> > the Layerscape PCIe one) from the fw_devlink patchset.
> >
> > Greg, can you revert the whole set for 6.0, please? It's obviously
> > nowhere near tested enough to go in and I expect we'll see a bunch of
> > -stable fixups due to this if we let it remain in.
>
> What exactly is "the whole set"?  I have the default option fix queued
> up and will send that to Linus later this week (am traveling back from
> Plumbers still), but have not heard any problems about any other issues
> at all other than your report.

I stand corrected in this case, the issue on the Hifive Unmatched was
a regression due to a PWM clock change -- I just sent a patch for that
(serial driver fix).

So it seems like as long as the fw_devlink.strict=1 patch is reverted,
things are back to a working state here.

I still struggle with how the fw_devlink patchset is expected to work
though, since DT is expected to describe the hardware configuration,
and it has no knowledge of whether there are drivers that will be
bound to any referenced supplier devnodes. It's not going to work well
to assume that they will always be bound, and to add 10 second
timeouts for those cases isn't a good solution. Seems like the number
of special cases will keep adding up.

The whole design feels like it's falling short, and it's been patched
here and there to deal with the shortcomings, instead of revisiting
the full solution. (The patches are the console one, and another to
deal with nfsroot boots).

As long as it doesn't keep regressing others, I suppose the work to
redesign it can happen in-tree, but it's not usually how we try to do
it for new functionality. Especially since it's still being iterated
on (with active patch sets posted around -rc1 for improvements).

Oh, and one more thing for the future -- the main patch that changes
behavior due to dependency tracking is 2f8c3ae8288e, named "driver
core: Add wait_for_init_devices_probe helper function". It's easy to
overlook this when looking at a list of patches since it's said to
just introduce a helper.


-Olof
