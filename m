Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B4C52412E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349458AbiEKXo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349454AbiEKXoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:44:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1483D60DBC
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:44:25 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d17so3364902plg.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U4DXScLb3PI4pSmFXkaWV6mZKYeR9MJzVJJLRHyJKNc=;
        b=N749XrlfSSbmBpSGeBA6P8yUxdfayt7vJDwGHTmGHTbfEE/LqsnXaZHfJJTagW6ViQ
         YvWZNgfCG2b2kuY02GdxPtTuE50UCDthDbqd7YX9iIxcmDjp+hs6Q5fFTv5m0DSGPTwI
         ihAKZLWLGgJJ+UJyN2Uopkl1/Dtqc89+W74eZjCwsqyFhce0mrdiBD2jLN9FIVL1kmq2
         nT032akxhZhcbAYhaNIQSMawGlrNyIwBoK84jVSSmMPuq+NCHmU34Z+MEeZay7MrYv9B
         Cm8l6HzL5FCu545Nw/YpMDHwflylHjYDoCGyZFkoBUK54vtFuuEsnxiDZ7tknE010cSo
         6DOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U4DXScLb3PI4pSmFXkaWV6mZKYeR9MJzVJJLRHyJKNc=;
        b=kqiJxem3pAB1gKkEGL2sNOyytC2qrrovf4yTeuyFQ8EH5u32hDi46ibawde7u6oS54
         L4N1cCTLpp41/ydxVupk3A9yfdYPOHm9rVsx78zhgrCYSywNbnIjSF91Ww7S91mw7zsS
         iGdDOgnTxuHLoX4MYuPhMKeofa16VMjKbIYXajatiKLPQHF1xlbFUaZgGH868LLOVGUf
         I+tBBR5dxzHNexwjnlTSrkxa6q9iw7GlVLooGXGX4cAAA+jkhmDEGRWfuX+j+5lP+6Zc
         CGDR9TGoRABMl5Suc7gTaRr3uGVaaVZAgKzjBRVxS0naBqGg+uO5hWEVXrruEruc03my
         dRZA==
X-Gm-Message-State: AOAM5305ePRcQ77pCBjegeCNU9SxmflLmDfg/ErFf4+wd6wZii8SoEJX
        AWYa03dmv+l5m0uHu5lfBbG8vVaEA8QI0UFzApeFBCrW
X-Google-Smtp-Source: ABdhPJy1csaXefAo0Wc3SGv/LpaUUDdm9MoElK1e7jD6idGi5oHhjGCAKRNKxvQaNqeHEV8l/0eqmJQpDgwVGjGrQa0=
X-Received: by 2002:a17:902:d145:b0:15e:d1a8:7f33 with SMTP id
 t5-20020a170902d14500b0015ed1a87f33mr27795352plt.66.1652312664374; Wed, 11
 May 2022 16:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220508224848.2384723-1-hauke@hauke-m.de> <20220508224848.2384723-5-hauke@hauke-m.de>
 <20220510172910.kthpd7kokb2qk27l@skbuf> <20220510192301.5djdt3ghoavxulhl@bang-olufsen.dk>
In-Reply-To: <20220510192301.5djdt3ghoavxulhl@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 11 May 2022 20:44:13 -0300
Message-ID: <CAJq09z7qaHTW03QTP5JyU7U+rQP2guybVhw5OsX5FH1VvWukJA@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
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

> On Tue, May 10, 2022 at 08:29:10PM +0300, Vladimir Oltean wrote:
> > On Mon, May 09, 2022 at 12:48:48AM +0200, Hauke Mehrtens wrote:
> > > @@ -983,14 +1295,25 @@ static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
> > >  static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
> > >                                    struct phylink_config *config)
> > >  {
> > > -   if (dsa_is_user_port(ds, port))
> > > +   int ext_int = rtl8365mb_extint_port_map[port];
> > > +
> > > +   config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
> > > +                              MAC_10 | MAC_100 | MAC_1000FD;
> > > +
> > > +   if (dsa_is_user_port(ds, port)) {
> > >             __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> > >                       config->supported_interfaces);
> > > -   else if (dsa_is_cpu_port(ds, port))
> > > +   } else if (dsa_is_cpu_port(ds, port)) {
> >
> > What does the quality of being a user port or a CPU port have to do with
> > which interfaces are supported?
>
> Right, I think this function was actually broken already in a few ways. The
> switch will have ports with integrated PHYs, and ports with extension interfaces
> like RGMII or SGMII etc. But which of those ports one uses as a CPU port, user
> port, or (one day) DSA port, is of no concern to the switch. The supported
> interface of a given port is a static property and simply a function of the port
> number and switch model. All switch models in the family have between 1 and 2
> ports with an extension interface.
>
> Luiz introduced this map:
>
> /* valid for all 6-port or less variants */
> static const int rtl8365mb_extint_port_map[]  = { -1, -1, -1, -1, -1, -1, 1, 2, -1, -1};
>
> ... which I think is actually what we ought to test on. It can be improved, but
> currently it is correct for all supported models.

I was playing some time ago with a more detailed description of
ports/supported modes I manually extracted from Realtek docs:

https://github.com/luizluca/linux/commit/d64201989803274bf6ba8bb784e2bf500114cff5

It might have more details than the driver really needs. Although
there are a lot of new lines with duplicated parts, I don't believe
that this family will grow too much.
I can get this upstream-ready if it looks the way to go.

Another approach would be to check if the switch can describe its
capabilities programmatically. The Realtek rtl8367c code has lots and
comes and goes, reads mysterious registers, but maybe deep down there
might be a way the switch can tell how many ports it has, which one
are really in use and what modes each port does support.

Regards,

Luiz
