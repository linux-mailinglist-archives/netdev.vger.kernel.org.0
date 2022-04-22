Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17DB50BF2C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiDVSCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbiDVR7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:59:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66BB9E6C62
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 10:55:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJ3drlBMS2NnU4GgqDdStLa4eIL5U5NXd4RL6pSUX0xUZXFv6VFEipFBjNQ6ksXE7alZFTQh0XR74vJ5qJIGKqgTmHxKkFEu6Tek9pY/O/nH6LXDk6he909dm2/pnHJRbSGl3ZFYdEpNbnN2OqFPBBOTm3TUuAAEMbJC989ZmEC/aumUoiy2xjlGBdHcM2wZFQlYD5n/7xBjFB30KGskYc2uZREQMn77UrVR1AJYWTuWiLaNSnZSBqqRVWvHxWZqAyDvvsTgHjIVtG0IqNx4R8kp/nUWgCYdxFbIBvzJZSt9esD4XbpdiicZJDIRTvxNQWoLzQKn0zZnrtsFX8sW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2OF2agry62ohz3IpE/VhHFrrqdH7l0Hx3YtCyqkCbs=;
 b=Z2Ce/r5dfgTcelLR/3cQXb/VOLuqIx7k1pOZC2n8Lvu8IEmW8B+OZ9CNUoEV4xbQaDvjwhldNe7/ACClO7qLSa+fpPFU+KymsoBstcKjcfgJAl10OUlpr7uPXsjw/jfN7s4eMRqzAxWT6Ps0tVVmx/BbAIoIlDz1K5udnup7rKk6l2w/bmtgWFD/JaQwaWMveMMp7rOTFgEPS9lKfud1nP875XLkMKJFYeywqoMQiQHD9yZgyWL5e9dAzMe/jdpXkLBhCcXenYwC9JRV+IIyY41LagdHdxSDQxfRKtvbVvoDkgwv1NXg1bzrJO4XqmKNHKo++f8oWmwOCg/7WWpokQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2OF2agry62ohz3IpE/VhHFrrqdH7l0Hx3YtCyqkCbs=;
 b=Hc0v9GLutEKodvIu9rCaELeWp7IxHgMl3CIlL18GnP2VFD/umQjGaMKD6pEOSCAPHa46XFodSvfrCuo6UNRMaT3jPGP7zG3cOi3jsqzTTGfP1upU+OBe2KfOhLKhvrFx7z8zb6IoyMxvIxQOWaN7Cci7Bn2TDc3PjSpY+PeFgcng3Lvnc0ErltqpZVWT8HcOgo8ogHIsyLNhh/AXB4r0qG7YXvYRB4o93rlqIHiY0dO8+V7EUnr5WMVRnaONJT2LgLhJicf5izsNXqeqn0PgPF2JoNEspGpCvNrEwoobgFfUrb0Z5sxGnzpxfIec1B1arRJXAW+F7GiveAXMSs0kWg==
Received: from DM6PR08CA0061.namprd08.prod.outlook.com (2603:10b6:5:1e0::35)
 by DM6PR12MB4060.namprd12.prod.outlook.com (2603:10b6:5:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 17:49:34 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::e1) by DM6PR08CA0061.outlook.office365.com
 (2603:10b6:5:1e0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 22 Apr 2022 17:49:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 17:49:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 17:49:30 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 10:49:29 -0700
Date:   Fri, 22 Apr 2022 20:49:26 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net-next v1 00/17] Extra IPsec cleanup
Message-ID: <YmLqpn6v/HIipias@unreal>
References: <cover.1650363043.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87905ad2-0c1d-482e-fddd-08da24887614
X-MS-TrafficTypeDiagnostic: DM6PR12MB4060:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB406061D3644585F4A913FF39BDF79@DM6PR12MB4060.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tymgpRN6fgzJMfyaHFS5w2/ukw7h52TtctH03EBs+UpkC0duAOkJPlJpL1Ob8iXL6+ktC37Ksi6T3gcJwPq4BfKmm1fU8SGAGyPRIysn4fExW0FPmyqOgbjm2PiyIssDuYJ6YmghMM7UEVkP+xvCWvYtFwhf7+M4oLDCuze72lMCEv0xdsOWNT5uuSk5/0y9u6BwpV/ufyjh9OwhpG3VZYezjoN6EABgXhLgQOwfJyKPDU/4GsRDxeuwhH0ip5VSUv0sR9mC+w3jQiQM3ZsK8xfVvn4N5z6xEM3AeyJbAgaTmMfxEt5SRPjLPhriDKc1RoBiWQ0ECN4EMKKNzYW4n8razgKGZBiKerVnIN10HxSzeHV85+r8G1wI94td9LU6AqwsdnJA+rEwwgAtqxRZVxXX1+WOqh247N6GAqxFqJurUI2NXKeDjrnZpOfbvNbr7nt2F/uk9G/8XTSv5afGRudaO+OViCZlqaulfmzs7btS3dBf8BenCLim3vMwXZqF/lFXodITpWZ2+rIdubt8Rax9DaZGK9y3+Uq7T2OUiyIbsHfa853aCU49gSD23rpF4/pCPn2zGSPwDJEwkpZABzbmUKk8OiM+bJ7rV4uQZSdTFOZ8eYl7o6RycRT0qGxOGQJjGys7GQ4l/IZEo5EjfJNT/fyOreJEj3Fho3DHT/fhDDHYGkBRIV5dJnNydAZ0K+ewKbHxI6P4tWU6TW4Csz2OFcvX5CAbVo9VRkTSBi0IbWz8Tnud9lXHrIZcGrvXN+vRV9CB8RNeg+tnURhLCEoBwy8WO/pdLycwZ/g6r7w41dMxwqPPpRkZ4y/cEpoW031LGCWDW8BuCUEkoOmszw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(7916004)(4636009)(46966006)(36840700001)(40470700004)(508600001)(5660300002)(40460700003)(86362001)(70586007)(70206006)(26005)(9686003)(4326008)(8676002)(966005)(81166007)(33716001)(356005)(36860700001)(83380400001)(8936002)(316002)(6666004)(336012)(426003)(186003)(16526019)(47076005)(54906003)(82310400005)(110136005)(2906002)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:49:34.0335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87905ad2-0c1d-482e-fddd-08da24887614
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:13:36PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Changelog:
> v1:
>  * changed target from mlx5-next to net-next.
>  * Improved commit message in patch #1
>  * Left function names intact, with _accel_ word in it.
> v0: https://lore.kernel.org/all/cover.1649578827.git.leonro@nvidia.com
> 
> --------------------
> After FPGA IPsec removal, we can go further and make sure that flow
> steering logic is aligned to mlx5_core standard together with deep
> cleaning of whole IPsec path.
> 
> Thanks

Hi,

I see that this series is marked as "Awaiting Upstream" in patchworks.
https://patchwork.kernel.org/project/netdevbpf/list/?series=633295&state=*
What does it mean? Can you please apply it directly to the netdev tree?

Thanks

> 
> Leon Romanovsky (17):
>   net/mlx5: Simplify IPsec flow steering init/cleanup functions
>   net/mlx5: Check IPsec TX flow steering namespace in advance
>   net/mlx5: Don't hide fallback to software IPsec in FS code
>   net/mlx5: Reduce useless indirection in IPsec FS add/delete flows
>   net/mlx5: Store IPsec ESN update work in XFRM state
>   net/mlx5: Remove useless validity check
>   net/mlx5: Merge various control path IPsec headers into one file
>   net/mlx5: Remove indirections from esp functions
>   net/mlx5: Simplify HW context interfaces by using SA entry
>   net/mlx5: Clean IPsec FS add/delete rules
>   net/mlx5: Make sure that no dangling IPsec FS pointers exist
>   net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
>   net/mlx5: Simplify IPsec capabilities logic
>   net/mlx5: Remove not-supported ICV length
>   net/mlx5: Cleanup XFRM attributes struct
>   net/mlx5: Allow future addition of IPsec object modifiers
>   net/mlx5: Don't perform lookup after already known sec_path
> 
>  .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   1 -
>  .../ethernet/mellanox/mlx5/core/en/params.c   |   2 +-
>  .../mellanox/mlx5/core/en_accel/ipsec.c       | 174 +++------
>  .../mellanox/mlx5/core/en_accel/ipsec.h       |  85 +++-
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 362 ++++++------------
>  .../mellanox/mlx5/core/en_accel/ipsec_fs.h    |   4 +-
>  .../mlx5/core/en_accel/ipsec_offload.c        | 331 +++-------------
>  .../mlx5/core/en_accel/ipsec_offload.h        |  14 -
>  .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  |   6 +-
>  .../mellanox/mlx5/core/en_accel/ipsec_stats.c |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 -
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +-
>  .../net/ethernet/mellanox/mlx5/core/main.c    |   2 +-
>  include/linux/mlx5/accel.h                    | 153 --------
>  include/linux/mlx5/mlx5_ifc.h                 |   2 -
>  15 files changed, 320 insertions(+), 823 deletions(-)
>  delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.h
>  delete mode 100644 include/linux/mlx5/accel.h
> 
> -- 
> 2.35.1
> 
