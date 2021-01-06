Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38962EB718
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbhAFAvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:51:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56730 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbhAFAvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:51:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 9B5104CBCE1FD;
        Tue,  5 Jan 2021 16:50:30 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:50:30 -0800 (PST)
Message-Id: <20210105.165030.1318380667754321276.davem@davemloft.net>
To:     miaoqinglang@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: qrtr: fix null-ptr-deref in qrtr_ns_remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210105055754.16486-1-miaoqinglang@huawei.com>
References: <20210105055754.16486-1-miaoqinglang@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:50:30 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>
Date: Tue, 5 Jan 2021 13:57:54 +0800

> A null-ptr-deref bug is reported by Hulk Robot like this:
> --------------
> KASAN: null-ptr-deref in range [0x0000000000000128-0x000000000000012f]
> Call Trace:
> qrtr_ns_remove+0x22/0x40 [ns]
> qrtr_proto_fini+0xa/0x31 [qrtr]
> __x64_sys_delete_module+0x337/0x4e0
> do_syscall_64+0x34/0x80
> entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x468ded
> --------------
> 
> When qrtr_ns_init fails in qrtr_proto_init, qrtr_ns_remove which would
> be called later on would raise a null-ptr-deref because qrtr_ns.workqueue
> has been destroyed.
> 
> Fix it by making qrtr_ns_init have a return value and adding a check in
> qrtr_proto_init.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
> ---
> v1->v2: remove redundant braces for single statement blocks.

Applied.
