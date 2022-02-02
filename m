Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CD4A7225
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 14:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344703AbiBBNu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 08:50:56 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53251 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344737AbiBBNum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 08:50:42 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9447E6000D;
        Wed,  2 Feb 2022 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643809841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhOm+HGT2TvQNz0Cij+moD/CsXOWHG18qYnI0MFlAck=;
        b=inf9rbXwfM08jQCxkjl5EDviAJuF+lCJYDChgrG06Khd90PHLZEHu027tkvSB1YrApJLCV
        ZpM5ZJmWd+j7UiaiWmv1yWSdR6J7EIJTPYGu3MWADhN4hV+I6Kqv5hwIkJApBTSTQkVYvh
        TNvTlkga7kDNtBO2h/Rw9S4Ry6ZSIMMiwYnybZh578G747DsFv81gNpP7MzmnNe2EoRViG
        G0gn1ZF6gZ0RWsjSbKq5aFHNvkeX9LYUmah8UJsEWozerrpB8Y5v7/RXZ7kLqFXF27hTTO
        kRRluSnlmJYFGKxgbbT+JFxpcXJHDXZHCAZ0Dbgod8TyWcg67p5a4o32hF1Mgw==
Date:   Wed, 2 Feb 2022 14:50:34 +0100
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
Message-ID: <20220202145034.13a34e98@xps13>
In-Reply-To: <026d499d-2814-2d5a-b148-fd7ec8ae9eb6@datenfreihafen.org>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-6-miquel.raynal@bootlin.com>
        <20220201184014.72b3d9a3@xps13>
        <fab37d38-0239-8be3-81aa-98d163bf5ca4@datenfreihafen.org>
        <20220202084017.7a88f20d@xps13>
        <026d499d-2814-2d5a-b148-fd7ec8ae9eb6@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Wed, 2 Feb 2022 13:17:39 +0100:

> Hello.
>=20
> On 02.02.22 08:40, Miquel Raynal wrote:
> > Hi Stefan,
> >=20
> > stefan@datenfreihafen.org wrote on Tue, 1 Feb 2022 21:51:04 +0100:
> >  =20
> >> Hello.
> >>
> >> On 01.02.22 18:40, Miquel Raynal wrote: =20
> >>> Hi, =20
> >>>    >>>> --- a/drivers/net/ieee802154/ca8210.c =20
> >>>> +++ b/drivers/net/ieee802154/ca8210.c
> >>>> @@ -2978,7 +2978,6 @@ static void ca8210_hw_setup(struct ieee802154_=
hw *ca8210_hw)
> >>>>    	ca8210_hw->phy->cca.mode =3D NL802154_CCA_ENERGY_CARRIER;
> >>>>    	ca8210_hw->phy->cca.opt =3D NL802154_CCA_OPT_ENERGY_CARRIER_AND;
> >>>>    	ca8210_hw->phy->cca_ed_level =3D -9800;
> >>>> -	ca8210_hw->phy->symbol_duration =3D 16 * NSEC_PER_USEC;
> >>>>    	ca8210_hw->phy->lifs_period =3D 40;
> >>>>    	ca8210_hw->phy->sifs_period =3D 12; =20
> >>>
> >>> I've missed that error                ^^
> >>>
> >>> This driver should be fixed first (that's probably a copy/paste of the
> >>> error from the other driver which did the same).
> >>>
> >>> As the rest of the series will depend on this fix (or conflict) we co=
uld
> >>> merge it through wpan-next anyway, if you don't mind, as it was there
> >>> since 2017 and these numbers had no real impact so far (I believe). =
=20
> >>
> >> Not sure I follow this logic. The fix you do is being removed in 4/4 o=
f your v3 set again. So it would only be in place for these two in between =
commits. =20
> >=20
> > Exactly.
> >  =20
> >> As you laid out above this has been in place since 2017 and the number=
 have no real impact. Getting the fix in wpan-next to remove it again two p=
atches later would not be needed here.
> >>
> >> If you would like to have this fixed for 5.16 and older stable kernels=
 I could go ahead and apply it to wpan and let it trickle down into stable =
trees. =20
> >=20
> > I'm fine "ignoring" the issue in stable kernels, it was just a warning
> > for you that this would happen otherwise, given the fact that this is
> > the second driver doing so (first fix has already been merged) and that
> > I just realized it now.
> >  =20
> >> We would have to deal with either a merge of net into net-next or with
> >> a merge conflicts when sending the pull request. Both can be done.
> >>
> >> But given the circumstances above I have no problem to drop this fix c=
ompletely and have it fixed implicitly with the rest of the patchset. =20
> >=20
> > Fine by me! =20
>=20
> Let's do it like this.
> You drop it from this series against wpan-next.
> I will pull it out of the series and apply to wpan directly. That way we =
get it into the stable kernels as well. You already did the work so we shou=
ld not waste it.
> I will deal with the merge conflict get get between wpan/net and wpan-nex=
t/net-next on my side. Nothing to worry for you.

That's very kind, but don't feel forced to do that, I won't turn mad if
you finally decide that this requires too much handling for such a
short-in-time improvement ;)

Thanks,
Miqu=C3=A8l
