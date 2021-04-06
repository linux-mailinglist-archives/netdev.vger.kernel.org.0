Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A330355DB1
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242927AbhDFVNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:13:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37428 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232861AbhDFVNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617743620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n0hWxJLVmdsricryI3Rst9nD37DLk4CPYNA3q9HyKGA=;
        b=U/LxtqZ6aWK8FrKlCHVfYDuT4hypRZlHVOXk+IwPdyV/gXrGQSiOqd6US3fHB4ZKZ8Ceo6
        IBTxlNKoPwxHG3dYDM9nPj2uFSfK/G1ygKF4bJDl4paKONjThOVKL5moP0jfbkegWz8WOH
        xZIr7XM7UsCswOVV/6haPJXfQLetKzc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-pMT5Ysn1NISr01kczrcvEQ-1; Tue, 06 Apr 2021 17:13:39 -0400
X-MC-Unique: pMT5Ysn1NISr01kczrcvEQ-1
Received: by mail-qt1-f197.google.com with SMTP id d18so3723002qtn.16
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 14:13:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n0hWxJLVmdsricryI3Rst9nD37DLk4CPYNA3q9HyKGA=;
        b=IGIAstIPeMf/3ioPcRdAptE3di1wHhPRMSR7YGekS0d2ndusEHE4XjjfggeAWfg+ru
         VaDHoLsnTy2xg+UbSQND26Mnc8f6aVGZNqIcI6XatuHYfxpD4e2YSenFY289EVO7rFMS
         y9nZNa8io+jfVB1Kb8MDyX/hlab+Nu4qtfaHpn9eY6gyLDHap9Z9GyO1UoEBwia8tL35
         r7LV6MI/vOzv9fgWlg/Z7L1yWM6zhqNe5KhQR9+k8k7r6SooBTNS72xpBvVAJgk8RccV
         SLLeFkS8lA+hqbk79DlUGeNhqt3KuOcPFaSA4xp2TRrM9SRe5YWWFINWUHaM4EkRqIoE
         fsog==
X-Gm-Message-State: AOAM532MS/wzUtkmDu2cGITc8CNSN3J1Ppt4By77GHbWOIvs+2M4IskL
        v2Oz7ey10ofj0EcT9GJv9XYJmfvPrQjQi6RVfV62XmC+lFlSbkseAz+kUljU6Ta1COQqmpYMjWP
        35yeYhJtE0779Y+0J
X-Received: by 2002:ac8:6c57:: with SMTP id z23mr14454880qtu.155.1617743618665;
        Tue, 06 Apr 2021 14:13:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvIEKe5NEFfjLI+xWqaKNhUTCtlcBMeB9iljRNEmRUAfwEbQMtz5cIl77hzWbFWgBhB1CLLA==
X-Received: by 2002:ac8:6c57:: with SMTP id z23mr14454854qtu.155.1617743618434;
        Tue, 06 Apr 2021 14:13:38 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e7f:cee0:ccad:a4ca:9a69:d8bc])
        by smtp.gmail.com with ESMTPSA id a10sm16963948qkh.122.2021.04.06.14.13.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Apr 2021 14:13:37 -0700 (PDT)
Message-ID: <fe8cdf3bede40b46716bf94b0760db6d47a13187.camel@redhat.com>
Subject: Re: [PATCH][next] net/mlx5: Fix bit-wise and with zero
From:   Laurence Oberman <loberman@redhat.com>
To:     Colin King <colin.king@canonical.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Raed Salem <raeds@nvidia.com>, Huy Nguyen <huyn@mellanox.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Apr 2021 17:13:36 -0400
In-Reply-To: <20210406165346.430535-1-colin.king@canonical.com>
References: <20210406165346.430535-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-04-06 at 17:53 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The bit-wise and of the action field with
> MLX5_ACCEL_ESP_ACTION_DECRYPT
> is incorrect as MLX5_ACCEL_ESP_ACTION_DECRYPT is zero and not
> intended
> to be a bit-flag. Fix this by using the == operator as was originally
> intended.
> 
> Addresses-Coverity: ("Logically dead code")
> Fixes: 7dfee4b1d79e ("net/mlx5: IPsec, Refactor SA handle creation
> and destruction")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
> b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
> index d43a05e77f67..0b19293cdd74 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
> @@ -850,7 +850,7 @@ mlx5_fpga_ipsec_release_sa_ctx(struct
> mlx5_fpga_ipsec_sa_ctx *sa_ctx)
>  		return;
>  	}
>  
> -	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action &
> +	if (sa_ctx->fpga_xfrm->accel_xfrm.attrs.action ==
>  	    MLX5_ACCEL_ESP_ACTION_DECRYPT)
>  		ida_free(&fipsec->halloc, sa_ctx->sa_handle);
>  

Looks correct to me with enum mlx5_accel_esp_action action;

Reviewed-by Laurence Oberman <loberman@redhat.com>

