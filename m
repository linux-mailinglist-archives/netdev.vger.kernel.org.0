Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E163301A
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfFCMp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 08:45:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfFCMp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 08:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Et6nrjAK7Pqph5akQJ3YiHQPpWtwaiEJXjZlHEdDEP4=; b=gW9uSA7XvajprKdkIRQxIPUk42
        6+PQrULX23WSBY0OqId4B9o/oV3KgvYUTUgxCmVxpdTwu+e+refM9CA0pcHKvwyIHWl3Jv3RJDG8B
        vfSseczgeD1adnOB+pfIT5hi+f9uJc3y/EHm+HKuEgcDVrKr1gbSAzvosuVL6pZdoZGk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXmLY-0004ki-88; Mon, 03 Jun 2019 14:45:52 +0200
Date:   Mon, 3 Jun 2019 14:45:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] net: dsa: add support for mv88e6250
Message-ID: <20190603124552.GC17267@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-6-rasmus.villemoes@prevas.dk>
 <20190524142728.GL2979@lunn.ch>
 <b05a12b8-fe03-e3c4-dbf0-ca29c1931e54@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b05a12b8-fe03-e3c4-dbf0-ca29c1931e54@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 08:52:38AM +0000, Rasmus Villemoes wrote:
> On 24/05/2019 16.27, Andrew Lunn wrote:
> >> @@ -4841,6 +4910,10 @@ static const struct of_device_id mv88e6xxx_of_match[] = {
> >>  		.compatible = "marvell,mv88e6190",
> >>  		.data = &mv88e6xxx_table[MV88E6190],
> >>  	},
> >> +	{
> >> +		.compatible = "marvell,mv88e6250",
> >> +		.data = &mv88e6xxx_table[MV88E6250],
> >> +	},
> >>  	{ /* sentinel */ },
> >>  };
> > 
> > Ah, yes. I had not thought about that. A device at address 0 would be
> > found, but a device at address 16 would be missed.
> 
> Eh, no? The port registers are at offset 0x8, i.e. at either SMI address
> 8 or 24, so I don't think a 6250 at address 0 could be detected using
> either of the existing families?

Even better.

The real problem is, people keep trying to add new compatible strings
here when they should not. The compatible string is about being able
to read the ID registers, not to list every single switch chip family.

This is one case where it really is needed, and i had not thought
about that.

      Andrew
