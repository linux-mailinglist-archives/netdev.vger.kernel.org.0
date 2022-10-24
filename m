Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BDE60A91C
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 15:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiJXNPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 09:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbiJXNOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 09:14:43 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90234A286E;
        Mon, 24 Oct 2022 05:25:38 -0700 (PDT)
Received: from relay5-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::225])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 0F692CEB89;
        Mon, 24 Oct 2022 12:18:09 +0000 (UTC)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E5C7A1C000A;
        Mon, 24 Oct 2022 12:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666613766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GADkgyfxmXlX6TdV6zf6SMGC4DVogV2LnJ1R/R8cq2I=;
        b=TY+PywmlcxjDR1hNtVcM/XjPkRQMiPggkvxT0+tSnSHKuAZZ4h99Hsp9KbBXP4ywlKOuYB
        dwZ+RIu4B5k/xWh2duYwOfMTU4YN27fU+Dhjel5tzgB/ul5NyAOXjlozHZm3I2euLfPT53
        nCaWJfsh49lo3Fl7Bynxxw1hZi9Y3ReNyvVogS4buvinvcHzu6pS7MjgZGA71cntAhsd7k
        rAeSHkZToIsv93huvtdeRDx+Z7l4So7yxgWnInUF7xQuhxVaKPKTDYzHdN5AVsT6xoCFEu
        IbQ2vOzF5dtf8R8FjWB4BkaVoW69y8hIfD/9uSeiX1Q+CXQU49iOruGzBo9NVA==
Date:   Mon, 24 Oct 2022 14:16:01 +0200
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
Subject: Re: [PATCH wpan-next] mac802154: Allow the creation of coordinator
 interfaces
Message-ID: <20221024141601.218b68e2@xps-13>
In-Reply-To: <CAK-6q+jna-UXWVvTjnJnJ+LADB0oP_WmVJV0N5r00cb1tfhkpA@mail.gmail.com>
References: <20221018183639.806719-1-miquel.raynal@bootlin.com>
        <CAK-6q+hoJiLWyHNi90_7kbyGp9h_jV-bvRHYRQDVrEb1u_enEA@mail.gmail.com>
        <20221019115242.571c19bb@xps-13>
        <CAK-6q+jna-UXWVvTjnJnJ+LADB0oP_WmVJV0N5r00cb1tfhkpA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

> > About the way we handle the PAN coordinator role I have a couple of
> > questions:
> > - shall we consider only the PAN coordinator to be able to accept
> >   associations or is any coordinator in the PAN able to do it? (this is
> >   not clear to me) =20
>=20
> Me either, it sounds for me that coordinators are "leaves" and pan
> coordinators are not. It is like in IPv6 level it is a host or router.

I went through the spec once again and I actually (re)discovered
Annexe E "Time-slot relaying based link extension (TRLE)" which indeed
seems to tell us that relaying is an extension, so otherwise
coordinators are "leaves" as you say.

> > - If a coordinator receives a packet with no destination it should
> >   expect it to be targeted at the PAN controller. Should we consider
> >   relaying the packet? =20
>=20
> I guess it depends what the standard says here?

While we don't implement TRLE (and this is a project on its own) I
guess we should not perform any relaying.

> > - Is relaying a hardware feature or should we do it in software?
> > =20
>=20
> I think for SoftMAC it is only the address filter which needs to be
> changed. The rest is in software. So far what I can see here.

If we need to change the address filters then I guess the hardware is
broken, it would not be usable. The hardware must have a "PAN
controller" bit to know whether or not the packet must be dropped or
not when there is no destination field.

> Question is what we are using here in the Linux kernel to provide such
> functionality...
>=20
> e.g. see:
>=20
> include/net/dst.h
>
> > Regarding the situation where we would have NODE + MONITOR or COORD +
> > MONITOR, while the interface creation would work, both could not be
> > open at the same time because the following happens:
> > mac802154_wpan_open() {
> >         ieee802154_check_concurrent_iface() {
> >                 ieee802154_check_mac_settings() {
> >                         /* prevent the two interface types from being
> >                          * open at the same time because the filtering
> >                          * needs are not compatible. */
> >                 }
> >         }
> > }
> >
> > Then, because you asked me to anticipate if we ever want to support more
> > than one NODE or COORD interface at the same time, or at least not to
> > do anything that would lead to a step back on this regard, I decided I
> > would provide all the infrastructure to gracefully handle this
> > situation in the Rx path, even though right now it still cannot happen
> > because when opening an interface, ieee802154_check_concurrent_iface()
> > will also prevent two NODE / COORD interfaces to be opened at the same
> > time. =20
>=20
> yes, but you are assuming the actual hardware here. A hardware with
> multiple address filters can indeed support other interfaces at the
> same time. I can also name one, hwsim and a real one - atusb.

I have this use case in mind, I know the support for it may be
brought at some point, and I think my proposal is future proof on this
aspect. Isn't it?

Thanks,
Miqu=C3=A8l
