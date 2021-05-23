Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A582B38D96F
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 09:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhEWH0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 03:26:12 -0400
Received: from mail-bn8nam08on2041.outbound.protection.outlook.com ([40.107.100.41]:23392
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231587AbhEWH0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 03:26:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwnHZ/esojPuZfLDvCEo42Y4qR+tbZ3ym2o5E8Ihf4s3reDqwkkXAtVk6PeyzkHpb67rdd0EnSdaSgb2kNxLRK0GoU6qDpAIzCwdNIfRy+1NNQEuALm2wIBV5p+lMTMn8fOFSEXp1OWtPXI4fiWFTfQ7NbH+9TfGa6C5LnqS+a8vfVgs5iUU3w1Wk5dM3joAZXdGBfwZnxLjRq9lrds5Vd0VSDH9aGZ1ik82PMRh5K7I6V7m7ufo5LrQzUhC3qrwuifAtStI8H4ExjZvMFL0kfoCj+xbB4GCjBCTIi+EsqOymkDOxnr5GzmSXkxcVG6VnxZcwSSBLEKyqGLA1wDBDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5lSL0L+gqtc2jG5jus6e4D8vR/g/OtUQcXLQpxjMlk=;
 b=ADiDIZRqADcizdI/vrJKC2C6vc6oz/l5cjYtX8lXIZBdUYjgmUeSgu5eU9mlgpmFfsQ1TVVc72qXyqzBpOJ91J1FzmIUeOXv28Nwq9ZRbdu8LUOA3db0ihVvu1AHZbNRn0GpnoG8XMTQtT7JrOWpku/wUpoBtbdW1/vmoVWbolHUM83MiCh60ez4N90vdPTAfTC/zzDP9waxhf18vm+jtdjggGE6vvMeUoGsDKF3buhgi2PpYnv8GzCR9pdZbL4r0aXRnllxvqLOOEzDMxkATVMTkvQaBv2es5KlMwEAstC8sN+7mhBQsXN9lNdR7pdRGUZFwgFmAnTFPoDSRBwUUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5lSL0L+gqtc2jG5jus6e4D8vR/g/OtUQcXLQpxjMlk=;
 b=Bgbks8u23PQGGtA13PIhYKXjLBNMJmug+2IYz9IPg7rH912lbRn4wqyRo8gM0HegqcQ8Yv1GmrDQlW8CBh01YwV4GLG2t5MX7Qt+bk+LsW+IkdN465Lc19opJ96S2k+/n3kCCgLPQsvOiD4icXGJINHPVx5O8IsXzy5/SlzeBLOPr3FfWW5xXI8SuHKPfpr4H0QLGiAWBCjlcWQGir37Ny3iYs+46puZLoHyKriKUfqj9YOYZmsMGURAOO+V+SBuKaPNMxOUG346WwMav4YAWLQnnCWOR5y/iIUQTdztvB/wRq/qNyP+M/zTrT0ECSJxUq0w8l8OQRK/LO6qr5WGAw==
Received: from DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) by
 DM6PR12MB4796.namprd12.prod.outlook.com (2603:10b6:5:16a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Sun, 23 May 2021 07:24:41 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::bc) by DM5PR15CA0056.outlook.office365.com
 (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Sun, 23 May 2021 07:24:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Sun, 23 May 2021 07:24:40 +0000
Received: from [172.27.14.178] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 May
 2021 07:24:37 +0000
Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
To:     guodeqing <geffrey.guo@huawei.com>, <mst@redhat.com>
CC:     <jasowang@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
References: <20210522080231.54760-1-geffrey.guo@huawei.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
Message-ID: <6f7b729d-38df-9bf8-f023-bc1986da9a9e@nvidia.com>
Date:   Sun, 23 May 2021 10:24:34 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210522080231.54760-1-geffrey.guo@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b20c80b7-bd2a-4aa7-f712-08d91dbbd472
X-MS-TrafficTypeDiagnostic: DM6PR12MB4796:
X-Microsoft-Antispam-PRVS: <DM6PR12MB479610C4D6D9756713AE5D0BDE279@DM6PR12MB4796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMjtQPOEmKv77HxrY1Fd4RrTsYcoOs2W+i8ojf89cEvwoc0GpLVITo2Lf8CynPNvw0XPua4kIgr1+FrIbdNKcUSX+OYIdblqTSucdF+n2cDYLe2CLIAubS2jfJ32Swok9R7ZF9bWA7VGmtibK5NsXvy7TYYkCrjDvNvTMm1ecSL9cuNtHK0dMP9GU1nKIJmpX6rMtm12uiwarlM9nK1zI7bjcsRa+6ofd+cIZ9KXcZAoDTve4Flc4+hnjHetjmYlMlZXydaMDdqV5iRg7Zkzk9qT+0CdAW7L3ZJxGNjGR8gN5AsJCkE/6ct4dlWuDV2kXq9RM26/wFW4t/+hrkFw0/anEXxTI/hEQClzbp5SZ0XbJXv8SqSPzT0lI9BYtz5JRBqiqKi6Vl50KcSb9pDmwLYkMtjeRj7q1bDZK9ATsBbja2RrdEZg2CE2/rD9Pokl3T7ZCPihrHrjm1SaWk4Ug0su/Kb/N8AM4VqnBv7uTbWbIfpHCK9MHyYNaFyaSlJAQxyDEsQQoPcOsK9KsTBG6jg2EUrwl3AitP2xpEGCdosCuzqrlFZ4xH6sTy1WAf5Fd3jys0pPX8Xc6i1mfWR+0L951t9/ihROjKXPyAhSmQerRxKiUxXelwbFEeBJ6RVudTukGnuPQgQ3fmkD/tiVHbQBdYnEqR4EqOkriymFanxHaTKMkSpgjRz+qwAe4V1g
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(70206006)(82310400003)(426003)(31686004)(53546011)(6666004)(16526019)(54906003)(16576012)(110136005)(2616005)(83380400001)(36906005)(70586007)(5660300002)(316002)(4326008)(336012)(2906002)(36756003)(186003)(8936002)(478600001)(26005)(82740400003)(8676002)(47076005)(36860700001)(31696002)(7636003)(86362001)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 07:24:40.9020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b20c80b7-bd2a-4aa7-f712-08d91dbbd472
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/22/2021 11:02 AM, guodeqing wrote:
> If the virtio_net device does not suppurt the ctrl queue feature,
> the vi->ctrl was not allocated, so there is no need to free it.

you don't need this check.

from kfree doc:

"If @objp is NULL, no operation is performed."

This is not a bug. I've set vi->ctrl to be NULL in case !vi->has_cvq.


>
> Here I adjust the initialization sequence and the check of vi->has_cvq
> to slove this problem.
>
> Fixes: 	122b84a1267a ("virtio-net: don't allocate control_buf if not supported")
> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
> ---
>   drivers/net/virtio_net.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9b6a4a875c55..894f894d3a29 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2691,7 +2691,8 @@ static void virtnet_free_queues(struct virtnet_info *vi)
>   
>   	kfree(vi->rq);
>   	kfree(vi->sq);
> -	kfree(vi->ctrl);
> +	if (vi->has_cvq)
> +		kfree(vi->ctrl);
>   }
>   
>   static void _free_receive_bufs(struct virtnet_info *vi)
> @@ -2870,13 +2871,6 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>   {
>   	int i;
>   
> -	if (vi->has_cvq) {
> -		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> -		if (!vi->ctrl)
> -			goto err_ctrl;
> -	} else {
> -		vi->ctrl = NULL;
> -	}
>   	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
>   	if (!vi->sq)
>   		goto err_sq;
> @@ -2884,6 +2878,12 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>   	if (!vi->rq)
>   		goto err_rq;
>   
> +	if (vi->has_cvq) {
> +		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
> +		if (!vi->ctrl)
> +			goto err_ctrl;
> +	}
> +
>   	INIT_DELAYED_WORK(&vi->refill, refill_work);
>   	for (i = 0; i < vi->max_queue_pairs; i++) {
>   		vi->rq[i].pages = NULL;
> @@ -2902,11 +2902,11 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>   
>   	return 0;
>   
> +err_ctrl:
> +	kfree(vi->rq);
>   err_rq:
>   	kfree(vi->sq);
>   err_sq:
> -	kfree(vi->ctrl);
> -err_ctrl:
>   	return -ENOMEM;
>   }
>   
