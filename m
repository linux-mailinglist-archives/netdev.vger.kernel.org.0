Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56682EEB32
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbhAHCN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:13:58 -0500
Received: from mga05.intel.com ([192.55.52.43]:57271 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbhAHCN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 21:13:58 -0500
IronPort-SDR: OEt6Sk1gX+g07acmqoQR062KmF9jDfFvplKDXEAzndce234T6n1GiupAOYTbmh4H0Wifz/78D7
 0i7nNEcfD9Rg==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="262297182"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="262297182"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 18:13:17 -0800
IronPort-SDR: PDGuJFH4rDJVtqUethAESPgpiqxSQjpjlgIydKpgyhLextU8T183Z4SIxG7QKllNY0+DlozMvP
 +dzUSyM6KdNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="570597816"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by fmsmga005.fm.intel.com with ESMTP; 07 Jan 2021 18:13:15 -0800
Date:   Fri, 8 Jan 2021 10:08:29 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        lee.jones@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, trix@redhat.com, lgoncalv@redhat.com,
        hao.wu@intel.com, matthew.gerlach@intel.com,
        russell.h.weight@intel.com, yilun.xu@intel.com
Subject: Re: [RESEND PATCH 2/2] misc: add support for retimers interfaces on
  Intel MAX 10 BMC
Message-ID: <20210108020829.GC13860@yilunxu-OptiPlex-7050>
References: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
 <1609999628-12748-3-git-send-email-yilun.xu@intel.com>
 <X/bTtBUevX5IBPUl@kroah.com>
 <X/cf+o1tuYre1JzU@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/cf+o1tuYre1JzU@lunn.ch>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 03:51:38PM +0100, Andrew Lunn wrote:
> On Thu, Jan 07, 2021 at 10:26:12AM +0100, Greg KH wrote:
> > On Thu, Jan 07, 2021 at 02:07:08PM +0800, Xu Yilun wrote:
> > > This driver supports the ethernet retimers (C827) for the Intel PAC
> > > (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
> > > 
> > > C827 is an Intel(R) Ethernet serdes transceiver chip that supports
> > > up to 100G transfer. On Intel PAC N3000 there are 2 C827 chips
> > > managed by the Intel MAX 10 BMC firmware. They are configured in 4 ports
> > > 10G/25G retimer mode. Host could query their link states and firmware
> > > version information via retimer interfaces (Shared registers) on Intel
> > > MAX 10 BMC. The driver creates sysfs interfaces for users to query these
> > > information.
> > 
> > Networking people, please look at this sysfs file:
> > 
> > > +What:		/sys/bus/platform/devices/n3000bmc-retimer.*.auto/link_statusX
> > > +Date:		Jan 2021
> > > +KernelVersion:	5.12
> > > +Contact:	Xu Yilun <yilun.xu@intel.com>
> > > +Description:	Read only. Returns the status of each line side link. "1" for
> > > +		link up, "0" for link down.
> > > +		Format: "%u".
> > 
> > as I need your approval to add it because it is not the "normal" way for
> > link status to be exported to userspace.
> 
> Hi Greg
> 
> Correct, this is not going to be acceptable.
> 
> The whole architecture needs to cleanly fit into the phylink model for
> controlling the SFP and the retimer.
> 
> I'm guessing Intel needs to rewrite portions of the BMC firmware to
> either transparently pass through access to the SFP socket and the
> retimer for phylink and a C827 specific driver, or add a high level
> API which a MAC driver can use, and completely hide away these PHY
> details from Linux, which is what many of the Intel Ethernet drivers
> do.

Got it, Thanks for your explanation.

Yilun
