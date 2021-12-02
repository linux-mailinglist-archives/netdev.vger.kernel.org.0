Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB030466600
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358839AbhLBPCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:02:24 -0500
Received: from mail-bn8nam11on2054.outbound.protection.outlook.com ([40.107.236.54]:43296
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358718AbhLBPCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 10:02:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lx8gRh7W6krqpWbC7VEU89DrgLVTNslh6EThoCJoVbZPYWMIvKwPeM5ohOkK3EFtn9cH8KHPNE64BqF1md7EE2SYmzNgqwfyfE6YYklKV9WkRdrc7I0w6/oAZAd5clNZ5xllquoZH83xZ1b3QL1E9iHfwA2wdMcUF9OssBgOQHSPjtIEBQpx6lxgvQszE4x64Zio60yXwL1CI4wv+5MUQrqWwI5rNDbKID6BxwR7jl63YgWjJLzZWF6SVYxUFRA9UMZgwXIcW/9z/KXGwtZxYFFlpaBuSQoJ2onKCpUAvy9+o7vSq8zxf/SoGd+27CY4J4zCseD22V+Ao1Z0wloB7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40ADUOd7Sw1G9eJmRyY6OD00/q8ogEVEDOZ/eHaQ08M=;
 b=P33uQbUkJzaQbIcI/E2bM4BJnwYjykkNk6GPr/KbUuXHJDZb2DzyFzWhZfKXCepgJkAAMkFdS6QihyP9p7aAq55aTq8pZQRP7Wwm5RFnsNr0XX8eOCA0EH4Vn1JCwejvnzW+Mgl0yW1mgrh2/bhcj2Vl3n4G89f791S7YTY01soFHiNWEZD354xw9O0koLHrD1DHEkosOViHi+53M9/E5j9s0p9pxrpYpIQleRGGFjmV1jr9ODFUtSF1Vs8pbb3jZEL0QHo1adSChmm8jSATvpp/p3UVyYC4F6vN9mwMPOl55CTS+xKx5FYHHLBBUosBggn+qFrY1Endrgk2XFbn8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40ADUOd7Sw1G9eJmRyY6OD00/q8ogEVEDOZ/eHaQ08M=;
 b=mwgHka7qgAQF75GVvQWhs4r3rXnKKce7aMCQDaJ2CPpc1QU/XcJN3t5cNTOPUZtzOLuzt6ivKhKbuD1BJdkyvUAVkL8Io4oNsNfyyQN9SKZJ6xk7idtIbBD939iZSnj80NwLYOiEgCF7egK2H1oi2UGodCrWkkbLF5SpEsnWwjH46cb4/68a3AKKEiugnYJHl08J0A34u9yqnAie8MOGsSONDk3jfDGvurmBLGcB4A/Y5RkpqDUIU+vHf7dqO4QzB6jRDl1ItfmYf/GKAqBbie6/dLjU+CqSI5DGWaPuXbs+utuoLcwYAUn99fLjH5OH4yKcoBIQ6wUnecCVRYFkiQ==
Received: from BN0PR04CA0041.namprd04.prod.outlook.com (2603:10b6:408:e8::16)
 by DM6PR12MB4236.namprd12.prod.outlook.com (2603:10b6:5:212::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 14:58:59 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::5e) by BN0PR04CA0041.outlook.office365.com
 (2603:10b6:408:e8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Thu, 2 Dec 2021 14:58:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 14:58:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 06:58:58 -0800
Received: from localhost (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 2 Dec 2021
 06:58:57 -0800
Date:   Thu, 2 Dec 2021 16:58:54 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [PATCH mlx5-next 4/4] RDMA/mlx5: Add support to multiple
 priorities for FDB rules
Message-ID: <YajfLkdK9hjDVEzq@unreal>
References: <20211201193621.9129-1-saeed@kernel.org>
 <20211201193621.9129-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211201193621.9129-5-saeed@kernel.org>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9f3a90b-4313-47fd-0a7f-08d9b5a4458c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4236:
X-Microsoft-Antispam-PRVS: <DM6PR12MB42362BA9D73EF71941BEA228BD699@DM6PR12MB4236.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LCHApNVYio1dpmjeO/tKQHRLi7aVKdAePIl2xtJQ/Uglpf8KOiMEaGdpuz4gWlUTH9NFtThIvfaXVjigjI+nS7bdqhil8Hny7StnDgJDWHRoGtxZeUK7w4kZiaLWzzxUgXGopB1WhUTzHGjyc2589hexNA2+xT63mUD3PzJZamJhrS49wG2YW19XvspZvaVg3q2PnhoNa9fPldbfDdTqhfXWYicEP2fJ+nVZY135fQMfL186wgGCBi5jpKagRlr3h47G4hoWz4iVkordMAJQmiPZv/Kh7fR9WrIxqPGnj5EWWxnvf9kkDw1W5xfxMs736K/fDAzB6HYbLq/lzCV6ML0oN+XbUU4oA/MNXv6OvjrRhXuKWtV1ZRB8ZfpmyxRv9JLhuN5cbJ5/xhg+9MPAmf7po0b7gWqkIbkaUSCreP8SsHx10iV4deISkE5fqdT6QOS3Ca1DAmkVbzqx3+Iq1agTwXlY6BID31PXVXvg1gewkPzAJhiwUzp4WCtvUi2dnBPU8w7V3/5E0FP1J9zRUJAvnYuW5heAg7tPteTBdS0na7FqpVPvHmZNgTs3wVQ+6JWT2KqwoOWJI5lA16nqLpkJLrFeVyIgmjh8CT3HU+jBgXRSeDBAdBMHYp7YnG0vfwp5SHCc7LuJawUWTFOjwnLlvcENu0qcdnw98PzB/yvcK7pyAaWYjYiT2ip0zRBz0txHAX0rouZjXro1Ban24Ew6WvSgJlik7W9Gtq5ds5t22kHM30j0pEoMYMHWZz2ZH4pZ00GJa+uVROgVj9EE0g==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(36840700001)(46966006)(40470700001)(40460700001)(508600001)(54906003)(47076005)(9686003)(186003)(83380400001)(33716001)(5660300002)(4326008)(86362001)(6666004)(70206006)(82310400004)(316002)(2906002)(36860700001)(107886003)(7636003)(336012)(26005)(426003)(356005)(8936002)(6916009)(8676002)(4744005)(70586007)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 14:58:59.3898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f3a90b-4313-47fd-0a7f-08d9b5a4458c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4236
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:36:21AM -0800, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> Currently, the driver ignores the user's priority for flow steering
> rules in FDB namespace. Change it and create the rule in the right
> priority.
> It will allow to create FDB steering rules in up to 16 different
> priorities.
> 
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/fs.c      | 4 ++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 3 ++-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
