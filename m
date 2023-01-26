Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAD667C479
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 07:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjAZGd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 01:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAZGd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 01:33:57 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD8E2BEF4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:33:54 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id m7so715517wru.8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 22:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=woby9x0ujsJ8/IY8hRR7+uQP8FZHkGIl73gCYukvzgY=;
        b=WqAtTJULzCteScTNuVc67D8EHg8tsT10VPvpkAu1KUxh2hHIxy9hnCqN7HMFyCJZFn
         gL+QiijXIME8oEm0QG5K6vKG6f2x3n8QX33tQBpJOwgXsOv6ia3PaW8MiEJCKLBeKB/0
         zDjgE6p9LfUYWNx8O6hwV6e0SCNi7tSu/v6GWG0nY/e5kjGMy+0Iq8tX+V3O55lVj3Nc
         78vqLEko6Z0a7pKVfCVvUmCum4cYx3BTfSGnsU+U/moTXb1U0GoMCU9Uz+U6mGHXRV8h
         3TdOmK2qHGKewkZjjWrIoy6hYN6kHHZv+xye/eCJ+k9kNqANdahnB/fl9TtPm2cnjAM8
         /8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=woby9x0ujsJ8/IY8hRR7+uQP8FZHkGIl73gCYukvzgY=;
        b=HMSXy/qXIycyc7DWrWH18pDR76ODfZopAKIpMpTCr9tD8jaodAR89TrAfqwWDn0WU8
         1SdxBikAiemi9rFGVZesHX1B6+I41jHnsyipHLPMnUDmAbl8y3LlPFUPniZWdcakfVeK
         0LXiK/uU2JLQ6DuQKifhQU3CVYq8BfnszklCDLHfyA1hsmgdLCjvNCsY62hk3QVQ88ht
         /IymHo32G6GT/84p5l50LpA3r5py+XAWFJ9XD/bEp4ilLIl52U47LNEtRJzJRNWvEnXn
         zXdJiilvTORdbCU2EKgpjxYoD4KMQ8uLsYQkzD2PmzNaxMn2zwPNNU5hWn2/GLsWC7bD
         tBhg==
X-Gm-Message-State: AO0yUKXsomWfNG0G/IUOoi2r/VvgbvcjJaX3TLSeiI5Zn/zgk8S15tH5
        UeNSoDzOh2STunCwEGCEaws=
X-Google-Smtp-Source: AK7set9/UOx9umCCeFyqATs3AkN2ya9AMPyHJB8H/zxy65q26NFK71yz59Ldlq+TsVFjePi3pDm69g==
X-Received: by 2002:a5d:65c5:0:b0:2bf:c338:8673 with SMTP id e5-20020a5d65c5000000b002bfc3388673mr1344379wrw.41.1674714833123;
        Wed, 25 Jan 2023 22:33:53 -0800 (PST)
Received: from [192.168.0.106] ([77.126.163.156])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d6da7000000b002426d0a4048sm389061wrs.49.2023.01.25.22.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 22:33:52 -0800 (PST)
Message-ID: <1b9571f2-eadd-5cda-a368-78d6ce4ae873@gmail.com>
Date:   Thu, 26 Jan 2023 08:33:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v3 1/2] mlx5: fix skb leak while fifo resync and push
Content-Language: en-US
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
References: <20230126010206.13483-1-vfedorenko@novek.ru>
 <20230126010206.13483-2-vfedorenko@novek.ru>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230126010206.13483-2-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/01/2023 3:02, Vadim Fedorenko wrote:
> From: Vadim Fedorenko <vadfed@meta.com>
> 
> During ptp resync operation SKBs were poped from the fifo but were never
> freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
> napi_consume_skb to properly free SKBs.
> 
> Another leak was happening because mlx5e_skb_fifo_has_room() had an error
> in the check. Comparing free running counters works well unless C promotes
> the types to something wider than the counter. In this case counters are
> u16 but the result of the substraction is promouted to int and it causes
> wrong result (negative value) of the check when producer have already
> overlapped but consumer haven't yet. Explicit cast to u16 fixes the issue.
> 
> Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 6 ++++--
>   drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 2 +-
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 

Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

