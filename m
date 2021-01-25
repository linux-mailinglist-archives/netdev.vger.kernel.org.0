Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F82B302CD7
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732060AbhAYUoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:44:21 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19380 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732097AbhAYTuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 14:50:37 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600f20e20000>; Mon, 25 Jan 2021 11:49:54 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:49:53 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 19:49:44 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Jan 2021 19:49:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F+68gOmRfKuyvP8JRHBpA1p5zlymWaM+bxfyADMeA3mJwt2be3rxYtLNDuSNkPDuSq0Qp0MrXdtHvMV74aScDgruK///WBHxYiYfWga4xKIpaeS+B/IQ4NbYgXsid38v80iO0+YpFir9j8f9vTgdXWOca0gQ7vf6Jz7AJlkhOZmwfjEKpNol0POjYc3BIhSb9cT0arPN52C0OHwqllkDCcgwsdRE+f2/oL8Sz2o0/613aCV1TCJA911Rdq1t16HcTcFQdtPR4wbjBcKu9DSlk2vHYca/E/LZiLUYxhFMlnyJAB9PR0zj51ft8v00L/1EDSr2TC3fG0Cv72VFgntDrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rBrJp3D0/deZS2m7iEuBAAQb4R6sBhX6MDEkU8y7JU=;
 b=RvbJ59dIJz9QelmkYnrL2BsxulDtxzi65zRUCgxf5BB/pU6ea/wBLuLQSJHSVycufxNCjV6kSX+G2ZYfbsdaKdwO/sjzqkK20odvY0D8oHWivTmW5Pu0SozX8g1tWORby3QuwC98w99ZzxUYJ7Yx2X55vTU2JZIoPJlX+nNeZJ6Eh6Q8J3E4zILWEKYcDllScOMmUjIC/fxilc5DnEJ9VT/9B14jwF9TxvR3rsl1wN80GjzXk6yGlJdyDyxs5kEMdsA3LaY/Pdr9Z+ByDn/VdVpo1ejDYXqIpcW4ZjGmJVeZCU2O3FfVozTP8R/Ibn17ReTaTqhKqD9741PJtCz19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 25 Jan
 2021 19:49:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:49:43 +0000
Date:   Mon, 25 Jan 2021 15:49:41 -0400
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
Message-ID: <20210125194941.GZ4147@nvidia.com>
References: <20210122193658.282884-1-saeed@kernel.org>
 <CAKOOJTxQ8G1krPbRmRHx8N0bsHnT3XXkgkREY6NxCJ26aHH7RQ@mail.gmail.com>
 <BY5PR12MB43229840037E730F884C3356DCBD9@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20210125132210.GJ4147@nvidia.com>
 <CAKOOJTx9V328r+TC_Pd0LXQr6aMaiK2eB4Qu77Dw-kc00vg3Bg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKOOJTx9V328r+TC_Pd0LXQr6aMaiK2eB4Qu77Dw-kc00vg3Bg@mail.gmail.com>
X-ClientProxiedBy: BL0PR02CA0061.namprd02.prod.outlook.com
 (2603:10b6:207:3d::38) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0061.namprd02.prod.outlook.com (2603:10b6:207:3d::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 19:49:42 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l47rp-006ioV-F3; Mon, 25 Jan 2021 15:49:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611604194; bh=+rBrJp3D0/deZS2m7iEuBAAQb4R6sBhX6MDEkU8y7JU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=RDnS/rhgTEv6DP8YN53WBn8QXjlNEvr5mV9wJTf2K3kw+c0RsZSpRt8kR8h+KFqUb
         AbgFPBGYAVwjVo2K/hk+sqgw1mtUC3VfpFivUr1f++MnKJuDcF3+zZ7jsFdZdAtzyT
         pS32J7GcGlmp79AO2tYL0MD+hRsWrTZj5eeMHc8mw7Wf1IyV8Pa/g5KBzPn9Ni6bBp
         rqrzxjrDMROrvJkUdWCV444IQdZ8+hdHub4H0qtwrbwkfH0yizkZLr1O7k2SHO0FZc
         nwWEym3+f6Iz/KhDijmEvakBDZIwTahk7vqUZXliEVwPCSQ40DfXTFUZpoHXNBkPK9
         +u9gyjfopbaLg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 11:23:56AM -0800, Edwin Peer wrote:
> On Mon, Jan 25, 2021 at 5:22 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > SRIOV and SF's require a simple linear lookup to learn the "function"
> > because the BAR space is required to be linear.
> 
> Isn't this still true even for NumVF's > 256? Wouldn't there still be
> a contiguous VF BAR space? Don't the routing IDs simply carry on
> incrementing by stride, with each being assigned the next slice of the
> shared BAR space?

I've never seen someone implement a NumVF > 256 by co-opting the bus
number.

Can Linux even assign more bus numbers to a port without firmware
help? Bus numbers are something that requires the root complex to be
aware of to setup routability.

Jason
