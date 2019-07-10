Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD4364B46
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 19:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfGJROR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 13:14:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50192 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfGJROR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 13:14:17 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so3089012wml.0;
        Wed, 10 Jul 2019 10:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/REE+n6sa4ljuFXYbZ1ldo6oCamSgjSpDC/XEdgtKL0=;
        b=ZThtyI8C23gqa+FFWJSWAFiSs3t84AkKmwhInxRS6XnP3MRA6LtdwA1sCJhDFhf8lw
         7MHHB5C027WnSeubZvQgnP73c44gDIQAMNMfsQVIax2GgwH1gde62/F1O9aeyhBynyDU
         rGZjDauOKVlzsaJA+kekmN+Fpegbq/OMelBOo3yHxeSo3Xcmg7egnQHn3GHafZ1GfrmO
         NklZFv+JSqjHtjLUrlgb91sow7uc0TbJw4V6IKyNbv99oglLsRFfLbsomO2xQMIWx5kx
         RO3B/Tdv35bohJIBXzh/3AKmXYIfbgoYfYtqglxLIjEqJ69gw5kcYxDIWHGYJJxwRxss
         3qbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/REE+n6sa4ljuFXYbZ1ldo6oCamSgjSpDC/XEdgtKL0=;
        b=c/f2TrzWkyPnYRLR1xq1+TZh3d9wdfPdQCNcs4ldPb7hVd3WQj3Z3v9BR83TAqjWBy
         rmN9eYGfJCi33v+zssLblUJsmTL4uO4Iya01UUJiunWR+s9S+1Gcdyy1J6G6K2Eco0Sx
         dOtAZi6zXhTfJ7fJ5wQY/8yyCmFUKSQBGTnQNBouC+b/AJqk/vh3jeycvX9y5gzz31hr
         m413ncBC0iCW3b8YAYtg4dHqGNJQlIZGsx2Y+KnVgLCmvps0Jfv5Pcd9ijzg//MQa9t3
         GF/A173XtXrrWdQhBQ+1yz7+gadBAq200gM5S9+nPU2BuM1W/snLF2VlQ//Oj5pjvRiJ
         8fEQ==
X-Gm-Message-State: APjAAAWHRAAmIGLUbJR+/+hUSCiDKKI4vWF5HO6/iUZCseQ3nC+OeUpF
        3I6bB2YCr83Ff/cVhYBEzHk=
X-Google-Smtp-Source: APXvYqzMY7xSsdA1gkDvtyp28Ctkl1M8qO9UfJd/E5dxUId8rDi+Y8m97M2ONoiqOAbmrFv9z2ueYw==
X-Received: by 2002:a1c:9813:: with SMTP id a19mr6097592wme.11.1562778855617;
        Wed, 10 Jul 2019 10:14:15 -0700 (PDT)
Received: from archlinux-threadripper ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id i18sm2968727wrp.91.2019.07.10.10.14.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 10:14:14 -0700 (PDT)
Date:   Wed, 10 Jul 2019 10:14:13 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] [net-next] net/mlx5e: avoid uninitialized variable use
Message-ID: <20190710171413.GB80585@archlinux-threadripper>
References: <20190710130638.1846846-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190710130638.1846846-1-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 03:06:25PM +0200, Arnd Bergmann wrote:
> clang points to a variable being used in an unexpected
> code path:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2: warning: variable 'rec_seq_sz' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note: uninitialized use occurs here
>         skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
>                                                     ^~~~~~~~~~
> 
> From looking at the function logic, it seems that there is no
> sensible way to continue here, so just return early and hope
> for the best.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> index 3f5f4317a22b..5c08891806f0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> @@ -250,6 +250,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
>  	}
>  	default:
>  		WARN_ON(1);
> +		return;
>  	}
>  
>  	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
> -- 
> 2.20.0
> 

Looks like my identical patch got picked up in net-next:

https://git.kernel.org/davem/net-next/c/1ff2f0fa450ea4e4f87793d9ed513098ec6e12be

Good to know the fix was the same.

Cheers,
Nathan
