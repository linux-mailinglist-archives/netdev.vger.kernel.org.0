Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8C234B7CC
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhC0OqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 10:46:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51084 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhC0OqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 10:46:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQAC8-00DLHu-FL; Sat, 27 Mar 2021 15:45:44 +0100
Date:   Sat, 27 Mar 2021 15:45:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,v2] net: dsa: mt7530: clean up core and TRGMII
 clock setup
Message-ID: <YF9FGJmH/b5BMHQC@lunn.ch>
References: <20210327055543.473099-1-ilya.lipnitskiy@gmail.com>
 <20210327060752.474627-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210327060752.474627-1-ilya.lipnitskiy@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:07:52PM -0700, Ilya Lipnitskiy wrote:
> Three minor changes:
> 
> - When disabling PLL, there is no need to call core_write_mmd_indirect
>   directly, use the core_write wrapper instead like the rest of the code
>   in the function does. This change helps with consistency and
>   readability. Move the comment to the definition of
>   core_read_mmd_indirect where it belongs.
> 
> - Disable both core and TRGMII Tx clocks prior to reconfiguring.
>   Previously, only the core clock was disabled, but not TRGMII Tx clock.
>   So disable both, then configure them, then re-enable both, for
>   consistency.
> 
> - The core clock enable bit (REG_GSWCK_EN) is written redundantly three
>   times. Simplify the code and only write the register only once at the
>   end of clock reconfiguration to enable both core and TRGMII Tx clocks.
> 
> Tested on Ubiquiti ER-X running the GMAC0 and MT7530 in TRGMII mode.
> 
> Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>

Thanks for moving the comment.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
