Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E1165EC4C
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbjAENIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 08:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbjAENHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 08:07:39 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8618B58310;
        Thu,  5 Jan 2023 05:07:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/+yxwdGYbgK6lzm80tkqnbFpCs+dz3NKN9ZusXY/+aRDYhiNA2qGM6WCUKqhWjH9SstWM0e+RePMV8H8SJtCR8o7Do/X6qkR2JHi/pmFE6MEMNdQ62594lRIghI+HZdvezgOV/kuF/EAqgXe0ZV/Oo86PSYssN4D6l9dH8r2BSCzj9yO5BkJzsVUsz5La4uoQEHX/Rfh1mUNin4t6neW1DAynq+bJHAmbJOG12Hxft8sGKM/BMEotOb8XB+Tf+8EqH/lXbMY50GohL+Zxh23GcBmm1eFg/1wEBEkgX8LJFOfrLJr+XGGej63vqODsD/OSqhHMKvmoyJ820c0vmmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgp9FdLhwMD0PwW4EcaepomMJU0SUQgwgbohkWp+ln0=;
 b=cARm3ZPC0cBdUtx9ujuMr3qPDmCWsImh2YuqYBfzqtA+Yr1E77F/FAx4sXHpRKOMup3BUkZT6RJsWsnt85MkqVE5YTLwcmzrsmcIUqfEt5G6AT4+WhCEdJfagWZ1XpViTfLYJhIgOLUd3OfEmOYaCv84d9KiZCqgnh3Oidguhb829ROgFjKckeUMHerRUjk5hvjhe1sskXEPi3/SY5y4f/84IHHYKx1LYKBpgNAvQiOnOMN2Uy+xehq9XL2eLPmWVYb7ClQr6epJm8TSVfIEWEqBUST7gU2MLQiUOyk3+0M7ZE81Cz/SSU7iYED++Iq+xpgYs6hA5oYZ7hsE/mXafg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgp9FdLhwMD0PwW4EcaepomMJU0SUQgwgbohkWp+ln0=;
 b=ZHW9rIjSyorHi+LKmjxjQ4nOHRZs56FdG3dJQF7ynNVt4JppX+BXmF5pQSyowlRYurk4EXU7NecrdHMRlzrLCTfCNgXCrIW+ff9AuE6UQpsCmZ8ycKc8ncqd31UCKsz1u/nojzSWluK+neVXUDAfKW+OOpQQYCvTwAWPpoeqoRTjYOnCCXulWBML4skdjF9FdWGn0Ef88LSA/3uy94Z/IiVTUI+b1/7QAqCZy6aC2SfHhbJkAFLJ4tqgEJbUEuljdFBU4uZt5jirEySfsSwAB34aj7vKbmRU+cNWWBHmIBFUqXVUvHi8DxtsTX4wVcd1ttU3r1bnd9gkWLav/SJ2ww==
Received: from DM6PR05CA0058.namprd05.prod.outlook.com (2603:10b6:5:335::27)
 by SA0PR12MB4352.namprd12.prod.outlook.com (2603:10b6:806:9c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 13:07:26 +0000
Received: from DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::45) by DM6PR05CA0058.outlook.office365.com
 (2603:10b6:5:335::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.6 via Frontend
 Transport; Thu, 5 Jan 2023 13:07:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT082.mail.protection.outlook.com (10.13.173.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 13:07:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 05:07:17 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 05:07:16 -0800
Date:   Thu, 5 Jan 2023 15:07:13 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH mlx5-next 2/8] net/mlx5e: Propagate an internal event in
 case uplink netdev changes
Message-ID: <Y7bLgdwHfVE3Hdsg@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
 <20230105041756.677120-3-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230105041756.677120-3-saeed@kernel.org>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT082:EE_|SA0PR12MB4352:EE_
X-MS-Office365-Filtering-Correlation-Id: ad57101e-c5d2-47e3-e574-08daef1dcb2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tF5ktt9UVEQkQv7hcD2nukbt/3pIfwfkErEsHJTvc3cK4tYXirgkvcBTgZ5RkHXToOKPB+k/4qoOmyAESDS3bvAAm9flUDXjnMCGXNu7F30vrj8WkUOlJ4milKNOibofTtBTXNdQvRh010Ve0Q8yqMgJVeeuOGlocdF306x8tWCkKK9lQWGnszOg4aKN+wTCL59rLROpdnPAvGQMG7NN6DmS7vfo4CiJSDPQOoGx3/9VIl/Sp9SI0VVfTDrjNW9AMf6qkhCRYtEimXV+ENrwctloOGs64Bogk2oIcslS7g54AsxHannqt5rpElO+/LUZsKB8qmXyB2s213SrJj6WP5XXZ5yJpldArgeTkXlhJ3mkM+8cbTI8czSiFuV4KfTmhauzwf1ejlHi7RyUJSp9gl4f6gXRizMBUPO6F2pkLTzr7z+9QuZ6iLyHmjCSbQJrcT2KLBceDiwerg5w9nxTwxVoxatn35PNKSJoOMLSnqUGNvVHwnn8i250W95Mr+t6bo1/2ZgSPvy+XVhGm2j2fp74yxTB1HOXOE0ma55i5MOFk4iD8SeY7eet8iQEMwCWpnXKvfINU3w10SS887g5JaV26QMfk1tsaAnID4kNAnewukhNtdr1FzX78/envZaOyXvaUYP9Uv0w+ctal7Vau4uq4SVdgZwEvHd1E5mCYK3c23Q5HzE862sasfMzey/vRsgVIsuKZ1C34e1+cxTxHA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(346002)(136003)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(47076005)(426003)(83380400001)(26005)(16526019)(107886003)(9686003)(336012)(82310400005)(33716001)(6666004)(40480700001)(40460700003)(86362001)(36860700001)(356005)(82740400003)(7636003)(186003)(316002)(4326008)(478600001)(41300700001)(8676002)(4744005)(2906002)(5660300002)(8936002)(70206006)(70586007)(54906003)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 13:07:26.6682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad57101e-c5d2-47e3-e574-08daef1dcb2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4352
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 08:17:50PM -0800, Saeed Mahameed wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Whenever uplink netdev is set/cleared, propagate newly introduced event
> to inform notifier blocks netdev was added/removed.
> 
> Move the set() helper to core.c from header, introduce clear() and
> netdev_added_event_replay() helpers. The last one is going to be called
> from rdma driver, so export it.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
>  .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |  5 -----
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 20 +++++++++++++++++++
>  include/linux/mlx5/device.h                   |  1 +
>  include/linux/mlx5/driver.h                   |  5 +++++
>  5 files changed, 28 insertions(+), 6 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
