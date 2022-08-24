Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E508A59F105
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 03:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiHXBdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiHXBdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 21:33:47 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453324F659
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 18:33:46 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-33da3a391d8so11433487b3.2
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 18:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=15+zFGICN73u7PZkuVftuGFAaRqO2hNiuUPbcuB/iDw=;
        b=ammrl+ffQIbxpXELKnFxaurs3Fbe2bx9R/IRI2+J5pQAM/wfjFh1aSFzyWG/E1RD5I
         rshOZlmvK+Bt4a2MNbUFbSpkCeSrrxRT3zaVTQqLRUMz4elzDZb4CyvIvtQzq4jGwi+1
         HBILJXTenmBL8ezDV/XzSltMyRVW8N5pGLVc6ZMhlIDEvl+mrwxpUc5n+db5z5Pfve4k
         jWbqAzYB3Hyg5oa2ZHgXfW73ElDNxOwcp7mMt28pojnFNBEyD2+0HttoLOb68bdPn3gz
         h+F5uqyOw5Q9oI+0N52Nr3XEpZ0TzyQMzlW05rWkdP3Hj3nW89n+8r+x6EjcJTcjYaCu
         dSgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=15+zFGICN73u7PZkuVftuGFAaRqO2hNiuUPbcuB/iDw=;
        b=mPOC8rJdgUVUjRW3J5nDStsj7x7Usv56L6gYpYftX79xfEK6om6Mgewq6OrfqnlCC1
         nLeRC4+F4HmyCblc0Y4ALDjm3PlnXrQaWvFl0yHk7gH5AFj2E8JhPx7kxE1jNr5Y61Jr
         tUk2KllE6089WKAwOyrriWR4UCBPu0GHNhcqpTKktdKIOac50IMi8nqhSyAmjGAtzC2u
         B3mg2WTEpCuAe8OdlEsCk+UTEPIU4PAtmweJ8si8fWZxYjXGsroCkmpAShMoWK/MdfHY
         ZenXoHJbthfg3vX3YdVKAuwfJ6N9ZKfZBNcW4nSh73ui6HUA27W2Nt07UF81Tr08YaYd
         aLXg==
X-Gm-Message-State: ACgBeo2AMJQLTfFuaCmKtxDejcMqRteYc6/oNqPKjXpAEcT54YIoaAg0
        kuf9GqV9JQbMXIHSua/2jTxctUJpQ3+g5p6tqEmI2A==
X-Google-Smtp-Source: AA6agR5VUVZnLczkpHKFOKrnd+Tscg/SlOlcCZoOHfOkTvdY9LhPO1gaSJJ+tW/v5A56NSwT8mnZVrMApq5J4jdaQcY=
X-Received: by 2002:a25:1546:0:b0:68f:8758:7348 with SMTP id
 67-20020a251546000000b0068f87587348mr24825887ybv.563.1661304824786; Tue, 23
 Aug 2022 18:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220701012647.2007122-1-saravanak@google.com> <YwS5J3effuHQJRZ5@kroah.com>
In-Reply-To: <YwS5J3effuHQJRZ5@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 23 Aug 2022 18:33:07 -0700
Message-ID: <CAGETcx8C_Hw588J_DsDELp2rS-UNnezpqqqvUixqGR7m2wDKaA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Fix console probe delay when stdout-path isn't set
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 4:25 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 30, 2022 at 06:26:38PM -0700, Saravana Kannan wrote:
> > These patches are on top of driver-core-next.
> >
> > Even if stdout-path isn't set in DT, this patch should take console
> > probe times back to how they were before the deferred_probe_timeout
> > clean up series[1].
>
> Now dropped from my queue due to lack of a response to other reviewer's
> questions.

Sorry, I somehow missed those emails. I'll respond later today/tomorrow.

-Saravana
