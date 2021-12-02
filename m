Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37C4665FD
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358847AbhLBPCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:02:13 -0500
Received: from mail-bn7nam10on2080.outbound.protection.outlook.com ([40.107.92.80]:35936
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358838AbhLBPCJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 10:02:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtJuPoWQ5lf/ZRZ6RVfjFuSrp3Ua0zVH4KjlNyy3JxJ9DTOLdX1tS9jKg8r7tnPMvb1mJQ5XeOm58HiuIRJlJyfhIhBV7Xe9ABy096oahLIjtoX15tWf4+uQ8LnVh1FONJo2Q8EsBRpI3mQ7w0JLKzVlJs4wVHFEQ87FAnQQ/R4EKf6nnnGL/ozRyCsqRdTvlv6wGshCgmyXDX7AF4xXLOEvcOFHaS96BBLXoyLKIFqM2GVz4KLIlApXEBXlX1tDKqEcytSz++aTCyKMrucFkqTMV3mb14Z84+tUjaOxxOD1GDPSczYgRkst2CNWYg4aSteYfaIIFqCoEwyCNAI7yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xfj8xq80hUtdvR56oSuz5TuXJPRJ+mtXv2JdLB2QnVI=;
 b=HcnL9JNWExDCD1kmU9nRaUFWPYDqsQCL7CZwTRx9g8yjmYjOydTA1qzeOl9tmxl12aK1ynWQZj7JhGNtZ2n2bbsE6LS9SyAU+vf2H4V3VwzEvHNUZxE+eR/ucMRWAM6ApiCF9NmCglxALZkjRGzvHQ767BZuoJ+q+JKntChJJS5BQrHhDsiHToIMnFOYrDkZVlLfpDta0j9b15k6EKRMFCuuR3E9CNq8QQv7GsojLzZYUSqdxyd1/w5cnWlUj7Cs2NZz5uHcnMUiAQ9vOib8Uo5ttDKRrToRrR8KoyAjZkCVHks2ZzI07/Qcm/PDXXTOPakH0vK682Etgan9Ak/uDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xfj8xq80hUtdvR56oSuz5TuXJPRJ+mtXv2JdLB2QnVI=;
 b=hzxRCQLXJBP7fT0b1GRipR105fEdHgDfFYxU/8q/7B/1GIF0rdlAT7B/kV+URKrdJKYiugSJVn8M9a4kKP1hCdIDNP/W67DXN7HJ7iavy+u/aExpQ9QO0ZglQzEsDpFfG57XuHzzAt/XQPoQaBcvtHb4BjmhOhApwuMyTICSDMxQ7Cl/NBGzRNwayHvjVbUCUgJQYSzyqbtwNkPdaGTWWPwLDJAWjLp954An6nOmhWP2DAHLEpEaQ41zOEwJHFNmPDvfNZ2H1isoHJzl9oLUQsM6O5pq/D0WU4Orx8ZSeAtCv/H4CSEEs8DSbIVN3uCjK3brKHtKT1kblFKUIRnvCw==
Received: from DM6PR13CA0019.namprd13.prod.outlook.com (2603:10b6:5:bc::32) by
 DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22; Thu, 2 Dec 2021 14:58:45 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::7d) by DM6PR13CA0019.outlook.office365.com
 (2603:10b6:5:bc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Thu, 2 Dec 2021 14:58:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 14:58:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 14:58:44 +0000
Received: from localhost (172.20.187.5) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 2 Dec 2021
 06:58:43 -0800
Date:   Thu, 2 Dec 2021 16:58:40 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [PATCH mlx5-next 3/4] net/mlx5: Create more priorities for FDB
 bypass namespace
Message-ID: <YajfIPrcxrYid3pi@unreal>
References: <20211201193621.9129-1-saeed@kernel.org>
 <20211201193621.9129-4-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211201193621.9129-4-saeed@kernel.org>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cb16e63-97bd-4241-c671-08d9b5a43d0e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4137:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4137A75671E20097DECF6B8CBD699@DM6PR12MB4137.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FIKAyo+2lIQsqGDWYuFjc+LrYYOfyd40oReIIZDbbQGQ6u/zk4VJwsdlDA1eTdnMtKqWJLQJxmZrEdS+kvBqsD2NFZDK8GJ4EeLuC9/UKjn910VmPPDyB6vsQAoTS9tW/k8f0HZLL6+ttkQpV+1x9F+w3QYoutClVXm/ULi29qkqv4J/r1KkvxlJMecseaCB1O686cmIwk68xSjrK1eIKIhevP0na1+ck4cwUoEWjfs8tYqdp32mSNm5zabTi5sSylZQfERU4kDa77mV7WAmKPLerWJL1HVTwwEy1APgkeoOhCr3apZuTJCr1klRzVtiWpssGxDOkcAmcVsGKSvUUZxVj54U+50ZHdc+4+OKCCIC0gmtfUn8Xyu6UsKad2xah0RrQAK8XrHNABtTG+aVWZ3H7K67zi5jaRaKFxZx+dRlcR+rojHLtNIX43QZtUmqkT2RItyO1/aghqxBXKGx3RCJtnUoq+w2yF5xmk+JcbZJQ2gSrmSeqYfUPh+SFETk0NiG5bFOuPaTvST4PYQuZQsQ1MNsODj51QPIjzyyhVgV9oKiX38PIqpUPibssbxpmx3q3N2YVY3kop65kQDqe6CSxEJ8SymgdxCqO7I3xBRpuHSNF8HQMT9kQCsQ5ue1mPASJBiJ7TQKW2u/L+GZRSEVADtLubsW/d2pNEZOyIf9RWItpPzAHC2aZ0bZFziEZP2sL9ZKGyC2zBC17RTSU6z0WCX0QmIIKmEpUMRtnQ0EgfUTDBmMhA+ZIWI7F+fo8S6n8/DCwzaAWJlHmU/Y/w==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(36840700001)(46966006)(40470700001)(508600001)(8936002)(9686003)(5660300002)(2906002)(6916009)(8676002)(86362001)(70586007)(4744005)(70206006)(426003)(336012)(316002)(186003)(54906003)(7636003)(82310400004)(356005)(33716001)(107886003)(4326008)(40460700001)(36860700001)(47076005)(16526019)(26005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 14:58:45.2340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb16e63-97bd-4241-c671-08d9b5a43d0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:36:20AM -0800, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> Create 16 flow steering priorities for FDB bypass users.
> 
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c | 35 +++++++++++++++----
>  1 file changed, 29 insertions(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
