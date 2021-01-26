Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C360F303523
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbhAZFgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:36:24 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15220 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731411AbhAZCRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:17:43 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f6c1f0005>; Mon, 25 Jan 2021 17:10:55 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 01:10:55 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 01:10:48 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.58) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 01:10:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMIV5UsluO3X4t3QrvgbvUNAq05r47cSSO7CPeocq0B2/e2MtLLo58ZlKt7jfQ0EIu0ohgmADW/VNLo9j4pWspNJiqswQbv+SvBvWhXWty2bAlPLZseQm5kgeEqpxU8CnoP0wgrYOdoWkRvi08kWgfIjaTODNc0IuvNCsUdNOv1ErtezwbFPqavCl2SzVNtLrpmVe+jEJS6rhfe5mpJB5zh9w7QjHDrZlPdotUDYjb7G1fyLuFCn47DaW6dXmrdPZkajrHY2Y6fCHB5bkJL9Tp2Yf2cZy6bTCYI2y2t1pq4I1F7Yiep/OmGCXpBtQRl0nFRMH5IV/PtTo/RaZaHztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bv1m0IqIy+JuqUa83fJ5LkpwhUejXPUQe/Okvn0g/jg=;
 b=bg+tMOhKbKsIOJvda1gEJEuvoGMk9K4cQivOzyJb5wXhjbs/lFWfBELhGEVKhn3RSAsBTCThjrfw9jZZ7xG1PeWemjtS5g0N7a5eFigHLaxkuuNPG+3k2tZvRZ5cPgVeA3o3j7BgI3y9rVn6Aryoe1MX3a+zb4XQrEZaIQFdzqKUhee6iJIR6YBxkk27UXRNm2VlDFixqxjEvVmnvOJGtmaSA4QlqCQwHYRzhWMPDtB+qslz4NtDAZ7hgxrv3F97G0AqfafBBehMNEpoexiBZtm1Bp+oKZ3j/bBGR289qwfNuWbDGFlPIy23AVY71+YBhPH3+676ZgNAzTyTcO6cLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3020.namprd12.prod.outlook.com (2603:10b6:5:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 26 Jan
 2021 01:10:46 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 01:10:45 +0000
Date:   Mon, 25 Jan 2021 21:10:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
CC:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
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
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210126011043.GG4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
X-ClientProxiedBy: BLAPR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:208:32c::23) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0168.namprd03.prod.outlook.com (2603:10b6:208:32c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 01:10:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4CsV-006tOB-4u; Mon, 25 Jan 2021 21:10:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611623456; bh=bv1m0IqIy+JuqUa83fJ5LkpwhUejXPUQe/Okvn0g/jg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=NXcdNM7E30KnqmiclGSzWD7TjPefBZu+AyetuApiL6O2twRBNpQkfcQtGboD3hLGa
         JwhTQcKtonmCRGERJYqTJFOzQPlFDMnCM9P8fRlWfYiQb5GxLsf0JML8pKEWU6jeQ/
         zjOBdcKTTkifJZ/Yn8puZh47ntsBJo6yWQlESrW4kMfRhEmwrV1kIDjQfJz2Opf8TJ
         b2psz0tFQUMMDFpBeeHgAd3Dzdg4YIii+rZUwwlkBKBS1hNbm6aO+PNT+zx72XLc7y
         KU3BJCJsubtjha2NcHS+PzKRxuXpW96c7qc3KpNKpbEbQAl3lhn44o9g47erY6M+Rz
         8eGwXfNDNjcQA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 05:01:40PM -0800, Jacob Keller wrote:
> 
> 
> On 1/25/2021 4:39 PM, Saleem, Shiraz wrote:
> >> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> >> implement private channel OPs
> >>
> >> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> >>> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> >>>> From: Mustafa Ismail <mustafa.ismail@intel.com>
> >>>>
> >>>> Register irdma as an auxiliary driver which can attach to auxiliary
> >>>> RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
> >>>> the private channel ops, add basic devlink support in the driver and
> >>>> register net notifiers.
> >>>
> >>> Devlink part in "the RDMA client" is interesting thing.
> >>>
> >>> The idea behind auxiliary bus was that PCI logic will stay at one
> >>> place and devlink considered as the tool to manage that.
> >>
> >> Yes, this doesn't seem right, I don't think these auxiliary bus objects should have
> >> devlink instances, or at least someone from devlink land should approve of the
> >> idea.
> >>
> > 
> > In our model, we have one auxdev (for RDMA) per PCI device function owned by netdev driver
> > and one devlink instance per auxdev. Plus there is an Intel netdev driver for each HW generation.
> > Moving the devlink logic to the PCI netdev driver would mean duplicating the same set of RDMA
> > params in each Intel netdev driver. Additionally, plumbing RDMA specific params in the netdev
> > driver sort of seems misplaced to me.
> > 
> 
> I agree that plumbing these parameters at the PCI side in the devlink of
> the parent device is weird. They don't seem to be parameters that the
> parent driver cares about.

It does, the PCI driver is not supposed to spawn any aux devices for
RDMA at all if RDMA is disabled.

For an iWarp driver I would consider ENABLE_ROCE to really be a
general ENABLE_RDMA.

Are you sure you need to implement this?

In any event, you just can't put the generic ENABLE_ROCE flag anyplace
but the PCI device for devlink, it breaks the expected user API
established by mlx5

Jason
