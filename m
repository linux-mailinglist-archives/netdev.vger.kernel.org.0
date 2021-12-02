Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6ED466A21
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 20:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376618AbhLBTHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 14:07:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36266 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376361AbhLBTHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 14:07:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=Ca/Np5EqNfWr4TZU2fd5ty7+mfW8+17DiuzNszp3vno=; b=qb
        qcOnLxHrA2wjcALq7MSiPGiEgwigv7oPeOlb2JHbWy7l6LwCsfKAtCjCTDQGF1ZKzfbuTse//Devi
        eYi8skOgG3HzqO+xyfNeSlgHLhUS9eaLkGekTKpbzI2ldptr2o/PvtrNw5nQYh5llYahiHAWHAZOp
        XVOA3K5IQ4NGTog=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msrMy-00FM1w-Mn; Thu, 02 Dec 2021 20:03:48 +0100
Date:   Thu, 2 Dec 2021 20:03:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wells Lu =?utf-8?B?5ZGC6Iqz6aiw?= <wells.lu@sunplus.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        Vincent Shih =?utf-8?B?5pa96YyV6bS7?= 
        <vincent.shih@sunplus.com>
Subject: Re: [PATCH net-next v3 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <YakYlHzvlAI+1at+@lunn.ch>
References: <1638266572-5831-1-git-send-email-wellslutw@gmail.com>
 <1638266572-5831-3-git-send-email-wellslutw@gmail.com>
 <YabsT0/dASvYUH2p@lunn.ch>
 <cf60c230950747ec918acfc6dda595d6@sphcmbx02.sunplus.com.tw>
 <YajEbXtBwlDL4gOL@lunn.ch>
 <2fded2fc3a1344d0882ae2f186257911@sphcmbx02.sunplus.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fded2fc3a1344d0882ae2f186257911@sphcmbx02.sunplus.com.tw>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 06:46:40PM +0000, Wells Lu 呂芳騰 wrote:
> Hi Andrew,
> 
> Thank you for explanation.
> 
> I'll add phy_support_asym_pause() after PHY connected next patch.
> 
> I found some drivers call phy_set_max_speed() to set PHY speed to
> 100M after PHY connected. Is that necessary?

> From 'supported', PHY supports 10M/100M already.

You need phy_set_max_speed() when it is possible to connect a 10/100
MAC to a 1G PHY.  You sometime do this because a 1G PHY is cheaper
than a 100M PHY. Unless limited, the PHY will advertise and could
negotiate a 1G link, but the MAC could then not support it. If it is
not physically possible to connect a 1G PHY to your MAC, you don't
need to worry.

> I also found some drivers call phy_start_aneg() after PHY started.

It is not needed.

   Andrew
