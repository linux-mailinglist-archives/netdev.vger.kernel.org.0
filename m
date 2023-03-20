Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0764F6C0EB9
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCTK1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCTK1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:27:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C8214E93;
        Mon, 20 Mar 2023 03:27:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id le6so11880923plb.12;
        Mon, 20 Mar 2023 03:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679308039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSIeSNXj2NK7GwxnsqUvOQ9ngSnTVVCDmw2ojgaHY/Q=;
        b=KyHiFYCszFeqp+Sj69ulyR4wr7TrESTpx2xJzWgCyQT6Vt/5CHr6e687DerG+5Odwr
         GhHUMwzw0fPPtpB2su8zeVGI7TY8T3Yh62EDhUizsuQRjKuaaH8gC0rB0TJz7rkWDRK5
         d2Wh+FnUhDX6hK4bCS+7qnMSzK4wemF/Yuay7Yi1FxdCzcLRhOAWMkv4vsXLvCQMLZWb
         Tb1NhaBp8NARozXjaxhjSLMm/GoUCIgVweB0yrtM0QUjkQBfW077n45I0nwViy/UBdpK
         y9Pl1cLb/ktS67CaJ/AascXWdLlWPyQf3qcsK9dn+e1COndji30GGFzA/Fl7FzNXDFda
         5HLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679308039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSIeSNXj2NK7GwxnsqUvOQ9ngSnTVVCDmw2ojgaHY/Q=;
        b=PNtueQJ9FB5osfGr//jx97UlISEthNl8mSYtuyl80fuwLfhqXHr8/cObyZi0zIOMFb
         4swELp8G845BsfvWMk346G8DzTQwUXdbRKhYSEzlO4f+KDCMTTKssL/OCTwXg+K7JrCi
         LfKgYQ62CoRF47hLqg9lcFT6XlkEQZ8Uh9xrlAq8gRk8Yz8vDcV/v68dSeybqmLfbKPW
         gENT+OgpE2e5XoEXAZEbWu0cAnUjlxp2YXEOkVllan+Nro29d59AN+7BFbVDBE1sVt5Q
         QtVawCnzfrEbXvKmJpiJi98BthPfD4s/qi4OQu+C78RlKf6OzRUIkQBUQdgpzSZ6xq5j
         mFWg==
X-Gm-Message-State: AO0yUKXsdgoMco47FWzu6g4Sxspw+i7LHqmHpSDvWrc/mlcuwfy0/dWA
        Q56CJI3tI2Wh3Jgz3yoUKujEc4a4tjB10+n7Sbs=
X-Google-Smtp-Source: AK7set8mObdpj+ne4whbVzyBPa9dDtaOK6SSawY/FmrIgIIvIaqaje7YMUJ+qannTnq3ICjBeYTjK5KFx6tn7A8Id2I=
X-Received: by 2002:a17:90b:234e:b0:23d:3ff1:87b8 with SMTP id
 ms14-20020a17090b234e00b0023d3ff187b8mr4685381pjb.8.1679308039547; Mon, 20
 Mar 2023 03:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf> <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <20230317142919.hhjd64juws35j47o@skbuf> <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
 <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com> <CAKR-sGck2hqc5CpQQS_4WHm4bPzXJRg4aokd-8EporvUJ8UtbQ@mail.gmail.com>
In-Reply-To: <CAKR-sGck2hqc5CpQQS_4WHm4bPzXJRg4aokd-8EporvUJ8UtbQ@mail.gmail.com>
From:   Jonas Gorski <jonas.gorski@gmail.com>
Date:   Mon, 20 Mar 2023 11:27:08 +0100
Message-ID: <CAOiHx=kqgmK7kGCUJNiKrm1Em56d3a1jDBnkUuFwOaLHb0+nJg@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 at 10:45, =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gma=
il.com> wrote:
>
> El vie, 17 mar 2023 a las 17:41, Florian Fainelli
> (<f.fainelli@gmail.com>) escribi=C3=B3:
> >
> > On 3/17/23 09:23, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > > El vie, 17 mar 2023 a las 15:29, Vladimir Oltean (<olteanv@gmail.com>=
) escribi=C3=B3:
> > >>
> > >> On Fri, Mar 17, 2023 at 03:17:12PM +0100, =C3=81lvaro Fern=C3=A1ndez=
 Rojas wrote:
> > >>>> The proposed solution is too radical for a problem that was not pr=
operly
> > >>>> characterized yet, so this patch set has my temporary NACK.
> > >>>
> > >>> Forgive me, but why do you consider this solution too radical?
> > >>
> > >> Because it involves changing device tree bindings (stable ABI) in an
> > >> incompatible way.
> > >>
> > >>>>
> > >>>>> But maybe Florian or Jonas can give some more details about the i=
ssue...
> > >>>>
> > >>>> I think you also have the tools necessary to investigate this furt=
her.
> > >>>> We need to know what resource belonging to the switch is it that t=
he
> > >>>> MDIO mux needs. Where is the earliest place you can add the call t=
o
> > >>>> b53_mmap_mdiomux_init() such that your board works reliably? Note =
that
> > >>>> b53_switch_register() indirectly calls b53_setup(). By placing thi=
s
> > >>>> function where you have, the entirety of b53_setup() has finished
> > >>>> execution, and we don't know exactly what is it from there that is
> > >>>> needed.
> > >>>
> > >>> In the following link you will find different bootlogs related to
> > >>> different scenarios all of them with the same result: any attempt o=
f
> > >>> calling b53_mmap_mdiomux_init() earlier than b53_switch_register()
> > >>> will either result in a kernel panic or a device hang:
> > >>> https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7
> > >>>
> > >>> 1. before b53_switch_register():
> > >>>
> > >>> 2. before dsa_register_switch():
> > >>>
> > >>> 3. before b53_switch_init():
> > >>
> > >> Did you read what I said?
> > >
> > > Yes, but I didn't get your point, sorry for that.
> > >
> > >>
> > >> | Note that b53_switch_register() indirectly calls b53_setup(). By p=
lacing
> > >> | this function where you have, the entirety of b53_setup() has fini=
shed
> > >> | execution, and we don't know exactly what is it from there that is
> > >> | needed.
> > >>
> > >> Can you place the b53_mmap_mdiomux_init() in various places within
> > >> b53_setup() to restrict the search further?
> > >
> > > I tried and these are the results:
> > > https://gist.github.com/Noltari/d5bdba66b8f2e392c9e4c2759661d862
> > >
> > > All of them hang when dsa_tree_setup() is called for DSA tree 1
> > > (external switch) without having completely setup DSA tree 0 (interna=
l
> > > switch):
> > > [ 1.471345] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
> > > [ 1.481099] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
> > > [ 1.506752] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:=
12
> > > [ 1.594365] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdo=
g
> > > [ 1.612008] NET: Registered PF_INET6 protocol family
> > > [ 1.645617] Segment Routing with IPv6
> > > [ 1.649547] In-situ OAM (IOAM) with IPv6
> > > [ 1.653948] NET: Registered PF_PACKET protocol family
> > > [ 1.659984] 8021q: 802.1Q VLAN Support v1.8
> > > [ 1.699193] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
> > > [ 2.124257] bcm53xx 0.1:1e: found switch: BCM53125, rev 4
> > > *** Device hang ***
> > >
> > > I don't know if there's a way to defer the probe of DSA tree 1 (the
> > > external switch) until DSA tree 0 (the internal switch) is completely
> > > setup, because that would probably be the only alternative way of
> > > fixing this.
> >
> > Could you find out which part is hanging? It looks like there is a busy
> > waiting operation that we never complete?
>
> After many tests I was able to find the part that was hanging the device.
> It turns out that if the MDIO bus controller is registered soon
> enough, b53_phy_read16 will be called for the RGMII port on the
> internal switch:
> [ 4.042698] b53-switch 10e00000.switch: b53_phy_read16: ds=3D81fede80
> phy_read16=3D00000000 addr=3D4 reg=3D2
> It turns out that the device is hanging on the following line of
> b53_phy_read16():
>     b53_read16(priv, B53_PORT_MII_PAGE(addr), reg * 2, &value);
> Maybe it's not safe to access B53_PORT_MII_PAGE() on MMAP switches?

If you are following the example from 1/3, then I think I see what the
issue might be here:

You are labeling the port where the external switch is connected as
"extsw", which is neither "cpu" nor "dsa", so it is treated as a
normal/user port (which it shouldn't). If you change its label to
"dsa" (which AFAIU would be the correct one to denote a daisy chained
switch) it should not try to access port 4's MDIO registers (via the
slave mdio bus).

Can you check if that helps?

Regards
Jonas
