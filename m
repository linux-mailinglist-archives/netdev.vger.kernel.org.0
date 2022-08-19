Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8C059A39D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351162AbiHSRrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350685AbiHSRqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:46:38 -0400
X-Greylist: delayed 149 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 19 Aug 2022 10:12:18 PDT
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EF2107AC1;
        Fri, 19 Aug 2022 10:12:18 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 34B8860003;
        Fri, 19 Aug 2022 17:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660929136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m3UMhrAoHpVgb/m5Er4vnR+gV0rJlsK78qtYXrGbcPg=;
        b=gQc0BwP9l1T8AAVbqRDl8OqAxDW6tWpM2TAC1HJhz+zKz/Moil2PePHF6Hk3YWAcigu9ME
        tJzgyT2OgcSbCAh7ilpAEtPCWO6VQWWKVqUcI0qJFmL/aySUGvA+Rff9gLNx0p6BSwYuz1
        VmbWt9Y+/I5njZZ/D87f7LO5Hx5pRyHcQomYPxbZDNO/0lYyxS9gXG9DlTyUtXeJizWWb0
        D05L/YKyBq7POgw9sDPLq7QHfWJtJrU+ZMj8GW0tlcevj/z+uFO5pVBFysByjNNgEqBVKb
        RTNPL+xJhHfVX8SWB2b+Dbf8Yb1Lp9MG47FSxyFmkY5yKMOeRhpKQ+MBSnFWMg==
Date:   Fri, 19 Aug 2022 19:12:12 +0200
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
Subject: Re: [PATCH wpan-next 20/20] ieee802154: hwsim: Allow devices to be
 coordinators
Message-ID: <20220819191212.4503a6d9@xps-13>
In-Reply-To: <CAK-6q+hS-6esVw7ebAsr8MoDDsEkorTLKVQupW1xoTZaawCHZA@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-21-miquel.raynal@bootlin.com>
        <CAK-6q+hS-6esVw7ebAsr8MoDDsEkorTLKVQupW1xoTZaawCHZA@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 10 Jul 2022 22:01:43 -0400:

> Hi,
>=20
> On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > In order to be able to create coordinator interfaces, we need the
> > drivers to advertize that they support this type of interface. Fill in
> > the right bit in the hwsim capabilities to allow the creation of these
> > coordinator interfaces.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/mac802154_hwsim.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/iee=
e802154/mac802154_hwsim.c
> > index a5b9fc2fb64c..a678ede07219 100644
> > --- a/drivers/net/ieee802154/mac802154_hwsim.c
> > +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> > @@ -776,6 +776,8 @@ static int hwsim_add_one(struct genl_info *info, st=
ruct device *dev,
> >         /* 950 MHz GFSK 802.15.4d-2009 */
> >         hw->phy->supported.channels[6] |=3D 0x3ffc00;
> >
> > +       hw->phy->supported.iftypes |=3D BIT(NL802154_IFTYPE_COORD); =20
>=20
> I think we can do that for more than one driver (except ca8210).

Yes of course. I can update this patch and make the change to all the
drivers except ca8210 indeed.

> What about the other iftypes?

The NODE type is set by default at initialization time:
net/mac802154/main.c-120-       /* always supported */
net/mac802154/main.c:121:       phy->supported.iftypes =3D BIT(NL802154_IFT=
YPE_NODE);

The MONITOR type is only set if the device supports the promiscuous
mode:
net/mac802154/main.c-255-       if (hw->flags & IEEE802154_HW_PROMISCUOUS)
net/mac802154/main.c:256:               local->phy->supported.iftypes |=3D =
BIT(NL802154_IFTYPE_MONITOR);

Which indeed makes echo to one of your other review, saying that we
should probably prevent the creation of MONITOR types if the device has
no promiscuous support.

Thanks,
Miqu=C3=A8l
