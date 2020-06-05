Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EE41F00A4
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgFET5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 15:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgFET5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 15:57:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9796C08C5C2;
        Fri,  5 Jun 2020 12:57:17 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id 5so3282423pjd.0;
        Fri, 05 Jun 2020 12:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=smVLscndUtcWIRf1BUBIrZ8L43w9eNyfqzYmsNy1U90=;
        b=tG9yM4X0n4Sj0dzcSzE1E9fhSOml70QBV5f2ujB8mXAoe3tNSs/GA77dwFICRpe7fc
         7GudSoCRk+469e/fRE7TK8QKX0EEtdnTcQz7NZUZxPxqfCoHw1uQTAydtdqUTvkINBsv
         7GfmCxAKmLx+li3RT29ncAHpPEIkWYC2oAkCGBenxBm6RqdV5p85B1zu2ngB/zNN4KFM
         SwwFmMsrAYtDvIi1lbv/9GJA0EA50n6OGG92fiw5S0bRvhBURrIyNURmbJ7AIPLnaaA6
         MCUXwRnQkG5Umbk923aZjUTq3uD/pe9u0MU/F20cwJ4ge0mqpoxNqhAPU5PrBYM0CjOq
         i5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=smVLscndUtcWIRf1BUBIrZ8L43w9eNyfqzYmsNy1U90=;
        b=b/D8GRDTzsRKhmbjgVNsElpm3Iigh8rK6T3xb8ckPvDF7CYt5hRiJoAz9Ur7P8EGln
         lHLGPsuVicAlFcnP6QRVLjlNnqSkyP3EfNHyIYaBFV1tzUmHpi5sXF1l4LMQvxW9BDrj
         M45YhEOrEMSB2wMmHr7qDeJOkphO/6HgrHj2cIsjaa/Mr54f5qTDQg+H/R4T4SHfNSja
         fDu9HD2K8I3bmj7eICbLoH0qUbgPCGNzsWC0uiERthfpzGnawZM6HLD/7/bTSE++93wF
         lW4n9AcsXPqdFGcEmXeaBq3Gx3QDDw5N0Bk2NG6POGP2aZhovKFYNnhtbSlVhfaYyzxZ
         XXWw==
X-Gm-Message-State: AOAM533wOhS+JpM7S9GwauxYbVoFaXJgbShnCEzLnpB4LuCLWJBVdLgw
        FxNZXTWjPLjeqtM8Jk8O/IjXQ7s7
X-Google-Smtp-Source: ABdhPJx5EDz7GQ03t3fgg5ewaTRinFEZc1l3wNG+RU71+4I4Cx1t8+RAFslb0CxNhsjFjJcvQj7cgA==
X-Received: by 2002:a17:90a:9d8b:: with SMTP id k11mr4958176pjp.10.1591387037105;
        Fri, 05 Jun 2020 12:57:17 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x1sm358759pfn.76.2020.06.05.12.57.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 12:57:16 -0700 (PDT)
Subject: Re: [PATCH] net/mlx5: Use kfree(ft->g) in arfs_create_groups()
To:     Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200605192235.79241-1-efremov@linux.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1cd5f60d-4a42-f7ba-1d0b-2303470a1f73@gmail.com>
Date:   Fri, 5 Jun 2020 12:57:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200605192235.79241-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/20 12:22 PM, Denis Efremov wrote:
> Use kfree() instead of kvfree() on ft->g in arfs_create_groups() because
> the memory is allocated with kcalloc().
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> index 014639ea06e3..c4c9d6cda7e6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> @@ -220,7 +220,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
>  			sizeof(*ft->g), GFP_KERNEL);
>  	in = kvzalloc(inlen, GFP_KERNEL);
>  	if  (!in || !ft->g) {
> -		kvfree(ft->g);
> +		kfree(ft->g);
>  		kvfree(in);
>  		return -ENOMEM;
>  	}
> 

This is slow path, kvfree() is perfectly able to free memory that was kmalloc()ed

net-next is closed, can we avoid these patches during merge window ?
