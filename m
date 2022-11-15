Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090F362998A
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiKONEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiKONEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:04:12 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D950212AED
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:04:11 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v1so24109834wrt.11
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwW0uBaAlTpBKUQdxGU5ysEd45I5AdKfsgEBUrRe/Pg=;
        b=p24vwfJQPkjbJXqBOSWAiwvDI3M/74U1EGc5MSZ7+6vnFCGdZyKTPAMxrcvihuKV8b
         q59/t642Ku6xoHJvm3eUFEz3qMAvMIKg7bDaf9Whb2Nzv/O9ywB/ttfWmJIpZ6cnHeZN
         bJHCbuBunq99AZP9q0rxwEzXoGPukKIsQVbwN4fbGQIJlCyxerqL688g+h8/b7loJW8y
         nMi6xc/Av/1CTxQCRkttoA5U5PlyFZr1E0qnJxWwuY1xFOdzlIe95STC42SfhDiM/KVu
         uiuoycO5BRnKFRgYssrQQi9Knd2Jf8LnMTQAiO6shZGYg6DOHH5jxJwhKY0PzBC8z7fW
         mGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwW0uBaAlTpBKUQdxGU5ysEd45I5AdKfsgEBUrRe/Pg=;
        b=4uZeBCOg0kP6/wM7F5wadWGprLCP07J1UXMHjRfNrGDtR48DdJS1jTY9QDlFOMTGg/
         KEZEaio6KuOHW6uKt9A9nJoYKPCDdQln6SdvE22VmWv9oK/Mxhis4qYV2VLKJnyQ8Qda
         yReEqE6TVDn3sC8uEyn/YsfWKimFg61eej4qGU8TzkIEm87H8tAw/Rlou3XtE8E6TABu
         q6Rel1ZDzhR3SYxVu3fDUyu2lxf/OINffvMJbDgPvDW0McynG1It8g3q9rM6QWVazFpH
         9Nu5wa3KdsILoIfa697i+BCpWTjVu5zhVtkgsYN612Bnda+5hnDFWVTcr0jtrJaNvwwL
         c5lQ==
X-Gm-Message-State: ANoB5pkEbY5r/qNp4MN5cyCNM8ylwVmyAHB4rgGlIgyxjilaBjhAeWxr
        MQzl/w+8iq+W8TyhWQdmSM0=
X-Google-Smtp-Source: AA0mqf7fBT4OIl0eI5gxW3SnRLJenoxXhwahnFGD7TF0Y0Uw06Xyftzvp+EonmAZ+lfJ6LQi3gdNwQ==
X-Received: by 2002:adf:f7d0:0:b0:22e:3d63:80bc with SMTP id a16-20020adff7d0000000b0022e3d6380bcmr11279392wrq.30.1668517450373;
        Tue, 15 Nov 2022 05:04:10 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id k3-20020adfd223000000b00236e834f050sm12211526wrh.35.2022.11.15.05.04.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Nov 2022 05:04:10 -0800 (PST)
Message-ID: <d3d9737f-381b-0156-a352-fa5d4fdf8a9f@gmail.com>
Date:   Tue, 15 Nov 2022 15:03:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] net/mlx4: Check retval of mlx4_bitmap_init
Content-Language: en-US
To:     Peter Kosyh <pkosyh@yandex.ru>, Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
References: <20221115095356.157451-1-pkosyh@yandex.ru>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221115095356.157451-1-pkosyh@yandex.ru>
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



On 11/15/2022 11:53 AM, Peter Kosyh wrote:
> If mlx4_bitmap_init fails, mlx4_bitmap_alloc_range will dereference
> the NULL pointer (bitmap->table).
> 
> Make sure, that mlx4_bitmap_alloc_range called in no error case.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> ---
>   drivers/net/ethernet/mellanox/mlx4/qp.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
> index b149e601f673..48cfaa7eaf50 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/qp.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
> @@ -697,7 +697,8 @@ static int mlx4_create_zones(struct mlx4_dev *dev,
>   			err = mlx4_bitmap_init(*bitmap + k, 1,
>   					       MLX4_QP_TABLE_RAW_ETH_SIZE - 1, 0,
>   					       0);
> -			mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
> +			if (!err)
> +				mlx4_bitmap_alloc_range(*bitmap + k, 1, 1, 0);
>   		}
>   
>   		if (err)

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
