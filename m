Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCE03AD21
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 04:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbfFJCmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 22:42:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48758 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387409AbfFJCmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 22:42:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DADE214EAD04B;
        Sun,  9 Jun 2019 19:42:39 -0700 (PDT)
Date:   Sun, 09 Jun 2019 19:42:39 -0700 (PDT)
Message-Id: <20190609.194239.1479697558753282281.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net-next 1/1] ipv6: tcp: fix potential NULL deref in
 tcp_v6_send_reset()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607192348.189876-1-edumazet@google.com>
References: <20190607192348.189876-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 19:42:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri,  7 Jun 2019 12:23:48 -0700

> syzbot found a crash in tcp_v6_send_reset() caused by my latest
> change.
> 
> Problem is that if an skb has been queued to socket prequeue,
> skb_dst(skb)->dev can not anymore point to the device.
> 
> Fortunately in this case the socket pointer is not NULL.
> 
> A similar issue has been fixed in commit 0f85feae6b71 ("tcp: fix
> more NULL deref after prequeue changes"), I should have known better.
> 
> Fixes: 323a53c41292 ("ipv6: tcp: enable flowlabel reflection in some RST packets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied.
