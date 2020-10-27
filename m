Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4970A29CBA8
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374689AbgJ0V62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:58:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48432 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897378AbgJ0V61 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 17:58:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXWym-003sRd-1O; Tue, 27 Oct 2020 22:58:08 +0100
Date:   Tue, 27 Oct 2020 22:58:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6123/6131
Message-ID: <20201027215808.GF904240@lunn.ch>
References: <20201022012516.18720-1-chris.packham@alliedtelesis.co.nz>
 <20201022012516.18720-5-chris.packham@alliedtelesis.co.nz>
 <20201023224216.GE745568@lunn.ch>
 <1b1d4c27-570b-8a2f-698b-d82b2ca8215d@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1d4c27-570b-8a2f-698b-d82b2ca8215d@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 08:56:09PM +0000, Chris Packham wrote:
> 
> On 24/10/20 11:42 am, Andrew Lunn wrote:
> >> +int mv88e6123_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
> >> +{
> >> +	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
> >> +		return 0;
> >> +
> >> +	return 26 * sizeof(u16);
> >> +}
> > Hi Chris
> >
> > Where did 26 come from?

> In the 88E6123 Serdes Register Description the highest register address 
> was 26 so that's what I used.

> Technically there are 32 possible 
> addresses in that space so I could go up to 32. Equally registers 9-14, 
> 20, 22-23 are "reserved" so I could remove them from the total and have 
> mv88e6123_serdes_get_regs() skip over them. I'm guessing skipping some 
> (27-32) and not others is probably less than ideal.

Hi Chris

I would dump all 32 and let userspace figure out if they mean
anything. The current register dump for the 6390 SEDES is horrible,
and i missed a register, and it is not easy to put in its correct
place because of ABI reasons. If you can do KISS, all the better.

      Andrew
