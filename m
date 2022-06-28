Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EAD55E19A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243028AbiF1H6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 03:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243842AbiF1H6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 03:58:35 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCDE1C93B;
        Tue, 28 Jun 2022 00:58:27 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AE11DFF817;
        Tue, 28 Jun 2022 07:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656403106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I+AXDaZsFl3z6rNIzXEGyxEFvhuj5AkhYIrVMphtqUs=;
        b=mlz8sFC3+L3lJQ6AEgajVVigiodvFbbOtWTXj9AKR71MXzw16wNmBhQW1Jqv20E32UcoQJ
        KpncCxNJ+6kVcItK+FzppxauPP006O/lk4YsrcIWMwlTvTRTvCcc1Edx5dLA1+ttVnj0Kq
        YeYnJPTrj/4JEMiMHJ55TA0fPMBLj9x4qgEZXIWwwHE0wDQ3kOT3IuXTqWk95Eom4wD5+E
        +RA6bMyUNCh5526B6WkSfkhmlsDubitkdabmgXVvw4BQx0cC0wCVNRtK9fFosyvL4vGo8+
        7wfxZDQjzQw4czYGRdfq2aoyBtCW0mg+vh1LAhM+J1aK8fbmTBfglQkARQluJQ==
Date:   Tue, 28 Jun 2022 09:58:21 +0200
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
Message-ID: <20220628095821.36811c5c@xps-13>
In-Reply-To: <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
References: <20220620134018.62414-1-miquel.raynal@bootlin.com>
        <20220620134018.62414-3-miquel.raynal@bootlin.com>
        <CAK-6q+jAhikJq5tp-DRx1C_7ka5M4w6EKUB_cUdagSSwP5Tk_A@mail.gmail.com>
        <20220627104303.5392c7f6@xps-13>
        <CAK-6q+jYFeOyP_bvTd31av=ntJA=Qpas+v+xRDQuMNb74io2Xw@mail.gmail.com>
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

aahringo@redhat.com wrote on Mon, 27 Jun 2022 21:32:08 -0400:

> Hi,
>=20
> On Mon, Jun 27, 2022 at 4:43 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sat, 25 Jun 2022 22:29:08 -0400:
> > =20
> > > Hi,
> > >
> > > On Mon, Jun 20, 2022 at 10:26 AM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote: =20
> > > >
> > > > Let's introduce the basics for defining PANs:
> > > > - structures defining a PAN
> > > > - helpers for PAN registration
> > > > - helpers discarding old PANs
> > > > =20
> > >
> > > I think the whole pan management can/should be stored in user space by
> > > a daemon running in background. =20
> >
> > We need both, and currently:
> > - while the scan is happening, the kernel saves all the discovered PANs
> > - the kernel PAN list can be dumped (and also flushed) asynchronously by
> >   the userspace
> >
> > IOW the userspace is responsible of keeping its own list of PANs in
> > sync with what the kernel discovers, so at any moment it can ask the
> > kernel what it has in memory, it can be done during a scan or after. It
> > can request a new scan to update the entries, or flush the kernel list.
> > The scan operation is always requested by the user anyway, it's not
> > something happening in the background.
> > =20
>=20
> I don't see what advantage it has to keep the discovered pan in the
> kernel. You can do everything with a start/stop/pan discovered event.

I think the main reason is to be much more user friendly. Keeping track
of the known PANs in the kernel matters because when you start working
with 802.15.4 you won't blindly use a daemon (if there is any) and will
use test apps like iwpan which are stateless. Re-doing a scan on demand
just takes ages (from seconds to minutes, depending on the beacon
order).

Aside from this non technical reason, I also had in mind to retrieve
values gathered from the beacons (and stored in the PAN descriptors) to
know more about the devices when eg. listing associations, like
registering the short address of a coordinator. I don't yet know how
useful this is TBH.

> It also has more advantages as you can look for a specific pan and
> stop afterwards. At the end the daemon has everything that the kernel
> also has, as you said it's in sync.
>=20
> > > This can be a network manager as it
> > > listens to netlink events as "detect PAN xy" and stores it and
> > > offers it in their list to associate with it. =20
> >
> > There are events produced, yes. But really, this is not something we
> > actually need. The user requests a scan over a given range, when the
> > scan is over it looks at the list and decides which PAN it
> > wants to associate with, and through which coordinator (95% of the
> > scenarii).
> > =20
>=20
> This isn't either a kernel job to decide which pan it will be
> associated with.

Yes, "it looks at the list and decides" referred to "the user".

> > > We need somewhere to draw a line and I guess the line is "Is this
> > > information used e.g. as any lookup or something in the hot path", I
> > > don't see this currently... =20
> >
> > Each PAN descriptor is like 20 bytes, so that's why I don't feel back
> > keeping them, I think it's easier to be able to serve the list of PANs
> > upon request rather than only forwarding events and not being able to
> > retrieve the list a second time (at least during the development).
> > =20
>=20
> This has nothing to do with memory.
>=20
> > Overall I feel like this part is still a little bit blurry because it
> > has currently no user, perhaps I should send the next series which
> > actually makes the current series useful.
> > =20
>=20
> Will it get more used than caching entries in the kernel for user
> space? Please also no in-kernel association feature.

I am aligned on this.

> We can maybe agree to that point to put it under
> IEEE802154_NL802154_EXPERIMENTAL config, as soon as we have some
> _open_ user space program ready we will drop this feature again...
> this program will show that there is no magic about it.

Yeah, do you want to move all the code scan/beacon/pan/association code
under EXPERIMENTAL sections? Or is it just the PAN management logic?

Thanks,
Miqu=C3=A8l
