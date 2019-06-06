Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A6737C5B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfFFSgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:36:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbfFFSgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 14:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dkXIVs69UZqZh8xaiaCOI/l9/rIFkkaEF3WcG61H0jA=; b=CdTAYMGcl7X50Hzj2Klxdy8svw
        aGXDAIXczFUV32tZqBNpFFquRW5/wzFlrv6lnYPNWIeWo5Cz7bCy6dw2xTYWwDp23h1eqid4M00Ms
        X7NlDEdVmf/VwknU6nSuRYIJ4iUsK60xurA8gyL7VQbcbh8xJyYKiwQpBuk7f/rTDMDA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYxFD-0000WR-S5; Thu, 06 Jun 2019 20:36:11 +0200
Date:   Thu, 6 Jun 2019 20:36:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190606183611.GD28371@lunn.ch>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
 <20190606124218.GD20899@lunn.ch>
 <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16971900-e6b9-e4b7-fbf6-9ea2cdb4dc8b@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

65;5402;1c> I don't like too much state changes outside control of the state machine,
> like in phy_start / phy_stop / phy_error. I think it would be better
> if a state change request is sent to the state machine, and the state
> machine decides whether the requested transition is allowed.

Hi Heiner

I initially though that phy_error() would be a good way to do what
Russell wants. But the locks get in the way. Maybe add an unlocked
version which PHY drivers can use to indicate something fatal has
happened?

	Andrew
