Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E054C9C16
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 04:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbiCBDXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 22:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiCBDXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 22:23:36 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AEB4969C;
        Tue,  1 Mar 2022 19:22:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BkUj0PjMdur0v9TShaniW/taG/R/Ra3dZF1SMMnxUms=; b=k0YSg7uXy1fj0hfP0jlFXcKxtR
        11zYwyIbh2N0zCDO0ChQtXVFrgmoKpGvYZCv6dbqbgDSZXMHeaAD+j5PU2MbPVeDC2GvixAXC5Ibk
        YDPa/NAZOIRj9XAmraCi19MiT51CGeyqHOfGi+1dsZYUmIy32V2mURxwZpObR+mgRQSU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nPFZk-008raJ-Mc; Wed, 02 Mar 2022 04:22:52 +0100
Date:   Wed, 2 Mar 2022 04:22:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/4] net: phy: added the LAN937x phy support
Message-ID: <Yh7jDF5CITerGkfF@lunn.ch>
References: <20220228140510.20883-1-arun.ramadoss@microchip.com>
 <20220228140510.20883-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228140510.20883-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 07:35:09PM +0530, Arun Ramadoss wrote:
> LAN937x T1 Phy is based on LAN87xx Phy, so reusing the init script of
> the Lan87xx. There is a workaround in accessing the DSP bank register
> for Lan937x Phy. Whenever there is a bank switch to DSP registers, then
> we need a dummy read access before proceeding to the actual register
> access.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/phy/microchip_t1.c | 47 +++++++++++++++++++++++++++++++---
>  1 file changed, 44 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
> index 33325e5bd884..634a1423182a 100644
> --- a/drivers/net/phy/microchip_t1.c
> +++ b/drivers/net/phy/microchip_t1.c
> @@ -10,6 +10,7 @@
>  #include <linux/ethtool_netlink.h>
>  
>  #define LAN87XX_PHY_ID			0x0007c150
> +#define LAN937X_T1_PHY_ID		0x0007c181

I guess the last 1 is meaningless, given the mask?

  Andrew
