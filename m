Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9832304930
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbhAZFad convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:30:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:31395 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387440AbhAZBXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:23:24 -0500
IronPort-SDR: oZWRFmGYYMtY4RZP3OJs7ANd4uZCr/IAvQ2kluH0m7/3/NgiGFNuSOWZJga2QaqB0xUhZOX3j4
 NGE3B7fbdJ8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179050465"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179050465"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 16:57:43 -0800
IronPort-SDR: CXDMzNOA/+Uh7UeFfUhVG/+pGBcuxji6hmdz5jvKdgHmXBWbYH7MyVqkuCKSlHOKbRFT87T8an
 URG/5wmDi6AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="368927213"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 25 Jan 2021 16:57:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 25 Jan 2021 16:57:41 -0800
Received: from orsmsx610.amr.corp.intel.com ([10.22.229.23]) by
 ORSMSX610.amr.corp.intel.com ([10.22.229.23]) with mapi id 15.01.1713.004;
 Mon, 25 Jan 2021 16:57:41 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     Leon Romanovsky <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8R0q9oy2W9uBuU2uSYnJtHdSaao3Ul6AgAGNgQD//8rX0IAA8vMA//9711A=
Date:   Tue, 26 Jan 2021 00:57:41 +0000
Message-ID: <27df0b1283124afa896899cab3969b03@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <20210126004758.GE4147@nvidia.com>
In-Reply-To: <20210126004758.GE4147@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 25, 2021 4:48 PM
> To: Saleem, Shiraz <shiraz.saleem@intel.com>
> Cc: Leon Romanovsky <leon@kernel.org>; dledford@redhat.com;
> kuba@kernel.org; davem@davemloft.net; linux-rdma@vger.kernel.org;
> gregkh@linuxfoundation.org; netdev@vger.kernel.org; Ertman, David M
> <david.m.ertman@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Ismail, Mustafa <mustafa.ismail@intel.com>;
> Keller, Jacob E <jacob.e.keller@intel.com>; jiri@nvidia.com; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; Williams, Dan J <dan.j.williams@intel.com>
> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Tue, Jan 26, 2021 at 12:39:53AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > > implement private channel OPs
> > >
> > > On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> > > > On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > > >
> > > > > Register irdma as an auxiliary driver which can attach to auxiliary
> > > > > RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
> > > > > the private channel ops, add basic devlink support in the driver and
> > > > > register net notifiers.
> > > >
> > > > Devlink part in "the RDMA client" is interesting thing.
> > > >
> > > > The idea behind auxiliary bus was that PCI logic will stay at one
> > > > place and devlink considered as the tool to manage that.
> > >
> > > Yes, this doesn't seem right, I don't think these auxiliary bus objects should
> have
> > > devlink instances, or at least someone from devlink land should approve of
> the
> > > idea.
> > >
> >
> > In our model, we have one auxdev (for RDMA) per PCI device function
> > owned by netdev driver and one devlink instance per auxdev. Plus
> > there is an Intel netdev driver for each HW generation.  Moving the
> > devlink logic to the PCI netdev driver would mean duplicating the
> > same set of RDMA params in each Intel netdev driver. Additionally,
> > plumbing RDMA specific params in the netdev driver sort of seems
> > misplaced to me.
> 
> That's because it is not supposed to be "the netdev driver" but the
> shared physical PCI function driver, and devlink is a shared part of
> the PCI function.

Well, at least in Intel ice driver case, we have multiple PCI functions, and each function gets its own devlink (as opposed to a single devlink instance). There's no separation between the netdev driver and the PCI function driver today.

> 
> > devlink is on a per 'struct device' object right? Should we be
> > limiting ourselves in its usage to only the PCI driver and PCI dev?
> > And not other devices like auxdev?
> 
> The devlink should not be created on the aux device, devlink should be
> created against PCI functions.
> 
> It is important to follow establish convention here, otherwise it is a
> user mess to know what to do
> 
> Jason
