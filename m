Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF98213B12
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 15:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgGCNfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 09:35:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbgGCNfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 09:35:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jrLqT-003T6y-SU; Fri, 03 Jul 2020 15:35:13 +0200
Date:   Fri, 3 Jul 2020 15:35:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        robh+dt@kernel.org
Subject: Re: [net-next,PATCH 2/4] net: mdio-ipq4019: add clock support
Message-ID: <20200703133513.GB807334@lunn.ch>
References: <20200702103001.233961-1-robert.marko@sartura.hr>
 <20200702103001.233961-3-robert.marko@sartura.hr>
 <e4921b83-0c80-65ad-6ddd-be2a12347d9c@gmail.com>
 <CA+HBbNHbyS3viFc90KDWW=dwkA9yRSuQ15fg9EzApmrP8JSR3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HBbNHbyS3viFc90KDWW=dwkA9yRSuQ15fg9EzApmrP8JSR3Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 01:37:48PM +0200, Robert Marko wrote:
> This is not the actual MDIO bus clock, that is the clock frequency
> that SoC clock generator produces.
> MDIO controller has an internal divider set up for that 100MHz, I
> don't know the actual MDIO bus clock
> frequency as it's not listed anywhere.

Hi Robert

From Documentation/devicetree/bindings/net/mdio.yaml 

  clock-frequency:
    description:
      Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
      defined 2.5MHz should only be used when all devices on the bus support
      the given clock speed.

You have to use that definition for clock-frequency. It means the MDIO
bus frequency. It would be good if you can get an oscilloscope onto
the bus and measure it. Otherwise, we have to assume the divider is
40, in order to give a standards compliment 2.5MHz. You can then work
out what value to pass to the clk_ API to get the correct input clock
frequency for the MDIO block.

	  Andrew
