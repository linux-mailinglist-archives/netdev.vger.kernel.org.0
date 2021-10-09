Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46622427842
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 11:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244338AbhJIJGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 05:06:30 -0400
Received: from mail-co1nam11on2074.outbound.protection.outlook.com ([40.107.220.74]:27712
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229995AbhJIJG3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 05:06:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7bgtx38s4I9F6jFq/29lQTqlIShJSS4v7C2eUsWQfU7K5AxF0ozoNXibu2DfcKCM4MNGpZ0tgypOEsnZaU5M8PSxsTUWQkO6uPdFHk7EUcehV0ShmIZyOCWFGn6XaEsqNax/+7nsBFivlSxMcXybh/gqSP00ut3H9SkJycDJS1j/Uv3LwDKlq92UsW5X9IOX0IvLTvz2nyUa/sDPn7PrLF869mTukFh24TSAe2x40bEQUMgpUb1yKaHoArIocycqkRiJT2MXil/W+Me8Y5RKoNm3ekSeGpuYKHBfo+7+l6Xmuusb2KJrezstK2U3ruCxhbqbLRf4FKh9bDIURnv6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PcHpVXSKrCXNdeO7M0WCdHyH08yBiDir6cI61ZOJ8BU=;
 b=Tcfyu4QZtqYmuSa4BDa93PGn2A2QGzZwvDiZCl2xzj/gpIJQjHJneGhZ1dKesqobJOOv8GaVhAbKZtZONU99DKpKxZf/MISotuFQnT7vpsOjpiU0eXazOFIyUU36zqo/NzZU1+U0grRCLPdSzdRD5I8Op3aosHzuWn6FxUMI0FiFmrryNZ33noBcnKubMV70V7zgEzvB+4nJ3CnjgvZFITdj/uc5tjabscbUJ8Z/+Jpf3xpvSCTuQOB4yU/jBv3MY7yt2ReDr+wWKxz0TkN5FXMIwV5w41tUKUZwmRwvGmPd8t1U+bMiIsYV3sLZun/QwW1GMP2KYwMQa3E0Svz+8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.112.34) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PcHpVXSKrCXNdeO7M0WCdHyH08yBiDir6cI61ZOJ8BU=;
 b=MSjsMa0lzTJLtAb1JpM/JHSGkvnLyESpymwU1IxSsy41cJW0jK1mjtbHzrRJDGrqGoFjC7/A9jPlt4sez0SZMDAJlznaYePx/KlMpQcsVzOf8bsPPw5hWstGm8xvHGOTCeutjF+WyMe6MD8QuQP3XRGOT5r6+rgZCzlzXdT2iDy80s8HewgcoU+F6EqQ5XZMp0ypui3ZU9veaJ7IwhBtNSTrJsN8ePsR4Jbi0VDpGWg69lvwU6mhx3ycx4ZL04pCUiHqYUhV4Jb294mgMrfCTXiGDN4S19lSNFB1bqOHzaMbUEiQdIjk96OzbVrzXynYaL7gviHtBYVjYwQetwy0+A==
Received: from DM6PR08CA0013.namprd08.prod.outlook.com (2603:10b6:5:80::26) by
 CY4PR1201MB0247.namprd12.prod.outlook.com (2603:10b6:910:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Sat, 9 Oct
 2021 09:04:31 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::e3) by DM6PR08CA0013.outlook.office365.com
 (2603:10b6:5:80::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Sat, 9 Oct 2021 09:04:31 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.112.34) smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not
 signed) header.d=none;chelsio.com; dmarc=temperror action=none
 header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Sat, 9 Oct 2021 09:04:29 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 9 Oct
 2021 09:04:28 +0000
Date:   Sat, 9 Oct 2021 12:04:24 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Mark Zhang <markzhang@nvidia.com>, <dledford@redhat.com>,
        <saeedm@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <aharonl@nvidia.com>, <netao@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v4 00/13] Optional counter statistics support
Message-ID: <YWFbGLPdXanAeDAG@unreal>
References: <20211008122439.166063-1-markzhang@nvidia.com>
 <20211008185736.GP2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211008185736.GP2744544@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a625d7d4-80b8-44ca-fa7d-08d98b03cd70
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0247:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0247867FCA4218487407B884BDB39@CY4PR1201MB0247.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 24bcC/amDYUen3yd7fWheIB5r+xA6TW7u/3xDy5EMz8+RAmiAe5dCjb9TVFJ7DCdmcQXJcU/NtzZS78hXJUBSzB6s5TDrz9Ah1f3BJ2h93/+S7XSKIeswFkuOBG+QgXo2+sMWLiSV/Bhu2p/MmspFv7/qVUycD/bOgRTiWmdAD8xtNC45lJEAhz1hII9O6tPvrl9npB7Rev9lqGf/DCIlzZtmZDRQrHm1hMH4dyNWm4mohFJtPdn/dsvSNvZaaPA13TK6SZMuSFTHRuny3xMi9S/21Jd/JrLJvY3OzJcpexvv0bDoGrhAAMsZ+/566J6+43eGXpL34VtX8HLgdIKMVu3d3QCgH8/PDlRatHW4ayaNTZjOIMfZ7XhlbNAh5FimZzHf/ZXRzTxvypKus6047uWXdB4t9l6i5AuPCsB5Jl+siFd/g3ga7mRldbTvj5FDx4NUeC7yM36/Fm7GXSzcqPGOPmXA6sQhbMzcw7Irzwo+AVUSU6kRyOdb5wuUYSvNz24oNFW0yxUwWXP3EmN0njtFn8FlI5CzIkJkr1aK9k+Ej5CuZt5DFSydYUR8EqjL9FyO6H0VgIXcx/J8Vdq62lBHBgG2FoRWI+GTjYrQI1bp7Gsg1vfB/lbVyd+VwJFlHFsXkS2X5JGUyljvzUf1lmQx+DrN2ak2PDdanU4oB1dxExSd6OgcNGM6xOb6Eps+08KlwQ/zHk1kFpSYjtRbQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(336012)(70206006)(356005)(5660300002)(26005)(70586007)(86362001)(186003)(16526019)(63370400001)(7636003)(426003)(508600001)(63350400001)(6636002)(6862004)(83380400001)(36860700001)(82310400003)(47076005)(33716001)(8676002)(54906003)(316002)(8936002)(2906002)(9686003)(7416002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2021 09:04:29.6482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a625d7d4-80b8-44ca-fa7d-08d98b03cd70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0247
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 03:57:36PM -0300, Jason Gunthorpe wrote:
> On Fri, Oct 08, 2021 at 03:24:26PM +0300, Mark Zhang wrote:
> > 
> > Aharon Landau (12):
> >   net/mlx5: Add ifc bits to support optional counters
> >   net/mlx5: Add priorities for counters in RDMA namespaces
> >   RDMA/counter: Add a descriptor in struct rdma_hw_stats
> >   RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
> >   RDMA/counter: Add optional counter support
> >   RDMA/nldev: Add support to get status of all counters
> >   RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
> >   RDMA/nldev: Allow optional-counter status configuration through RDMA
> >     netlink
> >   RDMA/mlx5: Support optional counters in hw_stats initialization
> >   RDMA/mlx5: Add steering support in optional flow counters
> >   RDMA/mlx5: Add modify_op_stat() support
> >   RDMA/mlx5: Add optional counter support in get_hw_stats callback
> > 
> > Mark Zhang (1):
> >   RDMA/core: Add a helper API rdma_free_hw_stats_struct
> 
> This seems fine now, please update the shared branch

Thanks, applied

b8dfed636fc6 net/mlx5: Add priorities for counters in RDMA namespaces
8208461d3912 net/mlx5: Add ifc bits to support optional counters

> 
> Jason
