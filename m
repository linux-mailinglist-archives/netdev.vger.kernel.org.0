Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFD8551424
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbiFTJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbiFTJUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:20:02 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222DA7665;
        Mon, 20 Jun 2022 02:19:26 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6FFAB1C0010;
        Mon, 20 Jun 2022 09:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655716765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SN8tX8iU1/7slm1miQCJDYLKpnj2pwBlshk+No+lnNo=;
        b=RHUboIy57EcFqj2NUnwUn5C8p5w0o0VqpotsT0953aYLQhMsGxVGgq8wHkJc9mUxnqgbUn
        zNRoOnCQJTra1LycWibO3GNEN3VOsMdhtJ5TCsUhY2TMmbFeO+VaFMb8Ih3jDrwfACoH+/
        QlsXNoRyjWrQZxkzsryfoA1P1GzOChYjeoP7slFVIYpqSjvnpmaXzymMqxAb9+Ks6ti3zm
        rvB4zxj4fu8ZclieZvgaT6CzQAFOS4oK6a1s7w2TqBrZZ1+9uVLwdirRAQzJJ4X06SSXmO
        tceKzYRzbX7k+UpPQ3hqmPz/j71R6SR1jlV0w7VO3tHD/Vi6DrxzjMvuJ9RoFg==
Date:   Mon, 20 Jun 2022 11:19:22 +0200
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
Message-ID: <20220620111922.51189382@xps-13>
In-Reply-To: <CAK-6q+i-77wXoTN0vXi4s-sv20d13x+2fMpw4TB9dDyXAhjOGA@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 19 Jun 2022 20:13:08 -0400:

> Hi,
>=20
> On Fri, Jun 17, 2022 at 11:13 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Hi Alex,
> >
> > aahringo@redhat.com wrote on Sat, 11 Jun 2022 08:23:41 -0400:
> > =20
> > > Hi,
> > >
> > > On Thu, Jun 9, 2022 at 11:52 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Wed, 8 Jun 2022 21:56:53 -0400:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Wed, Jun 8, 2022 at 9:47 AM Miquel Raynal <miquel.raynal@bootl=
in.com> wrote: =20
> > > > > >
> > > > > > Hi Alex,
> > > > > > =20
> > > > > > > > 3. coordinator (any $TYPE specific) userspace software
> > > > > > > >
> > > > > > > > May the main argument. Some coordinator specific user space=
 daemon
> > > > > > > > does specific type handling (e.g. hostapd) maybe because so=
me library
> > > > > > > > is required. It is a pain to deal with changing roles durin=
g the
> > > > > > > > lifetime of an interface and synchronize user space softwar=
e with it.
> > > > > > > > We should keep in mind that some of those handlings will ma=
ybe be
> > > > > > > > moved to user space instead of doing it in the kernel. I am=
 fine with
> > > > > > > > the solution now, but keep in mind to offer such a possibil=
ity.
> > > > > > > >
> > > > > > > > I think the above arguments are probably the same why wirel=
ess is
> > > > > > > > doing something similar and I would avoid running into issu=
es or it's
> > > > > > > > really difficult to handle because you need to solve other =
Linux net
> > > > > > > > architecture handling at first. =20
> > > > > > >
> > > > > > > Yep. =20
> > > > > >
> > > > > > The spec makes a difference between "coordinator" and "PAN
> > > > > > coordinator", which one is the "coordinator" interface type sup=
posed to
> > > > > > picture? I believe we are talking about being a "PAN coordinato=
r", but
> > > > > > I want to be sure that we are aligned on the terms.
> > > > > > =20
> > > > >
> > > > > I think it depends what exactly the difference is. So far I see f=
or
> > > > > address filtering it should be the same. Maybe this is an interfa=
ce
> > > > > option then? =20
> > > >
> > > > The difference is that the PAN coordinator can decide to eg. refuse=
 an
> > > > association, while the other coordinators, are just FFDs with no
> > > > specific decision making capability wrt the PAN itself, but have so=
me
> > > > routing capabilities available for the upper layers.
> > > > =20
> > >
> > > As I said, if there is a behaviour "it can do xxx, but the spec
> > > doesn't give more information about it" this smells for me like things
> > > moving into the user space. This can also be done e.g. by a filtering
> > > mechanism, _just_ the user will configure how this filtering will look
> > > like.
> > > =20
> > > > The most I look into this, the less likely it is that the Linux sta=
ck
> > > > will drive an RFD. Do you think it's worth supporting them? Because=
 if
> > > > we don't:
> > > > * NODE =3D=3D FFD which acts as coordinator
> > > > * COORD =3D=3D FFD which acts as the PAN coordinator
> > > > =20
> > >
> > > I thought that this is a kind of "transceiver type capability " e.g. I
> > > can imagine if it's only a "RFD" transceiver then you would be e.g.
> > > not able to set the address filter to coordinator capability. However
> > > I think that will never happen for a SoftMAC transceiver because why
> > > not adding a little bit silicon to provide that? People also can
> > > always have a co-processor and run the transceiver in promiscuous
> > > mode. E.g. atusb (which makes this transceiver poweful, because we
> > > have control over the firmware).
> > >
> > > For me node !=3D coord, because the address filtering is different. A=
s I
> > > mentioned in another mail "coordinator" vs "PAN coordinator" as
> > > described is what the user is doing here on top of it.
> > > =20
> > > > > > > > > > You are mixing things here with "role in the network" a=
nd what
> > > > > > > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > > > > > > different things. =20
> > > > > > > > >
> > > > > > > > > I don't think I am, however maybe our vision differ on wh=
at an
> > > > > > > > > interface should be.
> > > > > > > > > =20
> > > > > > > > > > You should use those defines and the user needs to crea=
te a new
> > > > > > > > > > interface type and probably have a different extended a=
ddress
> > > > > > > > > > to act as a coordinator. =20
> > > > > > > > >
> > > > > > > > > Can't we just simply switch from coordinator to !coordina=
tor
> > > > > > > > > (that's what I currently implemented)? Why would we need =
the user
> > > > > > > > > to create a new interface type *and* to provide a new add=
ress?
> > > > > > > > >
> > > > > > > > > Note that these are real questions that I am asking mysel=
f. I'm
> > > > > > > > > fine adapting my implementation, as long as I get the mai=
n idea.
> > > > > > > > > =20
> > > > > > > >
> > > > > > > > See above. =20
> > > > > > >
> > > > > > > That's okay for me. I will adapt my implementation to use the
> > > > > > > interface thing. In the mean time additional details about wh=
at a
> > > > > > > coordinator interface should do differently (above question) =
is
> > > > > > > welcome because this is not something I am really comfortable=
 with. =20
> > > > > >
> > > > > > I've updated the implementation to use the IFACE_COORD interfac=
e and it
> > > > > > works fine, besides one question below.
> > > > > >
> > > > > > Also, I read the spec once again (soon I'll sleep with it) and
> > > > > > actually what I extracted is that:
> > > > > >
> > > > > > * A FFD, when turned on, will perform a scan, then associate to=
 any PAN
> > > > > >   it found (algorithm is beyond the spec) or otherwise create a=
 PAN ID
> > > > > >   and start its own PAN. In both cases, it finishes its setup by
> > > > > >   starting to send beacons.
> > > > > > =20
> > > > >
> > > > > What does it mean "algorithm is beyond the spec" - build your own=
? =20
> > > >
> > > > This is really what is in the spec, I suppose it means "do what you
> > > > want in your use case".
> > > >
> > > > What I have in mind: when a device is powered on and detects two PA=
Ns,
> > > > well, it can join whichever it wants, but perhaps we should make the
> > > > decision based on the LQI information we have (the closer the bette=
r).
> > > > =20
> > >
> > > As I said in the other mail, this smells more and more for me to move
> > > this handling to user space. The kernel therefore supports operations
> > > to trigger the necessary steps (scan/assoc/etc.)
> > > =20
> > > > > > * A RFD will behave more or less the same, without the PAN crea=
tion
> > > > > >   possibility of course. RFD-RX and RFD-TX are not required to =
support
> > > > > >   any of that, I'll assume none of the scanning features is sui=
table
> > > > > >   for them.
> > > > > >
> > > > > > I have a couple of questions however:
> > > > > >
> > > > > > - Creating an interface (let's call it wpancoord) out of wpan0 =
means
> > > > > >   that two interfaces can be used in different ways and one can=
 use
> > > > > >   wpan0 as a node while using wpancoord as a PAN coordinator. I=
s that
> > > > > >   really allowed? How should we prevent this from happening?
> > > > > > =20
> > > > >
> > > > > When the hardware does not support it, it should be forbidden. As=
 most
> > > > > transceivers have only one address filter it should be forbidden
> > > > > then... but there exists a way to indeed have such a setup (which=
 you
> > > > > probably don't need to think about). It's better to forbid someth=
ing
> > > > > now, with the possibility later allowing it. So it should not bre=
ak
> > > > > any existing behaviour. =20
> > > >
> > > > Done, thanks to the pointer you gave in the other mail.
> > > > =20
> > > > > =20
> > > > > > - Should the device always wait for the user(space) to provide =
the PAN
> > > > > >   to associate to after the scan procedure right after the
> > > > > >   add_interface()? (like an information that must be provided p=
rior to
> > > > > >   set the interface up?)
> > > > > >
> > > > > > - How does an orphan FFD should pick the PAN ID for a PAN creat=
ion?
> > > > > >   Should we use a random number? Start from 0 upwards? Start fr=
om
> > > > > >   0xfffd downwards? Should the user always provide it?
> > > > > > =20
> > > > >
> > > > > I think this can be done all with some "fallback strategies" (bui=
ld
> > > > > your own) if it's not given as a parameter. =20
> > > >
> > > > Ok, In case no PAN is found, and at creation no PAN ID is provided,=
 we
> > > > can default to 0.
> > > > =20
> > >
> > > See me for other mails. (user space job)
> > > =20
> > > > > > - Should an FFD be able to create its own PAN on demand? Shall =
we
> > > > > >   allow to do that at the creation of the new interface?
> > > > > > =20
> > > > >
> > > > > I thought the spec said "or otherwise"? That means if nothing can=
 be
> > > > > found, create one? =20
> > > >
> > > > Ok, so we assume this is only at startup, fine. But then how to han=
dle
> > > > the set_pan_id() call? I believe we can forbid any set_pan_id() com=
mand
> > > > to be run while the interface is up. That would ease the handling.
> > > > Unless I am missing something?
> > > > =20
> > >
> > > See my other mails (user space job). =20
> >
> > Ok then, I'll go with the following constraints in mind:
> >
> > SCAN (passive/active) (all devices)
> > - All devices are allowed to perform scans.
> > - The user decides when a scan must be performed, there is no
> >   limitation on when to do a scan (but the interface must be up for
> >   physical reasons). =20
>=20
> Yes, I think it should not have anything to do with interface
> limitation.... it needs to have an operating phy.

Yes

> However I can say
> more to this when I see code (but please don't provide me with any
> github repository, I mean here on the mailing list and not a more than
> 15 patches stack, Thanks.) You probably want to say on an user level
> "run scan for iface $FOO" but this is just to make it simpler.
>=20
> > PAN ID
> > - The user is responsible to set the PAN ID. =20
>=20
> This is currently the case and I don't see a reason to change it.
>=20
> > - Like several other parameters, the PAN ID can only be changed if the
> >   iface is down. Which means the user might need to do:
> >         link up > scan > link down > set params > link up =20
>=20
> Yes, changing this behaviour will break other things.
>=20
> > BEACON
> > - Coordinator interfaces only can send beacons. =20
>=20
> okay.
>=20
> > - Beacons can only be sent when part of a PAN (PAN ID !=3D 0xffff). =20
>=20
> I guess that 0xffff means no pan is set and if no pan is set there is no =
pan?

Yes, Table 8-94=E2=80=94MAC PIB attributes states:

	"The identifier of the PAN on which the device is operating. If
	this value is 0xffff, the device is not associated."

> > - The choice of the beacon interval is up to the user, at any moment.
> > OTHER PARAMETERS =20
>=20
> I would say "okay", there might be an implementation detail about when
> it's effective.
> But is this not only required if doing such "passive" mode?

The spec states that a coordinator can be in one of these 3 states:
- Not associated/not in a PAN yet: it cannot send beacons nor answer
  beacon requests
- Associated/in a PAN and in this case:
    - It can be configured to answer beacon requests (for other
      devices performing active scans)
    - It can be configured to send beacons "passively" (for other
      devices performing passive scans)

In practice we will let to the user the choice of sending beacons
passively or answering to beacon requests or doing nothing by adding a
fourth possibility:
    - The device is not configured, it does not send beacons, even when
      receiving a beacon request, no matter its association status.

> > - The choice of the channel (page, etc) is free until the device is
> >   associated to another, then it becomes fixed.
> > =20
>=20
> I would say no here, because if the user changes it it's their
> problem... it's required to be root for doing it and that should be
> enough to do idiot things?

That was a proposal to match the spec, but I do agree we can let the
user handle this, so I won't add any checks regarding channel changes.

> > ASSOCIATION (to be done)
> > - Device association/disassociation procedure is requested by the
> >   user. =20
>=20
> This is similar like wireless is doing with assoc/deassoc to ap.

Kind of, yes.

> > - Accepting new associations is up to the user (coordinator only). =20
>=20
> Again implementation details how this should be realized.

Any coordinator can decide whether new associations are possible or
not. There is no real use case besides this option besides the memory
consumption on limited devices. So either we say "we don't care about
that possible limitation on Linux systems" or "let's add a user
parameter which tells eg. the number of devices allowed to associate".

What's your favorite?

> > - If the device has no parent (was not associated to any device) it is
> >   PAN coordinator and has additional rights regarding associations.
> > =20
>=20
> No idea what a "device' here is, did we not made a difference between
> "coordinator" vs "PAN coordinator" before and PAN is that thing which
> does some automatically scan/assoc operation and the other one not? I
> really have no idea what "device" here means.

When implementing association, we need to keep track of the
parent/child relationship because we may expect coordinators to
propagate messages from leaf node up to their parent. A device without
parent is then the PAN coordinator. Any coordinator may advertise the
PAN and subsequent devices may attach to it, this is creating a tree of
nodes.

The sentence about the additional rights is wrong, however, the spec
does not state anything about it, it was a misinterpretation on my side.

Thanks,
Miqu=C3=A8l
