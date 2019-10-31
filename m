Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 610D5EA849
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJaAfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:35:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfJaAfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:35:36 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45BD114DECD27;
        Wed, 30 Oct 2019 17:35:35 -0700 (PDT)
Date:   Wed, 30 Oct 2019 17:35:34 -0700 (PDT)
Message-Id: <20191030.173534.1339199251690556046.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: annotate lockless accesses to sk->sk_napi_id
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029175444.83564-1-edumazet@google.com>
References: <20191029175444.83564-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 17:35:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 29 Oct 2019 10:54:44 -0700

> We already annotated most accesses to sk->sk_napi_id
> 
> We missed sk_mark_napi_id() and sk_mark_napi_id_once()
> which might be called without socket lock held in UDP stack.
> 
> KCSAN reported :
> BUG: KCSAN: data-race in udpv6_queue_rcv_one_skb / udpv6_queue_rcv_one_skb
 ...
> Fixes: e68b6e50fa35 ("udp: enable busy polling for all sockets")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
