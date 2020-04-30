Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFC91C06B3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgD3TqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:46:12 -0400
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:43586
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgD3TqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EYBLBsoPyX5AmbG4EQQJPtkmSDNZr+u4qSbzHVPZB0Pi4jesJDSZ66IXik2gYvHFv1SYXPZYmqlKd5vMVFG6AAFwrq8kRLJdlHp7O1zwJx8dUFnN2l0i+TtcRMaRJoTLN19z4QyIZhJujxKYeSl6cKzVqfuXpF9SH7C63qjxPRuXzNWrJUaMej0xNs7yRwzMVWNVuCzjX9XO5qfC3FIdCDZpe2FJ5FR2aLjEijqIM07v5QWH4yb/JCU48sOhN0z3hd1Lf7tEDFh+fClqPXH626vuSEnu+JrhLfSK5Z0MRplmnETNiqIYo++fKhOyXOs8h+2R624ZPJLvRjybhHUr0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3a4f/PklHx3YB1cKK6P/gaCCSpiXKkGHat4/auPonek=;
 b=L3zYfX5jt34xtzSyznp1zL/ccc5DqyVhG/4bdEnEmLjrfFraaLVkFNbS36pvxPS8CinlN/Rs3dzMWRpagisYdAomcl9I3zBtO227oXnhLx0PbssOt8aznLy/fE9IQ8buWHvG4tdQCTPoTjBwrbTgW7PoS+fif0F/0yOmctb7+wNGeQcBVUGXKVrgOxDdR3GGcCsyI/S3vlYdFPqXgdu9zuiFtFBYHkZjYTEz02LGHX+bRbZi2Jaso979UCzDhVA567YY6tbGfLx0SUJvIBDb0By8yNbdh1uJUc+XgbeJ7O0ibt+TuHh6AhDbY7XwWLAA+8S/o+SvLaH5IG/NxTvaNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3a4f/PklHx3YB1cKK6P/gaCCSpiXKkGHat4/auPonek=;
 b=SjxuPKAw3JkM07P+S8pdQfbzX0sqk/lwCSWtWNhn+aNAMyNPe+y2dOjGxbv6VUtEbLzyz4rOFmu6LenY2bM25bnY32+sGagm5uLkWXg6QgMVomms8sc9u69s8w3G5th54uBX2OGdfp1PF1TQl9naI6ALIfo/FSife3CSRURpD+I=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com (2603:10a6:208:125::25)
 by AM0PR05MB5986.eurprd05.prod.outlook.com (2603:10a6:208:125::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Thu, 30 Apr
 2020 19:46:06 +0000
Received: from AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41]) by AM0PR05MB5873.eurprd05.prod.outlook.com
 ([fe80::3401:44fa:caa1:8d41%6]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 19:46:05 +0000
Subject: Re: [PATCH V7 mlx5-next 00/16] Add support to get xmit slave
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
References: <20200430185033.11476-1-maorg@mellanox.com>
From:   Maor Gottlieb <maorg@mellanox.com>
Message-ID: <5cc8aa98-3457-dbc5-56d6-88dadcd49e46@mellanox.com>
Date:   Thu, 30 Apr 2020 22:45:46 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200430185033.11476-1-maorg@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0039.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::19) To AM0PR05MB5873.eurprd05.prod.outlook.com
 (2603:10a6:208:125::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.100.102.8] (89.138.210.166) by AM0PR10CA0039.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 19:45:56 +0000
X-Originating-IP: [89.138.210.166]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9dba3105-4264-4e68-862f-08d7ed3f1f11
X-MS-TrafficTypeDiagnostic: AM0PR05MB5986:|AM0PR05MB5986:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB5986D82A0514D7FEF66BDBCAD3AA0@AM0PR05MB5986.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5873.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(16576012)(316002)(6486002)(5660300002)(66946007)(31696002)(86362001)(956004)(31686004)(66476007)(2616005)(186003)(16526019)(66556008)(53546011)(8936002)(966005)(52116002)(8676002)(2906002)(478600001)(107886003)(6666004)(36756003)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qO3tDyoipOCrLW1H+Vbo6AQXQKcm1DZLm2UEaK8qs2HzgrSYeJnlbrTKUzdLetr52fgKXEIPf3uiEDnyiR4ARtsbCR+eXWjAdEGN50lYU30Dqh150qWJcaife1p3MN/eC1VAL+N5LBZEN2IR7LTB0k4HLKECbfgh9B5C/KwfyhLMBR2IzKZjTuHswvQOmlmpOk1xbsUp73gVTZFkZF+G9dDOIRHlU7YBgvTxngVl8gWArHf6QqjChmjbbJq8YJg86cvCyeew63U+UAaGv9js5f0Jwoga0OQampQH08CaEcNX5s/0i+RbAULfy7A+F0AAnV81VDqw5PlKT5jI1/vENxSJgtjhdT1ponbpKhu9aXEIDF4PvRfiUSPvplRFz1oOa+vpRE0vGs8ZMvBQc3U21iGE0Mu7Ua7yDzkZ6jKDQRg2+vQzgchHts51DkW8hn3GU3cvWQA52rbiJJ5cEBFKUKKQwVaVB+2XM3N7/Qvpfrc1q8y11VHwi0QcQg1fyDB8iVzV2CHfO0qzjHM/2CCX3g==
X-MS-Exchange-AntiSpam-MessageData: kfwWBbfz6yc4ETHCeY7nQ6Ca4u6maPLAUPVM4Gdd5po50opUMfolwA6C5XzGg3Bb3PnrEOpdJoUgL65oG7xVQAtu1AbtKwDvgmTD80Bi3DD2KQVuZYid/j9f1x5bOiDmXN2MCPMkJ1cvxQkgv3LTeVBr6NmJI/Am3RMhuvlFfASN4dGgxkNjuqnfwsVkr7z87tLbk5x5b0RLmMgUuGiYyEqWCUVcS5U2G+JK6Apdvy9kQZr/qFqBJdhMcOEIPiKpkf9j+WvgQWT1Y4bUbRbx0Xrj1vyeuZz9biNuCMU//68NcWZfVO6NKtTEPaBHnHuch6VAtXy3XM86ViPSR84f3J40jhk4n0dtHr/IA9RLuE8tuBr6A9vRzqOVGAtcF23QllLb0aGTBNOmE9JI+ToZO3bp54nns/jQ2YUGsvQS3aGw9jWXihx40zyPdt0vukSvjFSnvvxC0jzoMisZpgWfFKn0H+6vLSPHMARNR5kZzNN6pJBQTGn89Yd8Vmzauw9kR4ho1gooRsjuHN92tFyPfz+/XTBxNn5R2uXFgP01UZj6rYoFLjkQCVJJ0HLXxQ1jNrmZOwmAOppVzoBS5f1IFnl0DCvOK7paWzmtDHVF6QrQFrqL/P8OjVvc6CM/AC8WDaBHnKPpiqtdxw7Y4Zt6J8iCChWz/0+Z4UvL0IdXbGBURi4WmFx/WaoqCuh4DiTitNQJZRBGhAVx/Ug4UxZK3aYFOQehJdze19UN8gjAwjRTRmCA6tQM+T+IRuqX3rUo4t1Dmv5+x6DcurWgw6nU4IkJ9UY6eE4Jk9hgutGY4H8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dba3105-4264-4e68-862f-08d7ed3f1f11
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 19:46:05.7728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jCTFUBiZxWZVGMlbrCi4oWYfp0seiFtVLok9ZbYzVaAui13GzXDoJ/Xy7EMawWhYrNiBIIOfr14kEZBucyVGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5986
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this version, there was a problem with the indexing.
I just sent V8.

On 4/30/2020 9:50 PM, Maor Gottlieb wrote:
> Hi Dave,
>
> This series is a combination of netdev and RDMA, so in order to avoid
> conflicts, we would like to ask you to route this series through
> mlx5-next shared branch. It is based on v5.7-rc2 tag.
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
> v7: Change only in RDMA part:
> 	- return slave and as output
> 	- Don't hold lock while allocating skb.
>      In addition, reorder patches, so mlx5 patches are before RDMA.
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
>    net/mlx5: Change lag mutex lock to spin lock
>    net/mlx5: Add support to get lag physical port
>    RDMA: Group create AH arguments in struct
>    RDMA/core: Add LAG functionality
>    RDMA/core: Get xmit slave for LAG
>    RDMA/mlx5: Refactor affinity related code
>    RDMA/mlx5: Set lag tx affinity according to slave
>
>   drivers/infiniband/core/Makefile              |   2 +-
>   drivers/infiniband/core/lag.c                 | 136 +++++++++
>   drivers/infiniband/core/verbs.c               |  66 +++--
>   drivers/infiniband/hw/bnxt_re/ib_verbs.c      |   8 +-
>   drivers/infiniband/hw/bnxt_re/ib_verbs.h      |   2 +-
>   drivers/infiniband/hw/efa/efa.h               |   3 +-
>   drivers/infiniband/hw/efa/efa_verbs.c         |   6 +-
>   drivers/infiniband/hw/hns/hns_roce_ah.c       |   5 +-
>   drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
>   drivers/infiniband/hw/mlx4/ah.c               |  11 +-
>   drivers/infiniband/hw/mlx4/mlx4_ib.h          |   2 +-
>   drivers/infiniband/hw/mlx5/ah.c               |  14 +-
>   drivers/infiniband/hw/mlx5/gsi.c              |  33 ++-
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
>   38 files changed, 696 insertions(+), 231 deletions(-)
>   create mode 100644 drivers/infiniband/core/lag.c
>   create mode 100644 include/rdma/lag.h
>
