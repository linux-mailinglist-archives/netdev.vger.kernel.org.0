Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2D4A62B3
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbiBARk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241593AbiBARkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:40:21 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D81C061714;
        Tue,  1 Feb 2022 09:40:20 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 75A106000A;
        Tue,  1 Feb 2022 17:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643737218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIzkclMLR/0ofZeGoiyZXiSCZMsNgk4mdcL9CiPgnxs=;
        b=UdPzrm3FSVuGZ79kQT2PRJ/gMjv8JxJU6lFaTaJCO+3b90o4j0qMaAbFPGUYnjJlB0c/65
        Lp1nKsrWlsTKIcVaLbhgvoV8VgmhWWOKW/zKvk/Ei5OY6aUX+lGVyx0s4YctduuJdZUBX1
        zEOFbNc44JutkGNnkJjUbw36FrylEG+cFaDwBDEVNxR5WiGFxShSHn5H8xzfP/tIMLycdr
        BLe0nyGFSW85zbD90F6vsZLfytMQ6EMC4kMi/G2gMt2AO2o6zdt8515Isi3SxYBa9m1zv3
        Axzxr2ZM/x6Y0kFhN8gOHk+EE5hjNqn2jHtG7W9uV6d5vUmYXJeTgfTeMf1Dsg==
Date:   Tue, 1 Feb 2022 18:40:14 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Subject: Re: [PATCH wpan-next v2 5/5] net: ieee802154: Drop duration
 settings when the core does it already
Message-ID: <20220201184014.72b3d9a3@xps13>
In-Reply-To: <20220128110825.1120678-6-miquel.raynal@bootlin.com>
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
        <20220128110825.1120678-6-miquel.raynal@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -2978,7 +2978,6 @@ static void ca8210_hw_setup(struct ieee802154_hw *c=
a8210_hw)
>  	ca8210_hw->phy->cca.mode =3D NL802154_CCA_ENERGY_CARRIER;
>  	ca8210_hw->phy->cca.opt =3D NL802154_CCA_OPT_ENERGY_CARRIER_AND;
>  	ca8210_hw->phy->cca_ed_level =3D -9800;
> -	ca8210_hw->phy->symbol_duration =3D 16 * NSEC_PER_USEC;
>  	ca8210_hw->phy->lifs_period =3D 40;
>  	ca8210_hw->phy->sifs_period =3D 12;

I've missed that error                ^^

This driver should be fixed first (that's probably a copy/paste of the
error from the other driver which did the same).

As the rest of the series will depend on this fix (or conflict) we could
merge it through wpan-next anyway, if you don't mind, as it was there
since 2017 and these numbers had no real impact so far (I believe).

I just figure this out now while searching for leftovers after a rebase
operation, sorry.

Thanks,
Miqu=C3=A8l
