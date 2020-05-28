Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78331E674F
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404927AbgE1QVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404897AbgE1QVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 12:21:20 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 892C7207D3;
        Thu, 28 May 2020 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590682880;
        bh=dK5URO1OumPfMBmpCNsQbD6yfHyQegOUpvi+PmcWe6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y5f/SkkPXFsA3TSlbfYIBka28usLbSuLbSG6ZkHDNRIOxS+4SrpNhuxaTuNQZ9GZG
         BeCDUBcJKOxY6Knnmpwja7GgmCHbYt361J9oU+KjNLWSsEgFDlc4G7BH9dsmetHiIs
         h07xrPZNmdig6wVgRDrSVEfraqe4atYZsBxb9+ec=
Date:   Thu, 28 May 2020 09:21:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, horatiu.vultur@microchip.com,
        allan.nielsen@microchip.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: Re: [PATCH net-next 02/11] net: mscc: ocelot: unexport
 ocelot_probe_port
Message-ID: <20200528092112.6892e6b5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527234113.2491988-3-olteanv@gmail.com>
References: <20200527234113.2491988-1-olteanv@gmail.com>
        <20200527234113.2491988-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 02:41:04 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is not being used by any other module except ocelot (i.e. felix
> does not use it). So remove the EXPORT_SYMBOL.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index e621c4c3ee86..ff875c2f1d46 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -2152,7 +2152,6 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
>  
>  	return err;
>  }
> -EXPORT_SYMBOL(ocelot_probe_port);
>  
>  /* Configure and enable the CPU port module, which is a set of queues.
>   * If @npi contains a valid port index, the CPU port module is connected

Strangely I get an error after this patch:

ERROR: modpost: "ocelot_probe_port"
[drivers/net/ethernet/mscc/ocelot_board.ko] undefined! make[2]: ***
[__modpost] Error 1 make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

Maybe a build system error, could you double check?
