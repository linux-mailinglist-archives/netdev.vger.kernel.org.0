Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58C6302C23
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbhAYUBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:01:24 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1162 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732101AbhAYUAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 15:00:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f231a0001>; Mon, 25 Jan 2021 11:59:22 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:59:21 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:59:09 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:59:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MehVQasvtHWct/n9CLc2VvuwyfcWKFVfhUf79UqSmJdLD/vJyoz17IyFvruv6lDE73Pc+Mp/iDNY2Vmogy1XaS5z6ADF6S++a9MjpO8SbExIGapaymWzWZJ5YsrRKaxRpIcOhbGpKwR4xpT/Nk5L1OZPauVwyX5eCC6ieDLW6JWgcgw+/0+6EeH4HTdQNrCkzEy5OjxweMG1K80wwt0PM7W/CPbAVAS4zPdfXrs20v5MDmuH4rH/Mhj9dsRMo+HfwxLK+JgZE8HNunwfIUq8Uz2Fa0V/tIzPeH0CDGO3ilDLrQmBxke9akJJObziOuvCfyjjoBK+KSJLYFn7JafQ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7U3SjgSGJP4ltv0PXCC/4xxdefhqR9yXyDJSdz4bFSM=;
 b=PZQP4p7F+mz89bN3fRZGDd7btFrUz9McCj3yuGiOdgcCBBNOQJWxGDjWSVVP703HiBDlk04lVnud5A3BXvNKG6asYKT9bry5j7lyu0cKgh8ob+iVfSOzdQ+HbWLChdsDhTVObvXjSFm0ufrfCtfhZ2pVDr7xYNeCLA87SSpL3Es0SdfEiImGsCuHmWjXchON+d0rnWKuA9TnE8gP1zJNP8fakiJBLn70NzYXwuT6IsYplnt/IYzoUIfiiNzlRUll5Droa8cYkPwzPXyA8ht7jTXlLQ2DyzBtJ9G4r3L7DXe8g04bFxCovUFEN/UP//ayojNKbjivOEyEFf76kDw8NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2488.namprd12.prod.outlook.com (2603:10b6:4:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 19:59:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:59:07 +0000
Date:   Mon, 25 Jan 2021 15:59:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
CC:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Kiran Patil <kiran.patil@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next V10 00/14] Add mlx5 subfunction support
Message-ID: <20210125195905.GA4147@nvidia.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKOOJTw_RfYfFunhHKTD6k73FvFObVb5Xx7hK8uPUUGJpuTzuw@mail.gmail.com>
 <CAKOOJTx7ogAvUkT5y8vKYp=KB+VSbe0MgXg5PuvjEiU_dO_5YA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKOOJTx7ogAvUkT5y8vKYp=KB+VSbe0MgXg5PuvjEiU_dO_5YA@mail.gmail.com>
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR05CA0004.namprd05.prod.outlook.com (2603:10b6:208:91::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Mon, 25 Jan 2021 19:59:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l480w-006ixN-08; Mon, 25 Jan 2021 15:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611604762; bh=7U3SjgSGJP4ltv0PXCC/4xxdefhqR9yXyDJSdz4bFSM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Kpb6tF5OrtY94t2DY8dABNagpG7VAFaUz+Bj/C3cc6thnCxrHt6rjX94SbL9aOAlg
         XgNROrbQtOdfx2V6dPu//5x33KKQT2TiwFi13IvCnhOkfE5sLZz5XhFseyW7SIMUZd
         mKS54U5SOn/T12pX2t8ZO3PTEfkbQmC27T9nnNE+8k4/YGb1CRJTsC6LLQAzmkiLAf
         YOG0zsE4lQfXNOKNlSOLTRfhGh+KU5OoUVyoD8CzygtTY5Nv8lrrC0buWq+nz3OE5v
         u4ZCevmJTtSy1KsEGPUey70c39zTbMjG9DwninHmpkZDNtHl1uPwNF1LJ4W7OtaxxF
         pgraLs8kQiPVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:34:49AM -0800, Edwin Peer wrote:

> What do these amount to in practice? Presumably config space is backed
> by normal memory controlled by firmware. Do VF's need to expose ECAM?
> Also, don't MSI tables come out of the BAR budget? Is the required BAR
> space necessarily more than any other addressable unit that can be
> delegated to a SF?

Every writable data mandated by the PCI spec requires very expensive
on-die SRAM to store it.

We've seen Intel drivers that show their SIOV ADIs don't even have a
register file and the only PCI presence is just a write-only doorbell
page in the BAR.

It is hard to argue a write-only register in a BAR page vs all the
SRIOV trappings when it comes to HW cost.

Jason
