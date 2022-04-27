Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175A8511E1E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiD0PkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239747AbiD0PkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:40:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF6833E9E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wKAx5X79aLLYxQF6ZdIzFaQ4YMtS4q/ZNcGTaAl+XKI=; b=U9yR5fZ+r9NI1jhXzFnNPtp3XN
        YTwMzOBfB+oRHEtAzJN+tZirL/K5iTFUpKPiJaUM2Ni+OMv+2nRk4MoqUehZ0fy9kDa7t8DJZvspy
        UvamxEyX5Kl4OpCFIlAmIcmGNRBmRoTd/L4Wr9PjRIEXVxHNKXawFm/C1ltjS/+9j56w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1njjif-0008Ty-Vu; Wed, 27 Apr 2022 17:36:45 +0200
Date:   Wed, 27 Apr 2022 17:36:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 1/2] net: phy: microchip: update LAN88xx phy
 ID and phy ID mask.
Message-ID: <YmljDTD9j3REqi47@lunn.ch>
References: <20220427121957.13099-1-yuiko.oshino@microchip.com>
 <20220427121957.13099-2-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427121957.13099-2-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 05:19:56AM -0700, Yuiko Oshino wrote:
> update LAN88xx phy ID and phy ID mask because the existing code conflicts with the LAN8742 phy.
> 
> The current phy IDs on the available hardware.
>         LAN8742 0x0007C130, 0x0007C131
>         LAN88xx 0x0007C132
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
> ---
>  drivers/net/phy/microchip.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
> index 9f1f2b6c97d4..131caf659ed2 100644
> --- a/drivers/net/phy/microchip.c
> +++ b/drivers/net/phy/microchip.c
> @@ -344,8 +344,8 @@ static int lan88xx_config_aneg(struct phy_device *phydev)
>  
>  static struct phy_driver microchip_phy_driver[] = {
>  {
> -	.phy_id		= 0x0007c130,
> -	.phy_id_mask	= 0xfffffff0,
> +	.phy_id		= 0x0007c132,
> +	.phy_id_mask	= 0xfffffff2,

Just so my comment on the previous version does not get lost, is this
the correct mask, because it is very odd. I think you really want
0xfffffffe?

    Andrew
