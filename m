Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D263CE222C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732365AbfJWRzm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Oct 2019 13:55:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:1186 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbfJWRzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 13:55:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Oct 2019 10:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,221,1569308400"; 
   d="scan'208";a="188329106"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga007.jf.intel.com with ESMTP; 23 Oct 2019 10:55:41 -0700
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.212]) by
 ORSMSX104.amr.corp.intel.com ([169.254.4.167]) with mapi id 14.03.0439.000;
 Wed, 23 Oct 2019 10:55:39 -0700
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Thread-Topic: [RFC 01/20] ice: Initialize and register multi-function device
 to provide RDMA
Thread-Index: AQGOetFAPbFeoIHdxRJDZlVegIphLQHJRZnhAdxiwysB1QCSuQJ6/k4op44H7uCAKV2vAP//jAtw
Date:   Wed, 23 Oct 2019 17:55:38 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B2E0C84@ORSMSX101.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-2-jeffrey.t.kirsher@intel.com>
 <20190926180556.GB1733924@kroah.com>
 <7e7f6c159de52984b89c13982f0a7fd83f1bdcd4.camel@intel.com>
 <20190927051320.GA1767635@kroah.com>
 <2B0E3F215D1AB84DA946C8BEE234CCC97B2B1A28@ORSMSX101.amr.corp.intel.com>
 <20191023174448.GP23952@ziepe.ca>
In-Reply-To: <20191023174448.GP23952@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTE5YjdmMDgtYTI5OC00MDk1LWJmODQtNGZkMmUxMzVhZDQzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiUTRwc0tOamFyTURwTUN0elJlMkJWdE5rQVJMZWVSOUdPc2hHS1VNcFloTFp0TU13cHAyNXNLdzFCbGl6RklnVSJ9
x-ctpclassification: CTP_NT
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
> From: Jason Gunthorpe [mailto:jgg@ziepe.ca]
> Sent: Wednesday, October 23, 2019 10:45 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: gregkh@linuxfoundation.org; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; dledford@redhat.com
> Subject: Re: [RFC 01/20] ice: Initialize and register multi-function device to
> provide RDMA
> 
> On Fri, Sep 27, 2019 at 06:03:51PM +0000, Ertman, David M wrote:
> > > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > > Sent: Thursday, September 26, 2019 10:13 PM
> > > To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> > > Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>;
> > > jgg@mellanox.com; netdev@vger.kernel.org;
> > > linux-rdma@vger.kernel.org; dledford@redhat.com; Ertman, David M
> > > <david.m.ertman@intel.com>
> > > Subject: Re: [RFC 01/20] ice: Initialize and register multi-function
> > > device to provide RDMA
> > >
> > > On Thu, Sep 26, 2019 at 11:39:22PM +0000, Nguyen, Anthony L wrote:
> > > > On Thu, 2019-09-26 at 20:05 +0200, Greg KH wrote:
> > > > > On Thu, Sep 26, 2019 at 09:45:00AM -0700, Jeff Kirsher wrote:
> > > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > > >
> > > > > > The RDMA block does not advertise on the PCI bus or any other bus.
> > > > >
> > > > > Huh?  How do you "know" where it is then?  Isn't is usually
> > > > > assigned to a PCI device?
> > > >
> > > > The RDMA block does not have its own PCI function so it must
> > > > register and interact with the ice driver.
> > >
> > > So the "ice driver" is the real thing controlling the pci device?
> > > How does it "know" about the RDMA block?
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The ICE driver loads and registers to control the PCI device.  It then
> > creates an MFD device with the name 'ice_rdma'. The device data
> > provided to the MFD subsystem by the ICE driver is the struct
> > iidc_peer_dev which contains all of the relevant information that the
> > IRDMA peer will need to access this PF's IIDC API callbacks
> >
> > The IRDMA driver loads as a software only driver, and then registers a
> > MFD function driver that takes ownership of MFD devices named 'ice_rdma'.
> > This causes the platform bus to perform a matching between ICE's MFD
> > device and IRDMA's driver.  Then the patform bus will call the IRDMA's
> > IIDC probe function.  This probe provides the device data to IRDMA.
> 
> Did any resolution happen here? Dave, do you know what to do to get Greg's
> approval?
> 
> Jason

This was the last communication that I saw on this topic.  I was taking Greg's silence as
"Oh ok, that works" :)  I hope I was not being too optimistic!

If there is any outstanding issue I am not aware of it, but please let me know if I am 
out of the loop!

Greg, if you have any other concerns or questions I would be happy to address them! 

-Dave E

