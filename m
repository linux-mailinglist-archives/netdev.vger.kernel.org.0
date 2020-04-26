Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A591B8D7A
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 09:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgDZHhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 03:37:55 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:6374
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726113AbgDZHhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 03:37:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FwvevAsvAoy3uVj3omBH6pLSkZjShdX81wSl2v+XXLBraj5K6taFmhmQFG4T6nzE1MvzB2rilWdUi/bq3060jBUhF2Y62FzlDXUgG4i4BrIxdDfoPfv0waTIE2L6M7fYxLvV2bRvjo27g+D/6hHyPh/r/HjwhOUjlGc4+WZZxKAiYW3/g54Agx93vYyaJdi2CSIOYrzpYY6YpeJAFMj6iNJ/C3+z0ThdIJKjPJDgch7WWNRTTYCjGxnOsgLoEUQUknu1LAJXCifNuis5dQIo8azvmXkJxSbio84fWO1IfJmywXfnkBhVAoogsirePAAFOmoEO8O4tED6gsJRHSw3ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XbyFzZy5BmsH1AjGOdS7LeDOltmGh9Ym4DTW4TOQ6k=;
 b=P5ZYDOFuZiWA7pekddG7F4pC4Hrvp/xdknWPQZHxUulN0RdMuhANPZOxEizb/dbaWdBvngPvhIm/6B7BnWIZwZc9Y6QRREzWTfSUkfloR8MSw6v30xkXsBqcVk8Bo4eX4kXPN6U2qkbkx9ZuZopD6qAAxe+02rd2vLxG1bfsFE7sfIRC5rA1qeTCi+yM6dC1CVXp+sCIWL+l2xqYuTJZ40Y8rU+26jQ9Xp8FeEeX8VsqbFwMbu/JZu/oab2Y2YpggtYCv6AqMGv/194+lpPMWJD8958J6a7j6sbODIo6bqRulrr6MYg0eNPtjpr2tOfFNH/1ZQFjF1qzPgYvaIXgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XbyFzZy5BmsH1AjGOdS7LeDOltmGh9Ym4DTW4TOQ6k=;
 b=PWA028bHRCjMS/dnBBqmbh6yq/uB/SlG4rsCmqFsipfZu/3TNpeHV6aEbtzpqaZyLa/+rI61aoBPOHfnLUy5SWo40HYX+aHAmMv3owAKXxeso3j0+F5Dx9vHhAPWU+6kOTgKLaojKjHtto1Vt4qQjM51LYmbEJoSLABICNq1vtU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maorg@mellanox.com; 
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB5314.eurprd05.prod.outlook.com (2603:10a6:208:f0::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Sun, 26 Apr
 2020 07:37:49 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 07:37:49 +0000
Subject: Re: [PATCH 00/16] Add support to get xmit slave
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200426071717.17088-1-maorg@mellanox.com>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <2ea77cab-bb0b-cade-9897-8b42121f721c@mellanox.com>
Date:   Sun, 26 Apr 2020 10:37:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200426071717.17088-1-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0902CA0006.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::16) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.4] (89.138.210.166) by AM4PR0902CA0006.eurprd09.prod.outlook.com (2603:10a6:200:9b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Sun, 26 Apr 2020 07:37:47 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49a2cd4d-029f-49c5-d3a0-08d7e9b4b83a
X-MS-TrafficTypeDiagnostic: AM0PR05MB5314:|AM0PR05MB5314:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB53146E7D631DFAD4C61ED15BD3AE0@AM0PR05MB5314.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 03853D523D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(2616005)(31686004)(16526019)(186003)(5660300002)(26005)(66946007)(8936002)(36756003)(316002)(107886003)(81156014)(52116002)(4326008)(53546011)(478600001)(66556008)(6486002)(956004)(8676002)(31696002)(16576012)(66476007)(966005)(86362001)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jhag+1bdchCWHJCzMNYmDwQgZpSL1lmXm1hh2fSXBya5LVih5xSjmoQ/ctXwk9yXNjHlUZa6/b4b4DMuHDry6mBkzPxRQWghsqO+EqtR+pCqEYJDj0oqSZLQ+YdDvBDNE1DHu5iWUQvrrHbbMirOBQpX2yPUKhj7N1vJPV1HMmKrYCcBR5DvsRd5OtoBRRtDarPHyL1T5KptXAAS4cYAHKEOQ0WzhilVNYnG/Zsiq8eJBHLctoBLLDJQDLOFPiMai9Jc4F0L1AbAKFaOmOGnkFRDv6S0OGftgcBJCERL7b3BZq6L/Uut8qXfFDRRZI3jXrsYw/nsmh/sgYaxyrCAjmFvP4JOekIqggoIGcJdmTtBIUzQaMdAOSm61vnaAFeADsgeWDrJ2HjDMtwrE88Z77PdgVz3p/+jW1ph3wvhI+er8NJWr3ZD3Y7r9zZYQfciqrrfL36cSjFap+BWnBeL4TTdTnqAEJ78AsGbVC1y9gkQ7Im5K47HcjYStTOeNBzldeDOXg0IlhU9lOb7m/I5Q==
X-MS-Exchange-AntiSpam-MessageData: fRSpDzEzngPeUdRg2zE9Kv/z8mos14M0OgFnMdcjZWh2NFe+8FDCCCTranGmFKOjBBOL1RuSosvO3eije8jJ+LPVKyPFWJ3yBM2DQBLFjkrGPd4Lk2pE7iwk7xnSQ0N57V4weAAhKv0+1D4ZH6wgstxFVwwQXMg7fLHNuoBAEumko8707x5H7cyqpq2/m2gkNfhM9CqrgVo0EIafSiVM6HtmijQFtaRaY3dFRC2/GOqlf3nU58ziG/VZOwX6PT+KhBifPe7YUwTkENcJTVT/9B3wxH2b+GHtkEMJ+ABOABqTXOlbbj2pAx37mcaDK9LBIuPiMXFnbEJygoFeo27OYFZalaNDUvMRGSkwX7BhaoEIDi/Q2M2AqzXn0QJ+z3nDdv57s77CR/0eKxnfrmmccgWeO4Ko44WJR34n582jEr2j6UeDFcXzapD2/fjLoskctnpKfq7C3ych0mjAHa68EOyTr80ZgI/yaojO12E+Gbj1A2P8eVw73BAnAUupWSq/SlgewsjkbMVmT7Nw0ioHAT8JPfw9Qr0D3lY5IC2g09Qq78tT/N4llRS++PWYedSbHrkAPLBOWVv6oahBebS2WY99cNC9sUbxhYY1FVJYeWRGQjyfJrOheurIX2ZBaqRvmH44exhq6R37s69nLrtxW3L665vRArGkmmyHJPD2x8CPNBMK6DEGBUpBcw4N3EidsQhdz2SEcE5SvfHvRXkqkQgPHCrXcywLhnyMa1yzt/3irjgzNdZMaQieJ+QnC1JjfXd2iB3fnExIeKZZDXc/SVOh+0Wjfu+7GHNofvv1dsU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a2cd4d-029f-49c5-d3a0-08d7e9b4b83a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2020 07:37:49.3391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mdp9llwmFgJvwq+f2jZyn+5hZHOyP8IxlMM/4WMpoqTtrLZrS7HYJd4ViZ6OCMEPOtG63AbGeJo4Okk62VceCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is V6 and should have mlx5-next in the title (all the other patches 
have it).

On 4/26/2020 10:17 AM, Maor Gottlieb wrote:
> Hi Dave,
>
> This series is a combination of netdev and RDMA, so in order to avoid
> conflicts, we would like to ask you to route this series through
> mlx5-next shared branch. It is based on v5.7-rc1 tag.
>
> ---------------------------------------------------------------------
>
> The following series adds support to get the LAG master xmit slave by
> introducing new .ndo - ndo_get_xmit_slave. Every LAG module can
> implement it and it first implemented in the bond driver.
> This is follow-up to the RFC discussion [1].
>
> The main motivation for doing this is for drivers that offload part
> of the LAG functionality. For example, Mellanox Connect-X hardware
> implements RoCE LAG which selects the TX affinity when the resources
> are created and port is remapped when it goes down.
>
> The first part of this patchset introduces the new .ndo and add the
> support to the bonding module.
>
> The second part adds support to get the RoCE LAG xmit slave by building
> skb of the RoCE packet based on the AH attributes and call to the new
> .ndo.
>
> The third part change the mlx5 driver driver to set the QP's affinity
> port according to the slave which found by the .ndo.
>
> Thanks
>
> [1]
> https://lore.kernel.org/netdev/20200126132126.9981-1-maorg@xxxxxxxxxxxx/
>
> Change log:
> v6: patch 1 - Fix commit message and add function description.
>      patch 10 - Keep udata as function argument.
> v5: patch 1 - Remove rcu lock.
>      patch 10 - Refactor patch that group the AH attributes in struct.
>      patch 11 - call the ndo while holding the rcu and initialize xmit_slave.
>      patch 12 - Store the xmit slave in rdma_ah_init_attr and qp_attr.
>
> v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and move
> the implementation to dev.c
>      2. Remove unnecessary check of NULL pointer.
>      3. Fix typo.
> v3: 1. Move master_get_xmit_slave to netdevice.h and change the flags
> arg.
> to bool.
>      2. Split helper functions commit to multiple commits for each bond
> mode.
>      3. Extract refcotring changes to seperate commits.
> v2: The first patch wasn't sent in v1.
> v1:
> https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@xxxxxxxxx/T/#t
>
> Maor Gottlieb (16):
>    net/core: Introduce netdev_get_xmit_slave
>    bonding: Export skip slave logic to function
>    bonding: Rename slave_arr to usable_slaves
>    bonding/alb: Add helper functions to get the xmit slave
>    bonding: Add helper function to get the xmit slave based on hash
>    bonding: Add helper function to get the xmit slave in rr mode
>    bonding: Add function to get the xmit slave in active-backup mode
>    bonding: Add array of all slaves
>    bonding: Implement ndo_get_xmit_slave
>    RDMA: Group create AH arguments in struct
>    RDMA/core: Add LAG functionality
>    RDMA/core: Get xmit slave for LAG
>    net/mlx5: Change lag mutex lock to spin lock
>    net/mlx5: Add support to get lag physical port
>    RDMA/mlx5: Refactor affinity related code
>    RDMA/mlx5: Set lag tx affinity according to slave
>
>   drivers/infiniband/core/Makefile              |   2 +-
>   drivers/infiniband/core/lag.c                 | 141 +++++++++
>   drivers/infiniband/core/verbs.c               |  58 ++--
>   drivers/infiniband/hw/bnxt_re/ib_verbs.c      |   8 +-
>   drivers/infiniband/hw/bnxt_re/ib_verbs.h      |   2 +-
>   drivers/infiniband/hw/efa/efa.h               |   3 +-
>   drivers/infiniband/hw/efa/efa_verbs.c         |   6 +-
>   drivers/infiniband/hw/hns/hns_roce_ah.c       |   5 +-
>   drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
>   drivers/infiniband/hw/mlx4/ah.c               |  11 +-
>   drivers/infiniband/hw/mlx4/mlx4_ib.h          |   2 +-
>   drivers/infiniband/hw/mlx5/ah.c               |  14 +-
>   drivers/infiniband/hw/mlx5/gsi.c              |  34 ++-
>   drivers/infiniband/hw/mlx5/main.c             |   2 +
>   drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +-
>   drivers/infiniband/hw/mlx5/qp.c               | 122 +++++---
>   drivers/infiniband/hw/mthca/mthca_provider.c  |   9 +-
>   drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |   3 +-
>   drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |   2 +-
>   drivers/infiniband/hw/qedr/verbs.c            |   4 +-
>   drivers/infiniband/hw/qedr/verbs.h            |   2 +-
>   .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |   5 +-
>   .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |   2 +-
>   drivers/infiniband/sw/rdmavt/ah.c             |  11 +-
>   drivers/infiniband/sw/rdmavt/ah.h             |   4 +-
>   drivers/infiniband/sw/rxe/rxe_verbs.c         |   9 +-
>   drivers/net/bonding/bond_alb.c                |  39 ++-
>   drivers/net/bonding/bond_main.c               | 268 +++++++++++++-----
>   drivers/net/ethernet/mellanox/mlx5/core/lag.c |  66 +++--
>   include/linux/mlx5/driver.h                   |   2 +
>   include/linux/mlx5/mlx5_ifc.h                 |   4 +-
>   include/linux/mlx5/qp.h                       |   2 +
>   include/linux/netdevice.h                     |  12 +
>   include/net/bond_alb.h                        |   4 +
>   include/net/bonding.h                         |   3 +-
>   include/rdma/ib_verbs.h                       |  12 +-
>   include/rdma/lag.h                            |  23 ++
>   net/core/dev.c                                |  22 ++
>   38 files changed, 696 insertions(+), 229 deletions(-)
>   create mode 100644 drivers/infiniband/core/lag.c
>   create mode 100644 include/rdma/lag.h
>
