Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF5544F9D
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 16:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiFIOmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 10:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbiFIOmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 10:42:47 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263F915716;
        Thu,  9 Jun 2022 07:42:44 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AA1AB40006;
        Thu,  9 Jun 2022 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654785763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uh4LLt/6JdErlzEN+2wYIYsmkK+wNN4OCN8Gh0tycMQ=;
        b=Ef89YXxwmnlOCM6NACM9/Wy6lYrP2AuwfAQ02+G61O0fP+zcKU4efMI1qeKLvy2LPmF/Ik
        rScxA9uLddVRc7JjSS8s5xkJDwrRwMWpat5T1HADkzhbRGfocIWeo7kQ7ROE+xDqYlmEet
        +2TxbaDF41a2PPkzjAYkmvilNPRurcaFFelOyyqzxOBILrOTAp1zcGunS5Ts/+j2r/o0WV
        IulLJUjN2sAaP8ryhPfzV++rS9kswMvom7gp807JFDh4wQpVoq7xRFWR2YVpjjKAKwRXwR
        3HeZv3c9IAg4HBrN8o1SUQk3TS9hDXxCGSXiyyGHfKt0RZRM1P2X2uOjlK2SuA==
Date:   Thu, 9 Jun 2022 16:42:40 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220609164240.4e7515d4@xps-13>
In-Reply-To: <CAK-6q+gf2_aVt4m7z77aLH+Rkc_sRTEjoykk5Dn+04wbu5n7Xg@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
        <CAK-6q+gf2_aVt4m7z77aLH+Rkc_sRTEjoykk5Dn+04wbu5n7Xg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

> > > > > Second I have
> > > > > a different opinion here that you cannot just "switch" the role f=
rom
> > > > > RFD, FFD, whatever. =20
> > > >
> > > > I agree with this, and that's why I don't understand this enum.
> > > >
> > > > A device can either be a NODE (an active device) or a MONITOR (a
> > > > passive device) at a time. We can certainly switch from one to
> > > > another at run time.
> > > >
> > > > A NODE can be either an RFD or an FFD. That is a static property wh=
ich
> > > > cannot change.
> > > >
> > > > However being a coordinator is just an additional property of a NODE
> > > > which is of type FFD, and this can change over time.
> > > >
> > > > So I don't get what having a coordinator interface would bring. What
> > > > was the idea behind its introduction then?
> > > > =20
> > >
> > > There exists arguments which I have in my mind right now:
> > >
> > > 1. frame parsing/address filter (which is somehow missing in your pat=
ches)
> > >
> > > The parsing of frames is different from other types (just as monitor
> > > interfaces). You will notice that setting up the address filter will
> > > require a parameter if coordinator or not. =20
> >
> > I think this is something that I completely missed until now, can you
> > point me to where/how this is expected to be done? I don't see anything
> > wpan specific filtering implementation. What is expected on this area
> > and is there code that I missed already?
> > =20
>=20
> https://elixir.bootlin.com/linux/v5.19-rc1/source/net/mac802154/rx.c#L284

Oh okay now I get what you mean. Indeed, I had to look into this
function to allow coordinators to receive packets with the IFACE_COORD
implementation, but so far the filtering is "the same" as for a node.
We can improve that later if needed.
=20
> > > Changing the address
> > > filterung during runtime of an interface is somehow _not_ supported.
> > > The reason is that the datasheets tell you to first set up an address
> > > filter and then switch into receiving mode. Changing the address
> > > filter during receive mode (start()/stop()) is not a specified
> > > behaviour. Due to bus communication it also cannot be done atomically.
> > > This might be avoidable but is a pain to synchronize if you really
> > > depend on hw address filtering which we might do in future. It should
> > > end in a different receiving path e.g. node_rx/monitor_rx. =20
> >
> > Got it.
> > =20
>=20
> I had some thoughts about this as well when going to promiscuous mode
> while in "receiving mode"... this is "normally" not supported...
>=20
> > >
> > > 2. HardMAC transceivers
> > >
> > > The add_interface() callback will be directly forwarded to the driver
> > > and the driver will during the lifetime of this interface act as a
> > > coordinator and not a mixed mode which can be disabled and enabled
> > > anytime. I am not even sure if this can ever be handled in such a way
> > > from hardmac transceivers, it might depend on the transceiver
> > > interface but we should assume some strict "static" handling. Static
> > > handling means here that the transceiver is unable to switch from
> > > coordinator and vice versa after some initialization state. =20
> >
> > Okay. I just completely missed the "interface add" command. So your
> > advice is to treat the "PAN coordinator" property as a static property
> > for a given interface, which seems reasonable.
> >
> > For now I will assume the same treatment when adding the interface is
> > required compared to a NODE, but if something comes to your mind,
> > please let me know.
> >
> > By the way, is there a mechanism limiting the number of interfaces on a
> > device? Should we prevent the introduction of a coordinator iface if
> > there is a node iface active?
> > =20
>=20
> such a mechanism already exists, look at the code when trying to ifup
> an interface in mac802154. You cannot simply have a monitor and node
> up at the same time. Hardware could have multiple address filters and
> run multiple mac stack instances on one phy, which is in my opinion
> not different than macvlan and in wireless running multiple access
> points on the same phy.

Oh nice, I didn't pay enough attention to figure out that this was
executed during ifup. So I already changed that code to refuse two node
*and* coordinators to be up at the same time, we should be on the safe
side.

Thanks,
Miqu=C3=A8l
