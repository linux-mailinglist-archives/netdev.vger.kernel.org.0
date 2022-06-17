Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FF754F9EC
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 17:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383056AbiFQPNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 11:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiFQPNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 11:13:04 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5243D220F0;
        Fri, 17 Jun 2022 08:13:01 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5B85DE0007;
        Fri, 17 Jun 2022 15:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655478780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mqCl8NkdZUJBDf6YHShq8zpKvvf1/TSmJAi3WE9vY80=;
        b=AtE+P97LF78Vomd5UEnuWVYEwTTV0+YUzmEgyYfop4NJwh9j1z4ce1X8LdLj1DwTHcf1Jz
        aZnfP/os9XC/sdpeEkYbE+eZhMJ/A5P6G5BvIEuB5kTBHCea6VjMtUxrxxhULNKpSSOUt6
        cwNcXSLkE0hfz5f7vDVwUaJkJSKLCv+LuYWBvtwZv5khjE157RYm+Qq/r2Mt3fDqQCUZ5k
        ijMDCH38Hv7pnQ9j0kCO20KprvyVA+L0GaO3WkP3Vca70h5Nsg4YAjhXE82Vg4rYdEnfzr
        nnFyZoX3NcbmSGc/JYJ4TUpcbtD6tJDjairhXk/lQ9h0A786oMUl26tJnWxhEA==
Date:   Fri, 17 Jun 2022 17:12:56 +0200
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
Message-ID: <20220617171256.2261a99e@xps-13>
In-Reply-To: <CAK-6q+jchHcge2_hMznO6fwx=xoUEpmoZTFYLAUwqM2Ue4Lx-A@mail.gmail.com>
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

Hi Alex,

aahringo@redhat.com wrote on Sat, 11 Jun 2022 08:23:41 -0400:

> Hi,
>=20
> On Thu, Jun 9, 2022 at 11:52 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 8 Jun 2022 21:56:53 -0400:
> > =20
> > > Hi,
> > >
> > > On Wed, Jun 8, 2022 at 9:47 AM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote: =20
> > > >
> > > > Hi Alex,
> > > > =20
> > > > > > 3. coordinator (any $TYPE specific) userspace software
> > > > > >
> > > > > > May the main argument. Some coordinator specific user space dae=
mon
> > > > > > does specific type handling (e.g. hostapd) maybe because some l=
ibrary
> > > > > > is required. It is a pain to deal with changing roles during the
> > > > > > lifetime of an interface and synchronize user space software wi=
th it.
> > > > > > We should keep in mind that some of those handlings will maybe =
be
> > > > > > moved to user space instead of doing it in the kernel. I am fin=
e with
> > > > > > the solution now, but keep in mind to offer such a possibility.
> > > > > >
> > > > > > I think the above arguments are probably the same why wireless =
is
> > > > > > doing something similar and I would avoid running into issues o=
r it's
> > > > > > really difficult to handle because you need to solve other Linu=
x net
> > > > > > architecture handling at first. =20
> > > > >
> > > > > Yep. =20
> > > >
> > > > The spec makes a difference between "coordinator" and "PAN
> > > > coordinator", which one is the "coordinator" interface type suppose=
d to
> > > > picture? I believe we are talking about being a "PAN coordinator", =
but
> > > > I want to be sure that we are aligned on the terms.
> > > > =20
> > >
> > > I think it depends what exactly the difference is. So far I see for
> > > address filtering it should be the same. Maybe this is an interface
> > > option then? =20
> >
> > The difference is that the PAN coordinator can decide to eg. refuse an
> > association, while the other coordinators, are just FFDs with no
> > specific decision making capability wrt the PAN itself, but have some
> > routing capabilities available for the upper layers.
> > =20
>=20
> As I said, if there is a behaviour "it can do xxx, but the spec
> doesn't give more information about it" this smells for me like things
> moving into the user space. This can also be done e.g. by a filtering
> mechanism, _just_ the user will configure how this filtering will look
> like.
>=20
> > The most I look into this, the less likely it is that the Linux stack
> > will drive an RFD. Do you think it's worth supporting them? Because if
> > we don't:
> > * NODE =3D=3D FFD which acts as coordinator
> > * COORD =3D=3D FFD which acts as the PAN coordinator
> > =20
>=20
> I thought that this is a kind of "transceiver type capability " e.g. I
> can imagine if it's only a "RFD" transceiver then you would be e.g.
> not able to set the address filter to coordinator capability. However
> I think that will never happen for a SoftMAC transceiver because why
> not adding a little bit silicon to provide that? People also can
> always have a co-processor and run the transceiver in promiscuous
> mode. E.g. atusb (which makes this transceiver poweful, because we
> have control over the firmware).
>=20
> For me node !=3D coord, because the address filtering is different. As I
> mentioned in another mail "coordinator" vs "PAN coordinator" as
> described is what the user is doing here on top of it.
>=20
> > > > > > > > You are mixing things here with "role in the network" and w=
hat
> > > > > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > > > > different things. =20
> > > > > > >
> > > > > > > I don't think I am, however maybe our vision differ on what an
> > > > > > > interface should be.
> > > > > > > =20
> > > > > > > > You should use those defines and the user needs to create a=
 new
> > > > > > > > interface type and probably have a different extended addre=
ss
> > > > > > > > to act as a coordinator. =20
> > > > > > >
> > > > > > > Can't we just simply switch from coordinator to !coordinator
> > > > > > > (that's what I currently implemented)? Why would we need the =
user
> > > > > > > to create a new interface type *and* to provide a new address?
> > > > > > >
> > > > > > > Note that these are real questions that I am asking myself. I=
'm
> > > > > > > fine adapting my implementation, as long as I get the main id=
ea.
> > > > > > > =20
> > > > > >
> > > > > > See above. =20
> > > > >
> > > > > That's okay for me. I will adapt my implementation to use the
> > > > > interface thing. In the mean time additional details about what a
> > > > > coordinator interface should do differently (above question) is
> > > > > welcome because this is not something I am really comfortable wit=
h. =20
> > > >
> > > > I've updated the implementation to use the IFACE_COORD interface an=
d it
> > > > works fine, besides one question below.
> > > >
> > > > Also, I read the spec once again (soon I'll sleep with it) and
> > > > actually what I extracted is that:
> > > >
> > > > * A FFD, when turned on, will perform a scan, then associate to any=
 PAN
> > > >   it found (algorithm is beyond the spec) or otherwise create a PAN=
 ID
> > > >   and start its own PAN. In both cases, it finishes its setup by
> > > >   starting to send beacons.
> > > > =20
> > >
> > > What does it mean "algorithm is beyond the spec" - build your own? =20
> >
> > This is really what is in the spec, I suppose it means "do what you
> > want in your use case".
> >
> > What I have in mind: when a device is powered on and detects two PANs,
> > well, it can join whichever it wants, but perhaps we should make the
> > decision based on the LQI information we have (the closer the better).
> > =20
>=20
> As I said in the other mail, this smells more and more for me to move
> this handling to user space. The kernel therefore supports operations
> to trigger the necessary steps (scan/assoc/etc.)
>=20
> > > > * A RFD will behave more or less the same, without the PAN creation
> > > >   possibility of course. RFD-RX and RFD-TX are not required to supp=
ort
> > > >   any of that, I'll assume none of the scanning features is suitable
> > > >   for them.
> > > >
> > > > I have a couple of questions however:
> > > >
> > > > - Creating an interface (let's call it wpancoord) out of wpan0 means
> > > >   that two interfaces can be used in different ways and one can use
> > > >   wpan0 as a node while using wpancoord as a PAN coordinator. Is th=
at
> > > >   really allowed? How should we prevent this from happening?
> > > > =20
> > >
> > > When the hardware does not support it, it should be forbidden. As most
> > > transceivers have only one address filter it should be forbidden
> > > then... but there exists a way to indeed have such a setup (which you
> > > probably don't need to think about). It's better to forbid something
> > > now, with the possibility later allowing it. So it should not break
> > > any existing behaviour. =20
> >
> > Done, thanks to the pointer you gave in the other mail.
> > =20
> > > =20
> > > > - Should the device always wait for the user(space) to provide the =
PAN
> > > >   to associate to after the scan procedure right after the
> > > >   add_interface()? (like an information that must be provided prior=
 to
> > > >   set the interface up?)
> > > >
> > > > - How does an orphan FFD should pick the PAN ID for a PAN creation?
> > > >   Should we use a random number? Start from 0 upwards? Start from
> > > >   0xfffd downwards? Should the user always provide it?
> > > > =20
> > >
> > > I think this can be done all with some "fallback strategies" (build
> > > your own) if it's not given as a parameter. =20
> >
> > Ok, In case no PAN is found, and at creation no PAN ID is provided, we
> > can default to 0.
> > =20
>=20
> See me for other mails. (user space job)
>=20
> > > > - Should an FFD be able to create its own PAN on demand? Shall we
> > > >   allow to do that at the creation of the new interface?
> > > > =20
> > >
> > > I thought the spec said "or otherwise"? That means if nothing can be
> > > found, create one? =20
> >
> > Ok, so we assume this is only at startup, fine. But then how to handle
> > the set_pan_id() call? I believe we can forbid any set_pan_id() command
> > to be run while the interface is up. That would ease the handling.
> > Unless I am missing something?
> > =20
>=20
> See my other mails (user space job).

Ok then, I'll go with the following constraints in mind:

SCAN (passive/active) (all devices)
- All devices are allowed to perform scans.
- The user decides when a scan must be performed, there is no
  limitation on when to do a scan (but the interface must be up for
  physical reasons).
PAN ID
- The user is responsible to set the PAN ID.
- Like several other parameters, the PAN ID can only be changed if the
  iface is down. Which means the user might need to do:
	link up > scan > link down > set params > link up=20
BEACON
- Coordinator interfaces only can send beacons.
- Beacons can only be sent when part of a PAN (PAN ID !=3D 0xffff).
- The choice of the beacon interval is up to the user, at any moment.
OTHER PARAMETERS
- The choice of the channel (page, etc) is free until the device is
  associated to another, then it becomes fixed.

ASSOCIATION (to be done)
- Device association/disassociation procedure is requested by the
  user.
- Accepting new associations is up to the user (coordinator only).
- If the device has no parent (was not associated to any device) it is
  PAN coordinator and has additional rights regarding associations.

Thanks,
Miqu=C3=A8l
