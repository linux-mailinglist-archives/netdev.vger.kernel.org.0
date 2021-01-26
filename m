Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9524930493A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387756AbhAZFak convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Jan 2021 00:30:40 -0500
Received: from mga18.intel.com ([134.134.136.126]:57690 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731909AbhAZB0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:26:53 -0500
IronPort-SDR: dweRfQBft2pe6o+aZ+xBpYkv0Xp94eZZLQTm3u8z4NRkeMiKYH1gmQYZe9KtGCNgOKJJF52j5c
 qyQocNeTSeLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="167500241"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="167500241"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 16:39:54 -0800
IronPort-SDR: 1A2wPb6zAmjRmOcac1CuzZW+S7ZrhN39Qwj9pcP8RTZc2I92JDgCII5E9TQUYaO/kV9Wps0rUQ
 q/WT+g2tgXxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="353264301"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 25 Jan 2021 16:39:54 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 25 Jan 2021 16:39:53 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.1713.004;
 Mon, 25 Jan 2021 16:39:53 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Topic: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Thread-Index: AQHW8RlTrNE3qjtLukSnj7NcX24DDao3Ul6AgAGNgQD//8rX0A==
Date:   Tue, 26 Jan 2021 00:39:53 +0000
Message-ID: <2072c76154cd4232b78392c650b2b2bf@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
In-Reply-To: <20210125132834.GK4147@nvidia.com>
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

> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> implement private channel OPs
> 
> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> > On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Register irdma as an auxiliary driver which can attach to auxiliary
> > > RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
> > > the private channel ops, add basic devlink support in the driver and
> > > register net notifiers.
> >
> > Devlink part in "the RDMA client" is interesting thing.
> >
> > The idea behind auxiliary bus was that PCI logic will stay at one
> > place and devlink considered as the tool to manage that.
> 
> Yes, this doesn't seem right, I don't think these auxiliary bus objects should have
> devlink instances, or at least someone from devlink land should approve of the
> idea.
> 

In our model, we have one auxdev (for RDMA) per PCI device function owned by netdev driver
and one devlink instance per auxdev. Plus there is an Intel netdev driver for each HW generation.
Moving the devlink logic to the PCI netdev driver would mean duplicating the same set of RDMA
params in each Intel netdev driver. Additionally, plumbing RDMA specific params in the netdev
driver sort of seems misplaced to me.

devlink is on a per 'struct device' object right? Should we be limiting ourselves in its
usage to only the PCI driver and PCI dev? And not other devices like auxdev?

To Leon's question on number of devlink instances, I think it is going to be same if you implement it in netdev or RDMA driver in this case.

Shiraz

