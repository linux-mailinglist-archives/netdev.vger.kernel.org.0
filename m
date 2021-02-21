Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99DC320B48
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 16:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhBUPNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 10:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhBUPNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 10:13:19 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2DCC061574;
        Sun, 21 Feb 2021 07:12:38 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id a132so11292830wmc.0;
        Sun, 21 Feb 2021 07:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hVPLyZWHBaek1PHFbgLhkSmbsjxi38Z0pvK15Xdkh6Y=;
        b=PS7zYxa7ltZ7qfh2gyPQjQxojgjx8WdwXt4IirBhppjB1+z+2AkimmvUBdjk7QzFJU
         fWPifxCji2zMrdwAU4cv/wTd2ngsLmUzch29YlbxEz1crTmP1lLZ/KNsfMkLOrLACI5k
         +3uVQDHf5Z2OpLENvLC4JgxsGoOjQlZ039ePrtJRvVx4bqKSZqFjnYD6Kiwb89/m/U7B
         YtiYMHzJOxhgpGguVQ4cYhRs8mn9YEsLPdASvD15z1ZniHcTXN1UiGNBXud52Bh5BVqg
         sydQKaFeGZ90mxF+dHhqOCHIg9pAsqUNvS4SCtV6BsybZsYokhFxgt3gARLcVE2fEVzh
         zCEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hVPLyZWHBaek1PHFbgLhkSmbsjxi38Z0pvK15Xdkh6Y=;
        b=HXwDqbSKjrJbBR11AdwNGy4Y18MDJeTDoHB8OXf6OTQT6TSc+z1rhfZLnmTiKThaHL
         PUypwVpbMiQ43pb+HN60ZAbLjHGeQHNStmmY2kwuxXrcBhR+24nh0i+AthMFqAAbspZr
         HXR7hzKxPNQoyb2kPLXxVIY3XF9Pq26IvxLdrJIFt41b24o17M8BYXO+rH36Uh0Y+6n+
         kEW9bbptA/780H6lvrj7oUDyVCOVMiYlFC7XhRxDSCxTcnaaOn42IlkXGloet8O214Fj
         bZriBkxFaL2RvRkFUCF34H7naZ9jVf69Z3Pe8XRdsIJPCgwXjX02vTKcjifhG2sbegII
         sa1Q==
X-Gm-Message-State: AOAM532ds8GgBQQfMTJVVXmW9BnVvZXqMHvuHT5XBHTY+yeOoH7JB5Iu
        Zl9ySoy69OYJb4cFeo0caKvGb1HjxV8=
X-Google-Smtp-Source: ABdhPJzX3UnavSV+so0S/RK3TrofN4wxPfIUmgiQoU3bNvkf1Dyx5MyVdkKgk/QpGAKhgIJUxgTSgA==
X-Received: by 2002:a1c:750e:: with SMTP id o14mr16746293wmc.60.1613920357037;
        Sun, 21 Feb 2021 07:12:37 -0800 (PST)
Received: from [10.21.182.212] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id y1sm24966175wrr.41.2021.02.21.07.12.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 07:12:36 -0800 (PST)
Subject: Re: [PATCH] net/mlx4_core: Add missed mlx4_free_cmd_mailbox()
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Moni Shoua <monis@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210221143559.390277-1-hslester96@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <06072721-31f7-49d8-05b8-19d37fae2061@gmail.com>
Date:   Sun, 21 Feb 2021 17:12:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221143559.390277-1-hslester96@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 4:35 PM, Chuhong Yuan wrote:
> mlx4_do_mirror_rule() forgets to call mlx4_free_cmd_mailbox() to
> free the memory region allocated by mlx4_alloc_cmd_mailbox() before
> an exit.
> Add the missed call to fix it.
> 
> Fixes: 78efed275117 ("net/mlx4_core: Support mirroring VF DMFS rules on both ports")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> index 394f43add85c..a99e71bc7b3c 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> @@ -4986,6 +4986,7 @@ static int mlx4_do_mirror_rule(struct mlx4_dev *dev, struct res_fs_rule *fs_rule
>   
>   	if (!fs_rule->mirr_mbox) {
>   		mlx4_err(dev, "rule mirroring mailbox is null\n");
> +		mlx4_free_cmd_mailbox(dev, mailbox);
>   		return -EINVAL;
>   	}
>   	memcpy(mailbox->buf, fs_rule->mirr_mbox, fs_rule->mirr_mbox_size);
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
Tariq
