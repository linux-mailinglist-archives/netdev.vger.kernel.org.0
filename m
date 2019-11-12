Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FCBF9BE7
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfKLVSy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Nov 2019 16:18:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:8238 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbfKLVSx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 16:18:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 13:18:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,297,1569308400"; 
   d="scan'208";a="202815791"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by fmsmga007.fm.intel.com with ESMTP; 12 Nov 2019 13:18:52 -0800
Received: from orsmsx153.amr.corp.intel.com (10.22.226.247) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 12 Nov 2019 13:18:52 -0800
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.229]) by
 ORSMSX153.amr.corp.intel.com ([169.254.12.169]) with mapi id 14.03.0439.000;
 Tue, 12 Nov 2019 13:18:52 -0800
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVmMVm9b0Ngs5xNEiEdFE1b2GqoqeIjNoA//97xfA=
Date:   Tue, 12 Nov 2019 21:18:52 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B2FE421@ORSMSX101.amr.corp.intel.com>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
 <20191112205958.GH5584@ziepe.ca>
In-Reply-To: <20191112205958.GH5584@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, November 12, 2019 1:00 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> parav@mellanox.com; Patil, Kiran <kiran.patil@intel.com>
> Subject: Re: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
> 
> On Mon, Nov 11, 2019 at 11:22:19AM -0800, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > This is the initial implementation of the Virtual Bus, virtbus_device
> > and virtbus_driver.  The virtual bus is a software based bus intended
> > to support lightweight devices and drivers and provide matching
> > between them and probing of the registered drivers.
> >
> > Files added:
> > 	drivers/bus/virtual_bus.c
> > 	include/linux/virtual_bus.h
> > 	Documentation/driver-api/virtual_bus.rst
> >
> > The primary purpose of the virual bus is to provide matching services
> > and to pass the data pointer contained in the virtbus_device to the
> > virtbus_driver during its probe call.  This will allow two separate
> > kernel objects to match up and start communication.
> 
> I think this is the 'multi_subsystem_device' idea I threw out in this thread. ie
> pass an opaque void *pointer, done here by
> virtbus_get_devdata():
> 
>  https://lore.kernel.org/r/20191109084659.GB1289838@kroah.com
> 
> And Greg said 'Ick, no'..
> 
> So each driver should makes its own bus, and perhaps we should provide
> some helper stuff for the repeating code, like PM function reflection?
> 
> Jason

This submission is from a thread with GregKH where I put forth a design proposal
of implementing a new software based bus.  I originally was going to name it
generic bus, and he suggested virtual bus.

Here is the meat of the thread:

>> We could add a new module to the kernel named generic_bus.ko.  This 
>> would create a new generic software bus and a set of APIs that would 
>> allow for adding and removing simple generic virtual devices and 
>> drivers, not as a MFD cell or a platform device. The power management 
>> events would also be handled by the generic_bus infrastructure (suspend, resume, shutdown).
>> We would use this for matching up by having the irdma driver register 
>> with this generic bus and hook to virtual devices that were added from 
>> different PCI LAN drivers.
>> 
>> Pros:
>> 1) This would avoid us attaching anything to the platform bus
>> 2) Avoid having each PCI LAN driver creating its own software bus
>> 3) Provide a common matching ground for generic devices and drivers 
>> that eliminates problems caused by load order (all dependent on 
>> generic_bus.ko)
>> 4) Usable by any other entity that wants a lightweight matching system 
>> or information exchange mechanism
>> 
>> Cons:
>> 1) Duplicates part of the platform bus functionality
>> 2) Adds a new software bus to the kernel architecture
>> 
>> Is this path forward acceptable?
>
>Yes, that is much better.  But how about calling it a "virtual bus"?
>It's not really virtualization, but we already have virtual devices today when you look in sysfs for devices that are created that are not >associated with any specific bus.  So this could take those over quite nicely!  Look at how /sys/devices/virtual/ works for specifics, you could >create a new virtual bus of a specific "name" and then add devices to that bus directly.
>
>thanks,
>
>greg k-h

I am hoping that I didn't completely misunderstand him.

-Dave E
