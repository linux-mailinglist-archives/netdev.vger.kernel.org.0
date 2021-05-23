Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF70D38DB69
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 16:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhEWO2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 10:28:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhEWO2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 10:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=cO97GQt7mIQ0ZMqdaTb0HibQ77osXtd0Ea5KRZD1PD8=; b=m8
        3mZcoKNanSeG+LzXhY4bt7KTO7qR7ZWahRLy9Nz22llXW9Fmiu8bnyBRGFX583JgPqWgr8kmJL7Dn
        sRdZ9oDBdLYUvCIdNMGzMuzQgyZfU0mKOSPuvsIJeH+//NJ/2fe3nFLBgIvxH77LyKLxLP8496efq
        elPtFT2803BeItc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lkp46-005mqx-9n; Sun, 23 May 2021 16:26:50 +0200
Date:   Sun, 23 May 2021 16:26:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        rasmus.villemoes@prevas.dk, kuba@kernel.org, davem@davemloft.net,
        leoyang.li@nxp.com
Subject: Re: [PATCH net-next] ethernet: ucc_geth: Use kmemdup() rather than
 kmalloc+memcpy
Message-ID: <YKpmKln1Z/UvZgZQ@lunn.ch>
References: <20210523075616.14792-1-yuehaibing@huawei.com>
 <20210523152937.Horde.5kC0kzvaP3No5BC63LlZ_A7@messagerie.c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210523152937.Horde.5kC0kzvaP3No5BC63LlZ_A7@messagerie.c-s.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 23, 2021 at 03:29:37PM +0200, Christophe Leroy wrote:
> YueHaibing <yuehaibing@huawei.com> a écrit :
> 
> > Issue identified with Coccinelle.
> > 
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >  drivers/net/ethernet/freescale/ucc_geth.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/freescale/ucc_geth.c
> > b/drivers/net/ethernet/freescale/ucc_geth.c
> > index e0936510fa34..51206272cc25 100644
> > --- a/drivers/net/ethernet/freescale/ucc_geth.c
> > +++ b/drivers/net/ethernet/freescale/ucc_geth.c
> > @@ -3590,10 +3590,10 @@ static int ucc_geth_probe(struct
> > platform_device* ofdev)
> >  	if ((ucc_num < 0) || (ucc_num > 7))
> >  		return -ENODEV;
> > 
> > -	ug_info = kmalloc(sizeof(*ug_info), GFP_KERNEL);
> > +	ug_info = kmemdup(&ugeth_primary_info, sizeof(*ug_info),
> > +			  GFP_KERNEL);
> 
> Can you keep that as a single line ? The tolerance is 100 chars per line now.

Networking prefers 80. If it fits a single 80 char line, please use a single line.
Otherwise please leave it as it is.

	   Andrew
