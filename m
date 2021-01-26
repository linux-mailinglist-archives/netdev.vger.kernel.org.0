Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE1C3048FB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbhAZFfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:35:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14514 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731081AbhAZCPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:15:16 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f66c80001>; Mon, 25 Jan 2021 16:48:08 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 00:48:05 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 26 Jan 2021 00:48:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPbzMMu0q8aoEomC+M9Ll9yvOw9u2vDZZnCJGj0w0GP1josY4TBuWBEeS/Gy6v9QKeyKFCQ6cKIoY6AwYaAkCZOg1yWAJABXBlN/vatQKVMMw6uHINEhQRCCQYX5X2O6nHTX/Hr+owyt2ak8tTL6k8xUGET7HFPE6apkI2/yn4/R8SHrWiRq9v5Y4vhTc0M1YkyVrt91fhmTonMeHGJQ2eyvOaElQSw4P+SyfwcpNq5BYiqELiWw0HB7rCpaTSwPnPIs4VbCB2Bj9pYGNeIRi2Nt56QnfhVzjatTKPCV0RDcS2bFBxfqLFHC1ouC1151gbm5UsWBxXoIfDOsbv0bLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9jRXUkeuLh7XYlF/894j7WdH3Nz4vJ6F5L88FPWdqo=;
 b=bce7LSRsayZrRgSMLr11lQfi/4PwmAq45f8wqFEmQd9Sl5aBy1cQDeicRVHm0NFcz16rAmZ18Jr6QKATKgwTln8M06bO2mpNAGHhwexC/C2TT5MGgmCJZ0jqZH8h5SBI2cz+P6KQE4HNs/ADYARXHUF2sXVzfQslEEDbKcwB5tfAM86+FDVtKi9zZ6d2t6/SGSs7a1mud5xyGwiBLCfEmHc1kUtV1ME2/no/ttV6IkjnvZfDb/llDzqGo0Jzh7EiNT95HNzQdXPBX2nBBPMuB5MCdCsqf5+oT6qgtU8DUeEap6dL3RrBPrYeU0O+nZkfAnO3AA5hWhOS3DhbgjldYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0204.namprd12.prod.outlook.com (2603:10b6:4:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Tue, 26 Jan
 2021 00:48:00 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 00:48:00 +0000
Date:   Mon, 25 Jan 2021 20:47:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
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
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210126004758.GE4147@nvidia.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2072c76154cd4232b78392c650b2b2bf@intel.com>
X-ClientProxiedBy: BL1PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0165.namprd13.prod.outlook.com (2603:10b6:208:2bd::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Tue, 26 Jan 2021 00:48:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l4CWU-006t0d-QM; Mon, 25 Jan 2021 20:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611622088; bh=M9jRXUkeuLh7XYlF/894j7WdH3Nz4vJ6F5L88FPWdqo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=h7RXY7B75dogwjnHqEbKzTlVyIWx+tTqd2jf4TaaTMlxGm4FY+Apt0ZN0td+S4x5T
         Neoa3q9l0ojF7QwJKWfZpaIE/DCc/p7sNJdktd7+5sWd7+KqFPnosHPXTTlR2Ip1ZO
         8KmdKW1TBVXKihR6VswvBLZUfTCtHJZtdtHZ+fmkcd/L0DhBZOviIAp96m+1mze0eI
         1ygR/HwLOCigDcYQHKeEvcz8t05xegcZ+sn3ODfR2Vl8n0cdgRBHuuYXj4yF/lVc9J
         dYxIx7I5/FPc//yxp667WTIGhlu/wfqgwt4YZHteJnhP9h1T4Vkm2E8ARLudTphmFG
         8Wy+d0vak0lEg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 12:39:53AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > implement private channel OPs
> > 
> > On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
> > > On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
> > > > From: Mustafa Ismail <mustafa.ismail@intel.com>
> > > >
> > > > Register irdma as an auxiliary driver which can attach to auxiliary
> > > > RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
> > > > the private channel ops, add basic devlink support in the driver and
> > > > register net notifiers.
> > >
> > > Devlink part in "the RDMA client" is interesting thing.
> > >
> > > The idea behind auxiliary bus was that PCI logic will stay at one
> > > place and devlink considered as the tool to manage that.
> > 
> > Yes, this doesn't seem right, I don't think these auxiliary bus objects should have
> > devlink instances, or at least someone from devlink land should approve of the
> > idea.
> > 
> 
> In our model, we have one auxdev (for RDMA) per PCI device function
> owned by netdev driver and one devlink instance per auxdev. Plus
> there is an Intel netdev driver for each HW generation.  Moving the
> devlink logic to the PCI netdev driver would mean duplicating the
> same set of RDMA params in each Intel netdev driver. Additionally,
> plumbing RDMA specific params in the netdev driver sort of seems
> misplaced to me.

That's because it is not supposed to be "the netdev driver" but the
shared physical PCI function driver, and devlink is a shared part of
the PCI function.

> devlink is on a per 'struct device' object right? Should we be
> limiting ourselves in its usage to only the PCI driver and PCI dev?
> And not other devices like auxdev?

The devlink should not be created on the aux device, devlink should be
created against PCI functions.

It is important to follow establish convention here, otherwise it is a
user mess to know what to do

Jason
