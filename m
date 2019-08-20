Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7132965AA
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbfHTP4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:56:51 -0400
Received: from vps.xff.cz ([195.181.215.36]:34466 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729888AbfHTP4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566316609; bh=bzutuiNbq00ksO2iXVNczWC4eQDfbf7nWDBun27IPTA=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=QvkxWzpkR3zBxqvUP9rNQO6X8E5gVtIfMMfz2ijXAbFX3kIjf/mrTpR7rh+3CdgeI
         oe+sdUivzOqXUPUin5nznYyGKPIRvPsJcUzSPOWRPWzbZBQT0sOgVdZ0jnizQrrEHz
         y/R5S8RhcZBWM/ByYYZn9tfxpzmBzeUBwErXr224=
Date:   Tue, 20 Aug 2019 17:56:48 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] net: stmmac: sun8i: Use devm_regulator_get for PHY
 regulator
Message-ID: <20190820155648.hjr5mlmsc6krecby@core.my.home>
Mail-Followup-To: Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20190820145343.29108-1-megous@megous.com>
 <20190820145343.29108-4-megous@megous.com>
 <20190820153939.GL29991@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820153939.GL29991@lunn.ch>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 05:39:39PM +0200, Andrew Lunn wrote:
> On Tue, Aug 20, 2019 at 04:53:40PM +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> > 
> > Use devm_regulator_get instead of devm_regulator_get_optional and rely
> > on dummy supply. This avoids NULL checks before regulator_enable/disable
> > calls.
> 
> Hi Ondrej
> 
> What do you mean by a dummy supply? I'm just trying to make sure you
> are not breaking backwards compatibility.

I have tested it on Orange Pi PC 2, that uses only phy-supply, but not
phy-io-supply, and the kernel now prints:

[    1.410137] dwmac-sun8i 1c30000.ethernet: 1c30000.ethernet supply phy-io not found, using dummy regulator

I have also tested it on Orange Pi PC, that doesn't use external phy, and
instead of:

[    1.081378] dwmac-sun8i 1c30000.ethernet: No regulator found

The kernel now prints:

[    1.112752] dwmac-sun8i 1c30000.ethernet: 1c30000.ethernet supply phy not found, using dummy regulator
[    1.112814] dwmac-sun8i 1c30000.ethernet: 1c30000.ethernet supply phy-io not found, using dummy regulator

Ethernet works in both cases, so that should cover all existing combinations. :)

regards,
	Ondrej


>      Thanks
> 	Andrew
