Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34E538941B
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 18:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355402AbhESQwi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 12:52:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:18000 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347377AbhESQwh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 12:52:37 -0400
IronPort-SDR: qkvvP9aAZYmkYpxkvawxYhEcj6+MLRTGx8y73nw4wvVfrkNvuoGHmCFPmx0MWzqYmh5hyrpxa5
 e69NfeXroycw==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="264941181"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="264941181"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 09:51:17 -0700
IronPort-SDR: xNgzBehC1uS2OlE5lb/KVwo2ldshCP/DPLX1uLrldkPusCAnFZL5JIfWv6tyU8svv/BbxkgSJV
 PwRZlRsoChhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440054300"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 19 May 2021 09:51:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 09:51:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 19 May 2021 09:51:15 -0700
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2242.008;
 Wed, 19 May 2021 09:51:15 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v5 06/22] i40e: Register auxiliary devices to provide RDMA
Thread-Topic: [PATCH v5 06/22] i40e: Register auxiliary devices to provide
 RDMA
Thread-Index: AQHXSMuNeBvhiyPQ+0SPTP6MHcChsarrPzUAgAAOi4D//5bpAA==
Date:   Wed, 19 May 2021 16:51:15 +0000
Message-ID: <071aae50fb0d427c9e365c4a38a5771d@intel.com>
References: <20210514141214.2120-1-shiraz.saleem@intel.com>
 <20210514141214.2120-7-shiraz.saleem@intel.com> <YKUJ4rnZf4u4qUYc@unreal>
 <20210519134349.GK1002214@nvidia.com>
In-Reply-To: <20210519134349.GK1002214@nvidia.com>
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

> Subject: Re: [PATCH v5 06/22] i40e: Register auxiliary devices to provide RDMA
> 
> On Wed, May 19, 2021 at 03:51:46PM +0300, Leon Romanovsky wrote:
> > On Fri, May 14, 2021 at 09:11:58AM -0500, Shiraz Saleem wrote:
> > > Convert i40e to use the auxiliary bus infrastructure to export the
> > > RDMA functionality of the device to the RDMA driver.
> > > Register i40e client auxiliary RDMA device on the auxiliary bus per
> > > PCIe device function for the new auxiliary rdma driver (irdma) to
> > > attach to.
> > >
> > > The global i40e_register_client and i40e_unregister_client symbols
> > > will be obsoleted once irdma replaces i40iw in the kernel for the
> > > X722 device.
> > >
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > >  drivers/net/ethernet/intel/Kconfig            |   1 +
> > >  drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
> > >  drivers/net/ethernet/intel/i40e/i40e_client.c | 152 ++++++++++++++++++++++-
> ---
> > >  drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
> > >  4 files changed, 136 insertions(+), 20 deletions(-)
> >
> > The amount of obfuscation in this driver is astonishing.
> >
> > I would expect that after this series, the i40e_client_add_*() would
> > be cleaned, for example simple grep of I40E_CLIENT_VERSION_MAJOR shows
> > that i40e_register_client() still have no-go code.
> 
> While it would be nice to see i40e fully cleaned I think we agreed to largely ignore it
> as-is so long as the new driver's aux implementation was sane.
> 

And for stuff like i40e_register_client and associated, I will send a cleanup patch after this series
is merged to remove it.

Shiraz


