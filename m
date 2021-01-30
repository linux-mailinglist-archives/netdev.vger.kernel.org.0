Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC2309147
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 02:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhA3B3s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jan 2021 20:29:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:13254 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232968AbhA3BVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:21:52 -0500
IronPort-SDR: XSs1Tp/QCQab94W1HfyT8VJzORkErjvSgJMSgGhdep4bd9ijtGdFScqva+KNWNaM4giM3Bc8/G
 kUO15KRkLUXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="180642656"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="180642656"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 17:19:37 -0800
IronPort-SDR: 30BkePQM2gL3laaQjb3VjBdNDLvJc9Xb0WMoxwfsNhXB5V0MN+lBXWmUjFZWeFsnFkJJ2W1tRB
 ttNY98Wf3jhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="505918768"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jan 2021 17:19:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:37 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:19:36 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 29 Jan 2021 17:19:36 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao5N6oA//+n/DCAAMFCAIAAeSAAgAHXAYD//6CioIABFy+AgABrh4CAAjZjEA==
Date:   Sat, 30 Jan 2021 01:19:36 +0000
Message-ID: <d58f341898834170af1bfb6719e17956@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
In-Reply-To: <20210128054133.GA1877006@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> >
> > > Even with another core PCI driver, there still needs to be private
> > > communication channel between the aux rdma driver and this PCI
> > > driver to pass things like QoS updates.
> >
> > Data pushed from the core driver to its aux drivers should either be
> > done through new callbacks in a struct device_driver or by having a
> > notifier chain scheme from the core driver.
> 
> Right, and internal to driver/core device_lock will protect from parallel
> probe/remove and PCI flows.
> 

OK. We will hold the device_lock while issuing the .ops callbacks from core driver.
This should solve our synchronization issue.

There have been a few discussions in this thread. And I would like to be clear on what
to do.

So we will,

1. Remove .open/.close, .peer_register/.peer_unregister
2. Protect ops callbacks issued from core driver to the aux driver with device_lock
3. Move the custom iidc_peer_op callbacks to an irdma driver struct that encapsulates the auxiliary driver struct. For core driver to use.
4. Remove ice FSM around open, close etc...
5. RDMA aux driver probe will allocate ib_device and register it at the end of probe.

Does this sound acceptable?
