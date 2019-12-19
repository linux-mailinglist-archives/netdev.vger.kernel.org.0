Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F7512681F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLSRaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:30:23 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37186 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSRaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:30:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=joiIL60i33gQwU7JNxW0f8NaOlF7POfgRUGaP64zU60=; b=HJKmIxFxgR1VFLr/8cqtc/no6
        CgTOKTDq07ieyqGWpEpxV8UH8XHAmuFDsBz88OLmYeU9UREfooy9Ffxwevk7pCLeHHuIi7DkUCdL/
        TAKrHCZdXh1uimmJ3onDz+U803HzhhOo+KzkivAObHX6e58ffMpMkLVJKaXXUxG1DyBCYaxx7wFKA
        a+5AXduyVqo9kDPNfTwerL0H9vDfBXnIK/DRA3ui8EmMxBqa0EalR6yIlQU5RYdYDSCiiAN1RFhjh
        VeM+D1cvUkrn9aU78A4HhmVkqHoKXsD8eS7AxmLhox61ghZoNVbG6CYw34xAvqzcn96fHnPzVsALl
        hDBR8RI5A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43512)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihzcw-0003qu-2f; Thu, 19 Dec 2019 17:30:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihzcu-0005XU-Hm; Thu, 19 Dec 2019 17:30:16 +0000
Date:   Thu, 19 Dec 2019 17:30:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     madalin.bucur@nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        devicetree@vger.kernel.org,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Subject: Re: [PATCH 5/6] net: fsl/fman: add support for PHY_INTERFACE_MODE_SFI
Message-ID: <20191219173016.GD25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-6-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576768881-24971-6-git-send-email-madalin.bucur@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 05:21:20PM +0200, Madalin Bucur wrote:
> Add support for the SFI PHY interface mode.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 2 ++
>  drivers/net/ethernet/freescale/fman/mac.c        | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index d0b12efadd6c..09fdec935bf2 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -440,6 +440,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
>  	tmp = 0;
>  	switch (phy_if) {
>  	case PHY_INTERFACE_MODE_XFI:
> +	case PHY_INTERFACE_MODE_SFI:

No difference between these two.

>  	case PHY_INTERFACE_MODE_XGMII:
>  		tmp |= IF_MODE_10G;
>  		break;
> @@ -456,6 +457,7 @@ static int init(struct memac_regs __iomem *regs, struct memac_cfg *cfg,
>  	/* TX_FIFO_SECTIONS */
>  	tmp = 0;
>  	if (phy_if == PHY_INTERFACE_MODE_XFI ||
> +	    phy_if == PHY_INTERFACE_MODE_SFI ||

Again, no difference between these two.

>  	    phy_if == PHY_INTERFACE_MODE_XGMII) {
>  		if (slow_10g_if) {
>  			tmp |= (TX_FIFO_SECTIONS_TX_AVAIL_SLOW_10G |
> diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
> index 2944188c19b3..5e6317742c38 100644
> --- a/drivers/net/ethernet/freescale/fman/mac.c
> +++ b/drivers/net/ethernet/freescale/fman/mac.c
> @@ -542,6 +542,7 @@ static const u16 phy2speed[] = {
>  	[PHY_INTERFACE_MODE_QSGMII]		= SPEED_1000,
>  	[PHY_INTERFACE_MODE_XGMII]		= SPEED_10000,
>  	[PHY_INTERFACE_MODE_XFI]		= SPEED_10000,
> +	[PHY_INTERFACE_MODE_SFI]		= SPEED_10000,

Again, no difference between these two.

>  };
>  
>  static struct platform_device *dpaa_eth_add_device(int fman_id,
> @@ -800,6 +801,7 @@ static int mac_probe(struct platform_device *_of_dev)
>  
>  	/* The 10G interface only supports one mode */
>  	if (mac_dev->phy_if == PHY_INTERFACE_MODE_XFI ||
> +	    mac_dev->phy_if == PHY_INTERFACE_MODE_SFI ||

Again, no difference between these two.

I just don't see the point of perpetuating the XFI and SFI names for
something that is just plain 10GBASE-R.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
