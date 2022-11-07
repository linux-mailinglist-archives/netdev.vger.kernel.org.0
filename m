Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14A961ED62
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiKGIth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiKGItf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:49:35 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136B513DC3;
        Mon,  7 Nov 2022 00:49:33 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CC81EC0005;
        Mon,  7 Nov 2022 08:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667810972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4po5/sAdAejmMVX7B1mMke6jv9XUIrfpCadagSEo9Zs=;
        b=V0MD+mRH5ooq2ROVyY/Cm5lHpnFneKLdMNtopTwfgBbT0LjjtH8nP+d6LfhglZDH6hmKbA
        pYfgCunm075LKqR0mXJFgUjlcu2+4iGhUgd0PfZ2HbMRDyJ2tHeWlBbO4gmyaY7tRcRqgD
        dawDYT9bnN8opXFR+H99KpNiM4cIUqbhcw7Uy5M2lHfNl2QRpL5uzy+MNYpXpZdVIuHGz+
        4ZsrIVLUydqCkx+5tAiqvS+TCxKx3Tkm5iBAtRVplOBC+92uvAzHLsh6oBanOg474XkLD4
        ovts6k/4L8O16Yu3wC8Xy9VlnL1mxjCrD/5CL0QDxD7thTwkAAhj3gn4tEFQfw==
Date:   Mon, 7 Nov 2022 09:49:29 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH wpan-next 3/3] ieee802154: Trace the registration of new
 PANs
Message-ID: <20221107094929.2a9891b8@xps-13>
In-Reply-To: <CAK-6q+jDFGr2xhAKLLitZXA2Q2dWgeZjgBXHubHvOvzX-xeB-w@mail.gmail.com>
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
        <20221102151915.1007815-4-miquel.raynal@bootlin.com>
        <CAK-6q+jDFGr2xhAKLLitZXA2Q2dWgeZjgBXHubHvOvzX-xeB-w@mail.gmail.com>
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

aahringo@redhat.com wrote on Sun, 6 Nov 2022 20:36:21 -0500:

> Hi,
>=20
> On Wed, Nov 2, 2022 at 11:20 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > From: David Girault <david.girault@qorvo.com>
> >
> > Add an internal trace when new PANs get discovered. =20
>=20
> I guess this will not be the API for the user that there is a PAN
> discovered? Is it only for debugging purposes? There will be an
> nl802154 event for this? As we discussed previously with additional
> commands for start, discovered, etc.?
>=20
> I am sorry, maybe I can read that somewhere on your previous patch
> series, just want to be sure.

Yeah no problem, so yes, as you eventually saw in patch 1/3, the
internal tracing is just here for in-kernel debugging purposes, it's in
no way related to the user interface. It's a 2015 feature, we're just
adding support for tracing the new commands.

Let's discuss the nl user interface in the other thread.

Thanks,
Miqu=C3=A8l
