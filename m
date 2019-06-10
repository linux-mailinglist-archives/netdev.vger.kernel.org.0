Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573D03BE2E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389824AbfFJVPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:15:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42940 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfFJVPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 17:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kOvoZ7UUXPPjS3T4n7Fk8hqSwFzI6Ebfl9pCSW6cL+U=; b=J3D/nqzeZzV1Sa+tPzjwVjYB9y
        zN5/zbXSUI8DL3H5WZov4uMPwePt+tbWv232sfGP1gZXcZFqURQACVG65vKN4lE0U9iXIRmz4wmQK
        R5+7zwafOcVxXa4Vv2+XEIvQXd2WILnODeH/GMyZ/M2IWac01+73EchMisz012M0Xnag=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1haRde-000217-DP; Mon, 10 Jun 2019 23:15:34 +0200
Date:   Mon, 10 Jun 2019 23:15:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Deal with non-existing PHY/fixed-link
Message-ID: <20190610211534.GD2191@lunn.ch>
References: <20190610193150.22231-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610193150.22231-1-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 12:31:49PM -0700, Florian Fainelli wrote:
> We need to specifically deal with phylink_of_phy_connect() returning
> -ENODEV, because this can happen when a CPU/DSA port does connect
> neither to a PHY, nor has a fixed-link property. This is a valid use
> case that is permitted by the binding and indicates to the switch:
> auto-configure port with maximum capabilities.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Hi Florian

This fixes the regression.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

But i wonder if we want to add in
(dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port) i.e. force a
user port to have some form of PHY?

     Andrew
