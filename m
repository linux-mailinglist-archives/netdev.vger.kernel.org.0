Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE0126801
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfLSR2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:28:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37114 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbfLSR2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:28:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8zbAzNcfI9oZ8v2ntYbWufi4k/9wq+l907iSnZf7FUU=; b=JCGh18A4PCK/syxO0EHwoSBYV
        GJY9Xh1XgWA/1ErUDsZmPaD49K/DdJzNttu0WKagLhKCq9E711XrlzoL3vam914Lxv/Lq2y3WL0te
        V0MX7ay20xSl4NYHh1GX0AGiaIDatTAUiZYeoMkD7mRs34iN38nU0MGiicqDNMOma7gQ30LwGd1tm
        gbu1osGT/LwYpIQcbG3Fxa0LWQS3ry0cBr03xm9EFPoOCaTLePgKQFdGJMqZpqHfHj+ujS0ctOXz9
        ax/IJView/HciZicjXKrXlGCmP3+5qWTi2TSeYfjkx3/GBMUE7p0H9i6qfOF2214eeAP0PLOq3nDL
        Ds8hCmMzQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55164)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihzbK-0003pn-8y; Thu, 19 Dec 2019 17:28:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihzbG-0005XL-Kp; Thu, 19 Dec 2019 17:28:34 +0000
Date:   Thu, 19 Dec 2019 17:28:34 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     madalin.bucur@nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191219172834.GC25745@shell.armlinux.org.uk>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 05:21:16PM +0200, Madalin Bucur wrote:
> From: Madalin Bucur <madalin.bucur@nxp.com>
> 
> Add explicit entries for XFI, SFI to make sure the device
> tree entries for phy-connection-type "xfi" or "sfi" are
> properly parsed and differentiated against the existing
> backplane 10GBASE-KR mode.

10GBASE-KR is actually used for XFI and SFI (due to a slight mistake on
my part, it should've been just 10GBASE-R).

Please explain exactly what the difference is between XFI, SFI and
10GBASE-R. I have not been able to find definitive definitions for
XFI and SFI anywhere, and they appear to be precisely identical to
10GBASE-R. It seems that it's just a terminology thing, with
different groups wanting to "own" what is essentially exactly the
same interface type.

> 
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> ---
>  include/linux/phy.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 5032d453ac66..ebb793621f0b 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -99,7 +99,8 @@ typedef enum {
>  	PHY_INTERFACE_MODE_2500BASEX,
>  	PHY_INTERFACE_MODE_RXAUI,
>  	PHY_INTERFACE_MODE_XAUI,
> -	/* 10GBASE-KR, XFI, SFI - single lane 10G Serdes */
> +	PHY_INTERFACE_MODE_XFI,
> +	PHY_INTERFACE_MODE_SFI,
>  	PHY_INTERFACE_MODE_10GKR,
>  	PHY_INTERFACE_MODE_USXGMII,
>  	PHY_INTERFACE_MODE_MAX,
> @@ -175,6 +176,10 @@ static inline const char *phy_modes(phy_interface_t interface)
>  		return "rxaui";
>  	case PHY_INTERFACE_MODE_XAUI:
>  		return "xaui";
> +	case PHY_INTERFACE_MODE_XFI:
> +		return "xfi";
> +	case PHY_INTERFACE_MODE_SFI:
> +		return "sfi";
>  	case PHY_INTERFACE_MODE_10GKR:
>  		return "10gbase-kr";
>  	case PHY_INTERFACE_MODE_USXGMII:
> -- 
> 2.1.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
