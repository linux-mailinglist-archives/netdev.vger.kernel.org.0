Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17936B957
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 20:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbhDZSrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 14:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238045AbhDZSrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 14:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D60BC60C3D;
        Mon, 26 Apr 2021 18:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619462825;
        bh=LzNTYbiIWhKMpW5wxTjs6p9h2s4HLvKp7YiHBdWNF1E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ONufhNyrHGrELeVqTZK15JxWEZhOmZWroNjNuCEbm8kztwgl4X/RNCKZFd2XgPNAD
         FhOitq6vSvhw46H2PPeJXVdjBO55yR7TR1cvVY/M2YZL71nhaX6tpPNIsgbq8shKGD
         PxfkTdK3RjjY5X4ue22IBdzXSqCfpvzMXpiYltxR5AqhQdEB8P9Jb71XNtnjh6PhyU
         YSvw4Qpy6aHsEQJseFqE/C9t0OcY+QtpGav4Bhf2GgIGKEvi1pp6IIVzwH86hoShu9
         mebvy1lN067HjnP2ay0Ue/+9BLDl+u8GI4xlfyq/MGngWOParRAD9AEiVMFBpyBI8s
         Jpx1CVME6aeWg==
Message-ID: <d2eca0209e76544b09021d94a47bc623ebfdc20c.camel@kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix some error messages
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Date:   Mon, 26 Apr 2021 11:47:03 -0700
In-Reply-To: <20210426093314.5f73781e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <YIKywXhusLj4cDFM@mwanda> <YIUOoTKRwy3UTRWz@unreal>
         <20210426093314.5f73781e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-26 at 09:33 -0700, Jakub Kicinski wrote:
> On Sun, 25 Apr 2021 09:39:29 +0300 Leon Romanovsky wrote:
> > > diff --git
> > > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > l.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > l.c
> > > index a81ece94f599..95f5c1a27718 100644
> > > ---
> > > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > l.c
> > > +++
> > > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > l.c
> > > @@ -83,16 +83,16 @@ mlx5_eswitch_termtbl_create(struct
> > > mlx5_core_dev *dev,
> > >         ft_attr.autogroup.max_num_groups = 1;
> > >         tt->termtbl =
> > > mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
> > >         if (IS_ERR(tt->termtbl)) {
> > > -               esw_warn(dev, "Failed to create termination table
> > > (error %d)\n",
> > > -                        IS_ERR(tt->termtbl));
> > > +               esw_warn(dev, "Failed to create termination table
> > > (error %ld)\n",
> > > +                        PTR_ERR(tt->termtbl));
> 
> If these are error pointers - perhaps %pe?

no reason to use %pe, we know it is an err ptr at this point so just
report PTR_ERR() 


