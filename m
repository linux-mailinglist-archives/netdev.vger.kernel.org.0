Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367EC6ECB5E
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 13:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjDXLb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 07:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDXLbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 07:31:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD502D70;
        Mon, 24 Apr 2023 04:31:50 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id C099C5C018B;
        Mon, 24 Apr 2023 07:31:49 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 24 Apr 2023 07:31:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682335909; x=1682422309; bh=Y9
        FYoJaNOjxIXKXj5iVt3HG1MU0gziVJXHg42DuXBOg=; b=O1tJf0aYUL1Asq2G9I
        v/WenhP5rGZyZB1SAL0Lr08oQeAEEUQrAp0socR3vEd9UgGnvByhJ755hJxV1qKU
        E9ZSACMVc6ctw5IOj3YSxNtJjppCrcMnuo3EHDjmd3kHM8VJtKdkgvKL4DFoHOqz
        +W+8IuX2hg35wSKwedvXKJ3PURDaQkrWjJM/7PMwj2nQ3bK1GDbl6lv178HZ/NA8
        KDsO9MYDBoMlPNBh8aEl4RrLKv4OLsavscqSSR/heANCq8T/WVE0cVUSnj8QfSJQ
        4u/teN+GVPZosLly+e7aCJHZfWx6MH3m9aFx+6kQZQbTUHFFn+RPDQoPPYxBW1gQ
        IJSA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682335909; x=1682422309; bh=Y9FYoJaNOjxIX
        KXj5iVt3HG1MU0gziVJXHg42DuXBOg=; b=iBdH6uvO/L8/zyujyEmeuLQ7lvT2x
        GYZygrbZo05oxTN/Md/oDE0e8WW8qA02cbgVhsfFcZOI0ds8e+FbCtiiaOJvFiRx
        +0cW8fxBsOTCzFHhmKeMdRGumvrSujG5VcT8IFLwY3h8/nMbzymQnlGomWQOWzQx
        /oBTRzPHT38WBG1dSwXH+qEHrQrBjZbDngRgGtk3lDrZjamKW1iCCAmPUjNH4bVF
        47At9lDjEDsPYhnN2768xyf3oBtpO2z2m/rKqeUCbiN4YmtGLmGGX3q1bMmxrG9I
        36sN74EogbvFLVEbiiG9I3iKHbm4hY5BQztKKlqVi2e7UnWmYlN05agjA==
X-ME-Sender: <xms:o2hGZE7zjv519ykLdrbAQGTLb_LGqm8C9gu0iv5LW_l5ijia9biY7A>
    <xme:o2hGZF7IUwkhhPb4KXqxJ6jrGKB4g1CI7PypRKEHNaKZ-yKjsy2DgJ29sYcy-8ANi
    L7P0836qypU8DsWz5I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedutddggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:o2hGZDccuXBCL3RAIdybA7rao9itrSh_uY8pqy72IR4RYUm3PNP66w>
    <xmx:o2hGZJLZwUfDzeDL8noN8lkkCw-LNtlf4Vp39AIRXYTSMF4PksJThw>
    <xmx:o2hGZIKT3iHKm9UvV7uZTvPOYuO2PbPXKewmqiqnd7-usVCISuMq0A>
    <xmx:pWhGZAVObyMQbbUUBpdedORBxIIpPoWc5gLC07zOHsQjH_IqgL-nMw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2684DB60086; Mon, 24 Apr 2023 07:31:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-372-g43825cb665-fm-20230411.003-g43825cb6
Mime-Version: 1.0
Message-Id: <8101c53e-e682-4dc3-95cc-a332b1822b8b@app.fastmail.com>
In-Reply-To: <20230424123522.18302-1-nikita.shubin@maquefel.me>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
Date:   Mon, 24 Apr 2023 13:31:25 +0200
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Nikita Shubin" <nikita.shubin@maquefel.me>
Cc:     "Arnd Bergmann" <arnd@kernel.org>,
        "Linus Walleij" <linusw@kernel.org>,
        "Alexander Sverdlin" <alexander.sverdlin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Bartosz Golaszewski" <brgl@bgdev.pl>,
        "Brian Norris" <briannorris@chromium.org>,
        "Chuanhong Guo" <gch981213@gmail.com>,
        "Conor.Dooley" <conor.dooley@microchip.com>,
        "Damien Le Moal" <dlemoal@kernel.org>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Emil Renner Berthing" <kernel@esmil.dk>,
        "Eric Dumazet" <edumazet@google.com>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "Hartley Sweeten" <hsweeten@visionengravers.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "Hitomi Hasegawa" <hasegawa-hitomi@fujitsu.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Jaroslav Kysela" <perex@perex.cz>,
        "Jean Delvare" <jdelvare@suse.de>, "Joel Stanley" <joel@jms.id.au>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        "Damien Le Moal" <damien.lemoal@opensource.wdc.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        "Liang Yang" <liang.yang@amlogic.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        "Lukasz Majewski" <lukma@denx.de>, "Lv Ruyi" <lv.ruyi@zte.com.cn>,
        "Mark Brown" <broonie@kernel.org>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        "Michael Turquette" <mturquette@baylibre.com>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Nathan Chancellor" <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        "Nicolas Saenz Julienne" <nsaenz@kernel.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Qin Jian" <qinjian@cqplus1.com>,
        "Richard Weinberger" <richard@nod.at>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Robert Jarzmik" <robert.jarzmik@free.fr>,
        "Russell King" <linux@armlinux.org.uk>,
        "Sebastian Reichel" <sre@kernel.org>,
        "Sergey Shtylyov" <s.shtylyov@omp.ru>,
        "Stephen Boyd" <sboyd@kernel.org>,
        "Sumanth Korikkar" <sumanthk@linux.ibm.com>,
        "Sven Peter" <sven@svenpeter.dev>, "Takashi Iwai" <tiwai@suse.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Vignesh Raghavendra" <vigneshr@ti.com>,
        "Vinod Koul" <vkoul@kernel.org>,
        "Walker Chen" <walker.chen@starfivetech.com>,
        "Wim Van Sebroeck" <wim@linux-watchdog.org>,
        "Yinbo Zhu" <zhuyinbo@loongson.cn>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        soc@kernel.org
Subject: Re: [PATCH 00/43] ep93xx device tree conversion
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023, at 14:34, Nikita Shubin wrote:
> This series aims to convert ep93xx from platform to full device tree support.
>
> Tested on ts7250 64 RAM/128 MiB Nand flash, edb9302.
>
> Thank you Linus and Arnd for your support, review and comments, sorry 
> if i missed something -
> these series are quite big for me.
>
> Big thanks to Alexander Sverdlin for his testing, support, review, 
> fixes and patches.

Thanks a lot for your continued work. I can't merge any of this at
the moment since the upstream merge window just opened, but I'm
happy to take this all through the soc tree for 6.5, provided we
get the sufficient Acks from the subsystem maintainers. Merging
it through each individual tree would take a lot longer, so I
hope we can avoid that.

      Arnd
