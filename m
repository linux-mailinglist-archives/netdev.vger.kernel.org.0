Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A562C9108
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgK3W1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:27:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58550 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgK3W1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 17:27:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjrd7-009afh-Fo; Mon, 30 Nov 2020 23:26:45 +0100
Date:   Mon, 30 Nov 2020 23:26:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Adrien Grassein <adrien.grassein@gmail.com>, fugang.duan@nxp.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] dt-bindings: net: fsl-fec add mdc/mdio bitbang
 option
Message-ID: <20201130222645.GG2073444@lunn.ch>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
 <20201129220000.16550-1-adrien.grassein@gmail.com>
 <20201129224113.GS2234159@lunn.ch>
 <CABkfQAFcSNMeYEepsx0Z6tuaif-dQhE2YBMK54t1hikAvzdASg@mail.gmail.com>
 <20201129230416.GT2234159@lunn.ch>
 <bb81c90c-d79e-d944-e35e-305da23d9e58@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb81c90c-d79e-d944-e35e-305da23d9e58@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> I am currently upstreaming the "Nitrogen 8m Mini board" that seems to not use a
> >> "normal" mdio bus but a "bitbanged" one with the fsl fec driver.
> > 
> > Any idea why?
> > 
> > Anyway, you should not replicate code, don't copy bitbanging code into
> > the FEC. Just use the existing bit-banger MDIO bus master driver.
> 
> Right there should be no need for you to modify the FEC driver at all,
> there is an existing generic bitbanged MDIO bus driver here:

Hi Florian

Speculation on my part, until i hear back on the Why? question, but
i'm guessing the board has a wrong pullup on the MDIO line. It takes
too long for the PHY/FEC to pull the line low at the default
2.5MHz. bit-banging is much slower, so it works.

If i'm right, there is a much simpler fix for this. Use the
clock-frequency property for the MDIO bus to slow the clock down.

	Andrew
