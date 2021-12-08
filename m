Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD2446DEE2
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbhLHXOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 18:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbhLHXOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 18:14:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A65C061746;
        Wed,  8 Dec 2021 15:10:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E6B25CE2404;
        Wed,  8 Dec 2021 23:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC52FC00446;
        Wed,  8 Dec 2021 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639005032;
        bh=CcTebSqQzVVeO2nbOHnvUj7TsFPdzktChqQy9mrGZoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/1+Xv89qz3HjEJ/EJGafEsIVDEgFPQFS2W2Jlnghbw4Qe4giE3p9WWOkiTvMIrfz
         NQZsB91kYKBlk6nPqjwUdxwS60Pd9SGNhy7yAXNAR8n0zkqEDKIsttaiDXX6NWWsId
         heyFwYbQ1JCVse166PXtaShavK47+ZbPGo6yaX/68MXI2pi0jXX/Jsf0veCAzLprXQ
         EQ+ZZMduVKbBFayTDlJN55XHagtZ/3bOz8dX7PXZ6zSPtA9GN9D499483JL9e7abT5
         uidXZvmk7qmLXO6vI9gwSzD30Z8paWipdpSvVA7JP5++E9sCvKFhr+DuZVml8qAEpM
         3Yhoo7sBp0xSA==
Date:   Wed, 8 Dec 2021 15:10:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?Sm9zw6kgRXhww7NzaXRv?= <jose.exposito89@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: dsa: felix: Fix memory leak in
 felix_setup_mmio_filtering
Message-ID: <20211208151030.1b489fad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211208181331.ptgtxg77yiz2zgb5@skbuf>
References: <20211208180509.32587-1-jose.exposito89@gmail.com>
        <20211208181331.ptgtxg77yiz2zgb5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:13:32 +0000 Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 07:05:09PM +0100, Jos=C3=A9 Exp=C3=B3sito wrote:
> > Addresses-Coverity-ID: 1492897 ("Resource leak")
> > Addresses-Coverity-ID: 1492899 ("Resource leak")
> > Signed-off-by: Jos=C3=A9 Exp=C3=B3sito <jose.exposito89@gmail.com>
> > --- =20
>=20
> Impossible memory leak, I might add, because DSA will error out much
> soon if there isn't any CPU port defined:
> https://elixir.bootlin.com/linux/v5.15.7/source/net/dsa/dsa2.c#L374
> I don't think I should have added the "if (cpu < 0)" check at all, but
> then it would have raised other flags, about BIT(negative number) or
> things like that. I don't know what's the best way to deal with this?
>=20
> Anyway, in case we find no better alternative:
>=20
> Fixes: 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during ini=
t and teardown")
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

If this is the way to go please repost with the tags added
and a commit message.
