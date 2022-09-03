Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2955ABB8F
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 02:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiICAIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 20:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiICAIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 20:08:38 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A8BE2C7B;
        Fri,  2 Sep 2022 17:08:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 71F37FF804;
        Sat,  3 Sep 2022 00:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662163713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xIeAVq84frgVzQjiIqgTO1vZhjqpyrWWxt6ITWWwSA=;
        b=nAxHt3h9I7RktOV30NzYruLqC3fPCp7S4QZFz0dgEyD7ey+xDmySMUciVCpDkhw5aCBO2p
        Y/b2xXkVgdmT/oVg5Fe4eP5oD4h5mFX10yBf2EKpWLTFtwVJ2MGExCy9Fg92nqBj4KzAxo
        U2g6ZWi4QX5fdBwN5vluAKTXdD3slxsUyiIed+f4Vje0tbfG5js27CeEboe11xSlLsx5k3
        NWQ+EgnHgtXDbuEFfzkag6XGI3sCPgjgtaLDbT3oXt1slF26mBzA9L66OmZQ1twUaz0j9D
        x5ux2GuKANCnDa+0WuoICPdeYr8l0+hmEQh2V4zzavghYt9bUy93vJ13Zalyxg==
Date:   Sat, 3 Sep 2022 02:08:29 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 01/20] net: mac802154: Allow the creation of
 coordinator interfaces
Message-ID: <20220903020829.67db0af8@xps-13>
In-Reply-To: <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220819191109.0e639918@xps-13>
        <CAK-6q+gCY3ufaADHNQWJGNpNZJMwm=fhKfe02GWkfGEdgsMVzg@mail.gmail.com>
        <20220823182950.1c722e13@xps-13>
        <CAK-6q+jfva++dGkyX_h2zQGXnoJpiOu5+eofCto=KZ+u6KJbJA@mail.gmail.com>
        <20220824122058.1c46e09a@xps-13>
        <CAK-6q+gjgQ1BF-QrT01JWh+2b3oL3RU+SoxUf5t7h3Hc6R8pcg@mail.gmail.com>
        <20220824152648.4bfb9a89@xps-13>
        <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
        <20220825145831.1105cb54@xps-13>
        <CAK-6q+j3LMoSe_7u0WqhowdPV9KM-6g0z-+OmSumJXCZfo0CAw@mail.gmail.com>
        <20220826095408.706438c2@xps-13>
        <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
        <20220829100214.3c6dad63@xps-13>
        <CAK-6q+gJwm0bhHgMVBF_pmjD9zSrxxHvNGdTrTm0fG-hAmSaUQ@mail.gmail.com>
        <20220831173903.1a980653@xps-13>
        <20220901020918.2a15a8f9@xps-13>
        <20220901150917.5246c2d0@xps-13>
        <CAK-6q+g1Gnew=zWsnW=HAcLTqFYHF+P94Q+Ywh7Rir8J8cgCgw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 1 Sep 2022 22:38:12 -0400:

> Hi,
>=20
> On Thu, Sep 1, 2022 at 9:09 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hello,
> >
> > miquel.raynal@bootlin.com wrote on Thu, 1 Sep 2022 02:09:18 +0200:
> > =20
> > > Hello again,
> > >
> > > miquel.raynal@bootlin.com wrote on Wed, 31 Aug 2022 17:39:03 +0200:
> > > =20
> > > > Hi Alexander & Stefan,
> > > >
> > > > aahringo@redhat.com wrote on Mon, 29 Aug 2022 22:23:09 -0400:
> > > >
> > > > I am currently testing my code with the ATUSB devices, the associat=
ion
> > > > works, so it's a good news! However I am struggling to get the
> > > > association working for a simple reason: the crafted ACKs are
> > > > transmitted (the ATUSB in monitor mode sees it) but I get absolutely
> > > > nothing on the receiver side.
> > > >
> > > > The logic is:
> > > >
> > > > coord0                 coord1
> > > > association req ->
> > > >                 <-     ack
> > > >                 <-     association response
> > > > ack             ->
> > > >
> > > > The first ack is sent by coord1 but coord0 never sees anything. In
> > > > practice coord0 has sent an association request and received a sing=
le
> > > > one-byte packet in return which I guess is the firmware saying "oka=
y, Tx
> > > > has been performed". Shall I interpret this byte differently? Does =
it
> > > > mean that the ack has also been received? =20
> > >
> > > I think I now have a clearer understanding on how the devices behave.
> > >
> > > I turned the devices into promiscuous mode and could observe that some
> > > frames were considered wrong. Indeed, it looks like the PHYs add the
> > > FCS themselves, while the spec says that the FCS should be provided to
> > > the PHY. Anyway, I dropped the FCS calculations from the different ML=
ME
> > > frames forged and it helped a lot.
> > >
> > > I also kind of "discovered" the concept of hardware address filtering
> > > on atusb which makes me realize that maybe we were not talking about
> > > the same "filtering" until now.
> > >
> > > Associations and disassociations now work properly, I'm glad I fixed
> > > "everything". I still need to figure out if using the promiscuous mode
> > > everywhere is really useful or not (maybe the hardware filters were
> > > disabled in this mode and it made it work). However, using the
> > > promiscuous mode was the only way I had to receive acknowledgements,
> > > otherwise they were filtered out by the hardware (the monitor was
> > > showing that the ack frames were actually being sent).
> > >
> > > Finally, changing the channel was also a piece of the puzzle, because=
 I
> > > think some of my smart light bulbs tried to say hello and it kind of
> > > disturbed me :) =20
> >
> > I tried to scan my ATUSB devices from a Zephyr based Arduino Nano
> > BLE but for now it does not work, the ATUSB devices receive the scan
> > requests from Zephyr and send their beacons, the ATUSB monitor shows
> > the beacons on Wireshark but the ieee80154_recv() callback is never
> > triggered on Zephyr side. I am new to this OS so if you have any idea
> > or debugging tips, I would be glad to hear them.
> > =20
> > > > I could not find a documentation of the firmware interface, I went
> > > > through the wiki but I did not find something clear about what to
> > > > expect or "what the driver should do". But perhaps this will ring a
> > > > bell on your side?
> > > >
> > > > [...]
> > > > =20
> > > > > I did not see the v2 until now. Sorry for that. =20
> > > >
> > > > Ah! Ok, no problem :)
> > > > =20
> > > > >
> > > > > However I think there are missing bits here at the receive handli=
ng
> > > > > side. Which are:
> > > > >
> > > > > 1. Do a stop_tx(), stop_rx(), start_rx(filtering_level) to go into
> > > > > other filtering modes while ifup. =20
> > > >
> > > > Who is supposed to change the filtering level?
> > > >
> > > > For now there is only the promiscuous mode being applied and the us=
er
> > > > has no knowledge about it, it's just something internal.
> > > >
> > > > Changing how the promiscuous mode is applied (using a filtering lev=
el
> > > > instead of a "promiscuous on" boolean) would impact all the drivers
> > > > and for now we don't really need it.
> > > > =20
> > > > > I don't want to see all filtering modes here, just what we curren=
tly
> > > > > support with NONE (then with FCS check on software if necessary),
> > > > > ?THIRD/FOURTH? LEVEL filtering and that's it. What I don't want t=
o see
> > > > > is runtime changes of phy flags. To tell the receive path what to
> > > > > filter and what's not. =20
> > > >
> > > > Runtime changes on a dedicated "filtering" PHY flag is what I've us=
ed
> > > > and it works okay for this situation, why don't you want that? It
> > > > avoids the need for (yet) another rework of the API with the driver=
s,
> > > > no?
> > > > =20
> > > > > 2. set the pan coordinator bit for hw address filter. And there i=
s a
> > > > > TODO about setting pkt_type in mac802154 receive path which we sh=
ould
> > > > > take a look into. This bit should be addressed for coordinator su=
pport
> > > > > even if there is the question about coordinator vs pan coordinato=
r,
> > > > > then the kernel needs a bit as coordinator iface type parameter to
> > > > > know if it's a pan coordinator and not coordinator. =20
> > > >
> > > > This is not really something that we can "set". Either the device
> > > > had performed an association and it is a child device: it is not the
> > > > PAN coordinator, or it initiated the PAN and it is the PAN coordina=
tor.
> > > > There are commands to change that later on but those are not suppor=
ted.
> > > >
> > > > The "PAN coordinator" information is being added in the association
> > > > series (which comes after the scan). I have handled the pkt_type yo=
u are
> > > > mentioning.
> > > > =20
> > > > > I think it makes total sense to split this work in transmit handl=
ing,
> > > > > where we had no support at all to send something besides the usual
> > > > > data path, and receive handling, where we have no way to change t=
he
> > > > > filtering level besides interface type and ifup time of an interf=
ace.
> > > > > We are currently trying to make a receive path working in a way t=
hat
> > > > > "the other ideas flying around which are good" can be introduced =
in
> > > > > future.
> > > > > If this is done, then take care about how to add the rest of it.
> > > > >
> > > > > I will look into v2 the next few days. =20
> > >
> > > If possible, I would really like to understand what you expect in ter=
ms
> > > of filtering. Maybe as well a short snippet of code showing what kind
> > > of interface you have in mind. Are we talking about a rework of the
> > > promiscuous callback? Are we talking about the hardware filters? What
> > > are the inputs and outputs for these callbacks? What do we expect from
> > > the drivers in terms of advertising? I will be glad to make the
> > > relevant changes once I understand what is needed because on this top=
ic
> > > I have a clear lack of experience, so I will try to judge what is
> > > reachable based on your inputs. =20
> > =20
>=20
> I am sorry, I never looked into Zephyr for reasons... Do they not have
> something like /proc/interrupts look if you see a counter for your
> 802.15.4 transceiver?
>=20
> > Also, can you please clarify when are we talking about software and
> > when about hardware filters.
> > =20
>=20
> Hardware filter is currently e.g. promiscuous mode on or off setting.
> Software filtering is depending which receive path the frame is going
> and which hardware filter is present which then acts like actually
> with hardware filtering.
> I am not sure if this answers this question?

I think my understand gets clearer now that I've digged into Zephyr's
ieee802154 layer and in the at86rf230 datasheet.

I will answer the previous e-mail but just for not I wanted to add that
I managed to get Zephyr working, I had to mess around in the code a
little bit and actually I discovered a net command which is necessary
to use in order to turn the iface up, whatever.

So I was playing with the atusb devices and I _think_ I've found a
firmware bug or a hardware bug which is going to be problematic. In
iface.c, when creating the interface, if you set the hardware filters
(set_panid/short/ext_addr()) there is no way you will be able to get a
fully transparent promiscuous mode. I am not saying that the whole
promiscuous mode does not work anymore, I don't really know. What I was
interested in were the acks, and getting them is a real pain. At least,
enabling the promiscuous mode after setting the hw filters will lead to
the acks being dropped immediately while if the promiscuous mode is
enabled first (like on monitor interfaces) the acks are correctly
forwarded by the PHY.

While looking at the history of the drivers, I realized that the
TX_ARET mode was not supported by the firmware in 2015 (that's what you
say in a commit) I have seen no further updates about it so I guess
it's still not available. I don't see any other way to know if a
frame's ack has been received or not reliably.

Do you think I can just ignore the acks during an association in
mac802154? Another idea how to get them? The Atmel datasheet states the
following, which is not encouraging:

	If (Destination Addressing Mode =3D 0 OR 1) AND (Source
	Addressing Mode =3D 0) no IRQ_5 (AMI) is generated, refer to
	Section 8.1.2.2 =E2=80=9CFrame Control Field (FCF)=E2=80=9D on page 80. Th=
is
	effectively causes all acknowledgement frames not to be
	announced, which otherwise always pass the fil- ter, regardless
	of whether they are intended for this device or not.

Thanks,
Miqu=C3=A8l
