Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81692E7AF9
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgL3QNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgL3QNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 11:13:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0559C06179C;
        Wed, 30 Dec 2020 08:13:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ses/rnxWif7X2Xqokp4AmCDl72h9LsApLutXxNkbwaw=; b=FkJB71OHUrc83Rx/oK69Qh3Cp
        hc7+rnwwEkrgT5mv+9F1x72eMrDCy5PNVvjXt+QhhGzOJ8hTVY7Os2QHBhYGJx+TDaRhFuwHUh+2g
        ee+hHFF6v4CWSqZlajRRS42ENm/lmctnvBtQqmP999Q85yJl1c0vT38NYw+QW6h1Pnm0/lgvvOx7b
        WMDqbzyoicRADHClw9lpM+qN22IxhgbYxhXiLomengv3Y7YVFdzXDh5z5pbKqzw2Lh9p39aleLu4M
        498RlfTxTfIm/k/OEm7YNPbaj7C8dMHGUGLVOTenC3e3NGdoQsNsgOWaY+GQ3vBAVfuidB/9qTltj
        Ixj+iMOCQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44916)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kue63-0005ol-8m; Wed, 30 Dec 2020 16:13:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kue63-0002KW-02; Wed, 30 Dec 2020 16:13:11 +0000
Date:   Wed, 30 Dec 2020 16:13:10 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: sfp: assume that LOS is not implemented if both
 LOS normal and inverted is set
Message-ID: <20201230161310.GT1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-4-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230154755.14746-4-pali@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 04:47:54PM +0100, Pali Rohár wrote:
> Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> 
> Such combination of bits is meaningless so assume that LOS signal is not
> implemented.
> 
> This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> 
> Co-developed-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

No, this is not co-developed. The patch content is exactly what _I_
sent you, only the commit description is your own.

> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  drivers/net/phy/sfp.c | 36 ++++++++++++++++++++++--------------
>  1 file changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 73f3ecf15260..d47485ed239c 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1475,15 +1475,19 @@ static void sfp_sm_link_down(struct sfp *sfp)
>  
>  static void sfp_sm_link_check_los(struct sfp *sfp)
>  {
> -	unsigned int los = sfp->state & SFP_F_LOS;
> +	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
> +	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
> +	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
> +	bool los = false;
>  
>  	/* If neither SFP_OPTIONS_LOS_INVERTED nor SFP_OPTIONS_LOS_NORMAL
> -	 * are set, we assume that no LOS signal is available.
> +	 * are set, we assume that no LOS signal is available. If both are
> +	 * set, we assume LOS is not implemented (and is meaningless.)
>  	 */
> -	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED))
> -		los ^= SFP_F_LOS;
> -	else if (!(sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL)))
> -		los = 0;
> +	if (los_options == los_inverted)
> +		los = !(sfp->state & SFP_F_LOS);
> +	else if (los_options == los_normal)
> +		los = !!(sfp->state & SFP_F_LOS);
>  
>  	if (los)
>  		sfp_sm_next(sfp, SFP_S_WAIT_LOS, 0);
> @@ -1493,18 +1497,22 @@ static void sfp_sm_link_check_los(struct sfp *sfp)
>  
>  static bool sfp_los_event_active(struct sfp *sfp, unsigned int event)
>  {
> -	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
> -		event == SFP_E_LOS_LOW) ||
> -	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
> -		event == SFP_E_LOS_HIGH);
> +	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
> +	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
> +	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
> +
> +	return (los_options == los_inverted && event == SFP_E_LOS_LOW) ||
> +	       (los_options == los_normal && event == SFP_E_LOS_HIGH);
>  }
>  
>  static bool sfp_los_event_inactive(struct sfp *sfp, unsigned int event)
>  {
> -	return (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_INVERTED) &&
> -		event == SFP_E_LOS_HIGH) ||
> -	       (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_LOS_NORMAL) &&
> -		event == SFP_E_LOS_LOW);
> +	const __be16 los_inverted = cpu_to_be16(SFP_OPTIONS_LOS_INVERTED);
> +	const __be16 los_normal = cpu_to_be16(SFP_OPTIONS_LOS_NORMAL);
> +	__be16 los_options = sfp->id.ext.options & (los_inverted | los_normal);
> +
> +	return (los_options == los_inverted && event == SFP_E_LOS_HIGH) ||
> +	       (los_options == los_normal && event == SFP_E_LOS_LOW);
>  }
>  
>  static void sfp_sm_fault(struct sfp *sfp, unsigned int next_state, bool warn)
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
