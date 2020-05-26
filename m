Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F85D1E27D5
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgEZRBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:01:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50046 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728485AbgEZRBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JUa7NTp3MITz+c/BLwyNNO//1H9K5Fw9a3TgKoCCEH0=; b=flbcARIdaYE+eRIoutOFYWhg/R
        Ik0nzRQgQu5vLb2ObJNSEiUbH0l7+RjnlC3VCMY1L3jmI8AibNWSyhOrmaNQoQYME082TuJaPpKF6
        VmGpiMvaeqwrgxIBMR3EPXpI0yMZKzTF8+zOvpLAqFVGLCP2tUKNh+y9XmaR0EcbNTn0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdcwm-003IxZ-5L; Tue, 26 May 2020 19:01:00 +0200
Date:   Tue, 26 May 2020 19:01:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 0/4] net: phy: mscc-miim: reduce waiting time
 between MDIO transactions
Message-ID: <20200526170100.GM768009@lunn.ch>
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526162256.466885-1-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 06:22:52PM +0200, Antoine Tenart wrote:
> Hello,
> 
> This series aims at reducing the waiting time between MDIO transactions
> when using the MSCC MIIM MDIO controller.

Hi Antoine

There are a couple of other things you can look at:

Can you disable the pre-amble on the MDIO transaction. It requires
that both the bus master and all devices on the bus support it, but
when it is usable, you half the number of bits sent over the wire.

Can you control the frequency of MDC? 802.3 says 2.5MHz, but many
devices support higher speeds. Again, you need all devices on the bus
to support the speed.

When accessing raw TDR data for cable tests i also have a lot of PHY
accesses. I implemented both of these for the FEC MDIO bus, and made
it a lot faster.

   Andrew
