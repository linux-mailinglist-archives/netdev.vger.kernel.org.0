Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66A7B5814FD
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbiGZOUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 10:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiGZOUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 10:20:32 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCA515FFC
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:20:31 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id mf4so26505118ejc.3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 07:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ty4WZ0hiTfX9j0JdigQY7s+tCOEyHhDi3t7R7BVuqL4=;
        b=PSARzHgTxGyGCI2C8glxXNMo7W66tZ5mT2Uy9zOvmGtyIilB7TukTZUN2RszeMxxZe
         vQCqixSkeHWrWiawNSfzjxlOTte4L07gyT/m4PrjuDlJyK1Z3QW7KQ8HLlGs2Ti/Rff5
         huFb4f+xtk8HFWXJtmwI98Sq+L6UOMu7e8hKIQR75I9wKoVKrKRxVb+q9S2WtDMtaL7d
         OdBS3Ql8zbaGgbqugw7TZVBYenb3GJZXqjyc4TYM5LPSrGN5bpXl7dwJmGfa+cd7RkRe
         WlJR+8wdSTo6XQwHSCcAHhYRs/N2dO34WNZUwdDYU7vf5YAk7bs9MruT6jv506m30PvX
         759Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ty4WZ0hiTfX9j0JdigQY7s+tCOEyHhDi3t7R7BVuqL4=;
        b=J9DreBawVIJx+j2UZsKnQ89kTcBp7/7St0Iftsc4q8coJAnSqR/9SOn+5yg11FaDak
         VhDNsVWEJSniVo6ySbB3Nuk/Tr29/pN7teM/QY1lpjtLG1jPIHh/fcQI8moNHgSnswHW
         mOkQkHwoz5ruETsOx0Wtuso9gSw2h+83vts/RZ4lWG3U6uvyft6MRA6xcuR5UMxbTIxz
         wIgXQ7fcnWCcol/r5vd84clnXBFc71TL5foY/sG0VvlGdqZNOpGNbHCANM36/aElQZDz
         znlq9P4T/mnC3C/jxg8JgB5X5oJbWxdwAvPGgZ1epXmgO4EvVlqjlB0P9Y+JaA9Ezt0v
         sBwg==
X-Gm-Message-State: AJIora8hbx1AeSDC0/AoSvWMNpOMx8u6Da+COlqr3QlqOd2ndYwe5GjF
        o2g3uAdT3R1fqOe5r3Q014+7IsfZoMjtyM65BxbJjQ==
X-Google-Smtp-Source: AGRyM1srFw1IVkp6YPgGpyvXP0iUbV4es2VsK2RbRJwDfj4fPhxhsqlxYGI96Vrn/mC3tvWQHxX+XmW9WSEKdy7gD+U=
X-Received: by 2002:a17:907:a053:b0:72b:3051:b79b with SMTP id
 gz19-20020a170907a05300b0072b3051b79bmr13768319ejc.690.1658845229643; Tue, 26
 Jul 2022 07:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220725202957.2460420-1-linus.walleij@linaro.org> <20220726110228.eook6krfpnb7gtwj@skbuf>
In-Reply-To: <20220726110228.eook6krfpnb7gtwj@skbuf>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 26 Jul 2022 16:20:18 +0200
Message-ID: <CACRpkdbCUvE_AusQ5xN=8qLJRXKMTUDNBGTgL-n2u9nsf8xsjg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8366rb: Configure ports properly
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 26, 2022 at 1:02 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Jul 25, 2022 at 10:29:57PM +0200, Linus Walleij wrote:

> > Instead of just hammering the CPU port up at 1GBit at
> > .phylink_mac_link_up calls for that specific port, support
> > configuring any port: this works like a charm.
>
> Could you clarify what is intended to be functionally improved with this
> change, exactly?

I can try, but as usual I am probably confused :)

> According to your phylink_get_caps() implementation, I see that all
> ports are internal, so presumably the CPU ports too (and the user ports
> are connected to internal PHYs).

Correct, if by internal you mean there is no external, discrete PHY
component. They all route out to the physical sockets, maybe with
some small analog filter inbetween.

> Is it just to act upon the phylink parameters rather than assuming the
> CPU port is at gigabit? Can you actually set the CPU port at lower rates?

I think you can, actually. The Realtek vendor mess does support it.

Hm I should test to gear it down to 100Mbit and 10Mbit and see
what happens.

> As for the internal PHY ports, do they need their link speed to be
> forced at 10/100, or did those previously work at those lower speeds,
> just left unforced?

They were left in "power-on"-state. Which I *guess* is
autonegotiate. But haven't really tested.

It leaves me a bit uneasy since these registers are never explicit
set up to autonegotiate. Maybe I should do a separate patch
to just set them explicitly in autonegotiation mode?

I have a small 10MBit router, I will try to connect it and see what
happens, if anything happens and can be detected.

> > -static void
> > -rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
> > -                   phy_interface_t interface, struct phy_device *phydev,
> > -                   int speed, int duplex, bool tx_pause, bool rx_pause)
> > +static void rtl8366rb_link_get_caps(struct dsa_switch *ds, int port,
> > +                                 struct phylink_config *config)
> >  {
> > -     struct realtek_priv *priv = ds->priv;
> > -     int ret;
> > +     /* The SYM and ASYM pause is RX and TX pause */
>
> No, SYM and ASYM pause are not RX and TX pause, but rather they are
> advertisement bits. After autoneg completes, the 4 SYM and ASYM pause
> advertisement bits of you and your link partner get resolved independently
> by you and your link partner according to the table described in
> linkmode_resolve_pause(), and the result of that resolution is what RX
> and TX pause are.

I stand corrected. I'll reword or drop this.

Yours,
Linus Walleij
