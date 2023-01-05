Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3654965EC31
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbjAENHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjAENGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:06:52 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E531D5B16A;
        Thu,  5 Jan 2023 05:06:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GUp77usC7Dg0tYJwYb5Wu2ofA1IrWHwnD6huYRlndeYSqfvwpaSioUhj5XdRAaWvZg5bl9UjIRbzJL7MMNRmGtOr8h2V0DKkcw8Au2y6sg0C/2qJ7h3ppHlpcYmkrrj14/HoA3AIVglmORsVfirlt7RIod6md8/l8yxqbUns9FmoUg6K6lDP0JNnj2gbk6eb798fSVuKYx4QkdmWJkOxF1/Rd8+qfdnPCQU/XlocIunOh51wijjLvbpbio4cVpdf3wmVKNKXAQxlfE0SFOPTWi4rBTjZ6AR4BUuNrlgnsd3gx7mWimegj8wdJTkIXR/x60T9imeUyU1zp4fEX5Ojwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAv6baPqiHhHGTglpKnQCVTH+II5dWDzWRXAty4+/m4=;
 b=OP03zuwR5vxd0XpAoIaWFEcw+79OgprMsYzAZCjRzXXjsxvDbzYxZaMMPc4Krg9mg22BYVhcLsAVWoCEdIOwfj/kfM7BB0P+hQwFuAElGR1G8Yt/a7ufWg46iDLrhf3dSNWZyz+ZfyiRvL4t/WvKLYXIXd4QJ73N/UmLAn9Pr0dky1luF6mKk0jcSAgqC1Y320+ldWW7PLWV4DQGhfTCI+9I42/bhtFJeDw5R68/Wh8hdaPCtbgILfYavP7tQBD5Nx5YCpn4GUuHu0N+r/wRC1V4KbZwOEL1Euy+R7LLT0MdU8vBalmfRmqjJKAGz9cd4Kz9NBsgX+ilypuukCeOvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAv6baPqiHhHGTglpKnQCVTH+II5dWDzWRXAty4+/m4=;
 b=HrKnFxEVrvPXvmA5ZNOYifGxnDF8+EhSxSbKe7GAYONyPnxjMtqBSxBNLyBsf/7aBbWB3HeVr5GCAncacY3akJcrt/KO3pFRN8qwmER4n2s5wiXgXOrGrnADuuZDOpnF5+O+LM5ZmRLW2VGkabMplIQ6/nVxHkKojBCfibnaPqdFjnUnjDoL3uEoUaIQ3JfhQw5qc2mxJsEDO/ZfFdq0MJUGsvB4Wi9dTamXEF96YzcjAb7r0CuRU4A9IHdqESOvQ+wzEBi8CdJ1BpvYckL6gjijU04s8FK/jZOnBBv5o2L/dM1AjXq74dWVDKlMP2ilGHGmIfmNBofxG7cqlaUaxQ==
Received: from DM6PR07CA0129.namprd07.prod.outlook.com (2603:10b6:5:330::23)
 by MN2PR12MB4239.namprd12.prod.outlook.com (2603:10b6:208:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 13:06:49 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::6) by DM6PR07CA0129.outlook.office365.com
 (2603:10b6:5:330::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 13:06:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 13:06:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 05:06:41 -0800
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 05:06:40 -0800
Date:   Thu, 5 Jan 2023 15:06:36 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/8] net/mlx5e: Fix trap event handling
Message-ID: <Y7bLXOfAuBblWbLd@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
 <20230105041756.677120-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230105041756.677120-2-saeed@kernel.org>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT033:EE_|MN2PR12MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: 37c2d978-55fe-4f53-1499-08daef1db4cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEdJuTwIIAHBe8i9gv6cxUH7xnH/bGDT1t/EenpT58phSYNA6U7SVnLNKCTdGcbTSmmGS4SQxN+MAw97m4kni5yWVIQRqkc4Sn+qfJ/tN/U7cqd9xVjxTBB1c7AZrhDot3XTtBtZ6gPjJc/ULBTPKUPQ8IQ3m3jmgn5AWwjDP6ebwizXoeuZOVocQlb5u9U4hpVJkPn6mF8+GGMc0AgZj+qy3d684GLlw4dT20h6IG6vnCGyKwptp7+Mn7F44U5cb3cbNDGkmGSa+iRPRYJrJ9UpWPhayOETg6UqArcNrBu4RP2/V3RaUV2ME23ZDSvzt30mxoBO0LsghsmNhkeQny6P28UzhFSC/Ck2YxI0/G2AY+PtmYpdD90b+TCp8X/9mydPpMuDKmoZ1Ht/aqfFrHwyBmgNVkVFXfLPWK528cg5U25xg4JgQMDLzgFAyID9+KwI4j2eegVX92taETOY5NYIlTHsZt/nq8DKx2+FH+npVCwn0RL4XnOiGQVPfPRmKkV+fmzMbtuPlbvhf0QKQzxGZRG2q98GFbR4WUF4hfWarmIErm7LcXZH9MfX17SvjMmdi2W3pbc9e6lp8/huTAMrfjkGnm5IqpBNiQma4LA5Goe6/nv9I1EmjC7pGwK8Jl4oVhRD/p2GgWPK69V3gjvFjkP5UWO4rX2zezXpH1OEDPjgbBhCAc4yiItG051mf5aij7qYW0wm5ub7UFNXXQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(36840700001)(40470700004)(46966006)(336012)(36860700001)(83380400001)(33716001)(47076005)(426003)(40480700001)(86362001)(40460700003)(82310400005)(7636003)(82740400003)(356005)(4744005)(6916009)(2906002)(54906003)(41300700001)(5660300002)(4326008)(8676002)(70586007)(8936002)(316002)(186003)(26005)(478600001)(9686003)(107886003)(16526019)(70206006)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 13:06:49.1082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c2d978-55fe-4f53-1499-08daef1db4cb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4239
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 08:17:49PM -0800, Saeed Mahameed wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Current code does not return correct return value from event handler.
> Fix it by returning NOTIFY_* and propagate err over newly introduce ctx
> structure.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/devlink.c |  9 +++++++--
>  drivers/net/ethernet/mellanox/mlx5/core/devlink.h |  5 +++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 ++++++++----
>  3 files changed, 20 insertions(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
