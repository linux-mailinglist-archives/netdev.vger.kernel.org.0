Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6764A3E9F31
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhHLHHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:07:47 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:23616
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229956AbhHLHHq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 03:07:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSrZTrk9v2GHQC7ZGvYc4v5b+K682UgYEdGaffaOi+mJQHM1Y/i7ChTyDxe4tUzdVMEc5CnnVnSj+2Mxdq10lnw8gqY8IRrMKauyAJjnO6vLcrK8HGWygcq5C/+EBSvWbqhm+74khIrimxUN8/hOMSeLuwbMP1wdmX/4KSwJm2FgQohmWIlkNRyZ3QiW9+Nd7hSQqQ5LKW4QecAas3+NZfgzG4p3XdZEeWx2txuqvLy7co+X2GIzDQJeU6IXHSVz1chO6S4J0HoDV6wgtBWflijJGsAPUwD+WKfqKrRqASVZcnLBUuTXA92ZbH7otE6ntwYXqRe64w+dYgM/1pSzKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Okle2DfjHlcnWxY8zJrKaQluELYr6iyqYP8zw5hsPCE=;
 b=I9HeIIqhuzHyNIRO9pQvEwMXgsIu09rnfl08tg9LviWPeZ2ScmCbSXP4veIfzWd50LX84jYKdVB48y+0UOD5R6JI8NyFilXec9Q5NozzeAtSi5RierCaZzTCGmPuqJbIrA1AsJrVVleXFv9EEQU96hq3oQj0aslY/8CRR+KwcQ7xOKWOcHVNaEd1psyvo+MUVWhi81EXWwMn7Ts+PsPBblKq6h/Xl8HuWMT7BpE0ft6VMlPjFMXZxQvbb9LfoqA5lhC45+NNzjOAzvNnoXU0SR49i3G4UB1ZqcYfWO6z0jF5FGFKPqUSWGHUSgslSWH4137KrvgvhmEjx3c3M5k6IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Okle2DfjHlcnWxY8zJrKaQluELYr6iyqYP8zw5hsPCE=;
 b=Iyw9pmCfzIZZCVAaB5ibA4GSLulrzFkTiUE8RgsTVYSlIm/Y95MyBwlEDczo2NohOQoNxY6q0j1uqs5JC8hgDN1esAvJ4dd9QSi0ZV+ynsCNnlgYrjEi1C8DoC/34lpdKZ9y7oWy0n6vytfcCfMZE0J1NI9FgUXrC33QitABhbpxt/JrYOSxCqXTl/3WcJhBSMWczBn/WvhnvUECV8G/9VMXwJpYnw7CQdfMreVtYFgd5t826NO1IxTWt5ugfTgvTmPdlkqqIQCx6EDW8K1urFgSKsjppvzvHc7ePK6NrVp24WKQo9v/qBXckpEkLfe3dWZK2LvhNqD5tqNWTBjx4A==
Received: from MWHPR19CA0008.namprd19.prod.outlook.com (2603:10b6:300:d4::18)
 by MWHPR1201MB0077.namprd12.prod.outlook.com (2603:10b6:301:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 07:07:20 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::f7) by MWHPR19CA0008.outlook.office365.com
 (2603:10b6:300:d4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend
 Transport; Thu, 12 Aug 2021 07:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4415.16 via Frontend Transport; Thu, 12 Aug 2021 07:07:20 +0000
Received: from localhost (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Aug
 2021 07:07:19 +0000
Date:   Thu, 12 Aug 2021 10:07:15 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 05/12] net/mlx5: Change SF missing dedicated MSI-X err
 message to dbg
Message-ID: <YRTIo8Op1MuHL6Am@unreal>
References: <20210811181658.492548-1-saeed@kernel.org>
 <20210811181658.492548-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210811181658.492548-6-saeed@kernel.org>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa75df9f-3100-4daa-4709-08d95d5fd3c1
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0077:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00777F5A056A3BE1B6DF21FBBDF99@MWHPR1201MB0077.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zdSbqDdLV/c4AETjnef75BmWsRQ/ceNNEDd9cFpTU0Z5V9yweqDhlyn8CqxyOl8AaZ0jEOcXG0LE1hfe3U5HG1ajfQwZyi1Y47GLSMz7hJpl348vdD5YE4RehLL1rtWr7YE3bVQzc7AlfgDH4qpWHgK1054OpHwoAYo+gE/pFJ79AvWvbJDjYk0vS7FurygfZoKrmQCQAHPKhDPBe6kB3De6Hy6qtfslJzrVMSRtfdq9NsSlGUWpgOpv5+n98Vl4DyoXQNP4zEvsEAcbj+qYUAsAdPnMXJI8tzCV214FB2WXBNUS7NGE4zYrKjhjWcbVTMPEw3kc2kQ+SVLFXDMXeN/T0gyaEVa56seRCkB6QKNMEMN4T9tvTmL9YRJpXpSUDLw8MDPCefTedy9dCIRiYyBd5dZM4mtuURz2GbUGUMqw856gxlXfgkk+B50p81s3SEw/SwSTV+MK3g/4hjsz70JCvUp4EtnaxizYVM3nmIhBq7ptoVDbDeNdGhB5D6Zs+PrzzTY9VztW349pQTCw8PG8CEeCB4IqBnW7hjZ5vcVj4cSG3antOdl/v6UN3IqUSx+L03+rjmbsS9JQINi6OKGa3CA8STqgSdstQFzfH6m0jEMg6vsfLDAo6lwMMZu/yGmmiRZZBSzYF/hSlC0jDSEC5ghESrZ6qtyZcltGl+L5Z3ywRhgZeVrE6PjTFwMZaIiMN5DK1ug6oUrd8fNl/A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(70586007)(16526019)(186003)(9686003)(70206006)(356005)(7636003)(33716001)(26005)(336012)(8936002)(4326008)(47076005)(86362001)(8676002)(6666004)(478600001)(5660300002)(36860700001)(82740400003)(82310400003)(83380400001)(36906005)(15650500001)(316002)(2906002)(54906003)(6916009)(426003)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 07:07:20.3722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa75df9f-3100-4daa-4709-08d95d5fd3c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 11:16:51AM -0700, Saeed Mahameed wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> When MSI-X vectors allocated are not enough for SFs to have dedicated,
> MSI-X, kernel log buffer has too many entries.
> Hence only enable such log with debug level.

Please invest extra time in the commit message.

> 
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> index a4f6ba0c91da..717b9f1850ac 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> @@ -479,7 +479,7 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
>  	if (!mlx5_sf_max_functions(dev))
>  		return 0;
>  	if (sf_vec < MLX5_IRQ_VEC_COMP_BASE_SF) {
> -		mlx5_core_err(dev, "Not enough IRQs for SFs. SF may run at lower performance\n");
> +		mlx5_core_dbg(dev, "Not enught IRQs for SFs. SF may run at lower performance\n");

enught -> enough

>  		return 0;
>  	}
>  
> -- 
> 2.31.1
> 
