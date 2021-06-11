Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5605D3A4622
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFKQHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:07:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhFKQHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 12:07:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pOUTLvcE1v7NqIp2eapNaGHmWwOnoyEPTjul5Q+Mgrg=; b=qHESekrPMAdarI+69K8BiSb6Ik
        xz/YrCBB6J2kUGVfkhu/z01rXghX3N6Kx/Vf/c3lTaczfwQ+KkAlUWll6+CGtGtwDYziOa4FbRa5Q
        x9Jll3iV/MQ1SKiEFgyKJ1aP/k06QNuGhUmyferxugIitTe7/nVraW4NSkoPHu+AJL48=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lrjeY-008sPM-6E; Fri, 11 Jun 2021 18:05:02 +0200
Date:   Fri, 11 Jun 2021 18:05:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 6/8] net: phy: print the function name by
 __func__ instead of an fixed string
Message-ID: <YMOJrv0ZRGCP26F7@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-7-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-7-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:36:57PM +0800, Weihang Li wrote:
> From: Wenpeng Liang <liangwenpeng@huawei.com>
> 
> It's better to use __func__ than a fixed string to print a
> function's name.
> 
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> Signed-off-by: Weihang Li <liweihang@huawei.com>
> ---
>  drivers/net/phy/mdio_device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
> index 0837319..c94cb53 100644
> --- a/drivers/net/phy/mdio_device.c
> +++ b/drivers/net/phy/mdio_device.c
> @@ -77,7 +77,7 @@ int mdio_device_register(struct mdio_device *mdiodev)
>  {
>  	int err;
>  
> -	dev_dbg(&mdiodev->dev, "mdio_device_register\n");
> +	dev_dbg(&mdiodev->dev, "%s\n", __func__);
>  
>  	err = mdiobus_register_device(mdiodev);
>  	if (err)
> @@ -188,7 +188,7 @@ int mdio_driver_register(struct mdio_driver *drv)
>  	struct mdio_driver_common *mdiodrv = &drv->mdiodrv;
>  	int retval;
>  
> -	pr_debug("mdio_driver_register: %s\n", mdiodrv->driver.name);
> +	pr_debug("%s: %s\n", __func__, mdiodrv->driver.name);

It would be nice to make this

        dev_dbg(&mdiodev->dev, "%s: %s\n", __func__, mdiodrv->driver.name);

	Andrew
