Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083DA2E9F87
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbhADVas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbhADVar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Jan 2021 16:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDFEC21919;
        Mon,  4 Jan 2021 21:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609795807;
        bh=H9RUiNpIWRm/wv7ST2Oq9S84uH9VPteE0U4ucsX6avA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P6MV5U+Bglr8KEmEnTFyrC5nZln7hmq9wyul6rjsaLtkyGfzGTQq8laytQoROjuLP
         vIvn7h64wPLvr97NtbcvxBNfr+9AtJLWRGgI+JKVCMgRDPDA225FGCrqiKpodAr9Yo
         OrTvho4lNAcKHX+hBxzm7ZLDWW3dgwewmPmObiug1DJADXr8C5A29knsU+eTCcX/qy
         9XftsBrpJ+ymb2dQgqu8R4tQFvtg96VZUhO6h+3MpuUW+uiOoTExqLh1ZbPOTU0QnH
         uQu6UeurNc51xsQZKm7VUh8weYfGpvf6wpGOWNAfi0Trdo7I4F7iTJNdsHaemb42zq
         J+oeB1Wd5grIg==
Date:   Mon, 4 Jan 2021 13:30:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Charles Keepax <ckeepax@opensource.cirrus.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG
 flag
Message-ID: <20210104133005.22c5488d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/MjyvgHJZrhYQw3@lunn.ch>
References: <20210104103802.13091-1-ckeepax@opensource.cirrus.com>
        <X/MjyvgHJZrhYQw3@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jan 2021 15:18:50 +0100 Andrew Lunn wrote:
> On Mon, Jan 04, 2021 at 10:38:02AM +0000, Charles Keepax wrote:
> > A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
> > macb_set_tx_clk were gated on the presence of this flag.
> > 
> > -   if (!clk)
> > + if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
> > 
> > However the flag was not added to anything other than the new
> > sama7g5_gem, turning that function call into a no op for all other
> > systems. This breaks the networking on Zynq.
> > 
> > The commit message adding this states: a new capability so that
> > macb_set_tx_clock() to not be called for IPs having this
> > capability
> > 
> > This strongly implies that present of the flag was intended to skip
> > the function not absence of the flag. Update the if statement to
> > this effect, which repairs the existing users.
> > 
> > Fixes: daafa1d33cc9 ("net: macb: add capability to not set the clock rate")
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>  
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
