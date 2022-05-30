Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3B2537586
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbiE3HhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233560AbiE3HhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:37:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A21D1208F;
        Mon, 30 May 2022 00:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653896225; x=1685432225;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yGVG/aODzVEBqfv0NxUXYp01v7JjTsmkyETK1O7Sm/U=;
  b=bgiWSU5mbkpFU/QZl/WjOOUYbFfew3W9Jt1Mj4XF0MNthUoe8Mns4prG
   rFKfhuR/tA+Ieuec8UzuUoQj+ZCbMz0rGucUujNnQV/0kUVmKwJ8CLwBo
   LqLT+xacWZFcwtUZ+tlpol1wNgyeDUzDZ+vCo9etoHLbNTufXhUF3S98W
   /RjPADUIHkc1yqlj8U5U4L7W6PCWOkHCZIhnIjfwGWOhLrp4mya/dTeSA
   9b947+n/uP7aSq/plA0VMoNpqudi00EVAd2M5gPhMdFQAHJMe+KDqbXke
   5/LcMdVjABgkJjF0sSobFLhI4qCnOdN3cq+VqLB/ZjhwyH15cgCpQhxAj
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10362"; a="337962349"
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="337962349"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 00:36:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,262,1647327600"; 
   d="scan'208";a="706048275"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 30 May 2022 00:36:44 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id B456C580689;
        Mon, 30 May 2022 00:36:40 -0700 (PDT)
Date:   Mon, 30 May 2022 15:33:56 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: phy: dp83867: retrigger SGMII AN
 when link change
Message-ID: <20220530073356.GA1199@linux.intel.com>
References: <20220526090347.128742-1-tee.min.tan@linux.intel.com>
 <Yo9zTmMduwel8XeZ@lunn.ch>
 <20220527014709.GA26992@linux.intel.com>
 <YpDHWMe7aEVWtECd@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YpDHWMe7aEVWtECd@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 02:43:04PM +0200, Andrew Lunn wrote:
> On Fri, May 27, 2022 at 09:47:09AM +0800, Tan Tee Min wrote:
> > On Thu, May 26, 2022 at 02:32:14PM +0200, Andrew Lunn wrote:
> > > On Thu, May 26, 2022 at 05:03:47PM +0800, Tan Tee Min wrote:
> > > > This could cause an issue during power up, when PHY is up prior to MAC.
> > > > At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
> > > > receive new in-band message from TI PHY with correct link status, speed
> > > > and duplex info.
> > > > 
> > > > As suggested by TI, implemented a SW solution here to retrigger SGMII
> > > > Auto-Neg whenever there is a link change.
> > > 
> > > Is there a bit in the PHY which reports host side link? There is no
> > > point triggering an AN if there is already link.
> > > 
> > >       Andrew
> > 
> > Thanks for your comment.
> > 
> > There is no register bit in TI PHY which reports the SGMII AN link status.
> > But, there is a bit that only reports the SGMII AN completion status.
> > 
> > In this case, the PHY side SGMII AN has been already completed prior to MAC is up.
> > So, once MAC side SGMII is up, MAC side SGMII wouldn`t receive any new
> > in-band message from TI PHY.
> 
> That does not make any sense for how i understand how this should
> work.
> 
> Say the bootloader brings the MAC up, the SERDES gets sync and AN is
> performed between the MAC and the PHY.
> 
> Linux takes over, downs the MAC and so the SERDES link is lost. The
> PHY should notice this. Later Linux configures the MAC up, the SERDES
> link should establish and AN should be performed.
> 
> Are you saying that the SERDES link is established, and stays
> established, even when the MAC is down?
> 
> What is the structure of the host? Does it have a MAC block and a
> SERDES block? It could be, the SERDES block is running independent of
> the MAC block, and the link is established all the time, even when the
> MAC is down. What you are missing is the MAC asking the SERDES block
> for the results of the AN when the MAC comes up. So this is actually
> an Ethernet driver bug, and you are working around it in the PHY
> driver.
> 
> Are there registers in the MAC for the SERDES? Can you read the SERDES
> link and AN state?
> 
> I have seen some MAC/SERDES combinations where you have to manually
> move the AN results from the SERDES into the MAC. So could be, your
> host will do it automatically is the MAC is up, but it won't do it if
> the MAC is down when SERDES AN completes.
> 
> I just want to fully understand the issue, because if this is just a
> workaround in the PHY, and you change the PHY, you are going to need
> the same workaround in the next PHY driver.
> 
>     Andrew

Below is the HW structure for Intel mGbE controller with external PHY.
The SERDES is located in the PHY IF in the diagram below and the EQoS
MAC uses pcs-xpcs driver for SGMII interface.

    <-----------------GBE Controller---------->|<---External PHY chip--->
    +----------+         +----+            +---+           +------------+
    |   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> |External PHY|
    |   MAC    |         |xPCS|            |IF |           |(TI DP83867)|
    +----------+         +----+            +---+           +------------+
           ^               ^                 ^                ^
           |               |                 |                |
           +---------------------MDIO-------------------------+

There are registers in the DW XPCS to read the SGMII AN status and
it's showing the SGMII AN has not completed and link status is down.
But TI PHY is showing SGMII AN is completed and the copper link is
established.

FYI, the current pcs-xpcs driver is configuring C37 SGMII as MAC-side
SGMII, so it's expecting to receive AN Tx Config from PHY about the
link state change after C28 AN is completed between PHY and Link Partner.
Here is the pcs-xpcs code for your reference:
https://elixir.bootlin.com/linux/latest/source/drivers/net/pcs/pcs-xpcs.c#L725

We faced a similar issue on MaxLinear GPY PHY in the past.
And, MaxLinear folks admitted the issue and implemented fixes/improvements
in the GPY PHY Firmware to overcome the SGMII AN issue.
Besides, they have also implemented this similar SW Workaround in their
PHY driver code to cater for the old Firmware.
Feel free to refer GPY driver code here:
https://elixir.bootlin.com/linux/latest/source/drivers/net/phy/mxl-gpy.c#L222

Apart from TI and MaxLinear PHY, we've also tested the Marvell 88E2110 and
88E1512 PHY with the MAC/SERDES combination above, Marvell PHY is working
fine without any issue.

Thanks,
Tee Min

