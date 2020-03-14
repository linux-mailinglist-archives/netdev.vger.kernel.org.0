Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56A185819
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCOBy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:54:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgCOBy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Mar 2020 21:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NL3MJouei4eDxbtXys1XmSE5zsmrHAunj/d9XtHq32s=; b=G5szt1P7X8/ZbWY5RtsxzdhZQQ
        FAgcpi+1hAXENYjjox6ZLVeHuUrmbkQiky5pSrHj7lZs3bFyKv0AceSFMBk833fGX1CPfVoh9mj49
        psBPAjJDhJrAgfqjaAWG1m+7bFdjDfsETwSdUxnfe4MuZWSZ6NTPOh0bHe1gK2v+in0I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDE8X-0002J5-M9; Sat, 14 Mar 2020 22:16:01 +0100
Date:   Sat, 14 Mar 2020 22:16:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, shawnguo@kernel.org,
        leoyang.li@nxp.com, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/3] net: fsl/fman: treat all RGMII modes in
 memac_adjust_link()
Message-ID: <20200314211601.GA8622@lunn.ch>
References: <1584101065-3482-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1584101065-3482-2-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584101065-3482-2-git-send-email-madalin.bucur@oss.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 02:04:23PM +0200, Madalin Bucur wrote:
> Treat all internal delay variants the same as RGMII.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index e1901874c19f..0fc98584974a 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -782,7 +782,10 @@ int memac_adjust_link(struct fman_mac *memac, u16 speed)
>  	/* Set full duplex */
>  	tmp &= ~IF_MODE_HD;
>  
> -	if (memac->phy_if == PHY_INTERFACE_MODE_RGMII) {
> +	if (memac->phy_if == PHY_INTERFACE_MODE_RGMII ||
> +	    memac->phy_if == PHY_INTERFACE_MODE_RGMII_ID ||
> +	    memac->phy_if == PHY_INTERFACE_MODE_RGMII_RXID ||
> +	    memac->phy_if == PHY_INTERFACE_MODE_RGMII_TXID) {

Hi Madalin

You can use phy_interface_mode_is_rgmii()

    Andrew
