Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0276188F40
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 05:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfHKDjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 23:39:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfHKDjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 23:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qt2FNV2e4/IIcV70ca9p7gJxxULqDaxTENYQx7t8ZKE=; b=5GSH0R9zwc+/WLSBs5ceq9PD8B
        NAzUJ7rBvDb7ZiPzGb3jnrZnNa1eueuuonDFY7gM8hjOI9jB19AwmDiQSaYCoX5fIWCyPVXlCt+Cb
        2hZEIMMTUHVULQ4lRThlUHT+YvD2Wu2I61dB/gdA9RVNCQbzZviGYZnFFyBiohFYWwZQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwehK-0002HG-PM; Sun, 11 Aug 2019 05:39:10 +0200
Date:   Sun, 11 Aug 2019 05:39:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port
 registration
Message-ID: <20190811033910.GL30120@lunn.ch>
References: <20190811031857.2899-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190811031857.2899-1-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 05:18:57AM +0200, Marek Behún wrote:
> Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
> genphy_read_status") broke fixed link DSA port registration in
> dsa_port_fixed_link_register_of: the genphy_read_status does not do what
> it is supposed to and the following adjust_link is given wrong
> parameters.

Hi Marek

Which parameters are incorrect?

In fixed_phy.c, __fixed_phy_register() there is:

        /* propagate the fixed link values to struct phy_device */
        phy->link = status->link;
        if (status->link) {
                phy->speed = status->speed;
                phy->duplex = status->duplex;
                phy->pause = status->pause;
                phy->asym_pause = status->asym_pause;
        }

Are we not initialising something? Or is the initialisation done here
getting reset sometime afterwards?

Thanks
	Andrew
