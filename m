Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6DCBC99
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388975AbfJDOEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:04:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32776 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388270AbfJDOEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 10:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hvef9gAZCNLEPoPb4V8GI6omAjMbtlCF+0f6M4l2WC8=; b=Dg3ktSFeV8IAvHwRX7gmvW4vXa
        X/LwRofdDXDZPPkgOL4g4Jf9DMLHhgupNh5qefppk68SwcNs50K2HDOk9stvnBZu96XXPR3lwCPUq
        6FtACkBONy8AdyHAVuNIs9zmJnXSbRTsnCf2o+fDSNsnjreNYe9Dsow1e3iyShX7xFnM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGOC5-0001Uj-4f; Fri, 04 Oct 2019 16:04:29 +0200
Date:   Fri, 4 Oct 2019 16:04:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrea Merello <andrea.merello@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: allow for reset line to be tied to a sleepy
 GPIO controller
Message-ID: <20191004140429.GB24154@lunn.ch>
References: <20191004135332.5746-1-andrea.merello@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004135332.5746-1-andrea.merello@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 03:53:32PM +0200, Andrea Merello wrote:
> mdio_device_reset() makes use of the atomic-pretending API flavor for
> handling the PHY reset GPIO line.
> 
> I found no hint that mdio_device_reset() is called from atomic context
> and indeed it uses usleep_range() since long time, so I would assume that
> it is OK to sleep there.
> 
> This patch switch to gpiod_set_value_cansleep() in mdio_device_reset().
> This is relevant if e.g. the PHY reset line is tied to a I2C GPIO
> controller.
> 
> This has been tested on a ZynqMP board running an upstream 4.19 kernel and
> then hand-ported on current kernel tree.
> 
> Signed-off-by: Andrea Merello <andrea.merello@gmail.com>

Yes, all the other bits of code using GPIOs are using the _cansleep
versions.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
