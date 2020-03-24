Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F900190337
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgCXBPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:15:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgCXBPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LrnGabRFfP7/O/oZscjvA4hk2ztHoVB4/SiMfY0wHSs=; b=RRoFHLzINvWtGrS4O3S5laMNf/
        kIroWMjSXfT/PQLzkjyJl5LvVR5mridQHUa2I7vdXLJVHGCWVZ0ClmHCKkpNoOUJoIp7InUaZR/nL
        FStX9oPZTJmvg/IrrfPBRmq+KH00wef/LqvK3O0lnNpM1VJ+XIzJkO2xK9uM/ALpfMIg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYAL-0005Mr-5I; Tue, 24 Mar 2020 02:15:37 +0100
Date:   Tue, 24 Mar 2020 02:15:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 01/14] net: ks8851: Factor out spi->dev in
 probe()/remove()
Message-ID: <20200324011537.GI3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-2-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:50AM +0100, Marek Vasut wrote:
> Pull out the spi->dev into one common place in the function instead of
> having it repeated over and over again. This is done in preparation for
> unifying ks8851 and ks8851-mll drivers. No functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/micrel/ks8851.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
> index 33305c9c5a62..d1e0116c9728 100644
> --- a/drivers/net/ethernet/micrel/ks8851.c
> +++ b/drivers/net/ethernet/micrel/ks8851.c
> @@ -1413,6 +1413,7 @@ static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
>  
>  static int ks8851_probe(struct spi_device *spi)
>  {
> +	struct device *dev = &spi->dev;
>  	struct net_device *ndev;
>  	struct ks8851_net *ks;
>  	int ret;

Hi Marek

The naming in probe appears to be different to the rest of the
driver. Normally dev is a strict net_device. Here it is a struct
device and ndev is a net_device. Sometimes netdev is also used.

It might be a bigger change than what you want to do, but it would be
nice if it was consistent everywhere.

     Andrew
