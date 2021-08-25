Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC93F7161
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbhHYJCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:02:19 -0400
Received: from mail-sn1anam02on2069.outbound.protection.outlook.com ([40.107.96.69]:48391
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239563AbhHYJCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 05:02:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pgp7IBDh9Xe91c3aNnbLJCXUlBxFBVILgni5RJma1jiye0vVegbNAfvdV2ixa7VJc8RiTBG4ZOgz/yHVkDIxsRR+QTTvrdC0YN1se3CI8gUS62KUvcq/bH6FmQgan3of3YoHfPvNcB0Wprz+03kfOKo1o7KSeBV6f8o0zId9StwfKdB4u2opDHTAoBTcLIj+HS7tBaEGifqFSlgtYXePyjf/ZCx3GfCvWuClCOaFZ/SnzjJJX2iGqBCmmBjPgbbH10C/AX0RwRtpqz7uscrnMjfmNhgqMzX2kusuYsJoZUpIuyi5dtySNYa2IRI0rYnca0kXtrCzMUPZOMAiWv8+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdmDYf8ei7Uq6X129vGEpTA/IrC1QBhdXKcA591Boqs=;
 b=SzB6ssy+6Pfy1VJ1KglYgGEfq0Tim6cCA4iwA5uvdE3OTR33+iJUGJN8uJrvvr30J9ilYOub1NeUJfqYYWMh/GBi5XlPytR+jq+3UVA3o503jVR4a1PBlQ4PFAm/Q4LqYZ+4ywrSl96/1ZRZUAViXtE+Rl/znIsIweEdHgdaQ8cny6GeGgIbH7VrB484vd8zxW1PxQ1nyw1Y1jYxtO/CD11T3SZVk9ZR1mB5qkseISyy8IYJBcF6rU4U04KYwkNs5HdIhhnLTQ/DeHjN1ChL0DHHAxplKks2fsSuEIw8LHPMt3UO4zgGQ9PWhyLNmql6hpQY5aeftEmXbE0Z0puheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdmDYf8ei7Uq6X129vGEpTA/IrC1QBhdXKcA591Boqs=;
 b=tc+YmP6NBI01zcQ0snFfUBwoej/5payfEKyIwsJfm2ANlcGmW7X1EKaCw4LWSjsWDdO0gdaieRL4mKFIZHWQnQfASp1SU/AFJsmbBIRg7UpZsIeSrz4st3ikd5JzTamo0w7lC6T8wgxP8BsytzNsdHi8lVWiQIf42ON0Tb9eLpAnPyGt05w8jZM+WJYSgbuB0eXS0c5bjTxirX4Fywc0fK/gql8a0Sq4nWbvm/UDhwlPTadzXupgB+ZCsZp3WK+vACzGpK5PC/4mz746kVCaMILKLAN9n8ZVo4Eo7VP0FwF8NqPn37vQh3JvcRUOW+0dsyMRyjX9dd1ndqeyeFTfpg==
Received: from BN9PR03CA0110.namprd03.prod.outlook.com (2603:10b6:408:fd::25)
 by BYAPR12MB2998.namprd12.prod.outlook.com (2603:10b6:a03:dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 25 Aug
 2021 09:01:28 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::41) by BN9PR03CA0110.outlook.office365.com
 (2603:10b6:408:fd::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend
 Transport; Wed, 25 Aug 2021 09:01:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 09:01:28 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 09:01:26 +0000
Received: from localhost (172.20.187.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug 2021 09:01:26
 +0000
Date:   Wed, 25 Aug 2021 12:01:22 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Dmytro Linkin <dlinkin@nvidia.com>, <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>,
        Yicong Yang <yangyicong@hisilicon.com>
Subject: Re: [PATCH net] net/mlx5: Remove all auxiliary devices at the
 unregister event
Message-ID: <YSYG4it61d7ztmuq@unreal>
References: <10641ab4c3de708f61a968158cac7620cef27067.1629547326.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10641ab4c3de708f61a968158cac7620cef27067.1629547326.git.leonro@nvidia.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce263b7a-a32c-45f2-2c13-08d967a6ecba
X-MS-TrafficTypeDiagnostic: BYAPR12MB2998:
X-Microsoft-Antispam-PRVS: <BYAPR12MB29987AB3F0BF438545ED8106BDC69@BYAPR12MB2998.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oi3jI/bhUjfyA3BWxiwj1DregITWlNrwz272IGQjWVNKRzUp6LcDo/ObxLnK2Ybz4d0xim73x9nBqgg83oAtM53AnibGZNdzqQd7Y6qDzED7FRaJZN4wzBW/c/+dxrIkeUxa7fRGf5t8VecIc7W1xfa2ctCfkuKT1yMmPD0hHIROwFHZf/FsAfqaJRK9eIwtQ1i+XhGJN0WHnC33fR5UZinw7ie1ykigtdh118A+B2zJgePcFf2hxn52WknAURuTbFRBfGOCCflLS2NTeUmoCy4mXSbXQjFoUapVodTV8pdtWYFgLC7ENHiz/UHbxGZJga1/1eHwQL+ngw8BN9uIJp/32C37fI1Vxi09GSl/MVAznAJkw39haPU7JG7hSpWGvw34g75Cg7Wk/26Agtov7VXUvu3QcYa7hhoJVIkWvldLwNRIPLTqfBRKSC82BknkcGtmvWuFEWRhPqv+3j0xDY4moAAYQujkijst20J4RPB0tBWFkhKccblfA9DzRO3twA83JvYirmpHmj4RSHDdSbPLKmCR7bXellmQFXNmC6Wzf9Z0AsNsJ8Ew1vwU6VNnhZ8HMVL6iJcDQgtKzAMotWUkgd48WnM2/w7DMNCKTivjVAyZnqoLcXUk6ipvxOewFHkVu+I9C/A3YVBSnu6WelXC5HBcy3ywaFp8PDQMwC/6kHV4lzRIyORXdBm5LLRAvYodd88c2/4B21qHxSGeVg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(33716001)(36860700001)(83380400001)(9686003)(86362001)(7636003)(6666004)(54906003)(426003)(16526019)(478600001)(316002)(47076005)(336012)(82740400003)(186003)(2906002)(82310400003)(70586007)(8676002)(356005)(5660300002)(8936002)(4326008)(70206006)(36906005)(26005)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 09:01:28.1842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce263b7a-a32c-45f2-2c13-08d967a6ecba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2998
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 03:05:11PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The call to mlx5_unregister_device() means that mlx5_core driver is
> removed. In such scenario, we need to disregard all other flags like
> attach/detach and forcibly remove all auxiliary devices.
> 
> Fixes: a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow")
> Tested-and-Reported-by: Yicong Yang <yangyicong@hisilicon.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Any reason do not apply this patch?

> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> index ff6b03dc7e32..e8093c4e09d4 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
> @@ -450,7 +450,7 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
>  void mlx5_unregister_device(struct mlx5_core_dev *dev)
>  {
>  	mutex_lock(&mlx5_intf_mutex);
> -	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
> +	dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
>  	mlx5_rescan_drivers_locked(dev);
>  	mutex_unlock(&mlx5_intf_mutex);
>  }
> -- 
> 2.31.1
> 
