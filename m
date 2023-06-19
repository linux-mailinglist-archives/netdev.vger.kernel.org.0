Return-Path: <netdev+bounces-11861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FC26734EDC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:57:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7276C1C20826
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F96DBA4E;
	Mon, 19 Jun 2023 08:57:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530895250
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:57:50 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36C3273F
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 01:57:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e62BYw5QBxdE62iqctfGg+ewS9Ygm7Eqda68m2P93G6AtjPOaPA7FnrWAZuBRWxqNH0CHOQnZPSztP5ju5H1rdZXOD6eBpL3Nc6d/YKuZApckphUyXyCnT2rq0GFW8YftyY0Z5jrIsM1qMy15wCkhrp2ZKbJPKN5CYqfpHpLyvsvCWVlftyABX7mrVS145hBq+I1WttalMR1+8Ns53Y1hQ9mUmFEuYkM+29IW7byKk0x40IK0iwWinus4ckoXrzh0MzK4dBo71Tq0pJRJVdQojCmXFzimigiUyydxA2wmLnO0TUCVZT5tS91RIUXye3oW7X4P+YfqHHejNPqOqZDUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rW0asRRfjV7Sfpd+V4ss8umDN4xNYfl//2tWazOb6Es=;
 b=Q/nDHp3+HDxQfBg+O3/7ZswJXM8UuiYoIPkni1aOe7Z3/vJ+r+K1sFZT7G74HtXqu6nzD+3LldSPCv8SGTPGx9vwzb4qe3vAeZ4FD43ZQB6NL3ruOiQiIgm57E/DUlHKOC1WbNjKRynvepd+bFKy2S12STI7VQvsRypDXPG+sKpoJEzcr4GFj77qkUeNjZe3UpHDGcbdGpV+6xXfR5DHMpx+7DMyAu9mQqFtcS+3JTjPpFWeSdxQt2Dx89R/62Qzkii5ZospEUviE+GG3hnoJu3CZZJfJoTWgexqTLveeos6YYVewEBLJktPlZr7iulIiLFvGWw+V1M2Bl9puuCVrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rW0asRRfjV7Sfpd+V4ss8umDN4xNYfl//2tWazOb6Es=;
 b=a2dKV+J2mwD5sXUbPF+1FsfiPszg60BCXgEMnUVTt88B9+XvOwNG0ZbuGiS8kysXJGOmrInC8XHDTvesF3PC/ZGSt8U3eMszJensQtq9zWeEBCW9ZzlRro7xob59kPUdzKUuJQJvToUJDnYGMsj88QUhxWgAoRAdmPe9JxqLVsKCao/dZU9I1ZBVxScCYbtfrTEVHu0UL9v9nm/lf3M5WvCW7Lf5tlloGh7GMx3RVAET4Z7/uuqfT9IYOHQYlFYSylOYj1cOpA2KuKhi+F6eZbbKnPloqXoE+KZfJ4FO/zcEr1FqeD3/NFpq0wnfA1WRFR0eH7EWQ87n2iRpfUek/Q==
Received: from DM6PR13CA0026.namprd13.prod.outlook.com (2603:10b6:5:bc::39) by
 DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Mon, 19 Jun 2023 08:57:04 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::ae) by DM6PR13CA0026.outlook.office365.com
 (2603:10b6:5:bc::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Mon, 19 Jun 2023 08:57:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.36 via Frontend Transport; Mon, 19 Jun 2023 08:57:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 19 Jun 2023
 01:56:54 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 19 Jun
 2023 01:56:51 -0700
References: <20230616201113.45510-1-saeed@kernel.org>
 <20230616201113.45510-8-saeed@kernel.org>
 <20230617004811.46a432a4@kernel.org>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, Saeed Mahameed <saeedm@nvidia.com>,
	<netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Gal Pressman
	<gal@nvidia.com>
Subject: Re: [net-next 07/15] net/mlx5: Bridge, expose FDB state via debugfs
Date: Mon, 19 Jun 2023 11:37:30 +0300
In-Reply-To: <20230617004811.46a432a4@kernel.org>
Message-ID: <87v8fjvnhq.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|DM4PR12MB5088:EE_
X-MS-Office365-Filtering-Correlation-Id: cf485695-0cfd-4dd6-842e-08db70a32766
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9m1YAV5ev2duDDKX0j+ppKJ8HxxkrpqXAkvrz7ylLjLBMC2e2KG0mPimlg2HQsEoRSK9OYBgjlxx64ey/X7TA4dYm0TGUiu3shYHYTtStO2HLOojap1UjlXvVH8yBhDiIbtTEd4U70YtTUU7jGV426pWU0dcqw4QWh1gZuCdbXxC1eoTEH0dC3MmMb5P6YRCiAie117zQzApo95N7N809LduQueuAmX7AgtlJYUS+75CHeLME8p+P59AQu2mDC4Xvv5YciedvRi5CeUNazu4Jmm+Nv8oLg+SoGiW0TyMT5w+YcCRrHW2qC/Cru8RKzRPCZUEAH5xom1ocwweCop2vWpwgL2aG/J7cF22PxHO/yIT3bnmbNN93n/UxIEtdcFxCT9gE6Yzq2p2N/LPkwA2DGf5MtEBf/DdThemB3b3+yk5vZDjUCwEqqU4LRpGnIA58kbTO9nOyZySbX8SYPR/dN4UrZLaTxZiGsynUs+nOZokkzCoKmhDZpnvVurADP7XlLasUURIJUCfeIdgltQ/qY6H7MRvPeH/x87yp9PbSBLtHpmQiZCTf1Smewh2BUSCZTlCs7zIzw9tlV5gf6AY+1oFn7IN6+oMpmZnn3arUpeybW1FVDzkrJI3Ds7n/lQlxgyxVAfpaGLgpHEiTZ9vARDQcqTkDUu3SDO+5me/6Fm6tqXPcxO6EEnh8/N3ha0m+9UQMhayx7Z1Sxr1jLfwktuKJjiXnKcv1EVL7puHOdRur287BnUnz7NwT/PireMF
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(36840700001)(46966006)(40470700004)(186003)(16526019)(107886003)(40460700003)(26005)(82740400003)(36860700001)(40480700001)(2616005)(47076005)(7636003)(356005)(66899021)(336012)(426003)(82310400005)(478600001)(4326008)(41300700001)(6916009)(70586007)(70206006)(36756003)(8676002)(316002)(54906003)(8936002)(7696005)(86362001)(6666004)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 08:57:04.4348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf485695-0cfd-4dd6-842e-08db70a32766
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat 17 Jun 2023 at 00:48, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 16 Jun 2023 13:11:05 -0700 Saeed Mahameed wrote:
>> $ cat mlx5/0000\:08\:00.0/esw/bridge/bridge1/fdb
>> DEV              MAC               VLAN              PACKETS                BYTES              LASTUSE FLAGS
>> enp8s0f0_1       e4:0a:05:08:00:06    2                    2                  204           4295567112   0x0
>> enp8s0f0_0       e4:0a:05:08:00:03    2                    3                  278           4295567112   0x0
>
> The flags here are the only thing that's mlx5 specific?

Not exactly. This debugfs exposes the state of our bridge offload layer.
For example, when VF representors from different eswitches are added to
the same bridge every FDB entry on such bridge will have multiple
underlying offloaded steering rules (one per eswitch instance connected
to the bridge). User will observe the entries in all connected 'fdb'
debugfs' (all except the 'main' entry will have flag
MLX5_ESW_BRIDGE_FLAG_PEER set) and their corresponding counters will
increment only on the eswitch instance that is actually processing the
packets, which depends on the mode (when bonding device is added to the
bridge in single FDB LAG mode all traffic appears on eswitch 0, without
it the the traffic is on the eswitch of parent uplink of the VF). I
understand that this is rather convoluted but this is exactly why we are
going with debugfs.

> Why not add an API for dumping this kind of stats that other drivers
> can reuse?

As explained in previous paragraph we would like to expose internal mlx5
bridge layer for debug purposes, not to design generic bridge FDB
counter interface. Also, the debugging needs of our implementation may
not correspond to other drivers because we don't have a 'hardware
switch' on our NIC, so we do things like learning and ageing in
software, and have to deal with multiple possible mode of operations
(single FDB vs merged eswitch from previous example, etc.).

>
> The rest of the patches LGTM


