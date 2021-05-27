Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C68393941
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhE0X2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:28:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32810 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233038AbhE0X2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:28:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=V4zv3tSkdbMop+5uGd/UYZ83LvN67WaQLJjf/Sfs61c=; b=wfg5R/awrSnPY8Z3K82p/HpQWQ
        xBCMpn9ez3I0ku46o+cZcHLYuTdsqW5LRQxNw7axDWNcBaYkKH8kxFmyEo2QFJxmee576Yy3magKK
        gTmPjvjNh5S4dDSI/kEfoa4TwI5x3VZNSax1/jXMI83knJ1YlI86T/Rsw6OzyAy/3UUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmPOg-006eAY-7v; Fri, 28 May 2021 01:26:38 +0200
Date:   Fri, 28 May 2021 01:26:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Jose.Abreu@synopsys.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        davem@davemloft.net, mcoquelin.stm32@gmail.com,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        tee.min.tan@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] net: pcs: add 2500BASEX support for
 Intel mGbE controller
Message-ID: <YLAqrte9qwQ/64BI@lunn.ch>
References: <20210527092415.25205-1-michael.wei.hong.sit@intel.com>
 <20210527092415.25205-3-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527092415.25205-3-michael.wei.hong.sit@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int xpcs_config_2500basex(struct mdio_xpcs_args *xpcs)
> +{
> +	int ret;
> +
> +		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1);
> +		if (ret < 0)
> +			return ret;
> +		ret |= DW_VR_MII_DIG_CTRL1_2G5_EN;
> +		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
> +		ret = xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL);
> +		if (ret < 0)
> +			return ret;
> +		ret &= ~AN_CL37_EN;
> +		ret |= SGMII_SPEED_SS6;
> +		ret &= ~SGMII_SPEED_SS13;
> +		return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_MMD_CTRL, ret);
> +
> +	return 0;

Indentation is messed up here? Or a rebase gone wrong removing an if
statement?

	    Andrew
