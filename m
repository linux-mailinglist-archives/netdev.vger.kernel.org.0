Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC4949C824
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 11:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240365AbiAZK5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 05:57:41 -0500
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:62273
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240351AbiAZK5k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 05:57:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcbHgvjV11cVVkbO4r40s3u11nZFQh2xL+HDoAaMhpg/77jwviYF+QA+f3vHeD8OaS8EpheaUh2s4M2PI+9575VYkU4NyUG/gTlS+/FgeLnTi0kJ6T9PCf2SDYBsu2IgxzZjdSbJqRIz4xW9ItxYkYU99juzOyi9Cfii4sruqObKNSeuvV2GFg8L0xwCpbKub/K+PBnLjERW9eLnCArcTeq4dVUB0+Hae5TtFPBnnFfG/s2dLk5cJxW4O6Qon2tgZ4oIyH7jy1vR2oA2DoLdzhbCWuKw0N/ocCFjxaTHUux3FmbhRtrkPAypRkpiBaPXcj2xgP/1wwMsA/C2Hesv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7D4nb2uLi98RmqCleMqyewoKkSsHsUbakBL0Itu8jFY=;
 b=VTBD2c5v9V4xDrUMZ1h/5ZafdMbbpTL0Gul7H6D3fX149rGL6L2TOV36aqTD4kJLmzQrIUb+J5WffYAaxeqcg/Up16xMPfkCXYmhVpQHzY/8aLbONTKUn9z0ILdL4JLnblbJri6RTCHDDprwxD+hSA2wZyAXqK6GGt34iiX6KGcdmEpI1/w3eO9f/I4ReirfVpcKCVrvoLClBvGyIYtVBx472VnsnSOAgF32LWAOwH8Hc7kGUZT+6o+GvBetzZK/lbVZsnYb7Edan2oFOcNhjxZD4t4Ke/iH3+WXfAXekXu9q3G65Xitnp7epRA+UYrzNBy8du/Z8zB4Rw0M1d2Amg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7D4nb2uLi98RmqCleMqyewoKkSsHsUbakBL0Itu8jFY=;
 b=GVJmf3rZ2VhFsfxkw2IiWZyOLJovX7lWTJLI4ZM8aeIscbCuizRUEuSQUFQqppCKGNzm240Cy2KhuInENNRbwARwnLiAPH5WAsOh70EXfCVeuTQp2DeiU1BI8NJiBdXdbVvL0+1q2W7tyZbzvsPEAVOkp+MaF4gO0+NaQi05jIjD13Ak6jZScHaV6k0InVMS7YPtN8AB3xoAi4GJWGz5SvsnPUgO8az/u6Zqi0p4KVDJqyLHWOftPs7YjDW34D2YObSXr+rCPyefYP41GaIdtiv+g5+lDwLQWIlkmCDpSuQpqZFia2vh/sYgOCYxuT2mtsuI1xDcR+LSDBYBdgCOkA==
Received: from BN6PR16CA0039.namprd16.prod.outlook.com (2603:10b6:405:14::25)
 by MWHPR12MB1518.namprd12.prod.outlook.com (2603:10b6:301:11::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Wed, 26 Jan
 2022 10:57:38 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::cd) by BN6PR16CA0039.outlook.office365.com
 (2603:10b6:405:14::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.19 via Frontend
 Transport; Wed, 26 Jan 2022 10:57:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Wed, 26 Jan 2022 10:57:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 26 Jan
 2022 10:57:36 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 26 Jan 2022
 02:57:34 -0800
References: <20220125170128.GA60918@embeddedor>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH][next] mlxsw: spectrum_kvdl: Use struct_size() helper in
 kzalloc()
Date:   Wed, 26 Jan 2022 11:55:04 +0100
In-Reply-To: <20220125170128.GA60918@embeddedor>
Message-ID: <87pmoen4ro.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail201.nvidia.com (10.126.190.180) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a4e40c2-1634-4729-478e-08d9e0baaa38
X-MS-TrafficTypeDiagnostic: MWHPR12MB1518:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1518621AF9C8F7681F51C575D6209@MWHPR12MB1518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: frny1JkXVhLdQq6AcGmRumhpFj4DnZq21gsyNg0OYTsiPrYxUNQqz3p2ZWq6O/2MJqPK01l8s25WsDAFmd8JNkU1hPGspHbaU64HV0WYmhycJVm9TFalcO1GKRfpo6I8WDOGoehJ9GYC75TpX3o73vXj28gr+j31/5hrkcuLP9aXRrrRMxPl/jI8aG6l8YsQUz9faS7yUfl9KrqPb7K9htP5VAWRkAiSmxgu54XhHi39tJnZL0b3ckCnqE3IzasKsixSjpmZgxFRXGIvw7d/HyGwaRKXDAoO8Y4aTIKbmCvqvke/zkjrqyuqi3B5kxqtjjvny4q7+6lrYpqMJLSxlUofljiu58EhunefOp4aLl5ZF7sfufLXMvBZ2EIhxIqGG+nDpbpxoqOe/DYmviQVcciHOyVV5OkqZqceAemb7Bu/qpVy4duz2iPHOa8ENiyGidrzbFHGpQZmEq5qTXi5jZVHk7MXZcYlGb0eandxJVKo4e43DrgB4eUcUhFBN8lIHe94wPVhKfbmRZC9bTUFyHajgLiadr6ASVKqkC2MffU3Cpg3FNrhT+fVikqfxxwWjXulxjcCp1wjKd/budaB0G3l2a0bDvawubRHw6/m8OVwG/T6Z6LykzVVKDaFPd1ex4pbd7lEO315q/D/XAR+UA1i38Xjjqeyd3YjCy0x+7+kJW6168sB8sb57pQ8RRyI+dEp0/DS3p4p6FB2WIzF2KUlUHYq2C3TWSBgmJYXFWW7LyjVXnECQ65w8RO30NoiIhQqMjUv+N9rmRSzjaiSu7V5/V7h4cyWmpLt1xv34HnXubMQ9O2Wos3N50+DdW2+lnITE977XZJMaWcWMkmptv25VX/GzOM0Qi8fIwOPt7rOcPlKS4OPDaJvhnC3Pr3y
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700004)(4326008)(86362001)(426003)(2616005)(81166007)(47076005)(8676002)(8936002)(5660300002)(70206006)(82310400004)(336012)(40460700003)(36860700001)(966005)(6916009)(6666004)(70586007)(2906002)(508600001)(26005)(83380400001)(36756003)(356005)(316002)(54906003)(16526019)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 10:57:37.2114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4e40c2-1634-4729-478e-08d9e0baaa38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:

> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows that,
> in the worst scenario, could lead to heap overflows.
>
> Also, address the following sparse warnings:
> drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c:229:24: warning: using sizeof on a flexible structure
>
> Link: https://github.com/KSPP/linux/issues/174
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
> index a9fff8adc75e..d20e794e01ca 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c
> @@ -213,7 +213,6 @@ mlxsw_sp1_kvdl_part_init(struct mlxsw_sp *mlxsw_sp,
>  	struct mlxsw_sp1_kvdl_part *part;
>  	bool need_update = true;
>  	unsigned int nr_entries;
> -	size_t usage_size;
>  	u64 resource_size;
>  	int err;
>  
> @@ -225,8 +224,8 @@ mlxsw_sp1_kvdl_part_init(struct mlxsw_sp *mlxsw_sp,
>  	}
>  
>  	nr_entries = div_u64(resource_size, info->alloc_size);
> -	usage_size = BITS_TO_LONGS(nr_entries) * sizeof(unsigned long);
> -	part = kzalloc(sizeof(*part) + usage_size, GFP_KERNEL);
> +	part = kzalloc(struct_size(part, usage, BITS_TO_LONGS(nr_entries)),
> +		       GFP_KERNEL);
>  	if (!part)
>  		return ERR_PTR(-ENOMEM);

Reviewed-by: Petr Machata <petrm@nvidia.com>
