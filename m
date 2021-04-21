Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0C93664C9
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 07:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhDUFXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 01:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235199AbhDUFXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 01:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3E6F61182;
        Wed, 21 Apr 2021 05:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618982597;
        bh=sR6Vvp0DRmKaF47VkWpSGNUetTMoFcXTnaUl1zJsCDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B0suTRT7RG67h/eYTHWt63hImbZfhewvAoStWXByZ1mFL6Fm/oY71R/E22DVX5QsO
         w9uUKUpIzK2t++VNt5ZFMdqWKq3h1qYXnkNmWyWKz8a2BJ1Q+V8bqhW20RB3eM7cDf
         l6SpDZuOm2Hmnhdi6+Np0sLMiwg3O5hVBWh2Bh/Eq7u5TjG+hZQsQL4wkFzEb27x3b
         SL87z8aQTBM7EtqS0JGuGyAQN17vrOOvPWIdeAdwWxK+GIJmH8Ra/J8zhZpehk/bk4
         x4eu+2KjxwjGAhA3i5m6O04I/Oes/RQJVtlA4cWxzMbBUITBF10E0eRTvewyk/OP5e
         NSeKPpV86kC7w==
Date:   Wed, 21 Apr 2021 08:23:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH RESEND][next] net/mlx4: Fix fall-through warnings for
 Clang
Message-ID: <YH+2wRRzBsSI/NM2@unreal>
References: <20210305084847.GA138343@embeddedor>
 <808373f4-25d0-9e7e-fe16-f8b279d1ebab@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <808373f4-25d0-9e7e-fe16-f8b279d1ebab@embeddedor.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:24:19PM -0500, Gustavo A. R. Silva wrote:
> Hi all,
> 
> Friendly ping: who can take this, please?

Why don't you fix Clang instead?
Why do we have this churn for something that correct?

> 
> Thanks
> --
> Gustavo
> 
> On 3/5/21 02:48, Gustavo A. R. Silva wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> > by explicitly adding a break statement instead of just letting the code
> > fall through to the next case.
> > 
> > Link: https://github.com/KSPP/linux/issues/115
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> > index a99e71bc7b3c..771b92019af1 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> > @@ -2660,6 +2660,7 @@ int mlx4_FREE_RES_wrapper(struct mlx4_dev *dev, int slave,
> >  	case RES_XRCD:
> >  		err = xrcdn_free_res(dev, slave, vhcr->op_modifier, alop,
> >  				     vhcr->in_param, &vhcr->out_param);
> > +		break;
> >  
> >  	default:
> >  		break;
> > 
