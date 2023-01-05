Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D9B65EC21
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbjAENGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbjAENGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:06:19 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF0757932;
        Thu,  5 Jan 2023 05:06:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMUIibjagm1WEXPXj4fbo5QmO/NrwYLCNk1PQV5DSn8bzMkmRzgyOs+LZ+1ZhLBylrfdEFZjl9+WpHwhWlaigCOTSZJXtrJUbNfm14DxNHG8W0pBXEeMT6pA/KztUjVioutiXdcoAF57DGgfRcBbXE2PC7oM+i+jkz6gHOiUFSII3uh4KcJYTRIqh+A131tiyA14RV8ALazbU4qMM1kLOW5WFQseGQxuxfeDOzOaXbh9UjrRBMD7cmktQjRPzcvVT8gNFZrX/a73BVrS6QPAH7v9yYaE81ARa6KAasUaCBHi6F3/d4WQNKgoGzsHFSA90kfl3zYXeGS7o+myedLajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba17J2L2LBZJ8hV+nQ1M6iRc4+cfU5kxNtpQm9V/wqI=;
 b=f/obU4tnRMLLNbEyvauQg8ykS/08SOm2yJ/3/9UZZt0DIS3U7cpSigtN+rscwJ3nj2Uij7duifNEWango57dUWg05ZhHdWau6W6JE0ZbdT5KqvnRRGnltAGtd/bHeoMVrif/Up9Q02p4CANWS+noQr5FDx075JjTN6ygPZgwKzHDF3yVPVq500wikZJ7li5dDrhYQwMYMQ7rkzQblVnVF4YlN0so150ssga79q7bWlxC2avTPzXcF/9t/bPPUwO6SFiPKL8qfEyX7EVKVb/pX9YiNkZ/kHj8pMeWfrQc+UHImbSaA/9lowWADDDDeGeGo8NY2DIMI7GjtGNRQWnu6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba17J2L2LBZJ8hV+nQ1M6iRc4+cfU5kxNtpQm9V/wqI=;
 b=BMtEVxmNRf6rbekb8M9Oi+/boRadOhq9WpQ29QUTzGlkT9Dm+XOrrmGc8NF2hNutLbl4LNJS+n3U4Ywq15SM4B5ecXUzviM+Zb6w5fy66y3jSNDglwjNK4eR0i+oxq/tNvNzuk0Q0mGbpGMhG6k5B32Neh/c+r6UY1+dPM8QhqiAkM13Mtf+nsXq6D2tqrdaNeft10W9Mgr3I5uYCdEMIbVWLB5kgvPay+S8U9RvUg+meoMvjlmR0RN94IO3UjbBiWzgrW+zzCiS404HSRhZRPv3pAwFShnI1Zp3dzJLy51docZcWrYjVJao1tIZWBi+nubMu0jeCaj5p2VqdAIIZQ==
Received: from DM6PR02CA0140.namprd02.prod.outlook.com (2603:10b6:5:332::7) by
 CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Thu, 5 Jan 2023 13:06:09 +0000
Received: from DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::10) by DM6PR02CA0140.outlook.office365.com
 (2603:10b6:5:332::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 13:06:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT072.mail.protection.outlook.com (10.13.173.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 13:06:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 05:05:58 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 05:05:57 -0800
Date:   Thu, 5 Jan 2023 15:05:54 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <Y7bLMiB9Pb8EUfn0@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230105041756.677120-1-saeed@kernel.org>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT072:EE_|CY8PR12MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: f6ac88eb-786e-48ee-f20e-08daef1d9cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g5Pio9VIS/Y88sk2Nrv+L4KFeA5v8QPFohedKbGqDX7EGq4jHY4RKr9xGDOGPbIsFXZfRWokLJyYudnX/RmGjriI+Zz0XCpNLBGmKVxggwyE6Hb8Ft3hx7tEV+myo+6c1LllLFptQyxHFkT/SiT92tJE1CvU77vh1wTy7mKn+F1vj74l/0WfGKZb8MHC+6WJDgfR4rMBPBSmBS7wyDGpeFlP1Vz/H5Tby6vzvTe26n7XWCohhDnxgmg39LMNPRQCKh/duAj+EDNybdX2zyPRQtepAWOMH9JogbrJFsmusS+hfxTu64OSqlWVkp2pzm7kPuBvjtQgpNH4Is4klzgd7HGDAsNJSmlZpJ9OHyI/s+rmI5ALM38DiGGakYkuAX/PqLV5RJyyJ+/lNCScTBBlMafG9HQW+DECYYzT+vtJiO12XhObheJHQ8+2ydBtOeKvik3GLNNAwbdbCawCVRxpgJ7pbDnbrhsC8lzLQHvbgKLazpm6oPtfK8bea+3JdvdKMuaKrnAo7HGCTTGjNASXaJ2TPvMI6PX0TiB1+azPBz122Vap6MkOn6yVsn0I2gaGvREyHbZNIb2xgmB9yZFQLtlvbnvDdGPL5r5v75K2ZvCsMNRnzkzgIMP0Qxnb+L1amsWpxwedSQe5xTpZm0qeu9lncvibSVD7jc5zyvSQxyJjRMme6YhOVh4pKAgEY8IpQXSMxQ8Cq/MZ9VSlqhFdgg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(83380400001)(33716001)(36860700001)(336012)(40480700001)(426003)(86362001)(7636003)(82310400005)(8676002)(82740400003)(356005)(47076005)(8936002)(40460700003)(54906003)(2906002)(4326008)(5660300002)(70586007)(6916009)(316002)(70206006)(186003)(16526019)(26005)(41300700001)(6666004)(9686003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 13:06:09.1303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6ac88eb-786e-48ee-f20e-08daef1d9cf6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT072.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 08:17:48PM -0800, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This series includes mlx5 modifications for both net-next and
> rdma-next trees.
> 
> In case of no objections, this series will be applied to net-mlx5 branch
> first then sent in PR to both rdma and net trees.

PR should be based on Linus's -rcX tag and shouldn't include only this patchset.

Thanks

> 
> 1) From Jiri: fixe a deadlock in mlx5_ib's netdev notifier unregister.
> 2) From Mark and Patrisious: add IPsec RoCEv2 support.
> 
> Thanks,
> Saeed.
> 
> Jiri Pirko (3):
>   net/mlx5e: Fix trap event handling
>   net/mlx5e: Propagate an internal event in case uplink netdev changes
>   RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier
>     unregister
> 
> Mark Zhang (4):
>   net/mlx5: Implement new destination type TABLE_TYPE
>   net/mlx5: Add IPSec priorities in RDMA namespaces
>   net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
>   net/mlx5: Configure IPsec steering for egress RoCEv2 traffic
> 
> Patrisious Haddad (1):
>   net/mlx5: Introduce new destination type TABLE_TYPE
> 
>  drivers/infiniband/hw/mlx5/main.c             |  78 ++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |   3 +
>  .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |   9 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.h |   5 +
>  .../mellanox/mlx5/core/diag/fs_tracepoint.c   |   4 +
>  .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 +
>  .../mellanox/mlx5/core/en_accel/ipsec.h       |   1 +
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  59 ++-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  15 +-
>  .../net/ethernet/mellanox/mlx5/core/events.c  |   2 +
>  .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   6 +
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c |  44 ++-
>  .../mellanox/mlx5/core/lib/ipsec_fs_roce.c    | 372 ++++++++++++++++++
>  .../mellanox/mlx5/core/lib/ipsec_fs_roce.h    |  20 +
>  .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   5 -
>  .../net/ethernet/mellanox/mlx5/core/main.c    |  20 +
>  include/linux/mlx5/device.h                   |   1 +
>  include/linux/mlx5/driver.h                   |   5 +
>  include/linux/mlx5/fs.h                       |   3 +
>  include/linux/mlx5/mlx5_ifc.h                 |  12 +-
>  21 files changed, 614 insertions(+), 53 deletions(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
>  create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
> 
> -- 
> 2.38.1
> 
