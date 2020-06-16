Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6441FA569
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 03:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgFPBJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 21:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgFPBJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 21:09:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D393C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 18:09:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91625122CBCB9;
        Mon, 15 Jun 2020 18:09:42 -0700 (PDT)
Date:   Mon, 15 Jun 2020 18:09:41 -0700 (PDT)
Message-Id: <20200615.180941.204956390185248889.davem@davemloft.net>
To:     weiyongjun1@huawei.com
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        peter.krystad@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: Re: [PATCH net v2] mptcp: fix memory leak in
 mptcp_subflow_create_socket()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200615013522.96854-1-weiyongjun1@huawei.com>
References: <20200615013522.96854-1-weiyongjun1@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 18:09:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 15 Jun 2020 09:35:22 +0800

> socket malloced  by sock_create_kern() should be release before return
> in the error handling, otherwise it cause memory leak.
> 
> unreferenced object 0xffff88810910c000 (size 1216):
>   comm "00000003_test_m", pid 12238, jiffies 4295050289 (age 54.237s)
>   hex dump (first 32 bytes):
>     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 2f 30 0a 81 88 ff ff  ........./0.....
>   backtrace:
>     [<00000000e877f89f>] sock_alloc_inode+0x18/0x1c0
>     [<0000000093d1dd51>] alloc_inode+0x63/0x1d0
>     [<000000005673fec6>] new_inode_pseudo+0x14/0xe0
>     [<00000000b5db6be8>] sock_alloc+0x3c/0x260
>     [<00000000e7e3cbb2>] __sock_create+0x89/0x620
>     [<0000000023e48593>] mptcp_subflow_create_socket+0xc0/0x5e0
>     [<00000000419795e4>] __mptcp_socket_create+0x1ad/0x3f0
>     [<00000000b2f942e8>] mptcp_stream_connect+0x281/0x4f0
>     [<00000000c80cd5cc>] __sys_connect_file+0x14d/0x190
>     [<00000000dc761f11>] __sys_connect+0x128/0x160
>     [<000000008b14e764>] __x64_sys_connect+0x6f/0xb0
>     [<000000007b4f93bd>] do_syscall_64+0xa1/0x530
>     [<00000000d3e770b6>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
> v1 -> v2: add net prefix to subject line

Applied and queued up for v5.6 -stable, thanks.
