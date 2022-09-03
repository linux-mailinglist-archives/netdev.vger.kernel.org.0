Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3600B5ABFAC
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 18:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiICQGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 12:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiICQGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 12:06:09 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14A040BEF;
        Sat,  3 Sep 2022 09:06:02 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 428321BF20B;
        Sat,  3 Sep 2022 16:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662221160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmPHVPoI6HAPYMHD+tu4gKjBgg/U6H2DfqTjAt8hY+c=;
        b=OyKNJRjYZGDzAuBJDAXq/ftoYenPRueMdrXIkPHCZbtD7+JT04D+AFTWIm+XcDDgGSq2S+
        LBB8bpLJgGeQlTCW8qR/3Pn6dhOLdvrf8WI4X3ljL4kR1wnIr+DrQghgqKCkhWt0bxXLgu
        x1+Ci2F/3CmWb7HL6/Ka15M65XuptYLq4uF07ycYUmACv75rNsbPDeaLnDbgkr9WFAynob
        78RONW1IJ8q2I8Z63XnniLafgPp8LTzXwFVgu5y+FbwrqkdpzGNgW1OIzTuQsab3SKabxd
        GKq8JLG/RnxXaYutvg4w0t4enQltsUVAMsWJN8RuWuvkFjupDMFEc7PR70ih3g==
Date:   Sat, 3 Sep 2022 18:05:56 +0200
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
Message-ID: <20220903180556.6430194b@xps-13>
In-Reply-To: <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
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
        <20220903020829.67db0af8@xps-13>
        <CAK-6q+hO1i=xvXx3wHo658ph93FwuVs_ssjG0=jnphEe8a+gxw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Sat, 3 Sep 2022 10:20:24 -0400:

> Hi,
>=20
> On Fri, Sep 2, 2022 at 8:08 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> ...
> > >
> > > I am sorry, I never looked into Zephyr for reasons... Do they not have
> > > something like /proc/interrupts look if you see a counter for your
> > > 802.15.4 transceiver?
> > > =20
> > > > Also, can you please clarify when are we talking about software and
> > > > when about hardware filters.
> > > > =20
> > >
> > > Hardware filter is currently e.g. promiscuous mode on or off setting.
> > > Software filtering is depending which receive path the frame is going
> > > and which hardware filter is present which then acts like actually
> > > with hardware filtering.
> > > I am not sure if this answers this question? =20
> >
> > I think my understand gets clearer now that I've digged into Zephyr's
> > ieee802154 layer and in the at86rf230 datasheet.
> > =20
>=20
> okay, I think for zephyr questions you are here on the wrong mailinglist.
>=20
> > I will answer the previous e-mail but just for not I wanted to add that
> > I managed to get Zephyr working, I had to mess around in the code a
> > little bit and actually I discovered a net command which is necessary
> > to use in order to turn the iface up, whatever.
> > =20
>=20
> aha.
>=20
> > So I was playing with the atusb devices and I _think_ I've found a
> > firmware bug or a hardware bug which is going to be problematic. In =20
>=20
> the firmware is open source, I think it's fine to send patches here (I
> did it as well once for do a quick hack to port it to rzusb) the atusb
> is "mostly" at the point that they can do open hardware from the
> qi-hardware organization.
>=20
> > iface.c, when creating the interface, if you set the hardware filters
> > (set_panid/short/ext_addr()) there is no way you will be able to get a
> > fully transparent promiscuous mode. I am not saying that the whole =20
>=20
> What is a transparent promiscuous mode?

I observe something very weird:

A/ If at start up time we set promisc_mode(true) and then we set the hw
address filters, all the frames are forwarded to the MAC.

B/ If at start up time we set the hw address filters and then set
promisc_mode(true), there is some filtering happening (like the Acks
which are dropped by the PHY.

I need to investigate this further because I don't get why in case B we
don't have the same behavior than in case A.

> > promiscuous mode does not work anymore, I don't really know. What I was
> > interested in were the acks, and getting them is a real pain. At least,
> > enabling the promiscuous mode after setting the hw filters will lead to
> > the acks being dropped immediately while if the promiscuous mode is
> > enabled first (like on monitor interfaces) the acks are correctly
> > forwarded by the PHY. =20
>=20
> If we would not disable AACK handling (means we receive a frame with
> ack requested bit set we send a ack back) we would ack every frame it
> receives (speaking on at86rf233).

Yes, but when sending MAC frames I would like to:
- be in promiscuous mode in Rx (tx paused) in order for the MAC to be
  aware of the acks being received (unless there is another way to do
  that, see below)
- still ack the received frames automatically

Unless we decide that we must only ack the expected frames manually?

> > While looking at the history of the drivers, I realized that the
> > TX_ARET mode was not supported by the firmware in 2015 (that's what you=
 =20
>=20
> There exists ARET and AACK, both are mac mechanisms which must be
> offloaded on the hardware. Note that those only do "something" if the
> ack request bit in the frame is set.

Absolutely (for the record, that's also an issue I had with Zephyr, I
had to use the shell to explicitly ask the AR bit to be set in the
outgoing frames, even though this in most MAC frames this is not a user
choice, it's expected by the spec).

> ARET will retransmit if no ack is received after some while, etc.
> mostly coupled with CSMA/CA handling. We cannot guarantee such timings
> on the Linux layer. btw: mac80211 can also not handle acks on the
> software layer, it must be offloaded.

On the Tx side, when sending eg. an association request or an
association response, I must expect and wait for an ack. This is
what I am struggling to do. How can I know that a frame which I just
transmitted has been acked? Bonus points, how can I do that in such a
way that it will work with other devices? (hints below)

> AACK will send a back if a frame with ack request bit was received.
>=20
> > say in a commit) I have seen no further updates about it so I guess
> > it's still not available. I don't see any other way to know if a
> > frame's ack has been received or not reliably. =20
>=20
> You implemented it for the at86rf230 driver (the spi one which is what
> also atusb uses). You implemented the
>=20
> ctx->trac =3D IEEE802154_NO_ACK;
>=20
> which signals the upper layer that if the ack request bit is set, that
> there was no ack.
>=20
> But yea, there is a missing feature for atusb yet which requires
> firmware changes as well.

:'(

Let's say I don't have the time to update the firmware ;). I also assume
that other transceivers (or even the drivers) might be limited on this
regard as well. How should I handle those "I should wait for the ack to
be received" situation while trying to associate?

The tricky case is the device receiving the ASSOC_REQ:
- the request is received
- an ack must be sent (this is okay in most cases I guess)
- the device must send an association response (also ok)
- and wait for the response to be acked...
	* either I use the promisc mode when sending the response
	  (because of possible race conditions) and I expect the ack to
	  be forwarded to the MAC
		-> This does not work on atusb, enabling promiscuous
		mode after the init does not turn the PHY into
		promiscuous mode as expected (discussed above)
	* or I don't turn the PHY in promiscuous mode and I expect it
	  to return a clear status about if the ACK was received
		-> But this seem to be unsupported with the current
		ATUSB firmware, I fear other devices could have similar
		limitations
	* or I just assume the acks are received blindly
		-> Not sure this is robust enough?

What is your "less worse" choice?

> Btw: I can imagine that hwsim "fakes" such
> offload behaviours.

My current implementation actually did handle all the acks (waiting for
them and sending them) from the MAC. I'm currently migrating the ack
sending part to the hw. For the reception, that's the big question.

> > Do you think I can just ignore the acks during an association in
> > mac802154? =20
>=20
> No, even we should WARN_ON ack frames in states we don't expect them
> because they must be offloaded on hardware.
>=20
> I am not sure if I am following what is wrong with the trac register
> and NO_ACK, this is the information if we got an ack or not. Do you
> need to turn off address filters while "an association"?

If we have access to the TRAC register, I believe we no longer need to
turn off address filters.

> Another idea how to get them? The Atmel datasheet states the
> > following, which is not encouraging:
> >
> >         If (Destination Addressing Mode =3D 0 OR 1) AND (Source
> >         Addressing Mode =3D 0) no IRQ_5 (AMI) is generated, refer to
> >         Section 8.1.2.2 =E2=80=9CFrame Control Field (FCF)=E2=80=9D on =
page 80. This
> >         effectively causes all acknowledgement frames not to be
> >         announced, which otherwise always pass the fil- ter, regardless
> >         of whether they are intended for this device or not. =20
>=20
> I hope the answers above are helpful because I don't know how this can
> be useful here.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
