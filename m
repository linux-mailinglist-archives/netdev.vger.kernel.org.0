Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566773DAB18
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 20:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhG2SkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 14:40:11 -0400
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:42400
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229614AbhG2SkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 14:40:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2Spd5spO6XPm3UV3PQYFm6q0g6bm9fGKZb3rzk+QrGPGs4mUYSNT8HPFym8Gdxb2adw5Vb5xvMerBLfgttgedm1WN87yi/j6NzyinnoN4osj1chVDnUOlQHW1X4TiaXoIxjVZJL7+DCkNXg/eE+Ox/kFuMRbGQ07oF5HUBESfwq1W1zxLStyyAXnA4/ZjdozXGCxYf70cALdnaWil3qLq2Cwbar8mhFHauevGxRc8oHBW4TZ/EtAGNk/bd3/1a9uDRXIWl9h4TxREUCVNlqR9ILnnqbwTCuwU4ZYlJkSMQrByjK0Q02JMq7syS+2mkaaQAqHW4mmNQeOOSMzCKVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbnm3X38c+TpzMcRtQqAGSYhV5CAkgf+TsHuTPVjHwc=;
 b=Pcrysm6d4xDOSsiDbzinIZjDr+RAtG7iAAUXrAsXLP4iQ5h9FBR0cOpUqqOm6bxAw5OMyfTGwSq0WtG4skhVPfOT5skIpKp1MzoicoAcrZ5UlnE8rfVgCdV7Pu7NWuvbfo2UgFHT2WN977qjtP1beRNojohctPWmcMoICstEO46pS8tadup+CrB9qoKYQsBVABuC7iZWI+FWlnYG/cx84yF1FcToLYbmzQEi3ksndzJv6q3pJaeVlNxHjHv2LcQiqmvc8bgo9cm6DSRILJakN2GXQ9FA/+Yoo5oektdtDdpeZXCEwfu1OMUimYa5Z3cEyPxur5KTd3qpCjvfo21gmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbnm3X38c+TpzMcRtQqAGSYhV5CAkgf+TsHuTPVjHwc=;
 b=M6RwMbw3rBiPiHDXAykcey2ZScyogoQqTmQiMhLKIRtQjbukW0/TBrr6X2BRQdF1fjSYLe7R7TBaew4ZJniqv5fKroGw4AJJJ8udMqkPcPESuLh05XLUE0ovb3wCM7g5uYzr3VF1r/v+yWK/vDTwhyg/6BZHZEbNccD0e1f46/8O0TFi/qj1U+Y0DezgPt8rwFQMyLCvzEFYrWT9SIAptYXuX5W3w8m0bgV/NJi+QJHVPcbx89qwMTLQL7mDP7wcdEGzMqNNgcCWeMFi+z1tpQIWV2+k2orkZPpfz2meO9LCBHSibZkazfUdNOHa842bLqcSl6A2M3Pt5HlR0lrZxw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Thu, 29 Jul
 2021 18:40:04 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4373.022; Thu, 29 Jul 2021
 18:40:04 +0000
Date:   Thu, 29 Jul 2021 15:39:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH mlx5-next 2/5] RDMA/mlx5: Move struct mlx5_core_mkey to
 mlx5_ib
Message-ID: <20210729183952.GA2408484@nvidia.com>
References: <cover.1624362290.git.leonro@nvidia.com>
 <db1e0478b61de2a051be2454065d41fd6c27a0d8.1624362290.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db1e0478b61de2a051be2454065d41fd6c27a0d8.1624362290.git.leonro@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0289.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by SJ0PR03CA0289.namprd03.prod.outlook.com (2603:10b6:a03:39e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 18:40:03 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m9Awi-00APZq-HZ; Thu, 29 Jul 2021 15:39:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b27cbd3-ea78-46fa-8bf3-08d952c0472f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5336890F05591B7BF8B7DBE4C2EB9@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXucq33rFDPJgWkzl2oTpEniH0tIOsh9kfGi4+Qm+zShdmpEr3zAjnh1g/yGq8Cj8fkAZ1L+sV15bb0ejzmP4lsSaR4RyBqG2064fr4M3M220d9JrFfamYsKcCuPf3xkrXVKTlrCeY+zXOq2l/JpWPYBEO3hc/XoXQjOf0ChDnSs9aKVPcEKG4PRJH60LnhZs7lm5XunMvM3RSTGyfm4xwjK3DpYOytOv8iYJ9pIE7R1uERSZrJ0sVKkUXs/PwJWzIXKpZ//kQnzYBq262RMdVnrRQnzxQxAnv1lzB7vJgLrx7zoOyGYQYXmbYOcBnrG8f1Sm1Yck+qhlvEnnaS8pPpgTRpnKmtbcaUanUfsmYdefj3fJaG5/zM9G8vtkSfeUqwPVJ3mGmcr9SOVQX+ZqfJDVZ/5gzBpcOKrdP3sX8nbVBxrEqedemrO2lubapdulzgrcX9eXUy1FgkbyAztece+h9o6cfBU4FQnTHKCAUcmVjKjBedn3NFZlp6j8a4ey38PPY7sxhca4soQQNJ3JWNcg2ufqxneiJoHDn75zo448tcOAteTpCywj05RD5hQ3tVAQmNKwc02r4r/WOLbHO4DzoXg4Sz2o1AASyjQupc/xHvD6B48Ayvvzw7VfbIZkJ0wuEV0wak5CUWZQIWT/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(5660300002)(316002)(86362001)(2616005)(83380400001)(33656002)(1076003)(426003)(6916009)(4326008)(186003)(54906003)(26005)(8676002)(2906002)(478600001)(66556008)(38100700002)(36756003)(9746002)(9786002)(66946007)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rxEZgAJIl5ObVFhYD6uh6we6gSlGtuV46RSmdAF+5fB960uL/DeJ2a/mzbGy?=
 =?us-ascii?Q?4uhOzbiS3b7uUT0GpwFTUUaRyASEMWy5iLjZ5CGw9j/iADNDo38Dk4SdAxaz?=
 =?us-ascii?Q?qETifGD5fmvatG/SLyxbIAvtft/5rBFNllKX6WVMphpk9/qid4yoWH4CjS4S?=
 =?us-ascii?Q?bTbryQARgMuj++CijLBcnobmAiam8p4D/m8jOakirx8YFyIoGXNpNj7SMpOX?=
 =?us-ascii?Q?Ijg54Re31lBy3opVPMTWrqkb32v7gjr29zUUmDr+NfAC5nTiaI3xVKRbcrWK?=
 =?us-ascii?Q?hSGea52JXHNsp1+iI/a1JG+R3v8IAnoNaUDW5R0mrMLkYtQ6LKqTBY2bDu28?=
 =?us-ascii?Q?dD0/jYV6b75d6KNc12Iqc8sEsmwW8O4h/ssj1EXxBXPGRYbZG4v6V4Lz9mHS?=
 =?us-ascii?Q?i7IPaKrh8GgtAU8/5RcZsFmYtEAuNM6Nx6vp0BJ78ZqWMZjv9wvH6GdeK8bz?=
 =?us-ascii?Q?7B6JiR2Q1hwg+QRIagBoD3X0jUMBgC5ricEePWfcxWfYxrlBadin7tawuFXc?=
 =?us-ascii?Q?ZETxBSTqopGWkFPxbg1ZBEKD2e5Ei9sP1X+8BZ8yVMkdZQjF9ABuX8G10gF7?=
 =?us-ascii?Q?T8+YZxBAdYcccDI3He1QGhNN0eyMhpqXQSNoPuCdyg/SWq5dsgYWDntWJ2hV?=
 =?us-ascii?Q?3k1fgx9ZBy1S71CEQOo0Jx3a3IjDXPJH5MbkSB4DNS+Pa4GNr7HR9qSWzzxG?=
 =?us-ascii?Q?i4dr31AAKZmhDSV3gQNliYRznuXKPsKsvW8RphsESP1KLML2BqAM0uQ08Vbe?=
 =?us-ascii?Q?/MGKcXW66nW6dp9tmGs2c+gDZWCdnanvlCLLuMJWvjm4VzDqz3D4fwYdccZ6?=
 =?us-ascii?Q?3oWx6JuJVI6EAHHojgBb0G4adaMZziHjw1czITBRknNzAf6oF7nRNDW/iYjf?=
 =?us-ascii?Q?PqCtuXgemoTqkI+isx+bH5MJMhK5LFsSctFoaktK8+/f+YzbEgD+7s586JbH?=
 =?us-ascii?Q?KgCQGqUEdiJfWF+5XqDrNTvdQhCTzHDyc+yKtzVUK9VpyFjgBcgIOi8StxVV?=
 =?us-ascii?Q?dnV6zUtwF0KJSgU+46wsKGEkeUB5o1p6Owv0hgxyGXzimYij2ed5TZ4s/U1H?=
 =?us-ascii?Q?QjhOL5LAI6PY2QVAuUJzKCcUWnheFCB0SVACjhQJoNSIytRmdwX0RaUfTkWg?=
 =?us-ascii?Q?8Yt7y+DBsXXl0F+AKLPTmbF5YuzjUzIY53Y3wQ2OWWTU+8cuCPa+9yLvFViQ?=
 =?us-ascii?Q?XRdzf2NkFW6dRWlaPr24VoDOKc91WO8E/mWrULpoawTOdcq/hX/02XVuC/ES?=
 =?us-ascii?Q?+IDErY2GXpYSZ4Hk6gtddMglfUTZWih4ANHK2z+zNW3EIBvIs5IuC2H+xar6?=
 =?us-ascii?Q?8/qsb9EMGMw5Mr+Twzp89hIH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b27cbd3-ea78-46fa-8bf3-08d952c0472f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 18:40:03.9764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGKS6d7R6p/mzm+9zM7qD00/I+jiZ51c7YXVkGhBhrLYsXQRF3kTrhp7aOImshIZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 03:08:20PM +0300, Leon Romanovsky wrote:

> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index 7bb35a3d8004..af11a0d8ebc0 100644
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -634,9 +634,19 @@ struct mlx5_user_mmap_entry {
>  #define mlx5_update_odp_stats(mr, counter_name, value)		\
>  	atomic64_add(value, &((mr)->odp_stats.counter_name))
>  
> +struct mlx5r_mkey {

Not mlx5_ib_mkey? mlx5_ib_odp_mkey might capture the intention of
what this is actually for.

> +	u64			iova;

IOVA is already stored in ib_mr->iova, no need to duplicate it here.

> +	u64			size;

Only one place reads size in mlx5_ib_create_xlt_wr(), and it can be
mr->ibmr.length, so delete size

> +	u32			key;
> +	u32			pd;

Lots of places write to this but nothing reads it, delete it.

> +	u32			type;

Please drop the horizontal spacing

type should be a proper enum not u32 and the values should be moved
out of driver.h as well.

ndescs should probably be added here instead of in the containing
structs since ODP needs it generically.

This patch and the one before are a good cleanup on their own so they
can get applied when they are fixed up enough. Each of the above
changes to remove fields in the mlx5r_mkey struct should be single
patches so this will little series will grow two more patches.

Jason
