Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C0F59A4E6
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351978AbiHSRrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352034AbiHSRq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:46:56 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBC0103C75;
        Fri, 19 Aug 2022 10:13:04 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 62DFE1C0004;
        Fri, 19 Aug 2022 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660929183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mlity6Q4wht0162itMXjE3CAKh4WGGKaF+5FBqiJS2M=;
        b=KhpYPvQH09vSxBIh5hBDnpHevqpIQZgcvUFuaGNB5IMKJnlAPCCjnSfKip5DyQiIsKtaPk
        FXmAUT/PP+yHXkuGz6iq1BLg2BheMdn7FHo8ZK/A0UrWVPVB/9Tqes71HEXV/dZjmewoGp
        gT/ZE8rGIxGUz5osuXCxXqelbBEgzz0hZ1s1otYHLypwBhztTaP3+DdY1zrc7TxXK29+Z9
        aN7wNz4LLUinLeTWRlt8TQtbOHfmKjz9ZH/vs1tOAVqUTgpuUeHamk/rb9f28KMMwVv4mI
        cNYLWcslwYWTpjiX290FfIs7frDF/JYyPCjk947xFnCrK6TrwBSbWCxVEKmjLA==
Date:   Fri, 19 Aug 2022 19:13:00 +0200
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
Subject: Re: [PATCH wpan-next 05/20] net: ieee802154: Define frame types
Message-ID: <20220819191300.0e5e28f1@xps-13>
In-Reply-To: <CAK-6q+gXUySx1YzPdq1+dt5MN5y_4qGWAB5a1qPe2tOGkbq19A@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-6-miquel.raynal@bootlin.com>
        <CAK-6q+gXUySx1YzPdq1+dt5MN5y_4qGWAB5a1qPe2tOGkbq19A@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 10 Jul 2022 22:06:57 -0400:

> Hi,
>=20
> On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > A 802.15.4 frame can be of different types, here is a definition
> > matching the specification. This enumeration will be soon be used when
> > adding scanning support.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  include/net/ieee802154_netdev.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_n=
etdev.h
> > index d0d188c3294b..13167851b1c3 100644
> > --- a/include/net/ieee802154_netdev.h
> > +++ b/include/net/ieee802154_netdev.h
> > @@ -69,6 +69,17 @@ struct ieee802154_hdr_fc {
> >  #endif
> >  };
> >
> > +enum ieee802154_frame_type {
> > +       IEEE802154_BEACON_FRAME,
> > +       IEEE802154_DATA_FRAME,
> > +       IEEE802154_ACKNOWLEDGEMENT_FRAME,
> > +       IEEE802154_MAC_COMMAND_FRAME,
> > +       IEEE802154_RESERVED_FRAME,
> > +       IEEE802154_MULTIPURPOSE_FRAME,
> > +       IEEE802154_FRAGMENT_FRAME,
> > +       IEEE802154_EXTENDED_FRAME,
> > +}; =20
>=20
> Please use and extend include/linux/ieee802154.h e.g. IEEE802154_FC_TYPE_=
DATA.
> I am also not a fan of putting those structs on payload, because there
> can be several problems with it, we should introduce inline helpers to
> check/get each individual fields but... the struct is currently how
> it's implemented.

Ok, I can easily do that.

Thanks,
Miqu=C3=A8l
