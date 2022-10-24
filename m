Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDDE60B932
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbiJXUGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiJXUF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:05:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CC828B1F8
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22314B815EB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 16:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F8FC433D6;
        Mon, 24 Oct 2022 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630064;
        bh=eQ/33hAexT54e5kSdPUtHu1T81mqJwxyQVcHI3CBHQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CdWOj8vXmEMXxLM0CDMCRcpQ2/QmLsURDC601WN/oz2Li13WgTWkTVI1tqD2CIGmV
         59PH7KHKCt2fBHfr/jW6wtG2sFiV/wqLxNUwFdAemB54wtP7aTzMo1as3GBJnaiAd5
         eldNgMxX/GL7iJL/Vykwzv+WlQliTjhJgQ3Mp+WSg8UoCESm4Iv508fGdnbHJgg+0T
         NKZP8A7P0F8lo4QQSOQc34Y+a1WFx6O1DIXmjx7VlYg839RpUaEyOyL6XEW5ny4pc5
         HoaOdz37ay53hzafWxjpIRt0j1r2NHUH1rFDg9r068fdXSX7M8npkspYmwp0B1tOBV
         GRv6BC8skm8hg==
Date:   Mon, 24 Oct 2022 19:47:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 1/6] net/mlx5e: Support devlink reload of IPsec
 core
Message-ID: <Y1bBrB3mps1+BBX8@unreal>
References: <cover.1666545480.git.leonro@nvidia.com>
 <862c2bab5b9a17c6a552d2e243909b9daf5d73d6.1666545480.git.leonro@nvidia.com>
 <20221024141714.7ritk6j3eprzkfpm@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024141714.7ritk6j3eprzkfpm@sx1>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 03:17:14PM +0100, Saeed Mahameed wrote:
> On 23 Oct 20:22, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Change IPsec initialization flow to allow future creation of hardware
> > resources that should be released and allocated during devlink reload
> > operation. As part of that change, update function signature to be
> > void as no callers are actually interested in it.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > .../mellanox/mlx5/core/en_accel/ipsec.c         | 17 ++++++++---------
> > .../mellanox/mlx5/core/en_accel/ipsec.h         |  5 ++---
> > .../net/ethernet/mellanox/mlx5/core/en_main.c   |  8 +++-----
> > .../net/ethernet/mellanox/mlx5/core/en_rep.c    | 13 +++++++------
> > 4 files changed, 20 insertions(+), 23 deletions(-)

<...>

> > +
> 
> unrelated change.

I will fix it.

> 
> > 	mlx5e_destroy_mdev_resources(mdev);
> > 	return 0;
> > }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c

<...>

> > static int mlx5e_create_rep_ttc_table(struct mlx5e_priv *priv)
> > @@ -1074,6 +1068,8 @@ static void mlx5e_rep_enable(struct mlx5e_priv *priv)
> > {
> > 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
> > 
> > +	mlx5e_ipsec_init(priv);
> > +
> 
> we don't want ipsec for vport representors, only uplink.

The FW will miss relevant IPsec caps for uplink, but ok, will remove.

Thanks
