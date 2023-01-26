Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8020D67D8B2
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 23:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbjAZWnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 17:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbjAZWnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 17:43:14 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160CD48593
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:43:12 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id tz11so9307363ejc.0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:43:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7imLnAGqNX+KAKgvEYbmCUsFXxAxoMWznMdx2Z5/JPk=;
        b=be/WE7bs3vtpHD+MU9AnZDT7JO+XYw07pDHaTaJMxptvzsI3aciQvHMyJqr8OIm/Dw
         7EONbYlNxNi0UC2k9MnGdw3zmMFdj6+YZ2/mLCJy5lwo+P7MBybazzQGBTg/iX8fmU8t
         vN0SwyBTS5fQx2or8J2DTqpBXvXnEBxWkqmHqFq56OEvmWdTvzURZuubFztKmCZCGSrE
         t8shlKwcDpZC8xuwECpXYkvRA+RdjShl1FLojk2N71uKQX9UPL6KOntFPmxIz5xllFhy
         5JBWHEhu4QJoQL91vVW0rlPXfw3n8mdHXyM9aRj2xiW1d+v73EXBY82Vxf2Msa1ZXT8A
         yLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7imLnAGqNX+KAKgvEYbmCUsFXxAxoMWznMdx2Z5/JPk=;
        b=B5Crwfh2GVk8GPBDxPWgO0pTxU7QzS+TQdW14U9FDkMPVr6zBy7A8+YfQMc5vj6ddx
         1wXjyznjhPGkvHVrjLWtHI6rcOTz8nyPqon1ljanhTMZZyXzM5NJcO2CBzcSIRDltq26
         sVU8Ej6+RvaMdg8GpZzS6Ac9GdINZFbh7vWku+74hQs4NNf5ns5rBRX7MjEKwI+r5+7E
         NpNjfJAKBX5kwle6wdcrAfr2MQ1Qz4OeHI2A2TUE3wNHRv95EPlj3IU1G1wXGJebjPVa
         s+7gIpX8eHwfa+WfTG9aOOoAKkPRdbxEkIWn1ltQ4FRUEcDHJNmirqO9E53h5A/Bn9b+
         TMeg==
X-Gm-Message-State: AO0yUKWhLsx+klU+xU2J0Y+vmWtUoK5naJuAOWe9oFYPHooc+HAiMCMe
        5wz3i7krJpV47qRtKRN7EIo=
X-Google-Smtp-Source: AK7set8ZEithirCIIlbcm+7OwjH9lhx1ECa8ynFECO32IdtN7bks1iPHfcdcFgtnxhAEYa0yWLAlPQ==
X-Received: by 2002:a17:907:3f8d:b0:878:59f7:3627 with SMTP id hr13-20020a1709073f8d00b0087859f73627mr5591454ejc.49.1674772991392;
        Thu, 26 Jan 2023 14:43:11 -0800 (PST)
Received: from localhost (tor-exit-relay-3.anonymizing-proxy.digitalcourage.de. [185.220.102.249])
        by smtp.gmail.com with ESMTPSA id gv52-20020a1709072bf400b00865ef3a3109sm1210751ejc.66.2023.01.26.14.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 14:43:10 -0800 (PST)
Date:   Fri, 27 Jan 2023 00:43:02 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net 1/2] net/mlx5e: XDP, Allow growing tail for XDP multi
 buffer
Message-ID: <Y9MB9gVwJz5mOdO/@mail.gmail.com>
References: <20230126191050.220610-1-maxtram95@gmail.com>
 <20230126191050.220610-2-maxtram95@gmail.com>
 <25a72690-6cae-bc7b-b30c-a0ece4fa0393@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25a72690-6cae-bc7b-b30c-a0ece4fa0393@gmail.com>
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 10:41:30PM +0200, Tariq Toukan wrote:
> 
> 
> On 26/01/2023 21:10, Maxim Mikityanskiy wrote:
> > The cited commits missed passing frag_size to __xdp_rxq_info_reg, which
> > is required by bpf_xdp_adjust_tail to support growing the tail pointer
> > in fragmented packets. Pass the missing parameter when the current RQ
> > mode allows XDP multi buffer.
> > 
> > Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
> > Fixes: 9cb9482ef10e ("net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP")
> > Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> > Cc: Tariq Toukan <tariqt@nvidia.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 11 ++++++++---
> >   1 file changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index abcc614b6191..cdd1e47e18f9 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -576,9 +576,10 @@ static void mlx5e_free_mpwqe_rq_drop_page(struct mlx5e_rq *rq)
> >   }
> >   static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
> > -			     struct mlx5e_rq *rq)
> > +			     struct mlx5e_rq_param *rq_params, struct mlx5e_rq *rq)
> >   {
> >   	struct mlx5_core_dev *mdev = c->mdev;
> > +	u32 xdp_frag_size = 0;
> >   	int err;
> >   	rq->wq_type      = params->rq_wq_type;
> > @@ -599,7 +600,11 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
> >   	if (err)
> >   		return err;
> > -	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id);
> > +	if (rq->wq_type == MLX5_WQ_TYPE_CYCLIC && rq_params->frags_info.num_frags > 1)
> 
> How about a more generic check? like:
> if (params->xdp_prog && params->xdp_prog->aux->xdp_has_frags)
> 
> So we won't have to maintain this when Stridng RQ support is added.

The check is specific, because below I use rq_params->frags_info, which
is specific to legacy RQ. If we change the input for xdp_frag_size, the
check can also be changed, but the condition that you suggested can't be
used anyway, because the XDP program can be hot-swapped without
recreating channels (i.e. without calling into mlx5e_init_rxq_rq), and
xdp_has_frags can change after the hot-swap.

It's actually valid to pass a non-zero value unconditionally, it just
won't be used if the driver doesn't pass any multi-buffer frames to XDP.
I added a reasonable condition solely for extra robustness, but we can
drop the `if` altogether if we don't agree on the condition.

> > +		xdp_frag_size = rq_params->frags_info.arr[1].frag_stride;
> 
> Again, in order to not maintain this (frags_info.arr[1].frag_stride not
> relevant for Striding RQ), isn't the value always PAGE_SIZE?

It's always PAGE_SIZE for the current implementation of legacy RQ, but
the kernel doesn't fix it to PAGE_SIZE, it's possible for a driver to
choose a different memory allocation scheme with fragments of another
size, that's why this parameter exists.

Setting it to PAGE_SIZE to be "future-proof" may be problematic: if
striding RQ uses a different frag_size, and the author forgets to update
this code, it may lead to a memory corruption on adjust_tail.

There is an obvious robustness problem with this place in code: it's
easy to forget about updating it. I forgot to set the right non-zero
value when I added XDP multi buffer, the next developer risks forgetting
updating this code when XDP multi buffer support is extended to striding
RQ, or the memory allocation scheme is somehow changed. So, it's not
possible to avoid maintaining it: either way it might need changes in
the future. I wanted to add some WARN_ON or BUILD_BUG_ON to simplify
such maintenance, but couldn't think of a good check...

> 
> Another idea is to introduce something like
> #define XDP_MB_FRAG_SZ (PAGE_SIZE)
> use it here and in mlx5e_build_rq_frags_info ::
> if (byte_count > max_mtu || params->xdp_prog) {
> 	frag_size_max = XDP_MB_FRAG_SZ;
> Not sure it's worth it...

IMO, it doesn't fit to mlx5e_build_rq_frags_info, because that function
heavily relies on its value being PAGE_SIZE, and hiding it under a
different name may give false impression that it can be changed.
Moreover, there is a chance that striding RQ will use a different value
for XDP frag_size. Also, it rather doesn't make sense even in the code
that you quoted: if byte_count > max_mtu, using XDP_MB_FRAG_SZ doesn't
make sense.

Using this constant only here, but not in mlx5e_build_rq_frags_info
doesn't make sense either, because it won't help remind developers to
update this part of code.

I think I got a better idea: move the logic to en/params.c, it knows
everything about the memory allocation scheme, about the XDP multi
buffer support, so let it calculate the right value and assign it to
some field (let's say, rq_params->xdp_frag_size), which is passed to
mlx5e_init_rxq_rq and used here as is. mlx5e_init_rxq_rq won't need to
dig into implementation details of each mode, instead the functions that
contain these details will calculate the value for XDP. What do you
think?

> Both ways we save passing rq_params in the callstack.

I don't think the number of parameters is crucial for non-datapath,
especially given that it's still fewer than 6.

> 
> > +
> > +	return __xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq->ix, c->napi.napi_id,
> > +				  xdp_frag_size);
> >   }
> >   static int mlx5_rq_shampo_alloc(struct mlx5_core_dev *mdev,
> > @@ -2214,7 +2219,7 @@ static int mlx5e_open_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
> >   {
> >   	int err;
> > -	err = mlx5e_init_rxq_rq(c, params, &c->rq);
> > +	err = mlx5e_init_rxq_rq(c, params, rq_params, &c->rq);
> >   	if (err)
> >   		return err;
