Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A197094E
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfGVTJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:09:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47920 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfGVTJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:09:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE38815258BA1;
        Mon, 22 Jul 2019 12:09:01 -0700 (PDT)
Date:   Mon, 22 Jul 2019 12:09:01 -0700 (PDT)
Message-Id: <20190722.120901.1770656295609872438.davem@davemloft.net>
To:     cai@lca.pw
Cc:     saeedm@mellanox.com, leonro@mellanox.com, yishaih@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: fix -Wtype-limits compilation warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563820482-10302-1-git-send-email-cai@lca.pw>
References: <1563820482-10302-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jul 2019 12:09:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Mon, 22 Jul 2019 14:34:42 -0400

> The commit b9a7ba556207 ("net/mlx5: Use event mask based on device
> capabilities") introduced a few compilation warnings due to it bumps
> MLX5_EVENT_TYPE_MAX from 0x27 to 0x100 which is always greater than
> an "struct {mlx5_eqe|mlx5_nb}.type" that is an "u8".
> 
> drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function
> 'mlx5_eq_notifier_register':
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:948:21: warning: comparison
> is always false due to limited range of data type [-Wtype-limits]
>   if (nb->event_type >= MLX5_EVENT_TYPE_MAX)
>                      ^~
> drivers/net/ethernet/mellanox/mlx5/core/eq.c: In function
> 'mlx5_eq_notifier_unregister':
> drivers/net/ethernet/mellanox/mlx5/core/eq.c:959:21: warning: comparison
> is always false due to limited range of data type [-Wtype-limits]
>   if (nb->event_type >= MLX5_EVENT_TYPE_MAX)
> 
> Fix them by removing unnecessary checkings.
> 
> Fixes: b9a7ba556207 ("net/mlx5: Use event mask based on device capabilities")
> Signed-off-by: Qian Cai <cai@lca.pw>

Saeed, I am assuming that you will take this.
