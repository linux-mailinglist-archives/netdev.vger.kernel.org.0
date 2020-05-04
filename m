Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9971C4689
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgEDTAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725956AbgEDTAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:00:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233D8C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:00:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D304D120ED551;
        Mon,  4 May 2020 12:00:51 -0700 (PDT)
Date:   Mon, 04 May 2020 12:00:51 -0700 (PDT)
Message-Id: <20200504.120051.910444868496651308.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, l.dmxcsnsbh@gmail.com
Subject: Re: [Patch net] atm: fix a memory leak of vcc->user_back
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200501181109.14542-2-xiyou.wangcong@gmail.com>
References: <20200501181109.14542-1-xiyou.wangcong@gmail.com>
        <20200501181109.14542-2-xiyou.wangcong@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 12:00:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Fri,  1 May 2020 11:11:09 -0700

> In lec_arp_clear_vccs() only entry->vcc is freed, but vcc
> could be installed on entry->recv_vcc too in lec_vcc_added().
> 
> This fixes the following memory leak:
> 
> unreferenced object 0xffff8880d9266b90 (size 16):
>   comm "atm2", pid 425, jiffies 4294907980 (age 23.488s)
>   hex dump (first 16 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 6b 6b 6b a5  ............kkk.
>   backtrace:
>     [<(____ptrval____)>] kmem_cache_alloc_trace+0x10e/0x151
>     [<(____ptrval____)>] lane_ioctl+0x4b3/0x569
>     [<(____ptrval____)>] do_vcc_ioctl+0x1ea/0x236
>     [<(____ptrval____)>] svc_ioctl+0x17d/0x198
>     [<(____ptrval____)>] sock_do_ioctl+0x47/0x12f
>     [<(____ptrval____)>] sock_ioctl+0x2f9/0x322
>     [<(____ptrval____)>] vfs_ioctl+0x1e/0x2b
>     [<(____ptrval____)>] ksys_ioctl+0x61/0x80
>     [<(____ptrval____)>] __x64_sys_ioctl+0x16/0x19
>     [<(____ptrval____)>] do_syscall_64+0x57/0x65
>     [<(____ptrval____)>] entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Cc: Gengming Liu <l.dmxcsnsbh@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Applied.
