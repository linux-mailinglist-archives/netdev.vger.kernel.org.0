Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7988230D0A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730673AbgG1PGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbgG1PGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:06:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3E8C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 08:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sQ/dFteZ5SgA63QSEmqp7T7dblgp/te9PEmlmEe3Oho=; b=ZoFpvtRHTNYY8ewQtel/lKW4P
        rZUyUga44GWUSSRcWtq9p51eJ8lKFMFm8x8xA+ewAO93zhOSLyW8hnmSUY4hH3q3JGTOCyIbAiURN
        8oLVy/4uoyEMl7exPzUziXLSnSNnas8XkW7DAPXPUk6fcAeUFtZ38197CRWCxlrYafXHKoEH62ssk
        tylNYHZUDvypQnOjqbxJjGclANX4LxWwpdK0eiZOhih8cwrmL0K3d5dmgZ973X70A1x9rqWwfYHW/
        tWWFnyuIXurNMYO6L+lJcSJtH+tVh4N9n69H798D5jUXW3IYkvsMhnylNex9th8vWaBDu+fCEWCQl
        Eqv07wRkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45278)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0RBb-0004Oo-QQ; Tue, 28 Jul 2020 16:06:35 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0RBb-0004kK-FP; Tue, 28 Jul 2020 16:06:35 +0100
Date:   Tue, 28 Jul 2020 16:06:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com
Subject: Re: [PATCH net-next v4 2/5] net: phylink: consider QSGMII interface
 mode in phylink_mii_c22_pcs_get_state
Message-ID: <20200728150635.GP1551@shell.armlinux.org.uk>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
 <20200724080143.12909-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724080143.12909-3-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:01:40AM +0300, Ioana Ciornei wrote:
> The same link partner advertisement word is used for both QSGMII and
> SGMII, thus treat both interface modes using the same
> phylink_decode_sgmii_word() function.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> Changes in v4:
>  - none
> 
>  drivers/net/phy/phylink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index d7810c908bb3..0219ddf94e92 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2404,6 +2404,7 @@ void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
>  		break;
>  
>  	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_QSGMII:
>  		phylink_decode_sgmii_word(state, lpa);
>  		break;
>  
> -- 
> 2.25.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
