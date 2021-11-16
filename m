Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE10145249A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353434AbhKPBkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:40:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:53902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380181AbhKPBiU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 20:38:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF2261BC1;
        Tue, 16 Nov 2021 01:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637026524;
        bh=Kc4faBGeE8Vyu9i8iqaOekNgPHxCF8t0GSy7JQ9lkn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a8EzP4giDTkOdSlsmSGH2l4DoyjUEW7dRyupJ923ce+Am8p2bPGzGtwlzA40CrdgG
         wnEm/JvxV1plyddOutn6mPu5FuICzetQGqJRpFn4XPLmqXushtJx4FrPP3UlxFTdXR
         4zUDsR2kOBUu/mC8alg5xqm8vOWwgIa3EUxtdvJAu+76kpC5lCNF+TwludfrTxT4Cw
         uuLsHKwKGKSZKxOm08JCZ1wcqMG2j9wAK9FKE+OGrM/+vbdjoMX/g8R/j+6a7Arl8E
         WzFRVISUP/NnE7pMD3STvvEtfVf16IkEK2G36d95DYSd2NbXZbfIWwNn0kQoYvlIW0
         q/Y3dMBKtRBqg==
Date:   Mon, 15 Nov 2021 17:35:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Parshuram Thombare <pthombar@cadence.com>,
        Antoine Tenart <atenart@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Milind Parab <mparab@cadence.com>
Subject: Re: [net-next PATCH v6] net: macb: Fix several edge cases in
 validate
Message-ID: <20211115173523.3c2c7ecc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
References: <20211112190400.1937855-1-sean.anderson@seco.com>
        <YZKOdibmws3vlMUh@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 16:44:38 +0000 Russell King (Oracle) wrote:
> On Fri, Nov 12, 2021 at 02:04:00PM -0500, Sean Anderson wrote:
> > There were several cases where validate() would return bogus supported
> > modes with unusual combinations of interfaces and capabilities. For
> > example, if state->interface was 10GBASER and the macb had HIGH_SPEED
> > and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
> > another case, SGMII could be enabled even if the mac was not a GEM
> > (despite this being checked for later on in mac_config()). These
> > inconsistencies make it difficult to refactor this function cleanly.
> > 
> > There is still the open question of what exactly the requirements for
> > SGMII and 10GBASER are, and what SGMII actually supports. If someone
> > from Cadence (or anyone else with access to the GEM/MACB datasheet)
> > could comment on this, it would be greatly appreciated. In particular,
> > what is supported by Cadence vs. vendor extension/limitation?
> > 
> > To address this, the current logic is split into three parts. First, we
> > determine what we support, then we eliminate unsupported interfaces, and
> > finally we set the appropriate link modes. There is still some cruft
> > related to NA, but this can be removed in a future patch.
> > 
> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>  
> 
> Thanks - this looks good to me.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Applied to net-next, thanks!
