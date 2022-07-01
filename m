Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7363E5627D4
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 02:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiGAAuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 20:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiGAAuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 20:50:22 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D095A2BB10;
        Thu, 30 Jun 2022 17:50:17 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CC2301BF208;
        Fri,  1 Jul 2022 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656636616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/kcoYTnNnzhOWM1MqioMlk5A13WMz4E/rfcuidnbwM=;
        b=n4jR9AFNGXEIcqmpmuKLGfcqPewrc0SE4fMpGLI6YGQteq7SjAkfhfU6JxazhbW5UBbfQ2
        WlwJMqtWz7V5ggm2MSuKr2sK2wGERLBMZU2F08sYFOak2m8h9fKm6RK05KhtBUIoNzqb5+
        bx5cus+sI98JpS52YReI5TjrKBOSCFgPU4LP6TPGGoO4QKW2xwmFQJ4PoMS+aa1PHX4Ddb
        gtMPbKwTzxa/1qoNtSellDPedY5/PSvd/pVXWKDSYVXdmU0jAOSzoWzEp6IC94l5gWtdoR
        sUWSyitr+CTX0rJnbw5/t/3hhuQYLl5avdqYCG6xHhG9Hb2PsOQcsuZIjCYnaw==
Date:   Fri, 1 Jul 2022 02:50:12 +0200
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
Subject: Re: [PATCH wpan-next v3 2/4] net: ieee802154: Add support for inter
 PAN management
Message-ID: <20220701025012.5dd38c81@xps-13>
In-Reply-To: <CAK-6q+gR-+9K2LtwwVQQMmMcmmkG399jUgyd-X3Nj8xh0y+jBQ@mail.gmail.com>
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
        <20220620134018.62414-3-miquel.raynal@bootlin.com>
        <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
        <20220627104303.5392c7f6@xps-13>
        <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
        <20220628095821.36811c5c@xps-13>
        <CAK-6q+g=Bbj7gS5a+fSqCsB9n=xrZK-z0-Rg9dn9yFK5xpZsvw@mail.gmail.com>
        <20220630101416.4dc42f29@xps-13>
        <CAK-6q+gR-+9K2LtwwVQQMmMcmmkG399jUgyd-X3Nj8xh0y+jBQ@mail.gmail.com>
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

aahringo@redhat.com wrote on Thu, 30 Jun 2022 19:27:49 -0400:

> Hi,
>=20
> On Thu, Jun 30, 2022 at 4:14 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Wed, 29 Jun 2022 21:40:14 -0400:
> > =20
> > > Hi,
> > >
> > > On Tue, Jun 28, 2022 at 3:58 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Mon, 27 Jun 2022 21:32:08 -0400:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Mon, Jun 27, 2022 at 4:43 AM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote: =20
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Sat, 25 Jun 2022 22:29:08 -0400:
> > > > > > =20
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
> > > > > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > > > > >
> > > > > > > > Let's introduce the basics for defining PANs:
> > > > > > > > - structures defining a PAN
> > > > > > > > - helpers for PAN registration
> > > > > > > > - helpers discarding old PANs
> > > > > > > > =20
> > > > > > >
> > > > > > > I think the whole pan management can/should be stored in user=
 space by
> > > > > > > a daemon running in background. =20
> > > > > >
> > > > > > We need both, and currently:
> > > > > > - while the scan is happening, the kernel saves all the discove=
red PANs
> > > > > > - the kernel PAN list can be dumped (and also flushed) asynchro=
nously by
> > > > > >   the userspace
> > > > > >
> > > > > > IOW the userspace is responsible of keeping its own list of PAN=
s in
> > > > > > sync with what the kernel discovers, so at any moment it can as=
k the
> > > > > > kernel what it has in memory, it can be done during a scan or a=
fter. It
> > > > > > can request a new scan to update the entries, or flush the kern=
el list.
> > > > > > The scan operation is always requested by the user anyway, it's=
 not
> > > > > > something happening in the background.
> > > > > > =20
> > > > >
> > > > > I don't see what advantage it has to keep the discovered pan in t=
he
> > > > > kernel. You can do everything with a start/stop/pan discovered ev=
ent. =20
> > > >
> > > > I think the main reason is to be much more user friendly. Keeping t=
rack
> > > > of the known PANs in the kernel matters because when you start work=
ing
> > > > with 802.15.4 you won't blindly use a daemon (if there is any) and =
will
> > > > use test apps like iwpan which are stateless. Re-doing a scan on de=
mand
> > > > just takes ages (from seconds to minutes, depending on the beacon
> > > > order).
> > > > =20
> > >
> > > I can see that things should work "out-of the box" and we are already
> > > doing it by manual setting pan_id, etc. However, doing it in an
> > > automatic way there exists a lot of "interpretation" about how you
> > > want to handle it (doesn't matter if this is what the spec says or
> > > not)... moving it to user space will offload it to the user.
> > > =20
> > > > Aside from this non technical reason, I also had in mind to retrieve
> > > > values gathered from the beacons (and stored in the PAN descriptors=
) to
> > > > know more about the devices when eg. listing associations, like
> > > > registering the short address of a coordinator. I don't yet know how
> > > > useful this is TBH.
> > > > =20
> > > > > It also has more advantages as you can look for a specific pan and
> > > > > stop afterwards. At the end the daemon has everything that the ke=
rnel
> > > > > also has, as you said it's in sync.
> > > > > =20
> > > > > > > This can be a network manager as it
> > > > > > > listens to netlink events as "detect PAN xy" and stores it and
> > > > > > > offers it in their list to associate with it. =20
> > > > > >
> > > > > > There are events produced, yes. But really, this is not somethi=
ng we
> > > > > > actually need. The user requests a scan over a given range, whe=
n the
> > > > > > scan is over it looks at the list and decides which PAN it
> > > > > > wants to associate with, and through which coordinator (95% of =
the
> > > > > > scenarii).
> > > > > > =20
> > > > >
> > > > > This isn't either a kernel job to decide which pan it will be
> > > > > associated with. =20
> > > >
> > > > Yes, "it looks at the list and decides" referred to "the user".
> > > > =20
> > > > > > > We need somewhere to draw a line and I guess the line is "Is =
this
> > > > > > > information used e.g. as any lookup or something in the hot p=
ath", I
> > > > > > > don't see this currently... =20
> > > > > >
> > > > > > Each PAN descriptor is like 20 bytes, so that's why I don't fee=
l back
> > > > > > keeping them, I think it's easier to be able to serve the list =
of PANs
> > > > > > upon request rather than only forwarding events and not being a=
ble to
> > > > > > retrieve the list a second time (at least during the developmen=
t).
> > > > > > =20
> > > > >
> > > > > This has nothing to do with memory.
> > > > > =20
> > > > > > Overall I feel like this part is still a little bit blurry beca=
use it
> > > > > > has currently no user, perhaps I should send the next series wh=
ich
> > > > > > actually makes the current series useful.
> > > > > > =20
> > > > >
> > > > > Will it get more used than caching entries in the kernel for user
> > > > > space? Please also no in-kernel association feature. =20
> > > >
> > > > I am aligned on this.
> > > > =20
> > >
> > > I am sorry I am not sure what that means. =20
> >
> > I was referring to the "no in-kernel association feature".
> >
> > There is however one situation which I _had_ to be handled in the
> > kernel: other devices asking for being associated or disassociated. In
> > the case of the disassociation, the receiving device is only notified
> > and cannot refuse the disassociation. For the association however,
> > the device receiving the association request has to make a decision.
> > There are three possible outcomes:
> > - accepting
> > - refusing because the PAN is at capacity
> > - refusing because the device is blacklisted =20
>=20
> Why not move this decision to the user as well? The kernel will wait
> for the reason? This isn't required to be fast and the decision may
> depend on the current pan management...

I've opted out for the simplest option, which is allowing X devices
being associated, X being manageable by the user. For now I'll keep
this very simple approach, I propose we add this filtering feature
later?

> > For now I've only implemented the first reason, because it's much
> > easier and only requires a maximum device number variable, set by the
> > user. For the second reason, it requires handling a
> > whitelist/blacklist, I don't plan to implement this for now, but that
> > should not impact the rest of the code. I'll let that to other
> > developers, or future-me, perhaps :-). Anyhow, you can kick-out devices
> > at any time anyway if needed with a disassociation notification
> > controlled by the user.
> > =20
> > > > > We can maybe agree to that point to put it under
> > > > > IEEE802154_NL802154_EXPERIMENTAL config, as soon as we have some
> > > > > _open_ user space program ready we will drop this feature again...
> > > > > this program will show that there is no magic about it. =20
> > > >
> > > > Yeah, do you want to move all the code scan/beacon/pan/association =
code
> > > > under EXPERIMENTAL sections? Or is it just the PAN management logic=
? =20
> > >
> > > Yes, why not. But as I can see there exists two categories of
> > > introducing your netlink api:
> > >
> > > 1. API candidates which are very likely to become stable
> > > 2. API candidates which we want to remove when we have a user
> > > replacement for it (will probably never go stable)
> > >
> > > The 2. should be defining _after_ the 1. In the "big" netlink API
> > > enums of EXPERIMENTAL sections. =20
> >
> > Yeah, got it.
> > =20
> > > Also you should provide for 2. some kind of ifdef/functions dummy/etc.
> > > that it's easy to remove from the kernel when we have a user
> > > replacement for it.
> > > I hope that is fine for everybody.
> > >
> > > I try to find solutions here, I don't see a reason for putting this
> > > pan management into the kernel... whereas I appreciate the effort
> > > which is done here and will not force you to write some user space
> > > software that does this job. From my point of view I can't accept this
> > > functionality in the kernel "yet". =20
> >
> > I've already spent a couple of days reworking all that part, I've
> > dropped most of the in-kernel PAN management, which means:
> > - when a new coordinator gets discovered (beacon received), if the mac
> >   was scanning then it calls a generic function from the cfg layer to
> >   advertise this pan.
> > - the cfg layer will send a NL message to the user with all the
> >   important information
> > - BUT the cfg layer will also keep in memory the beacon information for
> >   the time of the scan (only), to avoid polluting the user with the same
> >   information over and over again, this seems a necessary step to me,
> >   because otherwise if you track on the same channel two coordinators
> >   not emitting at the same pace, you might end up with 100 user
> >   notifications, for just 2 devices. I think this is the kernel duty to
> >   filter out identical beacons.
> > =20
>=20
> Okay, I am sure if somebody complains about such kernel behaviour and
> has a good argument to switch back... we still can do it.

Great!

>=20
> > I _will_ send a v4, including the scanning part this time by the end of
> > the week, I need to settle everything down, ensure it still works and
> > clean the branch.
> > =20
>=20
> ok.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
