Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7D858283B
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiG0OIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiG0OIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:08:02 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D77F3D5A1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:08:00 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s9so2311187edd.8
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 07:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ckwq9+RZ25t6TxI3G7wvQ/YAFBxZcLYCgHMh/h9lYXk=;
        b=VUv9YXMMbV60UXuXTAV/O0FSo9WU79aQzTxLele+AgncteS2/p+3sWQguAroOJHa5x
         icCTysrxmQkJ5gTMgoKTadmp0O0dfnDu09BJ2hEPaDjpYuNjdLYK4KsfgkP4kPYMTWlj
         4tKwB2fLlnUdGYDwKzGmEyeuAYEvgkKA5J1Xjmr+TUfAT82gbk9R/edyBfQVDXQ5WXxD
         bNA2i12HzNS9RAlII7PQUoFReIoMdfieIagDs5KL0rqHqHvEOb0/x/2/eGUv6qLjP3Xv
         2jl/DDe4adZK27lbHRW1SD9EqcP/HCEO6Ue2pOAzR6XeaTEigxeIXwFt4cAS3NE/p/Xa
         F2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ckwq9+RZ25t6TxI3G7wvQ/YAFBxZcLYCgHMh/h9lYXk=;
        b=dqWQLWjuBL6aY1Ettul91mhdHfRtP3hABeVQH7nnVUkDQhBhF/3PXtzTDDZrXTsjif
         fVIzQvb0NYyzSskjB+SM3/O6aiY4Tpx1LX9JdE7S8qlSSB4aVk8NFZZmUJHJ9Vg/1Iz4
         SQWmISPPETWIaSOD+VZefZfk75jLBaDI/lON0jwOenc7qLZTqF/EtGUnNa8qavBrwHH+
         OTtjqLi//6EEGmiF0Gw/Rgm1VK2GjCv2QFy4UnbvO+u05iFFfCOtZiXn7hcAI8IPO5KJ
         PeAv1X7MfWLHFodgQA+jTst35mmFVhFiiED9vX0c+IP1dPuzZk+LFJxPBg59SYxYJyzK
         G+jg==
X-Gm-Message-State: AJIora/yFf9xGvwp9Ok6MLavNb9n6ZEHMrw85581Ddgw9oFuQKxibqPj
        VSM+QoCsYNrz1nPifJOx3t2kPiCPbcy2jA==
X-Google-Smtp-Source: AGRyM1v71UdMOlAIbWLzWiX9NjJRs4epgXVlDfSiOhRCmU37JH6mwHjmJ16BGzwhEgbYSDNcZZ6AeA==
X-Received: by 2002:aa7:cd0a:0:b0:43b:c49d:22b6 with SMTP id b10-20020aa7cd0a000000b0043bc49d22b6mr22691414edw.155.1658930879017;
        Wed, 27 Jul 2022 07:07:59 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id q1-20020a1709060e4100b0072aac7446easm7653198eji.47.2022.07.27.07.07.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:07:58 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:07:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8366rb: Configure ports
 properly
Message-ID: <20220727140756.ds6yl6lpw57gar37@skbuf>
References: <20220725202957.2460420-1-linus.walleij@linaro.org>
 <20220726110228.eook6krfpnb7gtwj@skbuf>
 <CACRpkdbCUvE_AusQ5xN=8qLJRXKMTUDNBGTgL-n2u9nsf8xsjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbCUvE_AusQ5xN=8qLJRXKMTUDNBGTgL-n2u9nsf8xsjg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Tue, Jul 26, 2022 at 04:20:18PM +0200, Linus Walleij wrote:
> > According to your phylink_get_caps() implementation, I see that all
> > ports are internal, so presumably the CPU ports too (and the user ports
> > are connected to internal PHYs).
> 
> Correct, if by internal you mean there is no external, discrete PHY
> component. They all route out to the physical sockets, maybe with
> some small analog filter inbetween.

Yes, I mean that if there are RJ-45 ports, they are all driven by PHYs
which are internal to the switch chip, and if there is no internal PHY,
those ports are also internal to the chip, like in the case of the CPU
port.

> > Is it just to act upon the phylink parameters rather than assuming the
> > CPU port is at gigabit? Can you actually set the CPU port at lower rates?
> 
> I think you can, actually. The Realtek vendor mess does support it.
> 
> Hm I should test to gear it down to 100Mbit and 10Mbit and see
> what happens.

So the change wasn't intended for the CPU port, this is good to know.

> > As for the internal PHY ports, do they need their link speed to be
> > forced at 10/100, or did those previously work at those lower speeds,
> > just left unforced?
> 
> They were left in "power-on"-state. Which I *guess* is
> autonegotiate. But haven't really tested.
> 
> It leaves me a bit uneasy since these registers are never explicit
> set up to autonegotiate. Maybe I should do a separate patch
> to just set them explicitly in autonegotiation mode?

I am confused as to what you are describing when you are using the
"autonegotiation" word. "Port" is too generic, every user port will have
a MAC and a PHY. The PHY is what deals with autonegotiation; also, the
PHY is what the DSA driver does *not* control (it uses either a dedicated
or a generic driver from drivers/net/phy).

Between the internal MAC and the internal PHY, what's going on isn't
called autonegotiation, but doesn't have a specific name either, as far
as I know. Rather, because the 2 components are part of the same die,
the hardware designers may have added logic that automatically adapts
the speed in the MAC according to the speed that the PHY negotiated for
(or was forced at).

Your change (or at least the way in which I understand it) essentially
always forces the internal MAC to the same speed as the PHY. This is not
wrong per se, but I'm not clear if it's necessary either, considering
that there might be hardware logic to do this automatically.

> I have a small 10MBit router, I will try to connect it and see what
> happens, if anything happens and can be detected.

You don't need a dedicated 10BASE-T device to test this, you can run
"ethtool -s eth0 advertise 0x2" on any gigabit-capable device, and this
will limit the advertisement in its PHY to just 10BASE-T.
