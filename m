Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC31616558
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 15:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiKBOwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 10:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiKBOws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 10:52:48 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6F32AC49;
        Wed,  2 Nov 2022 07:52:45 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BD413C000F;
        Wed,  2 Nov 2022 14:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667400764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cfNvnrYr/ItlWTT9DZxYiIOujMBGP4riRcwbnYZoqbM=;
        b=Ezr0FF1nftRxdTz3hYfcYO8Voc7Z9E+Q761etlytsooXbdXbiKxEJPGGs/9u+gM/krNJ3g
        8yFY02C9P7Pn5mwpzz/ZIv6IWNzaP04KckScGBRXphWpRsiFTvdnOR5itWx/7qnFit1bzz
        nR7cD4VAN3s6kYwlp4dEmmxdTEyD4eK+iAmX1FHFSdHiuzCV5gf6B7LYpWes0QZ3mtQ4O4
        qQz/sTpCiVX61HN09vcvd/anPnoebPKGwYEs40QsNXAQQPTcf0C33ZWlSrv2LMA1vMu/cC
        U4Rl45TBB81R/mFw4pGZdjo1zTEzytQYlt5zUYwOw1RqFRvWMdj9vi4UgKsrdQ==
Date:   Wed, 2 Nov 2022 15:52:40 +0100
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
Subject: Re: [PATCH wpan-next v2 0/3] IEEE 802.15.4: Add coordinator
 interfaces
Message-ID: <20221102155240.71a1d205@xps-13>
In-Reply-To: <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
        <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 30 Oct 2022 22:20:03 -0400:

> Hi,
>=20
> On Wed, Oct 26, 2022 at 5:35 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hello,
> > These three patches allow the creation of coordinator interfaces, which
> > were already defined without being usable. The idea behind is to use
> > them advertizing PANs through the beaconing feature.
> > =20
>=20
> I still don't know how exactly those "leaves" and "non-leaves" are
> acting here regarding the coordinator interfaces. If this is just a
> bit here to set in the interface I am fine with it. But yea,
> "relaying" feature is a project on its own, as we said previously.
>=20
> Another mail I was asking myself what a node interface is then,
> currently it is a mesh interface with none of those 802.15.4 PAN
> management functionality?

Not "none", because I would expect a NODE to be able to perform minimal
management operations, such as:
- scanning
- requesting an association
But in no case it is supposed to:
- send beacons
- manage associations
- be the PAN coordinator
- act as a relay

> Or can it act also as a "leave"
> coordinator... I am not sure about that.
>=20
> However I think we can think about something scheduled later as we can
> still decide later if we really want that "node" can do that.
> Regarding to 6LoWPAN I think the current type what "node" interface is
> as a just a node in a mesh is required, it might depends on if you
> want routing on IP or "relaying" on MAC (mesh-over vs mesh-under), but
> I never saw mesh-under in 6LoWPAN.

Yes.

>=20
> Acked-by: Alexander Aring <aahringo@redhat.com>

Thanks!

Miqu=C3=A8l
