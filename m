Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51F01623CA7
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiKJHbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiKJHbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:31:07 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D7C32061;
        Wed,  9 Nov 2022 23:31:06 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l14so992934wrw.2;
        Wed, 09 Nov 2022 23:31:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8/dow2hr+K/Ps/4l2mFEzK5sJM1FFNyn+gsI/aO7eO4=;
        b=ejjW8NpxCmMk59Fll40y5nfBo5eGvsyzWSfCUvEQHttAnj3UTYI+yns7e2t+lrqUko
         rjbodonumcpbIOHPzT+NkqZkpqZalvYhz4M60Eb6u4UXxHiLGu++6SVC0dz2Vx+PwH7j
         3Jf1PV3EHQCqXZABGHpew3OTNH/EHnDsyc8+HB6HYieLg6uRpwfz+534DK3gq4FaIBSW
         w7JTJIdrY1YbNqJG7GFNP5MCIsJLW6R9lYkOYf5EQR387Ygzvd2xNA+J8YxtFGWmUN4K
         q73z969yAo8FakFLXXWk+iQHbCmtOCHiedZzc8q9o7cBe7M+DoqkRCmZzpZj0/eidtbw
         pCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8/dow2hr+K/Ps/4l2mFEzK5sJM1FFNyn+gsI/aO7eO4=;
        b=W5JNAhrSDIjTLssVsZZS2wa7xoCoEF/z5TVGJT0dG/jIjPX3bWdOsW48v6pqAOlDIi
         OlxMZuZFDvigbY9ED/VfbVpn+Vd1Y7EJIatTI8stIs8qewalnwv/vvCcLMWtXHxysfS6
         Md3MpY+7fhkd9lvmKS5JUU55saTcIW0Dyt4zgktMiv6HptoHDHaMSoyYJhsWDDSjtlOu
         A/il5m/7t72vtG0nu5A5dp4SZkJjl2ofe4v2Px/eGCToffY8DacIarVHo5bg6aRwqYON
         de50dns5c+y8J8rghqRyhw2N8KKwvvghOjVExLebULVrUjRo2b6k7XzfQGZlDl38HdjV
         wDXA==
X-Gm-Message-State: ACrzQf3wQ01nXJb3uwxQecgeNfUT25YGwVD7KZxZQ5FsSRURxxxBgwr3
        5QuX3Mj8Zan9bPA/Bj9UfZYHUx0lAe8=
X-Google-Smtp-Source: AMsMyM58b9in8nxGVUHqTWpUM5omfbM7Q/xvh7mppbSkxDOClpOqs5UeghFX9htgE2b0M++LTpS/3Q==
X-Received: by 2002:a5d:6688:0:b0:238:3e06:9001 with SMTP id l8-20020a5d6688000000b002383e069001mr24032704wru.308.1668065464418;
        Wed, 09 Nov 2022 23:31:04 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c029a00b003cf5ec79bf9sm4102754wmk.40.2022.11.09.23.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 23:31:03 -0800 (PST)
Message-ID: <ba0c84f1-1d99-c0e4-111d-bbd14047ca0b@gmail.com>
Date:   Thu, 10 Nov 2022 09:31:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] net/mlx5e: Use kvfree() in mlx5e_accel_fs_tcp_create()
To:     Eric Dumazet <edumazet@google.com>
Cc:     YueHaibing <yuehaibing@huawei.com>, borisp@nvidia.com,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, lkayal@nvidia.com,
        tariqt@nvidia.com, markzhang@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221108140614.12968-1-yuehaibing@huawei.com>
 <febe8f20-626a-02d6-c8ed-f0dcf6cd607f@gmail.com>
 <CANn89iKqm9=uyoymd9OvASjnazQVKVW1kwOxhpazxv_FGaVpFg@mail.gmail.com>
Content-Language: en-US
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <CANn89iKqm9=uyoymd9OvASjnazQVKVW1kwOxhpazxv_FGaVpFg@mail.gmail.com>
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



On 11/8/2022 9:45 PM, Eric Dumazet wrote:
> On Tue, Nov 8, 2022 at 9:58 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>
>>
>>
>> On 11/8/2022 4:06 PM, YueHaibing wrote:
>>> 'accel_tcp' is allocted by kvzalloc(), which should freed by kvfree().
>>>
>>> Fixes: f52f2faee581 ("net/mlx5e: Introduce flow steering API")
>>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>> ---
>>> v2: fix the same issue in mlx5e_accel_fs_tcp_destroy() and a commit log typo
>>> ---
>>>    drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>> index 285d32d2fd08..d7c020f72401 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
>>> @@ -365,7 +365,7 @@ void mlx5e_accel_fs_tcp_destroy(struct mlx5e_flow_steering *fs)
>>>        for (i = 0; i < ACCEL_FS_TCP_NUM_TYPES; i++)
>>>                accel_fs_tcp_destroy_table(fs, i);
>>>
>>> -     kfree(accel_tcp);
>>> +     kvfree(accel_tcp);
>>>        mlx5e_fs_set_accel_tcp(fs, NULL);
>>>    }
>>>
>>> @@ -397,7 +397,7 @@ int mlx5e_accel_fs_tcp_create(struct mlx5e_flow_steering *fs)
>>>    err_destroy_tables:
>>>        while (--i >= 0)
>>>                accel_fs_tcp_destroy_table(fs, i);
>>> -     kfree(accel_tcp);
>>> +     kvfree(accel_tcp);
>>>        mlx5e_fs_set_accel_tcp(fs, NULL);
>>>        return err;
>>>    }
>>
>> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>>
>> Thanks for your patch.
> 
> Although this structure is 64 bytes... Not sure why kvmalloc() has
> been used for this small chunk.

It's a small chunk indeed. Unnecessary usage of kvmalloc.

Although it's not critical (used only in slowpath), it'd be nice to 
clean it up and directly call kzalloc, instead of aligning the kfree().

YueHaibing, can you please submit a v3 for this?

Regards,
Tariq
