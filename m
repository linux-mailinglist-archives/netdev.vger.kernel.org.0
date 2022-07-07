Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B8C56A730
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiGGPnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiGGPnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:43:09 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEE82DABE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 08:43:08 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u12so33092539eja.8
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 08:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eRyQ6l+HRyXdzOqyBsn/dpYwUzVFGa0ZXhBusdg+nQo=;
        b=h+1J5PxQdDHpVcPcs2s+yMc1NuhF3fnxWBG+wgM3rOaWtnpf+p85x806rNKDUGzv44
         LTbrkDfifvjl5ET2lDlezGuLWQpoYLQleLNRJZE08q5gVyUubwxf9WUaMkQpGc1ITEzW
         Fv/OCqNYE/EBXUstj2Jtr7ceNxc7Susfdfu9RBg6p9QfP9iUA386bkSP3pjthu2JaobM
         HoeA6HPZnwBRkMjaymKChC/zMY/r6aGh/JQbNykqW3p4wbA0v/+wBEhX3cA7/dI622J8
         Ia1Bvykj9BrfJiwWNPt0UYLOR57jz0i3/R03Q9v7heVgtH+KF/M2jrTlE3RkSJqSiSg5
         ptyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eRyQ6l+HRyXdzOqyBsn/dpYwUzVFGa0ZXhBusdg+nQo=;
        b=7SxN1c2W/qUEgEqHVxiEsMneAdzdZmer+z+VD+TI+CLtUjvC9/77eHjm3YskKdH6SM
         Fw8Y9VCvJY9xDzRVwtliFGxYL2msXnL4L1rCDi6X7bE7sMXJHftYblP6+VyB2Ke9FJZs
         KZu48fsbfVbeW6UUNYeL5twkjiKDwJCu0XB6cVN3dHLB89qaJZX/kXGygU69O7RXciKQ
         WeOMDURCTUiji61rLq3b8dNurYrQR8DeIPZlW515eI5B9ocRhaoG0G3gWVyGPFIlCRmB
         NC+pkmtKFRbpds5Go8/YRt7lgfWb2BH3P9a6170GQHqsvUbbF8d7uYHzYt+yt39XEgrt
         kXbQ==
X-Gm-Message-State: AJIora+Mqf09rhrBqQi88PSyqR91Z8G07rT1GJ5veoA02bSqSns7gAIa
        Qvmaga9Ao/VmgbGDccMBHTg=
X-Google-Smtp-Source: AGRyM1sEZtfA3ti3uPrw9IQHDMSqCngj2V6a8d3LI1tYlReReGFPyHs4RoO1Aa2GY+mRk60+Ya5F2g==
X-Received: by 2002:a17:907:7209:b0:72a:fcaf:2250 with SMTP id dr9-20020a170907720900b0072afcaf2250mr7983182ejc.468.1657208587175;
        Thu, 07 Jul 2022 08:43:07 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7c04e000000b00431962fe5d4sm28681409edo.77.2022.07.07.08.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 08:43:06 -0700 (PDT)
Date:   Thu, 7 Jul 2022 18:43:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220707154303.236xaeape7isracw@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <Ysa85mJIUfo5m4dJ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ysa85mJIUfo5m4dJ@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 12:00:54PM +0100, Russell King (Oracle) wrote:
> More importantly, we need your input on Ocelot, which you are listed as
> a maintainer for, and Ocelot is the only DSA driver that does stuff
> differently (due to the rate adapting PCS). It doesn't set
> mac_capabilities, and therefore phylink_set_max_fixed_link() will not
> work here.
> 
> Has Ocelot ever made use of this DSA feature where, when nothing is
> specified for a CPU or DSA port, we use an effective fixed-link setup
> with an interface mode that gives the highest speed? Or does this not
> apply to this DSA driver?
> 
> Thanks.

I'm fine with both the ocelot and sja1105 drivers.

The ocelot driver has 3 users:

- felix_vsc9959 (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi) on NXP
  LS1028A, where the CPU ports have and have always had a fixed-link
  node in the SoC dtsi. LS1028A based boards should include the SoC
  dtsi. If other board DT writers don't do that or if they delete the
  fixed-link node from the CPU ports, that's not my problem and I don't
  really want to help them.

- seville_vsc9953 (arch/powerpc/boot/dts/fsl/t1040si-post.dtsi) on NXP
  T1040. Same thing, embedded switch, not my fault if the fixed-link
  disappears from the SoC dtsi.

- Colin Foster's SPI-controlled VSC7512 (still downstream). He has an
  Ethernet cable connecting the CPU port to a Beaglebone Black, so he
  has a phy-handle on the CPU port, so definitely not nothing. I believe
  his work hasn't made it to production in any case, so enforcing
  validation now shouldn't bother him too much if at all.

As for sja1105, there is DT validation that checks for the presence of
all required properties in sja1105_parse_ports_node().

There is some DT validation in felix_parse_ports_node() too, but it
doesn't check that all specifiers that phylink might use are there.
I'd really like to add some validation before I gain any involuntary
users, but all open-coded constructs I can come up with are clumsy.
What would you suggest, if I explicitly don't want to rely on
context-specific phylink interpretation of empty OF nodes, and rather
error out?
