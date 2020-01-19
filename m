Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE9B141F41
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 18:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgASRvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 12:51:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46084 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgASRvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jan 2020 12:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=w2Zv4J+M3B2KgwNk3zT07yTBvT0Gp9xOuPtf7bWAp/c=; b=aTrrKdmIs38brO/+qnNX5rvCwX
        OxFDy2Q5Q6AlQ6Tqil2wMh+iRrcUTQrNq0iJnvOkpFcXP9S8usOuhAsgyFwyNbZRqrl9C+YRI4NTC
        1Tc+UHRZje0kjosklBFGabvclIrlcHNSVlTckF0tWuoViX2f9+dJwp8Guu820seTuaeY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itEj7-0004tB-7E; Sun, 19 Jan 2020 18:51:09 +0100
Date:   Sun, 19 Jan 2020 18:51:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: phy: add generic ndo_do_ioctl handler
 phy_do_ioctl
Message-ID: <20200119175109.GB17720@lunn.ch>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
 <20200119161240.GA17720@lunn.ch>
 <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97389eb0-fc7f-793b-6f84-730e583c00e9@googlemail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner

> Almost all drivers have the running check. I found five that don't:
> 
> *ag71xx, fec_mpc52xx*
> They don't have the running check but should, because the PHY is
> attached in ndo_open only.

So long an ndo_close() sets the phydev pointer to NULL, it should be
safe. But do the drivers do this?

> *agere, faraday, rdc*
> They don't have the running check and attach the PHY in probe.
> 
> So yes, we could add a second helper w/o the running check, even if
> it's just for three drivers. There may be more in the future.
> 
> > Do you plan to convert any more MAC drivers?
> > 
> Not yet ;) Question would be whether one patch would be sufficient
> or whether we need one patch per driver that needs to be ACKed by
> the respective maintainer.

For this sort of mechanical change, i would do one patch for all
without running, and another with running. If any driver needs more
than a mechanical change, then do a patch per driver, and get the
maintainer involved.

    Andrew
