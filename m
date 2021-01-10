Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35022F0870
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 17:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbhAJQs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 11:48:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59910 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbhAJQs5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 11:48:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kydt1-00HL0H-2Z; Sun, 10 Jan 2021 17:48:15 +0100
Date:   Sun, 10 Jan 2021 17:48:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: cope with SFPs that set both LOS
 normal and LOS inverted
Message-ID: <X/svz0qt5Jh63oiV@lunn.ch>
References: <E1kyYQa-0004iR-CU@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kyYQa-0004iR-CU@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 10:58:32AM +0000, Russell King wrote:
> The SFP MSA defines two option bits in byte 65 to indicate how the
> Rx_LOS signal on SFP pin 8 behaves:
> 
> bit 2 - Loss of Signal implemented, signal inverted from standard
>         definition in SFP MSA (often called "Signal Detect").
> bit 1 - Loss of Signal implemented, signal as defined in SFP MSA
>         (often called "Rx_LOS").
> 
> Clearly, setting both bits results in a meaningless situation: it would
> mean that LOS is implemented in both the normal sense (1 = signal loss)
> and inverted sense (0 = signal loss).
> 
> Unfortunately, there are modules out there which set both bits, which
> will be initially interpret as "inverted" sense, and then, if the LOS
> signal changes state, we will toggle between LINK_UP and WAIT_LOS
> states.
> 
> Change our LOS handling to give well defined behaviour: only interpret
> these bits as meaningful if exactly one is set, otherwise treat it as
> if LOS is not implemented.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
