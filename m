Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865536794CA
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbjAXKI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233318AbjAXKI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:08:27 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402B0B75D;
        Tue, 24 Jan 2023 02:08:19 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4D418C000A;
        Tue, 24 Jan 2023 10:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674554898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3i5ohLf4wLNRAQx3kpGrIufjr8r+UzfPMXQjZwgDwzw=;
        b=E8BePmz8bTzR9PGZnnziJdDhqQ7/o0QqqGdAJrH+7NsEHio6tibumlCNVVG0ejiGIMwIa4
        bE4i0cwDc2VGUSSYBYy6M/OkYxoI5C+dlno6lmSbgRvLCiUDbWIbtbw5tJ5usXlCY3q6kb
        RkfpEPPIm8aZTRwLiIJ6h29Oa7lhz057YmpNHNTKP9yFmR6YpjUIBPvn+ZM/zr7l2g2ySz
        Qroj3Hqbui5tnsPNYVBOn5D0s1b+xTB6s/egRRUKWF/yY/V6kJ/eJIpJbWTMAZ+qMzJC+0
        HtD5sOWWxtviFGueXs8XqZ6qs0nQyJBBeLeq3eZYfYbRlZ/mDJesBtVPkUYgMA==
Date:   Tue, 24 Jan 2023 11:08:14 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Beaconing support
Message-ID: <20230124110814.6096ecbe@xps-13>
In-Reply-To: <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
References: <20230106113129.694750-1-miquel.raynal@bootlin.com>
        <CAK-6q+jNmvtBKKxSp1WepVXbaQ65CghZv3bS2ptjB9jyzOSGTA@mail.gmail.com>
        <20230118102058.3b1f275b@xps-13>
        <CAK-6q+gwP8P--5e9HKt2iPhjeefMXrXUVy-G+szGdFXZvgYKvg@mail.gmail.com>
        <CAK-6q+gn7W9x2+ihSC41RzkhmBn1E44pKtJFHgqRdd8aBpLrVQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Mon, 23 Jan 2023 09:02:48 -0500:

> Hi,
>=20
> On Mon, Jan 23, 2023 at 9:01 AM Alexander Aring <aahringo@redhat.com> wro=
te:
> >
> > Hi,
> >
> > On Wed, Jan 18, 2023 at 4:21 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > Hi Alexander,
> > >
> > > aahringo@redhat.com wrote on Sun, 15 Jan 2023 20:54:02 -0500:
> > > =20
> > > > Hi,
> > > >
> > > > On Fri, Jan 6, 2023 at 6:33 AM Miquel Raynal <miquel.raynal@bootlin=
.com> wrote: =20
> > > > >
> > > > > Scanning being now supported, we can eg. play with hwsim to verify
> > > > > everything works as soon as this series including beaconing suppo=
rt gets
> > > > > merged.
> > > > > =20
> > > >
> > > > I am not sure if a beacon send should be handled by an mlme helper
> > > > handling as this is a different use-case and the user does not trig=
ger
> > > > an mac command and is waiting for some reply and a more complex
> > > > handling could be involved. There is also no need for hotpath xmit
> > > > handling is disabled during this time. It is just an async messaging
> > > > in some interval and just "try" to send it and don't care if it fai=
ls,
> > > > or? For mac802154 therefore I think we should use the dev_queue_xmi=
t()
> > > > function to queue it up to send it through the hotpath?
> > > >
> > > > I can ack those patches, it will work as well. But I think we should
> > > > switch at some point to dev_queue_xmit(). It should be simple to
> > > > switch it. Just want to mention there is a difference which will be
> > > > there in mac-cmds like association. =20
> > >
> > > I see what you mean. That's indeed true, we might just switch to
> > > a less constrained transmit path.
> > > =20
> >
> > I would define the difference in bypass qdisc or not. Whereas the
> > qdisc can drop or delay transmitting... For me, the qdisc is currently
> > in a "works for now" state. =20
>=20
> probably also bypass other hooks like tc, etc. :-/ Not sure if we want th=
at.

Actually, IIUC, we no longer want to go through the entire net stack.
We still want to bypass it but without stopping/flushing the full
queue like with an mlme transmission, so what about using
ieee802154_subif_start_xmit() instead of dev_queue_xmit()? I think it
is more appropriate.

Thanks,
Miqu=C3=A8l
