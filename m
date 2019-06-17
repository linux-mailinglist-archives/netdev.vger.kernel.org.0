Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010BA491EC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfFQVCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:02:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38280 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfFQVCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 17:02:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A7631513979F;
        Mon, 17 Jun 2019 14:02:31 -0700 (PDT)
Date:   Mon, 17 Jun 2019 14:02:30 -0700 (PDT)
Message-Id: <20190617.140230.537297372523260104.davem@davemloft.net>
To:     arnd@arndb.de
Cc:     saeedm@mellanox.com, leon@kernel.org, ozsh@mellanox.com,
        paulb@mellanox.com, elibr@mellanox.com, markb@mellanox.com,
        ogerlitz@mellanox.com, maorg@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5e: reduce stack usage in
 mlx5_eswitch_termtbl_create
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617110855.2085326-1-arnd@arndb.de>
References: <20190617110855.2085326-1-arnd@arndb.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 14:02:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 17 Jun 2019 13:08:22 +0200

> Putting an empty 'mlx5_flow_spec' structure on the stack is a bit
> wasteful and causes a warning on 32-bit architectures when building
> with clang -fsanitize-coverage:
> 
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c: In function 'mlx5_eswitch_termtbl_create':
> drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c:90:1: error: the frame size of 1032 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> Since the structure is never written to, we can statically allocate
> it to avoid the stack usage. To be on the safe side, mark all
> subsequent function arguments that we pass it into as 'const'
> as well.
> 
> Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push actions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Saeed, once Arnd fixes the reverse christmas tree issue, I assume you will take
this in via your tree?

Thanks.
