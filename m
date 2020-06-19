Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4D82000F1
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgFSDsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSDsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:48:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94853C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:48:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE13B120ED49C;
        Thu, 18 Jun 2020 20:48:30 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:48:30 -0700 (PDT)
Message-Id: <20200618.204830.1094276610079682944.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, kuba@kernel.org,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] net: increment xmit_recursion level in
 dev_direct_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618052325.78441-1-edumazet@google.com>
References: <20200618052325.78441-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:48:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 Jun 2020 22:23:25 -0700

> Back in commit f60e5990d9c1 ("ipv6: protect skb->sk accesses
> from recursive dereference inside the stack") Hannes added code
> so that IPv6 stack would not trust skb->sk for typical cases
> where packet goes through 'standard' xmit path (__dev_queue_xmit())
> 
> Alas af_packet had a dev_direct_xmit() path that was not
> dealing yet with xmit_recursion level.
> 
> Also change sk_mc_loop() to dump a stack once only.
> 
> Without this patch, syzbot was able to trigger :
 ...
> f60e5990d9c1 ("ipv6: protect skb->sk accesses from recursive dereference inside the stack")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable.

I only noticed after pushing this out the missing "Fixes: " prefix, but not
much I can do about this now sorry :-/
