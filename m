Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663032BA01D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgKTBys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:54:48 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgKTByr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:54:47 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfvdE-0082qw-MZ; Fri, 20 Nov 2020 02:54:36 +0100
Date:   Fri, 20 Nov 2020 02:54:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Pavana Sharma <pavana.sharma@digi.com>, lkp@intel.com,
        ashkan.boldaji@digi.com, clang-built-linux@googlegroups.com,
        davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v10 4/4] net: dsa: mv88e6xxx: Add support for mv88e6393x
 family  of Marvell
Message-ID: <20201120015436.GC1804098@lunn.ch>
References: <cover.1605830552.git.pavana.sharma@digi.com>
 <df58a3716ab900a0c2a4d727ddae52ef1310fcdc.1605830552.git.pavana.sharma@digi.com>
 <20201120012906.GA1804098@lunn.ch>
 <20201120024311.5021d6b7@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120024311.5021d6b7@nic.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 02:43:11AM +0100, Marek Behun wrote:
> Hi Andrew,
> 
> On Fri, 20 Nov 2020 02:29:06 +0100
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > > +	if (speed >= 2500 && port > 0 && port < 9)
> > > +		return -EOPNOTSUPP;  
> > 
> > Maybe i'm missing something, but it looks like at this point you can
> > call
> > 
> > 	return mv88e6xxx_port_set_speed_duplex(chip, port, speed, true, true, duplex);
> 
> He can't. That function does not support speed 5000. You can't simply
> add it, because it clashes with register value for speed 2500 on
> previous switches (Peridot, Topaz).
> 
> 	Amethyst reg val	Peridot + Topaz reg val
> 2500	SPD_1000 | ALT_BIT	SPD_10000 | ALT_BIT
> 5000	SPD_10000 | ALT_BIT	not supported
> 10000	SPD_UNFORCED		SPD_UNFORCED

Hi Marek

O.K, as i said, i might be missing something :-)

I think a comment would be nice, pointing this out. Otherwise somebody
might try refactoring it, and make the same mistake!

      Andrew
