Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE41EC2B6
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 21:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgFBT1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 15:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBT1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 15:27:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC412C08C5C0;
        Tue,  2 Jun 2020 12:27:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y17so1794026plb.8;
        Tue, 02 Jun 2020 12:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ojxsapJVRcLIVUs+X1YXzLQFjCqQZDJZ+jxsQ+PG7k4=;
        b=b/kvpOvI1KhY+fkvFMKiHh/aNWRzwKw18pnqL/gXNfVTHG5cBO2lVRjrne9/2Ae5Vd
         f8rDJy/ANSrYFT++A9GRjnnHirTU7VsBDK5bQVbwBZjY9nhndd4rPNSyZ316XdRxRTT3
         Hb1r3z84+nIJB+dI9O8MFgYISxA80XQmTCC3cvncjLx+5AUZ0MT/6S7aeVAnazkr1DOd
         6QtCgfRFooZOp6xPMDfPdSlIkhklaGYPcnBIQ0bHgQ6YBUROkFa9SoQxLAvJ/c4KoqIz
         2S0AKwDsTxV0Nn/S/CWTYECpLhoVCtIXrawB69IjXgfncn1nIIeILUJlA6sh96XETWcC
         QFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ojxsapJVRcLIVUs+X1YXzLQFjCqQZDJZ+jxsQ+PG7k4=;
        b=bax8wsC4sZcwDw4zQi1yc4yO4yJcTPEE05/Gu5MWnbvupeuOZkTHjamEo4L4GyaK2O
         7P5XaIKluKqCt8Uy2W3jlZVgCXxVbEwRM6KGMQF6mMAwXhghF0KgnFZtOg5lU4+/WYU+
         zjftAwynoiyxkHHihmdUEp0yVKrylwVK3aOnVkCRiAwboTLlzVocYNFouEKgon9NeBvq
         QdUB0uitjylDBLgC0j5md8Ob1HfrA/BfZ+dFeyQuPH0MijkQplXzZafhL3AZ4PeHtDyL
         OGyV07Apt4xidqisNB60FGSJu8dg5wBCaOxmTYtugGbKsdm7/eQr3dio2ysTLSlV36ue
         0BoA==
X-Gm-Message-State: AOAM531DrOZvtNcTO2iHyc5z9l/7Q4aLq7QuuWALq/Ue2Ne/W6aOxoi3
        64pQVp/Nl53bWJY9WvLIZp8=
X-Google-Smtp-Source: ABdhPJzYL4mnYZRXO3BhVRmuH0IyvVzT5CA/X1FAdc54XUK8+voLohxlReuqH3Sqr2w4v8wYwIE5Qw==
X-Received: by 2002:a17:902:bf47:: with SMTP id u7mr25970116pls.159.1591126041361;
        Tue, 02 Jun 2020 12:27:21 -0700 (PDT)
Received: from Ryzen-9-3900X.localdomain ([107.152.99.41])
        by smtp.gmail.com with ESMTPSA id 17sm3057279pfn.19.2020.06.02.12.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 12:27:20 -0700 (PDT)
Date:   Tue, 2 Jun 2020 12:27:24 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        clang-built-linux@googlegroups.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>
Subject: Re: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
Message-ID: <20200602192724.GA672@Ryzen-9-3900X.localdomain>
References: <20200602122837.161519-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602122837.161519-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 03:28:37PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Clang warns:
> 
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
> 'err' is used uninitialized whenever 'if' condition is true
> [-Wsometimes-uninitialized]
>         if (!priv->dbg_root) {
>             ^~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
> uninitialized use occurs here
>         return err;
>                ^~~
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
> 'if' if its condition is always false
>         if (!priv->dbg_root) {
>         ^~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
> the variable 'err' to silence this warning
>         int err;
>                ^
>                 = 0
> 1 warning generated.
> 
> The check of returned value of debugfs_create_dir() is wrong because
> by the design debugfs failures should never fail the driver and the
> check itself was wrong too. The kernel compiled without CONFIG_DEBUG_FS
> will return ERR_PTR(-ENODEV) and not NULL as expected.
> 
> Fixes: 11f3b84d7068 ("net/mlx5: Split mdev init and pci init")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1042
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Thanks! That's what I figured it should be.

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
> Original discussion:
> https://lore.kernel.org/lkml/20200530055447.1028004-1-natechancellor@gmail.com
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index df46b1fce3a7..110e8d277d15 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -1275,11 +1275,6 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
> 
>  	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
>  					    mlx5_debugfs_root);
> -	if (!priv->dbg_root) {
> -		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
> -		goto err_dbg_root;
> -	}
> -
>  	err = mlx5_health_init(dev);
>  	if (err)
>  		goto err_health_init;
> --
> 2.26.2
> 
