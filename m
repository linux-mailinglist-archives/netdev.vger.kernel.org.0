Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0001B6BEEBA
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCQQpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCQQpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:45:03 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F10C1BC2;
        Fri, 17 Mar 2023 09:45:02 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-54195ef155aso104473147b3.9;
        Fri, 17 Mar 2023 09:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679071501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmlASijVwJGL91KHvF2vfFsUuFXx8zEeT62yHQWyYjM=;
        b=VFf5YHDZP7boz9w8LuIUR2k2zdczch210T2F1EkrhSSpdjrqECmnM3iOb1xqD2OfvC
         qU7cXoAm0citFDPaLk2NT440R8ltjrCiKIg/l/XSA8YXdJAEWxLSdacWAUAe2ftiiyWO
         hZyZFiLy6Q2zK/SUzz4tQw6X+2xfs5BGW1EeCNn+KMOgUcN1JDzwACBSzNEkkrzkc+l4
         C6RPNwgzjO+EMK9Hl1wLPEf4LPGUB1vaFrFa9m+SUBNNvIWvyY22D1wEKEHF1OGWArVZ
         Lo1D/5+idgKTfqQ9Onwv69od2u5whUf/PN0uIDL3O12LkTm5hu86qzjNlKRs7YZUwCGK
         7LbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmlASijVwJGL91KHvF2vfFsUuFXx8zEeT62yHQWyYjM=;
        b=L7iBCe20fopiJvQLZLQXKbNof1Ryk/oF3W2E1eY/bA1A3NRR9rgBJZd8jHX64GuYR8
         L7YucgtsP1df/Kiyaiw2NTW07VOfjQi7yDVVh0uG/S7hj5XnzaP3jttbcylxIK6vZUEP
         NDgfNBFaDO6LQaR+CYRsmmvV65pUa7laZcpbJGCh92qz8PW5itdz8AJFVOEGS0Iyi8TW
         Ml0K3L+DBeH+egokIB4e83utetle7gfGvl7UPzYbfguvxwzaGf880LTFFWUOwQaZC25n
         4ykVjhppV981/66zJrrS4FNwpPgWRkkVR7jv6/Svpf1jWRWsEeWKOq/VruLCViLXrF1i
         JTPA==
X-Gm-Message-State: AO0yUKWABstsE6pYCBqR8LEVTBW3D/C0vjPCKTCY/TveUuI+U4LWSIPM
        gDDC/fSwsg3ZJxaqcSdn9BXrxD2AyVNh7//68hQ=
X-Google-Smtp-Source: AK7set/JWr5cPG1OOBdLbtDejQPjayuo9X+vfsYJ66BE1iDz285J+xdcW/hoJ4pfbrH79hpkIJ8V8o0815vWSC+iGzQ=
X-Received: by 2002:a81:ed06:0:b0:540:e6c5:5118 with SMTP id
 k6-20020a81ed06000000b00540e6c55118mr5244681ywm.2.1679071501102; Fri, 17 Mar
 2023 09:45:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf> <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <20230317142919.hhjd64juws35j47o@skbuf> <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
 <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com>
In-Reply-To: <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 17:44:50 +0100
Message-ID: <CAKR-sGfeP=oOiQ5he4i9LH9D0=KtXf+m62Fs+YygnXZMfG1uYg@mail.gmail.com>
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

I don't think so, but I will try to debug the exact issue and report back.

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

Thanks for the info, I will look into this.

>
> using the MDIO mux would properly isolate the pseudo PHYs of the switch
> such that a given MDIO write does not end up programming *both* the
> internal and external switches. It could also be a completely different
> problem.
> --
> Florian
>
