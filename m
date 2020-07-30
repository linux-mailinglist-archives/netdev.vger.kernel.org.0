Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F96232C9B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 09:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgG3HaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 03:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG3HaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 03:30:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920F12070B;
        Thu, 30 Jul 2020 07:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596094224;
        bh=obI1cW5B2vkgbR1FTfLccdeC3SAat3jW9yYsILJxDWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=orK/glA1/hvlkXbeRL/ErCXplRTG2IdEYTZIOuVeFybdLjUDj+ooPomqVXeg43nNx
         KUv7nvvrlhzi9y8Gv4OlkglG+/K/2Ahej8yLlhBLQBriVuIocrEIT5rGr70LaYanAU
         Vpzlk51SlSihnn6OD4YaDjfQGoXhb9AAHTM+tzuk=
Date:   Thu, 30 Jul 2020 09:30:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        madalin.bucur@oss.nxp.com, camelia.groza@nxp.com,
        joakim.tjernlund@infinera.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 stable-5.4.y] Revert "dpaa_eth: fix usage as DSA
 master, try 3"
Message-ID: <20200730073013.GC4045776@kroah.com>
References: <20200624124517.3212326-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624124517.3212326-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 03:45:17PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This reverts commit 40a904b1c2e57b22dd002dfce73688871cb0bac8.
> 
> The patch is not wrong, but the Fixes: tag is. It should have been:
> 
> 	Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
> 
> which means that it's fixing a commit which was introduced in:
> 
> git tag --contains 060ad66f97954
> v5.5
> 
> which then means it should have not been backported to linux-5.4.y,
> where things _were_ working and now they're not.
> 
> Reported-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v1:
> Adjusted the commit message from linux-4.19.y to linux-5.4.y
> 
> Changes in v2:
> Fixed the sha1sum of the reverted commit.
> 
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 6683409fbd4a..4b21ae27a9fd 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2796,7 +2796,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Do this here, so we can be verbose early */
> -	SET_NETDEV_DEV(net_dev, dev->parent);
> +	SET_NETDEV_DEV(net_dev, dev);
>  	dev_set_drvdata(dev, net_dev);
>  
>  	priv = netdev_priv(net_dev);
> -- 
> 2.25.1
> 

Now queued up, thanks.

greg k-h
