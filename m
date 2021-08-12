Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E663E9F4B
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhHLHNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:13:51 -0400
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:50490
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234658AbhHLHNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 03:13:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e9albqgL62KtYemG3tDvvIp4KXxjMyLBgaXt/girHC8WcTX5BUwqNizvM5OdSFTvuM/A2NorCVI8W+dCJDx4femV7m4OfEsJe66hrcmjf7u8qlchdjT64HWFHgeSDH2ZijYyu/O8kKC/834FJUkqqcgPk4O1U5PT8r31TEK+RJBO6ysEpLGvEGjRb/xhvoVczVJwwzbjoCIRs7UaHj6pCDoaX/4HwBpZ14GGjvO26H9NWTmCzDQV3omtrb90oLNvQbG2Mec8CSX/B4puBcL9gd7ouEsz+CV0wplArGVK2s7rUcZaawBvpS9FVLGdXtoUDvgfM9vIXdocCrmhQgNtrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9BA8qq3cAjOHFzvpc7JtizHiOztNU38yG5L3Bkxa3Y=;
 b=KgRBdwQEIUkpetEQ/LOwZuUpW7b8ermPCZyoj1GSpPwCshRJeUDFjoq9z9yg87mKtioDNbhPfa6xr42yTQ6aoITbymbnUloi3Ek1jwfK9QUWl5hAJqgmKtq/JnJsbdW6vHUcvZWYcfrWBCae/f8x5P39U6rNXnFxzx1MldNe63I37K2992eJr8oBbHOjpgpsQIR90K6YCpyy5VEYMsLpex5Y1EVX4oT7lAla2rzEg8JHxhJTB+Yej9F+K3+4hHKXWy4Mtg0g0WEHXaPYiTh73iuP98kixCU2Orr+5g/A9oamamlu3p1vAOwC5+KGSu4B0D2JaEtlppy6mUECWBD11Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X9BA8qq3cAjOHFzvpc7JtizHiOztNU38yG5L3Bkxa3Y=;
 b=ZaxZCy0mHCUYm7SBwO3L3AlCXyLJExScnZ9MJcHkM2H8UvwECROxUyaiSvo9TRbKmqkDHlzeTta9usF8zY8QWgDApIl2zbgSCQ9c3RIlOirRlMuxXD05ZSyHMvYqIiRrMytfK8w7ov1KQBzRgsB+PaV72VayX8YwAUZuGOceuN9zIJdFxQKmaekTmF9zQAgfOYYUvj5XtTTmaGR8CK7ml+syTqrf5OKjt/CqXYgLiN0KRtX6gNqfIjK9VjQIZ1wNcOLuw79R09Dkl2Fw8L2nYLeV8krb84VMGsPRwYsnS2DNxo7xUe6hsOZ7c0zPUHkkkh7VtUec9nrhB2oXS1H+MA==
Received: from DM5PR18CA0087.namprd18.prod.outlook.com (2603:10b6:3:3::25) by
 DM5PR1201MB0041.namprd12.prod.outlook.com (2603:10b6:4:56::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.13; Thu, 12 Aug 2021 07:13:15 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::f0) by DM5PR18CA0087.outlook.office365.com
 (2603:10b6:3:3::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend
 Transport; Thu, 12 Aug 2021 07:13:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 07:13:15 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Aug
 2021 07:13:14 +0000
Date:   Thu, 12 Aug 2021 10:13:11 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 06/12] net/mlx5: Refcount mlx5_irq with integer
Message-ID: <YRTKBw/q57G3erd9@unreal>
References: <20210811181658.492548-1-saeed@kernel.org>
 <20210811181658.492548-7-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210811181658.492548-7-saeed@kernel.org>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffb412bd-551e-486a-a8f2-08d95d60a78a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0041:
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0041FFA1614B11EBE3CB0A15BDF99@DM5PR1201MB0041.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vIugBTCO8tT7cLZDY/bVoc2YQuGnTsSjZqGEE9bOTgcuolD7ZM1jYD+y01tpCS+yhB5VLIoVNlFwDCo1w4CkZzcJnHRAazCjaHrfmgxs1fI3nxp2bLVZLqB/KZEP67Eo2TwsMo5s5AD7qVHMxVhSq3OGXXCIPgTErNlnHmXD9YR/eqBxLMy94jx+FOQs/NDYOw5Ca95N9oLdoObaSMD9xNC0orzlsa9JdeQru1Gmq1Z5Ula2UHeqXy1DQCRPKC8V6drIgWot+fWZ3Uyv0Hub3cy5aT4DY6hNyFOm6QViwyGi0ttrqj8+hIHsSd62XbSZPUV+5AAqAgi9zTXKF0nfL51Aul0XidiLLI2CuWXiV+xsUGK+p8tuPkpRvuu1Cw2GB03WW7j6Kahr07Zf+sLuMDIm9e6FcjdPij+KyvHCsfNSVGfpKOha5vG1jnJ9utg7KzWeVP6+cy09PuIsK5etaPQ3gK+xuDAj1losNhuCi23ba3ftGBK+h9O1yeXXOYZ5la3Ekr+KcQDPFrDw7Q3zjLRNLAxvhGDGIpIKChaBsy0egyIgRsOMo3YIF09zjRQKFXpZqddSClY7jMffnPN9ZdJ9xAhDAC0PrkG6HQS3DBKvDQXLqJW2DFRvUeC6BgnFs8h27JVPdB56fm0texTsG9Js7BDrVxcyfBUyBPNjmWCAO/Q/DFa5U83UbhBZ2e6w8fluds3oakT91W++zEZ49Q==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(346002)(136003)(376002)(396003)(46966006)(36840700001)(8936002)(36906005)(186003)(7636003)(6916009)(426003)(16526019)(478600001)(70586007)(70206006)(82740400003)(2906002)(54906003)(107886003)(36860700001)(82310400003)(26005)(9686003)(33716001)(336012)(86362001)(316002)(5660300002)(8676002)(356005)(4326008)(6666004)(83380400001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 07:13:15.7732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb412bd-551e-486a-a8f2-08d95d60a78a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 11:16:52AM -0700, Saeed Mahameed wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Currently, all access to mlx5 IRQs are done undere a lock. Hance, there
> isn't a reason to have kref in struct mlx5_irq.
> Switch it to integer.

Please fix spelling errors.

> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 65 +++++++++++++------
>  1 file changed, 44 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> index 717b9f1850ac..60bfcad1873c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> @@ -32,7 +32,7 @@ struct mlx5_irq {
>  	cpumask_var_t mask;
>  	char name[MLX5_MAX_IRQ_NAME];
>  	struct mlx5_irq_pool *pool;
> -	struct kref kref;
> +	int refcount;

refcount has special meaning and semantics in the kernel.

>  	u32 index;
>  	int irqn;
>  };
> @@ -138,9 +138,8 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
>  	return ret;
>  }
>  
> -static void irq_release(struct kref *kref)
> +static void irq_release(struct mlx5_irq *irq)
>  {
> -	struct mlx5_irq *irq = container_of(kref, struct mlx5_irq, kref);
>  	struct mlx5_irq_pool *pool = irq->pool;
>  
>  	xa_erase(&pool->irqs, irq->index);
> @@ -159,10 +158,31 @@ static void irq_put(struct mlx5_irq *irq)
>  	struct mlx5_irq_pool *pool = irq->pool;
>  
>  	mutex_lock(&pool->lock);
> -	kref_put(&irq->kref, irq_release);
> +	irq->refcount--;
> +	if (!irq->refcount)
> +		irq_release(irq);
>  	mutex_unlock(&pool->lock);
>  }
>  
> +static int irq_get_locked(struct mlx5_irq *irq)
> +{
> +	lockdep_assert_held(&irq->pool->lock);
> +	if (WARN_ON_ONCE(!irq->refcount))
> +		return 0;
> +	irq->refcount++;
> +	return 1;
> +}
> +
> +static int irq_get(struct mlx5_irq *irq)
> +{
> +	int err;
> +
> +	mutex_lock(&irq->pool->lock);
> +	err = irq_get_locked(irq);
> +	mutex_unlock(&irq->pool->lock);
> +	return err;
> +}

From not deep-dive review, all this "irq->pool->lock" is wrong.
The idea that you lock pool to change one entry can't be right.

So, I would invest time to clean locking here instead of removing kref.

Thanks
