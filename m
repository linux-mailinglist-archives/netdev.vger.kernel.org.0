Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA10552AF9
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 08:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345535AbiFUG1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 02:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345379AbiFUG1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 02:27:21 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9263D18B2B;
        Mon, 20 Jun 2022 23:27:18 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 84B98200002;
        Tue, 21 Jun 2022 06:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655792837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NQXWhc5kzh0eeIOgRX/Ac4AnTukJ5AgS4lMy0NH/6rE=;
        b=SJDpeAzvvG25wPF6sivA6UszQlZESJ2ldABBph/fWlYMVNj6xIHiZHOynFnVyPhCuoAEYv
        TY+UqXU2ZOFYUcPkiEuBJOvvRA4Zyi3iEHiJGpVDUfs/NMF4xn4oCdlsql6munzWcIWA9O
        Kla2LV1UbjEpzf7LB8hJwbIe6qataRq3uqUC9tFt43eAbCWTqpXPekjDW6RUHJDsCJlewU
        FiUe91iQ1xdPapJWfPY5Q8N6B5irnf9erxrdNNErDVfVXrqSEvvjTSeimb/LLIms/dJu31
        yiXY1GQfEvTYEEM3mvwhwogPhJJjuBwX1CW4Cj9Xy/SUWRoy8Ida3wxvdQn2Lg==
Date:   Tue, 21 Jun 2022 08:27:14 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220621082714.78451ee0@xps-13>
In-Reply-To: <CAK-6q+jR00MD+W02AAH8P5xG7hUD-x8NEnOG_W3mifj=6ybBzg@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
        <20220608154749.06b62d59@xps-13>
        <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
        <20220609175217.21a9acee@xps-13>
        <CAK-6q+jchHcge2_hMznO6fwx=xoUEpmoZTFYLAUwqM2Ue4Lx-A@mail.gmail.com>
        <20220617171256.2261a99e@xps-13>
        <CAK-6q+i-77wXoTN0vXi4s-sv20d13x+2fMpw4TB9dDyXAhjOGA@mail.gmail.com>
        <20220620111922.51189382@xps-13>
        <CAK-6q+jR00MD+W02AAH8P5xG7hUD-x8NEnOG_W3mifj=6ybBzg@mail.gmail.com>
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

aahringo@redhat.com wrote on Mon, 20 Jun 2022 21:54:33 -0400:

> Hi,
>=20
> On Mon, Jun 20, 2022 at 5:19 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> ...
> > > =20
> > > > - Beacons can only be sent when part of a PAN (PAN ID !=3D 0xffff).=
 =20
> > >
> > > I guess that 0xffff means no pan is set and if no pan is set there is=
 no pan? =20
> >
> > Yes, Table 8-94=E2=80=94MAC PIB attributes states:
> >
> >         "The identifier of the PAN on which the device is operating. If
> >         this value is 0xffff, the device is not associated."
> > =20
>=20
> I am not sure if I understand this correctly but for me sending
> beacons means something like "here is a pan which I broadcast around"

Yes, and any coordinator in a beacon enabled PAN is required to send
beacons to advertise the PAN after it associated.

> and then there is "'device' is not associated".

FFDs are not supposed to send any beacon if they are not part of a PAN.

> Is when "associated"
> (doesn't matter if set manual or due scan/assoc) does this behaviour
> implies "I am broadcasting my pan around, because my panid is !=3D
> 0xffff" ?

I think so, yes. To summarize:

Associated:
* PAN is !=3D 0xffff
* FFD can send beacons
Not associated:
* PAN is =3D=3D 0xffff
* FFD cannot send beacons

> > > > - The choice of the beacon interval is up to the user, at any momen=
t.
> > > > OTHER PARAMETERS =20
> > >
> > > I would say "okay", there might be an implementation detail about when
> > > it's effective.
> > > But is this not only required if doing such "passive" mode? =20
> >
> > The spec states that a coordinator can be in one of these 3 states:
> > - Not associated/not in a PAN yet: it cannot send beacons nor answer
> >   beacon requests =20
>=20
> so this will confirm, it should send beacons if panid !=3D 0xffff (as my
> question above)?

It should only send beacons if in a beacon-enabled PAN. The spec is
not very clear about if this is mandatory or not.

> > - Associated/in a PAN and in this case:
> >     - It can be configured to answer beacon requests (for other
> >       devices performing active scans)
> >     - It can be configured to send beacons "passively" (for other
> >       devices performing passive scans)
> >
> > In practice we will let to the user the choice of sending beacons
> > passively or answering to beacon requests or doing nothing by adding a
> > fourth possibility:
> >     - The device is not configured, it does not send beacons, even when
> >       receiving a beacon request, no matter its association status.
> > =20
>=20
> Where is this "user choice"? I mean you handle those answers for
> beacon requests in the kernel?

Without user input, so the default state remains the same as today: do
not send beacons + do not answer beacon requests. Then, we created a:

	iwpan dev xxx beacons send ...

command which, depending on the beacon interval will either send
beacons at a given pace (interval < 15) or answer beacon requests
otherwise.

If the user want's to get back to the initial state (silent device):

	iwpan dev xxx beacons stop

> > > > - The choice of the channel (page, etc) is free until the device is
> > > >   associated to another, then it becomes fixed.
> > > > =20
> > >
> > > I would say no here, because if the user changes it it's their
> > > problem... it's required to be root for doing it and that should be
> > > enough to do idiot things? =20
> >
> > That was a proposal to match the spec, but I do agree we can let the
> > user handle this, so I won't add any checks regarding channel changes.
> > =20
>=20
> okay.
>=20
> > > > ASSOCIATION (to be done)
> > > > - Device association/disassociation procedure is requested by the
> > > >   user. =20
> > >
> > > This is similar like wireless is doing with assoc/deassoc to ap. =20
> >
> > Kind of, yes.
> > =20
>=20
> In the sense of "by the user" you don't mean putting this logic into
> user space you want to do it in kernel and implement it as a
> netlink-op, the same as wireless is doing? I just want to confirm
> that. Of course everything else is different, but from this
> perspective it should be realized.

Yes absolutely, the user would have a command (which I am currently
writing) like:

iwpan dev xxx associate pan_id yyy coord zzz
iwpan dev xxx disassociate device zzz

Mind the disassociate command which works for parents (you are
associated to a device and want to leave the PAN) and also for children
(a device is associated to you, and you request it to leave the PAN).

> > > > - Accepting new associations is up to the user (coordinator only). =
=20
> > >
> > > Again implementation details how this should be realized. =20
> >
> > Any coordinator can decide whether new associations are possible or
> > not. There is no real use case besides this option besides the memory
> > consumption on limited devices. So either we say "we don't care about
> > that possible limitation on Linux systems" or "let's add a user
> > parameter which tells eg. the number of devices allowed to associate".
> >
> > What's your favorite?
> > =20
>=20
> Sure there should be a limitation about how many pans should be
> allowed, that is somehow the bare minimum which should be there.
> I was not quite sure how the user can decide of denied assoc or not,
> but this seems out of scope for right now...

I thought as well about this, I think in the future we might find a way
to whitelist or blacklist devices and have these answers being sent
automatically by the kernel based on user lists, but this is really an
advanced feature and there is currently no use case yet, so I'll go for
the netlink op which changes the default number of devices which may
associate to a coordinator.
>=20
> > > > - If the device has no parent (was not associated to any device) it=
 is
> > > >   PAN coordinator and has additional rights regarding associations.
> > > > =20
> > >
> > > No idea what a "device' here is, did we not made a difference between
> > > "coordinator" vs "PAN coordinator" before and PAN is that thing which
> > > does some automatically scan/assoc operation and the other one not? I
> > > really have no idea what "device" here means. =20
> >
> > When implementing association, we need to keep track of the
> > parent/child relationship because we may expect coordinators to
> > propagate messages from leaf node up to their parent. A device without
> > parent is then the PAN coordinator. Any coordinator may advertise the
> > PAN and subsequent devices may attach to it, this is creating a tree of
> > nodes.
> > =20
>=20
>=20
> Who is keeping track of this relationship?

Each device keeps track of:
- the parent (the coordinator it associated with, NULL if PAN
  coordinator)
- a list of devices (FFD or RFD) which successfully associated

> So we store pans which we
> found with a whole "subtree" attached to it?

This is different, we need basically three lists:
- the parent in the PAN
- the children (as in the logic of association) in the PAN
- the coordinators around which advertise their PAN with beacons (the
  PAN can be the same as ours, or different)

> btw: that sounds similar to me to what RPL is doing...,

I think RPL stands one level above in the OSI layers? Anyway, my
understanding (and this is really something which I grasped by reading
papers because the spec lacks a lot of information about it) is that:
- the list of PANs is mainly useful for our own initial association
- the list of immediate parent/children is to be used by the upper
  layer to create routes, but as in the 802.15.4 layer, we are not
  supposed to propagate this information besides giving it to the
  "next upper layer".

Thanks,
Miqu=C3=A8l
