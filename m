Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B861D0F7D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732664AbgEMKPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:15:24 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:14055
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729917AbgEMKPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 06:15:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbeBkZiIS3pPOhmBD4snEh1C7w3dUtdqFcYtt7U74lZ3WjOt0e698NNIC5cy4jhWDHd0352X4a+N5ky98WUXFqv1hVPv6iQkn5jYX8xpGVGqsEMUk5XdNy/emsHiALg4z/4i7OqSSFMNv3kacI0dk2ODqf5Egu0Y9HSt4iJNQYtetqV7nyBjPD6w651AOhPjJfJnm5qIwrV24mpPwu1+3EqJlSXptEmaJ4/xI1TyyN2MjDFVNpLSt8oIfcYMEigjkORogUXZ6Fb09vXpj2v7u5dOnoUJtw72XJiVApYDROW4RpZZNSxy/oYEFH+JfxzP1bPXr24kMpuldePWvjhGDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/nDnx50PB2F68HiL6Vu1RHFQRfuF8xSm7MX0lvzx1g=;
 b=eZynXvOLD4UEEOCB/7HtsQIoZnlyPz9oaF6GnqLoKpYyHPp9dcYNGc3RZ2+wZq0VI+BKdE4j8HAKjE318PnOWbpvaMwb27xE9UjDP8M/hh+v3ABActVnvHZcK2njKqyVPXqUcqmNlfRGJFRGThSe8yBVDVR4VMkP5272q2ea/0hKys0v8r40a7/N8bz2zQxgVpImyJe0/bSz/nfVefkFxCXt6/OsH28RV7oXnhTGSn5F+gC/9u3kluq0zuYYZ7LGq1IL49g3iB8meiL8zOTszTNOYFsxXyWrf13iSWJ0Mjp140q7vH/IW1yrKRzGi8z3KOjIiB1afLYXWyylcWvxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/nDnx50PB2F68HiL6Vu1RHFQRfuF8xSm7MX0lvzx1g=;
 b=g4WCzNEFg5//K+qdNGT1Dx2OxTqLX+j4NETL7O03DyYotq3f9K40A3uQwWZo+5mAt28VBNYP6z5DE2E9bB48CTU/3VmS6XheQ1185Z4Tp70nkNicLxHonEFFsyW7Dmos8QCkx98t1W0E5Tqyd953MUjQKA6T3TS3kjPyYYWl/gI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB6039.eurprd05.prod.outlook.com (2603:10a6:20b:ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Wed, 13 May
 2020 10:15:20 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 10:15:20 +0000
Date:   Wed, 13 May 2020 13:15:17 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Lijun Ou <oulijun@huawei.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Weihang Li <liweihang@huawei.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>
Subject: Re: [PATCH rdma-next 00/14] RAW format dumps through RDMAtool
Message-ID: <20200513101517.GV4814@unreal>
References: <20200513095034.208385-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513095034.208385-1-leon@kernel.org>
X-ClientProxiedBy: AM0PR03CA0006.eurprd03.prod.outlook.com
 (2603:10a6:208:14::19) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM0PR03CA0006.eurprd03.prod.outlook.com (2603:10a6:208:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 10:15:19 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e75a32e-fe48-431c-bd98-08d7f7268a79
X-MS-TrafficTypeDiagnostic: AM6PR05MB6039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6039A742102DDA6265D8134CB0BF0@AM6PR05MB6039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v84aOLrP2INAWOVWVD9NuzbSKNb1jQXYN7kO3KGSEnMMam7DW7NawVzF/6Tz57WdAlP4pOjdAvXM5MbHA3ySZFazcLta5rE+LXK2x9Lre2Dvopmh+RAPak8r/0skgh0jKNKBeN9EffjEAfGlOcwOS6Nly7CmXVsv7OZ4eka1zDutzzQ5xbqxqVBlU9lKdQNDV8OHXjYZW7PzjGep8AiAWM2YYbyKBzI2t74/yR1p/pgcjZBxDZjVxfgDjlY23DglYAg9d9Q6rbNW2keX6RMrChQ7db3HczZdFen/WMGHfZACx80bNePPaNuZMlU/zInnHCxOhnA6IXINbv6wxFJAO7feujAeMNOovnH+f3xMS/sJI1iB36lw7gQIYRQQTy8AdMpmGUihLrfNyc7cQ+LdAx8TgbSpEGuxDzfC5QkGFyTcurcTlFPP4+n5y9aMM+OBQ8QbH6iIXysJzJeTQ7RRHGJzM3QCa3bvX9cLfz9jEgrfRpMUp6XOr4BMAquF6Blz3ryg3gzPZL8dLtHv3DPODQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(396003)(376002)(366004)(136003)(346002)(39860400002)(33430700001)(52116002)(478600001)(66556008)(6496006)(186003)(66476007)(110136005)(6486002)(54906003)(316002)(16526019)(33440700001)(86362001)(5660300002)(33656002)(33716001)(66946007)(2906002)(1076003)(6636002)(9686003)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pboE1xPcGdINIyRtmTJRzEqn6mI4h+JC36+gQ5MYb3Lu/QQSZBoeTyohvDArpE+7EzCxKKguupon55M9lgKUtnKnhbdv0AiaqNLELNODmT8mNA8vAUhs9pILpHfeTvG9heabzWDSKlg15EUH7aN9C+NcFYkKh+UHUlONvGJnzyvrBmx5VRTikN3/rehF7cF3RB2aPI3/PE95h8aZckr5YG4RuObFbOaj5RHwsJzaydN7bBH4oYK7bKVEx41OjcoX+aTBBSj1xVbx2KDpu4CWhFhwoqS/xS/E7YDhwTei4R1miO5LhGvRFyxQn+x4bbyx6cwvCjV05+Rl3czTMjQF9YRLNuzvq1pIv9EMRvvyhCehGk+qAv1S8i2I+WE/0r6JtQ+r/OjGXW2j97/1U0RA+Ga6nf0k1MGXrfa39w+crkMVdMnmb7TxEWhAoJc/lPjqnbcP2vfwk4y04UHLbj/msTzW7EQAfTE8zkvoSXBkLnJ/NNdnJfSLt8M4RIh4VRjb
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e75a32e-fe48-431c-bd98-08d7f7268a79
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 10:15:20.2545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JhUveI2cqF+fyvnAU2ax4Nj4d0rdjzH2SymnXNgcvudVAo+BPYSD1Ow2aD0bmCP7C0Y9odOZ6yJA/XZwnM9Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:50:20PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> From Maor:
>
> Hi,
>
> The following series adds support to get the RDMA resource data in RAW
> format. The main motivation for doing this is to enable vendors to return
> the entire QP/CQ/MR data without a need from the vendor to set each field
> separately.
>
> Thanks
>
> Maor Gottlieb (14):
>   net/mlx5: Export resource dump interface
>   net/mlx5: Add support in query QP, CQ and MKEY segments
>   RDMA/core: Fix double put of resource

This specific patch was already sent to -rc and accepted.
Please ignore.

>   RDMA/core: Allow to override device op
>   RDMA/core: Don't call fill_res_entry for PD
>   RDMA/core: Add restrack dummy ops
>   RDMA: Add dedicated MR resource tracker function
>   RDMA: Add a dedicated CQ resource tracker function
>   RDMA: Add a dedicated QP resource tracker function
>   RDMA: Add dedicated cm id resource tracker function
>   RDMA: Add support to dump resource tracker in RAW format
>   RDMA/mlx5: Add support to get QP resource in raw format
>   RDMA/mlx5: Add support to get CQ resource in RAW format
>   RDMA/mlx5: Add support to get MR resource in RAW format
>
>  drivers/infiniband/core/device.c              |  16 ++-
>  drivers/infiniband/core/nldev.c               | 136 ++++++++----------
>  drivers/infiniband/core/restrack.c            |  32 +++++
>  drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |   7 +-
>  drivers/infiniband/hw/cxgb4/provider.c        |  11 +-
>  drivers/infiniband/hw/cxgb4/restrack.c        |  33 ++---
>  drivers/infiniband/hw/hns/hns_roce_device.h   |   4 +-
>  drivers/infiniband/hw/hns/hns_roce_main.c     |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_restrack.c |  17 +--
>  drivers/infiniband/hw/mlx5/main.c             |   6 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  11 +-
>  drivers/infiniband/hw/mlx5/restrack.c         | 105 +++++++++++---
>  .../mellanox/mlx5/core/diag/rsc_dump.c        |   6 +
>  .../mellanox/mlx5/core/diag/rsc_dump.h        |  33 +----
>  .../diag => include/linux/mlx5}/rsc_dump.h    |  25 ++--
>  include/rdma/ib_verbs.h                       |  13 +-
>  include/uapi/rdma/rdma_netlink.h              |   2 +
>  17 files changed, 258 insertions(+), 201 deletions(-)
>  copy {drivers/net/ethernet/mellanox/mlx5/core/diag => include/linux/mlx5}/rsc_dump.h (68%)
>
> --
> 2.26.2
>
