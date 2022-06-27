Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E754E55CBDB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiF0ISH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbiF0ISH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:18:07 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590C9CF5;
        Mon, 27 Jun 2022 01:18:05 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B4A1140005;
        Mon, 27 Jun 2022 08:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656317883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8hGrNx+U1GBeTc/kVIhHrEydAqmJcoYpuRDIiSjCuFU=;
        b=pbvVqxrRllgUwOo9uPoF1k0lN3iFoQWCicu7trz5Pu6aa2DJO5KmTMGgr/1EYgIcpYxNkc
        5wtxGvnvrLciaOLmFnyvMv/4/vry1xkQnfyuS6WAo4HCsvdk6KXE8tZRfZIjqgzIX/djko
        nXB+l7f6EQTiV19gFAqkC3OKvp8Cp+i+aE1Tamxgom6i+aVja5OkYyUttExPZixuzydrQh
        z4vj1Pg5E7AH/YLiq1zPa7Q3iMNi9S3HCJK/myenfaToKU66/+BeLtR57Gc5AQxkX/dBPs
        YNwFH4/TGIV9IHFgjoKhH/8Z7dWwc3sbznL+CwKPS1ZB6Z+jo8dwuXMmuyTXMA==
Date:   Mon, 27 Jun 2022 10:17:59 +0200
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
Message-ID: <20220627101759.6ec79a84@xps-13>
In-Reply-To: <CAK-6q+gtAwi7VP_Tj5KE01LWoaV3CEYnMGSwpAQbrgH3v5xkSw@mail.gmail.com>
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
        <20220621082714.78451ee0@xps-13>
        <CAK-6q+gtAwi7VP_Tj5KE01LWoaV3CEYnMGSwpAQbrgH3v5xkSw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Sat, 25 Jun 2022 21:36:05 -0400:

> Hi,
>=20
> On Tue, Jun 21, 2022 at 2:27 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Mon, 20 Jun 2022 21:54:33 -0400:
> > =20
> > > Hi,
> > >
> > > On Mon, Jun 20, 2022 at 5:19 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote:
> > > ... =20
> > > > > =20
> > > > > > - Beacons can only be sent when part of a PAN (PAN ID !=3D 0xff=
ff). =20
> > > > >
> > > > > I guess that 0xffff means no pan is set and if no pan is set ther=
e is no pan? =20
> > > >
> > > > Yes, Table 8-94=E2=80=94MAC PIB attributes states:
> > > >
> > > >         "The identifier of the PAN on which the device is operating=
. If
> > > >         this value is 0xffff, the device is not associated."
> > > > =20
> > >
> > > I am not sure if I understand this correctly but for me sending
> > > beacons means something like "here is a pan which I broadcast around"=
 =20
> >
> > Yes, and any coordinator in a beacon enabled PAN is required to send
> > beacons to advertise the PAN after it associated.
> > =20
> > > and then there is "'device' is not associated". =20
> > =20
>=20
> I think there are several misunderstandings in the used terms in this
> discussion.
>=20
> A "associated" device does not imply an association by using the mac
> commands, it can also be by setting a pan id manually without doing
> anything of communication.

Yes, I am referring to the association procedure here, but I agree it
can be done "statically", that's how it's been done in Linux so far
anyway.

> But this would for me just end in a term "has valid PAN id",
> association is using the mac commands.
>=20
> > FFDs are not supposed to send any beacon if they are not part of a PAN.
> > =20
>=20
> FFD is a device capability (it can run as pan coordinator, which is a
> node with more functions), it is not a term which can be used in
> combination with an instance of a living role in the network
> (coordinator). That's for me what I understand in linux-wpan terms ->
> it's a coordinator interface.

I think we are aligned on the terms.

"Coordinators are not supposed to send any beacon if they are not part
of a PAN." if you prefer. But then while your are not connected to any
network, can we really talk about coordinator? A coordinator, as you
rightfully said, is a living role, so talking about a coordinator that
is not "associated" does not really make sense. Hence the generic term
"device", which I stretched a bit towards "FFD" because RFDs cannot
become coordinators on the network.

Anyway, I think we mean the same thing :)

> > > Is when "associated"
> > > (doesn't matter if set manual or due scan/assoc) does this behaviour
> > > implies "I am broadcasting my pan around, because my panid is !=3D
> > > 0xffff" ? =20
> >
> > I think so, yes. To summarize:
> >
> > Associated:
> > * PAN is !=3D 0xffff
> > * FFD can send beacons
> > Not associated:
> > * PAN is =3D=3D 0xffff
> > * FFD cannot send beacons
> > =20
>=20
> But the user need to explicit enable the "reacting/sending (probably
> depends on active/passive) beacon feature" which indeed sounds fine to
> me.

Absolutely

> > > > > > - The choice of the beacon interval is up to the user, at any m=
oment.
> > > > > > OTHER PARAMETERS =20
> > > > >
> > > > > I would say "okay", there might be an implementation detail about=
 when
> > > > > it's effective.
> > > > > But is this not only required if doing such "passive" mode? =20
> > > >
> > > > The spec states that a coordinator can be in one of these 3 states:
> > > > - Not associated/not in a PAN yet: it cannot send beacons nor answer
> > > >   beacon requests =20
> > >
> > > so this will confirm, it should send beacons if panid !=3D 0xffff (as=
 my
> > > question above)? =20
> >
> > It should only send beacons if in a beacon-enabled PAN. The spec is
> > not very clear about if this is mandatory or not.
> > =20
>=20
> as above. Sounds fine to me to have a setting start/stop for that.

Yes

> > > > - Associated/in a PAN and in this case:
> > > >     - It can be configured to answer beacon requests (for other
> > > >       devices performing active scans)
> > > >     - It can be configured to send beacons "passively" (for other
> > > >       devices performing passive scans)
> > > >
> > > > In practice we will let to the user the choice of sending beacons
> > > > passively or answering to beacon requests or doing nothing by addin=
g a
> > > > fourth possibility:
> > > >     - The device is not configured, it does not send beacons, even =
when
> > > >       receiving a beacon request, no matter its association status.
> > > > =20
> > >
> > > Where is this "user choice"? I mean you handle those answers for
> > > beacon requests in the kernel? =20
> >
> > Without user input, so the default state remains the same as today: do
> > not send beacons + do not answer beacon requests. Then, we created a:
> >
> >         iwpan dev xxx beacons send ...
> >
> > command which, depending on the beacon interval will either send
> > beacons at a given pace (interval < 15) or answer beacon requests
> > otherwise.
> >
> > If the user want's to get back to the initial state (silent device):
> >
> >         iwpan dev xxx beacons stop
> > =20
>=20
> sounds fine.
>=20
> > > > > > - The choice of the channel (page, etc) is free until the devic=
e is
> > > > > >   associated to another, then it becomes fixed.
> > > > > > =20
> > > > >
> > > > > I would say no here, because if the user changes it it's their
> > > > > problem... it's required to be root for doing it and that should =
be
> > > > > enough to do idiot things? =20
> > > >
> > > > That was a proposal to match the spec, but I do agree we can let the
> > > > user handle this, so I won't add any checks regarding channel chang=
es.
> > > > =20
> > >
> > > okay.
> > > =20
> > > > > > ASSOCIATION (to be done)
> > > > > > - Device association/disassociation procedure is requested by t=
he
> > > > > >   user. =20
> > > > >
> > > > > This is similar like wireless is doing with assoc/deassoc to ap. =
=20
> > > >
> > > > Kind of, yes.
> > > > =20
> > >
> > > In the sense of "by the user" you don't mean putting this logic into
> > > user space you want to do it in kernel and implement it as a
> > > netlink-op, the same as wireless is doing? I just want to confirm
> > > that. Of course everything else is different, but from this
> > > perspective it should be realized. =20
> >
> > Yes absolutely, the user would have a command (which I am currently
> > writing) like:
> >
> > iwpan dev xxx associate pan_id yyy coord zzz
> > iwpan dev xxx disassociate device zzz
> > =20
>=20
> Can say more about that if I am seeing code.
>=20
> > Mind the disassociate command which works for parents (you are
> > associated to a device and want to leave the PAN) and also for children
> > (a device is associated to you, and you request it to leave the PAN).
> > =20
> > > > > > - Accepting new associations is up to the user (coordinator onl=
y). =20
> > > > >
> > > > > Again implementation details how this should be realized. =20
> > > >
> > > > Any coordinator can decide whether new associations are possible or
> > > > not. There is no real use case besides this option besides the memo=
ry
> > > > consumption on limited devices. So either we say "we don't care abo=
ut
> > > > that possible limitation on Linux systems" or "let's add a user
> > > > parameter which tells eg. the number of devices allowed to associat=
e".
> > > >
> > > > What's your favorite?
> > > > =20
> > >
> > > Sure there should be a limitation about how many pans should be
> > > allowed, that is somehow the bare minimum which should be there.
> > > I was not quite sure how the user can decide of denied assoc or not,
> > > but this seems out of scope for right now... =20
> >
> > I thought as well about this, I think in the future we might find a way
> > to whitelist or blacklist devices and have these answers being sent
> > automatically by the kernel based on user lists, but this is really an
> > advanced feature and there is currently no use case yet, so I'll go for
> > the netlink op which changes the default number of devices which may
> > associate to a coordinator. =20
>=20
> yes.
>=20
> > > =20
> > > > > > - If the device has no parent (was not associated to any device=
) it is
> > > > > >   PAN coordinator and has additional rights regarding associati=
ons.
> > > > > > =20
> > > > >
> > > > > No idea what a "device' here is, did we not made a difference bet=
ween
> > > > > "coordinator" vs "PAN coordinator" before and PAN is that thing w=
hich
> > > > > does some automatically scan/assoc operation and the other one no=
t? I
> > > > > really have no idea what "device" here means. =20
> > > >
> > > > When implementing association, we need to keep track of the
> > > > parent/child relationship because we may expect coordinators to
> > > > propagate messages from leaf node up to their parent. A device with=
out
> > > > parent is then the PAN coordinator. Any coordinator may advertise t=
he
> > > > PAN and subsequent devices may attach to it, this is creating a tre=
e of
> > > > nodes.
> > > > =20
> > >
> > >
> > > Who is keeping track of this relationship? =20
> >
> > Each device keeps track of:
> > - the parent (the coordinator it associated with, NULL if PAN
> >   coordinator)
> > - a list of devices (FFD or RFD) which successfully associated
> > =20
> > > So we store pans which we
> > > found with a whole "subtree" attached to it? =20
> >
> > This is different, we need basically three lists:
> > - the parent in the PAN
> > - the children (as in the logic of association) in the PAN
> > - the coordinators around which advertise their PAN with beacons (the
> >   PAN can be the same as ours, or different)
> > =20
> > > btw: that sounds similar to me to what RPL is doing..., =20
> >
> > I think RPL stands one level above in the OSI layers? Anyway, my
> > understanding (and this is really something which I grasped by reading
> > papers because the spec lacks a lot of information about it) is that:
> > - the list of PANs is mainly useful for our own initial association
> > - the list of immediate parent/children is to be used by the upper
> >   layer to create routes, but as in the 802.15.4 layer, we are not
> >   supposed to propagate this information besides giving it to the
> >   "next upper layer".
> > =20
>=20
> I am asking the question who stores that, because I don't think this
> should be stored in kernel space.

I think the kernel needs to keep track of the associated devices,
just to be able to give this information in an asynchronous manner to
the user ("next upper layer", whatever) and do very basic checks on
the user inputs to avoid confusing the neighboring devices. Note that
there is no way to "check" with mac commands if an association is
active or not. In practice I agree the kernel itself should not make any
other use of these information.

> A user space daemon will trigger the
> mac commands scan/assoc/deassoc/etc.

Yes

> (kernel job) and get the results of those commands and store it in
> however the user space daemon is handling it. This is from my point
> of view no kernel job, triggering the mac commands in a way that we
> can add all children information, parents, etc, whatever you need to
> fill information in mac commands. Yes, this is a kernel task.

So far I only focused on performing the mac commands and updating the
parent/children list, perhaps that should be improved to also give the
user the opportunity to add an association in the list that has been
performed "statically" (without mac commands, just by setting the PAN
ID to the right value).

> Also I heard that association with a coordinator will allocate in the
> pan a short address, the associated device (which triggered the
> association command) will then set the allocated short address by the
> coordinator, did you take a look into that?

Yes, the association requests contains a bit which means "please give
me a short address". The coordinator that receives the request should
then, if it decides to successfully associate with the device, get a
short address (randomly) and give it to the device by responding with an
association response which contains this address in the payload. The
associating device will then configure itself with this short address,
until it disassociates from the PAN. If the association request "give
me a short address" bit is unset, it means the device does not
want/supports short addressing, the coordinator should answer with the
specific value 0xfffe to notify the device that it will continue using
its extended address only as part of the communications happening
within the PAN. Typically, constrained RFDs might not accept short
addresses.

There is one caveat though, and this is not covered by the spec at all:
the coordinator has no knowledge of the surrounding devices out of its
own range, which could be part of the PAN through another coordinator.
In this case, if there is a short address conflict, there is no
procedure to detect nor correct the situation.

Thanks,
Miqu=C3=A8l
