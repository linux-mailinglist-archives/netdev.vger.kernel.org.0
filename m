Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26382E20D8
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgLWTZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:25:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39002 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgLWTZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 14:25:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ks9kX-00DdoZ-Aj; Wed, 23 Dec 2020 20:24:41 +0100
Date:   Wed, 23 Dec 2020 20:24:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag on
 Zynq
Message-ID: <20201223192441.GH3198262@lunn.ch>
References: <20201223184144.7428-1-ckeepax@opensource.cirrus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223184144.7428-1-ckeepax@opensource.cirrus.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 06:41:44PM +0000, Charles Keepax wrote:
> A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
> macb_set_tx_clk were gated on the presence of this flag.
> 
> if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
> 
> However the flag was not added to anything other than the new
> sama7g5_gem, turning that function call into a no op for all other
> systems. This breaks the networking on Zynq.

I'm not sure this is the correct fix. I think the original patch might
be broken. Look at the commit message wording:

                                                      The patch adds a new
    capability so that macb_set_tx_clock() to not be called for IPs having
    this capability

So MACB_CAPS_CLK_HW_CHG disables something, not enables it. So i
suspect this if statement is wrong and needs fixing.

	Andrew
