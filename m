Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB35818066C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgCJSbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbgCJSbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 14:31:52 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0661208C3;
        Tue, 10 Mar 2020 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583865111;
        bh=P7jRn5rc6Vlr0wI8BHcgP80c/+R4LVaPHB4rCxyrb9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WC0OQx4IVu0ZXrEOxj+xaAgx/kk8P27AZKB8m+Jl40NArw1s1GEnlVezJK8bvPow4
         YFswb+zvFXv7xsnWpZCHlVAj3sfgY2cb5SMPFgtK6Ns00M8L/ShO1FrrX7TUljbvUy
         w/gqLaY3JeI1ybEFXHgVrqvDT4rjVVSb84/cwmps=
Date:   Tue, 10 Mar 2020 20:31:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Kiyanovski, Arthur" <akiyano@amazon.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "rmody@marvell.com" <rmody@marvell.com>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "skalluru@marvell.com" <skalluru@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "opendmb@gmail.com" <opendmb@gmail.com>,
        "siva.kallam@broadcom.com" <siva.kallam@broadcom.com>,
        "prashant@broadcom.com" <prashant@broadcom.com>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "tariqt@mellanox.com" <tariqt@mellanox.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "leedom@chelsio.com" <leedom@chelsio.com>,
        "ulli.kroll@googlemail.com" <ulli.kroll@googlemail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH net-next 01/15] net: ena: reject unsupported coalescing
 params
Message-ID: <20200310183147.GM242734@unreal>
References: <20200310021512.1861626-1-kuba@kernel.org>
 <20200310021512.1861626-2-kuba@kernel.org>
 <ba82e88dd3ac45a5a8e4527531d385c0@EX13D22EUA004.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba82e88dd3ac45a5a8e4527531d385c0@EX13D22EUA004.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 02:16:03PM +0000, Kiyanovski, Arthur wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, March 10, 2020 4:15 AM
> > To: davem@davemloft.net
> > Cc: netdev@vger.kernel.org; Kiyanovski, Arthur <akiyano@amazon.com>;
> > Belgazal, Netanel <netanel@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>;
> > irusskikh@marvell.com; f.fainelli@gmail.com; bcm-kernel-feedback-
> > list@broadcom.com; rmody@marvell.com; GR-Linux-NIC-Dev@marvell.com;
> > aelior@marvell.com; skalluru@marvell.com; GR-everest-linux-l2@marvell.com;
> > opendmb@gmail.com; siva.kallam@broadcom.com; prashant@broadcom.com;
> > mchan@broadcom.com; dchickles@marvell.com; sburla@marvell.com;
> > fmanlunas@marvell.com; tariqt@mellanox.com; vishal@chelsio.com;
> > leedom@chelsio.com; ulli.kroll@googlemail.com; linus.walleij@linaro.org;
> > Jakub Kicinski <kuba@kernel.org>
> > Subject: [EXTERNAL][PATCH net-next 01/15] net: ena: reject unsupported
> > coalescing params
> >
> > CAUTION: This email originated from outside of the organization. Do not click
> > links or open attachments unless you can confirm the sender and know the
> > content is safe.
> >
> >
> >
> > Set ethtool_ops->supported_coalesce_params to let the core reject
> > unsupported coalescing parameters.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > index 868265a2ec00..552d4cbf6dbd 100644
> > --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > @@ -826,6 +826,8 @@ static int ena_set_tunable(struct net_device *netdev,  }
> >
> >  static const struct ethtool_ops ena_ethtool_ops = {
> > +       .supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> > +                                    ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
> >         .get_link_ksettings     = ena_get_link_ksettings,
> >         .get_drvinfo            = ena_get_drvinfo,
> >         .get_msglevel           = ena_get_msglevel,
> > --
> > 2.24.1
>
>
> Acked-by: Sameeh Jubran <sameehj@amazon.com>

FROM author of this reply and Acked-by doesn't look the same.
Which one is correct?

Thanks
