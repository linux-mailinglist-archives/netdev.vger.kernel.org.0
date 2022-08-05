Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA9D58AFA2
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 20:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbiHESPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 14:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiHESPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 14:15:31 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206771A3B0;
        Fri,  5 Aug 2022 11:15:31 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id e23so2638380qts.1;
        Fri, 05 Aug 2022 11:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=hIkauzgt6OmvCPGlxkDP1V/+2ftR+tSiv6OMUdZBzKo=;
        b=MRHJitL58YogjWYs6VlFCFKBYkNKnV+HkzbmP4HsstwsDGmDEeAdmt1mXb/OSftO/T
         VxRRqyON8tIGMg1ZwZgpACMa7R1B6Z1BzSULIbzJr6FP1e5PV6/asDM4uQQrwKqVpk9D
         jeUZIchOcgL/bIag6uieD2ik0NpvskV7Q3BY5V5sGwvYFt9SQPAvkUViQ7qAGSuAyqX0
         9wwF2MUEUpxwO0H9/KYJrxsBxSxnEtcqwBwU8njs0rSTe8u0/1HaNSIPbwoUUOaJGlkw
         E2p0fJ0QMTEQ6mhwG8mLitTkHE91vmoDCspZ2RKSW+3sjwnxgpTDOE8MG7aZX6hKcxLd
         IgIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=hIkauzgt6OmvCPGlxkDP1V/+2ftR+tSiv6OMUdZBzKo=;
        b=NdCfN409XEaL1v+f1wpSQ2jyb1trQ6hpaSfzwhifEDTdR5hH7Pee50FQO/a0+lYm5t
         f1Nr3bhdHKY1oy7SrAjlKrMizwJYbjYHVIUqG+976p1XJzuVLU/I2YMpX50ft8nhvPlV
         S6w8fcxhKPdMpsPm/tZkXlfr6qkAqQKBYahs8GsSAl9k4tCF1t9DbUCYcM3H341hCPCv
         kBPwQFATiyzi/Gq8RbAns+83ijf1AAAvMoXV7JRbkmliZbNxc/arXt/NRiCJ7TZTq1NV
         uXBoV+7yIj7swckeItAeKKDTZ4ogdKVU3Ezw6dLn2mMbO/vWoOzNTi7Il4VvjQvjAI4k
         issw==
X-Gm-Message-State: ACgBeo39l0e9YSh0K/wdqzQvnjOubh0f81Yj7d20Nmz8ydu0lvlAoASy
        jJqmEROvUs13u27bgjDZoqjhW8Uo33eqlP8DgK0=
X-Google-Smtp-Source: AA6agR4W2hc1NBaVidAmORnlyQuBUgXNo1TsYqx+zcEm7U/mOfADrMnfYr7WuGQvyoi15L+WSZOFRo0DDl7C1lMjXZk=
X-Received: by 2002:ac8:7f88:0:b0:342:e9dc:ee77 with SMTP id
 z8-20020ac87f88000000b00342e9dcee77mr950460qtj.384.1659723330130; Fri, 05 Aug
 2022 11:15:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
 <20220803054728.1541104-10-colin.foster@in-advantage.com> <Yu1W8DMaP8xlyyr5@euler>
 <CAHp75VcVD4XxydmYkgybjpCKsh=0KS5+GnDGK5CJX-qZwJ06Cg@mail.gmail.com> <Yu1cSLlkXAr/t5ho@euler>
In-Reply-To: <Yu1cSLlkXAr/t5ho@euler>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 5 Aug 2022 20:14:52 +0200
Message-ID: <CAHp75Vftx=uF4Y-PCutjVSFYEdT3PrDVu=Vc3AX+hJaKE80LoA@mail.gmail.com>
Subject: Re: [PATCH v15 mfd 9/9] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
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

On Fri, Aug 5, 2022 at 8:07 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
> On Fri, Aug 05, 2022 at 07:58:06PM +0200, Andy Shevchenko wrote:
> > On Fri, Aug 5, 2022 at 7:44 PM Colin Foster
> > <colin.foster@in-advantage.com> wrote:
> > > On Tue, Aug 02, 2022 at 10:47:28PM -0700, Colin Foster wrote:

...

> > > > +int ocelot_chip_reset(struct device *dev)
> > >
> > > #include <linux/device.h>
> >
> > Nope,
> >
> > struct device;

...

> > > > +static int ocelot_spi_initialize(struct device *dev)
> > >
> > > #include <linux/device.h>
> >
> > Ditto.
>
> ocelot-spi.c uses devm_kzalloc, so that should still be included.
>
> ocelot-core.c uses dev_get_drvdata.
>
> So I think I still want the includes... but for different reasons.

Yes in this case.

-- 
With Best Regards,
Andy Shevchenko
