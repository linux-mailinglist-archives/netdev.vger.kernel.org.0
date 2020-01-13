Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3314E138DEC
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 10:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgAMJjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 04:39:02 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:45295 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMJjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 04:39:02 -0500
X-Originating-IP: 90.76.211.102
Received: from localhost (lfbn-tou-1-1151-102.w90-76.abo.wanadoo.fr [90.76.211.102])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 2E4F9FF803;
        Mon, 13 Jan 2020 09:38:58 +0000 (UTC)
Date:   Mon, 13 Jan 2020 10:38:58 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     David Miller <davem@davemloft.net>
Cc:     antoine.tenart@bootlin.com, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        camelia.groza@nxp.com, Simon.Edelhaus@aquantia.com,
        Igor.Russkikh@aquantia.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v5 00/15] net: macsec: initial support for
 hardware offloading
Message-ID: <20200113093858.GA3078@kwain>
References: <20200110162010.338611-1-antoine.tenart@bootlin.com>
 <20200111.150807.963654509739345915.davem@davemloft.net>
 <20200111.151030.80812382992588994.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200111.151030.80812382992588994.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Sat, Jan 11, 2020 at 03:10:30PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 11 Jan 2020 15:08:07 -0800 (PST)
> 
> > From: Antoine Tenart <antoine.tenart@bootlin.com>
> > Date: Fri, 10 Jan 2020 17:19:55 +0100
> > 
> >> td;dr: When applying this series, do not apply patches 12 to 14.
> >> 
> >> This series intends to add support for offloading MACsec transformations
> >> to hardware enabled devices. The series adds the necessary
> >> infrastructure for offloading MACsec configurations to hardware drivers,
> >> in patches 1 to 6; then introduces MACsec offloading support in the
> >> Microsemi MSCC PHY driver, in patches 7 to 11.
> >> 
> >> The remaining 4 patches, 12 to 14, are *not* part of the series but
> >> provide the mandatory changes needed to support offloading MACsec
> >> operations to a MAC driver. Those patches are provided for anyone
> >> willing to add support for offloading MACsec operations to a MAC, and
> >> should be part of the first series adding a MAC as a MACsec offloading
> >> provider.
> > 
> > You say four 4 patches, but 12 to 14 is 3.  I think you meant 12 to 15
> > because 15 depends upon stuff added in 12 :-)
> > 
> > I applied everything except patch #7, which had the unnecessary phy
> > exports, and also elided 12 to 15.
> 
> Actually I had to revert.
> 
> You are including net/macsec.h from a UAPI header, and that does not
> work once userlance tries to use things.  And this even makes the
> kernel build fail:
> 
> [davem@localhost net-next]$ make -s -j14
> In file included from <command-line>:32:
> ./usr/include/linux/if_macsec.h:17:10: fatal error: net/macsec.h: No such file or directory
>  #include <net/macsec.h>
>           ^~~~~~~~~~~~~~
> compilation terminated.
> make[2]: *** [usr/include/Makefile:104: usr/include/linux/if_macsec.hdrtest] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [scripts/Makefile.build:503: usr/include] Error 2
> make: *** [Makefile:1693: usr] Error 2
> 
> Please fix this and respin.  And honestly just leave 12-15 out of the v6
> submission, thanks.

Sorry for this, I'll fix the build issue and respin.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
