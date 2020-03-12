Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDAA182966
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 07:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbgCLG6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 02:58:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387889AbgCLG6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 02:58:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 460A714E20282;
        Wed, 11 Mar 2020 23:58:24 -0700 (PDT)
Date:   Wed, 11 Mar 2020 23:58:23 -0700 (PDT)
Message-Id: <20200311.235823.220996291757645509.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        shakeelb@google.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: memcg: fix lockdep splat in inet_csk_accept()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311184426.39253-1-edumazet@google.com>
References: <20200311184426.39253-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 23:58:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 11 Mar 2020 11:44:26 -0700

> Locking newsk while still holding the listener lock triggered
> a lockdep splat [1]
> 
> We can simply move the memcg code after we release the listener lock,
> as this can also help if multiple threads are sharing a common listener.
> 
> Also fix a typo while reading socket sk_rmem_alloc.
 ...
> Fixes: d752a4986532 ("net: memcg: late association of sock to memcg")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied, thanks Eric.
