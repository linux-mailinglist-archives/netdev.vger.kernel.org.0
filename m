Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CE75B88F1
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 15:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiINNRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 09:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiINNRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 09:17:52 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4041256B93;
        Wed, 14 Sep 2022 06:17:50 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MSLPp0Tqkz14QY5;
        Wed, 14 Sep 2022 21:13:50 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 21:17:47 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 21:17:47 +0800
Subject: Re: [PATCH -next 1/2] net/mlx5e: add missing error code in error path
To:     Raed Salem <raeds@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20220913143713.1998778-1-yangyingliang@huawei.com>
 <DM4PR12MB5357FF348010A6436B77042FC9469@DM4PR12MB5357.namprd12.prod.outlook.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <73eecede-06da-2eb9-3b45-1d999521298c@huawei.com>
Date:   Wed, 14 Sep 2022 21:17:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <DM4PR12MB5357FF348010A6436B77042FC9469@DM4PR12MB5357.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/9/14 20:35, Raed Salem wrote:
>> -----Original Message-----
>> From: Yang Yingliang <yangyingliang@huawei.com>
>> Sent: Tuesday, 13 September 2022 17:37
>> To: netdev@vger.kernel.org; linux-rdma@vger.kernel.org
>> Cc: Saeed Mahameed <saeedm@nvidia.com>; Lior Nahmanson
>> <liorna@nvidia.com>; Raed Salem <raeds@nvidia.com>;
>> davem@davemloft.net
>> Subject: [PATCH -next 1/2] net/mlx5e: add missing error code in error path
>>
>> External email: Use caution opening links or attachments
>>
>>
>> Add missing error code when mlx5e_macsec_fs_add_rule() or
>> mlx5e_macsec_fs_init() fails.
>>
>> Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>> .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  | 14 ++++++++++++--
>> 1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> index d9d18b039d8c..5fa3e22c8918 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
>> @@ -194,8 +194,13 @@ static int mlx5e_macsec_init_sa(struct
>> macsec_context *ctx,
>>                                       MLX5_ACCEL_MACSEC_ACTION_DECRYPT;
>>
>>         macsec_rule = mlx5e_macsec_fs_add_rule(macsec->macsec_fs, ctx,
>> &rule_attrs, &sa->fs_id);
>> -       if (IS_ERR_OR_NULL(macsec_rule))
>> +       if (IS_ERR_OR_NULL(macsec_rule)) {
>> +               if (!macsec_rule)
>> +                       err = -ENOMEM;
>> +               else
>> +                       err = PTR_ERR(macsec_rule);
>>                 goto destroy_macsec_object;
>> +       }
>>
>>         sa->macsec_rule = macsec_rule;
>>
>> @@ -1294,8 +1299,13 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
>>         macsec->mdev = mdev;
>>
>>         macsec_fs = mlx5e_macsec_fs_init(mdev, priv->netdev);
>> -       if (IS_ERR_OR_NULL(macsec_fs))
>> +       if (IS_ERR_OR_NULL(macsec_fs)) {
>> +               if (!macsec_fs)
>> +                       err = -ENOMEM;
>> +               else
>> +                       err = PTR_ERR(macsec_fs);
>>                 goto err_out;
>> +       }
>>
>>         macsec->macsec_fs = macsec_fs;
>>
>> --
> Look at mlx5e_macsec_fs_init implementation, it never returns error code, it either returns NULL or a valid Ptr, the use of IS_ERR_OR_NULL is redundant here (same for mlx5e_macsec_fs_add_rule)
Yes, I will replace it with NULL ptr check in v2.

Thanks,
Yang
>> 2.25.1
