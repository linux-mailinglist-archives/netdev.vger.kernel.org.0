Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4536EE2F8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjDYN1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjDYN1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:27:49 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00329C173;
        Tue, 25 Apr 2023 06:27:47 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id ECAAA32008FA;
        Tue, 25 Apr 2023 09:27:42 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 25 Apr 2023 09:27:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682429262; x=1682515662; bh=sh
        lQTGWa7vUbJrf98fLKqQIz8VMZW6pYwyh6rr26DkQ=; b=LLq6zsCSRbDjBVqeoa
        QdSyGzdFeRzi+y8dRC7yvod5SVHeKyFTIeuyfiTgHRDX9Awr81yDjU9y4QtxKrfo
        cU1BJzuMeChVwfos+ZupiLK5693eur3Az9zQP0C6tP5leOBtsxoSVBo5BxcsGO7K
        YnDEO3vBsGpNOdsMCfFNRkVF1sblVBXFoUUDMH3el3HzkP7EtTn6FoyExVTN+aTO
        gqS5bRJpJLk/Y1ln6yHL7bGq9WDFROd44pG/rbGw6QlYGqAnZ/JWZp/0ZoV7Bn0L
        vq7IJdZ4IHu4w03AFjEKqpLuEgPWaeUW+I/AyBGdPEay4Ph5wh032/s2qj/I9Wro
        /8xQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682429262; x=1682515662; bh=shlQTGWa7vUbJ
        rf98fLKqQIz8VMZW6pYwyh6rr26DkQ=; b=Av/a0k3pjb1ufd4JifUVwkqmaE0xY
        9CkoNy8ApgC/U0IKdRsJdeBSuhyHHZrHbLb2V34XnstlRhf8x06eo7Woi2Pmpwix
        1FUDyWuVR25j7bcLCv0SZIqeCbOOzHJd6HjbetiNBz6VUkZQgqJbWjJlxJ8A/BpO
        A212C1UV+wtke3Pc75MEe/ogcXY+s5a0ytb+7OOOZZFU2L6ynRwsUVp4XQ/s7+RJ
        Fwj/Kr4OJOlir/HJ5H/UNNH9HZpNxgAqrg5KWHIyAHdoqAHF43/uajOj57iT4Jzl
        X+HHwFW4rZzPdkC8YzfFnXBiw01B+vpVScnizIK5eGDgzxuBRbcgXd1yw==
X-ME-Sender: <xms:S9VHZJl5ArBpbY5tqUCy32a43H-Jc6lVaBY-LZKcl_pJhl7n-s0_dQ>
    <xme:S9VHZE1YTzlO84yHG36gWwGILapdSpSLopmyoWHKeOt_YpUc5zk_N5KDZkZzbByYb
    B4T9orgHH0-6nfJ018>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:S9VHZPoeetQZs_3oaiKa85eO_ubUpz9vMKuiDxO2Xe7ZONIHAb3MkQ>
    <xmx:S9VHZJk4L8-_hWSmPZAyBlv3pTZdFCFlZLIRfX2VBqLar6yCxaJTpA>
    <xmx:S9VHZH1TRLt9JCYwgLou_9qePysK818dBIHcDHDLr1LJlHSsbq0KeA>
    <xmx:TtVHZJsalndLD945CG4tBnqVxTIfpWnAMZDxIRKJWPLVcF1t9S-MXg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 91FC6B60086; Tue, 25 Apr 2023 09:27:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-374-g72c94f7a42-fm-20230417.001-g72c94f7a
Mime-Version: 1.0
Message-Id: <c3db2294-4fef-46be-a62a-11fc38884918@app.fastmail.com>
In-Reply-To: <0210316b-9e21-347c-ed15-ce8200aeeb94@linaro.org>
References: <20230424123522.18302-1-nikita.shubin@maquefel.me>
 <8101c53e-e682-4dc3-95cc-a332b1822b8b@app.fastmail.com>
 <20230424152933.48b2ede1@kernel.org>
 <0210316b-9e21-347c-ed15-ce8200aeeb94@linaro.org>
Date:   Tue, 25 Apr 2023 14:27:26 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Jakub Kicinski" <kuba@kernel.org>
Cc:     "Nikita Shubin" <nikita.shubin@maquefel.me>,
        "Arnd Bergmann" <arnd@kernel.org>,
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023, at 10:20, Krzysztof Kozlowski wrote:
> On 25/04/2023 00:29, Jakub Kicinski wrote:
>> On Mon, 24 Apr 2023 13:31:25 +0200 Arnd Bergmann wrote:
>>> Thanks a lot for your continued work. I can't merge any of this at
>>> the moment since the upstream merge window just opened, but I'm
>>> happy to take this all through the soc tree for 6.5, provided we
>>> get the sufficient Acks from the subsystem maintainers. Merging
>>> it through each individual tree would take a lot longer, so I
>>> hope we can avoid that.
>> 
>> Is there a dependency between the patches?
>
> I didn't get entire patchset and cover letter does not mention
> dependencies, but usually there shouldn't be such. Maybe for the next
> versions this should be split per subsystem?

Clearly the last patch that removes the board files depends on
all the previous patches, but I assume that the other ones
are all independent.

We don't do complete conversions from boardfiles to DT that often
any more, but in the past we tended to do this through a cross-
subsystem branch in the soc tree, which helps do it more quickly
and is less work for Nikita. In this case, I would make it a
separate top-level branch in the soc tree.

If anyone strongly feels that the patches should go through
the subsystem trees here, we'll take the longer path and
do the changes separately, with the boardfile removal
coming a release later.

     Arnd
