Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA561C431D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgEDRmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDRmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:42:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5C1C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 10:42:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7470E11951B43;
        Mon,  4 May 2020 10:42:52 -0700 (PDT)
Date:   Mon, 04 May 2020 10:42:51 -0700 (PDT)
Message-Id: <20200504.104251.870707696930385118.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, jgg@mellanox.com
Subject: Re: [PATCH net] net/mlx4_core: Fix use of ENOSPC around
 mlx4_counter_alloc()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504083602.19947-1-tariqt@mellanox.com>
References: <20200504083602.19947-1-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 10:42:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Mon,  4 May 2020 11:36:02 +0300

> When ENOSPC is set the idx is still valid and gets set to the global
> MLX4_SINK_COUNTER_INDEX.  However gcc's static analysis cannot tell that
> ENOSPC is impossible from mlx4_cmd_imm() and gives this warning:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:2552:28: warning: 'idx' may be
> used uninitialized in this function [-Wmaybe-uninitialized]
>  2552 |    priv->def_counter[port] = idx;
> 
> Also, when ENOSPC is returned mlx4_allocate_default_counters should not
> fail.
> 
> Fixes: 6de5f7f6a1fa ("net/mlx4_core: Allocate default counter per port")
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

Applied, thank you.
