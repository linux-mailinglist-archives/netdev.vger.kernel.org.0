Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3544665FA
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358837AbhLBPCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:02:07 -0500
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:17505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1358841AbhLBPBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 10:01:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AkrraT/lhed3VtLNVCB0h/iBeN5ixSJtyeMOZ15ASHZkCycOakNYgIMcd/zQtPfInuzeq4hpFDqGHFGDyC28/POch3oa3BOrpyJV0xFUVhkzF8nvJb2la6E67Bq+EjQ7jKLpG9OeLdxlBCF34D/UIewFo3LsgXMxiPkOf70bEron3KFAkwVsdbbpCNEXtfgWkj6b6ZeTMMKqbwBEs0FRt2BLr+tCzMQJUlg2SJegjTMykgSVzp1nOYaREWh/979KZPSV2pVGEBC9iKBGr4YYipSrVk6PI9PUKt+w7Y6f+hJwf7xEA/AseCs8qmWMDcmGH4/rzJgduQIQBckoojLTuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKTj+asMc7GXwMzpiAM5BnHWhhTkayBbdDrQZQD7iEE=;
 b=Yaf84hZ9DV0LAB6CnY4fW8QoVlp9rm5xwvTM8Nhh7ma3v4zKZp4A/EpcRtOqm7r36QDEcW1dnZkQ8UX8vnDhkZ4ENoLm3Z2w/QEI9job3B4EFii6oDCj8obd9cP0DCeJ13TqexV11mobXX+yenK1xGvvUr7WQXgBHrRz4NhjukeWJEds4K6yPiJpIQLegl+VJfgc2qqehJPbHyaQwSSCscrFKFKE9p+joXLs3+3d2Ptl6qTnXn8Zdzfs6iD4+SZ2pz6y/GRKxj524sp+rSSrKrWxNFKi71I1ccCibejxEzsJDzonnkWNi/IhokxGAh7JHrBsxz8riC20omyuh4cEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKTj+asMc7GXwMzpiAM5BnHWhhTkayBbdDrQZQD7iEE=;
 b=JxCxcWgoETqgplIsbSeaqkOS0mwq6luxiZJYSexqX6xWUn1lHFvHof889JpqnrjKL/Fp8ObLahVJ6EgKRNVxDZ+rIcQQafZApcuq8spX5uAOPMkEv/rLfHcjYBd7btYPO0PNSz+j7ywHgrSUkU/rC+//geJfIvJFGuS73e1NIQWnT3TRtx+/vEqER/8Yop7MMXU4VXLfgo00k3tnhrcBAnGvNbncrEhEqMWzHtFWq7cP26uUJ0Xa3UIB+dQnfpwtF4K7GBh9iChNdNGoLn0YheHFS4px493crgj2N64JcLgwyhHS9w8m1X8aEFZ9cnbBIQxXzVIdBQewlcA5U4S/kg==
Received: from DM6PR02CA0154.namprd02.prod.outlook.com (2603:10b6:5:332::21)
 by CY4PR12MB1573.namprd12.prod.outlook.com (2603:10b6:910:d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Thu, 2 Dec
 2021 14:58:27 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::49) by DM6PR02CA0154.outlook.office365.com
 (2603:10b6:5:332::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Thu, 2 Dec 2021 14:58:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 14:58:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 14:58:26 +0000
Received: from localhost (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Thu, 2 Dec 2021
 06:58:25 -0800
Date:   Thu, 2 Dec 2021 16:58:21 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: Re: [PATCH mlx5-next 2/4] net/mlx5: Refactor mlx5_get_flow_namespace
Message-ID: <YajfDXE4zJiOxIqz@unreal>
References: <20211201193621.9129-1-saeed@kernel.org>
 <20211201193621.9129-3-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211201193621.9129-3-saeed@kernel.org>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74d62db7-8b8d-4ccf-a828-08d9b5a43221
X-MS-TrafficTypeDiagnostic: CY4PR12MB1573:
X-Microsoft-Antispam-PRVS: <CY4PR12MB15734F48081B2EA6CDCE1388BD699@CY4PR12MB1573.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etsCDuiyvQku+JZiYiyUCx56NUlSBKWvtj+ybIMSSaPdmShud9cUdNO7BOX4f+jbJE6CfDbcYL1h50IKqM5zC6ofgQ7//XaLXhSriK7ziNJK98akmZ2G0ynPrIKyWAnVYZfDOcMjRHn90iW+s/WwhMz1Z1dzUOcwsrGOjvElSWbNDN2WugXgOFeuW/ajTNuG2kyVWbTgu3C1izZfxxATVrAA/hiHs25CtbvUGEJaKCNe1NzZ9KoWIF8nAeLyHZPOj+K8SicaOcz7gK5mo1FVWN90Icismry/nQODmYY100aY7Y5YrV2UaG+FK3Oohve58nlBaifd1GM4Umz9NNCs4w/DDw8dDhocrBqbeSTqIdkAxHMPvatYWB2NxezxY2YKFh1irMrHhbdHvIMCqCT1NtFvVr81ogmtvNg0bUVKQMGVxCc8cvPIJz8ivmYCFciN4ics1oGBulQ2baTJ9RooGN77CG3pvazQbURyisgwKBrD2dnYxFgqAKBlfdBiJil1QWlNyF7qUf4laiq8Z3iILt96Brcvrqe1qEdllicG26d+/ILtyO+PDQFK1ZPY5s7uy1p1enH9dKLQj4a5KVfrgVMntkVUzOs95dWYNsK9AY7hIaJ4j19CQZuTfO4Y3hGFhLqS7UMh29Z+dOMTP+SaZzLYgOcV5BZp5GpDPrnBMhWTW9ffjdJKKOTHv6TtJscpaQELvG2tHlD48nnee3uoDjiEATHLQxTHZohTFi44wQDhWcc4b432edMT5Y/cYuFyRdwFOIN2fMGm2PW9IR/stA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(46966006)(36840700001)(40470700001)(83380400001)(2906002)(8676002)(5660300002)(47076005)(26005)(9686003)(107886003)(336012)(16526019)(186003)(33716001)(70586007)(70206006)(86362001)(426003)(4326008)(316002)(40460700001)(356005)(508600001)(82310400004)(6666004)(36860700001)(4744005)(6916009)(8936002)(54906003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 14:58:26.9028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d62db7-8b8d-4ccf-a828-08d9b5a43221
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1573
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 11:36:19AM -0800, Saeed Mahameed wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> Have all the namespace type check in the same switch case.
> 
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/fs_core.c | 44 ++++++++++++++-----
>  1 file changed, 32 insertions(+), 12 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
