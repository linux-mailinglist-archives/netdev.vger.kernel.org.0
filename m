Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA4586F6F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 19:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiHARR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 13:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiHARR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 13:17:27 -0400
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69441D51;
        Mon,  1 Aug 2022 10:17:25 -0700 (PDT)
Received: by mail-io1-f45.google.com with SMTP id o2so8877624iof.8;
        Mon, 01 Aug 2022 10:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Qn1gwgOxsZjRA42gjs8EDCtLuKRUPulmbYF7v2HsmLA=;
        b=lkdwWThdiA0ChQ+/Jt1pk2EcUD/ImOSMe5+7DBrZUtIhZq0eQ+gpOr1XrHMqDiTSPf
         BKrl1Us4mqRK58cHztNotXKY3daKRIMtPSAuz4Y4+ftNsnfrl5ESuQLq0ikw8+XXkP8P
         /pw2vBz5118x/az7Y8ioR035mudLZK7vQgMWgEcqL6uuOUXBCjDQ40eVN0FGboeqHahs
         BBi1h9bnmNQUnQKUAIN7Hf5016I9Xp7Fde2GDi2I6dyD1fNRORlpfdScoej1GUemC08q
         mUaziK4D1iZm1a7QaEPouq7/oRzzDxqM3KLMWwpXvBAQK7MhruZ8EFCkx71qYJhRZkcH
         Wq+Q==
X-Gm-Message-State: AJIora+k/BElig7GUJEJb+Jj++8T6RNiywgnhRIqEZ+6FkbL1olGYzGw
        mzIs4NuF8kcgYuxXjDiW2Q==
X-Google-Smtp-Source: AGRyM1vyOEcW/a2+WhA545Tksq7e+fyPpWNPmmm7mkeYqSlqqk2DDxcsO2SWMm5rlwuNJcBi8IlZlg==
X-Received: by 2002:a05:6602:2d4f:b0:67b:f7c9:a3e with SMTP id d15-20020a0566022d4f00b0067bf7c90a3emr5730346iow.77.1659374245167;
        Mon, 01 Aug 2022 10:17:25 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id a5-20020a027345000000b003316f4b9b26sm5504847jae.131.2022.08.01.10.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 10:17:24 -0700 (PDT)
Received: (nullmailer pid 1197811 invoked by uid 1000);
        Mon, 01 Aug 2022 17:17:20 -0000
Date:   Mon, 1 Aug 2022 11:17:20 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: make phylink bindings
 required for CPU/DSA ports
Message-ID: <20220801171720.GA1190285-robh@kernel.org>
References: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
 <20220801092256.3e05c12e@kernel.org>
 <20220801162943.guvqrjcb34gsnrdk@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801162943.guvqrjcb34gsnrdk@skbuf>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 04:29:43PM +0000, Vladimir Oltean wrote:
> On Mon, Aug 01, 2022 at 09:22:56AM -0700, Jakub Kicinski wrote:
> > If I'm reading
> > 
> > https://lore.kernel.org/r/CAL_JsqKZ6cEny_xD8LUMQUR6AQ0q7JKZMmdP-9MUZxzzNxZ3JQ@mail.gmail.com/
> > 
> > correctly - the warnings are expected but there needs to be a change 
> > to properties, so CR? (FWIW I'd lean towards allowing it still, even
> > tho net-next got closed. Assuming v2 can get posted and acked today.)
> 
> I can post the v2 of this patch today with Rob's indications and the
> correct indentation spotted by yamllint. I'm not going to fix the newly
> introduced warnings in drivers' examples - I don't know how, for one thing,
> that's hardware specific knowledge.

Sorry, but we can't have a bunch of warnings added. The examples must be 
warning free.

> 
> Rob, given that you've said DSA shouldn't validate the DT and then
> reconsidered, I'd appreciate if you could leave some acks on patches 1
> and 4 of that series, which deal with the kernel side of things, rather
> than the dt-schema.

