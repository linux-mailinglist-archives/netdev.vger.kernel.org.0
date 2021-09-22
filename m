Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D5414CEE
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbhIVPZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232318AbhIVPZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 11:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E7C611CA;
        Wed, 22 Sep 2021 15:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632324220;
        bh=IpBkLTIQvIUZPkRaGwMHEUj4owQqlTkaaZEJ5Z2AWZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cPEi6jiO8TomHvLDhGygh5ypE8WXDmzCmL9R8h7hj/R1Kj2ox0S7hrwww9SK8AIxd
         rXvEJ2cOHRdoWrwfLUn3KqmFg/DOALNxwfTWJBoGnii2CFxFTHhZbXLMX8y2SvnYe/
         gGUNj5EMUpJodk7XVgujI43yIsjcPLh+xZLY32AyKeaOdtCn31pPY0M4/SNJwFCcrq
         cgUWk24Lz7DaLK13/CjJ1zOXKZ/Mk7IWwCuHjQP8773Rzp/NVHqCGm1B5MrqOf/m4A
         Lz59M2bXohUmDuYVbs8vSrRM58QmLcG9emmPxrQ2rrotL57Sz3jzqqAuTBqrY4twti
         W6FuR8WIBvprA==
Date:   Wed, 22 Sep 2021 17:23:36 +0200
From:   Simon Horman <horms@kernel.org>
To:     Ulrich Hecht <uli@fpond.eu>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
Subject: Re: [PATCH] can: rcar_can: Fix suspend/resume
Message-ID: <20210922152336.GA26223@kernel.org>
References: <20210921051959.50309-1-yoshihiro.shimoda.uh@renesas.com>
 <1020394138.1395460.1632220693209@webmail.strato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1020394138.1395460.1632220693209@webmail.strato.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 12:38:13PM +0200, Ulrich Hecht wrote:
> 
> > On 09/21/2021 7:19 AM Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com> wrote:
> > 
> >  
> > If the driver was not opened, rcar_can_suspend() should not call
> > clk_disable() because the clock was not enabled.
> > 
> > Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
> > ---
> >  drivers/net/can/rcar/rcar_can.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
> > index 00e4533c8bdd..6b4eefb03044 100644
> > --- a/drivers/net/can/rcar/rcar_can.c
> > +++ b/drivers/net/can/rcar/rcar_can.c

...

> > @@ -858,6 +860,7 @@ static int __maybe_unused rcar_can_suspend(struct device *dev)
> >  	priv->can.state = CAN_STATE_SLEEPING;
> >  
> >  	clk_disable(priv->clk);
> > +
> >  	return 0;
> >  }
> >  

nit: this hunk seems unrelated to the rest of the patch

...
