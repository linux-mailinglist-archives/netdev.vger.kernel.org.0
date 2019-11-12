Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFAC2F9A69
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 21:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKLURv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 15:17:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfKLURv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 15:17:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A738154D32A3;
        Tue, 12 Nov 2019 12:17:50 -0800 (PST)
Date:   Tue, 12 Nov 2019 12:17:49 -0800 (PST)
Message-Id: <20191112.121749.1249383492212187557.davem@davemloft.net>
To:     kgraul@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: fix refcount non-blocking connect() -part
 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191112150341.90681-1-kgraul@linux.ibm.com>
References: <20191112150341.90681-1-kgraul@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 12:17:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>
Date: Tue, 12 Nov 2019 16:03:41 +0100

> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> If an SMC socket is immediately terminated after a non-blocking connect()
> has been called, a memory leak is possible.
> Due to the sock_hold move in
> commit 301428ea3708 ("net/smc: fix refcounting for non-blocking connect()")
> an extra sock_put() is needed in smc_connect_work(), if the internal
> TCP socket is aborted and cancels the sk_stream_wait_connect() of the
> connect worker.
> 
> Reported-by: syzbot+4b73ad6fc767e576e275@syzkaller.appspotmail.com
> Fixes: 301428ea3708 ("net/smc: fix refcounting for non-blocking connect()")
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

Applied.

And since 301428ea3708 went to -stable, I'll queue this up too.

Thanks.
