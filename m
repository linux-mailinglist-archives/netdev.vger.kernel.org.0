Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1003A4F34
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhFLOMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230191AbhFLOMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 10:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FF361376;
        Sat, 12 Jun 2021 14:10:07 +0000 (UTC)
Date:   Sat, 12 Jun 2021 16:10:05 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jakub Kici nski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v4] net: make get_net_ns return error if NET_NS is
 disabled
Message-ID: <20210612141005.igoy2di6xhbkg7cq@wittgenstein>
References: <20210611142959.92358-1-changbin.du@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611142959.92358-1-changbin.du@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 10:29:59PM +0800, Changbin Du wrote:
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
> Fixes: c62cce2caee5 ("net: add an ioctl to get a socket network namespace")
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Cc: Christian Brauner <christian.brauner@ubuntu.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>

Looks good,
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
