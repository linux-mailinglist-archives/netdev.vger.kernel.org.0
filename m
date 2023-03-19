Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBB16C006C
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 10:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCSJpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCSJpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 05:45:19 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1352AB76E;
        Sun, 19 Mar 2023 02:45:17 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5416b0ab0ecso175237167b3.6;
        Sun, 19 Mar 2023 02:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679219116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9ErGVM/hPJOD1E20KyBCgnADtZeDKXRPbZaHTW4/PE=;
        b=CzBJDD2FSVZavpJFebtB5oF+WFA6zF/re9tl/IvuSJaPJqWeuhqu+LvP6hLmgxYxF5
         2hygZQ7rWf0sMPqoUpfdrtUXXIJPu4FgXc1H7iYzydDNGSPu+vaKJyWYkhrECl6Bryo+
         NkU9MMvoQInrv+nEImCNplGOyzEHfGijKSw8hRdw8wGCkpym5ybL3Hi3F2G8yhFcwSRg
         DiAyPScNXbAgcX+1A6twm0auRdf5jXeM2cyenuUBCZf6wmn5UDdu7bnDo0XlCpk9DUxy
         4GHq+N7u+JQ+TLhb0/oW1WLiyeLtXzEtJAe4+iU5FRBaVHd73BK4qOQ/gohmSgXvEVGQ
         cgQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679219116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9ErGVM/hPJOD1E20KyBCgnADtZeDKXRPbZaHTW4/PE=;
        b=MaN+mdIk3ozgU68xoaCaSjI8KHOKEiA1UhNaMWA0DQHcAqMLaWkTpkARHbOJxMqv+e
         w/S/yDn9hZ0jL2Gj+IBLLMHYypTGwyj07sQGXV5RYwnDvS5IoSSRfwd+OiWYvIAx6prV
         uvWJD2MA2J9m2Go9oIqILNpDFoyiSJkCwIbN8jD9a82ZHZYNFnk+F9mxF4eap+Hk56YA
         lhWTGmZi/7otfVW2l5pg4VKeVKbald4T2IQzf4EbhSTf5ZIrMFHQEIHL1qqVJ7NFyArA
         ONpFSx3lakTOnE/PAzZZWOJ8vEmOvctMl6uF4S9lBbBkunpTfBvuBi5kDH9hr07qIPXG
         rcJw==
X-Gm-Message-State: AO0yUKUaQ5Jh+8hB8g6HJZhPNEb9X35RaeH5AtmWfFN1kIChXHeAW8VC
        H+4yCA298371lFqbHlAu2ZoL/uMBdkV0twHz3kE=
X-Google-Smtp-Source: AK7set+EGp1KAUzIsksQqm3UaoiKBZEg0DwDH6V0AqzeAJpGiRwATHmXpvi5o4QqVI1RfI4EudqXqDo6RbMrOe8e11Q=
X-Received: by 2002:a81:b617:0:b0:541:8ce6:b9ad with SMTP id
 u23-20020a81b617000000b005418ce6b9admr7866486ywh.2.1679219115994; Sun, 19 Mar
 2023 02:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf> <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <20230317142919.hhjd64juws35j47o@skbuf> <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
 <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com>
In-Reply-To: <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Sun, 19 Mar 2023 10:45:05 +0100
Message-ID: <CAKR-sGck2hqc5CpQQS_4WHm4bPzXJRg4aokd-8EporvUJ8UtbQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        jonas.gorski@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
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

El vie, 17 mar 2023 a las 17:41, Florian Fainelli
(<f.fainelli@gmail.com>) escribi=C3=B3:
>
> On 3/17/23 09:23, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > El vie, 17 mar 2023 a las 15:29, Vladimir Oltean (<olteanv@gmail.com>) =
escribi=C3=B3:
> >>
> >> On Fri, Mar 17, 2023 at 03:17:12PM +0100, =C3=81lvaro Fern=C3=A1ndez R=
ojas wrote:
> >>>> The proposed solution is too radical for a problem that was not prop=
erly
> >>>> characterized yet, so this patch set has my temporary NACK.
> >>>
> >>> Forgive me, but why do you consider this solution too radical?
> >>
> >> Because it involves changing device tree bindings (stable ABI) in an
> >> incompatible way.
> >>
> >>>>
> >>>>> But maybe Florian or Jonas can give some more details about the iss=
ue...
> >>>>
> >>>> I think you also have the tools necessary to investigate this furthe=
r.
> >>>> We need to know what resource belonging to the switch is it that the
> >>>> MDIO mux needs. Where is the earliest place you can add the call to
> >>>> b53_mmap_mdiomux_init() such that your board works reliably? Note th=
at
> >>>> b53_switch_register() indirectly calls b53_setup(). By placing this
> >>>> function where you have, the entirety of b53_setup() has finished
> >>>> execution, and we don't know exactly what is it from there that is
> >>>> needed.
> >>>
> >>> In the following link you will find different bootlogs related to
> >>> different scenarios all of them with the same result: any attempt of
> >>> calling b53_mmap_mdiomux_init() earlier than b53_switch_register()
> >>> will either result in a kernel panic or a device hang:
> >>> https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7
> >>>
> >>> 1. before b53_switch_register():
> >>>
> >>> 2. before dsa_register_switch():
> >>>
> >>> 3. before b53_switch_init():
> >>
> >> Did you read what I said?
> >
> > Yes, but I didn't get your point, sorry for that.
> >
> >>
> >> | Note that b53_switch_register() indirectly calls b53_setup(). By pla=
cing
> >> | this function where you have, the entirety of b53_setup() has finish=
ed
> >> | execution, and we don't know exactly what is it from there that is
> >> | needed.
> >>
> >> Can you place the b53_mmap_mdiomux_init() in various places within
> >> b53_setup() to restrict the search further?
> >
> > I tried and these are the results:
> > https://gist.github.com/Noltari/d5bdba66b8f2e392c9e4c2759661d862
> >
> > All of them hang when dsa_tree_setup() is called for DSA tree 1
> > (external switch) without having completely setup DSA tree 0 (internal
> > switch):
> > [ 1.471345] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
> > [ 1.481099] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
> > [ 1.506752] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:12
> > [ 1.594365] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdog
> > [ 1.612008] NET: Registered PF_INET6 protocol family
> > [ 1.645617] Segment Routing with IPv6
> > [ 1.649547] In-situ OAM (IOAM) with IPv6
> > [ 1.653948] NET: Registered PF_PACKET protocol family
> > [ 1.659984] 8021q: 802.1Q VLAN Support v1.8
> > [ 1.699193] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
> > [ 2.124257] bcm53xx 0.1:1e: found switch: BCM53125, rev 4
> > *** Device hang ***
> >
> > I don't know if there's a way to defer the probe of DSA tree 1 (the
> > external switch) until DSA tree 0 (the internal switch) is completely
> > setup, because that would probably be the only alternative way of
> > fixing this.
>
> Could you find out which part is hanging? It looks like there is a busy
> waiting operation that we never complete?

After many tests I was able to find the part that was hanging the device.
It turns out that if the MDIO bus controller is registered soon
enough, b53_phy_read16 will be called for the RGMII port on the
internal switch:
[ 4.042698] b53-switch 10e00000.switch: b53_phy_read16: ds=3D81fede80
phy_read16=3D00000000 addr=3D4 reg=3D2
It turns out that the device is hanging on the following line of
b53_phy_read16():
    b53_read16(priv, B53_PORT_MII_PAGE(addr), reg * 2, &value);
Maybe it's not safe to access B53_PORT_MII_PAGE() on MMAP switches?

Only in one specific image in which I had a lot of debugging this
access didn't hang, but it just returned 0:
[ 5.129715] b53_mmap_write16: dev=3D83547680 page=3D0 reg=3D3c val=3D100
[ 5.135914] b53_mmap_write16: dev=3D83547680 page=3D0 reg=3D3c val=3D100 do=
ne!
[ 5.143721] b53-switch 10e00000.switch: b53_phy_read16: ds=3D83547580
phy_read16=3D00000000 addr=3D4 reg=3D2
[ 5.153204] b53-switch 10e00000.switch: b53_phy_read16: ds=3D83547580
phy_read16=3D00000000 addr=3D4 reg=3D2 val=3D0
[ 5.163171] b53-switch 10e00000.switch: b53_phy_read16: ds=3D83547580
phy_read16=3D00000000 addr=3D4 reg=3D3
[ 5.172560] b53-switch 10e00000.switch: b53_phy_read16: ds=3D83547580
phy_read16=3D00000000 addr=3D4 reg=3D3 val=3D0
[ 5.218764] b53-switch 10e00000.switch: Using legacy PHYLIB callbacks.
Please migrate to PHYLINK!

However, if I implement b53_mmap_phy_read16() and
b53_mmap_phy_write16() in MMAP it seems to solve the issue and the
device doesn't hang anymore:
[ 2.783407] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
[ 2.951877] b53-switch 10e00000.switch: b53_phy_read16: addr=3D4 reg=3D2
[ 2.958393] b53_mmap_phy_read16: dev=3D836f6580 phy_id=3D4 loc=3D2
[ 2.964367] b53_mmap_phy_read16: dev=3D836f6580 phy_id=3D4 loc=3D2 val=3D36=
2
[ 2.970923] b53-switch 10e00000.switch: b53_phy_read16: addr=3D4 reg=3D3
[ 2.977420] b53_mmap_phy_read16: dev=3D836f6580 phy_id=3D4 loc=3D3
[ 2.983315] b53_mmap_phy_read16: dev=3D836f6580 phy_id=3D4 loc=3D3 val=3D5e=
80
[ 3.026253] b53-switch 10e00000.switch: Using legacy PHYLIB callbacks.
Please migrate to PHYLINK!
[ 3.072584] b53-switch 10e00000.switch: Configured port 8 for internal
[ 3.082850] DSA: tree 0 setup

However, what I did is just replicating mdio-mux-bcm6368 source code
in MMAP (for the internal PHY only):
static int b53_mmap_phy_read16(struct b53_device *dev, int phy_id, int
loc, u16 *val)
{
        uint32_t reg;

        b53_mmap_write32(dev, 0, REG_MDIOC, 0);

        reg =3D REG_MDIOC_RD_MASK |
        (phy_id << REG_MDIOC_PHYID_SHIFT) |
        (loc << REG_MDIOC_REG_SHIFT);

        b53_mmap_write32(dev, 0, REG_MDIOC, reg);
        udelay(50);
        b53_mmap_read16(dev, 0, REG_MDIOD, val);

        return 0;
}

static int b53_mmap_phy_write16(struct b53_device *dev, int phy_id,
int loc, u16 val)
{
        uint32_t reg;

        b53_mmap_write32(dev, 0, REG_MDIOC, 0);

        reg =3D REG_MDIOC_WR_MASK |
        (phy_id << REG_MDIOC_PHYID_SHIFT) |
        (loc << REG_MDIOC_REG_SHIFT) |
        val;

        b53_mmap_write32(dev, 0, REG_MDIOC, reg);
        udelay(50);

        return 0;
}

Is it safe to add those functions in MMAP or is there a way of forcing
the use of mdio-mux-bcm6368 for those PHY accesses?

>
> DSA should be perfectly capable of dealing with disjoint trees being
> cascaded to one another, as this is entirely within how the framework is
> designed.
>
> What I suspect might be happening is a "double programming" effect,
> similar or identical to what was described in this commit:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3Db8c6cd1d316f3b01ae578d8e29179f6396c0eaa2
>
> using the MDIO mux would properly isolate the pseudo PHYs of the switch
> such that a given MDIO write does not end up programming *both* the
> internal and external switches. It could also be a completely different
> problem.
> --
> Florian
>

--
=C3=81lvaro
