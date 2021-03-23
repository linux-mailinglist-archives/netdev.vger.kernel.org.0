Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867A6345A16
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCWIwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:52:34 -0400
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:52065
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229493AbhCWIwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:52:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m578CcTJC9H/sW7qAyvrXVplmOMGxmYZMroNH58sgxUYjfDJEz6jhO1VNiJL/rTDkC+v12f9/PEZ5yECx+uiqGfdt3l69h3oRFkx6maoXFtdCwB4kapaeOv0zBH+O2btg1L/pyQF4lVRQPBWxMM9r6IjcquLlEctChToFmZBrXstigFv22Md7cmjAW1ZSKO3Zj6VcU5V2vrjHLpkLctR6BeMLhh5tmeKMAP+CzoLW3aCQyZY36TMZs5b05m8UFGokKFwsh6FF+cMZd6p8EQX5KqqNmFXVtEoYZfhUw8a1pCbhpPwCy60k/PNWnfeanscHF27r525qeGxWaBFkC1uLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn9TlnI1+dCa4YSImTmWO/MFA5W7V8eBaqbHmp0FNu4=;
 b=cxuC1rDpYqghP0xLaEq8WnHEd12leFGGcp5cG3xoHFK8TZoESnhxfleD1TwMiHVwN5SR6jjv1C13GVfIOONGUL/YYbj6ToEKVuzK1t9LTus1LPWU6Icd9OqZauFI8sT+EtiQKjw871ctnmXmPAzfX5iTdHSWAyZRqOXsF5TYeOUpauAa4QMq1xfAJUpHOv9nOfVP3+OUrBSLYFdmYdbQ9VSuL2jb1JYsYt9eXt0pj/2Q1xO5Q1i6ffD/Demo2giTnevrqQakLduEuIp5jCLmRRNqWlp7G7TAjjn7PMiKAO7VtRHQLXYvAD7RIC08WUUv7k5J0u6+AsnUnhnDDLcxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gn9TlnI1+dCa4YSImTmWO/MFA5W7V8eBaqbHmp0FNu4=;
 b=L5qn9eF3uC4y/Z394eqO9VRKSSVj7NALy21MfwlafHZ52c5zgv7V2+0vEJjt0aWxvPAamtn7NicXfpmLr8HT2XZb3fD3WiuD6ve5RLOrkjfjgTuFEd1h1HGxB7Q5jVPMOGvtkbPw7NqbhJp51ncVEJCMozTKwJFMz0nair380iJ3W6GThrMgDt53yK7QOfzd4qaRqpXLuV5vr3/D0OPMMuKLZR1GoR/ABnUmMRkcsll09TuCDFScCLIj3mpneX3hSbI/268e0v+K8hQ7lJPqJgOH42nOZ5v1ZcrdU2B9DkR2Xft4QsW8VSL0yUrNg1KQ0uqSDFUCcxx98F6613g3cg==
Received: from MWHPR15CA0068.namprd15.prod.outlook.com (2603:10b6:301:4c::30)
 by BN9PR12MB5308.namprd12.prod.outlook.com (2603:10b6:408:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 08:52:16 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::e3) by MWHPR15CA0068.outlook.office365.com
 (2603:10b6:301:4c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 23 Mar 2021 08:52:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 08:52:15 +0000
Received: from [172.27.0.234] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Mar
 2021 08:52:11 +0000
Subject: Re: [PATCH] net/mlx5: Fix a potential use after free in
 mlx5e_ktls_del_rx
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>, <borisp@nvidia.com>,
        <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <maximmi@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210322142109.6305-1-lyl2019@mail.ustc.edu.cn>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <0b9cd54f-cab4-7675-cecf-171d4d45b897@nvidia.com>
Date:   Tue, 23 Mar 2021 10:52:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322142109.6305-1-lyl2019@mail.ustc.edu.cn>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69dd7c4c-4035-4364-071c-08d8edd8f534
X-MS-TrafficTypeDiagnostic: BN9PR12MB5308:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53080B31AAA073A65B11DBB1DC649@BN9PR12MB5308.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Anfrk3sw0Wg9XGSujhrp5RSYnQ4bFmQWd7tYrnfL2Db82ql3pqhVqlhmeFCrj5D8zOvztWWlQxgpnetikshbdLgmSqZwVQjRPo7yvsHzsUHC4J1IrFErG17vCQNdY61ylgOLlaO4iG2Vj9DpqJ/Sn3MtVTPfFZlWmFOulQPNlQXiQDP6OaYVzt8Zo0XGxzpzdpRLb4BmLfNsUXrRptnL/KfsJ0ZHrxApvk7kz1KwjVjloqxiPI+6fVjpX8xrERkaqjmMyTM7dxbFtX5jhWAbKHvqbnqewge8MvLXivf04hCmwcqQTZJd2abbgjVxeCWLbb1cDoF72jKkdvU8UgU+Ana8OBPOfy9mN1FnlRbGGrXt01zLOLL5D/0qOBgqMPx2MGWepQcf5Qf1EPN33EYGIBFH2E2aY/1UBUypnmh6+kGiaFHU92lTNK3uP2Se1xAKdQJG4Xu4upYo2rF5cJ4845tTN9VfRWGmpkqmwrqpkUQChNz2JDGw3pIlRb3EARxPxzw/y3OZCnKvvIisi61mQR6+o44ZgJwkyNcWNnLgcDd2pZzIpQuMq/bOMsblAeeTaU4enyZ0srL27CjYJ/i/Wup7HyEHUgV4CKKhRUl/gcJvW8AiOjkyviT0oE8kvKHviAXf1VtG1WouCyeGX41l5euR2kobNsnCe3+1vW5fwiLQpub18ottDkVYdBU7p11W
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(46966006)(36840700001)(8676002)(4326008)(8936002)(86362001)(478600001)(31686004)(186003)(426003)(82740400003)(36860700001)(31696002)(26005)(36756003)(47076005)(336012)(82310400003)(16576012)(53546011)(5660300002)(6666004)(2906002)(70586007)(7636003)(316002)(54906003)(2616005)(70206006)(16526019)(36906005)(110136005)(356005)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 08:52:15.4382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dd7c4c-4035-4364-071c-08d8edd8f534
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5308
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-22 16:21, Lv Yunlong wrote:
> My static analyzer tool reported a potential uaf in
> mlx5e_ktls_del_rx. In this function, if the condition
> cancel_work_sync(&resync->work) is true, and then
> priv_rx could be freed. But priv_rx is used later.
> 
> I'm unfamiliar with how this function works. Maybe the
> maintainer forgot to add return after freeing priv_rx?

Thanks for running a static analyzer over our code! Sadly, the fix is 
not correct and breaks stuff, and there is no problem with this code.

First of all, mlx5e_ktls_priv_rx_put doesn't necessarily free priv_rx. 
It decrements the refcount and frees the object only when the refcount 
goes to zero. Unless there are other bugs, the refcount in this branch 
is not expected to go to zero, so there is no use-after-free in the code 
below. The corresponding elevation of the refcount happens before 
queue_work of resync->work. So, no, we haven't forgot to add a return, 
we just expect priv_rx to stay alive after this call, and we want to run 
the cleanup code below this `if`, while your fix skips the cleanup and 
skips the second mlx5e_ktls_priv_rx_put in the end of this function, 
leading to a memory leak.

If you'd like to calm down the static analyzer, you could try to add a 
WARN_ON assertion to check that mlx5e_ktls_priv_rx_put returns false in 
that `if` (meaning that the object hasn't been freed). If would be nice 
to have this WARN_ON regardless of static analyzers.

> Fixes: b850bbff96512 ("net/mlx5e: kTLS, Use refcounts to free kTLS RX priv context")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
> index d06532d0baa4..54a77df42316 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
> @@ -663,8 +663,10 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
>   		 */
>   		wait_for_completion(&priv_rx->add_ctx);
>   	resync = &priv_rx->resync;
> -	if (cancel_work_sync(&resync->work))
> +	if (cancel_work_sync(&resync->work)) {
>   		mlx5e_ktls_priv_rx_put(priv_rx);
> +		return;
> +	}
>   
>   	priv_rx->stats->tls_del++;
>   	if (priv_rx->rule.rule)
> 

