Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF91458C3F7
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbiHHHbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiHHHbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:31:19 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AE35599;
        Mon,  8 Aug 2022 00:31:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k26so15004048ejx.5;
        Mon, 08 Aug 2022 00:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tgetifgbBTUwaHUUNxKhDY+i5+I0QQCMcg7l3wjWxzY=;
        b=UTJmMy8wlZ8ar7ug6ycvZxzXHMuzQ3ccBZgVA5yaRBGGjOgthZyyYPMxB08CeQ87l6
         wGCPkpjDbw4thwhjnyGr/n57UtRmMmqFDk98cmj76C8hnM34OpDgmqHZjJK1tjkTvt9M
         H3L1Y76TJIGmj1mhsU1XE8xl6ORANOc1Jru+5l8+/9L1vYuMJLy09T8maKhxxv+ec8go
         dW1Pf5bm2VMEsLEMYQca4zQOIwbuznRdw5txE5QUrfL3WXpgvwNwPnvI8riPbI4LgP3Z
         h7rxYYR6Ba0b9L6n/uifAKXLO0vxiciVSxn3u81oXYHPoLMCYhJmJnxvEzPpv5dOST3J
         odvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tgetifgbBTUwaHUUNxKhDY+i5+I0QQCMcg7l3wjWxzY=;
        b=Rhd367xNsletjcJbg4wnAfAa3qss/snZbRoFSlK2sNmg/M2CsfQVMsGTnGQeKFxdRR
         OAOPlP/691Gwu7HymwH196Yai1qas5x5cdjj6+Hkgqs3d10h8eq7KXD4VAxWxt/zY6lm
         kKTJ8jNhC5sseBWe8mpsqPh9nNY7vopcyu4rEWI9lBzv5uqfz6hV7RohK6XcTwU4Hfis
         Y4nSSkXBrle8uo2aCwqppckNhKj1L9w1Tl19PefvcXmXN0oozjpS6wqWItYMEEUKUd1g
         ryBuNNW8UafV/hMHSUK5LHE7pA+02vLvvaRS/EStQ0+GE5xitbf+2yuYLdTyKXMB8LTy
         aUHQ==
X-Gm-Message-State: ACgBeo2xX+DKGy/+kBFBSm6Vl6feXPcH78OiwYrmqYljBKsrmUn3N8ub
        HKVxm/LzKTMMo8FDCFH+HVY=
X-Google-Smtp-Source: AA6agR74/72PZxy2KSi8pJBrl2fnYKZanlnWDpQ15tSBhcIHChFc/Ji9ZCqdzJ1ioYtI3EUEdZKWng==
X-Received: by 2002:a17:907:a42c:b0:730:9e5c:b457 with SMTP id sg44-20020a170907a42c00b007309e5cb457mr13380283ejc.666.1659943876709;
        Mon, 08 Aug 2022 00:31:16 -0700 (PDT)
Received: from skbuf ([188.27.185.133])
        by smtp.gmail.com with ESMTPSA id a15-20020a056402168f00b0043aba618bf6sm4178218edv.80.2022.08.08.00.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 00:31:14 -0700 (PDT)
Date:   Mon, 8 Aug 2022 10:31:10 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
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
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [RFC PATCH v3 net-next 10/10] net: dsa: make phylink-related OF
 properties mandatory on DSA and CPU ports
Message-ID: <20220808073110.wv4nm3fllwcxl5nq@skbuf>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-11-vladimir.oltean@nxp.com>
 <62eeca98.170a0220.601cd.70ac@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62eeca98.170a0220.601cd.70ac@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 06, 2022 at 09:58:16PM +0200, Christian Marangi wrote:
> > qca8k
> > ~~~~~
> > 
> >     compatible strings:
> >     - qca,qca8327
> >     - qca,qca8328
> >     - qca,qca8334
> >     - qca,qca8337
> > 
> >     5 occurrences in mainline device trees, none of the descriptions are
> >     problematic.
> > 
> >     Verdict: opt into validation.
> 
> I notice some have strict validation and other simple validation. I
> didn't understand from the commit description where strict is used
> instead of simple one.

There is no difference between "opt into validation" and "opt into
strict validation" in the verdicts for each driver. It all means the
same thing, which is that we won't apply DSA's workaround to skip
phylink registration for them (and implicitly fail the probing, if they
have lacking device trees, but the assumption is that they don't).
I suppose I could improve the wording.

> I'm asking this for qca8k as from what we notice with device that use
> qca8k the master ports always needs to have info in dt as we reset the
> switch and always need to correctly setup the port.

How sure are you about this? I am noticing the following commits:
79a4ed4f0f93 ("net: dsa: qca8k: Force CPU port to its highest bandwidth")
9bb2289f90e6 ("net: dsa: qca8k: Allow overwriting CPU port setting")

which suggests at at least at some point, the qca8k driver didn't rely
on device tree information for the CPU port. Now if that information was
available in the device tree in the first place, I don't know.
The phy-mode seems to have been; I'm looking at the initial commit
6b93fb46480a ("net-next: dsa: add new driver for qca8xxx family") and
there is an of_get_phy_mode() with a hard error on missing property for
the CPU port.
