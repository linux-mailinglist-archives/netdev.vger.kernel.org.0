Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110632D20B2
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 03:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgLHCRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 21:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLHCRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 21:17:14 -0500
Date:   Mon, 7 Dec 2020 18:16:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607393793;
        bh=aRk0tuN5gCFQ7woh8dahZNtsNwLAvKayoBIKDXzgY4g=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=YtzOtiH/3gJA7+9FQu1MilnluzeCMWP+lRrTTCJZF5EafTwr5EAnplsMbSvYlpROa
         ijBAroc1W5VosSS4wVmb4a8EeZTUEGAHw+kVAgR6Hj4JAtUEzrkP0r06Hnw07rk9XU
         rCB8qZ9mYdTSNJrAu26whsLUAV1iHMfeZWBc+7UYHZoI2zxMF6G8Yyr2dSOwmH+vAd
         TDVlSIzuqWrGwupa1dcP8vecmmzXjG6XDNrs8SZih+gLNbtawktx+1GsbgbUbKtkzW
         QXwSCnolsvd8IhWTZD3oi2sQIs09zCR3C2jhVe7GEVG+glysTMutSpaifVkgJj0fEa
         01gPFBPdzt0WA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        David S Miller <davem@davemloft.net>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1 2/2] net: dsa: microchip: improve port count
 comments
Message-ID: <20201207181631.6cade981@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207233116.GB2475764@lunn.ch>
References: <20201205152814.7867-1-TheSven73@gmail.com>
        <20201205152814.7867-2-TheSven73@gmail.com>
        <20201207233116.GB2475764@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 00:31:16 +0100 Andrew Lunn wrote:
> On Sat, Dec 05, 2020 at 10:28:14AM -0500, Sven Van Asbroeck wrote:
> > From: Sven Van Asbroeck <thesven73@gmail.com>
> > 
> > Port counts in microchip dsa drivers can be quite confusing:
> > on the ksz8795, ksz_chip_data->port_cnt excludes the cpu port,
> > yet on the ksz9477, it includes the cpu port.
> > 
> > Add comments to document this situation explicitly.  
> 
> Rather than document it, we should make it uniform. Unless there is a
> valid reason to require them to mean different things.

Agreed.

I wonder if we should make this effort target net-next.

My concern is that for the 3 port switch the cpu_ports variable is set
to 0x10, the same as for the 4 port one. Which makes me worried that 
if we just allow the "+ 1" - the CPU port will not actually hit the
register offsets its supposed to on 3 port platforms.

Since configuring the CPU port never worked here (AFAICT) we can view
this as a new feature / config option (even tho an important one).

So let's move to net-next, and we can "do this right".

Does that sound sane?
