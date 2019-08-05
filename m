Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612C781FEA
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfHEPPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:15:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34368 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbfHEPPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BxD9bHEfVvbXrjPtXMe/EKAGi9dgh7IkLu7Dh5ppO2Y=; b=HIL5cy43Guu210bimMJY4gbw+7
        1oWryRkaE4JOMs69ikBdoia3NxlNwoM96inLoCdJJOSE3wiwLG52E3EeZ54To/yGjrJBoDNq3jZtn
        KCRrwOcYd397n/aGvGSmIdkgw0VJIGAQsUCvf/1PaCZR6r3T0rRoP4iB4c2sWpaI7QCI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huehQ-0007nS-Ip; Mon, 05 Aug 2019 17:15:00 +0200
Date:   Mon, 5 Aug 2019 17:15:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 11/16] net: phy: adin: PHY reset mechanisms
Message-ID: <20190805151500.GP24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-12-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-12-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:48PM +0300, Alexandru Ardelean wrote:
> The ADIN PHYs supports 4 types of reset:
> 1. The standard PHY reset via BMCR_RESET bit in MII_BMCR reg
> 2. Reset via GPIO
> 3. Reset via reg GeSftRst (0xff0c) & reload previous pin configs
> 4. Reset via reg GeSftRst (0xff0c) & request new pin configs
> 
> Resets 2 & 4 are almost identical, with the exception that the crystal
> oscillator is available during reset for 2.
> 
> Resetting via GeSftRst or via GPIO is useful when doing a warm reboot. If
> doing various settings via phytool or ethtool, the sub-system registers
> don't reset just via BMCR_RESET.
> 
> This change implements resetting the entire PHY subsystem during probe.
> During PHY HW init (phy_hw_init() logic) the PHY core regs will be reset
> again via BMCR_RESET. This will also need to happen during a PM resume.

phylib already has support for GPIO reset. So if possible, you should
not repeat that code here.

What is the difference between a GPIO reset, and a GPIO reset followed
by a subsystem soft reset?

   Andrew
