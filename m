Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C048267F27
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 12:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgIMKMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 06:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgIMKMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 06:12:12 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F005C061573;
        Sun, 13 Sep 2020 03:12:11 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c8so14732373edv.5;
        Sun, 13 Sep 2020 03:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IMYFUzqiW20Iay+Ejl4kU0YXATxavEXThV4F8sBN6q8=;
        b=InksbMVjgPv+eom5oL2+Zo4rmfq5bAhgYroJtb4xe2mx9DVUitt2CuafAMzXIgm8/X
         fZR56LQUsjw5aKSNu/hV1kn4pAg1whJOaC2kqLtXneg2P7Uuy7GXwHvcirkBH2QHkxyT
         SQBpOTEXWu9c44BKNvWaKBCIUplWoFyuiKuz+EsQYNsJzviLNbMWwuuNZr8nlHauLt0f
         hlDTAMPmDDNYSltRRmxAAMj6hzUiB6xkFook79dYPqkmADwyy9dDqYY+WDi+rdnEgj05
         tiCiT1X4p0LqYyHvaKeEIykyxRZN7tj14vvrQzI+FRf8vRVXSkgge95fi3dZEjrhPM5D
         g7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IMYFUzqiW20Iay+Ejl4kU0YXATxavEXThV4F8sBN6q8=;
        b=rWfZoNFv1FOKGsPR70ScKGuGfOK+W413E7xwo/xrcXx7Aa66r3hoG+f9nZVsN9IuJe
         bvGoxBwwXuHkBPRGKCE7hmIFkVNcHSx3Wik1KsFf3Dr7ehChzSwRXLd2eJHrWbj1NHNv
         dLx9aMCnGpeRcU8zOEc8b/SJZVbyfYX9yAXAOma6wvtnKgOvIMdMd5seVWVW+VT2Ow49
         dtgBj7rNgHhGhZnbiV5iF3llVR4tN1Ce62khGl0ENLlDyGu2Wwu33fwdT6LCrKuHZFMh
         RaaPhQrFm6TKRWPU50grQ7SW+4/wJeT57zNlTz7UtmuOZh6yIzoUR9Jt/8cwa2RqlR1O
         isjg==
X-Gm-Message-State: AOAM532lpYKXYfxmlOnQ0dpz2E9d6dX9fpL7001f6iQXBs3/I89ZT6b+
        8wOvkZnUsy1gdzKHwNnH3bw2egRAkG0=
X-Google-Smtp-Source: ABdhPJx48SitZEcZDyr43jtNWWshqTXviMaD+tRE732awHaswdUb1ag54Dzw2HQppCkKbZHcjdSIog==
X-Received: by 2002:a50:bb65:: with SMTP id y92mr12008083ede.53.1599991929793;
        Sun, 13 Sep 2020 03:12:09 -0700 (PDT)
Received: from [192.168.0.105] ([77.124.39.109])
        by smtp.gmail.com with ESMTPSA id qu11sm5113408ejb.15.2020.09.13.03.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2020 03:12:09 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ethernet: mlx4: Avoid assigning a value to
 ring_cons but not used it anymore in mlx4_en_xmit()
To:     David Miller <davem@davemloft.net>, luojiaxing@huawei.com
Cc:     kuba@kernel.org, idos@mellanox.com, ogerlitz@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1599898095-10712-1-git-send-email-luojiaxing@huawei.com>
 <20200912.182219.1013721666435098048.davem@davemloft.net>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <c0987225-0079-617a-bf89-b672b07f298a@gmail.com>
Date:   Sun, 13 Sep 2020 13:12:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200912.182219.1013721666435098048.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2020 4:22 AM, David Miller wrote:
> From: Luo Jiaxing <luojiaxing@huawei.com>
> Date: Sat, 12 Sep 2020 16:08:15 +0800
> 
>> We found a set but not used variable 'ring_cons' in mlx4_en_xmit(), it will
>> cause a warning when build the kernel. And after checking the commit record
>> of this function, we found that it was introduced by a previous patch.
>>
>> So, We delete this redundant assignment code.
>>
>> Fixes: 488a9b48e398 ("net/mlx4_en: Wake TX queues only when there's enough room")
>>
>> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
> 
> Looks good, applied, thanks.
> 

Hi Luo,

I didn't get a chance to review it during the weekend.

The ring_cons local variable is used in line 903:
https://elixir.bootlin.com/linux/v5.9-rc4/source/drivers/net/ethernet/mellanox/mlx4/en_tx.c#L903

AVG_PERF_COUNTER depends on the compile-time definition of 
MLX4_EN_PERF_STAT. Otherwise it is a nop.

1. Your patch causes a degradation to the case when MLX4_EN_PERF_STAT is 
defined.
2. When MLX4_EN_PERF_STAT is not defined, we should totally remove the 
local variable declaration, not only its usage.

Please let me know if you're planning to fix this. Otherwise I'll do.

Regards,
Tariq
