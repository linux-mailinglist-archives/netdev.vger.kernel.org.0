Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EA8322718
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 09:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhBWI3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 03:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhBWI3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 03:29:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23270C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 00:28:40 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id n1so24932668edv.2
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 00:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Li9C7SDrwk5rNm7kTQovNBC2vU5jZhQZLg2eIYo6jM=;
        b=ZNnU6QLgunWOxdE81J4XYmT2qrAFVUvYjsZk0TLrupPbGFM0Ag/cNvZe8W/O5+kZ+N
         49Xs7u0A3i6BHsAzdBku/sDGMJx6RgolJJ6fntXvQuCSubEdqvohdRJWA5OPLwkVFF1i
         EQxz4sgXZMYr7FZ1d9i4OVTSM4NOf6CZXbBp47UqcLRP2Da/YvjfoeFLbb0YTQEjlg3n
         khSyEhFb87bQ659lv5w76Apc3DtfIjBLZC2O6HHg3UL3lDC24+MedGfYSJzbZLkIuhp0
         lfxwNnBduPSDH5/ABQ6jnLXWirTuqseILFb65Mar24jVJ+4usvChvQ4Mt/FV1TMu1A9m
         oB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Li9C7SDrwk5rNm7kTQovNBC2vU5jZhQZLg2eIYo6jM=;
        b=Zn1R4MYigZojBzsnrUQDjXLwOjQ/s7L82fZF7KWnH92Evlzs7iEbnBwZLKhEm+lcI5
         R/rKAZJkPL2c+EiUwLZK9gXZEHUNUUrebYEyessp1Uk8rCuWeESUF86W+sGcyp/ZYK6k
         QfNF1dXYvfJYGSFttYX9jnkklpIbn5YLLCzDu/HcwSqvfTC6/BOBGfLVEityWVinn7L+
         qd9e/bzYAK8HwfZRkEGgn2UTvfoi04KwN0HUA9HndqTvg4mYBkZacVuj6OT32Yy3spL+
         UG8HSa2qlbPK3Er4A3sZhvhrFfs0Iays1pbc/w7ofPXvflHdejQJGcYAVjczX2qQt9aa
         /NGQ==
X-Gm-Message-State: AOAM5319eXKFYwTkNqSDSH8B2+awdVdP5KGtUUassSRh5phsi7vm3Pvk
        dt7y+BkCVueKgO1/eF+SWLU=
X-Google-Smtp-Source: ABdhPJxXemTnDp6OByZ3KaE63XFS4ruEO3iOAWU6/Tfo3g05RIz7EAUoVRh31PsCQvAkpUwNZOOuZg==
X-Received: by 2002:aa7:c95a:: with SMTP id h26mr26864259edt.166.1614068918827;
        Tue, 23 Feb 2021 00:28:38 -0800 (PST)
Received: from [192.168.1.110] ([77.124.67.117])
        by smtp.gmail.com with ESMTPSA id m19sm13187206eds.8.2021.02.23.00.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 00:28:38 -0800 (PST)
Subject: Re: [PATCH RFC net-next] mlx5: fix for crash on net-next
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, saeedm@nvidia.com,
        Tariq Toukan <tariqt@mellanox.com>, eranbe@nvidia.com,
        maximmi@mellanox.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <161402344429.1980160.4798557236979159924.stgit@firesoul>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <b0967766-623a-90fa-3875-db9e1ad6a57f@gmail.com>
Date:   Tue, 23 Feb 2021 10:28:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <161402344429.1980160.4798557236979159924.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2021 9:50 PM, Jesper Dangaard Brouer wrote:
> Net-next at commit d310ec03a34e ("Merge tag 'perf-core-2021-02-17')
> 
> There is a divide error in drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> where it seems that num_tc_x_num_ch can become zero in a modulo operation:
> 
> 	if (unlikely(txq_ix >= num_tc_x_num_ch))
> 		txq_ix %= num_tc_x_num_ch;
> 
> I think error were introduced in:
>   - 214baf22870c ("net/mlx5e: Support HTB offload")
> 
> The modulo operation was introduced in:
>   - 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
> 
> The crash looks like this:
> 
> [   12.112849] divide error: 0000 [#1] PREEMPT SMP PTI
> [   12.117727] CPU: 4 PID: 0 Comm: swapper/4 Not tainted 5.11.0-net-next+ #575
> [   12.124677] Hardware name: Supermicro Super Server/X10SRi-F, BIOS 2.0a 08/01/2016
> [   12.132149] RIP: 0010:mlx5e_select_queue+0xd5/0x1e0 [mlx5_core]
> [   12.138110] Code: 85 c0 75 2e 48 83 bb 08 57 00 00 00 75 5b 31 d2 48 89 ee 48 89 df e8 ba 3e 54 e1 0f b7 d0 41 39 d4 0f 8f 6b ff ff ff 89 d0 99 <41> f7 fc e9 60 ff ff ff 8b 96 8c 00 00 00 89 d1 c1 e9 10 39 c1 0f
> [   12.156849] RSP: 0018:ffffc900001c0c10 EFLAGS: 00010297
> [   12.162065] RAX: 0000000000000004 RBX: ffff88810ff00000 RCX: 0000000000000007
> [   12.169188] RDX: 0000000000000000 RSI: ffff888107016400 RDI: ffff8881008dc740
> [   12.176313] RBP: ffff888107016400 R08: 0000000000000000 R09: 000000ncing: Fatal exception in interrupt ]---
> 
> This is an RFC, because I don't think this is a proper fix, but
> at least it allows me to boot with mlx5 driver enabled.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Hi Jesper,

Thanks for your report and patch.

We'll check it and post the proper fix.
I wonder what's special in your configuration / use case, as I'm not 
aware of such failure.
Can you please share more info about the reproduction?

Regards,
Tariq
