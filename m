Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1236B6E2
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhDZQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 12:33:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233923AbhDZQd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 12:33:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D51AF611CE;
        Mon, 26 Apr 2021 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619454796;
        bh=d0gfNgV9zTvtd4x6r4lI4n6KddJ35PZDUmebabXDSKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FFmJ79xE0QKNVYj36vQclGEC2+oq16f+aZHSuwK7oMgzt5na2PKlzD0fZUa8qUwcy
         n8FMNriIva1cmwTxV0eSlIvyYNH1oxFoCFKVDIEpkQeMN8IUh1L63CPy4OxR9uAxaL
         FrxfjcM/mDq22JlUXyCZnj/Oo0Y1JDb+lLI0M3ALqWa0hWTheqmGyw2UDsqO83FIqQ
         8in7/wPb/VGwSiOPaccTULMM0zJAdUJ9W3sUt8NwGpcgb3jAaLEdFn5hLnSvMNEJvy
         rGhAdU1x1n6xJMl9l2zwRqhuwLf1fr4DEikdUAG22G9fxOjj/xDaFrTqDc7cklMfk5
         zu7BX9P+MYQaw==
Date:   Mon, 26 Apr 2021 09:33:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix some error messages
Message-ID: <20210426093314.5f73781e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YIUOoTKRwy3UTRWz@unreal>
References: <YIKywXhusLj4cDFM@mwanda>
        <YIUOoTKRwy3UTRWz@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 25 Apr 2021 09:39:29 +0300 Leon Romanovsky wrote:
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> > index a81ece94f599..95f5c1a27718 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
> > @@ -83,16 +83,16 @@ mlx5_eswitch_termtbl_create(struct mlx5_core_dev *dev,
> >  	ft_attr.autogroup.max_num_groups = 1;
> >  	tt->termtbl = mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
> >  	if (IS_ERR(tt->termtbl)) {
> > -		esw_warn(dev, "Failed to create termination table (error %d)\n",
> > -			 IS_ERR(tt->termtbl));
> > +		esw_warn(dev, "Failed to create termination table (error %ld)\n",
> > +			 PTR_ERR(tt->termtbl));

If these are error pointers - perhaps %pe?
