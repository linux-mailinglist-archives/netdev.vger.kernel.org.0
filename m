Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A231C8D77
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgEGOEH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 May 2020 10:04:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:24102 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgEGOEG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 10:04:06 -0400
IronPort-SDR: d7LDCZBAKaNgicm17JVxcWiuZQiqLFdxIgeG+DtT613Xfzfn0biZvjSWXBcZBKNdfHNf/xWxoc
 SFUWH76cCxgQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 07:04:05 -0700
IronPort-SDR: 0zPLsjjUtQT1m1L3DSg05Otkjpwgb29rQWpGc4SyeQREyY+ItAl78NRHcuYg7GSoxPSRinPVi2
 t2KoQRAh8NCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,363,1583222400"; 
   d="scan'208";a="278608262"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 07 May 2020 07:04:05 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 7 May 2020 07:04:05 -0700
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.70]) by
 FMSMSX119.amr.corp.intel.com ([169.254.14.63]) with mapi id 14.03.0439.000;
 Thu, 7 May 2020 07:04:04 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
Thread-Topic: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
Thread-Index: AQHWI+1r2JNfe9cvUUWx8AZJyUPthaicvW2A///jz2A=
Date:   Thu, 7 May 2020 14:04:04 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7DCD6B850@fmsmsx124.amr.corp.intel.com>
References: <20200506210505.507254-1-jeffrey.t.kirsher@intel.com>
 <20200506210505.507254-3-jeffrey.t.kirsher@intel.com>
 <20200507081737.GC1024567@kroah.com>
In-Reply-To: <20200507081737.GC1024567@kroah.com>
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

> Subject: Re: [net-next v3 2/9] ice: Create and register virtual bus for RDMA
> 
> On Wed, May 06, 2020 at 02:04:58PM -0700, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > The RDMA block does not have its own PCI function, instead it must
> > utilize the ice driver to gain access to the PCI device. Create a
> > virtual bus device so the irdma driver can register a virtual bus
> > driver to bind to it and receive device data. The device data contains
> > all of the relevant information that the irdma peer will need to
> > access this PF's IIDC API callbacks.
> 
> But there is no virtual bus driver in this patch!

Hi Greg - 

The irdma driver is the virtbus driver that would bind to the virtual devices created
in this netdev driver.

It is decoupled from this series as it was deemed in a prior discussion that irdma driver
would go in a +1 cycle from net series to avoid conflicts. See discussion here --
https://lore.kernel.org/netdev/46ed855e75f9eda89118bfad9c6f7b16dd372c71.camel@intel.com/

The irdma driver is currently posted as an RFC series with its most recent submission here --
https://lore.kernel.org/linux-rdma/20200417171251.1533371-1-jeffrey.t.kirsher@intel.com/

Shiraz
