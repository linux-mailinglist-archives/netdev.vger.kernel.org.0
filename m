Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC111B33C9
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 02:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDVACg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 Apr 2020 20:02:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:27852 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVACg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 20:02:36 -0400
IronPort-SDR: OQk7cXA7qC8hRrYxl67wkQo5C8bxC3H3pUPkI9Aio1CDf24a6wThmWKCgxUZL8Or+svntAzmm+
 AONhQErxCnoQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 17:02:35 -0700
IronPort-SDR: M5qgxJYVhKuvVIxoKRds+DkPbc4qc1s+5g9q+PUlX7yhbNa+e7GPLOUIWQhjpt1mqemztzj6dv
 y0C4K1Kg1EBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="273698995"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 21 Apr 2020 17:02:35 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 17:02:15 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX119.amr.corp.intel.com ([169.254.14.63]) with mapi id 14.03.0439.000;
 Tue, 21 Apr 2020 17:02:15 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Thread-Topic: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
 definitions
Thread-Index: AQHWFNtzYxwJ525w0UOK+2ymyeL4bqh+OjIAgAQT/QCAAVr7AIAATqbQ
Date:   Wed, 22 Apr 2020 00:02:14 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD4C042@fmsmsx124.amr.corp.intel.com>
References: <20200417171251.1533371-1-jeffrey.t.kirsher@intel.com>
 <20200417171251.1533371-13-jeffrey.t.kirsher@intel.com>
 <20200417203216.GH3083@unreal>
 <9DD61F30A802C4429A01CA4200E302A7DCD485B7@fmsmsx124.amr.corp.intel.com>
 <20200421073044.GI121146@unreal>
In-Reply-To: <20200421073044.GI121146@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC PATCH v5 12/16] RDMA/irdma: Add miscellaneous utility
> definitions
> 

[...]
> > > > + * irdma_arp_table -manage arp table
> > > > + * @rf: RDMA PCI function
> > > > + * @ip_addr: ip address for device
> > > > + * @ipv4: IPv4 flag
> > > > + * @mac_addr: mac address ptr
> > > > + * @action: modify, delete or add  */ int irdma_arp_table(struct
> > > > +irdma_pci_f *rf, u32 *ip_addr, bool ipv4,
> > > > +		    u8 *mac_addr, u32 action)
> > >
> > > ARP table in the RDMA driver looks strange, I see that it is legacy
> > > from i40iw, but wonder if it is the right thing to do the same for the new driver.
> > >
> >
> > See response in Patch #1.
> 
> OK, let's me rephrase the question.
> Why can't you use arp_tbl from include/net/arp.h and need to implement it in the
> RDMA driver?
> 

The driver needs to track the on-chip arp cache indices and program the
index & entry via rdma admin queue cmd. These indices are specific to our hw
arp cache and not the system arp table. So I am not sure how we can use it.
