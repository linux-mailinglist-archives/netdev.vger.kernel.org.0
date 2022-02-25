Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B2F4C4130
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbiBYJUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbiBYJUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:20:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1141E2556DF;
        Fri, 25 Feb 2022 01:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yYPUVP5GQIwWEdo8h5T3+bGMPbFu+4+s/h/axnM61nw=; b=16cSS+cG1MUu/K9gKOShh/CdQ1
        eCKW8Ab407GxMelqnW7AVk3fiLGQAeT1x6nUDAny00vARJn3d3cAk+YEe8jLXCVpZ7LlbWnLGrR8j
        yvJyoIdIcv0JQSv9em5cs2IIrb3DakIjlkJXGVg3CE/GCxyharbXVcu9OPlO4lobT0IKRMiQ8qblL
        sxB4idK7XdWDLo72REtEoZKfEflfjyypBV1gEbK7560ANZA4VVdLDr/jiN99C8WBBUPqmrXzYr4ZQ
        Mm7GwlFaq88R+JtC+mDqrpLLhBgx2HLNQhVg9K9j7ZdUgB6mZYLnjHlAWKX+hhbNYEj68Ft9IOO0N
        MFqx1oaQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57472)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNWlD-00053z-M6; Fri, 25 Feb 2022 09:19:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNWlB-0002vg-SA; Fri, 25 Feb 2022 09:19:33 +0000
Date:   Fri, 25 Feb 2022 09:19:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: phylink: check the return value of
 phylink_validate()
Message-ID: <YhifJcE98boImuHJ@shell.armlinux.org.uk>
References: <20220225091246.22085-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220225091246.22085-1-baijiaju1990@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 01:12:46AM -0800, Jia-Ju Bai wrote:
> The function phylink_validate() can fail, so its return value should be
> checked.
> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  drivers/net/phy/phylink.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 420201858564..597f7579b29f 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -584,7 +584,9 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>  
>  	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  	linkmode_copy(pl->link_config.advertising, pl->supported);
> -	phylink_validate(pl, pl->supported, &pl->link_config);
> +	ret = phylink_validate(pl, pl->supported, &pl->link_config);
> +	if (ret)
> +		return ret;

Completely unnecessary. pl->supported will be zero, leading to
phy_lookup_setting() failing.

>  	s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
>  			       pl->supported, true);
> @@ -1261,7 +1263,11 @@ struct phylink *phylink_create(struct phylink_config *config,
>  
>  	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  	linkmode_copy(pl->link_config.advertising, pl->supported);
> -	phylink_validate(pl, pl->supported, &pl->link_config);
> +	ret = phylink_validate(pl, pl->supported, &pl->link_config);
> +	if (ret < 0) {
> +		kfree(pl);
> +		return ERR_PTR(ret);
> +	}

Again, intentional not to be checking here.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
