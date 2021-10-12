Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B69142A307
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbhJLLVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:21:17 -0400
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:2848
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232791AbhJLLVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:21:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gx1yORPQsV4VXnhHiDGS92gLDN6fBO54M7nqaTnx5Zjo0NYvJGbzZicz2NXMgMP6RrtvQTrWkJDYkwRIO9yWs1jDYk+k0VXlXFC2lqVHNuThcAaOfjMc83hVABxwnouuxEZmRfNu4h19NWYU5SQjoGV1kAry6F2IfzqqKaFCrhnoOOigbKIstCwzL/pvA69hAEquz703NW1Hum9MZY7eTjrMGTbQZNe/XQguODKIpjqLjetsGaemgxSJAqBfeqyLxgDr4Hy+XyjZ0c2T8iNaJUiOuUJoqlahEgf64UFDIlEcFDFMJCwZ0uNCAgwPIMP6ocLVSIKdsxSW08JBBFan/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8vuO5cSouCVh4brd+EMJqoJZj5s6bGjXSlEzl5eiMA=;
 b=Bnbq5s3qB1UHFH8LzZt0jINqfvTcEXPyra1NhQ5WQma0ZhAv1LRRk1nG/+rlRcs2pcDlWh23YbRMpfkmOqzuVFFXgC5ssHqOQCTvAHqZMyruVpmd7OZfwphmfUG6FkRaMkg7SLpz0wnUMcoV8HQV5RUvDRW5wLc/UXU+loWsHowYV/IWyyziqrH0/wFkxQpHQFt9+EXf6zsy8k6PiT20YojWFOJWGMwWCLnmzNred7HztqxbyEKZTzoTEesMj+NjkRmbX+ZsMFFCEFXCCTzBfyV/b3ex5Tv6BhTA1Arfz8nSBxugbYurWGD0Kn6/MC0fTZ3nt9a9c9QK2R4+THdC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8vuO5cSouCVh4brd+EMJqoJZj5s6bGjXSlEzl5eiMA=;
 b=TGbude7BnKm6wAsvRzSsULAosTwD2lPkwwluRaCp5BH7Q4NjeZWfXMbnRCDxWVPXIAgK6VHVMY4Ki5m/zc2HCDk2VHHOYCME37fZRlp55q1NC+Z5XmBLSv/4WbW9HgjTXdNgwXjAFUx+B1ol0NeYo+dlNpHTXtpsazS/y9RSguLmxWLq6/rR1gQYlMegXFrMfgu5QM5swT0EDAlaDYXq2mE7HAHv2ZdDdCChjIl+Pi7viB63IQ5SbWypWwp9ZEHxACdQQQgWm0v6DlQ74Fj9iSeU7D4uGSuK/Kkive+ouNmg0dvtZHqxzHZhUTXuWma1ATv2Ftxsm8nNHPf0a8feuQ==
Received: from BN9P223CA0003.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::8)
 by BN9PR12MB5050.namprd12.prod.outlook.com (2603:10b6:408:133::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 11:19:10 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::24) by BN9P223CA0003.outlook.office365.com
 (2603:10b6:408:10b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend
 Transport; Tue, 12 Oct 2021 11:19:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Tue, 12 Oct 2021 11:19:10 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 11:19:08 +0000
Date:   Tue, 12 Oct 2021 14:19:04 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Aharon Landau <aharonl@nvidia.com>, <linux-rdma@vger.kernel.org>,
        "Maor Gottlieb" <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        Shay Drory <shayd@nvidia.com>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/7] Clean MR key use across mlx5_* modules
Message-ID: <YWVvKM/7jjdNoqTp@unreal>
References: <cover.1634033956.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1634033956.git.leonro@nvidia.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 537c90ab-d8d9-40bd-3e95-08d98d721d1b
X-MS-TrafficTypeDiagnostic: BN9PR12MB5050:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5050DC9C8685AAE395ADA79BBDB69@BN9PR12MB5050.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1013;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bYM8MW3XPpU8uYGz6XCBYW5szcF7sOSz1jKOOOCbmKOgPaQkXqtpFFIbxQsjFzESf6vUlV/YW25K0MezhgSb3W7pJb9zQIhUlnyZ6srwZDQa4eLd3p9br+WtxG0yTJxXEFDjDs8sFUR/Pq/QZ/pp5yuK6+hoekopqXjCWVwg+Hqc2Zy0QRJznkHzDjG4wsb/ifJ4VWuNa1YMLyDFyfTUt50rgD9YCwhZqamRoQlqzmjh5MkLM2RN0zyKTL6gqZz92wBeEF3P26EIhsjQkSEiMYoxwh6cBmdGsCmSRrOWDhI7Vk+EBOm/PpkSCTx+VwMbmES5yYX0goe+TRR/FDRFvkk3FOnTPOyBNDZgJbZu4NNG8dHR9TgiZKli79GqU6vNjLkpohamVmnzgf4c5nz8cmtjmkpyr4oCSZh2c7fDaP1vZKt4VTYf/YjHPjE7u/v16O//sPY3BLYBV2H9d6dbGYKuxcQfU4EiJoxBLhnXrYF3da3bn790FtWawiA2h+XClEQpZzwplhsc8DoOdd3Mcg1QVm9+48xS0wBseSBZPNmBN6iMsul88Bkw94l3SVlH8yN+WHooTZ7owAcfoCPgKHJLl+VeyG4iYAwNZytgxd1QvYv2nJj+fNBI8dR2IXuZO+szw4kfH9+QBB78NxpIIsWM8DrsI0s0YxdQgEoTzA9HeZHVb65HWmM7Hz9WNaklIGfMA0JeHGhpPI60IgIMhBuT7pxA/2WObDmW0rsAyom9T7NH2w42qrHtlGtuRjd6FsW6zwmWysJuzC8t90EY0ymtVcyhAy+OWELFZGeZeLc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(46966006)(36840700001)(2906002)(508600001)(70586007)(336012)(107886003)(36860700001)(5660300002)(70206006)(86362001)(6666004)(966005)(9686003)(6636002)(8676002)(316002)(47076005)(82310400003)(26005)(33716001)(16526019)(4326008)(186003)(8936002)(356005)(54906003)(7636003)(83380400001)(110136005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:19:10.2049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 537c90ab-d8d9-40bd-3e95-08d98d721d1b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 01:26:28PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This is cleanup series of mlx5_* MR mkey management.
> 
> Thanks
> 
> Aharon Landau (7):
>   RDMA/mlx5: Don't set esc_size in user mr
                         ^^^^ this typo, I will fix when apply to mmlx5-next.

Thanks


>   RDMA/mlx5: Remove iova from struct mlx5_core_mkey
>   RDMA/mlx5: Remove size from struct mlx5_core_mkey
>   RDMA/mlx5: Remove pd from struct mlx5_core_mkey
>   RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
>   RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
>   RDMA/mlx5: Attach ndescs to mlx5_ib_mkey
> 
>  drivers/infiniband/hw/mlx5/devx.c             | 13 +--
>  drivers/infiniband/hw/mlx5/devx.h             |  2 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          | 31 ++++---
>  drivers/infiniband/hw/mlx5/mr.c               | 82 +++++++++----------
>  drivers/infiniband/hw/mlx5/odp.c              | 38 +++------
>  drivers/infiniband/hw/mlx5/wr.c               | 10 +--
>  .../mellanox/mlx5/core/diag/fw_tracer.c       |  6 +-
>  .../mellanox/mlx5/core/diag/fw_tracer.h       |  2 +-
>  .../mellanox/mlx5/core/diag/rsc_dump.c        | 10 +--
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/en/trap.c |  2 +-
>  .../ethernet/mellanox/mlx5/core/en_common.c   |  6 +-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 13 ++-
>  .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 10 +--
>  .../ethernet/mellanox/mlx5/core/fpga/core.h   |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/mr.c  | 27 +++---
>  .../mellanox/mlx5/core/steering/dr_icm_pool.c | 10 +--
>  .../mellanox/mlx5/core/steering/dr_send.c     | 11 ++-
>  .../mellanox/mlx5/core/steering/dr_types.h    |  2 +-
>  drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  8 +-
>  drivers/vdpa/mlx5/core/mr.c                   |  8 +-
>  drivers/vdpa/mlx5/core/resources.c            | 13 +--
>  drivers/vdpa/mlx5/net/mlx5_vnet.c             |  2 +-
>  include/linux/mlx5/driver.h                   | 30 ++-----
>  25 files changed, 147 insertions(+), 195 deletions(-)
> 
> -- 
> 2.31.1
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
