Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B2C86B52
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404733AbfHHUUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:20:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45582 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404467AbfHHUUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0ZbhcQSKDqCCErzmqb996yvUYEHV8ffjTNy/zw4MZ/M=; b=ed0VB4KNnf7RliplYnx3Zg4cuW
        jWncZDVebs44S/BGUuoyFqXQyMLVd8Vtv2XqaKC8FC1NxVQbRQdjHNlo/38rGbOSTaIw97+afjx9b
        yRlRkzP358Yz4PmTIPlR5GdM+tNJyy86rer45SENQgIe5mmuOW9ksdymnZC+7FeTqvzk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hvoth-0005mk-8a; Thu, 08 Aug 2019 22:20:29 +0200
Date:   Thu, 8 Aug 2019 22:20:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
Message-ID: <20190808202029.GN27917@lunn.ch>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
 <64769c3d-42b6-8eb8-26e4-722869408986@gmail.com>
 <20190808193743.GL27917@lunn.ch>
 <f34d1117-510f-861f-59f0-51e0e87ead1e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f34d1117-510f-861f-59f0-51e0e87ead1e@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I have a contact in Realtek who provided the information about
> the vendor-specific registers used in the patch. I also asked for
> a method to auto-detect 2.5Gbps support but have no feedback so far.
> What may contribute to the problem is that also the integrated 1Gbps
> PHY's (all with the same PHY ID) differ significantly from each other,
> depending on the network chip version.

Hi Heiner

Some of the PHYs embedded in Marvell switches have an OUI, but no
product ID. We work around this brokenness by trapping the reads to
the ID registers in the MDIO bus controller driver and inserting the
switch product ID. The Marvell PHY driver then recognises these IDs
and does the right thing.

Maybe you can do something similar here?

      Andrew
