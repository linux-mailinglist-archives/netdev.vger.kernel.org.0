Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C4A234D01
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 23:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbgGaVbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 17:31:02 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:42739 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGaVbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 17:31:02 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06VLUwoq018753;
        Fri, 31 Jul 2020 14:30:58 -0700
Date:   Sat, 1 Aug 2020 02:47:38 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ganji Aravind <ganji.aravind@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vishal@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200731211733.GA25665@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
 <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200731110904.GA1571@chelsio.com>
 <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, July 07/31/20, 2020 at 11:00:08 -0700, Jakub Kicinski wrote:
> On Fri, 31 Jul 2020 16:39:04 +0530 Ganji Aravind wrote:
> > On Thursday, July 07/30/20, 2020 at 16:23:35 -0700, Jakub Kicinski wrote:
> > > On Thu, 30 Jul 2020 20:41:38 +0530 Ganji Aravind wrote:  
> > > > Update set_flash to flash firmware configuration image
> > > > to flash region.  
> > > 
> > > And the reason why you need to flash some .ini files separately is?  
> > 
> > Hi Jakub,
> > 
> > The firmware config file contains information on how the firmware
> > should distribute the hardware resources among NIC and
> > Upper Layer Drivers(ULD), like iWARP, crypto, filtering, etc.
> > 
> > The firmware image comes with an in-built default config file that
> > distributes resources among the NIC and all the ULDs. However, in
> > some cases, where we don't want to run a particular ULD, or if we
> > want to redistribute the resources, then we'd modify the firmware
> > config file and then firmware will redistribute those resources
> > according to the new configuration. So, if firmware finds this
> > custom config file in flash, it reads this first. Otherwise, it'll
> > continue initializing the adapter with its own in-built default
> > config file.
> 
> Sounds like something devlink could be extended to do.
> 
> Firmware update interface is not for configuration.

I thought /lib/firmware is where firmware related files need to be
placed and ethtool --flash needs to be used to program them to
their respective locations on adapter's flash.

Note that we don't have devlink support in our driver yet. And, we're
a bit confused here on why this already existing ethtool feature needs
to be duplicated to devlink.

Thanks,
Rahul
