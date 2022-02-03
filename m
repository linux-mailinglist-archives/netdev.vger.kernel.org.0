Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9FF4A8991
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbiBCRMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:12:42 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41260 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234879AbiBCRMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 12:12:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HJo/I3l4wFO/9NpQZqWaB0htK+k/JBcYRbYknRZ7Czo=; b=ge4WAqzgfHDWqwzzFcmE4ebVjb
        LZRF5Hx8F/Ios8TUSFd0lbL2fXLQfDMxyv4iNL2hDx6EpOeEzAG8LYAM2EwdniVes4dLzR6Ut5h95
        PQADusP3N4Df/FG7Ly9MfPcaoCRH1O48+RfprermzJn1h3p0LkYDE1QLw5Js5WASARIA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFfey-0049FM-Aw; Thu, 03 Feb 2022 18:12:40 +0100
Date:   Thu, 3 Feb 2022 18:12:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] sunhme: fix the version number in struct
 ethtool_drvinfo
Message-ID: <YfwNCAYc6Xyk8V8K@lunn.ch>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <3152336.aeNJFYEL58@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3152336.aeNJFYEL58@eto.sf-tec.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 05:22:23PM +0100, Rolf Eike Beer wrote:
> Fixes: 050bbb196392b9c178f82b1205a23dd2f915ee93
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>  drivers/net/ethernet/sun/sunhme.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 22abfe58f728..43834339bb43 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2470,8 +2470,8 @@ static void hme_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
>  {
>  	struct happy_meal *hp = netdev_priv(dev);
>  
> -	strlcpy(info->driver, "sunhme", sizeof(info->driver));
> -	strlcpy(info->version, "2.02", sizeof(info->version));
> +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));

I would suggest you drop setting info->version. The kernel will fill
it with the current kernel version, which is much more meaningful.

   Andrew
