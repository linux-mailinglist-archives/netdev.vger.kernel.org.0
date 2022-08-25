Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8575E5A1143
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241450AbiHYM6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241096AbiHYM6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:58:37 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A77880359;
        Thu, 25 Aug 2022 05:58:35 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ADC9AC0002;
        Thu, 25 Aug 2022 12:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661432314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kaHYmMiQZE+TL7D8x2KLrmR70elOYdPqmPIh0JwWaag=;
        b=bZHOGGLk/XnLXCJ8qIAB+kAlLREPejZFzLeEkTAROe54asuy4Eh1Tr1pfXl8I5fxRzps/C
        FkpNenF6Eql15/2x7OjsJDQU1og5gW24kAETpu2cCCmJI57fkbXf+9+64nM8n7PGpT5hbZ
        qnsnY6abPLTu2eB9pDkj0s+hk3dO9YPMua5DI6Ep7qFWaIiFuyIjnPe90ZUGkkoQYY+wZ5
        epbDOoQGTylXC6RIWjzyPHLH9MaxnfUOLtR/DLjxn2K006ZKyTbA1vnqp4733NkyCm41hg
        ICl7rQ1MYJHfbMWbEAdw9toVyoPKrXsqI1mpvmaWgbWlICnokXyeSvc+i3dTDw==
Date:   Thu, 25 Aug 2022 14:58:31 +0200
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
Message-ID: <20220825145831.1105cb54@xps-13>
In-Reply-To: <CAK-6q+itA0C4zPAq5XGKXgCHW5znSFeB-YDMp3uB9W-kLV6WaA@mail.gmail.com>
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

Hi Alexander,

aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:53:45 -0400:

> Hi,
>=20
> On Wed, Aug 24, 2022 at 9:27 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:
> > =20
> > > Hi,
> > >
> > > On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote:
> > > ... =20
> > > >
> > > > Actually right now the second level is not enforced, and all the
> > > > filtering levels are a bit fuzzy and spread everywhere in rx.c.
> > > >
> > > > I'm gonna see if I can at least clarify all of that and only make
> > > > coord-dependent the right section because right now a
> > > > ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does not
> > > > really make sense given that the level 3 filtering rules are mostly
> > > > enforced in ieee802154_subif_frame(). =20
> > >
> > > One thing I mentioned before is that we probably like to have a
> > > parameter for rx path to give mac802154 a hint on which filtering
> > > level it was received. We don't have that, I currently see that this
> > > is a parameter for hwsim receiving it on promiscuous level only and
> > > all others do third level filtering.
> > > We need that now, because the promiscuous mode was only used for
> > > sniffing which goes directly into the rx path for monitors. With scan
> > > we mix things up here and in my opinion require such a parameter and
> > > do filtering if necessary. =20
> >
> > I am currently trying to implement a slightly different approach. The
> > core does not know hwsim is always in promiscuous mode, but it does
> > know that it does not check FCS. So the core checks it. This is
> > level 1 achieved. Then in level 2 we want to know if the core asked
> > the transceiver to enter promiscuous mode, which, if it did, should
> > not imply more filtering. If the device is working in promiscuous
> > mode but this was not asked explicitly by the core, we don't really
> > care, software filtering will apply anyway.
> > =20
>=20
> I doubt that I will be happy with this solution, this all sounds like
> "for the specific current behaviour that we support 2 filtering levels
> it will work", just do a parameter on which 802.15.4 filtering level
> it was received and the rx path will check what kind of filter is
> required and which not.
> As driver ops start() callback you should say which filtering level
> the receive mode should start with.
>=20
> > I am reworking the rx path to clarify what is being done and when,
> > because I found this part very obscure right now. In the end I don't
> > think we need additional rx info from the drivers. Hopefully my
> > proposal will clarify why this is (IMHO) not needed.
> > =20
>=20
> Never looked much in 802.15.4 receive path as it just worked but I
> said that there might be things to clean up when filtering things on
> hardware and when on software and I have the feeling we are doing
> things twice. Sometimes it is also necessary to set some skb fields
> e.g. PACKET_HOST, etc. and I think this is what the most important
> part of it is there. However, there are probably some tune ups if we
> know we are in third leveling filtering...

Ok, I've done the following.

- Adding a PHY parameter which reflects the actual filtering level of
  the transceiver, the default level is 4 (standard situation, you're
  receiving data) but of course if the PHY does not support this state
  (like hwsim) it should overwrite this value by setting the actual
  filtering level (none, in the hwsim case) so that the core knows what
  it receives.

- I've replaced the specific "do not check the FCS" flag only used by
  hwsim by this filtering level, which gives all the information we
  need.

- I've added a real promiscuous filtering mode which truly does not
  care about the content of the frame but only checks the FCS if not
  already done by the xceiver.

- I've also implemented in software filtering level 4 for most regular
  data packets. Without changing the default PHY level mentioned in the
  first item above, this additional filtering will be skipped which
  ensures we keep the same behavior of most driver. In the case of hwsim
  however, these filters will become active if the MAC is not in
  promiscuous mode or in scan mode, which is actually what people
  should be expecting.

Hopefully all this fits what you had in mind.

I have one item left on my current todo list: improving a bit the
userspace tool with a "monitor" command.

Otherwise the remaining things to do are to discuss the locking design
which might need to be changed to avoid lockdep issues and keep the
rtnl locked eg. during a channel change. I still don't know how to do
that, so it's likely that the right next version will not include any
change in this area unless something pops up.

Thanks,
Miqu=C3=A8l
