Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7205FD7A7
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 12:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJMKOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 06:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJMKOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 06:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B899474F4;
        Thu, 13 Oct 2022 03:14:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45C98B81E1D;
        Thu, 13 Oct 2022 10:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32150C433C1;
        Thu, 13 Oct 2022 10:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665656060;
        bh=y6JXVdo1ZORVMnzUVo72B/1EKIEVRzlh9YDUW+RWTHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vE/hpCj25weQuONrqd3G3rpeWz2HRTn9obyNwy2ddQeLfN48GLhF88zsI7Xnih7Qh
         olR8hh+xKN5V/yZQVDkooO3jBTAtJV2/CqhDCVsUBELRmoTEOpMaWQCXe9jttj8eGG
         Pgf6ow8GDbq7U4Zd4LIdGNBHZ5X0weO2P89iKAbLdio0N1X8X1C/IFNvRF4M00Ru8W
         Ulsvgy5Ib3Q6wYvefPrH1b1ESoxN6RoPFB8y0evaCBjZp31q4OOhDu+9I5Ro3xlAvd
         ivKnAgX4ojFQGfa9N//ilHkFEh8w2eiDT7r2oGeDeM8Z3LEiBUdeEKQZPPiAqdmXAd
         udxaQd75zvo5w==
Date:   Thu, 13 Oct 2022 13:14:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Cleanup MACsec uninitialization routine
Message-ID: <Y0fk9wD4CeS8vh1E@unreal>
References: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
 <446abc60-b954-6c41-e6f6-62e0ff02c9e9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <446abc60-b954-6c41-e6f6-62e0ff02c9e9@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 01:03:43PM +0300, Tariq Toukan wrote:
> 
> 
> On 10/13/2022 10:21 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
> > doesn't support MACsec (priv->macsec will be NULL) together with useless
> > comment line, assignment and extra blank lines.
> > 
> > Fix everything in one patch.
> > 
> > Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 11 +----------
> >   1 file changed, 1 insertion(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> > index 41970067917b..4331235b21ee 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> > @@ -1846,25 +1846,16 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
> >   void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
> >   {
> >   	struct mlx5e_macsec *macsec = priv->macsec;
> > -	struct mlx5_core_dev *mdev = macsec->mdev;
> > +	struct mlx5_core_dev *mdev = priv->mdev;
> 
> simply defer the mdev calculation to be after the early return, trying to
> keep this macsec function as independent as possible.

It is done to keep _cleanup symmetrical to _init one. The function
should operate on same priv->mdev as was used there without any relation
to macsec->mdev. Of course, it is the same pointer, but it is better to have
same code.

> 
> >   	if (!macsec)
> >   		return;
> >   	mlx5_notifier_unregister(mdev, &macsec->nb);
> > -
> >   	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
> > -
> > -	/* Cleanup workqueue */
> >   	destroy_workqueue(macsec->wq);
> > -
> >   	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
> > -
> > -	priv->macsec = NULL;
> > -
> 
> Why remove this assignment?
> 
> It protects against accessing freed memory, for instance when querying the
> macsec stats, see
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c

You can't and shouldn't access anything related to MACsec after call to
mlx5e_macsec_cleanup(). If you do so, you are already in trouble as you
don't have any locking protection from stat access and cleanup.

So no, it doesn't protect from accessing freed memory. It is just
anti-pattern of hiding bugs related to unlocked concurrent accesses
and wrong release flows. Don't do it.

Thanks

> 
> >   	rhashtable_destroy(&macsec->sci_hash);
> > -
> >   	mutex_destroy(&macsec->lock);
> > -
> >   	kfree(macsec);
> >   }
