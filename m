Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B542E860A
	for <lists+netdev@lfdr.de>; Sat,  2 Jan 2021 02:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbhABBuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jan 2021 20:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbhABBuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Jan 2021 20:50:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BF522241;
        Sat,  2 Jan 2021 01:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609552198;
        bh=ftpLdvsvDf6Op/7guRWkU1GTp+LUtuRhZif20iq/5j4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBpHeX+ylHfhXASU+u0XDWdnQDzosOaZ8yY2oW5P7GJm+i2clh+8urMVbfa/FbyQy
         2+92fzN0ESMhfqT+K56fKm3qSLgtXMvQi2bY+eNxmv9lvLwEOVwuQlBVisVlu9DFuw
         ZMSTV6D4JNlXUNq/PaYR7oxjrWc1y5LH397Su7KGoTuJJx0mfTFTUxs7RMpU9wwm8h
         CZmGrD7PvE65VOlBTL7ePVBGfTCUnYHZp3oUCHAEI0aNczIe80z8rUe7EjkAfixSi6
         wZY4fXcsKDOFlatZJLdW8DTiDi8Dr0FTouI3mivPap2TItPrUXtCpEeM7gwV7k4gK0
         FzzoPuXCdWPFA==
Received: by pali.im (Postfix)
        id D53C59DC; Sat,  2 Jan 2021 02:49:55 +0100 (CET)
Date:   Sat, 2 Jan 2021 02:49:55 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Thomas Schreiber <tschreibe@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210102014955.2xv27xla65eeqyzz@pali>
References: <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
 <20201230170546.GU1551@shell.armlinux.org.uk>
 <X+y1K21tp01GpvMy@lunn.ch>
 <20201230174307.lvehswvj5q6c6vk3@pali>
 <20201230190958.GW1551@shell.armlinux.org.uk>
 <20201231121410.2xlxtyqjelrlysd2@pali>
 <X+3ume1+wz8HXHEf@lunn.ch>
 <20201231170039.zkoa6mij3q3gt7c6@pali>
 <X+4GwpFnJ0Asq/Yj@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+4GwpFnJ0Asq/Yj@lunn.ch>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 31 December 2020 18:13:38 Andrew Lunn wrote:
> > > Looking at sfp_module_info(), adding a check for i2c_block_size < 2
> > > when determining what length to return. ethtool should do the right
> > > thing, know that the second page has not been returned to user space.
> > 
> > But if we limit length of eeprom then userspace would not be able to
> > access those TX_DISABLE, LOS and other bits from byte 110 at address A2.
> 
> Have you tested these bits to see if they actually work? If they don't
> work...

On Ubiquiti module that LOS bit does not work.

I think that on CarlitoxxPro module LOS bit worked. But I cannot test it
right now as I do not have access to testing OLT unit.

Adding Thomas to loop. Can you check if CarlitoxxPro GPON ONT module
supports LOS or other bits at byte offset 110 at address A2?
