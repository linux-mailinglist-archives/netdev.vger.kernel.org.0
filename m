Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889D86C18F5
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjCTP3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjCTP2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:28:38 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874FD32CC8;
        Mon, 20 Mar 2023 08:21:44 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-541a05e4124so230534747b3.1;
        Mon, 20 Mar 2023 08:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679325701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3YlNFskFUTdqITlWtp9qPUGN21m2xiCw/lm+YWXlRM=;
        b=CYfU0kZ0OPTFZXnb3yTUxmKw9OywqehS3F6c4VsPwKgh0xdiOvEfB51baZZcb+oqfH
         9ivQeOCRQYkxxBX/Meq9tJ1obhLjB7dpJTKDBnohQ+WFl1EvSAe+idyAVjm3WQETtXrv
         Ar6OkaxliMn1bjuziXtrmg0QpqVOACljlaWQy2Msl9c84AKo1Xy3lz9jYw6FedE8ByQP
         zMFIKJzuRA7qBizucrydzEeqphvlHJ7pmE3tN9ZTGR4N0OvPtSU8U81DtOJizWtlysck
         1fCnYcma4IT53ddTfU1NqsPMs7wk+EomJ/wpU71yVr9dtwm5dBUIjVCndwSN4l5b0NDg
         TgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679325701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M3YlNFskFUTdqITlWtp9qPUGN21m2xiCw/lm+YWXlRM=;
        b=daUWiwA+DA8UCFCO54QXTH9bR5j02s4cnZ0KNrUzKSS16LgUCRebnSu+TgPN7jSkpB
         NJjEsfTFElJzQYIL/9wji64Hu1ZCzc7ukMLFr+ObJUuYZ5sjzBra5zbcHmTxY3vKLtLM
         RMbCr4Xy+EuFO+TigilSKX35cWfsgAbSJQSUwFmA/KRVyhTscJmgaJ96NnsxtK/ridjb
         qaJ43VcB4/tlUIUwOQqkC0Kb3a95V6KRaJngUHcSwL6EFJ2dpUeLv1hm0mU1EpMmKJI0
         XxNTb9U+kAmVYEmr0maUxTcNjo/e9V1CMHv67BpZ/agHMKr/ZTcR/e0G52s4ka/mmgg3
         ep6g==
X-Gm-Message-State: AO0yUKXw/wV9+Ya2RCFG6o48prE0fZ2lGqisRsWNV1iOwelByZbTi82Y
        elVePGlPBO2w68FzKq3nF7B2kU6zrAEX2+FOfrVIJrBqTHhYwQ==
X-Google-Smtp-Source: AK7set8qe8anY1RB73FuYBf7zPoZmWREte9FdgaYvM8VEz/WsagnA9JV+ULWMcoGJ6MpeaOtWeo8BbRHwFtP9JK5hkM=
X-Received: by 2002:a81:e8f:0:b0:544:b9dd:e27a with SMTP id
 137-20020a810e8f000000b00544b9dde27amr8212695ywo.1.1679325701054; Mon, 20 Mar
 2023 08:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230317113427.302162-1-noltari@gmail.com> <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf> <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
 <20230317130434.7cbzk5gxx5guarcz@skbuf> <CAKR-sGeFZLnuqH=4Gok1URJEvrQKxbk203Q8zdMd9830G_XD7A@mail.gmail.com>
 <20230317142919.hhjd64juws35j47o@skbuf> <CAKR-sGc7u346XqoihOuDse3q=d8HG6er3H6R1NCm_pQeNW7edA@mail.gmail.com>
 <4d669474-59b6-b0e9-09cb-8278734fa3a2@gmail.com> <CAKR-sGck2hqc5CpQQS_4WHm4bPzXJRg4aokd-8EporvUJ8UtbQ@mail.gmail.com>
 <CAOiHx=kqgmK7kGCUJNiKrm1Em56d3a1jDBnkUuFwOaLHb0+nJg@mail.gmail.com>
In-Reply-To: <CAOiHx=kqgmK7kGCUJNiKrm1Em56d3a1jDBnkUuFwOaLHb0+nJg@mail.gmail.com>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Mon, 20 Mar 2023 16:21:30 +0100
Message-ID: <CAKR-sGcyba_9og3S_BxKYXmT=t=SBJ2f5m7Rp7WufHdruN3+Xw@mail.gmail.com>
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
To:     Jonas Gorski <jonas.gorski@gmail.com>
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

El lun, 20 mar 2023 a las 11:27, Jonas Gorski
(<jonas.gorski@gmail.com>) escribi=C3=B3:
>
> On Sun, 19 Mar 2023 at 10:45, =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@g=
mail.com> wrote:
> >
> > El vie, 17 mar 2023 a las 17:41, Florian Fainelli
> > (<f.fainelli@gmail.com>) escribi=C3=B3:
> > >
> > > On 3/17/23 09:23, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > > > El vie, 17 mar 2023 a las 15:29, Vladimir Oltean (<olteanv@gmail.co=
m>) escribi=C3=B3:
> > > >>
> > > >> On Fri, Mar 17, 2023 at 03:17:12PM +0100, =C3=81lvaro Fern=C3=A1nd=
ez Rojas wrote:
> > > >>>> The proposed solution is too radical for a problem that was not =
properly
> > > >>>> characterized yet, so this patch set has my temporary NACK.
> > > >>>
> > > >>> Forgive me, but why do you consider this solution too radical?
> > > >>
> > > >> Because it involves changing device tree bindings (stable ABI) in =
an
> > > >> incompatible way.
> > > >>
> > > >>>>
> > > >>>>> But maybe Florian or Jonas can give some more details about the=
 issue...
> > > >>>>
> > > >>>> I think you also have the tools necessary to investigate this fu=
rther.
> > > >>>> We need to know what resource belonging to the switch is it that=
 the
> > > >>>> MDIO mux needs. Where is the earliest place you can add the call=
 to
> > > >>>> b53_mmap_mdiomux_init() such that your board works reliably? Not=
e that
> > > >>>> b53_switch_register() indirectly calls b53_setup(). By placing t=
his
> > > >>>> function where you have, the entirety of b53_setup() has finishe=
d
> > > >>>> execution, and we don't know exactly what is it from there that =
is
> > > >>>> needed.
> > > >>>
> > > >>> In the following link you will find different bootlogs related to
> > > >>> different scenarios all of them with the same result: any attempt=
 of
> > > >>> calling b53_mmap_mdiomux_init() earlier than b53_switch_register(=
)
> > > >>> will either result in a kernel panic or a device hang:
> > > >>> https://gist.github.com/Noltari/b0bd6d5211160ac7bf349d998d21e7f7
> > > >>>
> > > >>> 1. before b53_switch_register():
> > > >>>
> > > >>> 2. before dsa_register_switch():
> > > >>>
> > > >>> 3. before b53_switch_init():
> > > >>
> > > >> Did you read what I said?
> > > >
> > > > Yes, but I didn't get your point, sorry for that.
> > > >
> > > >>
> > > >> | Note that b53_switch_register() indirectly calls b53_setup(). By=
 placing
> > > >> | this function where you have, the entirety of b53_setup() has fi=
nished
> > > >> | execution, and we don't know exactly what is it from there that =
is
> > > >> | needed.
> > > >>
> > > >> Can you place the b53_mmap_mdiomux_init() in various places within
> > > >> b53_setup() to restrict the search further?
> > > >
> > > > I tried and these are the results:
> > > > https://gist.github.com/Noltari/d5bdba66b8f2e392c9e4c2759661d862
> > > >
> > > > All of them hang when dsa_tree_setup() is called for DSA tree 1
> > > > (external switch) without having completely setup DSA tree 0 (inter=
nal
> > > > switch):
> > > > [ 1.471345] b53-switch 10e00000.switch: found switch: BCM63xx, rev =
0
> > > > [ 1.481099] bcm6368-enetsw 1000d800.ethernet: IRQ tx not found
> > > > [ 1.506752] bcm6368-enetsw 1000d800.ethernet: mtd mac 4c:60:de:86:5=
2:12
> > > > [ 1.594365] bcm7038-wdt 1000005c.watchdog: Registered BCM7038 Watch=
dog
> > > > [ 1.612008] NET: Registered PF_INET6 protocol family
> > > > [ 1.645617] Segment Routing with IPv6
> > > > [ 1.649547] In-situ OAM (IOAM) with IPv6
> > > > [ 1.653948] NET: Registered PF_PACKET protocol family
> > > > [ 1.659984] 8021q: 802.1Q VLAN Support v1.8
> > > > [ 1.699193] b53-switch 10e00000.switch: found switch: BCM63xx, rev =
0
> > > > [ 2.124257] bcm53xx 0.1:1e: found switch: BCM53125, rev 4
> > > > *** Device hang ***
> > > >
> > > > I don't know if there's a way to defer the probe of DSA tree 1 (the
> > > > external switch) until DSA tree 0 (the internal switch) is complete=
ly
> > > > setup, because that would probably be the only alternative way of
> > > > fixing this.
> > >
> > > Could you find out which part is hanging? It looks like there is a bu=
sy
> > > waiting operation that we never complete?
> >
> > After many tests I was able to find the part that was hanging the devic=
e.
> > It turns out that if the MDIO bus controller is registered soon
> > enough, b53_phy_read16 will be called for the RGMII port on the
> > internal switch:
> > [ 4.042698] b53-switch 10e00000.switch: b53_phy_read16: ds=3D81fede80
> > phy_read16=3D00000000 addr=3D4 reg=3D2
> > It turns out that the device is hanging on the following line of
> > b53_phy_read16():
> >     b53_read16(priv, B53_PORT_MII_PAGE(addr), reg * 2, &value);
> > Maybe it's not safe to access B53_PORT_MII_PAGE() on MMAP switches?
>
> If you are following the example from 1/3, then I think I see what the
> issue might be here:
>
> You are labeling the port where the external switch is connected as
> "extsw", which is neither "cpu" nor "dsa", so it is treated as a
> normal/user port (which it shouldn't). If you change its label to
> "dsa" (which AFAIU would be the correct one to denote a daisy chained
> switch) it should not try to access port 4's MDIO registers (via the
> slave mdio bus).

Correct me if I'm wrong, but I think that the configuration you're
suggesting would be for a different kind of switches layout.
In this case I'm using a disjoint tree setup since both switches are
using different tags incompatible with each other.

So the proper switch layout should be the following (for a Huawei
HG253s, which is a BCM6362 with a WAN port on the internal switch port
5 and the external switch BCM53124S connected to the internal switch
on port 4):
https://gist.github.com/Noltari/975374f908bb056ecf2544d289255b2e#file-b53-d=
isjoint-switch-trees-hg253s-v2-dts

BTW, this is the log (as you can see b53_mmap_phy_read16() is used for
ports 4 & 5 at the beginning. After the switch initialization, the
mdio-mux bus controller is used):
https://gist.github.com/Noltari/975374f908bb056ecf2544d289255b2e#file-b53-d=
isjoint-switch-trees-hg253s-v2-log

I think that we need this kind of layout because as we already
discussed on "net: dsa: tag_brcm: legacy: fix daisy-chained switches"
(https://patchwork.kernel.org/project/netdevbpf/patch/20230317120815.321871=
-1-noltari@gmail.com/)
it's the only way of removing the incorrect VLAN tag added by the
internal BCM63xx switch when it receives a packet from the external
switch on port 4 (RGMII).
Otherwise, the double tag won't be processed correctly due to the
invalid VLAN tag and the packet won't be correctly forwarded from the
external switch to the internal switch.

But I may be wrong here since I don't have much experience with DSA...
That's why I decided to upstream all the patches that I sent lately,
to seek for help of the experts :)

>
> Can you check if that helps?
>
> Regards
> Jonas

Best regards,
=C3=81lvaro.
