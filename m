Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0FF6B844
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 10:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfGQIdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 04:33:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52315 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQIdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 04:33:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id s3so21219273wms.2
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 01:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DPqMvnqkO8b0h+ZSKhMZDugdDV7HoHpxp4MnEW4lcak=;
        b=eUzP8vOOcOCpZdDTDtZMq8j5klOev1qCQLhczxgsCrLubpe8mKKSBUQrEbueKBcgQN
         BX2uJ5KLH2zTI8j+07PS8/T1MSqimUj+LTNHlWCfBcNe5lbE4fK58teFMt0+iMSeGVZq
         hC/ldGSbrEazvJZzedu5+t7zGIL45TcGIL5AFaBWhX6h99twg+CAuGhgBYDcmlmOmQHX
         ZlMoaAB/SkJGA7gzLqOqRDscbNIFLSU69SWp3SF41I3I7+tG6snuHpg44CHR81G8h9nB
         UMKvUjFCmpylCbQstzC5OObRd7QeVtE0g0vpKpCIb4xP4Zgu/ccjTNnB0NjKmweYhTHW
         q2xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DPqMvnqkO8b0h+ZSKhMZDugdDV7HoHpxp4MnEW4lcak=;
        b=RRltgJoT7529JBYm8grHf/gZdQ3QMgK5uUDBwvPCZ5lPV1mKYr1xkgqopm0bcioh5Q
         0hK6gjGgczEHzuDGbJBQ2qz8+yhyPasia5X4Du0rAKQ1larXmYEDQ7aWbUm8vyqkS6ZQ
         XofT5sYgrUwRgLY0imeA1SVVeN8uzvj0N9Josum3F35Lr5kZmXg8tJtX/7hlcjsrCdgs
         DSVSihxIElqBcr3YjFKnKSnxDp/rmgWP9BiUrcSbD7IrmySRtrb5WArGmomzgj4SRCrh
         iqg2G3o404Kj9o2NBGMg5Quq40hnWlqRCUJv5TFC0PqtDb7tfRjy5MK55xvqJP/1eQU/
         lAqQ==
X-Gm-Message-State: APjAAAWc8WMKrcrWgnbd7g7tYUY/mVk5MUJSgKMCAI4WGTy4DFV6GAYy
        NSPbclhQF4yKtTz3Kg5K2j8kWQa8
X-Google-Smtp-Source: APXvYqw1nmr3GOo9u4tfs77lyr2WrNTr6WM5KkIbrH+MjahC/azFwJNv7OpnlAH/vCgcRi2y333GEg==
X-Received: by 2002:a7b:c206:: with SMTP id x6mr35178071wmi.156.1563352430569;
        Wed, 17 Jul 2019 01:33:50 -0700 (PDT)
Received: from [192.168.8.147] (189.163.185.81.rev.sfr.net. [81.185.163.189])
        by smtp.gmail.com with ESMTPSA id e6sm23566749wrw.23.2019.07.17.01.33.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 01:33:48 -0700 (PDT)
Subject: Re: [PATCH] net/mlx5: Replace kfree with kvfree
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190717080322.13631-1-hslester96@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2102aecf-03f1-0235-4ae1-93830b437f83@gmail.com>
Date:   Wed, 17 Jul 2019 10:33:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190717080322.13631-1-hslester96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/19 10:03 AM, Chuhong Yuan wrote:
> Variable allocated by kvmalloc should not be freed by kfree.
> Because it may be allocated by vmalloc.
> So replace kfree with kvfree here.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---

Please add corresponding Fixes: tag, thanks !

>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index 2fe6923f7ce0..9314777d99e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -597,7 +597,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
>  	err = devlink_fmsg_arr_pair_nest_end(fmsg);
>  
>  free_data:
> -	kfree(cr_data);
> +	kvfree(cr_data);
>  	return err;
>  }
>  
> 
