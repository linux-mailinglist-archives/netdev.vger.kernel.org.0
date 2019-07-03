Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1E65EB7F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfGCSZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:25:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCSZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:25:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1EC32140CFF56;
        Wed,  3 Jul 2019 11:25:02 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:24:59 -0700 (PDT)
Message-Id: <20190703.112459.875695376158111859.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, mahesh@bandewar.net,
        geert@linux-m68k.org
Subject: Re: [PATCH next] loopback: fix lockdep splat
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703061631.84485-1-maheshb@google.com>
References: <20190703061631.84485-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:25:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Tue,  2 Jul 2019 23:16:31 -0700

> dev_init_scheduler() and dev_activate() expect the caller to
> hold RTNL. Since we don't want blackhole device to be initialized
> per ns, we are initializing at init.
> 
> [    3.855027] Call Trace:
> [    3.855034]  dump_stack+0x67/0x95
> [    3.855037]  lockdep_rcu_suspicious+0xd5/0x110
> [    3.855044]  dev_init_scheduler+0xe3/0x120
> [    3.855048]  ? net_olddevs_init+0x60/0x60
> [    3.855050]  blackhole_netdev_init+0x45/0x6e
> [    3.855052]  do_one_initcall+0x6c/0x2fa
> [    3.855058]  ? rcu_read_lock_sched_held+0x8c/0xa0
> [    3.855066]  kernel_init_freeable+0x1e5/0x288
> [    3.855071]  ? rest_init+0x260/0x260
> [    3.855074]  kernel_init+0xf/0x180
> [    3.855076]  ? rest_init+0x260/0x260
> [    3.855078]  ret_from_fork+0x24/0x30
> 
> Fixes: 4de83b88c66 ("loopback: create blackhole net device similar to loopack.")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

Applied.
