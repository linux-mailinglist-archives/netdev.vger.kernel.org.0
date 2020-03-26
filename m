Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97F219422F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 15:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgCZO6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 10:58:11 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:46670 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgCZO6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 10:58:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mTjPEJu+QkU3fI0mJj42IMjiIlzgL6R60YMdQoKc3oc=; b=KIjfvbccPd2baQQYlJVF49MvG
        g9s1orjCx5h/3/xipDgJJtLVOuqpcap6pyMWHLoUuVhKvcpIi3u38GZITMRx8Mf/7FezT6GCXnYCx
        Xyl2JtXSsu87NBBjJrIRnEUWysSenbuiPkbX3OKU6U92BJxwuO+kpL70L4kJW2VlHRfrkN7PXtRmb
        qEGiCA1wRmmmTnBO/6xQ8nxoU24GEiA5uw39wnArFcdzJTv7aae1h30QF/O00zKLio8oxWhKaTDK9
        KMiz2vpoYrl3nHOj9v2ioAXz/eaD6rfMjZ+AO4Yj1RRE3h6/cp5r/yMqNr0V+7hbdjX4hgwyBE0zO
        kz7Rmuhdg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41644)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jHTxI-0003zz-Ah; Thu, 26 Mar 2020 14:58:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jHTx8-0003Ih-PH; Thu, 26 Mar 2020 14:57:50 +0000
Date:   Thu, 26 Mar 2020 14:57:50 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [RFC net-next 0/2] split phylink PCS operations and add PCS
 support for dpaa2
Message-ID: <20200326145750.GA25745@shell.armlinux.org.uk>
References: <20200317144944.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317144944.GP25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Was there any conclusion on this 5 patch series, and whether I should
submit it for net-next?

The discussion around patch 2 seems to have tailed off, and no one
seems to have replied to patches 3 to 5.

Thanks.

On Tue, Mar 17, 2020 at 02:49:44PM +0000, Russell King - ARM Linux admin wrote:
> This series splits the phylink_mac_ops structure so that PCS can be
> supported separately with their own PCS operations, and illustrates
> the use of the helpers in the previous patch series (net: add phylink
> support for PCS) in the DPAA2 driver.
> 
> This is prototype code, not intended to be merged yet, and is merely
> being sent for illustrative purposes only.
> 
>  arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi   | 144 +++++++++++++++
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 226 ++++++++++++++++++++++-
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h |   1 +
>  drivers/net/phy/phylink.c                        | 102 ++++++----
>  include/linux/phylink.h                          |  11 ++
>  5 files changed, 446 insertions(+), 38 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
