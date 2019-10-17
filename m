Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3673BDB997
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 00:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503709AbfJQWOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 18:14:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51630 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438047AbfJQWOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 18:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O32NFV5tBKYp86Cbah2xdrWQDoKTQV/dczaLU0XSPeQ=; b=BM/8z0kco4xKU14sNfH6so6wyB
        ffIUC/2Add86PIU0J0DUgUFkuMREHGWll8g3BukppU7P24cj/1iPSY+Cg2l0FyGG6aGTPQQu+y+OX
        QfUyyTcXPcL6idnD6SeCF1vvMeVPKDz/0ojL/hqmJjpMu4V8dYtjo2r8X3j6/KlVpheY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLE2j-0006rG-Dg; Fri, 18 Oct 2019 00:14:49 +0200
Date:   Fri, 18 Oct 2019 00:14:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>, hkallweit1@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, olteanv@gmail.com,
        rmk+kernel@armlinux.org.uk, cphealy@gmail.com,
        Jose Abreu <joabreu@synopsys.com>
Subject: Re: [PATCH net-next v2 2/2] net: phy: Add ability to debug RGMII
 connections
Message-ID: <20191017221449.GC24810@lunn.ch>
References: <20191017214453.18934-1-f.fainelli@gmail.com>
 <20191017214453.18934-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017214453.18934-3-f.fainelli@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#ifdef CONFIG_PHY_RGMII_DEBUG
> +int phy_rgmii_debug_probe(struct phy_device *phydev);
> +#else
> +static inline int phy_rgmii_debug_probe(struct phy_device *phydev)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif

Hi Florian

Jose wanted to make use of this in his self test code for stmmac.  I
think to make this more user friendly in that setup, it would be good
to return the phy_mode which works, if only one works. The MAC driver
can then compare the what it thinks the mode should be to what
actually works, and report a test failure if they differ.

    Andrew
