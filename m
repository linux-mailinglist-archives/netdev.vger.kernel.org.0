Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243C0422364
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhJEKaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbhJEKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:30:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED7BC06161C;
        Tue,  5 Oct 2021 03:28:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p13so48563757edw.0;
        Tue, 05 Oct 2021 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ShOmW/2RWuxjsq4/QuGLlOjUEiq6tFtOZJVvEHgoGug=;
        b=LDHrbn7aoB+cQkNUG+FKJzSRxh3FGMaHoTMs12H3MCvRTB/9tIvK7NOHsJLesPDVh4
         EzlcmQowczdMBNzUenbcFcQCf7ADV1cFmCBI5vmgEOF0B43ZC8iiW3a7Wi6a71kFtIG3
         l7q+82K77CNL14Yta4fokwaywc0epu/NKmJt7BB/yrd3xv7L30JZzuvU74+xoXfRf43D
         Y/hdovmns3Js/QDY0BEMhNJby+g+qIsaKSfGcN16HgBzro9oXX0zJGDkPQkSqbUjQFpC
         QpQSpwi+zMwicFIejFpAEPUK/ENwgb7dsnnmOf5LjGYua16JAQaiiTM0G42dY2DizTpQ
         lzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ShOmW/2RWuxjsq4/QuGLlOjUEiq6tFtOZJVvEHgoGug=;
        b=r0TNIodil6+/5m12oRAeL3oecFd1W7elZpv+9HI75kuMEVJPNDgs81Q0uXGcS1gbDS
         fNozELWMawT1wNMMMKaq74KedUoKLidzu89WUOoS4k+dvU0tQvzIHECTAN89QX8d1pBX
         1fT0AiUu3X3vTT3oYjzZ8m3QXcxgPPet1DOg/6e7GbfAc4BpHmiuJzC5QXv28g5f1qso
         Fm73tkymeQL/CwcBQUtwKGh9jFYTFYRmInzXJ+peNExzQOTDFEyxUYNkptY108J1C/kR
         UOqI1ls13vyE+zXAHzcWtsMgpx2CPgTsBmvF3KO5Mc5ag5R+viNNlyPDt1949hvWWR8b
         6Sgg==
X-Gm-Message-State: AOAM533dqkZF/cJsm1m1mN6LRQl13lLvHDDLUPYvUyjaLL5022MY4IzJ
        GDzvtsY7RXLEwXLxb9b7cVakkm/PH6w=
X-Google-Smtp-Source: ABdhPJyYB6zKyhj5+BkQuBUj1gr4St7CvGZHGHlYKNvvV9oT2LcIzG31A4tMcrxU/yt+8LWqppSuqw==
X-Received: by 2002:a17:906:d107:: with SMTP id b7mr23711400ejz.541.1633429705854;
        Tue, 05 Oct 2021 03:28:25 -0700 (PDT)
Received: from [192.168.0.108] ([176.228.98.2])
        by smtp.gmail.com with ESMTPSA id g9sm7671660ejo.60.2021.10.05.03.28.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 03:28:25 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] mlx4: prep for constant dev->dev_addr
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org
References: <20211004191446.2127522-1-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <d2c490a9-7f52-bc6d-ad58-48011d1816aa@gmail.com>
Date:   Tue, 5 Oct 2021 13:28:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211004191446.2127522-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2021 10:14 PM, Jakub Kicinski wrote:
> This patch converts mlx4 for dev->dev_addr being const. It converts
> to use of common helpers but also removes some seemingly unnecessary
> idiosyncrasies.
> 
> Please review.

Thanks for your series.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

> 
> Jakub Kicinski (4):
>    mlx4: replace mlx4_mac_to_u64() with ether_addr_to_u64()
>    mlx4: replace mlx4_u64_to_mac() with u64_to_ether_addr()
>    mlx4: remove custom dev_addr clearing
>    mlx4: constify args for const dev_addr
> 
>   drivers/infiniband/hw/mlx4/main.c             |  2 +-
>   drivers/infiniband/hw/mlx4/qp.c               |  2 +-
>   drivers/net/ethernet/mellanox/mlx4/cmd.c      |  4 +-
>   .../net/ethernet/mellanox/mlx4/en_netdev.c    | 37 +++++++------------
>   drivers/net/ethernet/mellanox/mlx4/fw.c       |  2 +-
>   drivers/net/ethernet/mellanox/mlx4/mcg.c      |  2 +-
>   include/linux/mlx4/device.h                   |  2 +-
>   include/linux/mlx4/driver.h                   | 22 -----------
>   8 files changed, 21 insertions(+), 52 deletions(-)
> 
