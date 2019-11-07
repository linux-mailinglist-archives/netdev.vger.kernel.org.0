Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C69F272C
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfKGFf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:35:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33952 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfKGFf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:35:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C05F21511D770;
        Wed,  6 Nov 2019 21:35:56 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:35:56 -0800 (PST)
Message-Id: <20191106.213556.714656150086041700.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] net: silence data-races on sk_backlog.tail
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191106180411.113080-1-edumazet@google.com>
References: <20191106180411.113080-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:35:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  6 Nov 2019 10:04:11 -0800

> sk->sk_backlog.tail might be read without holding the socket spinlock,
> we need to add proper READ_ONCE()/WRITE_ONCE() to silence the warnings.
> 
> KCSAN reported :
> 
> BUG: KCSAN: data-race in tcp_add_backlog / tcp_recvmsg
 ...
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
