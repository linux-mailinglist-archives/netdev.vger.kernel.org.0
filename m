Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7ED432935
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhJRVoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:44:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRVoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 17:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xfigqgq3auU+bCIeWSNZA5J9X0KkjzeCETQout6wr6M=; b=3yMPr3eZ5OdQtCAuApxpT3neYa
        NbsSRR7udUU0C4mU8ION2UuSpkoDCNfcVbxTOMj3Gp4mCmnWFkl1l6LoLlS3/TaqnnM5fA3MZ4OlN
        Agz1QfZFF9IqOzngHqk6/XDmn6npyRGTVKv3BbBdKgq+WgHMRB9utF+O9/mCrvQDCamM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcaOT-00B0p6-6U; Mon, 18 Oct 2021 23:42:05 +0200
Date:   Mon, 18 Oct 2021 23:42:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v3 06/13] net: phy: add qca8081 read_status
Message-ID: <YW3qLe8iHe1wdMev@lunn.ch>
References: <20211018033333.17677-1-luoj@codeaurora.org>
 <20211018033333.17677-7-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018033333.17677-7-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int qca808x_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_10GBT_STAT);
> +	if (ret < 0)
> +		return ret;
> +
> +	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, phydev->lp_advertising,
> +			ret & MDIO_AN_10GBT_STAT_LP2_5G);
> +

Could genphy_c45_read_lpa() be used here?

      Andrew
