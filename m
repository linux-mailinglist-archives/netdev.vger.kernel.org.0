Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6122B1AFA48
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 14:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgDSM44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 08:56:56 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:56807
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725793AbgDSM44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 08:56:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYRbnfWtuKbXGimuiXZN6SLwpgD56pnQG8cgCau3SPdKfDTDo4ChQia+zCF8O3GItTNBAbJSgHUZ44LxsQ5ujiQkeCTdZq2nWim5vYBRKR6aPUZ3ddOA2GrwykG9T0qLoD2/PREYACGV1Jb16H59ueUxMPiEHHrNHuLJhGT9urmXQgPGx1jcAm6j0NQfoqxJma0I6cWnUYkdaKx3+/WW1bRudMw17fcSNntdVv5iv8fA1j5Yv+TVr6GuSmrtOaTOmFf5TbA59TQiKCD/hFgsxfCacMpG77jc4em5sN6s7uEeYMaPjwk5sLFFaORxlPy84fghVOILT0AWAwoieTzl7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdEYzKKviw80/D0kUkI4V1usEY1FG8AJQ+GnBN1IdqA=;
 b=PYrJw9iIAmtomMjquSZbD4T7TPlGm0RLvydG6rAnusd22QHtu3FFkvZzH8PmwzBiTs9IIC78bIfzOfgRv4MwagEo4Zx7PBrV8rMDEK2m/it/fY6YS1ApjamZmaPNZJlpP8vt1mULi37GL/eVxhPOrioIw5f5W27E0IB5V8P8eKxcUmaUqG4wWcpNTl+Vv5k0Lb9fhEc+N7u3ulZfUwRPQxbTl73IbwFTBcTvm0fwUCuYz3RMDwrnhH8YDCG14rR8y+fjodl7pngfX4eKTnad4BPYtfSOUtVfmgiu35rHyomGDE0cLe0IBuGri+JhcxvJj6HEQEQI/j1+++GXzvl75A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rdEYzKKviw80/D0kUkI4V1usEY1FG8AJQ+GnBN1IdqA=;
 b=CCsuFrVSLXedGYKijTzTYMQDzokKO946SDzC4dHUbxM1bV/hmndSEp9t0piistkxbV8F56fGVEAbGzNF1cjVqiOCzeVvuzm4rt65EMwX+kYUG8d6lgStQXVllbIzf4htOJY0wtcwXEOk6edDAuzTgp2mDjt9mi+olb/GtSBPEhc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB5444.eurprd05.prod.outlook.com (2603:10a6:20b:31::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Sun, 19 Apr
 2020 12:56:53 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 12:56:53 +0000
Date:   Sun, 19 Apr 2020 15:56:50 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 00/13] Move QP code to be under mlx5_ib
 responsibility
Message-ID: <20200419125650.GA121146@unreal>
References: <20200413142308.936946-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.11 via Frontend Transport; Sun, 19 Apr 2020 12:56:52 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca975d20-461b-43ae-7db7-08d7e46121f8
X-MS-TrafficTypeDiagnostic: AM6PR05MB5444:|AM6PR05MB5444:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5444C5ECD2200E5804021BD2B0D70@AM6PR05MB5444.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(186003)(5660300002)(316002)(1076003)(16526019)(110136005)(52116002)(33716001)(54906003)(9686003)(8936002)(6496006)(81156014)(2906002)(6486002)(66556008)(33656002)(66476007)(8676002)(66946007)(478600001)(6636002)(86362001)(4326008)(107886003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tgdoGR/BPnDjhp4xycEibRdXj5XDL3cxs5UTd/2VwxTOj22FWVVXsxgg6KOrLNkB19GzdYpP0VoT2WjipqCDr1PXUOMb5H4itouA2Yr5RO/kEYhqwIQN2Bwy3ZPRCsa8B5gTlyjhGfcWy+BpMoZQQzda0vjK/4UYv3FF4gW3agxO7BdNnMXwCNdO3iGGTvh6HyQUzypoHqk27R5V0YvyCQIZgqn7QK0dIcDowkKehigZQV/VmWFBdR+8n073qbMj26ldnHHM/rpJO5GSAH0qIzkvntiI25JYvBV4rrg6R5WM7Ri51ZpmKiJhypzRi1KtpXs7aY4lEQk4I7u+OILTXWj6ha5LLVCNg5p5laNjazfQH3ZF/tSVkROd/T4a9p7+Y1620DI77PXicT/69cE3K+W8JGY1yYEOspSsNIHGJuconJY07pNnZ6W4LeVovrxh
X-MS-Exchange-AntiSpam-MessageData: P/Doo7pY3h/wsmGKVrPF5kvSdFTBFXtuvAA+06OYAjt0VADRK/o+tO+8bWBDhAWcL8A+D8mmdaAKDyTMjIP4bPdzSpY5Opq4tOgAJ3aRhiPugcJlAEmad3i4yjLi6wurqHTI/cXuZD3aWl6FW8JspZZuqg0iz8gVBBJD91QerYo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca975d20-461b-43ae-7db7-08d7e46121f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 12:56:53.2906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GX9ChaDd0IfVqmuZ4CBVtjtvE/qXKl5kNF477JFzcLYBIpg2AsACBb1gC8AY8h8UxGJXepbP9wKuhWOmZk8exA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5444
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 05:22:55PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This series introduces simplified version of mlx5 command interface,
> refactors the code to disconnect mlx5_core from QP logic and moves
> qp.c to be under mlx5_ib responsibilities.
>
> Next series will convert mlx5_core to this new interface, so at this
> point I tried to keep the amount of changes to the minimum.
>
> Thanks
>
> Leon Romanovsky (13):
>   net/mlx5: Provide simplified command interfaces
>   net/mlx5: Open-code create and destroy QP calls
>   net/mlx5: Remove empty QP and CQ events handlers
>   net/mlx5: Open-code modify QP in steering module
>   net/mlx5: Open-code modify QP in the FPGA module
>   net/mlx5: Open-code modify QP in the IPoIB module
>   net/mlx5: Remove extra indirection while storing QPN
>   net/mlx5: Replace hand written QP context struct with automatic
>     getters
>   net/mlx5: Remove Q counter low level helper APIs
>   RDMA/mlx5: Delete Q counter allocations command
>   net/mlx5: Delete not-used cmd header
>   RDMA/mlx5: Alphabetically sort build artifacts
>   net/mlx5: Move QP logic to mlx5_ib

The whole series applied to the mlx5-next, please pull.

Thanks
