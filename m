Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE9A6E4D67
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjDQPj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjDQPjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:39:52 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [217.70.178.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC9110A;
        Mon, 17 Apr 2023 08:39:49 -0700 (PDT)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C7858100004;
        Mon, 17 Apr 2023 15:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681745988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1QbBR2bB5LMaN7h7i/xMkA3oEaeoCIU14nuN9j563/8=;
        b=pPIzZVuga4kjB4/iB25V+Bk/IIoSnmzhdgtOYrWqun9VhrA0CjDBbJxIYPQRH49qrB+xtu
        kez/uQDOIz1E3W9OQYlz+tYjlqMLOvz3i1bgiO83IcpkXFAT9RDFrQ4UlKThLWzwLYChku
        zXYnJiPhToWVd2fAAHUglQsXQIBzREt1PXAENKp6eJlNddThO1DZrJXcqUY/HwZCT3a3TE
        RmrQ7fWoekLXQJEmp3KUUP9VwEDx0FN+dtNs7l6c0AZflXlJwIJjXtgZ2L+c+1bjUGPVsZ
        FE3YoIz7S6NONlfFJPBgcESokBYC5f5Ck0jSMOA27dcabLgO95G/67qDHV+Vwg==
Date:   Mon, 17 Apr 2023 17:39:41 +0200
From:   Herve Codina <herve.codina@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <20230417173941.0206f696@bootlin.com>
In-Reply-To: <a2615755-f009-4a21-b464-88ec5e58f32a@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
        <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
        <20230414165504.7da4116f@bootlin.com>
        <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
        <20230417121629.63e97b80@bootlin.com>
        <a2615755-f009-4a21-b464-88ec5e58f32a@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 15:12:14 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > I'm surprised to see so much in the binding. I assume you are familiar
> > > with DAHDI. It allows nearly everything to be configured at
> > > runtime. The systems i've used allow you to select the clock
> > > configuration, line build out, user side vs networks side signalling
> > > CRC4 enables or not, etc. =20
> >=20
> > Well, I am not familiar with DAHDI at all.
> > I didn't even know about the DAHDI project.
> > The project seems to use specific kernel driver and I would like to avo=
id
> > these external drivers. =20
>=20
> DAHDI is kind of the reference. Pretty much any Linux system being
> used as a open source PBX runs Asterisk, and has the out of tree DAHDI
> code to provide access to E1/T1 hardware and analogue POTS. I doubt it
> will ever be merged into mainline, but i think it gives a good idea
> what is needed to fully make use of such hardware.
>=20
> I don't know what you application is. Are you using libpri for
> signalling? How are you exposing the B channel to user space so that
> libpri can use it?

My application (probably a subset of what we can do with E1 lines) does
not use signaling.

I don't expose any channel to the user space but just:
- One hdlc interface using one timeslot.
- One or more dai links (audio channels) that can be used using ALSA librar=
y.

>=20
> > > > Further more, the QMC HDLC is not the only PEF2256 consumer.
> > > > The PEF2256 is also used for audio path (ie audio over E1) and so t=
he
> > > > configuration is shared between network and audio. The setting cann=
ot be
> > > > handle by the network part as the PEF2256 must be available and cor=
rectly
> > > > configured even if the network part is not present.   =20
> > >=20
> > > But there is no reason why the MFD could not provide a generic PHY to
> > > actually configure the 'PHY'. The HDLC driver can then also use the
> > > generic PHY. It would make your generic PHY less 'pointless'. I'm not
> > > saying it has to be this way, but it is an option. =20
> >=20
> > If the pef2256 PHY provides a configure function, who is going to call =
this
> > configure(). I mean the one calling the configure will be the configura=
tion
> > owner. None of the MFD child can own the configuration as this configur=
ation
> > will impact other children. So the MFD (top level node) owns the config=
uration. =20
>=20
> Fine. Nothing unusual there. The netdev owns the configuration for an
> Ethernet device. The MAC driver passes a subset down to any generic
> PHY being used to implement a SERDES.
>=20
> You could have the same architecture here. The MFD implements a
> standardised netlink API for configuring E1/T1/J1 devices. Part of it
> gets passed to the framer, which could be part of a generic PHY. I
> assume you also need to configure the HDLC hardware. It needs to know
> if it is using the whole E1 channel in unframed mode, or it should do
> a fractional link, using a subset of slots, or is just using one slot
> for 64Kbps, which would be an ISDN B channel.

The HDLC driver uses a QMC channel and the DT binding related to this
QMC channel defines the timeslots used by this channel.

=46rom the QMC HDLC nothing is configured. This is done at the QMC level.
  https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/=
Documentation/devicetree/bindings/soc/fsl/cpm_qe/fsl,cpm1-scc-qmc.yaml#n91

>=20
> > > > > In fact, this PHY driver does not seem to do any configuration of=
 any
> > > > > sort on the framer. All it seems to be doing is take notification=
 from
> > > > > one chain and send them out another chain!   =20
> > > >=20
> > > > Configuration is done by the parent MFD driver.
> > > > The PHY driver has nothing more to do.
> > > >    =20
> > > > >=20
> > > > > I also wounder if this get_status() call is sufficient. Don't you=
 also
> > > > > want Red, Yellow and Blue alarms? It is not just the carrier is d=
own,
> > > > > but why it is down.   =20
> > > >=20
> > > > I don't need them in my use case but if needed can't they be added =
later?
> > > > Also, from the HDLC device point of view what can be done with thes=
e alarms?   =20
> > >=20
> > > https://elixir.bootlin.com/linux/latest/source/Documentation/networki=
ng/ethtool-netlink.rst#L472 =20
> >=20
> > Thanks for pointing this interface.
> > It is specific to ethtool but I can see the idea. =20
>=20
> Don't equate ethtool with Ethernet. Any netdev can implement it, and a
> HDLC device is a netdev. So it could well return link down reason.

Ok.
So the link down reason should be returned by the newly introduced QMC HDLC.

Adding this in the generic PHY infrastructure I used (drivers/phy) is adding
some specific netdev stuff in this subsystem.
Don't forget that the pef2256 can be used without any network part by the
audio subsystem in order to have the user audio data sent to E1 using pure
ALSA path.


>=20
> > But indeed this could be changed.
> > If changed, the MFD pef2256 will have to handle the full struct
> > phy_status_basic as the translation will not be there anymore.
> > Right now, this structure is pretty simple and contains only the link s=
tate
> > flag. But in the future, this PHY structure can move to something more
> > complex and I am not sure that filling this struct is the MFD pef2256
> > responsibility. The PHY pef2256 is responsible for the correct structure
> > contents not sure that this should be moved to the MFD part. =20
>=20
> Framers, like Ethernet PHYs, are reasonably well defined, because
> there are clear standards to follow. You could put the datasheets for
> the various frames side by side and quickly get an idea of the common
> properties. So you could define a structure now. In order to make it
> extendable, just avoid 0 having any meaning other than UNKNOWN. If you
> look at ethernet, SPEED_UNKNOWN is 0, DUPLEX_UNKNOWN is 0. So if a new
> field is added, we know if a driver has not filled it in.
>=20
> > > And why is the notifier specific to the PEF2256? What would happen if
> > > i used a analog devices DS2155, DS21Q55, and DS2156, or the IDT
> > > 82P2281? Would each have its own notifier? And hence each would need
> > > its own PHY which translates one notifier into another? =20
> >=20
> > Each of them should have their own notifier if they can notify. =20
>=20
> I doubt you will find a framer which cannot report lost of framing. It
> is too much a part of the standards. There are signalling actions you
> need to do when a link goes does. So all framer drivers will have a
> notifier.
>=20
> > At least they will need their own notifier at they PHY driver level.
> > Having or not a translation from something else would depend on each de=
vice
> > PHY driver implementation. =20
>=20
> Have you ever look at Ethernet PHYs? They all export the same API. You
> can plug any Linux MAC driver into any Linux Ethernet PHY driver. It
> should be the same here. You should be able to plug any HDLC driver
> into any Framer. I should be able to take the same SoC you have
> implementing the TDM interface, and plug it into the IDT framer i know
> of. We want a standardised API between the HDLC device and the framer.

Can you tell me more.
I thought I was providing a "standardised" API between the HDLC device
and the framer. Maybe it was not as complete as you could expect but I had
the feeling that it was standardised.
Right now it is just a link state notification provided by a simple 'basic
PHY'. Any HDLC device that uses a 'basic PHY' can be notified of any changes
of this link state provided by the PHY without knowing what is the exact
PHY behind this 'basic phy'.

>=20
> > I would like this first implementation without too much API restriction
> > in order to see how it goes.
> > The actual proposal imposes nothing on the PHY internal implementation.
> > the pef2256 implementation chooses to have two notifiers (one at MFD
> > level and one at PHY level) but it was not imposed by the API. =20
>=20
> What i would like to see is some indication the API you are proposing
> is generic, and could be implemented by multiple frames and HDLC
> devices. The interface between the HDLC driver and the framer should
> be generic. The HDLC driver has an abstract reference to a framer. The
> framer has a reference to a netdev for the HDLC device.

Here, I do not fully understand.
Why does the framer need a reference to the netdev ?

>=20
> You can keep this API very simple, just have link up/down
> notification, since that is all you want at the moment. But the
> implementation should give hints how it can be extended.
>=20

Best regards,
Herv=C3=A9

--=20
Herv=C3=A9 Codina, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
