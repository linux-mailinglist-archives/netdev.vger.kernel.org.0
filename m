Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FDC54C46A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 11:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347963AbiFOJP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 05:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345653AbiFOJPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 05:15:37 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB19E3ED3C;
        Wed, 15 Jun 2022 02:15:34 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 98DDB4000A;
        Wed, 15 Jun 2022 09:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655284533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uWE1Vk0+Zr2pLM5BMYfOcrVeY77S5kIxNU+y947KTYA=;
        b=OCCYbLep7uSmyImaY+JZAde+Rv71ihGaCkTa5Pja7/OTipLP59KcHFfZMMgb5f5ycybS0u
        owb3h9cWUSuRkBb8X0Y2prhWO8EsjJ6JPekAW5Ky0KskBkJ+bytNPeM466Kv39beHD0tdJ
        UT29o73jCXTsV0XU7wXhFQGMgez2Dyrj7ldsmppKHcsj8wsW6vG0hUF1ndAEuPYFOsUoM0
        NFqIQmqU39H0YCSTwcKiv9hXYiAWC0c0aWCI3q70DAkHJZ3tdyUscroQS5m7TRWDKta9eH
        8Z2ZuD3eGW+itMNKb63RgQN3kbo2BCragNE7wZWti6ucXUl3/61iLh1EVHLigA==
Date:   Wed, 15 Jun 2022 11:15:30 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220615111530.04c54bfd@xps-13>
In-Reply-To: <CAK-6q+haNAxexhNe5_pReU=jpUyP+XKn9oq=DKGC_Leg0w41pA@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
        <20220608154749.06b62d59@xps-13>
        <20220608163708.26ccd4cc@xps-13>
        <CAK-6q+iD0_bS2z_BdKsyeqYvzxj2x-v+SWAo2UO02j7yGtEcEg@mail.gmail.com>
        <CAK-6q+gBCakX8Vm1SHuLfex5jBqLKySUiaZKg3So+zjeJaSehw@mail.gmail.com>
        <20220609174353.177daddb@xps-13>
        <CAK-6q+haNAxexhNe5_pReU=jpUyP+XKn9oq=DKGC_Leg0w41pA@mail.gmail.com>
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

aahringo@redhat.com wrote on Sat, 11 Jun 2022 08:05:31 -0400:

> Hi,
>=20
> On Thu, Jun 9, 2022 at 11:44 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alex,
> > =20
> > > > >
> > > > >   - How is chosen the beacon order? Should we have a default valu=
e?
> > > > >     Should we default to 15 (not on a beacon enabled PAN)? Should=
 we be
> > > > >     able to update this value during the lifetime of the PAN?
> > > > > =20
> > > >
> > > > Is there no mib default value for this? =20
> >
> > I didn't find anything. I suppose we can ask for that parameter at PAN
> > creation, but otherwise I'll keep a backward compatible value: 15,
> > which means that the PAN is not beacon enabled (like today, basically).
> > =20
>=20
> I hope it is not necessary to answer this question, see below.
>=20
> > > > =20
> > > > >   - The spec talks about the cluster topology, where a coordinato=
r that
> > > > >     just associated to a PAN starts emitting beacons, which may e=
nable
> > > > >     other devices in its range to ask to join the PAN (increased =
area
> > > > >     coverage). But then, there is no information about how the ne=
wly
> > > > >     added device should do to join the PAN coordinator which is a=
nyway
> > > > >     out of range to require the association, transmit data, etc. =
Any
> > > > >     idea how this is supposed to work?
> > > > > =20
> > > >
> > > > I think we should maybe add a feature for this later if we don't kn=
ow
> > > > how it is supposed to work or there are still open questions and fi=
rst
> > > > introduce the manual setup. After that, maybe things will become
> > > > clearer and we can add support for this part. Is this okay? =20
> > >
> > > *I also think that this can be done in user space by a daemon by
> > > triggering netlink commands for scan/assoc/etc. (manual setup) and
> > > providing such functionality as mentioned by the spec (auto creation
> > > of pan, assoc with pan). Things which are unclear here are then moved
> > > to the user as the operations for scan/assoc/etc. will not be
> > > different or at least parameterized. The point here is that providing
> > > the minimum basic functionality should be done at first, then we can
> > > look at how to realize such handling (either in kernel or user space)=
. =20
> >
> > Actually this is none of the 802.15.4 MAC layer business. I believe
> > this is the upper layer duty to make this interoperability work,
> > namely, 6lowpan? =20
>=20
> I am not sure if I understand your answer, I meant that if
> "coordinator" or "PAN coordinator" depends on whatever, if somebody is
> running a "coordinator" software in the background on top of a coord
> interface.
> The kernel offers the functionality for scan/assoc/etc. (offers link
> quality, etc. _statistics_ and not _heuristic_) which will be used by
> this software to whatever the user defines to realize this behaviour
> as it is user specific.

Yes.

> Sure linux-wpan, should then provide at least a standard piece of
> software for it.
>=20
> This has in my opinion nothing to do with 6lowpan.

I was referring to the cluster topology routing logic. The routing
logic to reach a device in a PAN that is not directly reachable by the
PAN coordinator is the responsibility of the layer 3 in the OSI model,
so I believe it's either 6lowpan's duty or even above.

Thanks,
Miqu=C3=A8l
