Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954173698C9
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243329AbhDWSCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:02:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhDWSCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 14:02:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1la07G-000hrM-F4; Fri, 23 Apr 2021 20:01:22 +0200
Date:   Fri, 23 Apr 2021 20:01:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/3] net: marvell: prestera: bump supported
 firmware version to 3.0
Message-ID: <YIMLcsstbpY215oJ@lunn.ch>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
 <YIL6feaar8Y/yOaZ@lunn.ch>
 <20210423170437.GC17656@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423170437.GC17656@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 08:04:37PM +0300, Vadym Kochan wrote:
> Hi Andrew,
> 
> On Fri, Apr 23, 2021 at 06:49:01PM +0200, Andrew Lunn wrote:
> > On Fri, Apr 23, 2021 at 06:59:31PM +0300, Vadym Kochan wrote:
> > > From: Vadym Kochan <vkochan@marvell.com>
> > > 
> > > New firmware version has some ABI and feature changes like:
> > > 
> > >     - LAG support
> > >     - initial L3 support
> > >     - changed events handling logic
> > > 
> > > Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> > > ---
> > >  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > > index 298110119272..80fb5daf1da8 100644
> > > --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > > +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> > > @@ -13,7 +13,7 @@
> > >  
> > >  #define PRESTERA_MSG_MAX_SIZE 1500
> > >  
> > > -#define PRESTERA_SUPP_FW_MAJ_VER	2
> > > +#define PRESTERA_SUPP_FW_MAJ_VER	3
> > >  #define PRESTERA_SUPP_FW_MIN_VER	0
> > 
> > I could be reading the code wrong, but it looks like anybody with
> > firmware version 2 on their machine and this new driver version
> > results in the switch not probing? And if the switch does not probe,
> > do they have any networking to go get the new firmware version?
> > 
> 
> Existing boards have management port which is separated from the PP.

I don't think that is enough. You have strongly tied the kernel
version to the firmware version. Upgrade the kernel without first
upgrading linux-firmware, and things break. In Linux distributions
these are separate packages, each with their own life cycle. There is
no guarantee they will be upgraded together.

> > I think you need to provide some degree of backwards compatibly to
> > older firmware. Support version 2 and 3. When version 4 comes out,
> > drop support for version 2 in the driver etc.

The wifi driver i have for my laptop does something like this. It
first tries to load the latest version of the firmware the driver
supports, and if that fails, it goes back to older versions until it
finds a version it can load, or gives up, saying they are all too old.

      Andrew
