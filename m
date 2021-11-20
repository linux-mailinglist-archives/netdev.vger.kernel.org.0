Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33E457AF4
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 04:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhKTD7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 22:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhKTD7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 22:59:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D337C60232;
        Sat, 20 Nov 2021 03:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637380571;
        bh=86FBIWCf6Lk8AWeTyqH+1Q1RzlmtrhnJcVce4iLfil0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FY7rSawkMDH8RFKwIewiTEFVjtWG9HzT0acaESuughIfcaAZ/uhv1LOdCs+w2piM+
         NRk0TfOkzdpawLt7D1p27wJ51jg0+Mxnd6EeDvDUkJt9vL3vypOZnUp+PSPx1pVcrL
         dofSKuGwokco63u4CFO/5Tplek1fZCDgomjJOZAx86fdYbrhPro0LRiAeJvROzxHX4
         luHchBb4t0ggupHAAgbxcyLHWpP+oQHnWLbxwwh80qmjfj+pR93+GYYt/3Kt7Zfzdq
         Smsfdawg5vrBPUC+kkuR7D6yEtOkBFk93ZKI/4sW2iFpMt4BZmkutMFGwts372nPIG
         L4iLSgG7Eu2lg==
Date:   Fri, 19 Nov 2021 19:56:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 1/3] net: mdio: mscc-miim: convert to a
 regmap implementation
Message-ID: <20211119195610.72da54d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119213918.2707530-2-colin.foster@in-advantage.com>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
        <20211119213918.2707530-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 13:39:16 -0800 Colin Foster wrote:
> Utilize regmap instead of __iomem to perform indirect mdio access. This
> will allow for custom regmaps to be used by way of the mscc_miim_setup
> function.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

clang says:

drivers/net/mdio/mdio-mscc-miim.c:228:30: warning: variable 'bus' is uninitialized when used here [-Wuninitialized]
        mscc_miim_setup(&pdev->dev, bus, mii_regmap, phy_regmap);

drivers/net/mdio/mdio-mscc-miim.c:216:13: warning: variable 'dev' is uninitialized when used here [-Wuninitialized]
        if (IS_ERR(dev->phy_regs)) {
                   ^~~
