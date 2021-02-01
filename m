Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491CA30B046
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbhBATWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:22:13 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19670 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhBATWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:22:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601854bb0000>; Mon, 01 Feb 2021 11:21:31 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:21:30 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:21:25 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 19:21:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVnm9w7UAbGdM/xd5r4TF509IvBhYfqQXhcsBMG6bZCQE7eCVcOeqguDBLiJMjtzXlnFf2aU5FhahhlAxCWehAjHD0y1jkV9I3gQmfHPZat7SbH4rODU7qv7KyTAn1IfCjGh/1cQxEwHkgkrxsPb4xaQgZjRC9e3x+dlMAbRM4+vbVr5zYiVVmVbTslCPCkYl/WHmlUFR0cQ9/1o5e4H9c812OQkqMJv19RT9RUtffaVjqqFWAZ1UvHmSDWm8YtZ/27rdKQO0AtBgJ4Z7S8S7KqgMNSunG+YTyagRtcDm9lVPYaRzTNpSO10aB8XUvuE9sCmVcUo7+HWijkvRgOevg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZAwhGl1myqA3Za0Nb8Y5U/TtJ1mu9j0LNtbHpOrcDs=;
 b=L1UTomASWby3zAYFBgeXw4A8h1SkpzJ340HddBugqG3hIKVGD75/g4Wk6ts4GvntPiRV3ZMZwQMQDq2TGWxjw+QFmY0/aJp5FryQiWLcJj5BK+RliW1P1x7gtk4zZf9hLfKRfLEL5cEJdnes1sVQTGnF6ZkkoiGf3mvN6kcqAETbKYqV/X1ha8htxgCptgNYAL8jAl8moPVj004Xk1CPCQpzCqrs/XPYQQTsHR+sX+4Oa7y4ECvz8VhkPsbLMzWqd76TxQQtsDMOpeZ8jn8fMBs639HqAxkP3zKZCk++cFwVw/O/zU5CeGbPipQFj+rMWCmlnzAhbn+MYZD1opCh4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4778.namprd12.prod.outlook.com (2603:10b6:5:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 19:21:22 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 19:21:22 +0000
Date:   Mon, 1 Feb 2021 15:21:21 -0400
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
Subject: Re: [PATCH 20/22] RDMA/irdma: Add ABI definitions
Message-ID: <20210201192121.GQ4247@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-21-shiraz.saleem@intel.com>
 <20210125194515.GY4147@nvidia.com>
 <04dcd32fcecd4492900f0bde0e45e5dc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <04dcd32fcecd4492900f0bde0e45e5dc@intel.com>
X-ClientProxiedBy: BL0PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:207:3c::44) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0031.namprd02.prod.outlook.com (2603:10b6:207:3c::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Mon, 1 Feb 2021 19:21:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6elF-002ImG-38; Mon, 01 Feb 2021 15:21:21 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612207291; bh=kZAwhGl1myqA3Za0Nb8Y5U/TtJ1mu9j0LNtbHpOrcDs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=nPlhjvW7e+xmwEBMGWNhMmj5D2qiQVsPWOVidimdJZ6VHq72JhWrZlt/4QL+SBzv9
         zu2nGv0JL+jq84opL3uwbsN95Iequ7xdJ6iCwGOWmLq7g5VE8o5P+97go12+usAGHI
         y3khV42aKhEW9HGYNcta4PmWuWqRU44Ht9gBZ5m7/t8CBbm9nG+ugDj2AjopCIslRY
         cJdgThnoPN7eCevUGpp1Hd1YiYSdV/jQ99Ij9+g0/5bEhQf57QhIDN3WDO3geF5n5X
         i4SoQkxOISzRcapQdf4JBfM21KxXPkc8cD0PSakdt9Je4od4nk75v3j4wOLgCixhIt
         cHxPH6dvndhlg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 01:18:36AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 20/22] RDMA/irdma: Add ABI definitions
> > 
> > On Fri, Jan 22, 2021 at 05:48:25PM -0600, Shiraz Saleem wrote:
> > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > >
> > > Add ABI definitions for irdma.
> > >
> > > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > include/uapi/rdma/irdma-abi.h | 140
> > > ++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 140 insertions(+)
> > >  create mode 100644 include/uapi/rdma/irdma-abi.h
> > >
> > > diff --git a/include/uapi/rdma/irdma-abi.h
> > > b/include/uapi/rdma/irdma-abi.h new file mode 100644 index
> > > 0000000..d9c8ce1
> > > +++ b/include/uapi/rdma/irdma-abi.h
> > > @@ -0,0 +1,140 @@
> > > +/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR
> > > +Linux-OpenIB) */
> > > +/*
> > > + * Copyright (c) 2006 - 2021 Intel Corporation.  All rights reserved.
> > > + * Copyright (c) 2005 Topspin Communications.  All rights reserved.
> > > + * Copyright (c) 2005 Cisco Systems.  All rights reserved.
> > > + * Copyright (c) 2005 Open Grid Computing, Inc. All rights reserved.
> > > + */
> > > +
> > > +#ifndef IRDMA_ABI_H
> > > +#define IRDMA_ABI_H
> > > +
> > > +#include <linux/types.h>
> > > +
> > > +/* irdma must support legacy GEN_1 i40iw kernel
> > > + * and user-space whose last ABI ver is 5  */ #define IRDMA_ABI_VER 6
> > 
> > I don't want to see this value increase, either this is ABI compatible with i40iw or it
> > is not and should be a new driver_id.
> 
> I am not sure I understand how it's possible without a ver. bump.
> We support user-space libirdma with this driver as well as libi40iw. 

Well, start by not making gratuitous changes to the structure layouts
and then ask how to handle what you have left over.

It looks like nothing hard, where is the problem?

Jason
