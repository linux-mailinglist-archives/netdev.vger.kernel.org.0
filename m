Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287C81F2172
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 23:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgFHVWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 17:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgFHVWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 17:22:46 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F1EC08C5C2;
        Mon,  8 Jun 2020 14:22:46 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id b18so14906408oti.1;
        Mon, 08 Jun 2020 14:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wW8D/dSScjtqwaMeYYSqLpcYbiXjnjq+RVvdaEoSPKg=;
        b=pH67onXKnkmvjnr7kTdmSi6Uzwy0roBDOYeXmG6zC7hP7OzMaXitW9M1K8phN51a9G
         TTKgsjMlSf4ptU8tmEA3CoRwCvBdbHg2jNimQQgG0ZWXoZ15t826vTTeNF9nVOowoGbD
         GgBXqH8k/ht6kmgSlqpkRfSIpxSag1DRxLuM43rZaQIptFsBuMGzEPAR56O7HyBC3AIr
         lAi3Q4ke+IaJGDeYTXsvzOozZK8lRsydY5KEbzA/FHzSLLVl8COj0HK5DLgPsT9qlEhy
         REUTa9QleLU8oFNH8y6Mz6xoFNoDIe9x6YSBoFr4sJi/RIGkmyG83kGaNnvJY6I93Qpa
         1jcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wW8D/dSScjtqwaMeYYSqLpcYbiXjnjq+RVvdaEoSPKg=;
        b=o3HtGnPRanoG2W2+QUbxBx2Cm3pZbLRWRR+iqocsB/d/t8l1Ho4yjjo8FsWEe1CS0w
         mspMTrHyUtzP8GIL9KpfwPQNexWZ1VQUaMhvcaVbQt21S8nwqZwBMk4WI8mqZuDeCp6d
         VDY59J7g2gznxnU9PGcNiidf/sPHEoBuOZPiWDuG8qyvMMSAo+9JHcp82ONxsDCtU/6Q
         73lQFWzqZbiV2xwHzLeJuGi7Xrp4vc7+B8NgDjckQ3/a3ofWgG5QGk9RYyZ2el9M4chi
         O6R9/iUHeXweFzCDUw/e3nQRCOamQ+D63v7+aDgCE2Bs5vDN8D6QfoKZQOk7B08Gt5I2
         PKOw==
X-Gm-Message-State: AOAM53253LEnFq19NgjD37FoxpIHRxYq1GthkcyOfqPVflr/7UTUJ98I
        CgefymW++8N0lHCnoLbvIz0=
X-Google-Smtp-Source: ABdhPJxqSR1gGUtivubbaRfehqrabRImW2oEhG335ChW6vi9VqUVtQNFJBheN9jpjiT1dHVCoDDJZQ==
X-Received: by 2002:a9d:67c1:: with SMTP id c1mr12662793otn.27.1591651365554;
        Mon, 08 Jun 2020 14:22:45 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id r65sm592355oie.13.2020.06.08.14.22.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 14:22:44 -0700 (PDT)
Date:   Mon, 8 Jun 2020 14:22:43 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Vu Pham <vuhuong@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net/mlx5: Don't fail driver on failure to create
 debugfs
Message-ID: <20200608212243.GA2072362@ubuntu-n2-xlarge-x86>
References: <20200602122837.161519-1-leon@kernel.org>
 <20200602192724.GA672@Ryzen-9-3900X.localdomain>
 <20200603183436.GA2565136@ubuntu-n2-xlarge-x86>
 <cf22654ba1e726c3f3d1acf7eff2bc167de810c7.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf22654ba1e726c3f3d1acf7eff2bc167de810c7.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 04:44:00AM +0000, Saeed Mahameed wrote:
> On Wed, 2020-06-03 at 11:34 -0700, Nathan Chancellor wrote:
> > On Tue, Jun 02, 2020 at 12:27:24PM -0700, Nathan Chancellor wrote:
> > > On Tue, Jun 02, 2020 at 03:28:37PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > > 
> > > > Clang warns:
> > > > 
> > > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning:
> > > > variable
> > > > 'err' is used uninitialized whenever 'if' condition is true
> > > > [-Wsometimes-uninitialized]
> > > >         if (!priv->dbg_root) {
> > > >             ^~~~~~~~~~~~~~~
> > > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
> > > > uninitialized use occurs here
> > > >         return err;
> > > >                ^~~
> > > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note:
> > > > remove the
> > > > 'if' if its condition is always false
> > > >         if (!priv->dbg_root) {
> > > >         ^~~~~~~~~~~~~~~~~~~~~~
> > > > drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note:
> > > > initialize
> > > > the variable 'err' to silence this warning
> > > >         int err;
> > > >                ^
> > > >                 = 0
> > > > 1 warning generated.
> > > > 
> > > > The check of returned value of debugfs_create_dir() is wrong
> > > > because
> > > > by the design debugfs failures should never fail the driver and
> > > > the
> > > > check itself was wrong too. The kernel compiled without
> > > > CONFIG_DEBUG_FS
> > > > will return ERR_PTR(-ENODEV) and not NULL as expected.
> > > > 
> > > > Fixes: 11f3b84d7068 ("net/mlx5: Split mdev init and pci init")
> > > > Link: https://github.com/ClangBuiltLinux/linux/issues/1042
> > > > Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > > 
> > > Thanks! That's what I figured it should be.
> > > 
> > > Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> > > 
> > > > ---
> > > > Original discussion:
> > > > https://lore.kernel.org/lkml/20200530055447.1028004-1-natechancellor@gmail.com
> > > > ---
> > > >  drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 -----
> > > >  1 file changed, 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > > b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > > index df46b1fce3a7..110e8d277d15 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > > > @@ -1275,11 +1275,6 @@ static int mlx5_mdev_init(struct
> > > > mlx5_core_dev *dev, int profile_idx)
> > > > 
> > > >  	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
> > > >  					    mlx5_debugfs_root);
> > > > -	if (!priv->dbg_root) {
> > > > -		dev_err(dev->device, "mlx5_core: error, Cannot create
> > > > debugfs dir, aborting\n");
> > > > -		goto err_dbg_root;
> > 
> > Actually, this removes the only use of err_dbg_root, so that should
> > be
> > removed at the same time.
> > 
> 
> Fixed this up and applied to net-next-mlx5, 
> Thanks!
> 

Hi Saeed,

I see this warning in mainline now, is this something you were planning
to have merged this cycle or next? I see it in several configs so it
would be nice if it could be resolved this one, since it was introduced
by a patch in this cycle even though the core issue has been around for
a few months.

Cheers,
Nathan
