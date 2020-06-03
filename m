Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930CA1ED634
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 20:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgFCSel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 14:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgFCSek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 14:34:40 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8018FC08C5C0;
        Wed,  3 Jun 2020 11:34:40 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id p70so2687771oic.12;
        Wed, 03 Jun 2020 11:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oQUJgJ3YOiG5bkxRQ655KQgPRUZx1ajq2wCUvcTmv/c=;
        b=WAuK+Ys4wPxnPwWzJG2fRvdNtZJjBr4K/jg49UPIPCKSt+9sa5yYh2ukyBQ19K5QRN
         6IbRW3HIcQUNedisO6iKxoDVBAvTxmzPedTlAe2BD2Vl73q/FGkauRLoKFZY4ein/Jfn
         2zNcAuxC7YLlUldKmdRnMINbfN/BTSomKKhVKFuXIBpB4XCs3/o8EOQExzD0JUeXSJc0
         y5WWicPjR9YLg/WSMLHHhSxvQUg0W15woHoyDgBFgzXieH9Pd+LgmqGcaP8oIvVdBfJo
         GENv80MVWA0MIFfSTaErFWogUix7tgMJo6E4JsJvB2jK6FyLFCjn7sRFG3zhDNp7e+FB
         9DBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oQUJgJ3YOiG5bkxRQ655KQgPRUZx1ajq2wCUvcTmv/c=;
        b=X4a7WuFF4b2ElHazBR67440zuRXbN94HZjEfImz5nYJTKMOLgNAIURzbokgWOaEenX
         Csb3sVdvynwXfaC/YT9ktwRggyONQNUK+VxejS+pmeUXJaKeFcLhkU2mp55vm5KjHgu5
         hzqlwf3PLbNQAiJU/r/eQzRxcaeqDcA/+K95L3+K2lgg80RWvgZ01zcWp9OOP9RKNWB7
         XCYvHcPtemRihvF5npPGSxUyaBrRj1IL0HTDJHLsKG4FRB210LYRH5lTpWAn+p4yNmSg
         Af/jfuEaqHeiqMununX4RmfTf3ACm0hA6afKmRc7le32m8JLuN145PJA0DN7eNeRpXpw
         Cmww==
X-Gm-Message-State: AOAM530f2hhoOUEC9887qHSXdDdVPwcovr2YTv3BtFRZxNDDj8bduLm5
        yHPBBPh1dwhhf4QmYFM7s0vcrGjK
X-Google-Smtp-Source: ABdhPJxyWSU1KggVyvQ8xOq73tL2jiUpI3axcd3BWGgYnVx8RsEFahEsfmiTrCdexw6rtnJnlXwwfw==
X-Received: by 2002:aca:1e0f:: with SMTP id m15mr763445oic.23.1591209279813;
        Wed, 03 Jun 2020 11:34:39 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id m18sm693585ooe.12.2020.06.03.11.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 11:34:38 -0700 (PDT)
Date:   Wed, 3 Jun 2020 11:34:36 -0700
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
Message-ID: <20200603183436.GA2565136@ubuntu-n2-xlarge-x86>
References: <20200602122837.161519-1-leon@kernel.org>
 <20200602192724.GA672@Ryzen-9-3900X.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602192724.GA672@Ryzen-9-3900X.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 12:27:24PM -0700, Nathan Chancellor wrote:
> On Tue, Jun 02, 2020 at 03:28:37PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> > 
> > Clang warns:
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
> > 'err' is used uninitialized whenever 'if' condition is true
> > [-Wsometimes-uninitialized]
> >         if (!priv->dbg_root) {
> >             ^~~~~~~~~~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
> > uninitialized use occurs here
> >         return err;
> >                ^~~
> > drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
> > 'if' if its condition is always false
> >         if (!priv->dbg_root) {
> >         ^~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
> > the variable 'err' to silence this warning
> >         int err;
> >                ^
> >                 = 0
> > 1 warning generated.
> > 
> > The check of returned value of debugfs_create_dir() is wrong because
> > by the design debugfs failures should never fail the driver and the
> > check itself was wrong too. The kernel compiled without CONFIG_DEBUG_FS
> > will return ERR_PTR(-ENODEV) and not NULL as expected.
> > 
> > Fixes: 11f3b84d7068 ("net/mlx5: Split mdev init and pci init")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1042
> > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> 
> Thanks! That's what I figured it should be.
> 
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> > ---
> > Original discussion:
> > https://lore.kernel.org/lkml/20200530055447.1028004-1-natechancellor@gmail.com
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index df46b1fce3a7..110e8d277d15 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -1275,11 +1275,6 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
> > 
> >  	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
> >  					    mlx5_debugfs_root);
> > -	if (!priv->dbg_root) {
> > -		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
> > -		goto err_dbg_root;

Actually, this removes the only use of err_dbg_root, so that should be
removed at the same time.

Cheers,
Nathan

> > -	}
> > -
> >  	err = mlx5_health_init(dev);
> >  	if (err)
> >  		goto err_health_init;
> > --
> > 2.26.2
> > 
