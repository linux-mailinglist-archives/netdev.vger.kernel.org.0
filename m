Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D238296FDF
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464244AbgJWNFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:05:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41484 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S464240AbgJWNFV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 09:05:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kVwkx-003854-KK; Fri, 23 Oct 2020 15:05:19 +0200
Date:   Fri, 23 Oct 2020 15:05:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com
Subject: Re: lan78xx: /sys/class/net/eth0/carrier stuck at 1
Message-ID: <20201023130519.GB745568@lunn.ch>
References: <20201021170053.4832d1ad@gollum>
 <20201021193548.GU139700@lunn.ch>
 <20201023082959.496d4596@gollum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201023082959.496d4596@gollum>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 08:29:59AM +0200, Juerg Haefliger wrote:
> On Wed, 21 Oct 2020 21:35:48 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > On Wed, Oct 21, 2020 at 05:00:53PM +0200, Juerg Haefliger wrote:
> > > Hi,
> > > 
> > > If the lan78xx driver is compiled into the kernel and the network cable is
> > > plugged in at boot, /sys/class/net/eth0/carrier is stuck at 1 and doesn't
> > > toggle if the cable is unplugged and replugged.
> > > 
> > > If the network cable is *not* plugged in at boot, all seems to work fine.
> > > I.e., post-boot cable plugs and unplugs toggle the carrier flag.
> > > 
> > > Also, everything seems to work fine if the driver is compiled as a module.
> > > 
> > > There's an older ticket for the raspi kernel [1] but I've just tested this
> > > with a 5.8 kernel on a Pi 3B+ and still see that behavior.  
> > 
> > Hi Jürg
> 
> Hi Andrew,
> 
> 
> > Could you check if a different PHY driver is being used when it is
> > built and broken vs module or built in and working.
> > 
> > Look at /sys/class/net/eth0/phydev/driver
> 
> There's no such file.

I _think_ that means it is using genphy, the generic PHY driver, not a
specific vendor PHY driver? What does

/sys/class/net/eth0/phydev/phy_id contain.
  
> Given that all works fine as long as the cable is unplugged at boot points
> more towards a race at boot or incorrect initialization sequence or something.

Could be. Could you run

mii-tool -vv eth0

in the good and bad case.

   Andrew

