Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C0E824B6
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbfHESOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:14:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbfHESOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:14:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F6DE1540C725;
        Mon,  5 Aug 2019 11:14:06 -0700 (PDT)
Date:   Mon, 05 Aug 2019 11:14:05 -0700 (PDT)
Message-Id: <20190805.111405.1284530866900143643.davem@davemloft.net>
To:     cai@lca.pw
Cc:     saeedm@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: always initialize frag->last_in_page
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564667574-31542-1-git-send-email-cai@lca.pw>
References: <1564667574-31542-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 11:14:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qian Cai <cai@lca.pw>
Date: Thu,  1 Aug 2019 09:52:54 -0400

> The commit 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue
> memory scheme") introduced an undefined behaviour below due to
> "frag->last_in_page" is only initialized in mlx5e_init_frags_partition()
> when,
> 
> if (next_frag.offset + frag_info[f].frag_stride > PAGE_SIZE)
> 
> or after bailed out the loop,
> 
> for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++)
> 
> As the result, there could be some "frag" have uninitialized
> value of "last_in_page".
> 
> Later, get_frag() obtains those "frag" and check "frag->last_in_page" in
> mlx5e_put_rx_frag() and triggers the error during boot. Fix it by always
> initializing "frag->last_in_page" to "false" in
> mlx5e_init_frags_partition().
...
> Fixes: 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue memory scheme")
> Signed-off-by: Qian Cai <cai@lca.pw>

Applied and queued up for -stable.
