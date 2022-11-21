Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B814631C51
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiKUJFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiKUJFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:05:47 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521BD654C2;
        Mon, 21 Nov 2022 01:05:45 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A3D111BF209;
        Mon, 21 Nov 2022 09:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669021543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4hAN+SNqsNB3+xxqfAaMfB/0OkYfYcBVnfWzoz8nW0=;
        b=DG7X6vhXCFa/BErQYfsgDzmRe1H4f2oAdONKuJ+aNtcjff9QYB7VGcOaMF50Lg2Z5MpPJJ
        tBfJJKIVrdBfb6btAzFiO+jyc7L33EtXpYmYFTeWCbHrXhIbV8hXhzeoA+caXFIKJGWLX4
        t7fufe7HuBm8s3roRpFYyq9ueSZPHdfyVvZf6HZ1Fs54ln6nt7DcwPYH9ZLHjndJD1VM2E
        brWtUOIGFnYDBQNqHyxwFUq9w/p8SamC8lHNXSADf6/DV9Tbk9uagJ7JA+9cTOGt5vrY06
        b1zWPhXxOSRHkOtdnanXeH93wfZ7EIOrulrLtmLh7/VxL+y9JhN81H2EiDms6Q==
Date:   Mon, 21 Nov 2022 10:05:39 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH wpan-next 1/3] ieee802154: Advertize coordinators
 discovery
Message-ID: <20221121100539.75e13069@xps-13>
In-Reply-To: <CAK-6q+jJKoFy359_Pd4_d+EfqLw4PTdG4F7H4u+URD=UKu9k6w@mail.gmail.com>
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
        <20221102151915.1007815-2-miquel.raynal@bootlin.com>
        <CAK-6q+iSzRyDDiNusXiRWvUsS5dSS5bSzAtNjSLTt6kgaxtbHg@mail.gmail.com>
        <20221118230443.2e5ba612@xps-13>
        <CAK-6q+jJKoFy359_Pd4_d+EfqLw4PTdG4F7H4u+URD=UKu9k6w@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Sun, 20 Nov 2022 19:57:31 -0500:

> Hi,
>=20
> On Fri, Nov 18, 2022 at 5:04 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sun, 6 Nov 2022 21:01:35 -0500:
> > =20
> > > Hi,
> > >
> > > On Wed, Nov 2, 2022 at 11:20 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Let's introduce the basics for advertizing discovered PANs and
> > > > coordinators, which is:
> > > > - A new "scan" netlink message group.
> > > > - A couple of netlink command/attribute.
> > > > - The main netlink helper to send a netlink message with all the
> > > >   necessary information to forward the main information to the user.
> > > >
> > > > Two netlink attributes are proactively added to support future UWB
> > > > complex channels, but are not actually used yet.
> > > >
> > > > Co-developed-by: David Girault <david.girault@qorvo.com>
> > > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/net/cfg802154.h   |  20 +++++++
> > > >  include/net/nl802154.h    |  44 ++++++++++++++
> > > >  net/ieee802154/nl802154.c | 121 ++++++++++++++++++++++++++++++++++=
++++
> > > >  net/ieee802154/nl802154.h |   6 ++
> > > >  4 files changed, 191 insertions(+)
> > > >
> > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > index e1481f9cf049..8d67d9ed438d 100644
> > > > --- a/include/net/cfg802154.h
> > > > +++ b/include/net/cfg802154.h
> > > > @@ -260,6 +260,26 @@ struct ieee802154_addr {
> > > >         };
> > > >  };
> > > >
> > > > +/**
> > > > + * struct ieee802154_coord_desc - Coordinator descriptor
> > > > + * @coord: PAN ID and coordinator address
> > > > + * @page: page this coordinator is using
> > > > + * @channel: channel this coordinator is using
> > > > + * @superframe_spec: SuperFrame specification as received
> > > > + * @link_quality: link quality indicator at which the beacon was r=
eceived
> > > > + * @gts_permit: the coordinator accepts GTS requests
> > > > + * @node: list item
> > > > + */
> > > > +struct ieee802154_coord_desc {
> > > > +       struct ieee802154_addr *addr; =20
> > >
> > > Why is this a pointer? =20
> >
> > No reason anymore, I've changed this member to be a regular structure.
> > =20
>=20
> ok.
>=20
> > > =20
> > > > +       u8 page;
> > > > +       u8 channel;
> > > > +       u16 superframe_spec;
> > > > +       u8 link_quality;
> > > > +       bool gts_permit;
> > > > +       struct list_head node;
> > > > +};
> > > > +
> > > >  struct ieee802154_llsec_key_id {
> > > >         u8 mode;
> > > >         u8 id;
> > > > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > > > index 145acb8f2509..cfe462288695 100644
> > > > --- a/include/net/nl802154.h
> > > > +++ b/include/net/nl802154.h
> > > > @@ -58,6 +58,9 @@ enum nl802154_commands {
> > > >
> > > >         NL802154_CMD_SET_WPAN_PHY_NETNS,
> > > >
> > > > +       NL802154_CMD_NEW_COORDINATOR,
> > > > +       NL802154_CMD_KNOWN_COORDINATOR,
> > > > + =20
> > >
> > > NEW is something we never saw before and KNOWN we already saw before?
> > > I am not getting that when I just want to maintain a list in the user
> > > space and keep them updated, but I think we had this discussion
> > > already or? Currently they do the same thing, just the command is
> > > different. The user can use it to filter NEW and KNOWN? Still I am not
> > > getting it why there is not just a start ... event, event, event ....
> > > end. and let the user decide if it knows that it's new or old from its
> > > perspective. =20
> >
> > Actually we already discussed this once and I personally liked more to
> > handle this in the kernel, but you seem to really prefer letting the
> > user space device whether or not the beacon is a new one or not, so
> > I've updated both the kernel side and the userspace side to act like
> > this.
> > =20
>=20
> I thought there was some problem about when the "scan-op" is running
> and there could be the case that the discovered PANs are twice there,
> but this looks more like handling UAPI features as separate new and
> old ones? I can see that there can be a need for the first case?

I don't think there is a problem handling this on one side or the
other, both should work identically. I've done the change anyway in v2
:)

> > > >         /* add new commands above here */
> > > >
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > > @@ -133,6 +136,8 @@ enum nl802154_attrs {
> > > >         NL802154_ATTR_PID,
> > > >         NL802154_ATTR_NETNS_FD,
> > > >
> > > > +       NL802154_ATTR_COORDINATOR,
> > > > +
> > > >         /* add attributes here, update the policy in nl802154.c */
> > > >
> > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > > @@ -218,6 +223,45 @@ enum nl802154_wpan_phy_capability_attr {
> > > >         NL802154_CAP_ATTR_MAX =3D __NL802154_CAP_ATTR_AFTER_LAST - 1
> > > >  };
> > > >
> > > > +/**
> > > > + * enum nl802154_coord - Netlink attributes for a coord
> > > > + *
> > > > + * @__NL802154_COORD_INVALID: invalid
> > > > + * @NL802154_COORD_PANID: PANID of the coordinator (2 bytes)
> > > > + * @NL802154_COORD_ADDR: coordinator address, (8 bytes or 2 bytes)
> > > > + * @NL802154_COORD_CHANNEL: channel number, related to @NL802154_C=
OORD_PAGE (u8)
> > > > + * @NL802154_COORD_PAGE: channel page, related to @NL802154_COORD_=
CHANNEL (u8)
> > > > + * @NL802154_COORD_PREAMBLE_CODE: Preamble code used when the beac=
on was received,
> > > > + *     this is PHY dependent and optional (u8)
> > > > + * @NL802154_COORD_MEAN_PRF: Mean PRF used when the beacon was rec=
eived,
> > > > + *     this is PHY dependent and optional (u8)
> > > > + * @NL802154_COORD_SUPERFRAME_SPEC: superframe specification of th=
e PAN (u16)
> > > > + * @NL802154_COORD_LINK_QUALITY: signal quality of beacon in unspe=
cified units,
> > > > + *     scaled to 0..255 (u8)
> > > > + * @NL802154_COORD_GTS_PERMIT: set to true if GTS is permitted on =
this PAN
> > > > + * @NL802154_COORD_PAYLOAD_DATA: binary data containing the raw da=
ta from the
> > > > + *     frame payload, (only if beacon or probe response had data)
> > > > + * @NL802154_COORD_PAD: attribute used for padding for 64-bit alig=
nment
> > > > + * @NL802154_COORD_MAX: highest coordinator attribute
> > > > + */
> > > > +enum nl802154_coord {
> > > > +       __NL802154_COORD_INVALID,
> > > > +       NL802154_COORD_PANID,
> > > > +       NL802154_COORD_ADDR,
> > > > +       NL802154_COORD_CHANNEL,
> > > > +       NL802154_COORD_PAGE,
> > > > +       NL802154_COORD_PREAMBLE_CODE, =20
> > >
> > > Interesting, if you do a scan and discover pans and others answers I
> > > would think you would see only pans on the same preamble. How is this
> > > working? =20
> >
> > Yes this is how it is working, you only see PANs on one preamble at a
> > time. That's why we need to tell on which preamble we received the
> > beacon.
> > =20
>=20
> But then I don't know how you want to change the preamble while
> scanning?

Just to be sure: here we are talking about reporting the beacons that
were received and the coordinators they advertise. Which means we
_need_ to tell the user on which preamble code it was, but we don't yet
consider any preamble code changes here on the PHY.

> I know there are registers for changing the preamble and I
> thought that is a vendor specific option. However I am not an expert
> to judge if it's needed or not, but somehow curious how it's working.

I guess this is a problem that we must delegate to the drivers, very
much like channel changes, no?

> NOTE: that the preamble is so far I know (and makes sense for me)
> _always_ filtered on PHY side.

Yes, I guess so.

>=20
> > > =20
> > > > +       NL802154_COORD_MEAN_PRF,
> > > > +       NL802154_COORD_SUPERFRAME_SPEC,
> > > > +       NL802154_COORD_LINK_QUALITY, =20
> > >
> > > not against it to have it, it's fine. I just think it is not very
> > > useful. A way to dump all LQI values with some timestamp and having
> > > something in user space to collect stats and do some heuristic may be
> > > better? =20
> >
> > Actually I really like seeing this in the event logs in userspace, so if
> > you don't mind I'll keep this parameter. It can safely be ignored by the
> > userspace anyway, so I guess it does not hurt.
> > =20
>=20
> ok.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
