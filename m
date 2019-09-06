Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE322AC12D
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387939AbfIFUB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:01:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60516 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfIFUB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 16:01:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5BA/udfx9tiiu/UaXuycBkGhbsM3ggiscOGSuK3nHuQ=; b=6XCzVQF3Wn3ZeAW22eNF0wYkob
        93Im1AtTPuX4jf/Paj8SYD95WB3J7O2cNyi9BV4qHww3EGeX1cbE72ytRtg+loi5Qq28FPH8hPWoz
        vRnYTSqmJhtRZH87tWJvWBZbPDSXC2PxvdDM4DgwdBSk7yJNCEsb9DjyDn1hDxaxuLzw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6KQb-0001HI-8z; Fri, 06 Sep 2019 22:01:53 +0200
Date:   Fri, 6 Sep 2019 22:01:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] enetc: Initialize SerDes for SGMII and
 SXGMII protocols
Message-ID: <20190906200153.GE2339@lunn.ch>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-4-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567779344-30965-4-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 05:15:42PM +0300, Claudiu Manoil wrote:
> +int enetc_imdio_init(struct enetc_pf *pf)
> +{
> +	struct device *dev = &pf->si->pdev->dev;
> +	struct enetc_mdio_priv *mdio_priv;
> +	struct mii_bus *bus;
> +	int err;
> +
> +	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
> +	if (!bus)
> +		return -ENOMEM;
> +
> +	bus->name = "FSL ENETC internal MDIO Bus";
> +	bus->read = enetc_mdio_read;
> +	bus->write = enetc_mdio_write;
> +	bus->parent = dev;

Hi Claudiu

Since you don't expect any PHYs to be on this bus, maybe you should
set bus->phy_mask;

    Andrew
