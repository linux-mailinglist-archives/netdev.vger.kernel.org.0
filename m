Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6812E7B1D
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 17:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgL3Qp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 11:45:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726391AbgL3Qp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 11:45:28 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kueaX-00F3el-28; Wed, 30 Dec 2020 17:44:41 +0100
Date:   Wed, 30 Dec 2020 17:44:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
Message-ID: <X+yueZ4of+Ixr//E@lunn.ch>
References: <20201230103309.8956-1-ckeepax@opensource.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230103309.8956-1-ckeepax@opensource.cirrus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 10:33:09AM +0000, Charles Keepax wrote:
> A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
> macb_set_tx_clk were gated on the presence of this flag.
> 
> -   if (!clk)
> + if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
> 
> However the flag was not added to anything other than the new
> sama7g5_gem, turning that function call into a no op for all other
> systems. This breaks the networking on Zynq.
> 
> The commit message adding this states: a new capability so that
> macb_set_tx_clock() to not be called for IPs having this
> capability
> 
> This strongly implies that present of the flag was intended to skip
> the function not absence of the flag. Update the if statement to
> this effect, which repairs the existing users.
> 
> Fixes: daafa1d33cc9 ("net: macb: add capability to not set the clock rate")
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Hi Charles

Since this is a fix, this should be based on the net tree. And you
indicate this in the subject line with [PATCH net]. If this applies
cleanly to net, Dave will probably just accept it, but please keep
this in mind for any more submissions you make to netdev.

    Andrew
