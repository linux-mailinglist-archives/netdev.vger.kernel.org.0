Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709525635A6
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiGAOeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiGAOdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:33:42 -0400
Received: from relay12.mail.gandi.net (relay12.mail.gandi.net [IPv6:2001:4b98:dc4:8::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010643B017;
        Fri,  1 Jul 2022 07:29:08 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DEB4F200012;
        Fri,  1 Jul 2022 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZUrtA5TTAouY2hXQhPedVeEatLdZz4mEiwVWFUBUAd0=;
        b=hLUCWVBoOxitvph9/I7M2Qf/NQszjGTfFQSFM621AZEM/i/eVyqrFOpBAjRcgBVIIl4SuN
        sBnMBr1fyFnJaznCU6JH8B22mPqCkcpMtpksYgZdPTwCJs5p6P2h/s/Gh+4c/mBufYZsdF
        fqKsvrYprYNlgeIJj5BaRlePTE0+WEKwfkCwGAjxUGBT8lPvbkOMbOSsMgjC5w3oKwRoxf
        CBd9wK5KNKNyt7xCFJyxOn2rrNmNsFVJpHf3ggI7iu0qYS8YUGub5VhblOLV5qZLBiVK0+
        9RJdlgmsB9fUOgh4tocFGHZwEmpQPHXBvnyaHw9BmThW1V1IerhQOw0s6t+P0g==
Date:   Fri, 1 Jul 2022 16:29:00 +0200
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
Message-ID: <20220701162900.1cec25dd@xps-13>
In-Reply-To: <CAK-6q+g4=jrO+kGVyimNi1HCC_PShL0fwitCuTRv4-5LBKJuKw@mail.gmail.com>
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
        <20220620134018.62414-3-miquel.raynal@bootlin.com>
        <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
        <20220627104303.5392c7f6@xps-13>
        <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
        <20220628095821.36811c5c@xps-13>
        <CAK-6q+g=Bbj7gS5a+fSqCsB9n=xrZK-z0-Rg9dn9yFK5xpZsvw@mail.gmail.com>
        <20220630101416.4dc42f29@xps-13>
        <CAK-6q+gR-+9K2LtwwVQQMmMcmmkG399jUgyd-X3Nj8xh0y+jBQ@mail.gmail.com>
        <20220701025012.5dd38c81@xps-13>
        <CAK-6q+g4=jrO+kGVyimNi1HCC_PShL0fwitCuTRv4-5LBKJuKw@mail.gmail.com>
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

aahringo@redhat.com wrote on Fri, 1 Jul 2022 08:23:32 -0400:

> Hi,
>=20
> On Thu, Jun 30, 2022 at 8:50 PM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Thu, 30 Jun 2022 19:27:49 -0400:
> > =20
> > > Hi,
> > >
> > > On Thu, Jun 30, 2022 at 4:14 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Wed, 29 Jun 2022 21:40:14 -0400:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Tue, Jun 28, 2022 at 3:58 AM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote: =20
> > > > > >
> > > > > > Hi Alexander,
> > > > > >
> > > > > > aahringo@redhat.com wrote on Mon, 27 Jun 2022 21:32:08 -0400:
> > > > > > =20
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Mon, Jun 27, 2022 at 4:43 AM Miquel Raynal <miquel.raynal@=
bootlin.com> wrote: =20
> > > > > > > >
> > > > > > > > Hi Alexander,
> > > > > > > >
> > > > > > > > aahringo@redhat.com wrote on Sat, 25 Jun 2022 22:29:08 -040=
0:
> > > > > > > > =20
> > > > > > > > > Hi,
> > > > > > > > >
> > > > > > > > > On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
> > > > > > > > > <miquel.raynal@bootlin.com> wrote: =20
> > > > > > > > > >
> > > > > > > > > > Let's introduce the basics for defining PANs:
> > > > > > > > > > - structures defining a PAN
> > > > > > > > > > - helpers for PAN registration
> > > > > > > > > > - helpers discarding old PANs
> > > > > > > > > > =20
> > > > > > > > >
> > > > > > > > > I think the whole pan management can/should be stored in =
user space by
> > > > > > > > > a daemon running in background. =20
> > > > > > > >
> > > > > > > > We need both, and currently:
> > > > > > > > - while the scan is happening, the kernel saves all the dis=
covered PANs
> > > > > > > > - the kernel PAN list can be dumped (and also flushed) asyn=
chronously by
> > > > > > > >   the userspace
> > > > > > > >
> > > > > > > > IOW the userspace is responsible of keeping its own list of=
 PANs in
> > > > > > > > sync with what the kernel discovers, so at any moment it ca=
n ask the
> > > > > > > > kernel what it has in memory, it can be done during a scan =
or after. It
> > > > > > > > can request a new scan to update the entries, or flush the =
kernel list.
> > > > > > > > The scan operation is always requested by the user anyway, =
it's not
> > > > > > > > something happening in the background.
> > > > > > > > =20
> > > > > > >
> > > > > > > I don't see what advantage it has to keep the discovered pan =
in the
> > > > > > > kernel. You can do everything with a start/stop/pan discovere=
d event. =20
> > > > > >
> > > > > > I think the main reason is to be much more user friendly. Keepi=
ng track
> > > > > > of the known PANs in the kernel matters because when you start =
working
> > > > > > with 802.15.4 you won't blindly use a daemon (if there is any) =
and will
> > > > > > use test apps like iwpan which are stateless. Re-doing a scan o=
n demand
> > > > > > just takes ages (from seconds to minutes, depending on the beac=
on
> > > > > > order).
> > > > > > =20
> > > > >
> > > > > I can see that things should work "out-of the box" and we are alr=
eady
> > > > > doing it by manual setting pan_id, etc. However, doing it in an
> > > > > automatic way there exists a lot of "interpretation" about how you
> > > > > want to handle it (doesn't matter if this is what the spec says or
> > > > > not)... moving it to user space will offload it to the user.
> > > > > =20
> > > > > > Aside from this non technical reason, I also had in mind to ret=
rieve
> > > > > > values gathered from the beacons (and stored in the PAN descrip=
tors) to
> > > > > > know more about the devices when eg. listing associations, like
> > > > > > registering the short address of a coordinator. I don't yet kno=
w how
> > > > > > useful this is TBH.
> > > > > > =20
> > > > > > > It also has more advantages as you can look for a specific pa=
n and
> > > > > > > stop afterwards. At the end the daemon has everything that th=
e kernel
> > > > > > > also has, as you said it's in sync.
> > > > > > > =20
> > > > > > > > > This can be a network manager as it
> > > > > > > > > listens to netlink events as "detect PAN xy" and stores i=
t and
> > > > > > > > > offers it in their list to associate with it. =20
> > > > > > > >
> > > > > > > > There are events produced, yes. But really, this is not som=
ething we
> > > > > > > > actually need. The user requests a scan over a given range,=
 when the
> > > > > > > > scan is over it looks at the list and decides which PAN it
> > > > > > > > wants to associate with, and through which coordinator (95%=
 of the
> > > > > > > > scenarii).
> > > > > > > > =20
> > > > > > >
> > > > > > > This isn't either a kernel job to decide which pan it will be
> > > > > > > associated with. =20
> > > > > >
> > > > > > Yes, "it looks at the list and decides" referred to "the user".
> > > > > > =20
> > > > > > > > > We need somewhere to draw a line and I guess the line is =
"Is this
> > > > > > > > > information used e.g. as any lookup or something in the h=
ot path", I
> > > > > > > > > don't see this currently... =20
> > > > > > > >
> > > > > > > > Each PAN descriptor is like 20 bytes, so that's why I don't=
 feel back
> > > > > > > > keeping them, I think it's easier to be able to serve the l=
ist of PANs
> > > > > > > > upon request rather than only forwarding events and not bei=
ng able to
> > > > > > > > retrieve the list a second time (at least during the develo=
pment).
> > > > > > > > =20
> > > > > > >
> > > > > > > This has nothing to do with memory.
> > > > > > > =20
> > > > > > > > Overall I feel like this part is still a little bit blurry =
because it
> > > > > > > > has currently no user, perhaps I should send the next serie=
s which
> > > > > > > > actually makes the current series useful.
> > > > > > > > =20
> > > > > > >
> > > > > > > Will it get more used than caching entries in the kernel for =
user
> > > > > > > space? Please also no in-kernel association feature. =20
> > > > > >
> > > > > > I am aligned on this.
> > > > > > =20
> > > > >
> > > > > I am sorry I am not sure what that means. =20
> > > >
> > > > I was referring to the "no in-kernel association feature".
> > > >
> > > > There is however one situation which I _had_ to be handled in the
> > > > kernel: other devices asking for being associated or disassociated.=
 In
> > > > the case of the disassociation, the receiving device is only notifi=
ed
> > > > and cannot refuse the disassociation. For the association however,
> > > > the device receiving the association request has to make a decision.
> > > > There are three possible outcomes:
> > > > - accepting
> > > > - refusing because the PAN is at capacity
> > > > - refusing because the device is blacklisted =20
> > >
> > > Why not move this decision to the user as well? The kernel will wait
> > > for the reason? This isn't required to be fast and the decision may
> > > depend on the current pan management... =20
> >
> > I've opted out for the simplest option, which is allowing X devices
> > being associated, X being manageable by the user. For now I'll keep
> > this very simple approach, I propose we add this filtering feature
> > later?
> > =20
>=20
> What I suggest here is to move the filtering logic into the user
> space. If the interface is a coordinator it will trigger an event for
> the user and waits for an upper layer user space logic to get an
> answer back what to do as answer.
>=20
> However as I said I don't force you to program a user space software
> which does that job but you code should be prepared to be get replaced
> by such handling.

Actually I really think we should keep the maximum value which returns
the 802.15.4 "PAN AT CAPACITY" error status. The filtering thing is an
additional feature, I don't think it will replace what I currently
provide, but it will rather complement it.

> > > > For now I've only implemented the first reason, because it's much
> > > > easier and only requires a maximum device number variable, set by t=
he
> > > > user. For the second reason, it requires handling a
> > > > whitelist/blacklist, I don't plan to implement this for now, but th=
at
> > > > should not impact the rest of the code. I'll let that to other
> > > > developers, or future-me, perhaps :-). Anyhow, you can kick-out dev=
ices
> > > > at any time anyway if needed with a disassociation notification
> > > > controlled by the user.
> > > > =20
> > > > > > > We can maybe agree to that point to put it under
> > > > > > > IEEE802154_NL802154_EXPERIMENTAL config, as soon as we have s=
ome
> > > > > > > _open_ user space program ready we will drop this feature aga=
in...
> > > > > > > this program will show that there is no magic about it. =20
> > > > > >
> > > > > > Yeah, do you want to move all the code scan/beacon/pan/associat=
ion code
> > > > > > under EXPERIMENTAL sections? Or is it just the PAN management l=
ogic? =20
> > > > >
> > > > > Yes, why not. But as I can see there exists two categories of
> > > > > introducing your netlink api:
> > > > >
> > > > > 1. API candidates which are very likely to become stable
> > > > > 2. API candidates which we want to remove when we have a user
> > > > > replacement for it (will probably never go stable)
> > > > >
> > > > > The 2. should be defining _after_ the 1. In the "big" netlink API
> > > > > enums of EXPERIMENTAL sections. =20
> > > >
> > > > Yeah, got it.
> > > > =20
> > > > > Also you should provide for 2. some kind of ifdef/functions dummy=
/etc.
> > > > > that it's easy to remove from the kernel when we have a user
> > > > > replacement for it.
> > > > > I hope that is fine for everybody.
> > > > >
> > > > > I try to find solutions here, I don't see a reason for putting th=
is
> > > > > pan management into the kernel... whereas I appreciate the effort
> > > > > which is done here and will not force you to write some user space
> > > > > software that does this job. From my point of view I can't accept=
 this
> > > > > functionality in the kernel "yet". =20
> > > >
> > > > I've already spent a couple of days reworking all that part, I've
> > > > dropped most of the in-kernel PAN management, which means:
> > > > - when a new coordinator gets discovered (beacon received), if the =
mac
> > > >   was scanning then it calls a generic function from the cfg layer =
to
> > > >   advertise this pan.
> > > > - the cfg layer will send a NL message to the user with all the
> > > >   important information
> > > > - BUT the cfg layer will also keep in memory the beacon information=
 for
> > > >   the time of the scan (only), to avoid polluting the user with the=
 same
> > > >   information over and over again, this seems a necessary step to m=
e,
> > > >   because otherwise if you track on the same channel two coordinato=
rs
> > > >   not emitting at the same pace, you might end up with 100 user
> > > >   notifications, for just 2 devices. I think this is the kernel dut=
y to
> > > >   filter out identical beacons.
> > > > =20
> > >
> > > Okay, I am sure if somebody complains about such kernel behaviour and
> > > has a good argument to switch back... we still can do it. =20
> >
> > Great!
> > =20
>=20
> I would say more here... there might be some API documentation where
> you cannot expect anything from the kernel but it tries to avoid
> stupid things (Whatever that means). As the API is experimental it can
> be easily changed, otherwise some additional flag is required to
> enable this feature or not. However I can say more about this when I
> see code and we have some user experience about whatever the default
> behaviour should be or such flag is really necessary.

As I've dropped the entire internal PAN management handling thing with
userspace I have not set anything within the EXPERIMENTAL section, but
I believe there will be other versions, so we can decide what else
should go in there and I'll do it in the next version.

Thanks,
Miqu=C3=A8l
