Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D83050F3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbhA0EbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:31:19 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15628 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbhA0DCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:02:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010d2cd0000>; Tue, 26 Jan 2021 18:41:17 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 02:41:16 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 02:41:12 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 27 Jan 2021 02:41:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bm6ApYnwUFcLALuhIvURTyH6WQP6l6iCrTWs36gsVDWEJMtVrM2unPkO2THrd2MUnH6CEZojJcZ1H/2sTWjuZwCrWWbXv5uPNOIEpLvbsR9Uu+19gynkT3w4AX1dxtv2B7tUmO2MB7k7pmuf2ikxGOgNOhVWwnimBtic4pf9O9CxTa/vuqeGVwm+GRTj+wC/kGAs0OSVm1ly1vIvnUswkY/LphoL04pySjKmOVYTkUdm3sqYyQWlZ5ToUtPQGeavMpIoVwedva7sqJS6gCn/GNIvTn0FHK61oLBPBu1VTEV5sR0fGcK8gWFhyi/E5AjQ6e+ZrFPTeEsBaUNQ++MayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oHl6y1opY73UQDRpIt+UlaiGJAMUzYncsyt2HojZKg=;
 b=IOdeNtV29ZX+KivoQOr8PY60sPLgPeWlOXYO3dLEZqkjukk/0oZAYIlSGWfjsGQVzXXWjsH7j2LwmeB3mzKoIo7CazaTBa2mGjWxIeuFzxq0EEVqs/8Vu5IxL163dPc2M2TXnR3oVpDsKz+EZhERpL6kW1pmze5QuosaI5jXj0uV43VO1wTLHt4xsvqgkzr56uS9pLsjvQNDwgA7lwYicr+ggB3NOOJ/3g57+uDVANjzT605FOTTbTv5YRU2Erb/EMUZTyVAXfjlL98SzVMhK/20sfFsfthk8mytv0zo7r0ejLuVB1ElxVwjfTsTlhM/cjKXu2u01TT6ga7eTN7Mhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3516.namprd12.prod.outlook.com (2603:10b6:5:18b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 02:41:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 02:41:10 +0000
Date:   Tue, 26 Jan 2021 22:41:09 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Message-ID: <20210127024109.GK4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-10-shiraz.saleem@intel.com>
 <20210125192319.GW4147@nvidia.com>
 <5c36451841f64f90ac2be6d23ffa9578@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5c36451841f64f90ac2be6d23ffa9578@intel.com>
X-ClientProxiedBy: MN2PR05CA0063.namprd05.prod.outlook.com
 (2603:10b6:208:236::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0063.namprd05.prod.outlook.com (2603:10b6:208:236::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Wed, 27 Jan 2021 02:41:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4alZ-007KOh-C9; Tue, 26 Jan 2021 22:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611715277; bh=/oHl6y1opY73UQDRpIt+UlaiGJAMUzYncsyt2HojZKg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=NY52gJFLf1/uevsRqgkYleJKDFYlgG/1G0cJ5elBu1rHcs4Bl5n1QNEYDUaxTHJzZ
         a5SLuYf3mJ0pHZvN3a97EoCCBBIbSxIskvNIKyDjQXvCbaZCjOLURUDluEkUKWdh08
         HNRKExjnVmQm9h7RkggStUMcoXZudwO+bmqgeSJEy3Rrt4QCZwdUQKD373i+lyRfkS
         kd6yS1PgdO50OHULtugoAcIgtVOtKPOH+M1zK8xWIZ1A7eJH8Fra4yC+yYmL+wu8/2
         NdVhro7KYjSkm7R0EE3l+79ANASHLBn5+nhJCN0nTVJFKPGr4YT1xATpviKtDKn03i
         KSa7d+8lvDExw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:41:59AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
> > 
> > On Fri, Jan 22, 2021 at 05:48:14PM -0600, Shiraz Saleem wrote:
> > > +#define LS_64_1(val, bits)	((u64)(uintptr_t)(val) << (bits))
> > > +#define RS_64_1(val, bits)	((u64)(uintptr_t)(val) >> (bits))
> > > +#define LS_32_1(val, bits)	((u32)((val) << (bits)))
> > > +#define RS_32_1(val, bits)	((u32)((val) >> (bits)))
> > > +#define LS_64(val, field)	(((u64)(val) << field ## _S) & (field ## _M))
> > > +#define RS_64(val, field)	((u64)((val) & field ## _M) >> field ## _S)
> > > +#define LS_32(val, field)	(((val) << field ## _S) & (field ## _M))
> > > +#define RS_32(val, field)	(((val) & field ## _M) >> field ## _S)
> > 
> > Yikes, why can't this use the normal GENMASK/FIELD_PREP infrastructure like the
> > other new drivers are now doing?
> > 
> > EFA is not a perfect example, but EFA_GET/EFA_SET are the macros I would
> > expect to see, just without the _MASK thing.
> > 
> > IBA_GET/SET shows how to do that pattern
> > 
> > > +#define FLD_LS_64(dev, val, field)	\
> > > +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ##
> > _M])
> > > +#define FLD_RS_64(dev, val, field)	\
> > > +	((u64)((val) & (dev)->hw_masks[field ## _M]) >> (dev)->hw_shifts[field ##
> > _S])
> > > +#define FLD_LS_32(dev, val, field)	\
> > > +	(((val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
> > > +#define FLD_RS_32(dev, val, field)	\
> > > +	((u64)((val) & (dev)->hw_masks[field ## _M]) >>
> > > +(dev)->hw_shifts[field ## _S])
> > 
> > Is it because the register access is programmable? That shouldn't be a significant
> > problem.
> > 
> 
> Yes. How do we solve that?
> 
> https://lore.kernel.org/linux-rdma/20200602232903.GD65026@mellanox.com/

Ooh, I'm remarkably consistent after all this time

I think the answer hasn't changed the point is to make the macros the
same.

And the LS/RS stuff isn't using the indirection, so why isn't it using
normal GENMASK stuff?

Jason
