Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BBA253D015
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346154AbiFCR76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346141AbiFCR7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 13:59:18 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F9F580EC;
        Fri,  3 Jun 2022 10:55:16 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id F03D520005;
        Fri,  3 Jun 2022 17:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654278913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uB9MB0sGXVEAR72YIR3d2LvPn6avSyl/aTG9v3Mg4co=;
        b=OcV6ZZnXBToKPqmNwRIOBI8OXCK745PcOIFZJb2fuX3qY3u+mg8+yOeZ/1OTVxGVjBb1TZ
        xoJY0fxre1RSYeOVF3/gjCpu5xDpFPI4tgLJpiAWCbwHeSPzCjQeesiTtdyTYd2bztMZoi
        iVJZyAcVUrWml83PuWl0girLhS37Xis+npYWFHQjfPfo61pCTbmgqRY8LtBPvzydW3QWK7
        uala+zRhIMz0iXFKpG/MvtcKhG+f23mVk2w32Un3K/C8MT+Pu270plsnI9Mh0wOe9D7wxH
        FZtt9PjC3JWeeU8fBbDc4q81Qm/mzjw/INTPu6q13Kp273lKvWgMHgda0C8uZA==
Date:   Fri, 3 Jun 2022 19:55:09 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <aahringo@redhat.com>,
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
Message-ID: <20220603195509.73cf888f@xps-13>
In-Reply-To: <d844514c-771f-e720-407b-2679e430243a@datenfreihafen.org>
References: <20220519150516.443078-1-miquel.raynal@bootlin.com>
        <CAK-6q+hmd_Z-xJrz6QVM37gFrPRkYPAnyERit5oyDS=Beb83kg@mail.gmail.com>
        <d844514c-771f-e720-407b-2679e430243a@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan, Alex,

stefan@datenfreihafen.org wrote on Wed, 1 Jun 2022 23:01:51 +0200:

> Hello.
>=20
> On 01.06.22 05:30, Alexander Aring wrote:
> > Hi,
> >=20
> > On Thu, May 19, 2022 at 11:06 AM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote: =20
> >>
> >> Hello,
> >>
> >> This series brings support for that famous synchronous Tx API for MLME
> >> commands.
> >>
> >> MLME commands will be used during scan operations. In this situation,
> >> we need to be sure that all transfers finished and that no transfer
> >> will be queued for a short moment.
> >> =20
> >=20
> > Acked-by: Alexander Aring <aahringo@redhat.com> =20
>=20
> These patches have been applied to the wpan-next tree. Thanks!
>=20
> > There will be now functions upstream which will never be used, Stefan
> > should wait until they are getting used before sending it to net-next. =
=20
>=20
> Indeed this can wait until we have a consumer of the functions before pus=
hing this forward to net-next. Pretty sure Miquel is happy to finally move =
on to other pieces of his puzzle and use them. :-)

Next part is coming!

In the mean time I've experienced a new lockdep warning:

All the netlink commands are executed with the rtnl taken.
In my current implementation, when I configure/edit a scan request or a
beacon request I take a scan_lock or a beacons_lock, so they may only
be taken after the rtnl in this case, which leads to this sequence of
events:
- the rtnl is taken (by the net core)
- the beacon's lock is taken

But now in a beacon's work or an active scan work, what happens is:
- work gets woken up
- the beacon/scan lock is taken
- a beacon/beacon-request frame is transmitted
- the rtnl lock is taken during this transmission

Lockdep then detects a possible circular dependency:
[  490.153387]        CPU0                    CPU1
[  490.153391]        ----                    ----
[  490.153394]   lock(&local->beacons_lock);
[  490.153400]                                lock(rtnl_mutex);
[  490.153406]                                lock(&local->beacons_lock);
[  490.153412]   lock(rtnl_mutex);

So in practice, I always need to have the rtnl lock taken when
acquiring these other locks (beacon/scan_lock) which I think is far
from optimal.

1# One solution is to drop the beacons/scan locks because they are not
useful anymore and simply rely on the rtnl.

2# Another solution would be to change the mlme_tx() implementation to
finally not need the rtnl at all.

Note that just calling ASSERT_RTNL() makes no difference in 2#, it
still means that I always need to acquire the rtnl before acquiring the
beacons/scan locks, which greatly reduces their usefulness and leads to
solution 1# in the end.

IIRC I decided to introduce the rtnl to avoid ->ndo_stop() calls during
an MLME transmission. I don't know if it has another use there. If not,
we may perhaps get rid of the rtnl in mlme_tx() by really handling the
stop calls (but I was too lazy so far to do that).

What direction would you advise?

Thanks,
Miqu=C3=A8l
