Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC8D4FA532
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 07:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbiDIFjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 01:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiDIFjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 01:39:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB64CCFB8D;
        Fri,  8 Apr 2022 22:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRXF2ln872BEhzwG8+yPAdfuLx1Sd48aj8tFsVS8U5JjCBGBSH+NXTLSosEs0cFpbpXGsMmhOlzBppBHQFwjxcO9ENV6wKI6nf9XUXR8XcnKLzy6Pn3okfKapCc1KbJS5MM1g18sLh1ZO8Y9cVoCL5KvDj/HH4UeQKgwU0s/+v3dRCdtQEX1h4U+ABa09t0VX3ObKZr0vJNvKvmRNDN3mwbFA8nKEngPguv35e43kB4CbnWDJPRvwkaIxM0M6zUNnKx4zFY5H4+nsbtu+P4jrTkdM1C23vCTxOE+d+bUwvE5xxpnjk0pwA2K/eJZoHtk2f3s7NZ+56NA2VWnUT2Mlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wr0iqcjRdH22FXjWAO+0+/r2zJjV5AsSS/qQvpQ0auc=;
 b=jTjGZYelCa5sH0TeOUUDzA0c2ryJ713SU4U/enX8RrNNusp2bg4eToqbVrddICfp3ErJh1m60XPWm3XzERmKP6GSiYU2m5ebRIJlhLrgxRIr0cvkMRlLZBecY06rZbZINn4lf8LMqvF4yvMaR3rXJW61ta4UOCU84ipPNqv06/83sOX/ZD0gPeklgoJev8Sk4Q5MgBAWOsTdVmaaDr/676CziUNuOZNjoDsveXEA3rDCIwdraG/7djTN838V7YD7iynqbd8YG1nlTPg2llLd/U8405tZZhcX2ZJVdkPKu1t6AYOhWlR+zBeWOVk7dQXTEHlWcR3atyubOtILM/Rt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wr0iqcjRdH22FXjWAO+0+/r2zJjV5AsSS/qQvpQ0auc=;
 b=GN1AQSEBsO2CXEfrp/MqgOa5QS2abB5Tna+jGi+vcC+Et8mpi4YhTSvygvLPqiS2p9BIBFbr8p6bCs6vvcFHA4X71Z2nrlabHnSDRjIn0oj5kDJN9TrAsXQiu9DUPHHBa0Yd9Z0EmpmGETqIT5O+wNOQtUDk06kG1d8Q/ZP4GeFDAX56StE8c4pTVXZdjjcBMI2JK0xs/zNgdOtI8AGL7sW+J7j0u7xAUmT1kZnc9QRUvtZ3ieSFV7J1fAS2mgpU5kQZKB7LysDzsR33J0wUnu2TYJBKrdguElfIsr0vVhvcELihRLkVj8DOB+sF6lpt9Iwjf9EH2vzihK1E5mm35g==
Received: from BN6PR17CA0053.namprd17.prod.outlook.com (2603:10b6:405:75::42)
 by BN8PR12MB3489.namprd12.prod.outlook.com (2603:10b6:408:44::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.27; Sat, 9 Apr
 2022 05:37:31 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::50) by BN6PR17CA0053.outlook.office365.com
 (2603:10b6:405:75::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26 via Frontend
 Transport; Sat, 9 Apr 2022 05:37:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Sat, 9 Apr 2022 05:37:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sat, 9 Apr
 2022 05:37:30 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 8 Apr 2022
 22:37:28 -0700
Date:   Sat, 9 Apr 2022 08:37:25 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 00/17] Drop Mellanox FPGA IPsec support from
 the kernel
Message-ID: <YlEblcbDzcFGYjM3@unreal>
References: <cover.1649232994.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1649232994.git.leonro@nvidia.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e1e3366-a12f-4d7e-5be1-08da19eb0ab8
X-MS-TrafficTypeDiagnostic: BN8PR12MB3489:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB34890BFDAE059DED934C8BB0BDE89@BN8PR12MB3489.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUS/fAW1kxvxXhvVyGpf8gtobmTefpnazGeKwTm1A2AfAFMp89Jt+9G4Walhjjeo/z3G9R+s8CKQWzrL1Ei9tGF/pe/ecDvb5Pnhi4xGB2LsXrbvPiLE0Bn+xJYP5dYh1Ym/T6VslRH2BBoXiO2/UmZ7BFVRZyMiVK06K3ckF11kNw3QmG0oXgItoUdyMLipQivyU3rO6SmM6R1OyvsMal8hN62Dj7c0IRHdcry3j/6+2kTq1cSA2iacJ741BUGXdsaK+z//NvRfGMW7hYlK2qc1tugQCmDzNZBxEsB+IfpCR7JHaB3wJFowKKto04Bz47JM3IvLiorfbISXOavX0MhQlYwbSb7pb/9Sf8f0lBLm2NlN+Hbm/yAqOOzABD6G17sCI7RbHncbDK21jSKOUQEwwl36IraKM3VP5eLU2rtLlLISxncqZqUgZGwWjSROWNgVfJoBQbaE+xHpFmMmidq5HhVnQ4DylKNQOidaRv13sU718w1nJWR5pwFgkqeLvs+53Eo/nVk9TEGzmAokM91vo4LRraO15zFhYUymM+h9ImuJtgAhCLnXzyCPts9iixMXCZPH+n6liVpa5O+C+wJjesXWr5KoPGksH/JyjjFowo26jhN5UL+gv4BjAmDxk/Z+5WCTjYaJgK5w22kFhTTOgkOaWfSs2ECz4V/0ookqQTxabtDE8yh1a5VHxDG/OIPMyzuQMPReqloI9JZQsUVgmlhOzH5L8Cu5OYyVayqwGNb3bikIyODKLsSyEdh8Cy6Ix0Fd0ix7lYaw84o4ioxEIVb9HaYH6dD6VGYVMCY=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(40470700004)(46966006)(36840700001)(5660300002)(9686003)(8936002)(107886003)(110136005)(966005)(508600001)(2906002)(6666004)(40460700003)(86362001)(356005)(36860700001)(81166007)(33716001)(426003)(26005)(336012)(16526019)(47076005)(186003)(83380400001)(316002)(6636002)(70586007)(8676002)(82310400005)(70206006)(4326008)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2022 05:37:31.2647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e1e3366-a12f-4d7e-5be1-08da19eb0ab8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3489
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 11:25:35AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Together with FPGA TLS, the IPsec went to EOL state in the November of
> 2019 [1]. Exactly like FPGA TLS, no active customers exist for this
> upstream code and all the complexity around that area can be deleted.
>     
> [1] https://network.nvidia.com/related-docs/eol/LCR-000535.pdf
> 
> Thanks
> 
> Leon Romanovsky (17):
>   net/mlx5_fpga: Drop INNOVA IPsec support
>   net/mlx5: Delete metadata handling logic
>   net/mlx5: Remove not-used IDA field from IPsec struct
>   net/mlx5: Remove XFRM no_trailer flag
>   net/mlx5: Remove FPGA ipsec specific statistics
>   RDMA/mlx5: Delete never supported IPsec flow action
>   RDMA/mlx5: Drop crypto flow steering API
>   RDMA/core: Delete IPsec flow action logic from the core
>   net/mlx5: Remove ipsec vs. ipsec offload file separation
>   net/mlx5: Remove useless IPsec device checks
>   net/mlx5: Unify device IPsec capabilities check
>   net/mlx5: Align flow steering allocation namespace to common style
>   net/mlx5: Remove not-needed IPsec config
>   net/mlx5: Move IPsec file to relevant directory
>   net/mlx5: Reduce kconfig complexity while building crypto support
>   net/mlx5: Remove ipsec_ops function table
>   net/mlx5: Remove not-implemented IPsec capabilities

Thanks, applied to mlx5-next.

2984287c4c19 net/mlx5: Remove not-implemented IPsec capabilities
f2b41b32cde8 net/mlx5: Remove ipsec_ops function table
f03c7b183ef9 net/mlx5: Reduce kconfig complexity while building crypto support
16fe5a1c5c07 net/mlx5: Move IPsec file to relevant directory
54deb0e77561 net/mlx5: Remove not-needed IPsec config
a6a9eaf14222 net/mlx5: Align flow steering allocation namespace to common style
2451da081a34 net/mlx5: Unify device IPsec capabilities check
5a985aa3c922 net/mlx5: Remove useless IPsec device checks
7e4e84912139 net/mlx5: Remove ipsec vs. ipsec offload file separation
32313c6ae622 RDMA/core: Delete IPsec flow action logic from the core
de8bdb476908 RDMA/mlx5: Drop crypto flow steering API
74ec29bdb0eb RDMA/mlx5: Delete never supported IPsec flow action
0d90bd551446 net/mlx5: Remove FPGA ipsec specific statistics
3c811a6b4552 net/mlx5: Remove XFRM no_trailer flag
501a9b23b23c net/mlx5: Remove not-used IDA field from IPsec struct
df439fcb1cd4 net/mlx5: Delete metadata handling logic
2fa33b3518a8 net/mlx5_fpga: Drop INNOVA IPsec support

