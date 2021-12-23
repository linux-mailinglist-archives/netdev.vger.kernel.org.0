Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70E247E865
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 20:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350100AbhLWTe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 14:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350022AbhLWTe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 14:34:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8ABC061401;
        Thu, 23 Dec 2021 11:34:58 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w24so5075240ply.12;
        Thu, 23 Dec 2021 11:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=gfqJf7SzIqbcHPeGopiBGrOBFpo1yLWHJgtQyrjtfMY=;
        b=TcE1IvMrcW0NGYIvwnazCqtyBlz4RlhZYGOGu5TtQ20BhpOzZD57qxc1wuZzOqHIgY
         X4+Jwa40ZqUzo/zGlhh8VHdPIRgleOaLLXhbqi0gv6YtxM54DBNwlZ947nvGKa0C75gd
         +t1wkPQXiaS0167CMDjS+rc2b/Lj1UYOzGURWJfA+L6wmmzAxQ86bn40RHUSgf64mK0V
         1CkxGBVV0KOP5P7KYrrddGRvTiVo4UFVZ1EQtON5dX5aQe8CYIxXuRSapZchWMiHYdQp
         FxJEOsa4KWIZw/TzXN3FkVushZTQPipN3PowhfKbAd6bRLdOLrGNYyJ0jK7cemr7GgWZ
         pLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gfqJf7SzIqbcHPeGopiBGrOBFpo1yLWHJgtQyrjtfMY=;
        b=mUUAAZRSo/qGNvJN2ouzTP+lvUiN0fs+iWMUL7gaRBKE4I5gkJf2KG8Qy0VE+Pn1MY
         vnCVm4YSeyC3kzhto0CoZpsTBy/rA1QQPOi+6xCsFqWaB5VwNp69AZU4xNIKRrkh2ZJa
         aTyOAWC64RmZIpzDYZuYnEH8qHeFBxGWF3+QasIg/7hvAbnshdu6xBabRbSkejhv3zxi
         Unan3mC9ua2gSyyuCWhwfxz7x4gy4cFv6ignyuXFAdMfWFXHH39Cl5msU9CGVpoFyVFo
         ewKXM2LaHhd0881p5I+z8tBVvoc0DxI/6Q3wXcGcpZKfVLp0EfsYn68kyPuhbk56VsHr
         72zg==
X-Gm-Message-State: AOAM532G9yvymL7T2UbrEgXfTowY8BYCR5dC2sbzs2EU/LIVqYx+4aZF
        bYyNCcNu7EW8V1hGxCYh1tU=
X-Google-Smtp-Source: ABdhPJx8VCGJ20VqDfKx0XJ2RzpGIAoKL9LsmWga+flt80us4x7/eBQQ2xQW6YrYBZOKIKUgAGDVlg==
X-Received: by 2002:a17:90b:30c9:: with SMTP id hi9mr4166574pjb.216.1640288097932;
        Thu, 23 Dec 2021 11:34:57 -0800 (PST)
Received: from [10.2.59.154] (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id ot6sm7116933pjb.32.2021.12.23.11.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 11:34:57 -0800 (PST)
Message-ID: <d8cf5bd620e65351dbd82d18b0426a22ea77eae2.camel@gmail.com>
Subject: Re: [PATCH] net: ethernet: mellanox: return errno instead of 1
From:   Saeed Mahameed <saeed.kernel@gmail.com>
To:     Qing Wang <wangqing@vivo.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 23 Dec 2021 11:34:55 -0800
In-Reply-To: <1640226277-32786-1-git-send-email-wangqing@vivo.com>
References: <1640226277-32786-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-22 at 18:24 -0800, Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> mlx5e_hv_vhca_stats_create() better return specific error than 1
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git
> a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
> index d290d72..04cda3d
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c
> @@ -142,7 +142,7 @@ int mlx5e_hv_vhca_stats_create(struct mlx5e_priv
> *priv)
>                                     PTR_ERR(agent));
>  
>                 kvfree(priv->stats_agent.buf);
> -               return IS_ERR_OR_NULL(agent);
> +               return agent ? PTR_ERR(agent) : -ENODEV;

the single caller of this function ignores the return value,
I just made a patch to void the return value and added you as Reported-
by.

Thanks !


