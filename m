Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790AF304925
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732995AbhAZFaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:30:10 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17675 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731605AbhAYTYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:24:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f1ab30000>; Mon, 25 Jan 2021 11:23:31 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:23:30 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:23:24 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:23:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLzpkqBe1D+ffNoeA8z3pjkh1tTdAYSGnD3clbFtiiPS7Bm4k3lFzPIDpMNjtGKTZvqqMTWPpOBQkhvsphMl9WrmPXlK2yaSxAM/f6c0TBHgIpnAN/ry3mM/5hYN9IO7i6FvmBWRisMTkZLg87X6Zxh8F5ukSPZ2wyxNnwHljogiizw/ZwbGnzS5PdisbSAFj/4U/cp4asS/dg0+NxKTGRphPFk7ABwJ7M2aXAnCok7ZyAMwMukYXx/xMx3HChjfMdYFltiSYprlv84tfB0FwFYnpgNkrK9kx4TAWn9/wgRlGt+2ywC8mWlI2V0pJoet2IwUY5piOO5G1LSZM6hjmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NfZn8/vgbvXLs39OV5+DLkRYC8rfCgVQ41wEMwYd+4=;
 b=GS9iAedl8mxwMbyD7KIU7tHR9k2zemWV23RZTRIkfna7PDOaImOeEbblPAcfAWyBgZBknAwQvhVMXHEAsm3Ty1WvoI7b+dZQOW05W/3eg7SuaeucDdnpChyDjDBYF36vUuq3u4TTIiHG0pqcKzCdmau8XhCEw7WfGpeJEJu8peliiJl7efeHZ47K5JnuFTMU2pq5iv+IC8cWB6xD9MxP0xYCkycGIv0w+EoGe17Rmbe34SN/c42S0WLq9NFKIlpDaQAWt3XoWrLeRvZqxHIDjiU4Fr6pZvgqjmuFQJ2Zn9KQk18AgyWwaB6nQb0MDVnpRPiqZnR/5G/yFzXQj3Ukwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Mon, 25 Jan
 2021 19:23:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:23:21 +0000
Date:   Mon, 25 Jan 2021 15:23:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
CC:     <dledford@redhat.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <linux-rdma@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <netdev@vger.kernel.org>, <david.m.ertman@intel.com>,
        <anthony.l.nguyen@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: [PATCH 09/22] RDMA/irdma: Implement HW Admin Queue OPs
Message-ID: <20210125192319.GW4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-10-shiraz.saleem@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210122234827.1353-10-shiraz.saleem@intel.com>
X-ClientProxiedBy: BL0PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:208:2d::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR03CA0005.namprd03.prod.outlook.com (2603:10b6:208:2d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 19:23:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l47SJ-006iL3-4P; Mon, 25 Jan 2021 15:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611602611; bh=6NfZn8/vgbvXLs39OV5+DLkRYC8rfCgVQ41wEMwYd+4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=fgl4q9/9432pZu3bMEAOWRFWa0l3cCsDyUx+LpBcWltuLANxLHh8GuX2Pd7plGfod
         xcGYWHKGGpuyqSICLNv7UMccsFPgJweNda4JD2oLfPAaL45POoU3B7dIdpeMbXa/Jk
         ZalCray+yrqXCZUY3Ga2QyktYpZhiYrDMiBkIO2fDuArWHYwUflMdvZbGItK2gdn9u
         v5SucNga1cqeRU1nIGg9mXoeV3ynHf+evL/L4tjC1403GD76q2wERCbqQ2Jpe2v5PF
         mm2PR3qTnZKGsIBOEeLMOdoH+ZbBZ950Ij9FOi4khqXBQ78/ZDxS6gVgYr5d+S5jwM
         /nrusPJub7OtQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 05:48:14PM -0600, Shiraz Saleem wrote:
> +#define LS_64_1(val, bits)	((u64)(uintptr_t)(val) << (bits))
> +#define RS_64_1(val, bits)	((u64)(uintptr_t)(val) >> (bits))
> +#define LS_32_1(val, bits)	((u32)((val) << (bits)))
> +#define RS_32_1(val, bits)	((u32)((val) >> (bits)))
> +#define LS_64(val, field)	(((u64)(val) << field ## _S) & (field ## _M))
> +#define RS_64(val, field)	((u64)((val) & field ## _M) >> field ## _S)
> +#define LS_32(val, field)	(((val) << field ## _S) & (field ## _M))
> +#define RS_32(val, field)	(((val) & field ## _M) >> field ## _S)

Yikes, why can't this use the normal GENMASK/FIELD_PREP infrastructure
like the other new drivers are now doing?

EFA is not a perfect example, but EFA_GET/EFA_SET are the macros I
would expect to see, just without the _MASK thing.

IBA_GET/SET shows how to do that pattern

> +#define FLD_LS_64(dev, val, field)	\
> +	(((u64)(val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
> +#define FLD_RS_64(dev, val, field)	\
> +	((u64)((val) & (dev)->hw_masks[field ## _M]) >> (dev)->hw_shifts[field ## _S])
> +#define FLD_LS_32(dev, val, field)	\
> +	(((val) << (dev)->hw_shifts[field ## _S]) & (dev)->hw_masks[field ## _M])
> +#define FLD_RS_32(dev, val, field)	\
> +	((u64)((val) & (dev)->hw_masks[field ## _M]) >> (dev)->hw_shifts[field ## _S])

Is it because the register access is programmable? That shouldn't be a
significant problem.

> +#define IRDMA_CQPSQ_QHASH_QS_HANDLE_S 0
> +#define IRDMA_CQPSQ_QHASH_QS_HANDLE_M ((u64)0x3ff << IRDMA_CQPSQ_QHASH_QS_HANDLE_S)

All of this is particularly painful

A bit of time with coccinelle would probably fix all of this

Jason
