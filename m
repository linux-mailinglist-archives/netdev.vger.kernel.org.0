Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5528C100EFC
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKRWzK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 18 Nov 2019 17:55:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:42573 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKRWzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 17:55:10 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2019 14:55:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,321,1569308400"; 
   d="scan'208";a="215394769"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga001.fm.intel.com with ESMTP; 18 Nov 2019 14:55:08 -0800
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 18 Nov 2019 14:55:08 -0800
Received: from orsmsx101.amr.corp.intel.com ([169.254.8.229]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.139]) with mapi id 14.03.0439.000;
 Mon, 18 Nov 2019 14:55:08 -0800
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHVnATHptCZx1o750+cmj+dZwSi7aeRF4IAgAB2SgA=
Date:   Mon, 18 Nov 2019 22:55:08 +0000
Message-ID: <2B0E3F215D1AB84DA946C8BEE234CCC97B30129A@ORSMSX101.amr.corp.intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <20191118074934.GB130507@kroah.com>
In-Reply-To: <20191118074934.GB130507@kroah.com>
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
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Sunday, November 17, 2019 11:50 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca;
> parav@mellanox.com; Patil, Kiran <kiran.patil@intel.com>
> Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
> 
> On Fri, Nov 15, 2019 at 02:33:55PM -0800, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > This is the initial implementation of the Virtual Bus, virtbus_device
> > and virtbus_driver.  The virtual bus is a software based bus intended
> > to support lightweight devices and drivers and provide matching
> > between them and probing of the registered drivers.
> >
> > The primary purpose of the virual bus is to provide matching services
> > and to pass the data pointer contained in the virtbus_device to the
> > virtbus_driver during its probe call.  This will allow two separate
> > kernel objects to match up and start communication.
> >
> > The bus will support probe/remove shutdown and suspend/resume
> > callbacks.
> >
> > Kconfig and Makefile alterations are included
> >
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> > v2: Cleaned up the virtual bus interface based on feedback from Greg KH
> >     and provided a test driver and test virtual bus device as an example
> >     of how to implement the virtual bus.
> 
> There is not a real user of this here, many of your exported functions are not
> used at all, right?  I want to see this in "real use" to actually determine how it
> works, and that's the only way you will know if it solves your problem or not.
> 
> thanks,
> 
> greg k-h

I totally understand.  The ice, i40e, and irdma drivers will be available later this
week using the new virtbus.  I am implementing some changes suggested by both
you and Parav Pandit, otherwise it would already be ready :)

-Dave E
