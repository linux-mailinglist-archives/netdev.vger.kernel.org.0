Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764FDAC13E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 22:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394366AbfIFUGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 16:06:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394361AbfIFUGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 16:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Nw+uWXrWS8NOxYj5RgCXXtYKhYcQjShXFWBVcKs2PyU=; b=YyqjyIgg8lq/EWdK4FP9vEhAW4
        J87ZpyhJogv60+7/XxEbcfxqRj/aDU6rmfHeM2hVHA8eqUUBtrH3QGnHUkawwJ25XpJMYdlrwc595
        TQM2MCrSnpJmapl/95eKoI6A9za8RYNhwGv0LeAl18oE8qgaS0TtkCRph7KRnli7nlmI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6KUk-0001KO-La; Fri, 06 Sep 2019 22:06:10 +0200
Date:   Fri, 6 Sep 2019 22:06:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] enetc: Use DT protocol information to set
 up the ports
Message-ID: <20190906200610.GF2339@lunn.ch>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-6-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567779344-30965-6-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void enetc_configure_port_mac(struct enetc_hw *hw,
> +				     phy_interface_t phy_mode)
>  {
>  	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
>  		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
> @@ -523,9 +524,11 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
>  		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC |
>  		      ENETC_PM0_TX_EN | ENETC_PM0_RX_EN);
>  	/* set auto-speed for RGMII */
> -	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG)
> +	if (enetc_port_rd(hw, ENETC_PM0_IF_MODE) & ENETC_PMO_IFM_RG ||
> +	    phy_mode == PHY_INTERFACE_MODE_RGMII)
>  		enetc_port_wr(hw, ENETC_PM0_IF_MODE, ENETC_PM0_IFM_RGAUTO);

What about PHY_INTERFACE_MODE_RGMII_ID, PHY_INTERFACE_MODE_RGMII_RXID
and PHY_INTERFACE_MODE_RGMII_TXID.

    Andrew
