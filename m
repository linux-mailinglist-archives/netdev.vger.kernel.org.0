Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE8C4980C1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 14:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiAXNPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 08:15:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbiAXNPm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 08:15:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PeFIruRVAx/9fcHZk7SrtQ7xKuJ0YbP5VfyDFWFEJSw=; b=xNaC/FgUnUbJApVTzE3QBM8Djn
        w16MkgJn3jTsl3IlNpc0Uu7r56sCQIwzpR7BGd/HuczSidjDiif1i+IUYc0NELP8xMK65vYvZCmXe
        53bERZ7s8V4cinKzRid22A2gaCq4jElkED97VaRNfxWKGsQVeSDwhtrRus9S32iYtoU0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nBzBr-002TB3-P7; Mon, 24 Jan 2022 14:15:23 +0100
Date:   Mon, 24 Jan 2022 14:15:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net: stmmac: skip only stmmac_ptp_register when
 resume from suspend
Message-ID: <Ye6maxMtt68JlZ9l@lunn.ch>
References: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
 <20220124095951.23845-3-mohammad.athari.ismail@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124095951.23845-3-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -3308,13 +3309,11 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
>  
>  	stmmac_mmc_setup(priv);
>  
> -	if (init_ptp) {
> -		ret = stmmac_init_ptp(priv);
> -		if (ret == -EOPNOTSUPP)
> -			netdev_warn(priv->dev, "PTP not supported by HW\n");
> -		else if (ret)
> -			netdev_warn(priv->dev, "PTP init failed\n");
> -	}
> +	ret = stmmac_init_ptp(priv, ptp_register);
> +	if (ret == -EOPNOTSUPP)
> +		netdev_warn(priv->dev, "PTP not supported by HW\n");
> +	else if (ret)
> +		netdev_warn(priv->dev, "PTP init failed\n");

The init_ptp parameter now seems unused? If so, please remove it.

    Andrew
