Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C22C8841D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfHIUhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:37:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfHIUhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:37:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9BF81456E97B;
        Fri,  9 Aug 2019 13:37:06 -0700 (PDT)
Date:   Fri, 09 Aug 2019 13:37:06 -0700 (PDT)
Message-Id: <20190809.133706.1598956680657409884.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 00/12] Mellanox, mlx5 fixes 2019-08-08
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 13:37:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 8 Aug 2019 20:21:58 +0000

> This series introduces some fixes to mlx5 driver.
> 
> Highlights:
> 1) From Tariq, Critical mlx5 kTLS fixes to better align with hw specs.
> 2) From Aya, Fixes to mlx5 tx devlink health reporter.
> 3) From Maxim, aRFs parsing to use flow dissector to avoid relying on
> invalid skb fields.
> 
> Please pull and let me know if there is any problem.

Pulled.

> For -stable v4.3
>  ('net/mlx5e: Only support tx/rx pause setting for port owner')
> For -stable v4.9
>  ('net/mlx5e: Use flow keys dissector to parse packets for ARFS')
> For -stable v5.1
>  ('net/mlx5e: Fix false negative indication on tx reporter CQE recovery')
>  ('net/mlx5e: Remove redundant check in CQE recovery flow of tx reporter')
>  ('net/mlx5e: ethtool, Avoid setting speed to 56GBASE when autoneg off')

Queued up.

> Note: when merged with net-next this minor conflict will pop up:
> ++<<<<<<< (net-next)
>  +      if (is_eswitch_flow) {
>  +              flow->esw_attr->match_level = match_level;
>  +              flow->esw_attr->tunnel_match_level = tunnel_match_level;
> ++=======
> +       if (flow->flags & MLX5E_TC_FLOW_ESWITCH) {
> +               flow->esw_attr->inner_match_level = inner_match_level;
> +               flow->esw_attr->outer_match_level = outer_match_level;
> ++>>>>>>> (net)
> 
> To resolve, use hunks from net (2nd) and replace:
> if (flow->flags & MLX5E_TC_FLOW_ESWITCH) 
> with
> if (is_eswitch_flow)

Thanks for this.
