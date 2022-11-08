Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CC76213A6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbiKHNwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbiKHNwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:52:19 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F7C623AD;
        Tue,  8 Nov 2022 05:52:14 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N68fT3N6xz15MPv;
        Tue,  8 Nov 2022 21:52:01 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 21:52:12 +0800
Subject: Re: [PATCH] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
To:     Mark Zhang <markzhang@nvidia.com>, <borisp@nvidia.com>,
        <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lkayal@nvidia.com>, <tariqt@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221108130411.6932-1-yuehaibing@huawei.com>
 <937e019a-f911-8fcb-6f0f-d23188ced89c@nvidia.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <654e2ea2-0032-f8b6-709b-0aa55956f1b6@huawei.com>
Date:   Tue, 8 Nov 2022 21:52:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <937e019a-f911-8fcb-6f0f-d23188ced89c@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/8 21:16, Mark Zhang wrote:
> On 11/8/2022 9:04 PM, YueHaibing wrote:
>> 'accel_tcp' is allocated by kzalloc(), which should freed by kvfree().
> 
> 'accel_tcp' is allocated by kvzalloc()>
>>
>> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>> index 285d32d2fd08..7843c60d5b99 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>> @@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>>   err_destroy_tables:
>>       while (--i >= 0)
>>           accel_fs_tcp_destroy_table(fs, i);
>> -    kfree(accel_tcp);
>> +    kvfree(accel_tcp);
>>       mlx5e_fs_set_accel_tcp(fs, NULL);
>>       return err;
>>   }
> 
> Need to fix mlx5e_accel_fs_tcp_destroy() as well?

Indeed, thanks for your review.

> 
> .
