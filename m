Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B649E621B4E
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiKHR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiKHR6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:58:41 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70E41FF80;
        Tue,  8 Nov 2022 09:58:39 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bs21so22224053wrb.4;
        Tue, 08 Nov 2022 09:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TxXsdnnL/UQNns1x2IBQo7m3t5OBViQXtLwqC2rEvOw=;
        b=NxU888jiud/7ecZiCvco7myv3EfLdXpQ9tPwc93NbqMk5MDDIqEqutoKEPdIS0h8SN
         78/kByCUTbZplqFD1n499+ddQZbIAQEQ6v4z1Lc+cPwZqBQPyMnDX5w3vzuN85S4VAmN
         uBEooUC8wb65TOp0reOEyJDNe9xPvkVfE5Qd5D3nU1TEIGyy8edrmAinFywc8eoDO7AG
         bzDI/hEcLNaEl9EugjZ5xSOuqyrd2WGPzbd8z9AOmxeQLDWDoWeVC5UKjrM7itNDgTdy
         w6UZd2lhIJ+68mgCHOkt5EJBQVj2nus3dUPPja88lSWgQbcfjwIyzGRByJ08BNp2DNUU
         +6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TxXsdnnL/UQNns1x2IBQo7m3t5OBViQXtLwqC2rEvOw=;
        b=3fk8TKAgGs/ApHTnyl/BtpK6WJhzd9utrRgxUGlITvDDJFsWgelu+RLkNYCHk4hVvR
         jBMAOdR3T2y7vdvUX5uQXXRonDNhf90I3FrBZFhR4k2JzsrEFeqCpiVKrJrWx4x3tkHQ
         xYbdIlyyRzXzFZLEBjgLZzG4+e3NGqYA/XjBDrRPAG4vGbXeLUfsYw7vYOwnTH55KG/8
         zb0VNvLgDgrDWK2o009O7SwRPwGdYw/kTVwUB+bPv7csdRwuvJ8t9laLlceh93/ZWv57
         RtzylQA+V4RwDMtHtxF6M6TpHN2x35tayjO4ZgxvheQXN7KqZomXW6t/etRsCp8cv8f8
         9R0A==
X-Gm-Message-State: ACrzQf1YWnvhhzvkfU3g5ymMKxTHet+vNDopKabfTRQrmOiAnuARkXPo
        MOmG1ZHCBBIEJNuflzCQR7xex/IN4D0=
X-Google-Smtp-Source: AMsMyM7Y9ycxjh29Wcsn/2Zha12t1j7LsVM+JYAuJhSO0rAgP9BOAUO1qG8eGat4P3yF7OJx02NCbw==
X-Received: by 2002:adf:dbc5:0:b0:22c:c605:3b81 with SMTP id e5-20020adfdbc5000000b0022cc6053b81mr36178453wrj.218.1667930318419;
        Tue, 08 Nov 2022 09:58:38 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id k4-20020a5d6e84000000b00236722ebe66sm11054650wrz.75.2022.11.08.09.58.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 09:58:37 -0800 (PST)
Message-ID: <febe8f20-626a-02d6-c8ed-f0dcf6cd607f@gmail.com>
Date:   Tue, 8 Nov 2022 19:58:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lkayal@nvidia.com, tariqt@nvidia.com, markzhang@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221108140614.12968-1-yuehaibing@huawei.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221108140614.12968-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/2022 4:06 PM, YueHaibing wrote:
> 'accel_tcp' is allocted by kvzalloc(), which should freed by kvfree().
> 
> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> index 285d32d2fd08..d7c020f72401 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
> @@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
>   	for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
>   		accel_fs_tcp_destroy_table(fs, i);
>   
> -	kfree(accel_tcp);
> +	kvfree(accel_tcp);
>   	mlx5e_fs_set_accel_tcp(fs, NULL);
>   }
>   
> @@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>   err_destroy_tables:
>   	while (--i >= 0)
>   		accel_fs_tcp_destroy_table(fs, i);
> -	kfree(accel_tcp);
> +	kvfree(accel_tcp);
>   	mlx5e_fs_set_accel_tcp(fs, NULL);
>   	return err;
>   }

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
