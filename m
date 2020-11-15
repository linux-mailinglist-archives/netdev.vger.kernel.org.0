Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB082B3311
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 09:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgKOI4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 03:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgKOI4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 03:56:20 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B913223FB;
        Sun, 15 Nov 2020 08:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605430113;
        bh=Rb5YMKuDhGA8y27ozdkJkBkaoCrinqJTdOX9QLayzaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SLqbXgfYurGq37YLB0Ug66DB0D9xSxF2FZ4C4qLsdTFOmGSlYVuDDz37jWUzyIlZ9
         e5d/jh28ccpFk1tPHu81sQROPRKMJLTy+NYWQxP1ufza1JjvWTXnkgSlgyTmUB3dQl
         he5s7um2zxLE/FLL2yTJ6OuzfLuP5BBZ5wxLA+E0=
Date:   Sun, 15 Nov 2020 09:48:27 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <uwe@kleine-koenig.org>,
        Michal Hrusecki <Michal.Hrusecky@nic.cz>,
        Tomas Hlavacek <tomas.hlavacek@nic.cz>,
        =?UTF-8?B?QmVkxZlpY2hhIEtvxaFhdHU=?= <bedrich.kosata@nic.cz>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Jason Cooper <jason@lakedaemon.net>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: mvneta: Fix validation of 2.5G HSGMII
 without comphy
Message-ID: <20201115094827.74eacbc3@kernel.org>
In-Reply-To: <20201115004151.12899-1-afaerber@suse.de>
References: <20201115004151.12899-1-afaerber@suse.de>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 01:41:51 +0100
Andreas F=C3=A4rber <afaerber@suse.de> wrote:

> -	if (pp->comphy || state->interface =3D=3D PHY_INTERFACE_MODE_2500BASEX)=
 {
> +	if (pp->comphy || state->interface =3D=3D PHY_INTERFACE_MODE_2500BASEX
> +		       || state->interface =3D=3D PHY_INTERFACE_MODE_NA) {
>  		phylink_set(mask, 2500baseT_Full);
>  		phylink_set(mask, 2500baseX_Full);
>  	}

No, this will cause, on systems without comphy described, phylink to
think that 2500baseX/T is possible. But without comphy how can it be
configured?

Marek
