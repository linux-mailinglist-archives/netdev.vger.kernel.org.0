Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264CD902C4
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfHPNT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:19:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfHPNT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=H1gBj1kW5szAndmHTcMrgfLyKfd6e1h5nu6uGkk0ceA=; b=2BgCYLk1+pnghjH6m1WkYd2x5e
        vLrhtmpNXL7uZhdDGlzP0N3sNv8Hxd3GjAukJWrE0eZc3SHmeKGTYp+kXFMp/1J1G++ye5794gZuo
        HIcR/FeJqPlURZ8A0do7Y/aJXl/dghXi/TrDZdmY/RysLG5SboMN95cvKaFms46M0NzY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hyc92-00008Z-S4; Fri, 16 Aug 2019 15:19:52 +0200
Date:   Fri, 16 Aug 2019 15:19:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v5 10/13] net: phy: adin: implement PHY subsystem
 software reset
Message-ID: <20190816131952.GA307@lunn.ch>
References: <20190816131011.23264-1-alexandru.ardelean@analog.com>
 <20190816131011.23264-11-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816131011.23264-11-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 16, 2019 at 04:10:08PM +0300, Alexandru Ardelean wrote:
> The ADIN PHYs supports 4 types of reset:
> 1. The standard PHY reset via BMCR_RESET bit in MII_BMCR reg
> 2. Reset via GPIO
> 3. Reset via reg GeSftRst (0xff0c) & reload previous pin configs
> 4. Reset via reg GeSftRst (0xff0c) & request new pin configs
> 
> Resets 2, 3 & 4 are almost identical, with the exception that the crystal
> oscillator is available during reset for 2.
> 
> This change implements subsystem software reset via the GeSftRst and
> reloading the previous pin configuration (so reset number 3).
> This will also reset the PHY core regs (similar to reset 1).
> 
> Since writing bit 1 to reg GeSftRst is self-clearing, the only thing that
> can be done, is to write to that register, wait a specific amount of time
> (10 milliseconds should be enough) and try to read back and check if there
> are no errors on read. A busy-wait-read won't work well, and may sometimes
> work or not work.
> 
> In case phylib is configured to also do a reset via GPIO, the ADIN PHY may
> be reset twice when the PHY device registers, but that isn't a problem,
> since it's being done on boot (or PHY device register).
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
