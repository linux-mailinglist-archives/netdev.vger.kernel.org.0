Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65F36BEBC
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 07:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhD0FJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 01:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229490AbhD0FJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 01:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ABB361078;
        Tue, 27 Apr 2021 05:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619500106;
        bh=se4N3XRMNqnR8HJf2nwyOdDriOFE0QMWPZMG7tgwpMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q0fyONEJq1UU0PsUJ8Kvd14hKCyM/qCmIpdnhlB+1gwqauzRN9cPAMH7k5avtYyFG
         Lm/sCfs/xJubDR3BrzvGAXZuAEaJwUSqh+8Gz08D9S8r6OhkJff663Wlgw75qNVMeC
         Tkd3ZaQrd6nzwTs0G4AM/7AE7HfTq3yz4X6dgPKDijKtqjA0emnUK46MtEHNH1MnfU
         7WwprK6oxOAiDpn2KaV+vL37zqLSXfMe8lsOnag0U9FNyAE5bZpXXHvvwX8XcZd1JP
         zgCQN5wo/FfIPQ1mEaiUUfmwKaF1oWmWnKfbU+4Wsme4V7TUGAiO2o9fDtpHaV0DeF
         fEStF5weAgz4Q==
Date:   Tue, 27 Apr 2021 08:08:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5: Fix some error messages
Message-ID: <YIecRqSNq6aPiwVA@unreal>
References: <YIKywXhusLj4cDFM@mwanda>
 <YIUOoTKRwy3UTRWz@unreal>
 <20210426093314.5f73781e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d2eca0209e76544b09021d94a47bc623ebfdc20c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d2eca0209e76544b09021d94a47bc623ebfdc20c.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:47:03AM -0700, Saeed Mahameed wrote:
> On Mon, 2021-04-26 at 09:33 -0700, Jakub Kicinski wrote:
> > On Sun, 25 Apr 2021 09:39:29 +0300 Leon Romanovsky wrote:
> > > > diff --git
> > > > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > > l.c
> > > > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > > l.c
> > > > index a81ece94f599..95f5c1a27718 100644
> > > > ---
> > > > a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > > l.c
> > > > +++
> > > > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtb
> > > > l.c
> > > > @@ -83,16 +83,16 @@ mlx5_eswitch_termtbl_create(struct
> > > > mlx5_core_dev *dev,
> > > >         ft_attr.autogroup.max_num_groups = 1;
> > > >         tt->termtbl =
> > > > mlx5_create_auto_grouped_flow_table(root_ns, &ft_attr);
> > > >         if (IS_ERR(tt->termtbl)) {
> > > > -               esw_warn(dev, "Failed to create termination table
> > > > (error %d)\n",
> > > > -                        IS_ERR(tt->termtbl));
> > > > +               esw_warn(dev, "Failed to create termination table
> > > > (error %ld)\n",
> > > > +                        PTR_ERR(tt->termtbl));
> > 
> > If these are error pointers - perhaps %pe?
> 
> no reason to use %pe, we know it is an err ptr at this point so just
> report PTR_ERR() 

Saeed,

%pe prints string "-EINVAL" instead of "22", which is better.

I didn't know about such format specifier.

Thanks
