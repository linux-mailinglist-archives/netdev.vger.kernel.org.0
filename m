Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD6A41B2A7
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 17:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241516AbhI1PKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 11:10:51 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:24393
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241523AbhI1PKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 11:10:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noSfjPlvx/Mb4SBjsFJXOjJy2kdthUFcALSl+D1WYMAXpzWrAyix6sYBpNH9jEaYdcIkbdaxB5//PV5Gf4sOqkqH6BrvgiHvnIDNgyjLJAemgSMZB5a9xepih9c7pyyuaA8TNWuUj5PJBNxsVlfAGkF2QhZ+Or12z5hAS/NMGgCVUW5LhTM/dQXPiLRNgZpcFp+AmVgkmo2LGUJlGnYsehLb91/6n6t7YqGcgeYvUyaz1O6NX9cUC5eqUNwI/6yP8qe+UZu+X34iNtWKXcttJ7O+AfNPev+cebuQpVAlrZH3qsHeOmxzgQJ+1JyXLjpSTo+eaRChIsFt11U2zFZ0bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Xc9Npct+CwouhbUTULUV9EdBQeTSUc3rrmPA5gvphRo=;
 b=Zjs8OTztDvog5MbCfe+3EL+8tuMZTy+wspmgxh/aklyCLBBSJQckQpwAMPgSQ/retZPU3Oz+3REXTbQuCO8KKWtzuaUTpkSTh2Lf0dydA/cA23ymLQgclZgWFE2ovC4Q1PRkROTZ/Pi1E8fcykXuyKum+DSo6K99DQDhPdGb6MYcwmO1ntGnSTo5Kx/47gBtk5iO9GMDPQLTDJS/bl/WUXYZ+BbOxO9InmJ5nKsLc53nnLUsMdpM6G+rjt1MUEkSPvFYj07PSZ/d2q68q0JhY/s5peaWevf9O33mq8TE82Zf6rUOdz46LbI06dS6JAK8oQgvflbpW3W2akAxZVOpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xc9Npct+CwouhbUTULUV9EdBQeTSUc3rrmPA5gvphRo=;
 b=sCEymU0XU1gRfuyc5pOe71etlpoqa7QUxeX5eRAWSMrXE00AG1tfvXjnPBL0atciiUEvlsbCj42BH6uML63TCqJhpLjO0g4GOtqVqyeqMHVe07qL6jLidzv2b3DEUHuPyWw/NueScHdtwNPbMAi7eW9olEK3HCTPbAq4Xrb5Z3cPv6MpTl59Vh039OTLin934KKWgDhVWyj4V57mcMF758Ot9fjuliFfQZ6/4S52SeLVFQMvOibb+LoZI1MBljYPXAU7tWm052fdB5R0QvS1UyYyeVNJgO35Yj9LgaC3Ku4yV5y7Z1q8DV2XnZjDd8k0F1wr/7DTRqLCz4O3b4ydWg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5296.namprd12.prod.outlook.com (2603:10b6:5:39d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.13; Tue, 28 Sep 2021 15:09:05 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::3817:44ce:52ad:3c0b]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::3817:44ce:52ad:3c0b%5]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 15:09:05 +0000
Date:   Tue, 28 Sep 2021 12:09:04 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next v1 0/2] Extend UAR to have DevX UID
Message-ID: <20210928150904.GA1675481@nvidia.com>
References: <cover.1632299184.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1632299184.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0336.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::11) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0336.namprd13.prod.outlook.com (2603:10b6:208:2c6::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10 via Frontend Transport; Tue, 28 Sep 2021 15:09:05 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mVEjA-0071si-98; Tue, 28 Sep 2021 12:09:04 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1030069b-0bd8-4603-2801-08d98291e9c6
X-MS-TrafficTypeDiagnostic: DM4PR12MB5296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5296F6178DD543B7E56F55FBC2A89@DM4PR12MB5296.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tuGrO7gGpK1N2TA7Tn0WZtET74jemXzccS42PwXBSvbi4v1skWktKRq6SkVDBPU+UKSGkTjl1FDkyYKGqUP5GcjG5waIPSH3/UJgKVn/5vkt1KYVZ4LB0VhszbPv36DP44Gp+PySFhN7ezERRQKKYQSFb7YEElZgfgsaSQM7ScjIQhvdaMzwsjJHj5anNbLUix386wlW7ADEv485lrL/O4CV3j4PUgQLP5UsNmF2kkbllwu9odtyco4DgVp2NMHMZ3T82zOU7fesAxcZBq+B24DxhTxUEdWkmLzigSnvS0iiY23eH9X59d5h36F4Q3wJejsYdrfJtAUe0n3zc8cYpX/TSVVS29MgIHz/puiO7exqg1hsI2yGfSAKfDAC+YjkvgaYmNrRqaphZc0rA4WjMVCkTSRJhRzQRBXBop0XZukX0LHbSwzlJDvx4R+lR9PiAY1ev5LVKzLRxUUqpRcfJ/3COQNFcPgFXMDtKNMiw3o24VkSxjUKJzCmO9zOMLJMy6YaSZZZcd5kwXTbdREBBhtG57K80WGvsgtEOTi5F1ch0YwD3E02CF7bTgUaTKLiugEbHl6xucyJua71ZNSc3KY7R5aRETENaETHcC6YouJ9rZxeTXuPEsX+gF1syM8YF4k64oZ467t2nER9hpjk3iVbvNLkOznEvb1FX+PxYq/nno0Y6DIMmQVONX9m3UGDe2FEWXDMDiyTkhDC8tP7E8nhh+7iOJsx9oDS6nz9Fio=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(8936002)(9746002)(9786002)(2616005)(54906003)(5660300002)(186003)(86362001)(8676002)(26005)(1076003)(508600001)(107886003)(33656002)(83380400001)(4326008)(316002)(4744005)(6916009)(66556008)(66476007)(66946007)(36756003)(426003)(966005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+pkIwcaAFll+Gp0WfmVd6YGNksiaAeuw6DIunbq/F3qYe3XfdikqSv6sm1fN?=
 =?us-ascii?Q?vkRIXYDnbB6hE6qc2wHZRzvZe9LDfeyi3rRbEVm/RUv4mi6rnhjHfe29ol7y?=
 =?us-ascii?Q?HAckoche8bZUrJsbR9dQwU52SLxXnyG368Vo3xyHRN646JaRF3KoCkF8Xo21?=
 =?us-ascii?Q?R3lLvGeKMngseKIQkOYBvP2bK2dOXg0ktuMwkY/U+p9my1/eN8YHu7aBwg7a?=
 =?us-ascii?Q?BLiVJA7/YA7Csizz9mCcrkly5Q6uRgWdYLk3V0L5yoR+U5PB+t8UkrvnUKlm?=
 =?us-ascii?Q?1ToucGhOlydqui8H8ssUSuEGR7xsMkPgWayJNRBxa5y5aVlCqn9whoSzyE4Q?=
 =?us-ascii?Q?wJzNUHbEmlRcEkskmyLr8RFIzbyvLdJR29bMr5icOGDVSY0sN9jvjbdLDfPQ?=
 =?us-ascii?Q?Q7DjEcJLIz4lmwXaRlisGBpdP28nmt54WaosDTiT1dYznsR8pg84XzBJzNDg?=
 =?us-ascii?Q?6eHT/MwmEWir9W5qEyBtjhz7jULfrmC0+m35bg9b4Ob/LO0Zv4QeDGhFxKo7?=
 =?us-ascii?Q?mpxJzQF+iYDEWz+gcgOzJ/rPvrCc0Hbda/dxiih/olXtyDr4Sp0dZ5/Pl+dY?=
 =?us-ascii?Q?VxJHaCJWMkCqoFwPabBnX5XCHdjKScwpvuwEhWkmh6wrjI8qwuSu72F1VH0Z?=
 =?us-ascii?Q?oZU9jnygj0oJ39cpO1Yn4k3K+e4vO8JBxZp0SPy/q+DMWVjl7LLb2pB95phU?=
 =?us-ascii?Q?1WejCVUlv4hMaTNKOZutvrcFSwnW75EKZGEociaSLuoyNIkOLZ/I+l5OrIuM?=
 =?us-ascii?Q?2QLffd1mtywQSk3VJ3YxyuS//o/YX4u0/IhzHMKQK7nijaQQt6wWJ7RJGWNx?=
 =?us-ascii?Q?IChoKw108BkPKgzkuDzkqRUvh59HJr2owPmVoT4S0+P5TO/t6TBr3BYYe0+D?=
 =?us-ascii?Q?ELEAP35+rATV6VjnUJ8QbeD4aBIA+7SgqkacCaJBoHNYmrLW5tQI+IquplAO?=
 =?us-ascii?Q?eBzmipxPFHprrGEX4rqbWL/hMYAFx+3HKtW2WrVvLz4sI8oGNzGMOFqV6rYz?=
 =?us-ascii?Q?63yUiTLqhxrB6LzGv2hUaGXYDdpubKd26Ggv9THqyDYX40KaKsnVrmtYrLq6?=
 =?us-ascii?Q?AeE5hGedIvXHdGquQPRjEoMerchuJV/ACW5pBKZV2FDIrbOG2IyOijeXD0oT?=
 =?us-ascii?Q?1+FVDUVJEItR84DQ0BWgnNkPkDt+Ch6Zp0XmotalqtRQ/L0DkabSmK16r/Yn?=
 =?us-ascii?Q?tjdePiYHQTIGDYMa8Mvnc2eiSJHHFFZYw9y+1r0SUpOS9U9ZiKDLcPZ1VdsP?=
 =?us-ascii?Q?Y8kyiMuNXvjeVEcqBPdRWvIVa9t3FYQhyw2OVg3qF3FGvIoJeh3XOcC4Q5ue?=
 =?us-ascii?Q?ikKAFXMTtox3WZbo3nSxcViK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1030069b-0bd8-4603-2801-08d98291e9c6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 15:09:05.4876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MYx71e/jF+iv8SNRagEHvICJAxTk1ILvd5htxhTU4r6E63+Wy3SWTACTQ9cIizvs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5296
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:28:49AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * Renamed functions and unexport mlx5_core uar calls.
> v0: https://lore.kernel.org/all/cover.1631660943.git.leonro@nvidia.com
> ----------------------------------------------------------------------
>
> Hi,
> 
> This is short series from Meir that adds DevX UID to the UAR.
> 
> Thanks
> 
> Meir Lichtinger (2):
>   net/mlx5: Add uid field to UAR allocation structures
>   IB/mlx5: Enable UAR to have DevX UID
> 
>  drivers/infiniband/hw/mlx5/cmd.c              | 26 +++++++++
>  drivers/infiniband/hw/mlx5/cmd.h              |  2 +
>  drivers/infiniband/hw/mlx5/main.c             | 55 +++++++++++--------
>  drivers/net/ethernet/mellanox/mlx5/core/uar.c | 14 ++---
>  include/linux/mlx5/driver.h                   |  2 -
>  include/linux/mlx5/mlx5_ifc.h                 |  4 +-
>  6 files changed, 68 insertions(+), 35 deletions(-)

This seems fine, can you update the shared branch please

Jason
