Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ED15A4472
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiH2ICb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbiH2ICX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:02:23 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0DA52DEF;
        Mon, 29 Aug 2022 01:02:20 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4F5ABFF80E;
        Mon, 29 Aug 2022 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661760138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbK4FLgVcyuywxCvgkPcyUhJCy21Oc7s3VI4AFor3Ck=;
        b=MNkYgue1pUdXhSskYnt+2akTbgIuOCTNnHANa3dulxuDROZbNiwAMQo7cOaqikPEfABkG9
        V+6qiTZJy/vyy1Du1ksnftZpCQJ1xbQ7qcmFJ5CCkw8zAfjjXfZIH/yg+APnaaLVpr3h/P
        iawsKcE0RIawR7nCNCR1/9Qrtd1ZtizWNzHOoBeQHrUuO0pMbjFR3avkIL54EQMynSCMst
        faoS9j+CykF5ILVGyZRA+8ooPK1JMxFVuwPKmzrk/wzajvrktfWwL09ILG+WRwgdDnFdHW
        0xakHJdZ4gmhHKQ2CP84FnLH/1an4//eZP2J/dINa/VnkgYXglLRnwl+J8A7hg==
Date:   Mon, 29 Aug 2022 10:02:14 +0200
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
Message-ID: <20220829100214.3c6dad63@xps-13>
In-Reply-To: <CAK-6q+gxD0TkXzUVTOiR4-DXwJrFUHKgvccOqF5QMGRjfZQwvw@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 28 Aug 2022 22:52:14 -0400:

> Hi,
>=20
> On Fri, Aug 26, 2022 at 3:54 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Thu, 25 Aug 2022 21:05:09 -0400:
> > =20
> > > Hi,
> > >
> > > On Thu, Aug 25, 2022 at 8:58 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Wed, 24 Aug 2022 17:53:45 -0400:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Wed, Aug 24, 2022 at 9:27 AM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote: =20
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Wed, 24 Aug 2022 08:43:20 -0400:
> > > > > > =20
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Wed, Aug 24, 2022 at 6:21 AM Miquel Raynal <miquel.raynal@=
bootlin.com> wrote:
> > > > > > > ... =20
> > > > > > > >
> > > > > > > > Actually right now the second level is not enforced, and al=
l the
> > > > > > > > filtering levels are a bit fuzzy and spread everywhere in r=
x.c.
> > > > > > > >
> > > > > > > > I'm gonna see if I can at least clarify all of that and onl=
y make
> > > > > > > > coord-dependent the right section because right now a
> > > > > > > > ieee802154_coord_rx() path in ieee802154_rx_handle_packet()=
 does not
> > > > > > > > really make sense given that the level 3 filtering rules ar=
e mostly
> > > > > > > > enforced in ieee802154_subif_frame(). =20
> > > > > > >
> > > > > > > One thing I mentioned before is that we probably like to have=
 a
> > > > > > > parameter for rx path to give mac802154 a hint on which filte=
ring
> > > > > > > level it was received. We don't have that, I currently see th=
at this
> > > > > > > is a parameter for hwsim receiving it on promiscuous level on=
ly and
> > > > > > > all others do third level filtering.
> > > > > > > We need that now, because the promiscuous mode was only used =
for
> > > > > > > sniffing which goes directly into the rx path for monitors. W=
ith scan
> > > > > > > we mix things up here and in my opinion require such a parame=
ter and
> > > > > > > do filtering if necessary. =20
> > > > > >
> > > > > > I am currently trying to implement a slightly different approac=
h. The
> > > > > > core does not know hwsim is always in promiscuous mode, but it =
does
> > > > > > know that it does not check FCS. So the core checks it. This is
> > > > > > level 1 achieved. Then in level 2 we want to know if the core a=
sked
> > > > > > the transceiver to enter promiscuous mode, which, if it did, sh=
ould
> > > > > > not imply more filtering. If the device is working in promiscuo=
us
> > > > > > mode but this was not asked explicitly by the core, we don't re=
ally
> > > > > > care, software filtering will apply anyway.
> > > > > > =20
> > > > >
> > > > > I doubt that I will be happy with this solution, this all sounds =
like
> > > > > "for the specific current behaviour that we support 2 filtering l=
evels
> > > > > it will work", just do a parameter on which 802.15.4 filtering le=
vel
> > > > > it was received and the rx path will check what kind of filter is
> > > > > required and which not.
> > > > > As driver ops start() callback you should say which filtering lev=
el
> > > > > the receive mode should start with.
> > > > > =20
> > > > > > I am reworking the rx path to clarify what is being done and wh=
en,
> > > > > > because I found this part very obscure right now. In the end I =
don't
> > > > > > think we need additional rx info from the drivers. Hopefully my
> > > > > > proposal will clarify why this is (IMHO) not needed.
> > > > > > =20
> > > > >
> > > > > Never looked much in 802.15.4 receive path as it just worked but I
> > > > > said that there might be things to clean up when filtering things=
 on
> > > > > hardware and when on software and I have the feeling we are doing
> > > > > things twice. Sometimes it is also necessary to set some skb fiel=
ds
> > > > > e.g. PACKET_HOST, etc. and I think this is what the most important
> > > > > part of it is there. However, there are probably some tune ups if=
 we
> > > > > know we are in third leveling filtering... =20
> > > >
> > > > Ok, I've done the following.
> > > >
> > > > - Adding a PHY parameter which reflects the actual filtering level =
of
> > > >   the transceiver, the default level is 4 (standard situation, you'=
re =20
> > >
> > > 3? =20
> >
> > Honestly there are only two filtering levels in the normal path and one
> > additional for scanning situations. But the spec mentions 4, so I
> > figured we should use the same naming to avoid confusing people on what
> > "level 3 means, if it's level 3 because level 1 and 2 are identical at
> > PHY level, or level 3 which is the scan filtering as mentioned in the
> > spec?".
> >
> > I used this enum to clarify the amount of filtering that is involved,
> > hopefully it is clear enough. I remember we talked about this already
> > but an unrelated thread, and was not capable of finding it anymore O:-).
> >
> > /** enum ieee802154_filtering_level - Filtering levels applicable to a =
PHY
> >  * @IEEE802154_FILTERING_NONE: No filtering at all, what is received is
> >  *      forwarded to the softMAC
> >  * @IEEE802154_FILTERING_1_FCS: First filtering level, frames with an i=
nvalid
> >  *      FCS should be dropped
> >  * @IEEE802154_FILTERING_2_PROMISCUOUS: Second filtering level, promisc=
uous
> >  *      mode, identical in terms of filtering to the first level at the=
 PHY
> >  *      level, but no ACK should be transmitted automatically and at th=
e MAC
> >  *      level the frame should be forwarded to the upper layer directly
> >  * @IEEE802154_FILTERING_3_SCAN: Third filtering level, enforced during=
 scans,
> >  *      which only forwards beacons
> >  * @IEEE802154_FILTERING_4_FRAME_FIELDS: Fourth filtering level actually
> >  *      enforcing the validity of the content of the frame with various=
 checks
> >  */
> > enum ieee802154_filtering_level {
> >         IEEE802154_FILTERING_NONE,
> >         IEEE802154_FILTERING_1_FCS,
> >         IEEE802154_FILTERING_2_PROMISCUOUS,
> >         IEEE802154_FILTERING_3_SCAN,
> >         IEEE802154_FILTERING_4_FRAME_FIELDS,
> > };
> > =20
>=20
> I am fine to drop all this level number naming at all and we do our
> own filtering definition here, additionally to the mandatory ones.

I can add intermediate filtering levels but I don't know what they are,
you need to give me an exhaustive list of what you have in mind?

> E.g. The SCAN filter can also be implemented in e.g. atusb by using
> other filter modes which are based on 802.15.4 modes (or level
> whatever).

That is actually what I've proposed. The core requests a level of
filtering among the official ones, the PHY driver when it gets the
request does what is possible and adjusts the final filtering level to
what it achieved. The core will then have to handle the missing checks.

> I am currently thinking about if we might need to change something
> here in the default handling of the monitor interface, it should use
> 802.15.4 compatible modes (and this is what we should expect is always
> being supported). IEEE802154_FILTERING_NONE is not a 802.15.4
> filtering mode and is considered to be optional. So the default
> behaviour of the monitor should be IEEE802154_FILTERING_FCS with a
> possibility to have a switch to change to IEEE802154_FILTERING_NONE
> mode if it's supported by the hardware.

That's what I've done, besides that the default filtering level for a
monitor interface is PROMISCUOUS and not FCS. In practice, the
filtering regarding the incoming frames will be exactly the same
between FCS, PROMISCUOUS and SCAN, but in the PROMISCUOUS case we ask
the PHY not to send ACKS (which is not the case of the FCS filtering
level, acks can be automatically sent by the PHY, we don't want that).

> You should also add a note on the filter level/modes which are
> mandatory (means given by the spec) and put their level inside there?
>=20
> > > =20
> > > >   receiving data) but of course if the PHY does not support
> > > > this state (like hwsim) it should overwrite this value by
> > > > setting the actual filtering level (none, in the hwsim case) so
> > > > that the core knows what it receives.
> > > > =20
> > >
> > > ok.
> > > =20
> > > > - I've replaced the specific "do not check the FCS" flag only
> > > > used by hwsim by this filtering level, which gives all the
> > > > information we need.
> > > > =20
> > >
> > > ok.
> > > =20
> > > > - I've added a real promiscuous filtering mode which truly does
> > > > not care about the content of the frame but only checks the FCS
> > > > if not already done by the xceiver.
> > > > =20
> > >
> > > not sure what a "real promiscuous filtering here is" people have
> > > different understanding about it, but 802.15.4 has a definition
> > > for it. =20
> >
> > Promiscuous, by the 802154 spec means: the FCS is good so the
> > content of the received packet must means something, just forward
> > it and let upper layers handle it.
> >
> > Until now there was no real promiscuous mode in the mac NODE rx
> > path. Only monitors would get all the frames (including the ones
> > with a wrong FCS), which is fine because it's a bit out of the
> > spec, so I'm fine with this idea. But otherwise in the NODE/COORD
> > rx path, the FCS should be checked even in promiscuous mode to
> > correctly match the spec.=20
>=20
> If we parse the frame, the FCS should always be checked. The frame
> should _never_ be parsed before it hits the monitor receive path.

Yes.

>=20
> The wording "real promiscuous mode" is in my opinion still debatable,
> however that's not the point here.

I meant "like it is described in the spec".

> > Until now, ieee802154_parse_frame_start() was always called in these
> > path and this would validate the frame headers. I've added a more
> > precise promiscuous mode in the rx patch which skips any additional
> > checks. What happens however is that, if the transceiver disables
> > FCS checks in promiscuous mode, then FCS is not checked at all and
> > this is invalid. With my current implementation, the devices which
> > do not check the FCS might be easily "fixed" by changing their PHY
> > filtering level to "FILTERING_NONE" in the promiscuous callback.
> > =20
> > > You should consider that having monitors, frames with bad fcs
> > > should not be filtered out by hardware. There it comes back what I
> > > said before, the filtering level should be a parameter for start()
> > > driver ops.
> > > =20
> > > > - I've also implemented in software filtering level 4 for most
> > > > regular =20
> > >
> > > 3?
> > > =20
> > > >   data packets. Without changing the default PHY level
> > > > mentioned in the first item above, this additional filtering
> > > > will be skipped which ensures we keep the same behavior of most
> > > > driver. In the case of hwsim however, these filters will become
> > > > active if the MAC is not in promiscuous mode or in scan mode,
> > > > which is actually what people should be expecting.
> > > > =20
> > >
> > > To give feedback to that I need to see code. And please don't
> > > send the whole feature stuff again, just this specific part of
> > > it. Thanks. =20
> >
> > The entire filtering feature is split: there are the basis
> > introduced before the scan, and then after the whole
> > scan+association thing I've introduced additional filtering levels.
> > =20
>=20
> No idea what that means.

In my series, the first patches address the missing bits about
filtering. Then there are patches about the scan. And finally there are
two patches improving the filtering, which are not actually needed
right now for the scan to work.

> > > > Hopefully all this fits what you had in mind.
> > > >
> > > > I have one item left on my current todo list: improving a bit
> > > > the userspace tool with a "monitor" command.
> > > >
> > > > Otherwise the remaining things to do are to discuss the locking
> > > > design which might need to be changed to avoid lockdep issues
> > > > and keep the rtnl locked eg. during a channel change. I still
> > > > don't know how to do that, so it's likely that the right next
> > > > version will not include any change in this area unless
> > > > something pops up. =20
> > >
> > > I try to look at that on the weekend. =20
> >
> > I've had an idea yesterday night which seem to work, I think I can
> > drop the two patches which you disliked regarding discarding the
> > rtnl in the tx path and in hwsim:change_channel(). =20
>=20
> I would like to bring the filtering level question at first upstream.
> If you don't mind.

The additional filtering which I've written has nothing to do with the
scan, and more importantly it uses many new enums/helpers which are
added along the way (by the scan series and the association series).
Hence moving this filtering earlier in the series is a real pain and
would anyway not bring anything really useful at this stage. All the
important filtering changes are already available in the v2 series sent
last week.

Not mentioning, I would really like to move forward on the scan series
as it's been in the air for quite some time.

Thanks,
Miqu=C3=A8l
