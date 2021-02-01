Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2385A30B03E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhBATTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:19:50 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1817 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhBATTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:19:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018542a0000>; Mon, 01 Feb 2021 11:19:06 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:19:03 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:18:10 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 19:18:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLOu8/hOFdiUG1llR3FKkuA1TM/4V58Z7jPeo26HKlf6fI3xYewwoYhmOa+ZMfBCxJJPkKFbfJDtKCU1lxKEx61p6IRngcEaD0IuVgHKl8j11nacbZSINRfxcjymtKYO8Avj2DsgP/TtuBWc/yE9MBoGXgpNwHo8Ye4mlfTP/pcvr+691EywzpkTOYioy0jVUZgU51SX3bieysVVci9oaaEdy0KJEfA2gedcmCfPkrvu+HXLcGTloMRVDeytsXeJFR3ArgS4sLzOw47Z+eBXXNR5QRxQ3TM2Btmqgkvf0WpGLu4yrK6MU4pjpQBQuggv6tfiYa9Ald7WYrpJga7csA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L52XxPg9GOO+gFKhaEBrJSXExjP2SyvmaMR8UrDwGvQ=;
 b=GvuxdDcuUPQoa7Ap9HkvEd/fX6U7ZxWKJVr0Z88GjScAQX3syHHDEufdo0nDiMMp5l9LKkxe/5lAEgy54uRSmM+RUO8uU6nJxMhDfcMi2SC7LNjFluLkQMEkOHvKbCfONnTLeY15kEN5pyg6sv3FLERITMR71KuRBeekpRJEqhmBbcf/deULnFhgkEXwLKyyTztsDwE/uH8iy1hXEYd09cPYNHzoZm2kaon3TBKCidsQQjHGMd8J7OaJBHRTPSobg+aiAZFT1QyNsXNkCKO2qF+3d7KPswtyPWcK3EfggFX2jZqNnXNg9YD3lSUPBvaI9eSh8DfIgweD73KmhiuPMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.25; Mon, 1 Feb
 2021 19:18:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 19:18:07 +0000
Date:   Mon, 1 Feb 2021 15:18:05 -0400
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
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
Message-ID: <20210201191805.GO4247@nvidia.com>
References: <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210125184248.GS4147@nvidia.com>
 <99895f7c10a2473c84a105f46c7ef498@intel.com>
 <20210126005928.GF4147@nvidia.com>
 <031c2675aff248bd9c78fada059b5c02@intel.com>
 <20210127121847.GK1053290@unreal>
 <ea62658f01664a6ea9438631c9ddcb6e@intel.com>
 <20210127231641.GS4147@nvidia.com> <20210128054133.GA1877006@unreal>
 <d58f341898834170af1bfb6719e17956@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d58f341898834170af1bfb6719e17956@intel.com>
X-ClientProxiedBy: MN2PR20CA0051.namprd20.prod.outlook.com
 (2603:10b6:208:235::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0051.namprd20.prod.outlook.com (2603:10b6:208:235::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 19:18:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6ei5-002IjC-Ow; Mon, 01 Feb 2021 15:18:05 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612207146; bh=L52XxPg9GOO+gFKhaEBrJSXExjP2SyvmaMR8UrDwGvQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=okEMjmoaEBr83aDn5i9yObKN2A/zDTPjW7rDUFqfskXiPHaI5IQaKIDVOdZ9b2qwI
         LGcNOW16PCLu7SDUO517SeME6LEvsTfL3MNH69LNrf/NRIrY7aA7AwP2OWplp+tN6R
         XPCvJRHojBzSPSv+wMkqQRXFhmYFro2TxQ+75m4ZN0kbPhbQZQUTcvQMjJ15nnjLVw
         cLQiBUqwxi3YPOfaxIIl2D2XY1an6Lz1CFXJvhj2A+9vX7++eMffh7rmnEhZReTdCw
         qr0yg7aD0NkkdZr/2pw1fkxpZa5O96+Y0nrq1/GadK8gvi57796P/cdDHrAT39+mqI
         cGnkvoaDLY4WQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 01:19:36AM +0000, Saleem, Shiraz wrote:
> > Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
> > implement private channel OPs
> > 
> > On Wed, Jan 27, 2021 at 07:16:41PM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 27, 2021 at 10:17:56PM +0000, Saleem, Shiraz wrote:
> > >
> > > > Even with another core PCI driver, there still needs to be private
> > > > communication channel between the aux rdma driver and this PCI
> > > > driver to pass things like QoS updates.
> > >
> > > Data pushed from the core driver to its aux drivers should either be
> > > done through new callbacks in a struct device_driver or by having a
> > > notifier chain scheme from the core driver.
> > 
> > Right, and internal to driver/core device_lock will protect from parallel
> > probe/remove and PCI flows.
> > 
> 
> OK. We will hold the device_lock while issuing the .ops callbacks from core driver.
> This should solve our synchronization issue.
> 
> There have been a few discussions in this thread. And I would like to be clear on what
> to do.
> 
> So we will,
> 
> 1. Remove .open/.close, .peer_register/.peer_unregister
> 2. Protect ops callbacks issued from core driver to the aux driver
> with device_lock

A notifier chain is probably better, honestly.

Especially since you don't want to split the netdev side, a notifier
chain can be used by both cases equally.

Jason
