Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45A347E158
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 11:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347617AbhLWKXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 05:23:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239344AbhLWKXA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 05:23:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MArMGCZ4sp/C4MYnm4nxg0qh/KUio32K5/XLn829OC4=; b=yHriCuq6dBzpNIqFXAdbo5c3Yf
        cWXwyhvSIsctu+7luYSCSZ3VRVV/mUkYGEJb4Eux8jgc3VV2TzSA3lUAWk2gj//+iEyCBwj64sszC
        xCOqar5Xwru2jRtwq0DbOTN1XodyufQzOC9C6paj7g8zBt0gJmwQ0U9JuH+OUf1BZ5Uw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n0LFH-00HIMl-KR; Thu, 23 Dec 2021 11:22:47 +0100
Date:   Thu, 23 Dec 2021 11:22:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcRN9zwkP4nw4Dh8@lunn.ch>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
 <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcJJh9e2QCJOoEB/@lunn.ch>
 <CO1PR11MB5170C1925DFB4BFE4B7819F5D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcOYDi1s5x5gU/5w@lunn.ch>
 <CO1PR11MB5170B7667FD1C091E1946CEDD97E9@CO1PR11MB5170.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB5170B7667FD1C091E1946CEDD97E9@CO1PR11MB5170.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 23, 2021 at 05:15:34AM +0000, Chen, Mike Ximing wrote:
> 
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Wednesday, December 22, 2021 4:27 PM
> > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.org; Williams, Dan J
> > <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@vger.kernel.org;
> > davem@davemloft.net; kuba@kernel.org
> > Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
> > 
> > > > pointing to skbufs? How are the lifetimes of skbufs managed? How do
> > > > you get skbufs out of the NIC? Are you using XDP?
> > >
> > > This is not a network accelerator in the sense that it does not have
> > > direct access to the network sockets/ports. We do not use XDP.
> > 
> > So not using XDP is a problem. I looked at previous versions of this patch, and it is all DPDK. But DPDK is
> > not in mainline, XDP is. In order for this to be merged into mainline you need a mainline user of it.
> > 
> > Maybe you should abandon mainline, and just get this driver merged into the DPDK fork of Linux?
> > 
> Hi Andrew,
> 
> I am not sure why not using XDP is a problem. As mentioned earlier, the
> DLB driver is not a part of network stack.  
> 
> DPDK is one of applications that can make a good use of DLB, but is not the
> only one. We have applications that access DLB directly via the kernel driver API
> without using DPDK.

Cool. Please can you point at a repo for the code? As i said, we just
need a userspace user, which gives us a good idea how the hardware is
supposed to be used, how the kAPI is to be used, and act as a good
test case for when kernel modifications are made. But it needs to be
pure mainline.

There have been a few good discussion on LWN about accelerators
recently. Worth reading.

	  Andrew
