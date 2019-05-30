Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77B12FBBB
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfE3Mw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 08:52:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfE3Mw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 08:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KITFTTw/Cix1jy7QS8u4yTnUr1sVdxGbnIKHvJASKJI=; b=c0cthpJkOph11OO7nNMrinJnK8
        Z51KKXGH2kyjTxkDhGUa+441s17SAb5dTpNkpFlwhZPjJwDV2NZ9Dm6a86qZcZ2MmESrzmErfH20A
        2ZCu0RXCJLbun751covQM5y6aXHt+/lLYTTnKL9/e1LSBDTUNlIZGtQuUsDVRTaadquA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWKXV-0006Mr-Oh; Thu, 30 May 2019 14:52:13 +0200
Date:   Thu, 30 May 2019 14:52:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: Add error path handling in
 dsa_tree_setup()
Message-ID: <20190530125213.GA22727@lunn.ch>
References: <1559196547-17917-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559196547-17917-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 09:09:07AM +0300, Ioana Ciornei wrote:
> In case a call to dsa_tree_setup() fails, an attempt to cleanup is made
> by calling dsa_tree_remove_switch(), which should take care of
> removing/unregistering any resources previously allocated. This does not
> happen because it is conditioned by dst->setup being true, which is set
> only after _all_ setup steps were performed successfully.
> 
> This is especially interesting when the internal MDIO bus is registered
> but afterwards, a port setup fails and the mdiobus_unregister() is never
> called. This leads to a BUG_ON() complaining about the fact that it's
> trying to free an MDIO bus that's still registered.
> 
> Add proper error handling in all functions branching from
> dsa_tree_setup().
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reported-by: kernel test robot <rong.a.chen@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
