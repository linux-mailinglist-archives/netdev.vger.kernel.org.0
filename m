Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30542563137
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 12:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiGAKSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 06:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235572AbiGAKSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 06:18:12 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695E3BC92;
        Fri,  1 Jul 2022 03:18:11 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id g4so3203786ybg.9;
        Fri, 01 Jul 2022 03:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IK1q7pWvnzmd2/yzmMQOB6gFUgHkXgsyzwODpSKqHtU=;
        b=jSDpH5b4ezTXYDkI+Kv1qjoulW4GueRKAo9MfvH6Or74WD1aO19b0yl9X6h7ikpgsb
         Yzj9/9QR8pvv9s537mQBeUk8bodicRt2sYNtrKP02dXkQyCDQKSj99VRGbrzh5/zLrXe
         3DbujuLPciSi5vALJ+old//V6zoLm6pd0LhvBAARG1SXsh/2UP6qVVa/FfV3DuM5if+u
         lMLgaAYtih653stfzpF6JzV1TgtPEvIAiwFM7x+VFO7m6+ikg5S95jdc8NlSpoxf6NUC
         chD7vf96GrCNEtWT2dpp9TfC5k1TkiGvGH1SczyJzPL6/3uFcjCYC/RxAKuWF753UD7k
         NBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IK1q7pWvnzmd2/yzmMQOB6gFUgHkXgsyzwODpSKqHtU=;
        b=15An1tGG8nHWbgQ7lfNc8QLkFangfrf5YDaVcKBSZIPQNTJpbJxa1DdQzV2vSVOcbO
         fh8Ji5/HqmK7yMFs2MeudkwBT0eUgiprBaC/Ipzg3IKpQEC48MbD9m5GtGhAwwOR1S38
         voachqulCt9cj6gYIc3OwlRxsv9slparbv2iXH6LnUc2rniEK+YWoy+PXqdP3WyAEj5+
         rsQ/igFcd7l6NwGjhR1DuOEwyg6roMp4wpQsnXjvh0N3s3ON1yJTkfgv0SAFFL/ravUl
         Z2SByPfwCJvXSEO6RW+F0dcU0r8IacIWIiQdBlThXmbvdg+DnfZF1OkBKNG6LPeik1rx
         XpYQ==
X-Gm-Message-State: AJIora9wJdSdxEZ+C6/PPujawAdsPLp91iPchxdMcifaiD5H32SspsC1
        NV3zAm6bWrrd7io0QsjyNBjW5xoQDju9soyGUQI=
X-Google-Smtp-Source: AGRyM1tvrcPaXjb6qpRZmlm3mN1+HaZ3X5zFt5Vb6BDK08mCBJ8qF4vfcIrvo5gC3LEAhM4YrPgldTFVhwpUgFcS228=
X-Received: by 2002:a05:6902:1549:b0:66d:5f76:27ba with SMTP id
 r9-20020a056902154900b0066d5f7627bamr14092504ybu.385.1656670690515; Fri, 01
 Jul 2022 03:18:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220701012647.2007122-1-saravanak@google.com> <20220701012647.2007122-3-saravanak@google.com>
In-Reply-To: <20220701012647.2007122-3-saravanak@google.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 1 Jul 2022 12:17:33 +0200
Message-ID: <CAHp75Vdw8pZePnqR=mmJh4pv0bPMRJE=p7-cG3akskdxMHmoKw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] serial: Set probe_no_timeout for all DT based drivers
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
        david ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:LINUX FOR POWERPC PA SEMI PWRFICIENT" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/ASPEED MACHINE SUPPORT" 
        <linux-aspeed@lists.ozlabs.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-snps-arc@lists.infradead.org,
        linux-amlogic <linux-amlogic@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-actions@lists.infradead.org,
        linux-unisoc@lists.infradead.org,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sparc kernel list <sparclinux@vger.kernel.org>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
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

On Fri, Jul 1, 2022 at 3:28 AM Saravana Kannan <saravanak@google.com> wrote:
>
> With commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by
> default") the probing of TTY consoles could get delayed if they have
> optional suppliers that are listed in DT, but those suppliers don't
> probe by the time kernel boot finishes. The console devices will probe
> eventually after driver_probe_timeout expires.
>
> However, since consoles are often used for debugging kernel issues, it
> does not make sense to delay their probe. So, set the newly added
> probe_no_timeout flag for all serial drivers that at DT based. This way,
> fw_devlink will know not to delay the probing of the consoles past
> kernel boot.

Same question, do you think only serial drivers need that?

-- 
With Best Regards,
Andy Shevchenko
