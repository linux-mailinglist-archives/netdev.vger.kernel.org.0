Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934231D4091
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgENWNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgENWNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:13:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A30C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 15:13:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F5A213C43B56;
        Thu, 14 May 2020 15:13:12 -0700 (PDT)
Date:   Thu, 14 May 2020 15:13:11 -0700 (PDT)
Message-Id: <20200514.151311.883516625024833502.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        arjunroy@google.com, soheil@google.com, syzkaller@googlegroups.com
Subject: Re: [PATCH net] tcp: fix error recovery in tcp_zerocopy_receive()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514205813.164401-1-edumazet@google.com>
References: <20200514205813.164401-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 15:13:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 14 May 2020 13:58:13 -0700

> If user provides wrong virtual address in TCP_ZEROCOPY_RECEIVE
> operation we want to return -EINVAL error.
> 
> But depending on zc->recv_skip_hint content, we might return
> -EIO error if the socket has SOCK_DONE set.
> 
> Make sure to return -EINVAL in this case.
> 
> BUG: KMSAN: uninit-value in tcp_zerocopy_receive net/ipv4/tcp.c:1833 [inline]
  ...
> Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Series applied and queued up for -stable, thanks.
