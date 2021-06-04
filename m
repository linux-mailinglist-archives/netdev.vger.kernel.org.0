Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB8739B39A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbhFDHMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:12:19 -0400
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:61665
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhFDHMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 03:12:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIh648sMfxHP2a81Lxtg7/r+U/pI8G6/aL39UyDj6Ckzf38FuWpa8Rw7IfpkrxQOzSIQI1AWPtMZiDYBYP6fV7XIAzcnIm2HuWiJ4GBlmEJOXMx16WuEEz1Gs0ejxHvofZGTDlM/mJyv/GezvsfWybVXLLKdAo9jLWV4Ca5l8gcu7n+ZBSiSvM/setlY8ix+rvRK6DbWDpUKMD5xwzjO91dqjRJ3qbUyIgGRm6lFcQpM8Gk3CRCG4KQkmWD6W+44mzdJ8tQ7oxojxtadaithjgVL51gU0zUdS8J/rKTiXahuJt9jiWUmcGr/26TADVwjPlBTsadD//6UjoL1I94bGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbFiU2dq8xzUSA+BLBG11LvqLsKqOdTu9Y888Rn4t3E=;
 b=l2wFwHA8T6T66wmWZ/6jzea02A7qNGav+oz4+gcpXhc/IdNyUgd4ZLXpjJ8gOWYslURHq8BRfHpoIkx5cjYiN/mR0fGoDDFUx9nLHMcVNjzlt6BAY+lEpeYm1kJeXYBQofYgQVFG4Z4fyuLXyq3KaJ6yZJLNShDpdnG1IDnONRsDRYFzqNCjgHIOnBZxSqNuap9fwjspZmaZZEXFs/gdh9WeuVzZorsPkGNNsbH1Hf5wV4vYJiPhKxvqpl/9f/ZZIfxEqU4Tu+Gg+OrXmkzLNN7bdTLgVuBXIOKILGjQGk1r4BAn8NTdxPtJ38mvYX87eY9/ep1FDTQ0xc+D3xp2Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbFiU2dq8xzUSA+BLBG11LvqLsKqOdTu9Y888Rn4t3E=;
 b=TXwK4Du62R3A18VKgQGWI+RmM4tXG9/r3iK0zi0muahWm7OGSEdeirFXEZMNqfiprqzvPGRXFds0SGX8jQaNdgFiqag3nhClpMTz6YJg9OS8ybFukxSqI0Gkt7Gp+zhBRLorASGgTTjHkEnBJdDwxjiicWmRYpww1eiAKPXRMGvbQ5GZKnrotR0JSP8OSpK8S6Xc+HktJvEuZB/qr0NggglGnKAd2EZMSJ684yxr7bJoVRNHLL/AIX78w9hL4fGF79ZaxCeobbS62L3rfFm15UjdElxRjGCszNA5T27X1ImzgjkZNakJjD27Fg2BILTVCxmswddPUr6Nf6x8F9KMUQ==
Received: from MWHPR04CA0063.namprd04.prod.outlook.com (2603:10b6:300:6c::25)
 by MWHPR12MB1903.namprd12.prod.outlook.com (2603:10b6:300:108::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 07:10:32 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:6c:cafe::2e) by MWHPR04CA0063.outlook.office365.com
 (2603:10b6:300:6c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Fri, 4 Jun 2021 07:10:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Fri, 4 Jun 2021 07:10:31 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Jun
 2021 07:10:31 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 4 Jun
 2021 07:10:30 +0000
Received: from [10.212.111.1] (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Jun 2021 07:10:28 +0000
Subject: Re: [PATCH][next] netdevsim: Fix unsigned being compared to less than
 zero
To:     Colin King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210603215657.154776-1-colin.king@canonical.com>
From:   Dmytro Linkin <dlinkin@nvidia.com>
Message-ID: <111afba0-1f6f-12b5-4d1c-733172b1b1ea@nvidia.com>
Date:   Fri, 4 Jun 2021 10:10:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210603215657.154776-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b848ba-0221-4ff1-ccd7-08d92727d750
X-MS-TrafficTypeDiagnostic: MWHPR12MB1903:
X-Microsoft-Antispam-PRVS: <MWHPR12MB19030EB4C500E4787767DDF9CB3B9@MWHPR12MB1903.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 383r1l2bzGLF9px3kYI2xENsvlgovR5uHixRxPqFFZAmloaD+q01ziREk6+bejESYP0gTP892ZSPOOOwjO0S4ToHKWcPcdIdozj5N6RzImfGiu7tp+oGyerct76KDfEWXz+WsI9XW/v6RpgMMrrhud73x0iibeyuuOlouDJTdYYiIanKtjlH/saige61hzAv1hB/6w9pvPFprWEbCcgRNoFwPafJ46b4gADUZonOOvaIuz7WVIVNm+bqkdgFe1RyEjjipSNYJtriX8s6bWU2JWaKqpN9BPOqv1BATHg1ZulJb9nEa1zb8jO5h02OVakZlZFNWZ+5UzA1aYL5GlQs6LzHTG9yA+YhXW0EE9VdAZbV5ewMCYoVsqkcD68g/yNTNVN/CuOcTaHaMcPK2Ags6YhcOm77IDjK40uCixPGJ3EaM7rD4uwEwK+KpoXASB5AkZqmMgLDOTAEZmkXyApJAs994V2P5PYEsO47Xr3x+3hNkYMBKczdmAwnXJIgz7vtyWAEPftSqQcSbsSGHeJVQ7O+lu7VhUfRXSlc6vxnSqEFe+5TStoqvbpMTaOef7ljSSC2W/4VtbwxYXNUeVQkRXFOeRgXwX6lnIYW0KrRTmZpkk7ZTcgso/9c+p2dhcta3MhJtRtor2duUVLazxsnSVv4B1hEQCIqZ88l69OcNoNvwp5g5ROl1uye2QUZQtd4
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(46966006)(54906003)(2906002)(4326008)(110136005)(26005)(86362001)(70206006)(82740400003)(70586007)(316002)(2616005)(31696002)(36756003)(16576012)(4744005)(36860700001)(82310400003)(426003)(336012)(53546011)(83380400001)(5660300002)(36906005)(8676002)(356005)(7636003)(8936002)(47076005)(186003)(31686004)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 07:10:31.8152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b848ba-0221-4ff1-ccd7-08d92727d750
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/4/21 12:56 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of len < 0 is always false because len is a size_t. Fix
> this by making len a ssize_t instead.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: d395381909a3 ("netdevsim: Add max_vfs to bus_dev")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/netdevsim/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> index b56003dfe3cc..ccec29970d5b 100644
> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -111,7 +111,7 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
>  {
>  	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
>  	char buf[11];
> -	size_t len;
> +	ssize_t len;
>  
>  	len = snprintf(buf, sizeof(buf), "%u\n", nsim_bus_dev->max_vfs);
>  	if (len < 0)
> 

Thanks.
