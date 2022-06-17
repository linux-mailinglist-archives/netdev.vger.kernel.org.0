Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E485E54F90F
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 16:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382599AbiFQOUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382484AbiFQOUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 10:20:42 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154BC43EFB;
        Fri, 17 Jun 2022 07:20:40 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1FAFDC0010;
        Fri, 17 Jun 2022 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655475639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrYkNvOzTMIzxWUK5tbHcNaHrzffRjB2I4nCD6yzJ6M=;
        b=IAYZjeoktt4PUmpFETUg9Kh/RJGKLnRCtF3x04LkK2Vjdypp2zMoPVNXkZz2EeB3VrzyOe
        9SZ75EFV1jvjXN/hhy8LedYeAQXvxJ0qi1ddX4x/GiRPyPl5LFEh4yE/wXSIn7AjoLLVwC
        4/3PL7yLZGRkyKVjSXHaPmlXLcO+hduMD+Bb0e/wNB46gsFgXw9AGPhoe+hYhAIGPW+Jq6
        oDXh0CpE0x64mj0sjlOoOE3t3Gg1DhM/ZRdZlo0Z1C4WqIFdL44Kx9yPV7G5a0cyejbYsy
        3UOsRQM7jySz2VPDTirmdSFmequBydUf+K0n5tiDfOyRGHFPSkQI72QeHbe+9Q==
Date:   Fri, 17 Jun 2022 16:20:35 +0200
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
Subject: Re: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
Message-ID: <20220617162035.5024d8a8@xps-13>
In-Reply-To: <CAK-6q+if-dNbpbneTfUtj6MrZXiYPq9npZfMkatXKo8cfU1m9w@mail.gmail.com>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
        <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
        <d844514c-771f-e720-407b-2679e430243a@datenfreihafen.org>
        <20220603195509.73cf888f@xps-13>
        <CAK-6q+if-dNbpbneTfUtj6MrZXiYPq9npZfMkatXKo8cfU1m9w@mail.gmail.com>
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

aahringo@redhat.com wrote on Fri, 3 Jun 2022 21:50:15 -0400:

> Hi,
>=20
> On Fri, Jun 3, 2022 at 1:55 PM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hi Stefan, Alex,
> >
> > stefan@datenfreihafen.org wrote on Wed, 1 Jun 2022 23:01:51 +0200:
> > =20
> > > Hello.
> > >
> > > On 01.06.22 05:30, Alexander Aring wrote: =20
> > > > Hi,
> > > >
> > > > On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
> > > > <miquel.raynal@bootlin.com> wrote: =20
> > > >>
> > > >> Hello,
> > > >>
> > > >> This series brings support for that famous synchronous Tx API for =
MLME
> > > >> commands.
> > > >>
> > > >> MLME commands will be used during scan operations. In this situati=
on,
> > > >> we need to be sure that all transfers finished and that no transfer
> > > >> will be queued for a short moment.
> > > >> =20
> > > >
> > > > Acked-by: Alexander Aring <aahringo@redhat.com> =20
> > >
> > > These patches have been applied to the wpan-next tree. Thanks!
> > > =20
> > > > There will be now functions upstream which will never be used, Stef=
an
> > > > should wait until they are getting used before sending it to net-ne=
xt. =20
> > >
> > > Indeed this can wait until we have a consumer of the functions before=
 pushing this forward to net-next. Pretty sure Miquel is happy to finally m=
ove on to other pieces of his puzzle and use them. :-) =20
> >
> > Next part is coming!
> >
> > In the mean time I've experienced a new lockdep warning:
> >
> > All the netlink commands are executed with the rtnl taken.
> > In my current implementation, when I configure/edit a scan request or a
> > beacon request I take a scan_lock or a beacons_lock, so they may only
> > be taken after the rtnl in this case, which leads to this sequence of
> > events:
> > - the rtnl is taken (by the net core)
> > - the beacon's lock is taken
> >
> > But now in a beacon's work or an active scan work, what happens is:
> > - work gets woken up
> > - the beacon/scan lock is taken
> > - a beacon/beacon-request frame is transmitted
> > - the rtnl lock is taken during this transmission
> >
> > Lockdep then detects a possible circular dependency:
> > [  490.153387]        CPU0                    CPU1
> > [  490.153391]        ----                    ----
> > [  490.153394]   lock(&local->beacons_lock);
> > [  490.153400]                                lock(rtnl_mutex);
> > [  490.153406]                                lock(&local->beacons_lock=
);
> > [  490.153412]   lock(rtnl_mutex);

So after a lot of thinking and different tries, I've opted for a
slightly different approach regarding the rtnl being taken in the mlme
tx path. What we want there is actually to be sure that the device
won't be turned off during the transmission. Either this is done
before, and the transmission will just return an error (and this is
fine) or there is no ndo_close() call and we are actually safe. So I've
actually introduced a mutex for serializing accesses to the "stop the
device" section which actually what we care about. It works well, avoid
keeping the rtnl in all the scan/beacons works (which would have been
a crazy thing to do IMHO) and allows to keep a beacons/scan mutex for
the configuration of these specific parts. I'll propose this change in
the upcoming series.

Thanks,
Miqu=C3=A8l
