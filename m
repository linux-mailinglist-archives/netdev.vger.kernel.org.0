Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658F931D385
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhBQBFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhBQBE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:04:58 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12792C061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 17:04:17 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gx20so538949pjb.1
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 17:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QLg3G/fjGuiW4ZOwwhcwF1Foakoaxcg3/v6Y+9vissI=;
        b=h8G331O5KHx4NPQjhFcYbstW6Gk4O1PNlFlCIC6D0pGwpyZrNgFeUCc+Kw2PzqVYWw
         MNkpLhnAiypIvwXRJOOB1Dpg3msp59/5W1KUe/RUlDBIo1lnDN0HlndHaPkoSomsH6wr
         GVrotH9g09fmV5JqktB9I2uY0yDgjZSveQ/Vez0y/iuJOaz/TXDwoynqkInqFDu5bkh9
         YtWN53jpLY/8Kvykg4EYyYKeKajuYFp0z+ChtpZ47dvQxL4VG8wIYmsUBM/YLEH8OHvx
         IEpJRCuQuj30KS+kbBNJAm9VMfgO1ngnaJ2bNtWp270AFdQDX5fp7AHYRGGpaHKMFA4c
         5p+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QLg3G/fjGuiW4ZOwwhcwF1Foakoaxcg3/v6Y+9vissI=;
        b=sRkgVSKzcPD1BJFsNSZTbeg4C8LP7rYOwgivkGsxQCkvcdsKuazs9Ld9xYNO3eFSyO
         YxWtQQojjPdrB61dSaqD0h1u2xRk119fA4obKsztpdCc0snKoV/5NT3Pw/32QepD/+GO
         4we7XNY2VjlAexreR5fInJR+HZofH/tJlvumOFsfHCvTLytzw3mvLJI3cO0Yk2VdKFN8
         qmDwxenAroqN8+nISY7cs/xeXEnKZ5iBZ8sNa7NzoZEjpvF/iunS8zLTlRQhuPOtqlq8
         moggjA+AFaKjbZFirLBM3+v0a4sT/QdWk+bf6d/ICXyhfNrGlW644hUZowckEPOWVbzs
         hd8w==
X-Gm-Message-State: AOAM533PsMDHzxqz1SvL5fBsTwqFFEn1/45TYsNcOlT6vlE0oEkvi32W
        uTWgs4w9oyqwkV48HVnJg3M=
X-Google-Smtp-Source: ABdhPJy9hcTv3i8V18iYwSxN7BfTlZWgcZIpScTkrqErXLX9/5Gjf0R/Hc13O+pVv8nyVATmLwd3zA==
X-Received: by 2002:a17:902:bcc6:b029:e3:f95:6da5 with SMTP id o6-20020a170902bcc6b02900e30f956da5mr22487772pls.6.1613523856581;
        Tue, 16 Feb 2021 17:04:16 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e16sm272127pge.17.2021.02.16.17.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 17:04:16 -0800 (PST)
Subject: Re: [PATCH] net: dsa: tag_rtl4_a: Support also egress tags
To:     patchwork-bot+netdevbpf@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sandberg@mailfence.com, dqfext@gmail.com
References: <20210216235542.2718128-1-linus.walleij@linaro.org>
 <161352360748.27993.16056070788425010106.git-patchwork-notify@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f985a670-e537-8989-12d1-40f73593ba3c@gmail.com>
Date:   Tue, 16 Feb 2021 17:04:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161352360748.27993.16056070788425010106.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 5:00 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Wed, 17 Feb 2021 00:55:42 +0100 you wrote:
>> Support also transmitting frames using the custom "8899 A"
>> 4 byte tag.
>>
>> Qingfang came up with the solution: we need to pad the
>> ethernet frame to 60 bytes using eth_skb_pad(), then the
>> switch will happily accept frames with custom tags.
>>
>> [...]
> 
> Here is the summary with links:
>   - net: dsa: tag_rtl4_a: Support also egress tags
>     https://git.kernel.org/netdev/net-next/c/86dd9868b878
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

Woah not so fast, 1h05 minutes to review a patch, how are we supposed to
keep up?
-- 
Florian
