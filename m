Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCC00348C05
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 10:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCYI7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 04:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCYI7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 04:59:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C94C06174A;
        Thu, 25 Mar 2021 01:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YSMq9K94SLMNFk6Q3E9dbxOo81Ihzvj6PbV9ppKeRHo=; b=mL5eEQ85y+GHxmHEaDsecPFYY
        m5ssBOR51oWbueT4dvzHRMp4WWe2Y30EgpGawMsc3VkUxA6MQUuNLdvroWpddKI9TCEgKEXVn4moz
        yWup6vpz185Wzn8rSeFuXsf6BabGxj7WjrttETRAwKvdvhwQr6RSfD29jp5Sj62JaFCCrBMDs4ckA
        RIVTzKtdIj7f5+lZrb1L2os+5sUScVkacrjqLvVJVBIGGWA+Nsq7hSm/Wy7E9ooTSIghJU1KnMoub
        0q3ZpOQC+DKE22yELVoUgBEZbiFeCksnutuNBhkp8yu+tX5+sKyDhxkQeq176RUGXQoJP3ewweLr/
        vU6XWMdqA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51708)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lPLpa-0001Sm-Nv; Thu, 25 Mar 2021 08:59:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lPLpX-0005t4-2i; Thu, 25 Mar 2021 08:59:03 +0000
Date:   Thu, 25 Mar 2021 08:59:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, qiangqing.zhang@nxp.com,
        vee.khee.wong@intel.com, fugang.duan@nxp.com,
        kim.tatt.chuah@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v3 2/2] net: pcs: configure xpcs 2.5G speed mode
Message-ID: <20210325085902.GK1463@shell.armlinux.org.uk>
References: <20210325083806.19382-1-michael.wei.hong.sit@intel.com>
 <20210325083806.19382-3-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325083806.19382-3-michael.wei.hong.sit@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 04:38:06PM +0800, Michael Sit Wei Hong wrote:
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 12a047d47dec..c95dfe4e5310 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -290,6 +290,8 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>  
>  		switch (pl->link_config.interface) {
>  		case PHY_INTERFACE_MODE_SGMII:
> +			phylink_set(pl->supported, 2500baseT_Full);
> +			fallthrough;

This is wrong. "SGMII" here means 1G SGMII. See the documentation in
Documentation/networking/phy.rst.

If we want to have this at 2.5G speed, then we need a separate
enumeration for that mode, just like we make a distinction between
1000BASE-X and 2500BASE-X.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
