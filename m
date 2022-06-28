Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2A955C825
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244392AbiF1CZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244078AbiF1CXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:23:48 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB936B94;
        Mon, 27 Jun 2022 19:23:03 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 68so10793016pgb.10;
        Mon, 27 Jun 2022 19:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HJxtqab0/tMiakWNEyC3nFz1/Ap3ZwjlyjInjl9oQ08=;
        b=GtISRQAw32VwWkIqJjbS6kPz10YSeb/J+R05thf6bFPMAOY82jKQN3UdU/3Xm5A6wE
         tMPJ9jiXwXd5WIpoNmuhYObSQi+a4vbyn3XjCacf3FIX++nTWeWgUHF+xWdV2kFekLbZ
         0OzYqNi1FmudYoMCCJZeGvG2ye4sCgduv0rk2Zt4nVkQ98BfuFa3NPGjGKGgPVG9KtHY
         DntPc1msd2JalXRAlzsxyFpEjwPnKkzTvOPkfaVuXEaP+ZKelLBEm4Nr7ZrcOOgm/4RV
         HPa6kkD+OJGFCcd57tIyozXxW7wCGRkiieRac/DfVSrfyK1ch327OFoWU4ImG2SclPJ9
         uIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HJxtqab0/tMiakWNEyC3nFz1/Ap3ZwjlyjInjl9oQ08=;
        b=uKtNSVIaMW9Afk2Jysh68j5jGzaY4UZsPPMdW7SZfsYYvY0v6Bo09tzf8KSCA+Fgm8
         Va6JUpV1KXGNS/fpYTWvxUO+W8pU2ZebRpiE+seQuWUTiIr0Dj3ENGHm71zWjXSQSXUC
         a5vdRjGXrSZLpYtjvaEpEcONTLDWOwz+eE0j6JQUaGW42rKHKJllTDEMTgQojWB9BNfY
         EGP3l2tHt09Oy/l+W15beUJ2z6jcculr8sszAXkHvJvZTgHGVcTAbJFM9AnBJBVex5El
         C+0qExBVo5Ki/EN0o02R35GVQzPk6hFvWkGrolIldrHoZmKXiXi2pyQsT18sW2boZbQa
         MNxw==
X-Gm-Message-State: AJIora9/lsd2H0Y1KkPVZPBON5mKRxcyiSWhum39wLTZW8EWzT1vM6UI
        LKQvyxC709xvJlpCrV2Qfn3lC/9QvbzFsZjp+Qk=
X-Google-Smtp-Source: AGRyM1tkELEQsXZZ9rCiYz26Ox2Bo3COuaabo0ODviEYu2B5j99coTUXvXqjCJz9EcYG+uOHPMvd9KNaBAGlSJExO9A=
X-Received: by 2002:a65:6a0e:0:b0:405:2310:22d0 with SMTP id
 m14-20020a656a0e000000b00405231022d0mr15760605pgu.290.1656382983124; Mon, 27
 Jun 2022 19:23:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220628020110.1601693-1-saravanak@google.com>
In-Reply-To: <20220628020110.1601693-1-saravanak@google.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 27 Jun 2022 23:22:52 -0300
Message-ID: <CAOMZO5D29QqH_-pktht6yO_Ga7B7KgeGXxzyUHJWGYfGTJr4pw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] Fix console probe delay when stdout-path isn't set
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
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
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-serial@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Mon, Jun 27, 2022 at 11:03 PM Saravana Kannan <saravanak@google.com> wrote:
>
> Since the series that fixes console probe delay based on stdout-path[1] got
> pulled into driver-core-next, I made these patches on top of them.
>
> Even if stdout-path isn't set in DT, this patch should take console
> probe times back to how they were before the deferred_probe_timeout
> clean up series[2].
>
> Fabio/Ahmad/Sascha,
>
> Can you give this a shot please?

This series works fine for me (with and without stdout-path), thanks:

Tested-by: Fabio Estevam <festevam@gmail.com>
