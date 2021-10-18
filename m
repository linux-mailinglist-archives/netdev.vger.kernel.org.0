Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56145432944
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhJRVuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:50:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45344 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRVuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:50:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BapwsbtYOPKbDg5KdZ4f1xIYaXmcW0uLqeUff/ga3b4=; b=viCmyS0AVopFgGRSsw30OCs3xI
        cxP9pcl/PKkCFoHWkxt8VAHiVOF+RUZQp2pGmX0wnjvE7TVTO6NvOUDgMYD5FIIeI/v62DMCNV5Nk
        HWZVRUXtdJsI9K12dIQAzouE/AYS5XtO236GeLi6Upjwpi0Y6PFjS2Ji/5iXu2vu77jQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcaU6-00B0rC-FG; Mon, 18 Oct 2021 23:47:54 +0200
Date:   Mon, 18 Oct 2021 23:47:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 10/13] net: phy: add qca8081 config_init
Message-ID: <YW3riurwBofqOmUL@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-11-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-11-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int qca808x_phy_fast_retrain_config(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_CTRL,
> +			MDIO_AN_10GBT_CTRL_ADV2_5G |
> +			MDIO_AN_10GBT_CTRL_ADVFSRT2_5G |
> +			MDIO_AN_10GBT_CTRL_ADVLPTIMING);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_10GBR_FSRT_CSR,
> +			MDIO_PMA_10GBR_FSRT_ENABLE);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_CTRL2, MDIO_AN_THP_BP2_5GT);
> +	if (ret)
> +		return ret;

Could that be made generic and put into phy-c45.c? Is there anything
specific to your PHY here?

	 Andrew
