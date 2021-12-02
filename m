Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984E64665F7
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358833AbhLBPBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:01:46 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:25344
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347191AbhLBPBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 10:01:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dR3D67zq9QutVJnxGo6FEtzjN9rKqvXJ8Tl/m7ExR+2iCX0Q/3A+EH/ClSoUlUO3JjCBwx9A3xVhCzcFc8FXGfZICnF1Sugfvazzz0xHZ0mkV3JfLanwwTr7R2jM7d9L4YQ1j/yOpnfF/TRKLBlI7gRKxV0ZBj/TG12euOLXma6A+oyduNeqQQBJDJJY8mPvQGXFALFMS/Vpeb5fbSAUrSfRO/VyPb8T+oKzSQnDppjkVBQCgCzaqY7kmw8XfqRptQH/HT6qkoX6MtWY7eo8HV3RBP6qGnrdjh+L1CLSgiAYc2Xe2a6gWXdRRsITyf0le0yYfR5+6SUy1nv0vQMrmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5ClcepjWUjKXc3he0VEjXLIMDxnyRIT4CruirbxSpU=;
 b=HES6e3LYD2/fJmgo+O7S/w29aylYqhQkz/xjYKu00Pf/z6IvKOqnxYamNRqkfq9SmLik1+RrR8vbKVFWyHKU7JFSriTSVE6AVn+eCzhH2oVbzkUC9LeRQuLM3uoVn6+2FSOGIs1lsKmWqh/IvxkzGoGb1Iom9N9yFE0Jio1zXhUsxsnZ11M4D4WQHa+QFHQSAxipWgi2dOLO0fx1SvTrpUIYiaLsDxDsQ5xEyx65gQ720183Dn4leionRSIO0BopxUORH1qrpSObNSCdUNEAnQ8fLiYsJMRGJyREmbONG54bf5ltUFqJHK1Iskq9dix5V1dCgiuj9WUDOfPui7Y7Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5ClcepjWUjKXc3he0VEjXLIMDxnyRIT4CruirbxSpU=;
 b=LE8MDfYeS8Yc3CdNocFLnkgX7fQ5AJ5FdL8+3pqF+FsBvdHZd30Hz29cf9ZjzJ52GQiSIVV0dY3VNBq9sj6nIV/Rz9aDmDBInhc0nHYg7Xtx2Bgq1CGxfODqW0ZHtzBtgwMhgSsDVvYwLEqMlKAkpbLWUBBll5XXK1b3sJW6yNkP5fig9P5Y8/1Uc16O8+6KLIcxPE+upnsiGtLBnxdYIGhAhNSO6bZvjg4AX6IwsZJMMqIgbrGtGXUcFSriBOhqi1k9pIHb8WW5plNRcNdYfv89F7RyYaYtp3oYhJAqlkro71cwTAILF0SfUs2MRR/pRAqv7cVZJXtd8baoIUiN5g==
Received: from BN9PR03CA0263.namprd03.prod.outlook.com (2603:10b6:408:ff::28)
 by DM6PR12MB4713.namprd12.prod.outlook.com (2603:10b6:5:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Thu, 2 Dec
 2021 14:58:18 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::43) by BN9PR03CA0263.outlook.office365.com
 (2603:10b6:408:ff::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Thu, 2 Dec 2021 14:58:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 14:58:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 14:58:16 +0000
Received: from localhost (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 2 Dec 2021
 06:58:15 -0800
Date:   Thu, 2 Dec 2021 16:58:11 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/4] net/mlx5: Separate FDB namespace
Message-ID: <YajfA2p+e6AvgX6I@unreal>
References: <20211201193621.9129-1-saeed@kernel.org>
 <20211201193621.9129-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211201193621.9129-2-saeed@kernel.org>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac9fd888-27ef-4110-f294-08d9b5a42c59
X-MS-TrafficTypeDiagnostic: DM6PR12MB4713:
X-Microsoft-Antispam-PRVS: <DM6PR12MB47133F36CDE3DA04703F1D45BD699@DM6PR12MB4713.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KztEC4Kpl0R6Vd7uazzghEf48wvfIRnc71wHriokYJFftJ0xA1wBdvK69+ibuj0K3Kda7RUiaBMlTYLjL1fdfmB6sGTeVokO6fNfHuq/FBHyOVvRPHTYHbPPN1XLG7KQycgeGQ29DoVCajyqUQ77fEo7hBboCqqYJEnri6udTmHjg6R6iHb5G6a6Tlttu0LvwCN8PeiNtrIsHikp8DRMP3dwK9vIO2X/0sXlroUupVbBqnyXoqdSvV4jJYU3N99LZlUxkoKGPUFdDGjgmpo+gUBsAmtWhLtAgac0zE0oJdjYmm9g3zlYdAf1XYjlFRt44jr8ADxc5XfudRJkDsK0iDtqx/xvI2z6QdeDVicMklTrkP1wrsYTc/duhhF+y9m73nXgory5ufKbshn1t23rB88ENYuwWFRLOOVPa6GGIocstUd+693k7xx2/ErfEiO1mSHhowU5YuqFl/wftdC+7Gf3rpK0f6pnhQ/WSGxB12GOW4Ybx4Rw/+qBT84mxAkUpbkwyikSt7RZk/j4wZ7ur1huxh2hJDTHIbszqzQoykxM8A6v7kGcAYN9dh4H4WcquyYxW6K3hQEGTk4kiLfdGi0WrRW6LLDx1v7wOXeTOp04xqpIhG5iRKH1w/MViPdUZ3UeOkZL3c3aX3cDDTLZxkQjIZ4Z1DcNXvX0F7oepEqjbFRx9pYTcHOo2HYGcqPeIrZHk7h8fj8L0jAG9x0awhLq5x1xt2ZSabtqLrhxv9cjJ63MMdfkE3vzESpFetzuqmtPXJTgs8j5tZS3V+JsJ/zttKGhREX8vk81rsz+2LI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(36840700001)(46966006)(40470700001)(83380400001)(8676002)(186003)(508600001)(6916009)(70586007)(5660300002)(70206006)(26005)(16526019)(316002)(2906002)(4326008)(54906003)(9686003)(6666004)(8936002)(36860700001)(7636003)(426003)(47076005)(82310400004)(33716001)(86362001)(356005)(336012)(40460700001)(4744005)(107886003)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 14:58:17.1273
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9fd888-27ef-4110-f294-08d9b5a42c59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4713
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:36:18AM -0800, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> This patch doesn't add an additional namespaces, but just separates the
> naming to be used by each FDB user, bypass and kernel.
> Downstream patches will actually split this up and allow to have more
> than single priority for the bypass users.
> 
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/fs.c                   | 14 +++++++-------
>  drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  4 +++-
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |  1 +
>  include/linux/mlx5/fs.h                           |  1 +
>  4 files changed, 12 insertions(+), 8 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
