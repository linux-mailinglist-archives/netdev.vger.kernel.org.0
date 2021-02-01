Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D4230B048
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhBATWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:22:46 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6776 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhBATWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:22:44 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601854dc0000>; Mon, 01 Feb 2021 11:22:04 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:22:00 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 19:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRulK3IdQ2PHg8EmWVjxdXCFrel26KSKbvWwwBYVoxft7YnHvZRm9PJLAKkv+cT1+TugLtEZh0d6h/EfoM/i2Z8po8wC6QS8+b9R1IsnEPubbHIi2HjNFVFoRYM9c83cZLjnRnlgk5jvXbKXrv47YSqU0wnBBfD+hgt9ailg7z87VJ7AzY+dKdIJmpx8WoxJ6zF3oVRmgSq91jMXgwjUNqNiLNA4oWVyikU9TMFWhJVA+9jsVfl2AeDjsTkWZdDfBVeu/HqcUERTwYNFXiOpg6l/QWtF6BAW9xW8Zx1dUJv+TB+Zn4T07ZRqf0zRU88EeflvSccOc4eFD4xUZKDZEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw4VTUs+KQ/vCwcSo9FudBmYRanzW79fsmqg0Rm/Vyo=;
 b=ArdLubaV8c8Mdn7uW4upbHcPyoi/stCs/chmcnsJHgPtzuys84ptTlHyz5pJdTZDziuXqxO4mxG/PQ3y9P3aSMf5ZBoiKJbPqXP6VulhT9+/ZxFDy2MmH4BO9ElHUaEXcRXnQe2BOZRal3hTKTsUdhurj7EqCR40KisNqRS6L5nXCKB/rrkN8SS9XA3b2SqVI5U+/53s6ltv+UBDsyhsIQ7+MP1QvsQXoFo3Z1vrDpOPA/mk6SKQkDQGwDJNALuLrhf8HmwBmgj7RugA9qFO5OU+75XQpPMX2FNcTPf3NqP60ijpVr7OqsAabDGpyGGCLvNM+V5y7z0Mx6ZialYv/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2437.namprd12.prod.outlook.com (2603:10b6:4:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 19:21:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 19:21:58 +0000
Date:   Mon, 1 Feb 2021 15:21:57 -0400
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
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210201192157.GR4247@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <031c2675aff248bd9c78fada059b5c02@intel.com>
X-ClientProxiedBy: MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0055.prod.exchangelabs.com (2603:10b6:208:23f::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 19:21:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6elp-002Imr-FK; Mon, 01 Feb 2021 15:21:57 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612207324; bh=bw4VTUs+KQ/vCwcSo9FudBmYRanzW79fsmqg0Rm/Vyo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=i5wRRD3UwpVTE786qYWCbr5nvOHIbDSc03nkkBGJZ4eMApEh9Cvdsj2ncF+j6GjlN
         I2mhPew+OFqFrpqOxzLndFcJRVgrfCOtGYxtTEmtB6Vtb4knfuQ1CLoJUnwmPbGKbg
         0NmRjJbEczurqf8qiShtFTt5mX4QuC/vaSy5wbfUZDhE5rZUvT9FQ4NigbyzmEwAnG
         Jy44kIV2ApJzpmURbH0AZVVRTuWxrHnukJjLwNPuCMCrEHxIATTlN/bOuxkbOsIZSW
         vXpZ4uF4GfXwGmZO6+HaWoHLpVkIOdMxv0jOEZeD3n1JQ0AqaMoczkGKSn/9QKpZbc
         ug21H7AAHCKOg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 12:41:41AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > implement private channel OPs
> > 
> > On Tue, Jan 26, 2021 at 12:42:16AM +0000, Saleem, Shiraz wrote:
> > 
> > > I think this essentially means doing away with .open/.close piece.
> > 
> > Yes, that too, and probably the FSM as well.
> > 
> > > Or are you saying that is ok?  Yes we had a discussion in the past and
> > > I thought we concluded. But maybe I misunderstood.
> > >
> > > https://lore.kernel.org/linux-rdma/9DD61F30A802C4429A01CA4200E302A7DCD
> > > 4FD03@fmsmsx124.amr.corp.intel.com/
> > 
> > Well, having now seen how aux bus ended up and the way it effected the
> > mlx5 driver, I am more firmly of the opinion this needs to be fixed. It is extremly
> > hard to get everything right with two different registration schemes running around.
> > 
> > You never answered my question:
> 
> Sorry I missed it.
> > 
> > > Still, you need to be able to cope with the user unbinding your
> > > drivers in any order via sysfs. What happens to the VFs when the PF is
> > > unbound and releases whatever resources? This is where the broadcom
> > > driver ran into troubles..
> > 
> > ?
> 
> echo -n "ice.intel_rdma.0" > /sys/bus/auxiliary/drivers/irdma/unbind  ???
> 
> That I believe will trigger a drv.remove() on the rdma PF side which require
> the rdma VFs to go down.

How? They could be in VMs

Jason
