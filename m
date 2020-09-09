Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F39A263627
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIISjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:39:13 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:15771 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIISjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:39:11 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5921210000>; Wed, 09 Sep 2020 11:38:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 09 Sep 2020 11:39:09 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 09 Sep 2020 11:39:09 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 18:38:52 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 9 Sep 2020 18:38:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSLpXjDhQISSwHK1DuGKoH8REE2Fp6HD+P2k18oHpD6CwM0YvPYGrr1f8LyIV1sZnO3eGh6thB9cBYpkmsUwTIJ53GjMa7StkX2gYKBstiU+LDAFKreQoI3wRMvap3QmiXDEmD4PQR4PD4gmuzSsVINvhzZewoIJFsAzbzu0Y7c27PKw+SKWuWDgD7RR9uT+Xb79xKVxCwQBn6OOfgGTThBEQi58ge3djV6/MPvVKaOGrq0pBW57/FrSpfLmmd3lVpa4f9HODma5xD/O0nQnxF9f5mz3Q85nItHvIq3vE9ScsfpANa1/yhRUoKfSkbAreFGts8DeS+0bZyCk8WsM5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SKAIKH2gOxsBAO06t95VyU9FwWEtuWnGcM9izqCFPcE=;
 b=PWm2f+B83KvagjaD5v8rl73N/8FRzhF+1z3ZqEPdW5O82DPCaHvYL2799k19Ka6zqThMz1VTmMvIQnJgp8T8dEzC6n+6X0HEWhrk9PV0338WPqAH+URjZ+vGp0FfqB0ePWHS+KxZelqXl8ZD6MmkM1eHGGoxexOPHFAL508uMP5zz4EKsEuFld8HTeQ2e+6ldPCMb8DCxITemDtlqTcSu0NwdBN1UwQat6GCloKqK15lSgyIws71YplqKpVthv8OTOecYeONWp8TdnRlwsM2sUy3+c/bRSJYG4HHD/Kmd469NpCVN3dnD39UXOsk0dvqM9GSlfmQsvPlO6k/uTk3AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.18; Wed, 9 Sep
 2020 18:38:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 18:38:50 +0000
Date:   Wed, 9 Sep 2020 15:38:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Adit Ranadive <aditr@vmware.com>, Ariel Elior <aelior@marvell.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Faisal Latif <faisal.latif@intel.com>,
        "Gal Pressman" <galpress@amazon.com>,
        <GR-everest-linux-l2@marvell.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Leon Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        Weihang Li <liweihang@huawei.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Naresh Kumar PBS" <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Lijun Ou <oulijun@huawei.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "Selvin Xavier" <selvin.xavier@broadcom.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     Firas JahJah <firasj@amazon.com>,
        Henry Orosco <henry.orosco@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH v2 00/17] RDMA: Improve use of umem in DMA drivers
Message-ID: <20200909183848.GA950693@nvidia.com>
References: <0-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
X-ClientProxiedBy: MN2PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:208:15e::37) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR17CA0024.namprd17.prod.outlook.com (2603:10b6:208:15e::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 18:38:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kG4zY-003zL2-5s; Wed, 09 Sep 2020 15:38:48 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62bc44fe-a624-4d31-ce57-08d854ef97e4
X-MS-TrafficTypeDiagnostic: DM6PR12MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44837EC72A2532AD9D81D8DBC2260@DM6PR12MB4483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Z0kveNKk2/ZbhIvuZ61iJsmpl1HvHU4Gm3o3nZ/ND0gkTVP7x5bQWctoE47ay1b2/QByrYlWSN0i6Y/HHEPV9n+67xuGpTPt+kLuGzisDW4T7JPbv9R99lEddLW+KFmfYEXEP03zzz7+XOESaK4ZmORWQgM8bMCkllULbtLL8JPF5MCJS6klnxOBpA4zSdbnZgngv1BpEiPLGmdwKnziLthF5aUcxJZ15N7TBpnMxSIRJog7jSKQk1mQ1Dm5U504hihr2pEHhva5AnKXuWRwR34Z0ZW/PRCONu09OKEv0m3+cpUp2IjCofEL0Em2CJ7aV0/Dn+dJYXVFE2vmHd94wAlEmSBbH8eIF31o8actVYM3pT9WglEhbblZfMc8OLBtk/xT1D8F0vlkHB4WX4XSa3G34Sdop6p7w2uc31r8KrROsQQ8mgaV1ege649Kjc5s5d21Z7a5nc3lv8jhnBH0Udx/eRYe1yfSScqpi0M1Os=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(9786002)(26005)(9746002)(54906003)(426003)(186003)(66556008)(66946007)(2616005)(316002)(66476007)(110136005)(478600001)(2906002)(7416002)(6636002)(8676002)(83380400001)(5660300002)(1076003)(33656002)(966005)(4326008)(86362001)(36756003)(8936002)(27376004)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P/9UcdBTxdXYz7EMrL8bGgTjGHqUqefIDymkd0arlbcmWC6Pp9cTVeWp8U5LfEgJyjTVK6huBPGla93DB+DRau0mkFya0kra5JDKPVUImBWZvQDKcDU6hnrUBAF59+Pv7rBal0GuC1LNmshD15GN3Gwe97z5PxyJpKovTY8eZfJnhy40cnYYiigBFyEGO0x7VN0D/3unN/FXFC6eaMke8+9yCkeJzdlE4SHGX92PHPnXGRcyhgi7mzjXvVNI27dwvvwjmoCAKbtPM1RzFTnRi4CXOwyRIV4ILS4UFQxLw/EdhmKHF0AWuu0B46rzTQWTaqtdOlRyhgMhwYM75ygwGihXri+cn/SqVRWH4j1ULuHRIj42kjLaakCgumN5UeJzOpobf2eBEr3fBtILi/bLX+RBL7v/+nkOlnX5Pp+9D2rs9BVys1Pe3kK2TvqEcgNi5/xh77qrcMKKY0QYZhdQuixITWUQcImwfZ5JKSvfHLMOwtjJEJRhME/ZwtHB0+HeNm9dtWIVeauVFI+WcBKzelu7b/Wy+iOrFW6h+4x+oCs4iTfunQJR+IgydierVY9MFt38leI/+w9kcL77WhTKKxRdYqgqvo+Wav4kg/gcyHJ3hxnaUdnylN5MNTk2Pcxq1lHigW3iVAF8BRmpUkiI8Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 62bc44fe-a624-4d31-ce57-08d854ef97e4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 18:38:50.6940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4z5Mpy5jP0ggLPhGm31lzoz4m0B+XzoMzi/NbJxEzN6mW4edkrTlvznlxCjJnzkF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599676705; bh=SKAIKH2gOxsBAO06t95VyU9FwWEtuWnGcM9izqCFPcE=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=RWqBA08gvr80/oIYFVatwpTu6Q434TiV61wjT7DfwbsutjpxgS8MhWkZN/psW7Uua
         KmKBgdA22C9bQUruCV9gvwVQeF9NyZnCts4ixZdrgIvz+kSzhxzx5tNTTYyS5vnHza
         odVNDy1tWEKdI9cUVG9wz2Iu2DjD8Cp/jvfcaCBb3mBsQDxkwOGQJeREP558rWyyby
         6ESByL8D0e0rUgRIvlv24ERQtUkGBSc+aRr1QY3e3pArEgViyavaF21ad7/BqTAtNV
         vhDOrEbOGuynpOggrig2mo1feq1WK5IlqIS+vbpYIq3pjPvYzwBdgjY7+UlW9RXpLH
         UD4t0VWIUfffg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 07:41:41PM -0300, Jason Gunthorpe wrote:
> Most RDMA drivers rely on a linear table of DMA addresses organized in
> some device specific page size.
> 
> For a while now the core code has had the rdma_for_each_block() SG
> iterator to help break a umem into DMA blocks for use in the device lists.
> 
> Improve on this by adding rdma_umem_for_each_dma_block(),
> ib_umem_dma_offset() and ib_umem_num_dma_blocks().
> 
> Replace open codings, or calls to fixed PAGE_SIZE APIs, in most of the
> drivers with one of the above APIs.
> 
> Get rid of the really weird and duplicative ib_umem_page_count().
> 
> Fix two problems with ib_umem_find_best_pgsz(), and several problems
> related to computing the wrong DMA list length if IOVA != umem->address.
> 
> At this point many of the driver have a clear path to call
> ib_umem_find_best_pgsz() and replace hardcoded PAGE_SIZE or PAGE_SHIFT
> values when constructing their DMA lists.
> 
> This is the first series in an effort to modernize the umem usage in all
> the DMA drivers.
> 
> v1: https://lore.kernel.org/r/0-v1-00f59ce24f1f+19f50-umem_1_jgg@nvidia.com
> v2:
>  - Fix ib_umem_find_best_pgsz() to use IOVA not umem->addr
>  - Fix ib_umem_num_dma_blocks() to use IOVA not umem->addr
>  - Two new patches to remove wrong open coded versions of
>    ib_umem_num_dma_blocks() from EFA and i40iw
>  - Redo the mlx4 ib_umem_num_dma_blocks() to do less and be safer
>    until the whole thing can be moved to ib_umem_find_best_pgsz()
>  - Two new patches to delete calls to ib_umem_offset() in qedr and
>    ocrdma
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (17):
>   RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page
>     boundary
>   RDMA/umem: Prevent small pages from being returned by
>     ib_umem_find_best_pgsz()
>   RDMA/umem: Use simpler logic for ib_umem_find_best_pgsz()
>   RDMA/umem: Add rdma_umem_for_each_dma_block()
>   RDMA/umem: Replace for_each_sg_dma_page with
>     rdma_umem_for_each_dma_block
>   RDMA/umem: Split ib_umem_num_pages() into ib_umem_num_dma_blocks()
>   RDMA/efa: Use ib_umem_num_dma_pages()
>   RDMA/i40iw: Use ib_umem_num_dma_pages()
>   RDMA/qedr: Use rdma_umem_for_each_dma_block() instead of open-coding
>   RDMA/qedr: Use ib_umem_num_dma_blocks() instead of
>     ib_umem_page_count()
>   RDMA/bnxt: Do not use ib_umem_page_count() or ib_umem_num_pages()
>   RDMA/hns: Use ib_umem_num_dma_blocks() instead of opencoding
>   RDMA/ocrdma: Use ib_umem_num_dma_blocks() instead of
>     ib_umem_page_count()
>   RDMA/pvrdma: Use ib_umem_num_dma_blocks() instead of
>     ib_umem_page_count()
>   RDMA/mlx4: Use ib_umem_num_dma_blocks()
>   RDMA/qedr: Remove fbo and zbva from the MR
>   RDMA/ocrdma: Remove fbo from MR

Applied to for-next with Leon's note. Thanks everyone

Jason
