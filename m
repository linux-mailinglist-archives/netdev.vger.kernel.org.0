Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2AB3D8F71
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhG1NrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:47:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236691AbhG1NqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 09:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dJr5/InFEe21OM6ybxukBLEbeFlKPVFc6d3Sfz79n9w=; b=J9KE/1Irq3Z47wn2zFN2IGJnxx
        HZ+lx3rkUSB6A4HgfNCWE5atbzAMX1NucFsSSzPhllq4OETuFG7aIPwiTqtwL4Dmaw0ksW9KQ+FQB
        5fHRjERE5c95IJ8iVCHX++E+0WXndYyslCJzTvO7COSm94EgsDV73/Nt5FU9cy/EOF4Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8jsF-00FAt9-Ld; Wed, 28 Jul 2021 15:45:27 +0200
Date:   Wed, 28 Jul 2021 15:45:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: Re: [PATCH net-next 08/18] ravb: Add R-Car common features
Message-ID: <YQFfd6jcdyAPobIG@lunn.ch>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-9-biju.das.jz@bp.renesas.com>
 <d493b1d2-6d05-9eb3-c5f5-f3828938fe56@gmail.com>
 <TYCPR01MB59337E1C3F14B0E15F0626D986EA9@TYCPR01MB5933.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB59337E1C3F14B0E15F0626D986EA9@TYCPR01MB5933.jpnprd01.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -2205,8 +2235,10 @@ static int ravb_probe(struct platform_device
> > *pdev)
> > >  	}
> > >  	clk_prepare_enable(priv->refclk);
> > >
> > > -	ndev->max_mtu = 2048 - (ETH_HLEN + VLAN_HLEN + ETH_FCS_LEN);
> > > -	ndev->min_mtu = ETH_MIN_MTU;
> > > +	if (info->features & RAVB_OVERRIDE_MTU_CHANGE) {
> > 
> >    Why? :-/ Could you tell me more details?
> 
> RX buff size = 2048 for R-Car where as it is 8K for RZ/G2L.

RAVB_OVERRIDE_MTU_CHANGE is not the most descriptive name. You are not
overriding, you are setting the correct value for the hardware
variant.

Maybe name the feature RAVB_8K_BUFFERS or RAVB_2K_BUFFERS.

Also, putting more details in the commit message will help, and lots
of small patches, each patch doing one thing. It is much better to
have 40 simple, well documented, obviously correct patches, than 20
hard to understand patches. But please do submit them in small
batches, no more than 15 at once.

	 Andrew



