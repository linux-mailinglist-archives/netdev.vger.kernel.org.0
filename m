Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CD85A89B9
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 02:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiIAAJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 20:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiIAAJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 20:09:27 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D11E115A;
        Wed, 31 Aug 2022 17:09:25 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 60DF61BF204;
        Thu,  1 Sep 2022 00:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661990963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7HecSJBCz5O36GzBTh4mMVoQyvMbAhBFppUr4JLhBpI=;
        b=kG42d29JD6P4EH+fwB+DyhMKMvqNJfGaSf3+TCsROEmeyssOPghOQy8QomlxZVyVckYJzt
        3kuULVJ6aL+EGHBhE+GXdU+UEX39xqKmkA7ab6oGZ+tDHS7troHlRrr4vKzi0VFnwZnQJv
        8o4ZB96RXTWjcWkQGt8apDWdkTtiBAr0F7B8aveEUYSZJ13cDW6lIph2EnQi4huY14ysn1
        msTRkuaM6UAxP0GClrY68zSvrkJ/U6V5RO+Y/NbYB5mcIDT3Tw9A5gZHybMfxN7agjVM9Z
        D2xt//+m6pI1aai3Qo/utJ0ngmNT7JQFvukWL0nQCuVrlDpzjm81im27wNWLcA==
Date:   Thu, 1 Sep 2022 02:09:18 +0200
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
Message-ID: <20220901020918.2a15a8f9@xps-13>
In-Reply-To: <20220831173903.1a980653@xps-13>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-2-miquel.raynal@bootlin.com>
        <CAK-6q+jkUUjAGqEDgU1oJvRkigUbvSO5SXWRau6+320b=GbfxQ@mail.gmail.com>
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

Hello again,

miquel.raynal@bootlin.com wrote on Wed, 31 Aug 2022 17:39:03 +0200:

> Hi Alexander & Stefan,
>=20
> aahringo@redhat.com wrote on Mon, 29 Aug 2022 22:23:09 -0400:
>=20
> I am currently testing my code with the ATUSB devices, the association
> works, so it's a good news! However I am struggling to get the
> association working for a simple reason: the crafted ACKs are
> transmitted (the ATUSB in monitor mode sees it) but I get absolutely
> nothing on the receiver side.
>=20
> The logic is:
>=20
> coord0                 coord1
> association req ->
>                 <-     ack
>                 <-     association response
> ack             ->
>=20
> The first ack is sent by coord1 but coord0 never sees anything. In
> practice coord0 has sent an association request and received a single
> one-byte packet in return which I guess is the firmware saying "okay, Tx
> has been performed". Shall I interpret this byte differently? Does it
> mean that the ack has also been received?

I think I now have a clearer understanding on how the devices behave.

I turned the devices into promiscuous mode and could observe that some
frames were considered wrong. Indeed, it looks like the PHYs add the
FCS themselves, while the spec says that the FCS should be provided to
the PHY. Anyway, I dropped the FCS calculations from the different MLME
frames forged and it helped a lot.

I also kind of "discovered" the concept of hardware address filtering
on atusb which makes me realize that maybe we were not talking about
the same "filtering" until now.

Associations and disassociations now work properly, I'm glad I fixed
"everything". I still need to figure out if using the promiscuous mode
everywhere is really useful or not (maybe the hardware filters were
disabled in this mode and it made it work). However, using the
promiscuous mode was the only way I had to receive acknowledgements,
otherwise they were filtered out by the hardware (the monitor was
showing that the ack frames were actually being sent).

Finally, changing the channel was also a piece of the puzzle, because I
think some of my smart light bulbs tried to say hello and it kind of
disturbed me :)

> I could not find a documentation of the firmware interface, I went
> through the wiki but I did not find something clear about what to
> expect or "what the driver should do". But perhaps this will ring a
> bell on your side?
>=20
> [...]
>=20
> > I did not see the v2 until now. Sorry for that. =20
>=20
> Ah! Ok, no problem :)
>=20
> >=20
> > However I think there are missing bits here at the receive handling
> > side. Which are:
> >=20
> > 1. Do a stop_tx(), stop_rx(), start_rx(filtering_level) to go into
> > other filtering modes while ifup. =20
>=20
> Who is supposed to change the filtering level?
>=20
> For now there is only the promiscuous mode being applied and the user
> has no knowledge about it, it's just something internal.
>=20
> Changing how the promiscuous mode is applied (using a filtering level
> instead of a "promiscuous on" boolean) would impact all the drivers
> and for now we don't really need it.
>=20
> > I don't want to see all filtering modes here, just what we currently
> > support with NONE (then with FCS check on software if necessary),
> > ?THIRD/FOURTH? LEVEL filtering and that's it. What I don't want to see
> > is runtime changes of phy flags. To tell the receive path what to
> > filter and what's not. =20
>=20
> Runtime changes on a dedicated "filtering" PHY flag is what I've used
> and it works okay for this situation, why don't you want that? It
> avoids the need for (yet) another rework of the API with the drivers,
> no?
>=20
> > 2. set the pan coordinator bit for hw address filter. And there is a
> > TODO about setting pkt_type in mac802154 receive path which we should
> > take a look into. This bit should be addressed for coordinator support
> > even if there is the question about coordinator vs pan coordinator,
> > then the kernel needs a bit as coordinator iface type parameter to
> > know if it's a pan coordinator and not coordinator. =20
>=20
> This is not really something that we can "set". Either the device
> had performed an association and it is a child device: it is not the
> PAN coordinator, or it initiated the PAN and it is the PAN coordinator.
> There are commands to change that later on but those are not supported.
>=20
> The "PAN coordinator" information is being added in the association
> series (which comes after the scan). I have handled the pkt_type you are
> mentioning.
>=20
> > I think it makes total sense to split this work in transmit handling,
> > where we had no support at all to send something besides the usual
> > data path, and receive handling, where we have no way to change the
> > filtering level besides interface type and ifup time of an interface.
> > We are currently trying to make a receive path working in a way that
> > "the other ideas flying around which are good" can be introduced in
> > future.
> > If this is done, then take care about how to add the rest of it.
> >=20
> > I will look into v2 the next few days.

If possible, I would really like to understand what you expect in terms
of filtering. Maybe as well a short snippet of code showing what kind
of interface you have in mind. Are we talking about a rework of the
promiscuous callback? Are we talking about the hardware filters? What
are the inputs and outputs for these callbacks? What do we expect from
the drivers in terms of advertising? I will be glad to make the
relevant changes once I understand what is needed because on this topic
I have a clear lack of experience, so I will try to judge what is
reachable based on your inputs.

Thanks,
Miqu=C3=A8l
