Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C8930325A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 04:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbhAYNY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 08:24:57 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5689 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728754AbhAYNXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:23:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600ec6110001>; Mon, 25 Jan 2021 05:22:25 -0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 13:22:24 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 13:22:14 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 13:22:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xe5VlSP7opi/D00Kr2C4ITSqlFk8ohK9+q96JPlCcaW7ur/gYj0HnqZ6xc4ImX0eYriQhF0ApzDRh2IrU2p0/Zyt/bU1lVoiJiwLbFc5hZAovYinXr8J/kEtZEjU0K4RA5edHVKUb7pQZOhRd20ZCKOKZht05l9X7FBkkLuYXBFf8OFed5mPpZj3LdwmuKqXJxXAGtC9cFZAwa/tv6RWKEYFN2yOejv+4/vyb12hATiuX7xI+kVkLyCAbBp2F/N88OhSp16hML/bxLtzzjRysHm7Jt8BlM2VIz4qzq1/Y3KNcbvE+T3KfRueS+mAziKdBUNNJNDzQRRbsZm3ZanBRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N14MOe7zKRarnSVCPHj68Jlgyy0ftSkDvB71RhG3G3o=;
 b=Pkhk4y9KvGzcWQl4T8v8JSZmi4dovERoqRMJWYabE+rFfYifLYXZ5Sr38sFRhPZSPmqt2y3JUuE8J/l7bfvulUTRUSdUZTOx7L5OOPAqvU7URBv7fcbKz6r61xdxgHJ6LeB0Ao+fh80vI4bWSKds1n/LihjMeUETAxlMobokUd4HCI8XPjkWDS1LP0g19ILyvXRPV9fPWNz4LNQMb56Q5+uh+5LCPy1NO+fjW75U3aYy7XZFSET2KXXIk0nOHZjwUDVH1sJlz75K/Y6fzBLyVxIU1+l1j1IGL+W0jeC7VfruKWdHo6bCJngmc7A9fJClp7CXef057j2gcSKQsEGCGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 13:22:12 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:22:11 +0000
Date:   Mon, 25 Jan 2021 09:22:10 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
CC:     Edwin Peer <edwin.peer@broadcom.com>,
        Saeed Mahameed <saeed@kernel.org>,
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
Message-ID: <20210125132210.GJ4147@nvidia.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:208:d4::38) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR04CA0025.namprd04.prod.outlook.com (2603:10b6:208:d4::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Mon, 25 Jan 2021 13:22:11 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l41oo-006Uo3-3T; Mon, 25 Jan 2021 09:22:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611580945; bh=N14MOe7zKRarnSVCPHj68Jlgyy0ftSkDvB71RhG3G3o=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=K1HPy5pmkzjUG8rywT0tpAi2Gj8bZX6sjQiDhIZ/o98DAwI+6RXvxxXq/75tZFFt0
         wkbq9VYnSPz4nWcud1WdcIEgbyBiOHMbHuY79GOdrvQq1VdITjqQrILUr8bY90GhZV
         IvVI9OgNIH56rroVKmRynxbCu+uR59XBvbPPSD+UxuEh0Pw5PjfbHSW/GN7/MrvdU+
         P72BcDZXrEmmLwo/+nZ5M9t0iC6D9+nxYawIfQwFUBUnwDdeckULQYS40SM5JhRhVS
         Q2Z9hJFhNV/5iyHVbyQiovUvA2Zxz0QA+RcEX0KYPwhYYGikO9kTxdIMrgXHumcJ2j
         WOA9bPEhdagNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 10:57:14AM +0000, Parav Pandit wrote:
> Hi Edwin,
> 
> > From: Edwin Peer <edwin.peer@broadcom.com>
> > Sent: Monday, January 25, 2021 2:17 AM
> > 
> > On Fri, Jan 22, 2021 at 11:37 AM Saeed Mahameed <saeed@kernel.org>
> > wrote:
> > 
> > > For more detailed information about subfunctions please see detailed tag
> > > log below.
> > 
> > Apologies for the tardy question out of left field, but I've been
> > thinking about this some more. If I recall, the primary motivation for
> > this was a means to effectively address more VFs? But, why can't the
> > device simply expose more bus numbers?
> 
> Several weeks back, Jason already answered this VF scaling question
> from you at discussion [1].

To add a little more colour, the PCI spec design requires a CAM (ie
search) to figure out which function an incoming address is connected
to because there are no restrictions on how BAR's of each function
have to be layed out.

SRIOV and SF's require a simple linear lookup to learn the "function"
because the BAR space is required to be linear.

Scaling a CAM to high sizes is physicaly infeasible, so all approaches
to scaling PCI functions go this road of having a single large BAR
space.

Jason
