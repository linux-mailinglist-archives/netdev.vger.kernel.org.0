Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96019271932
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 04:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgIUCJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 22:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIUCJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 22:09:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213EBC061755;
        Sun, 20 Sep 2020 19:09:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 519C013D74AB2;
        Sun, 20 Sep 2020 18:52:49 -0700 (PDT)
Date:   Sun, 20 Sep 2020 19:09:36 -0700 (PDT)
Message-Id: <20200920.190936.692148593394247602.davem@davemloft.net>
To:     Julia.Lawall@inria.fr
Cc:     santosh.shilimkar@oracle.com, kernel-janitors@vger.kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] RDS: drop double zeroing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600601186-7420-8-git-send-email-Julia.Lawall@inria.fr>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
        <1600601186-7420-8-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 18:52:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Sun, 20 Sep 2020 13:26:19 +0200

> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.
> 
> the semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,n,flags;
> @@
> 
> x = 
> - kcalloc
> + kmalloc_array
>   (n,sizeof(*x),flags)
> ...
> sg_init_table(x,n)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Applied.
