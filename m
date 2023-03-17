Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C486BEE01
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCQQXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCQQXs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:23:48 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE84B1ADE1;
        Fri, 17 Mar 2023 09:23:45 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5418d54d77bso103327957b3.12;
        Fri, 17 Mar 2023 09:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679070225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4QmBtbgB/2OW4j7xluQKxFUqIbIGpqHrFtJV0Y+1mU=;
        b=JntHXpIMykE8+M/vIjipdKxK6O9A+GC2MUwHi0UHZOcueEavN591OdIAmOfOKUYc9E
         mGV/GW8RPCteYgkPGambd+eSrlwOsolng8JNwWI6C/cmXjF5PoLXnyUHFWel1QsDc944
         bCoRUqjEeVhyXbY3dbosS8eP/qTRW0PO33+GYLkOzSyNADM8eL3N9iP+vdmBGDA16jEx
         2yUIn1kXajwAMLjwRiIY3g+kGsDgB7Zmeckio/FkDqdhxlcRWdKR8jOVpV/MkkcjhB5h
         3V/4lFjMyp4kdqnGi9vCDrbyDlgdAhe4hxPvJ7SJUQedVHpnRKIr2MyLERGzF95j2hFo
         2ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4QmBtbgB/2OW4j7xluQKxFUqIbIGpqHrFtJV0Y+1mU=;
        b=aBqq/EI8gUgo3OYPEhDqPwX6TUFF+qbg2TeiGxCBMZNrXve+fMC6V3y4CvFoS+Ekoh
         NTo6XPMTWCps3WvGsUqIE4O0h1L5HhrIW+4eb4DLhmr3ayjqdfyt+r93MHuuhFVIKEhG
         tcND1j/Uitq8Z+PbDdb7Xyfxe9RNjSaAsPtSuYYOsnHqYGwV1fnT9TxYU8GNzpeK2Gmw
         N/mrPO0WaaZF9rdpaEFJtst/dZbm49Gy889RbdtJ77CtMfrBFleekZLOMBp70wj5lpZD
         VIYVZOTXcSQrlOuekdmlczPSxLreOzWmS54lBocLPr/1k3ZbaSMOaLDj0+sBW6ClMtIQ
         KQaw==
X-Gm-Message-State: AO0yUKWh03TByAJM7IKuKwC8bp2LD0glPCdqljAqKEt5yms9J3S7Y1Br
        J4/ZAJ59wwd5s4bazVVnOD1VqGa+UQDRNIwFBFY=
X-Google-Smtp-Source: AK7set/OpWtNOxgI+xlGLNw2LIW9agNzVXS1y+lw5SM2gLBHmSXzUiGz63HEQGoVzjCGcDoSzde/MdoP9M8Ps6Y7UL8=
X-Received: by 2002:a81:e8f:0:b0:544:b9dd:e27a with SMTP id
 137-20020a810e8f000000b00544b9dde27amr2415408ywo.1.1679070224751; Fri, 17 Mar
 2023 09:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf> <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <20230317142919.hhjd64juws35j47o@skbuf>
In-Reply-To: <20230317142919.hhjd64juws35j47o@skbuf>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 17:23:34 +0100
Message-ID: <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
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

El vie, 17 mar 2023 a las 15:29, Vladimir Oltean (<olteanv@gmail.com>) escr=
ibi=C3=B3:
>
> On Fri, Mar 17, 2023 at 03:17:12PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > > The proposed solution is too radical for a problem that was not prope=
rly
> > > characterized yet, so this patch set has my temporary NACK.
> >
> > Forgive me, but why do you consider this solution too radical?
>
> Because it involves changing device tree bindings (stable ABI) in an
> incompatible way.
>
> > >
> > > > But maybe Florian or Jonas can give some more details about the iss=
ue...
> > >
> > > I think you also have the tools necessary to investigate this further=
.
> > > We need to know what resource belonging to the switch is it that the
> > > MDIO mux needs. Where is the earliest place you can add the call to
> > > b53_mmap_mdiomux_init() such that your board works reliably? Note tha=
t
> > > b53_switch_register() indirectly calls b53_setup(). By placing this
> > > function where you have, the entirety of b53_setup() has finished
> > > execution, and we don't know exactly what is it from there that is
> > > needed.
> >
> > In the following link you will find different bootlogs related to
> > different scenarios all of them with the same result: any attempt of
> > calling b53_mmap_mdiomux_init() earlier than b53_switch_register()
> > will either result in a kernel panic or a device hang:
> > https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7
> >
> > 1. before b53_switch_register():
> >
> > 2. before dsa_register_switch():
> >
> > 3. before b53_switch_init():
>
> Did you read what I said?

Yes, but I didn't get your point, sorry for that.

>
> | Note that b53_switch_register() indirectly calls b53_setup(). By placin=
g
> | this function where you have, the entirety of b53_setup() has finished
> | execution, and we don't know exactly what is it from there that is
> | needed.
>
> Can you place the b53_mmap_mdiomux_init() in various places within
> b53_setup() to restrict the search further?

I tried and these are the results:
https://gist.github.com/Noltari/d5bdba66b8f2e392c9e4c2759661d862

All of them hang when dsa_tree_setup() is called for DSA tree 1
(external switch) without having completely setup DSA tree 0 (internal
switch):
[ 1.471345] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
[ 1.481099] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
[ 1.506752] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:52:12
[ 1.594365] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watchdog
[ 1.612008] NET: Registered PF_INET6 protocol family
[ 1.645617] Segment Routing with IPv6
[ 1.649547] In-situ OAM (IOAM) with IPv6
[ 1.653948] NET: Registered PF_PACKET protocol family
[ 1.659984] 8021q: 802.1Q VLAN Support v1.8
[ 1.699193] b53-switch 10e00000.switch: found switch: BCM63xx, rev 0
[ 2.124257] bcm53xx 0.1:1e: found switch: BCM53125, rev 4
*** Device hang ***

I don't know if there's a way to defer the probe of DSA tree 1 (the
external switch) until DSA tree 0 (the internal switch) is completely
setup, because that would probably be the only alternative way of
fixing this.

--
=C3=81lvaro.
