Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEC769A77D
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBQIxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjBQIxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:53:00 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E95311ED;
        Fri, 17 Feb 2023 00:52:57 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 11A711BF203;
        Fri, 17 Feb 2023 08:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676623976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yj6ZTdoTs2OpbtD0sShAiX7nc7AFw9v61v50HL93pJo=;
        b=kN0xvP0GNqL+WV23fM7yZb3z9ypDYDZGhTm8PFHJBUFXkV9tMO0WGbANKuFsktt5gbRTgq
        eE77ydYd9JORtvAgNeDmOwmmS6MToQSbmVlKZDvxkhUIw4F63mkG+e8ChEiExZ+Pn0aF5P
        PIDJgzIzpQw9x0SRdAB9AZ03k3wPsteHJVMFvTEAtW0MO9PeeX3/z7tNHALSJfK+D3MRfD
        mjZ/k5DaZLZCDb+rlpkLo5UAJVRnDkhj7Z/TcixK6ilPTSYDKET8eeuIIY5GVsDGaC0KMS
        /bWkEWQJYISYLZFyLitc5w9YitvreW+9/DJ2fYPzOSn2bI+GgqyPUPFjYH2cQw==
Date:   Fri, 17 Feb 2023 09:52:51 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] ieee802154: Add support for user scanning
 requests
Message-ID: <20230217095251.59c324d0@xps-13>
In-Reply-To: <CAK-6q+i-QiDpFptFPwDv05mwURGVHzmABcEn2z2L9xakQwgw+w@mail.gmail.com>
References: <20221129160046.538864-1-miquel.raynal@bootlin.com>
        <20221129160046.538864-2-miquel.raynal@bootlin.com>
        <CAK-6q+iwqVx+6qQ-ctynykdrbN+SHxzk91gQCSdYCUD-FornZA@mail.gmail.com>
        <20230206101235.0371da87@xps-13>
        <CAK-6q+jav4yJD3MsOssyBobg1zGqKC5sm-xCRYX1SCkH9GhmHw@mail.gmail.com>
        <20230210182129.77c1084d@xps-13>
        <CAK-6q+jLKo1bLBie_xYZyZdyjNB_M8JvxDfr77RQAY9WYcQY8w@mail.gmail.com>
        <20230213111553.0dcce5c2@xps-13>
        <CAK-6q+jP55MaB-_ZbRHKESgEb-AW+kN3bU2SMWMtkozvoyfAwA@mail.gmail.com>
        <20230214152849.5c3d196b@xps-13>
        <CAK-6q+i-QiDpFptFPwDv05mwURGVHzmABcEn2z2L9xakQwgw+w@mail.gmail.com>
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

aahringo@redhat.com wrote on Thu, 16 Feb 2023 23:46:42 -0500:

> Hi,
>=20
> On Tue, Feb 14, 2023 at 9:28 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Tue, 14 Feb 2023 08:51:12 -0500:
> > =20
> > > Hi,
> > >
> > > On Mon, Feb 13, 2023 at 5:16 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > > =20
> > > > > > > > > > +static int nl802154_trigger_scan(struct sk_buff *skb, =
struct genl_info *info)
> > > > > > > > > > +{
> > > > > > > > > > +       struct cfg802154_registered_device *rdev =3D in=
fo->user_ptr[0];
> > > > > > > > > > +       struct net_device *dev =3D info->user_ptr[1];
> > > > > > > > > > +       struct wpan_dev *wpan_dev =3D dev->ieee802154_p=
tr;
> > > > > > > > > > +       struct wpan_phy *wpan_phy =3D &rdev->wpan_phy;
> > > > > > > > > > +       struct cfg802154_scan_request *request;
> > > > > > > > > > +       u8 type;
> > > > > > > > > > +       int err;
> > > > > > > > > > +
> > > > > > > > > > +       /* Monitors are not allowed to perform scans */
> > > > > > > > > > +       if (wpan_dev->iftype =3D=3D NL802154_IFTYPE_MON=
ITOR)
> > > > > > > > > > +               return -EPERM; =20
> > > > > > > > >
> > > > > > > > > btw: why are monitors not allowed? =20
> > > > > > > >
> > > > > > > > I guess I had the "active scan" use case in mind which of c=
ourse does
> > > > > > > > not work with monitors. Maybe I can relax this a little bit=
 indeed,
> > > > > > > > right now I don't remember why I strongly refused scans on =
monitors. =20
> > > > > > >
> > > > > > > Isn't it that scans really work close to phy level? Means in =
this case
> > > > > > > we disable mostly everything of MAC filtering on the transcei=
ver side.
> > > > > > > Then I don't see any reasons why even monitors can't do anyth=
ing, they
> > > > > > > also can send something. But they really don't have any speci=
fic
> > > > > > > source address set, so long addresses are none for source add=
resses, I
> > > > > > > don't see any problem here. They also don't have AACK handlin=
g, but
> > > > > > > it's not required for scan anyway... =20
> > > > > >
> > > > > > I think I remember why I did not want to enable scans on monito=
rs: we
> > > > > > actually change the filtering level to "scan", which is very
> > > > > > different to what a monitor is supposed to receive, which means=
 in scan
> > > > > > mode a monitor would no longer receive all what it is supposed =
to
> > > > > > receive. Nothing that cannot be workaround'ed by software, prob=
ably,
> > > > > > but I believe it is safer right now to avoid introducing potent=
ial
> > > > > > regressions. So I will just change the error code and still ref=
use
> > > > > > scans on monitor interfaces for now, until we figure out if it's
> > > > > > actually safe or not (and if we really want to allow it).
> > > > > > =20
> > > > >
> > > > > Okay, for scan yes we tell them to be in scan mode and then the
> > > > > transceiver can filter whatever it delivers to the next level whi=
ch is
> > > > > necessary for filtering scan mac frames only. AACK handling is
> > > > > disabled for scan mode for all types !=3D MONITORS.
> > > > >
> > > > > For monitors we mostly allow everything and AACK is _always_ disa=
bled.
> > > > > The transceiver filter is completely disabled for at least what l=
ooks
> > > > > like a 802.15.4 MAC header (even malformed). There are some frame
> > > > > length checks which are necessary for specific hardware because
> > > > > otherwise they would read out the frame buffer. For me it can sti=
ll
> > > > > feed the mac802154 stack for scanning (with filtering level as wh=
at
> > > > > the monitor sets to, but currently our scan filter is equal to the
> > > > > monitor filter mode anyway (which probably can be changed in
> > > > > future?)). So in my opinion the monitor can do both -> feed the s=
can
> > > > > mac802154 deliver path and the packet layer. And I also think tha=
t on
> > > > > a normal interface type the packet layer should be feeded by those
> > > > > frames as well and do not hit the mac802154 layer scan path only.=
 =20
> > > >
> > > > Actually that would be an out-of-spec situation, here is a quote of
> > > > chapter "6.3.1.3 Active and passive channel scan"
> > > >
> > > >         During an active or passive scan, the MAC sublayer shall
> > > >         discard all frames received over the PHY data service that =
are
> > > >         not Beacon frames.
> > > > =20
> > >
> > > Monitor interfaces are not anything that the spec describes, it is
> > > some interface type which offers the user (mostly over AF_PACKET raw
> > > socket) full phy level access with the _default_ options. I already
> > > run user space stacks (for hacking/development only) on monitor
> > > interfaces to connect with Linux 802.15.4 interfaces, e.g. see [0]
> > > (newer came upstream, somewhere I have also a 2 years old updated
> > > version, use hwsim not fakelb). =20
> >
> > :-)
> > =20
> > >
> > > In other words, by default it should bypass 802.15.4 MAC and it still
> > > conforms with your spec, just that it is in user space. However, there
> > > exists problems to do that, but it kind of works for the most use
> > > cases. I said here by default because some people have different use
> > > cases of what they want to do in the kernel. e.g. encryption (so users
> > > only get encrypted frames, etc.) We don't support that but we can,
> > > same for doing a scan. It probably requires just more mac802154 layer
> > > filtering.
> > >
> > > There are enough examples in wireless that they do "crazy" things and
> > > you can do that only with SoftMAC transceivers because it uses more
> > > software parts like mac80211 and HardMAC transceivers only do what the
> > > spec says and delivers it to the next layer. Some of them have more
> > > functionality I guess, but then it depends on driver implementation
> > > and a lot of other things.
> > >
> > > Monitors also act as a sniffer device, but you _could_ also send
> > > frames out and then the fun part begins. =20
> >
> > Yes, you're right, it's up to us to allow monitor actions.
> > =20
> > > > I don't think this is possible to do anyway on devices with a single
> > > > hardware filter setting?
> > > > =20
> > >
> > > On SoftMAC it need to support a filtering level where we can disable
> > > all filtering and get 802.15.4 MAC frames like it's on air (even
> > > without non valid checksum, but we simply don't care if the
> > > driver/transceiver does not support it we will always confirm it is
> > > correct again until somebody comes around and say "oh we can do FCS
> > > level then mac802154 does not need to check on this because it is
> > > always correct")... This is currently the NONE filtering level I
> > > think? =20
> >
> > But right now we ask for the "scan" filtering, which kind of discards
> > most frames. Would you like a special config for monitors, like
> > receiving everything on each channel you jump on? Or shall we stick to
> > only transmitting beacon frames during a scan on a monitor interface?
> > =20
>=20
> good question...
>=20
> > I guess it's rather easy to handle in each case. Just let me know what
> > you prefer. I think I have a small preference for the scan filtering
> > level, but I'm open.
> > =20
>=20
> I would capture and deliver everything to the user.. if the user does
> a scan while doing whatever the user is doing with the monitor
> interface at this time, the user need to live with the consequences
> and you need to be root (okay probably every wireless manager will
> give the normal user access to it, but still you need to know what you
> are doing)

Fair enough.

> > > For HardMAC it is more complicated; they don't do that, they do the
> > > "scan" operation on their transceiver and you can dump the result and
> > > probably never forward any beacon related frames? (I had this question
> > > once when Michael Richardson replied). =20
> >
> > Yes, in this case we'll have to figure out something else...
> > =20
>=20
> ok, I am curious. Probably it is very driver/device specific but yea,
> HardMAC needs to at least support what 802.15.4 says, the rest is
> optional and result in -ENOTSUPP?

TBH this is still a gray area in my mental model. I'm not sure what
these devices will really offer in terms of interfaces.

Thanks,
Miqu=C3=A8l
