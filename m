Return-Path: <netdev+bounces-787-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 920656F9F78
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A850C1C20955
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9D113AE2;
	Mon,  8 May 2023 06:13:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0F37E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:13:27 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4173A11B71;
	Sun,  7 May 2023 23:13:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0MLzA3Ujl0W+euMCDVPQBD1VgpoL7GI4X7rJi8wTnBEut1PFDoXGiTVmdjG6B/e8ocA28fPaWiXqUV6tkdNhOL8nh/z9xDlvqMvnuNL41HdVJrHe63H3S56JmPLWXzt0ScKPmulp4tCYSG5+zHSXbECPWVfU08suGcRluFl1fLHzVuRR8D4pgWWQskRzEGZSGyiVt7u9K7P+A7ml82FZazdPfnuiGsV7eZDrcqXWoRvZP0y+rXQe46DlZGZqMkszOyocnvnPkHBJpBiMk4iC8pWwmsW2lnE4MNQUr5mLGxWVustKtueSiCm+zs+7pYOwQXHioQtAiZXZRD4Z0U7Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUnLahWZZJWYXpk7zNWZ2QEDrwq8Vyo2R7Sxle9HkeU=;
 b=aCDDeg2zSUb9wALE+KZvmg+TQJ+mXoYDgIqMpXONZIAxdUNI/BexGS1RWvKKDpQwHK42I9qxfTJOQVwRKFfjtFWNn2R0IZXQrmiTlcVeSYdO5jw8JiU428n4vBp7Y8+fYl581nBDYg4r0Ho6dNJ+0F8qkzbFKI5wW5p2R1gatDRlt4KGLaqucTwq16ESsOV//6PZr97cKbaX24YwnIiOoSIpqV96XPdHXXtZhvlXq1wXXhdIIhaHr4pwPmbKGtVaunoOFvTvFd0X2UnVZTMHylLgWDazNsIUr9bQb71CeREzUQO0C/YAZv2vAzzBnjvwZElYZZFhCAVC4DxUWPVcgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUnLahWZZJWYXpk7zNWZ2QEDrwq8Vyo2R7Sxle9HkeU=;
 b=QTr8JhRfoUBQYcjPvoAZ3OnZDwXmUGQN1ytIBVZawj1mC0eUsl5KVkH9l80XXCMk19BlcTvlnBLzKAIKmeW5VRzko+3xW5ijvQuTmR293ngGebTtzI7OJWYof4njYiM2NzJBfxEIHQcdaQFpQl3UL70U5aT8Boq7x/2/b77Iwyl55a4daJgh+UzRAg6osfeX6aN1Bt+9K9Vsq4eeimKSPCRq9EsjCI++MkwJEjyuL1zg2e3StH/7gnk41rcRHjQkq7KGx9DKv0M9Eqkq1+3Y+qdbjvPbjfpatGnr0l/Ny0gTG89keXL6Xjvnq34LqN+6LJooYV6XT0pn7UOTelhHeQ==
Received: from BN8PR03CA0002.namprd03.prod.outlook.com (2603:10b6:408:94::15)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 06:13:22 +0000
Received: from BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::9f) by BN8PR03CA0002.outlook.office365.com
 (2603:10b6:408:94::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32 via Frontend
 Transport; Mon, 8 May 2023 06:13:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT073.mail.protection.outlook.com (10.13.177.231) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32 via Frontend Transport; Mon, 8 May 2023 06:13:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 7 May 2023
 23:13:11 -0700
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 7 May 2023
 23:13:09 -0700
Date: Mon, 8 May 2023 09:13:07 +0300
From: Leon Romanovsky <leonro@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>, "David S.
 Miller" <davem@davemloft.net>, John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, "Paolo
 Abeni" <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Tal Gilboa <talgi@nvidia.com>, Roy Novich
	<royno@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: Re: [PATCH net] linux/dim: Do nothing if no time delta between
 samples
Message-ID: <20230508061307.GB6195@unreal>
References: <20230507135743.138993-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230507135743.138993-1-tariqt@nvidia.com>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT073:EE_|PH0PR12MB5645:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bc495db-8fcc-4a3f-721e-08db4f8b5322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m90Ran2CmtYYkuyfzvLfqtayVh+TeFEshdmsj1u6h3IdsmzHDVttLqu0qcQ4Yl64p/PGPKccHv+kN+h37vjiOUIjETA93LujftajN7Dnc4inurWHjcPj1NgLeP/uFwkEpvRQFOsjlu5rvf6j9cl+haxgE56w1jKEF6XSGcsYZ3/Wb5ygDDckS+EnhIoCRju07HCDR4Wp9Wsjwg/zdFpVg4OG1cxNEetCfiWoJ4E4R+YbO/ddkVwNTvRtkVDJA4X3nelE80jWIQRMmgnP10ooGturJxwMaDbQFlDvp1QVAULk2UGj0l9F2Ixu6VOuFbLhAflANOeJqDq10YnhRk+kewbPP7tZwi7JAgCshjITTVfrr/qxDQkBJ4tVVHZHXzuTmwt6RX/ylTmMUHsXOoeEotyNugLeXofoffMn0GaYqKdEbRtq7F77TuK/FeDEqIPOhV4j5i6omxQNm+iD1qm0faPqeLt/4BrMIbxIZyEZSrFtVPAqp2BA10RiiC60DEovJNOjb9uW4q8nHwPglybN0qpbAw5ajQ3N6Si3CoecdAX92LSZOAPthn9NKQ1oV2p+9qdPGjZhSQ7SAed230StvqtNc7Pyi5asHk8/A13ZxGwaXhdmwAGPo1Eg0+grmbAV2qjPkwvayTz7zW3vwENn3e0YEw0JHdp4iEWgrw1MzxuuOCq0NtqFcOCZTjLWL0e6B5YqAH+rmXwJ79f+I/r+jw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(396003)(346002)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(1076003)(9686003)(26005)(107886003)(47076005)(83380400001)(336012)(426003)(36860700001)(40480700001)(33656002)(7636003)(86362001)(82310400005)(33716001)(356005)(82740400003)(186003)(40460700003)(16526019)(41300700001)(478600001)(2906002)(54906003)(4744005)(5660300002)(4326008)(6636002)(316002)(8936002)(8676002)(6862004)(70586007)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 06:13:21.3903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc495db-8fcc-4a3f-721e-08db4f8b5322
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 07, 2023 at 04:57:43PM +0300, Tariq Toukan wrote:
> From: Roy Novich <royno@nvidia.com>
> 
> Add return value for dim_calc_stats. This is an indication for the
> caller if curr_stats was assigned by the function. Avoid using
> curr_stats uninitialized over {rdma/net}_dim, when no time delta between
> samples. Coverity reported this potential use of an uninitialized
> variable.
> 
> Fixes: 4c4dbb4a7363 ("net/mlx5e: Move dynamic interrupt coalescing code to include/linux")
> Fixes: cb3c7fd4f839 ("net/mlx5e: Support adaptive RX coalescing")
> Signed-off-by: Roy Novich <royno@nvidia.com>
> Reviewed-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  include/linux/dim.h | 3 ++-
>  lib/dim/dim.c       | 5 +++--
>  lib/dim/net_dim.c   | 3 ++-
>  lib/dim/rdma_dim.c  | 3 ++-
>  4 files changed, 9 insertions(+), 5 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

