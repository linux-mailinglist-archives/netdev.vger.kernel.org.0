Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC832361644
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbhDOXah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:30:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54528 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237446AbhDOXae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:30:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lXBQy-00GymV-MO; Fri, 16 Apr 2021 01:30:04 +0200
Date:   Fri, 16 Apr 2021 01:30:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 06/10] net: korina: Only pass mac address via
 platform data
Message-ID: <YHjMfOKyovyzTHOE@lunn.ch>
References: <20210414230648.76129-1-tsbogend@alpha.franken.de>
 <20210414230648.76129-7-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414230648.76129-7-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 01:06:43AM +0200, Thomas Bogendoerfer wrote:
> Get rid of access to struct korina_device by just passing the mac
> address via platform data and use drvdata for passing netdev to remove
> function.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  arch/mips/rb532/devices.c     |  5 +++--
>  drivers/net/ethernet/korina.c | 11 ++++++-----
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
> index dd34f1b32b79..5fc3c8ee4f31 100644
> --- a/arch/mips/rb532/devices.c
> +++ b/arch/mips/rb532/devices.c
> @@ -105,6 +105,9 @@ static struct platform_device korina_dev0 = {
>  	.name = "korina",
>  	.resource = korina_dev0_res,
>  	.num_resources = ARRAY_SIZE(korina_dev0_res),
> +	.dev = {
> +		.platform_data = &korina_dev0_data.mac,
> +	}

This is a bit unusual. Normally you define a structure in
include/linux/platform/data/koriana.h, and use that.

What about the name? "korina0" How is that passed?

     Andrew
