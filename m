Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF351EB41B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 06:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgFBEHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 00:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgFBEHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 00:07:52 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AB4C061A0E;
        Mon,  1 Jun 2020 21:07:52 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id k15so6432992otp.8;
        Mon, 01 Jun 2020 21:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KMSPv9lovPpFYq/LUSFG6QcTM2yJAf6mkVnhkUqAWFE=;
        b=WMxPxSbb+ih0evnuvt75qFV3j8/ZNo5BoD18gBSZrmuRB4x6eae1MSmhNbPveib8Cb
         vG9YA93T4cM2T9KxFOrqXQPSCswFTfrBHeDT7K3csLywYfYJnG1bK47kH2B5IkpfFDTv
         7AclSnVyGL3RM659NhBjQiWSNH6AszZr3hagD+SFuyd8BmUHP9tGbUz9BSOUdZ/CHCrz
         2oCtAI3pdEMUiiEjNiDZFonC6ESR4R17iOsexI1pf0Fi2tNzAdohkOdFU0pRIkgbwvsv
         0SF2prYH888MMi3xOuUOIPJjBhTu6bzXuN4Hr1FkGzc9TpENlMzHGozAyZ/90+5ihXpv
         aQJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KMSPv9lovPpFYq/LUSFG6QcTM2yJAf6mkVnhkUqAWFE=;
        b=EB6aK9FeAjo2vR6xrTbgun8JicTEpDkdnQmhHpVsdKvUySIuQJl5c3Ahi0YCLDlB6D
         tOl+3U12mwcYg6egUP3jKwmpgpS+Su8wktK/2yfmO/EVm6lsAKovgRxQEZzNAVzHKoab
         /KdxFxLgRE/wt5TnJRiED3ERi7EGuC8PX/sVtpg2J4VAT/DV0Z04eXO21RubgDzm9MMF
         wTNiGKF6tjY0lodyhirmAMq0F/vbdMDsdOtw969k2GSuzhW3DXSqypJnI20padt8OieE
         AEyqPigDLq9PST3o9N0N3pgnGlPqV22Tx6l2ZHCNqtilTEQ4w3ovkUMSF+bcF8uWbFYx
         3lxQ==
X-Gm-Message-State: AOAM531gIxYA9n+J/pJRWxqNPdDh5UW8LcrsqP1DN/mlWR8R6JCUmJip
        kGYLvoxQQfUhJ0u5WKrGYEc=
X-Google-Smtp-Source: ABdhPJzXrPxUYjRIUy87NNVlcUO9m5FQh/SjJVEgeC1PytNMgZBHluBrkNXvuWeXy4XPqPBswW9+Jw==
X-Received: by 2002:a9d:1d43:: with SMTP id m61mr19800887otm.190.1591070871042;
        Mon, 01 Jun 2020 21:07:51 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id v1sm418926ooi.13.2020.06.01.21.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 21:07:50 -0700 (PDT)
Date:   Mon, 1 Jun 2020 21:07:48 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] mlx5: Restore err assignment in mlx5_mdev_init
Message-ID: <20200602040748.GA1435528@ubuntu-n2-xlarge-x86>
References: <20200530055447.1028004-1-natechancellor@gmail.com>
 <20200531095810.GF66309@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200531095810.GF66309@unreal>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 12:58:10PM +0300, Leon Romanovsky wrote:
> On Fri, May 29, 2020 at 10:54:48PM -0700, Nathan Chancellor wrote:
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
> > This path previously returned -ENOMEM, restore that error code so that
> > it is not uninitialized.
> >
> > Fixes: 810cbb25549b ("net/mlx5: Add missing mutex destroy")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1042
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index df46b1fce3a7..ac68445fde2d 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -1277,6 +1277,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
> >  					    mlx5_debugfs_root);
> >  	if (!priv->dbg_root) {
> >  		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
> > +		err = -ENOMEM;
> >  		goto err_dbg_root;
>                 ^^^^^^^^^^^^^^^^^^ this is wrong.
> Failure to create debugfs should never fail the driver.

Fair enough, could you guys deal with this then to make sure it gets
fixed properly? It appears to be introduced in 11f3b84d7068 ("net/mlx5:
Split mdev init and pci init").

> >  	}
> >
> >
> > base-commit: c0cc73b79123e67b212bd537a7af88e52c9fbeac
> > --
> > 2.27.0.rc0
> >
