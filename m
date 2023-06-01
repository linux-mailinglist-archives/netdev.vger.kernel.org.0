Return-Path: <netdev+bounces-7040-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFE8A71965B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:06:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ABD51C20FFB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 09:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED9E13AF0;
	Thu,  1 Jun 2023 09:06:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35FB5231
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 09:06:12 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F23B18B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 02:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZM0wnJ/wORbhVZDLJUKMmdTIy570Xw0xRNEsnIgPgr0=; b=BLze9DsklPHZnYMl6B7xoV4d/P
	EnjhIIHBXYtPKfPTaX2cFA1ZQiJE4DV1VRRPEOCW7UMKA1N2oHJIjCO+rO4Icr3nNTp3tPIR5xYL0
	Bda83WDBwCmwb+KpspzI38qtnUWyt1yCdfwZNNQAUaSfUtDdI0tFxVQy/ExUJd2tTEdk1dGFp7ZNb
	0H8yHOwIJ5rXBpQdAmbnQPhGDfZiisX6TxF03lYFq5XErAKSwhqRHamMAB7GakTQHqPj/qQdV9om4
	QwOvc8VI2hxk91OlGRFUmduVFOJE+gDXOrcjfEqpjd5/VlvZytsdBwXfAHYErDdb+xZt1o5sTPjZO
	GkfdmBAA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39708)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q4eFc-00063c-HN; Thu, 01 Jun 2023 10:05:44 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q4eFa-0001lt-9q; Thu, 01 Jun 2023 10:05:42 +0100
Date: Thu, 1 Jun 2023 10:05:42 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: actually fix ksettings_set() ethtool
 call
Message-ID: <ZHhfZo3ktuRe1CjK@shell.armlinux.org.uk>
References: <E1q4eC7-00AyAn-6d@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q4eC7-00AyAn-6d@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Please ignore this, wrong version of the patch. :/ More coffee needed.

On Thu, Jun 01, 2023 at 10:02:07AM +0100, Russell King (Oracle) wrote:
> Raju Lakkaraju reported that the below commit caused a regression
> with Lan743x drivers and a 2.5G SFP. Sadly, this is because the commit
> was utterly wrong. Let's fix this properly by not moving the
> linkmode_and(), but instead copying the link ksettings and then
> modifying the advertising mask before passing the modified link
> ksettings to phylib.
> 
> Fixes: df0acdc59b09 ("net: phylink: fix ksettings_set() ethtool call")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index e237949deee6..cf4e51e48cdd 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -2225,11 +2225,13 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
>  
>  	ASSERT_RTNL();
>  
> -	/* Mask out unsupported advertisements */
> -	linkmode_and(config.advertising, kset->link_modes.advertising,
> -		     pl->supported);
> -
>  	if (pl->phydev) {
> +		struct ethtool_link_ksettings phy_kset = *kset;
> +
> +		linkmode_and(phy_kset.link_modes.advertising,
> +			     phy_kset.link_modes.advertising,
> +			     pl->supported);
> +
>  		/* We can rely on phylib for this update; we also do not need
>  		 * to update the pl->link_config settings:
>  		 * - the configuration returned via ksettings_get() will come
> @@ -2252,6 +2254,9 @@ int phylink_ethtool_ksettings_set(struct phylink *pl,
>  	}
>  
>  	config = pl->link_config;
> +	/* Mask out unsupported advertisements */
> +	linkmode_and(config.advertising, kset->link_modes.advertising,
> +		     pl->supported);
>  
>  	/* FIXME: should we reject autoneg if phy/mac does not support it? */
>  	switch (kset->base.autoneg) {
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

