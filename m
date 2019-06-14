Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B048E450F9
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfFNBBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:01:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFNBBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 21:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sFpEpubnqfpAGx/KyQuTA3/U2WeQSmIVcFpmd5w5rCs=; b=YCL0ORzeoIkZYLhHOcLOL59f7g
        1CyOUlr6m/DOjiEND+2tw9+Upulso+DFTTwMzggeDYk5xALh1jHNYkxAjtt09XOEe///2Z0s6yqEW
        TtGfP/06hK1UQb0CNtt9oL/VDEeB9dctS1/qlEPX/HdCXbRU2rzuSdzf0Yur3ET78qPs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbaag-0007vn-NV; Fri, 14 Jun 2019 03:01:14 +0200
Date:   Fri, 14 Jun 2019 03:01:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, ruxandra.radulescu@nxp.com,
        Valentin Catalin Neacsu <valentin-catalin.neacsu@nxp.com>
Subject: Re: [PATCH RFC 2/6] dpaa2-eth: add support for new link state APIs
Message-ID: <20190614010114.GB28822@lunn.ch>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-3-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560470153-26155-3-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /**
> + * Advertised link speeds
> + */
> +#define DPNI_ADVERTISED_10BASET_FULL           BIT_ULL(0)
> +#define DPNI_ADVERTISED_100BASET_FULL          BIT_ULL(1)
> +#define DPNI_ADVERTISED_1000BASET_FULL         BIT_ULL(2)
> +#define DPNI_ADVERTISED_10000BASET_FULL        BIT_ULL(4)

So 10 Half and 100Half are not supported by the PHYs you use?  What
happens if somebody does connect a PHY which supports these speeds? Do
you need to change the firmware? I suppose you do anyway, since it is
the firmware which is driving the PHY.

>  struct dpni_link_state {
>  	u32	rate;
>  	u64	options;
> +	u64	supported;
> +	u64	advertising;
>  	int	up;
> +	int	state_valid;
>  };

Does the firmware report Pause? Asym Pause? EEE? Is this part of
options? Can you control the advertisement of these options?

     Andrew
