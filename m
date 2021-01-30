Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931B130942C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhA3KOo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 30 Jan 2021 05:14:44 -0500
Received: from mga12.intel.com ([192.55.52.136]:16730 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232622AbhA3BW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 20:22:59 -0500
IronPort-SDR: C7e6MbjEN56ATD8/A6EL5vfAcHITlQ1Ctz65atc2WJRaeK5x7qO/x5LeS/meMppjF5XOcV49Q6
 kNr2aXpotdcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="159672452"
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="159672452"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 17:18:57 -0800
IronPort-SDR: 2bVc/EPAEP5aWhCAvZEU5RXXpaxtPSS018yJ/t9sRq+IqT7gWcYVFzM0aPKTzM8BxDzp2HZ2hR
 s6LUpcjpJaJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,387,1602572400"; 
   d="scan'208";a="365563249"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jan 2021 17:18:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:18:56 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 29 Jan 2021 17:18:56 -0800
Received: from fmsmsx612.amr.corp.intel.com ([10.18.126.92]) by
 fmsmsx612.amr.corp.intel.com ([10.18.126.92]) with mapi id 15.01.2106.002;
 Fri, 29 Jan 2021 17:18:56 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Thread-Topic: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Thread-Index: AQHW8RlWIRUHfz8eR0uS2oJ96sRUVao5QvyAgAD4k+CAARQWgIAEGDeQ
Date:   Sat, 30 Jan 2021 01:18:56 +0000
Message-ID: <610ec40cfc71437dadc802da3e8d3b35@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-10-shiraz.saleem@intel.com>
 <20210125192319.GW4147@nvidia.com>
 <5c36451841f64f90ac2be6d23ffa9578@intel.com>
 <20210127024109.GK4147@nvidia.com>
In-Reply-To: <20210127024109.GK4147@nvidia.com>
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

> Subject: Re: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
> 
> On Wed, Jan 27, 2021 at 12:41:59AM +0000, Saleem, Shiraz wrote:
> > > Subject: Re: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
> > >
> > > On Fri, Jan 22, 2021 at 05:48:14PM -0600, Shiraz Saleem wrote:
> > > > +#define LS_64_1(val, bits)	((u64)(uintptr_t)(val) << (bits))
> > > > +#define RS_64_1(val, bits)	((u64)(uintptr_t)(val) >> (bits))
> > > > +#define LS_32_1(val, bits)	((u32)((val) << (bits)))
> > > > +#define RS_32_1(val, bits)	((u32)((val) >> (bits)))
> > > > +#define LS_64(val, field)	(((u64)(val) << field ## _S) & (field ## _M))
> > > > +#define RS_64(val, field)	((u64)((val) & field ## _M) >> field ## _S)
> > > > +#define LS_32(val, field)	(((val) << field ## _S) & (field ## _M))
> > > > +#define RS_32(val, field)	(((val) & field ## _M) >> field ## _S)
> > >
> > > Yikes, why can't this use the normal GENMASK/FIELD_PREP
> > > infrastructure like the other new drivers are now doing?
> > >
> > > EFA is not a perfect example, but EFA_GET/EFA_SET are the macros I
> > > would expect to see, just without the _MASK thing.
> > >
> > > IBA_GET/SET shows how to do that pattern
> > >
> > > > +#define FLD_LS_64(dev, val, field)	\
> > > > +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) &
> > > > +(dev)->hw_masks[field ##
> > > _M])
> > > > +#define FLD_RS_64(dev, val, field)	\
> > > > +	((u64)((val) & (dev)->hw_masks[field ## _M]) >>
> > > > +(dev)->hw_shifts[field ##
> > > _S])
> > > > +#define FLD_LS_32(dev, val, field)	\
> > > > +	(((val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
> > > > +#define FLD_RS_32(dev, val, field)	\
> > > > +	((u64)((val) & (dev)->hw_masks[field ## _M]) >>
> > > > +(dev)->hw_shifts[field ## _S])
> > >
> > > Is it because the register access is programmable? That shouldn't be
> > > a significant problem.
> > >
> >
> > Yes. How do we solve that?
> >
> > https://lore.kernel.org/linux-rdma/20200602232903.GD65026@mellanox.com
> > /
> 
> Ooh, I'm remarkably consistent after all this time
> 
> I think the answer hasn't changed the point is to make the macros the same.
> 
> And the LS/RS stuff isn't using the indirection, so why isn't it using normal
> GENMASK stuff?
> 
It can. And we will use FIELD_PREP / GENMASK on those that don't use the indirection.
FLD_LS/RS will be left alone.
