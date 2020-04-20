Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7A61B1A47
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgDTXrT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Apr 2020 19:47:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:17892 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgDTXrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:47:18 -0400
IronPort-SDR: sMIllEOLX+xsvkCM83zliQiPbkJcOygAjztpOcH4OG5awe7oUMNJyH7z3JYnpf1CltjnVLoxvp
 VRcscjalhOSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:47:17 -0700
IronPort-SDR: TgHwtbIiBeR/RAZHMGFvfelrsQbeJOHtV46ii6301Acn81QnCdRQnQ7X0YQwRhCT4WpFxogEJB
 c/GTd3XZ1zhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300429857"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 16:47:16 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 16:47:16 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.248]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.36]) with mapi id 14.03.0439.000;
 Mon, 20 Apr 2020 16:47:16 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 2/9] ice: Create and register virtual bus for RDMA
Thread-Topic: [net-next 2/9] ice: Create and register virtual bus for RDMA
Thread-Index: AQHWFNsstHCiaW4QAEuCsEzo2mqkcKh+JW4AgASML3A=
Date:   Mon, 20 Apr 2020 23:47:15 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D940449866CCA8@ORSMSX112.amr.corp.intel.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-3-jeffrey.t.kirsher@intel.com>
 <20200417191756.GJ26002@ziepe.ca>
In-Reply-To: <20200417191756.GJ26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, April 17, 2020 12:18
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com; Nguyen,
> Anthony L <anthony.l.nguyen@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [net-next 2/9] ice: Create and register virtual bus for RDMA
> 
> On Fri, Apr 17, 2020 at 10:10:27AM -0700, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > The RDMA block does not have its own PCI function, instead it must
> > utilize the ice driver to gain access to the PCI device. Create a
> > virtual bus device so the irdma driver can register a virtual bus
> > driver to bind to it and receive device data. The device data contains
> > all of the relevant information that the irdma peer will need to
> > access this PF's IIDC API callbacks.
> 
> Can you please provide examples of what the sysfs paths for all this stuff looks
> like?
[Kirsher, Jeffrey T] 

Here is an example using ice and irdma driver registered:
/sys/bus/virtbus/devices/intel,ice,rdma.7
/sys/bus/virtbus/devices/intel,ice,rdma.5
/sys/bus/virtbus/devices/intel,ice,rdma.6
/sys/bus/virtbus/devices/intel,ice,rdma.4
/sys/bus/virtbus/drivers/irdma/intel,ice,rdma.7
/sys/bus/virtbus/drivers/irdma/intel,ice,rdma.5
/sys/bus/virtbus/drivers/irdma/intel,ice,rdma.6
/sys/bus/virtbus/drivers/irdma/intel,ice,rdma.4
/sys/devices/pci0000:00/0000:00:1c.4/0000:09:00.0/intel,ice,rdma.4
/sys/devices/pci0000:00/0000:00:1c.4/0000:09:00.3/intel,ice,rdma.7
/sys/devices/pci0000:00/0000:00:1c.4/0000:09:00.1/intel,ice,rdma.5
/sys/devices/pci0000:00/0000:00:1c.4/0000:09:00.2/intel,ice,rdma.6
/sys/module/virtual_bus/holders/ice
/sys/module/ice
/sys/module/ice/drivers/pci:ice
/sys/bus/pci/drivers/ice

/sys/bus/virtbus/drivers/irdma
/sys/module/virtual_bus/holders/irdma
/sys/module/irdma
/sys/module/irdma/drivers/virtbus:irdma
/sys/module/ib_core/holders/irdma
/sys/module/ib_uverbs/holders/irdma

> 
> Does power management work right?
[Kirsher, Jeffrey T] 

The power management we tested so far is working.  Are you seeing any issue?

> 
> Jason
