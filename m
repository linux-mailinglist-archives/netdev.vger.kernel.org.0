Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D937D64C1
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 16:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732482AbfJNOHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 10:07:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44764 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732117AbfJNOHe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 10:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ydmJEPR2+DQi1k/zQtS54GNwIRA0tN+K6ybF7hWPwJI=; b=hyxaYv29wEpNPxXKIX8Y6KnlUQ
        DsIbNCWFRkmvml5Wgg4LP64yWTjVNGTzXbU7E9bI23dCXEXsSj8MUtlKzEbpGYI+EjSy/YyTDJ3b6
        WFkVZBaGcsWF4Lx/tmUPNx5BxLTWs9JV3LpoVjNZw2QdId1FDZ335JrwwtncIldsoqsw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK10J-0005gY-Pz; Mon, 14 Oct 2019 16:07:19 +0200
Date:   Mon, 14 Oct 2019 16:07:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net V4 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795
 PHYs
Message-ID: <20191014140719.GB21165@lunn.ch>
References: <20191013212404.31708-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013212404.31708-1-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 11:24:03PM +0200, Marek Vasut wrote:
> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
> is wrong, since the KSZ8051 configures registers of the PHY which are
> not present on the simplified KSZ87xx switch PHYs and misconfigures
> other registers of the KSZ87xx switch PHYs.
> 
> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
> KSZ87xx switch by checking the Basic Status register Bit 0, which is
> read-only and indicates presence of the Extended Capability Registers.
> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
> 
> This patch implements simple check for the presence of this bit for
> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
> PHY driver instance.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
