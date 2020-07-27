Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A9622F373
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbgG0PGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 11:06:25 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:54413
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730328AbgG0PGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 11:06:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpVim/H4x5Qd2o3edEAscT8Ytf/1jSlnWQ8YhgylGWgLz4BMQNfxb/MDJGLSDrrAvj6Elx3eE5NJuSIK5GktZCoxaFNuisULVV1Pn3LInmkKaD13lGEo4o17GGTFz7XsayzMvHGmLQqDBL0KXLy4x+l1UIIcEZa+rfvirAwNwbRDvcDO3RcVCm5ZTOlBFyqlxdJJjzmG7QafxJqRNZaf4rn1msW12dgUGi9XBUSiMDWO2sQ4t65+Rcy1BwpQgayc6pLyahEVQOYOOC4kFeSQEg+ywT67rLT8Jbjmh0RQbU0u1dMODpegs45ab/5CNPR4r/DVVkMp5AA5vySv3hFlTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LefzLN/lTdhNLgP73kGhXX3G3DE9qcqJFEpFf3RXiWc=;
 b=hoQxlRdt9UqXEjY32+viITQ5+22QhABUgzoJrIRDkH8jqUErZyk8k9qyuvaB4/tMQ8NWSeMe+GOI7VvvgpsO+GmiUOYQFsYWYbD/U3BFLe8c03gXZXDcrR6AXRafo1M1NSpBISu9Fq3DmcOgrSztb40GsMai6rpSSHozE/YJexPWoURZdLeFnieQWvANaUL9FUMQkdAcMk8t8i1lG2rIPj5xI7dP30VWnKHSSW0xzLAMlVReyihkDr5rjkJj+h/36u9peBvBUgQcM1DNrBCdaCh+NPT00rOgCFz17v3Cidq98Tsxxs52dDK8cOcecR0flZRkjg3tqmUWrWHdqptQDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LefzLN/lTdhNLgP73kGhXX3G3DE9qcqJFEpFf3RXiWc=;
 b=Uh9Q2Ble4fnQuMxyLH3fSjtYSzrc07D6UntwnJzOC5VSKBrXqrfTGG4iqFzx8bentVwsTsV6wadx8b0ug57Sx1DHEPNj51xPeXJ6fm0HPv9zxc5/RXwegsweDwj1MvWN+TD0oSEfIGi0k9jMrl4pLkOi8/uvH5Q0biECmW9s998=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR0501MB2285.eurprd05.prod.outlook.com (2603:10a6:800:2c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 15:06:20 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::10b0:e5f1:adab:799a%4]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 15:06:20 +0000
Date:   Mon, 27 Jul 2020 11:47:43 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@mellanox.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-next 0/3] Create UMR with relaxed ordering
Message-ID: <20200727144743.GC19097@mellanox.com>
References: <20200716105248.1423452-1-leon@kernel.org>
 <20200724193151.GA64071@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724193151.GA64071@unreal>
X-ClientProxiedBy: BL0PR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:207:3d::48) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0071.namprd02.prod.outlook.com (2603:10b6:207:3d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 15:06:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1k04Pn-000Bbg-Ha; Mon, 27 Jul 2020 11:47:43 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c8f6549-d3af-467e-d83d-08d8323e9e7a
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB228536FCFA9B2C5C06ED8816CF720@VI1PR0501MB2285.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vL4HGCDhFfD+dha5zTp3mOi5oHGIGZoSTViwMzefDYeALebe4ABLdEL0Buf8O0UeKxCt9Vq4VqX4sps1ya4a3w47vjkXFYsWtkTPxgG/JHSllG7+4ZEvzxV6dndlR/U4hV8hRW0gwZ38tig0EmLhKMlNpXFEmSwD18W+aSkQhcrWdakjblcvJxUKgJaf9fecMmM8BBkRYGMUrbxTPep1jdoa8/fo2r2FX2WbJdsMe0gxSvk5NS38SvYaTUOun64m/lGeKMV/ftV9mmZ3vIyWSo3MwaBOc6YaJZIO5d4iD+GTqD8O1QDXpn0vr1m/jOta
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(4326008)(6862004)(8676002)(6636002)(86362001)(316002)(37006003)(54906003)(107886003)(66946007)(26005)(33656002)(8936002)(5660300002)(1076003)(66556008)(66476007)(36756003)(2906002)(9746002)(9786002)(83380400001)(2616005)(426003)(478600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LtNgDOjZlE8d1eHqmK6+PQEV/F6EG1KwPi2uNYQ1LGQF4zCJcRFekLgM0RT1o5iE9KJjsFgvQ3izaudSxTe33+OnjQyC+NhBdk9v0UctKylspbyqX94X5zFQqwBE0MPn0XSoV4SvFnbW6Gz742UvT7u9E/b4QwJlzRhssS5XpJ8jKgMAwiHzfokFHyikHsUAMJBGGCWFZjn7NwJcade9yqJHN6d8+x+3Ze+rlnNrRPJKrxY6EVAmqig0We1mx/8UceY9Dy2zFEnDoOu1++znwVfJeMf+0qH4aOXSmDQ4hPmJ/nWsSg/0AHwqEgcZw8dUT1ZW0PxIFOOjLoZbNHvVy4gIyLkeC7ZRjGXzWW+dX1BMQZCodiAFTU2z6iOhKr79U0wp1giAMrsKAiaLa5UPGp108ZDl0G+uWZkGpzEYCl4HfPCRlQGsm4CBQKmDpjYzN1W/fxdD6KWPgeHmyC8es5KtPo3jVA7L7lITUBehNYA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8f6549-d3af-467e-d83d-08d8323e9e7a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 15:06:20.4635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEBSQei87ErZEQWJCblecU/lnkjQip0rvifPnU3SY2zvy9o+gzfYjuzqTc9LRB4NqzSkGfWmveyxBAE6q639Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 10:31:51PM +0300, Leon Romanovsky wrote:
> On Thu, Jul 16, 2020 at 01:52:45PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Hi,
> >
> > ConnectX-7 supports setting relaxed ordering read/write mkey attribute by UMR,
> > indicated by new HCA capabilities, so extend mlx5_ib driver to configure
> > UMR control segment based on those capabilities.
> >
> > Thanks
> >
> > Meir Lichtinger (3):
> >   RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR
> >   RDMA/mlx5: Use MLX5_SET macro instead of local structure
> >   RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7
> >
> >  drivers/infiniband/hw/mlx5/mlx5_ib.h | 18 +++-----
> >  drivers/infiniband/hw/mlx5/wr.c      | 68 ++++++++++++++++++++--------
> >  include/linux/mlx5/device.h          |  5 +-
> >  include/linux/mlx5/mlx5_ifc.h        |  4 +-
> >  4 files changed, 63 insertions(+), 32 deletions(-)
> 
> Thanks, first patch is applied to mlx5-next.
> 042dd05bddbd RDMA/mlx5: ConnectX-7 new capabilities to set relaxed ordering by UMR

Applied to for-next, thanks

Jason
