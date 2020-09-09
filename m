Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27752625E5
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgIID2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIID2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:28:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD325C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 20:28:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEECD11E3E4C3;
        Tue,  8 Sep 2020 20:11:50 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:28:36 -0700 (PDT)
Message-Id: <20200908.202836.574556740303703917.davem@davemloft.net>
To:     saeedm@nvidia.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, maximmi@mellanox.com,
        tariqt@mellanox.com
Subject: Re: [net-next V2 03/12] net/mlx5e: Move mlx5e_tx_wqe_inline_mode
 to en_tx.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909012757.32677-4-saeedm@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
        <20200909012757.32677-4-saeedm@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:11:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>
Date: Tue, 8 Sep 2020 18:27:48 -0700

> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -232,6 +232,29 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>  	return -ENOMEM;
>  }
>  
> +static inline bool mlx5e_transport_inline_tx_wqe(struct mlx5_wqe_ctrl_seg *cseg)
> +{
> +	return cseg && !!cseg->tis_tir_num;
> +}
> +
> +static inline u8
> +mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct mlx5_wqe_ctrl_seg *cseg,
> +			 struct sk_buff *skb)
> +{

No inlines in foo.c files, please.
