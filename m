Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0F64A6C66
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 08:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbiBBHkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 02:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiBBHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 02:40:22 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9349CC061714;
        Tue,  1 Feb 2022 23:40:21 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 56AB3C0004;
        Wed,  2 Feb 2022 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643787620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zsOj/eK+TtUHvLBFRhbaoTMI8pDkaCDWImw1CNXSGHc=;
        b=lCEMQ10DkyahsCu1fZoYpm8y/Gx23iV7at2b6Bwsd8j0avIiENzV8pH9Ov9mmADdirwK5l
        OoEIt9Zf9BE/DyCcPsHa+RO2BhzCdAxq+E2ZQIuq5dLrAUbtqsWVuugnr8dEQktlOC65/6
        s9Z8zh+lqL687j33MBMbojpvWsiKb4oFZ95hMLQgTDh5G0G6wxsMO/jQdmln89an9K08ke
        LjtiI7y9HnTInRMWcTAPc4m1srCjaeQghVtmUg9gEKjPSQnFtAxJ+zGNizfXZoAUCnaj/R
        HKTmQzqOeJR/KlpDjQz23UoXQ1lIUKml+772ZQ4lAtx/ljwdq4tXzSYberKSiw==
Date:   Wed, 2 Feb 2022 08:40:17 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Subject: Re: [PATCH wpan-next v2 5/5] net: ieee802154: Drop duration
 settings when the core does it already
Message-ID: <20220202084017.7a88f20d@xps13>
In-Reply-To: <fab37d38-0239-8be3-81aa-98d163bf5ca4@datenfreihafen.org>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-6-miquel.raynal@bootlin.com>
        <20220201184014.72b3d9a3@xps13>
        <fab37d38-0239-8be3-81aa-98d163bf5ca4@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Tue, 1 Feb 2022 21:51:04 +0100:

> Hello.
>=20
> On 01.02.22 18:40, Miquel Raynal wrote:
> > Hi,
> >  =20
> >> --- a/drivers/net/ieee802154/ca8210.c
> >> +++ b/drivers/net/ieee802154/ca8210.c
> >> @@ -2978,7 +2978,6 @@ static void ca8210_hw_setup(struct ieee802154_hw=
 *ca8210_hw)
> >>   	ca8210_hw->phy->cca.mode =3D NL802154_CCA_ENERGY_CARRIER;
> >>   	ca8210_hw->phy->cca.opt =3D NL802154_CCA_OPT_ENERGY_CARRIER_AND;
> >>   	ca8210_hw->phy->cca_ed_level =3D -9800;
> >> -	ca8210_hw->phy->symbol_duration =3D 16 * NSEC_PER_USEC;
> >>   	ca8210_hw->phy->lifs_period =3D 40;
> >>   	ca8210_hw->phy->sifs_period =3D 12; =20
> >=20
> > I've missed that error                ^^
> >=20
> > This driver should be fixed first (that's probably a copy/paste of the
> > error from the other driver which did the same).
> >=20
> > As the rest of the series will depend on this fix (or conflict) we could
> > merge it through wpan-next anyway, if you don't mind, as it was there
> > since 2017 and these numbers had no real impact so far (I believe). =20
>=20
> Not sure I follow this logic. The fix you do is being removed in 4/4 of y=
our v3 set again. So it would only be in place for these two in between com=
mits.

Exactly.

> As you laid out above this has been in place since 2017 and the number ha=
ve no real impact. Getting the fix in wpan-next to remove it again two patc=
hes later would not be needed here.
>=20
> If you would like to have this fixed for 5.16 and older stable kernels I =
could go ahead and apply it to wpan and let it trickle down into stable tre=
es.

I'm fine "ignoring" the issue in stable kernels, it was just a warning
for you that this would happen otherwise, given the fact that this is
the second driver doing so (first fix has already been merged) and that
I just realized it now.

> We would have to deal with either a merge of net into net-next or with
> a merge conflicts when sending the pull request. Both can be done.
>=20
> But given the circumstances above I have no problem to drop this fix comp=
letely and have it fixed implicitly with the rest of the patchset.

Fine by me!

Thanks,
Miqu=C3=A8l
