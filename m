Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE94D1CA6
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbiCHQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:03:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348096AbiCHQDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:03:01 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0021B4F46C
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:02:04 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id q17so25118101edd.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 08:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wtKnn8sOp9gsbylhWR5+etD0D4ZEumu2ZHdO6TvbrEw=;
        b=ISQtERgCGtSoZR1/EpvUwyR4z8ZBueNPZNG5ONTT4cT24tHQBz9fMPLEMZugb6muXo
         e6AHcquLc8l7QJ2Y/UX8MQDsygC23+105e6D/03+bpOXFX6VGheUgCEHbW60hDb0D0Xx
         SprS+OLWs7fhV/VzrYKEeIpKtL/bPWAIRpx52Q6PqpcXH99q/h4y6uKdDS5imPS43TTo
         nJrufA0jJ6jNkeHiHOC+14xPatSJu8OKrr9ihsCWvZSt94XSKB+U51nHMSzb9pdCCrmJ
         oxiAjsZ8GowZ2HJwtcwvJhWsPAOU0SuJ0dHymWswBgIXpsN+J243z5gcQ8nblzukNeit
         qbsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wtKnn8sOp9gsbylhWR5+etD0D4ZEumu2ZHdO6TvbrEw=;
        b=joLZPvjEf4fmAV/cqqi2K3sYrebwJeUCRhyjmPXdiRZlUjQEPOnBSkJD4fgk4G7uuM
         HyzAVQOGi0pZl42ioOCYRH3DWgrILw70BZKB48UbahWcuRqAh0VDMlkyxM5/QK81aSaL
         284nLK8O0DeIyHUJiygBhYFJoc3l5Zg3SMuTxanKtECfbDsHact2grwBPqX32SY65FHD
         5Bw9qZo4y7WrhSpLP72oOoRAlSr/xG9NR4iEHBI8RfGUjxUIxWqrJBVpiD9//FzYm9W1
         Ea5XydANrP0qsqd1cu0N0yWL1Dkcq85ZVd4wk87l94tgp1HDjLvGs0xVNvmyE3z0u5XX
         XErg==
X-Gm-Message-State: AOAM530mXSMQoz5aD+zfqAtgdc8K7SPqpuYOQ8TQuL1E9A8rEaxaDhVn
        0R1PNEMrNAvztHLLKanEcPA=
X-Google-Smtp-Source: ABdhPJxTzuFf3YdXsK6P+ijVuo9xndVFjd1db3ls5tT6xe1h3TwWt0LX0sE00m7aFx6JSbwB8PhKKA==
X-Received: by 2002:aa7:d9c2:0:b0:415:a15e:25dc with SMTP id v2-20020aa7d9c2000000b00415a15e25dcmr16732855eds.304.1646755323424;
        Tue, 08 Mar 2022 08:02:03 -0800 (PST)
Received: from [192.168.0.110] ([77.126.183.254])
        by smtp.gmail.com with ESMTPSA id da23-20020a056402177700b0041394d8173csm7792522edb.31.2022.03.08.08.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:02:03 -0800 (PST)
Message-ID: <2b078aef-76a4-2912-9286-3de4922623ff@gmail.com>
Date:   Tue, 8 Mar 2022 18:02:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 net-next 14/14] mlx5: support BIG TCP packets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-15-eric.dumazet@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220303181607.1094358-15-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/2022 8:16 PM, Eric Dumazet wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> mlx5 supports LSOv2.
> 
> IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> with JUMBO TLV for big packets.
> 
> We need to ignore/skip this HBH header when populating TX descriptor.
> 
> Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> 
> v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> 
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
>   .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 82 +++++++++++++++----
>   2 files changed, 67 insertions(+), 16 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.

