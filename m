Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029AA27CCA0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733227AbgI2Mhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732170AbgI2MhT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 08:37:19 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9B92075F;
        Tue, 29 Sep 2020 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601383038;
        bh=S4wNT1s618zBR49BGhVX+tQF2CHbKbCGsPdgXgyr3UY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmsXpnI7r0iwkDdjZ5+XzKl8hLcq4E7KTAWur2JExI4C/hTf9CpOt5hyaa0x7EoMJ
         Pp1FqhwKzdYR9lulHDWiKIuXkZFw6mv9oQQXYWV2mVxtwLZiEnaW1tG7tQnKaIOiia
         LkLIAxj7nlzosaz27eG8yAvY4EhGbsR8lzEMxgmA=
Date:   Tue, 29 Sep 2020 15:37:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: Fix use of freed pointer
Message-ID: <20200929123713.GG3094@unreal>
References: <20200928074301.GC3094@unreal>
 <20200929101554.8963-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929101554.8963-1-alex.dewar90@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 11:15:49AM +0100, Alex Dewar wrote:
> If the call to mlx5_fc_create() fails, then shared_counter will be freed
> before its member, shared_counter->counter, is accessed to retrieve the
> error code. Fix by using an intermediate variable.
>
> Addresses-Coverity: CID 1497153: Memory - illegal accesses (USE_AFTER_FREE)
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
> v2:
> 	- Add Fixes tag (Leon)
> 	- Use ERR_CAST (Leon)
>
> Hi Leon,
>
> I've made the suggested changes. Let me know if there's anything else
> you need :)

Hi Alex,

Saeed already picked Dan's patch.
https://lore.kernel.org/linux-rdma/1017ab3724b83818c03dfa7661b3f31827a7f62f.camel@kernel.org/T/#t

>
> There is also this patch in the series which doesn't seem to have been
> reviewed yet: https://lore.kernel.org/lkml/20200927113254.362480-4-alex.dewar90@gmail.com/

Ariel is handling this internally.
https://lore.kernel.org/linux-rdma/64f6a3eaaac505c341f996df0b0877ee9af56c00.camel@kernel.org/T/#t

Thanks
