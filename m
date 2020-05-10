Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B581CCB8C
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgEJOaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:30:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgEJOaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 10:30:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aYidsJQJbZ2p6thM6SLIEHn2F310LxGXTPcNi9orDhw=; b=dFisxF/v8lgbkGBdn/LftGX1MU
        5mJdGzQFBNafprc4GwrovA3XqFj0anEqyyDShZgZ1frV33SyEOVy5R1Hbz2b5s5ssA031jF+LGWuo
        XRfiHwbOy6YGuz1NDoukjYt2TB/vTuSik9gnrInzyQYZF6ochIeGaEAAXoOkGXJG1IKk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXmxw-001i6L-T7; Sun, 10 May 2020 16:30:04 +0200
Date:   Sun, 10 May 2020 16:30:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: at803x: add cable diagnostics support
Message-ID: <20200510143004.GF362499@lunn.ch>
References: <20200509221719.24334-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509221719.24334-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 12:17:19AM +0200, Michael Walle wrote:
> The AR8031/AR8033 and the AR8035 support cable diagnostics. Adding
> driver support is straightforward, so lets add it.
> 
> The PHY just do one pair at a time, so we have to start the test four
> times. The cable_test_get_status() can block and therefore we can just
> busy poll the test completion and continue with the next pair until we
> are done.
> The time delta counter seems to run at 125MHz which just gives us a
> resolution of about 82.4cm per tick.
> 
> 100m cable, A/B/C/D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: Open Circuit
>   Pair: Pair A, fault length: 107.94m
>   Pair: Pair B, result: Open Circuit
>   Pair: Pair B, fault length: 104.64m
>   Pair: Pair C, result: Open Circuit
>   Pair: Pair C, fault length: 105.47m
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair D, fault length: 107.94m
> 
> 1m cable, A/B connected, C shorted, D open:
>   Cable test started for device eth0.
>   Cable test completed for device eth0.
>   Pair: Pair A, result: OK
>   Pair: Pair B, result: OK
>   Pair: Pair C, result: Short within Pair
>   Pair: Pair C, fault length: 0.82m
>   Pair: Pair D, result: Open Circuit
>   Pair: Pair D, fault length: 0.82m
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Hi Michael

This looks good. Thanks for working on these two drivers.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
