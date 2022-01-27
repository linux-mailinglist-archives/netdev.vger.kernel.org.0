Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE2949E81B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244141AbiA0QyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbiA0QyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:54:15 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88965C061714;
        Thu, 27 Jan 2022 08:54:14 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1BCD7C0003;
        Thu, 27 Jan 2022 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643302452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IvtKV4Bh1kWEO/WKcmj7NfRZ2FJ3K2bDH9xAeH8VGHA=;
        b=Xbh8gJr78/4fIFuTILF1vW84ncRpl1Hyg1RDrGOrCjaoSnfTbymyJ+NdYn/dzhiiydD8Im
        NALYRTg4YmboqZ0vG2GFARgZfVzeBOMN8WwtnwbQXEY+uQw7DNbXPMdM69HuByAZtFK8fw
        SHSGZMEWGxusxbtSNj5x8d4NRdXGw4eG2MpPeUZio+OeupGWpBrw46dl2bDMSQD9BojVoz
        /n9FysPX6j6D6xa4X6X7OMIoE29Np0Sj9O405uEsFslG5Zc7GoLGxhru93MjBfy1DEz0tV
        BfBU5XNOGrGlOKUMVVJSnTC/NfZgkEAQTEMxksHqyqGk2brYkxwSNNmXCdE5cw==
Date:   Thu, 27 Jan 2022 17:54:09 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next 2/4] net: mac802154: Include the softMAC stack
 inside the IEEE 802.15.4 menu
Message-ID: <20220127175409.777b9dff@xps13>
In-Reply-To: <53c2d017-a7a5-3ed0-a68c-6b67c96b5b54@datenfreihafen.org>
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
        <20220120004350.308866-3-miquel.raynal@bootlin.com>
        <53c2d017-a7a5-3ed0-a68c-6b67c96b5b54@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Thu, 27 Jan 2022 17:04:41 +0100:

> Hello.
>=20
> On 20.01.22 01:43, Miquel Raynal wrote:
> > From: David Girault <david.girault@qorvo.com>
> >=20
> > The softMAC stack has no meaning outside of the IEEE 802.15.4 stack and
> > cannot be used without it.
> >=20
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit]
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >   net/Kconfig            | 1 -
> >   net/ieee802154/Kconfig | 1 +
> >   2 files changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/net/Kconfig b/net/Kconfig
> > index 0da89d09ffa6..a5e31078fd14 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -228,7 +228,6 @@ source "net/x25/Kconfig"
> >   source "net/lapb/Kconfig"
> >   source "net/phonet/Kconfig"
> >   source "net/6lowpan/Kconfig"
> > -source "net/mac802154/Kconfig"
> >   source "net/sched/Kconfig"
> >   source "net/dcb/Kconfig"
> >   source "net/dns_resolver/Kconfig"
> > diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
> > index 31aed75fe62d..7e4b1d49d445 100644
> > --- a/net/ieee802154/Kconfig
> > +++ b/net/ieee802154/Kconfig
> > @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
> >   	  for 802.15.4 dataframes. Also RAW socket interface to build MAC
> >   	  header from userspace. =20
> >   > +source "net/mac802154/Kconfig" =20
> >   source "net/ieee802154/6lowpan/Kconfig" =20
> >   >   endif =20
> >  =20
>=20
> Please fold this patch into the previous one moving the Kconfig option ar=
ound. This can be done in one go.

Sure.

By the way, I was questioning myself: why is the mac802154 folder
outside of ieee802154? I don't really understand the organization but
as it would massively prevent any of the future changes that I already
prepared to apply correctly, I haven't proposed such a move -yet. But
I would like to know what's the idea behind the current folder
hierarchy?

Thanks,
Miqu=C3=A8l
