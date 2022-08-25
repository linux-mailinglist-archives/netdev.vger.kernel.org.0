Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845275A0BCD
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiHYIqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiHYIqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:46:13 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE29A7226;
        Thu, 25 Aug 2022 01:46:11 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D24DCFF80E;
        Thu, 25 Aug 2022 08:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661417169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bahjZcarBioPWMNdzDPpo1kw6IWEXf4GMLqcWxmA3kE=;
        b=QIwwHfGyw5BPvquaPtSG63fOxLLy3LM0p29M2QSo2NkXn4P8pohaS2uYwPC3SMTT15fevc
        51N3JcVvE8vKx1TA8R+yz9ZV4QrWpUVc8xc3edVr46rdkqOg0vY8rHwc4qheNjmEtaq3qn
        843H2g9rIm5Uymbt4EEvwj9ubGFSObomHH+QWuYYBJun8jmKoX8eO7W1gBUQKqo+wK7nLS
        PiS68GrZVXiNW84QhuK7QffGqYpIXbPN04/Y/UlpIAyyGaJCU9v6JnhMOf6vfaXC4lqB/i
        yee72sXKXssycV9DcMC6hGlBWWu4/C1uAt2naAZBwGBUZEoWlMszwabCCcnzfg==
Date:   Thu, 25 Aug 2022 10:46:07 +0200
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
Message-ID: <20220825104607.6274e906@xps-13>
In-Reply-To: <CAK-6q+gnkz-Yf=39Ss361dDsmzhJErJCAq9FaKK3m5nRih=VDA@mail.gmail.com>
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
        <CAK-6q+gnkz-Yf=39Ss361dDsmzhJErJCAq9FaKK3m5nRih=VDA@mail.gmail.com>
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

aahringo@redhat.com wrote on Wed, 24 Aug 2022 21:02:29 -0400:

> Hi,
>=20
> On Wed, Aug 24, 2022 at 5:53 PM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Wed, Aug 24, 2022 at 9:27 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:
> > > =20
> > > > Hi,
> > > >
> > > > On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
> > > > ... =20
> > > > >
> > > > > Actually right now the second level is not enforced, and all the
> > > > > filtering levels are a bit fuzzy and spread everywhere in rx.c.
> > > > >
> > > > > I'm gonna see if I can at least clarify all of that and only make
> > > > > coord-dependent the right section because right now a
> > > > > ieee802154_coord_rx() path in ieee802154_rx_handle_packet() does =
not
> > > > > really make sense given that the level 3 filtering rules are most=
ly
> > > > > enforced in ieee802154_subif_frame(). =20
> > > >
> > > > One thing I mentioned before is that we probably like to have a
> > > > parameter for rx path to give mac802154 a hint on which filtering
> > > > level it was received. We don't have that, I currently see that this
> > > > is a parameter for hwsim receiving it on promiscuous level only and
> > > > all others do third level filtering.
> > > > We need that now, because the promiscuous mode was only used for
> > > > sniffing which goes directly into the rx path for monitors. With sc=
an
> > > > we mix things up here and in my opinion require such a parameter and
> > > > do filtering if necessary. =20
> > >
> > > I am currently trying to implement a slightly different approach. The
> > > core does not know hwsim is always in promiscuous mode, but it does
> > > know that it does not check FCS. So the core checks it. This is
> > > level 1 achieved. Then in level 2 we want to know if the core asked
> > > the transceiver to enter promiscuous mode, which, if it did, should
> > > not imply more filtering. If the device is working in promiscuous
> > > mode but this was not asked explicitly by the core, we don't really
> > > care, software filtering will apply anyway.
> > > =20
> >
> > I doubt that I will be happy with this solution, this all sounds like
> > "for the specific current behaviour that we support 2 filtering levels
> > it will work", just do a parameter on which 802.15.4 filtering level
> > it was received and the rx path will check what kind of filter is =20
>=20
> I think a per phy field is enough here because the receive path should
> be synchronized with changing filtering level on hardware. No need for
> per receive path parameter.

Ok, I prefer the per-PHY field rather than the per-received-skb info.

I will add a parameter in the start field set to LEVEL3, drivers are
free to change this (like hwsim) if they can't.

I will add also the major filtering rules in the rx path but we will
actually use them only if the hw filtering level is lower than what is
requested, as you said.

>=20
> "If the device is working in promiscuous mode but this was not asked
> explicitly by the core, we don't really care, software filtering will
> apply anyway."
> I don't understand this sentence, we should not filter on things which
> the hardware is doing for us. I mean okay I'm fine to handle it now
> just to check twice, but in the future there might be more "we don't
> need to filter this because we know the hardware is doing it" patches.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
