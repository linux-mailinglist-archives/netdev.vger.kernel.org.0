Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3463A96509
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfHTPrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:47:17 -0400
Received: from vps.xff.cz ([195.181.215.36]:34058 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfHTPrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 11:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566316035; bh=+WetNuZhgsPVrJpioXtAn4eK1dq+iJ2qVlbpblbtjW4=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=hP54zVonCSbd4zXVtywOUAO5skboSj0IERBMVv++b8InA7BK9VB27HeH7mYCTQuH2
         4Le6mzzhSoXaVM6Dr/19kjLEesxX8WweIzbVQu0I2k75qcV+BB2m//1C81g4tlSYw1
         aCtfMtwX+imflszImRWYPRPZENIcBTQ1VAySnfxU=
Date:   Tue, 20 Aug 2019 17:47:14 +0200
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
Message-ID: <20190820154714.2rt4ctovil5ol3u2@core.my.home>
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

Hi Andrew,

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

Sorry, I mean dummy regulator. See:

https://elixir.bootlin.com/linux/latest/source/drivers/regulator/core.c#L1874

On systems that use DT (i.e. have_full_constraints() == true), when the
regulator is not found (ENODEV, not specified in DT), regulator_get will return
a fake dummy regulator that can be enabled/disabled, but doesn't do anything
real.

This can be used to avoid NULL checks and make the code simpler.

regards,
	Ondrej

>      Thanks
> 	Andrew
