Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9CA3A35C4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFJVUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:20:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50394 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFJVUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 17:20:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id AFEAA4F7DFB96;
        Thu, 10 Jun 2021 14:18:43 -0700 (PDT)
Date:   Thu, 10 Jun 2021 14:18:43 -0700 (PDT)
Message-Id: <20210610.141843.1491689012491247186.davem@davemloft.net>
To:     changbin.du@gmail.com
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xiyou.wangcong@gmail.com, David.Laight@ACULAB.COM,
        christian.brauner@ubuntu.com
Subject: Re: [PATCH v3] net: make get_net_ns return error if NET_NS is
 disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210610153941.118945-1-changbin.du@gmail.com>
References: <20210610153941.118945-1-changbin.du@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Jun 2021 14:18:44 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Date: Thu, 10 Jun 2021 23:39:41 +0800

> There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
> The reason is that nsfs tries to access ns->ops but the proc_ns_operations
> is not implemented in this case.
> 
> [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> [7.670268] pgd = 32b54000
> [7.670544] [00000010] *pgd=00000000
> [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> [7.672315] Modules linked in:
> [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> [7.673309] Hardware name: Generic DT based system
> [7.673642] PC is at nsfs_evict+0x24/0x30
> [7.674486] LR is at clear_inode+0x20/0x9c
> 
> The same to tun SIOCGSKNS command.
> 
> To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
> disabled. Meanwhile move it to right place net/core/net_namespace.c.
> 
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>

As this is a bug fix please rebase on the 'net' tree and provide a proper Fixes: tag.

Thank you.
