Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945D94F5B8F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 12:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbiDFKkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 06:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242168AbiDFKjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 06:39:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC10D4BFCF;
        Wed,  6 Apr 2022 00:04:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkpGShSOtrQdXXXpqlQiKIJIBo5tayg8Sdbp3Th3aglL1UZKTwJ4M2cut0cYgMX0kTWv+uGd/oxE3eoL6D0DbufwJ+tOYN1jQrGYXATow/T9Hw3xJ8lzeL3Rdr4wpjtZizJ1ghU9QmlLVB4+8izpG9+wVkqq1v4j8TrTgj+tn7tUFA6CiwHbjeNc44E8J6/2RIcbKc8cbZHg0iogB4uZA6UBY+axbkANrgyxZ1xkxvIvD3z0t7dw6B0G3Na/4keOLlMjVQ1xkvA88b6dsKkkNGJ8cn5M5UaDbmR71GuXcA5Acflr3bBxHmgGQ5DgCofQEdsaC3AVxqPkZXCz+mzi4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2em0mDVlhltllKvMC+54AC2/kYS0S1+Cpug54H6ZNwI=;
 b=JmlHrfyaFgCVOCLh0Pb+RS/r+qyV3cqoHqHhMDYf4Sc1tieaQnMz3CqPzmMyqI/C+d6p5ZmQgL0YQHcHYQNgU8KGi8GuyKwE7wayDWjSGuWep6LZLKg7LSUrEfs4DaZ3gCEcEAIQAZ9JeaVY7VNXX6HkbEWqaBs4UuT1GMaKu8iyZ7bDrWUK/Tv5jNMUJUe51n/HGdLSGHAl9djXK7sE9HzGDKqpVyFIZ0TEGPhrFjYZIMUXSsoMihsbmPBd1OuaNNnzhIw+cGIVLqQ2xErT/2/ckDMUhqb/UhPotK/mTQWlIQwZNW41uHPG4WyEKE6eueYgOa1MYRysO0h4KURoOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2em0mDVlhltllKvMC+54AC2/kYS0S1+Cpug54H6ZNwI=;
 b=tTFEfIYHfZwCAdNLFxm1LZsr9pvuMawERZ9OKhBfj7MJf1Xj4TnTO0Kr8nU6dtgS5DzaG5TkiJdDE0ECLPw47CzMvOgww9cGxdNUQ2y1meds+o++OVzYj2Al2RueGd3Is3zdosAvtpNnTX145qH5iCRM2iw/hM3hScCsf6P31lhamD6DNkp6SRvpZDP0WxLKW+8MWDEISNrNA1GZ/CWsmsIcPdHss1edXhevPcoJaslUAoAtLwRCfBLmST2WoO8bFf2fStMRP+wa8sdsxgqzGlbkkHxBZsUDAPdqvkoquvWn/6ys7HSDSp2q1b1rSPLyZpNyD/weRhxIO/QRE5XiYQ==
Received: from DM6PR07CA0050.namprd07.prod.outlook.com (2603:10b6:5:74::27) by
 DM8PR12MB5479.namprd12.prod.outlook.com (2603:10b6:8:38::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Wed, 6 Apr 2022 07:04:24 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::b5) by DM6PR07CA0050.outlook.office365.com
 (2603:10b6:5:74::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.29 via Frontend
 Transport; Wed, 6 Apr 2022 07:04:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 07:04:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 07:04:18 +0000
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 00:04:17 -0700
Date:   Wed, 6 Apr 2022 10:04:14 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/5] Drop Mellanox FPGA TLS support from the
 kernel
Message-ID: <Yk07bqnHhuT8QjS7@unreal>
References: <cover.1649073691.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1649073691.git.leonro@nvidia.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1725ea7-03aa-4ec2-5aa0-08da179bab6f
X-MS-TrafficTypeDiagnostic: DM8PR12MB5479:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB54795A366C3E9D3D7876D056BDE79@DM8PR12MB5479.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zX81UJObQTxWIX2OE5r381kRj3qWB/3fdIpqWnKyYsuLgIxGYQvjOmPHmfN9duLnZJHBkrkumFy7HLgriLX22k7DL59XtseLXJQr6TBWR3XHPSGV3h2rvVEHp2xPYW7Ok/tM/xzDVrQ4YSlwMsQjiNKzgZzwAGu1chDip5S9v2/9cR5ktgRDvzo280UfzMU8XtaBhtEkRZO6ycUQDmlCJ4Up75zSc8zo0RbcP8YqBLn96jZwnouP5AIEavKvaLRVJ98f9/GD+wIbMyz2JkxvlA13SAuPMm5APDSFZ9WOW6w9FUUI9GYiSS6fN+dDN1Cgg3EkmS/YH79OZmHAukGbpZQsPl5MyIHTpFcEhc+9D+J+A2b06rt2ZpKa0k0pXS6a6EouIfFZZ5T4h/RJ7xwrPPH59LqQtacZjzqwDah3oB4giLa4aNTEsfEeZTP1U4o3wYaItDkNSLiqNFiK0oE8h09O3gRASsVYiJEC84zg3emCmKGcE7KQiETEOuu9U59pc0ObKnEzIFi28ShZYXZHPoWyPLi6rnMzbqtnXoAxyQu402sePYTl6aIS6sbCRGscT+hvVBXev/cw+xHd66xHfAwkdOsdKsGxCeWMDLnw/TQmhNvExTZXxvyez7yF1g8y/V3zJXZpdvL2q5NojviWeSqA56EXekhN78lj/uasOkxElg1J/gaYNqaT/H7EYFBK9w1ae4UuUQ6R9DnRt3UWGocLybbgvxTeBKwpiJWqE8pzVTstoJIo2pT9mr3XbPdr0SiG/Y26gKkFAvOkcwkCuMuZQZe0Q1G10zmeIce+D5U=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(46966006)(40470700004)(36840700001)(8676002)(70586007)(70206006)(4326008)(2906002)(86362001)(356005)(82310400005)(5660300002)(8936002)(83380400001)(81166007)(36860700001)(426003)(6666004)(40460700003)(16526019)(54906003)(186003)(316002)(47076005)(110136005)(336012)(9686003)(966005)(107886003)(26005)(33716001)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 07:04:18.8667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f1725ea7-03aa-4ec2-5aa0-08da179bab6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5479
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 03:08:14PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Mellanox INNOVA TLS cards are EOL in May, 2018 [1]. As such, the code
> is unmaintained, untested and not in-use by any upstream/distro oriented
> customers. In order to reduce code complexity, drop the kernel code,
> clean build config options and delete useless kTLS vs. TLS separation.
>     
> [1] https://network.nvidia.com/related-docs/eol/LCR-000286.pdf
>     
> Thanks
> 
> BTW, the target of this series is mlx5-next, as other series removes
> FPGA IPsec together with relevant cleanup in RDMA side.
> 
> Leon Romanovsky (5):
>   net/mlx5_fpga: Drop INNOVA TLS support
>   net/mlx5: Reliably return TLS device capabilities
>   net/mlx5: Remove indirection in TLS build
>   net/mlx5: Remove tls vs. ktls separation as it is the same
>   net/mlx5: Cleanup kTLS function names and their exposure
> 

Thanks, applied to mlx5-next.

7a9104ea9011 net/mlx5: Cleanup kTLS function names and their exposure
943aa7bda373 net/mlx5: Remove tls vs. ktls separation as it is the same
691f17b980d0 net/mlx5: Remove indirection in TLS build
e59437aa7ae6 net/mlx5: Reliably return TLS device capabilities
40379a0084c2 net/mlx5_fpga: Drop INNOVA TLS support
