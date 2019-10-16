Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9EED99E5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403913AbfJPTVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:21:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53298 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403782AbfJPTVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:21:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 444E11425B0E7;
        Wed, 16 Oct 2019 12:21:06 -0700 (PDT)
Date:   Wed, 16 Oct 2019 12:21:05 -0700 (PDT)
Message-Id: <20191016.122105.1270802508720509186.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jakub.kicinski@netronome.com, dhowells@redhat.com
Subject: Re: [PATCH net] rxrpc: use rcu protection while reading
 sk->sk_user_data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014130438.163688-1-edumazet@google.com>
References: <20191014130438.163688-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Oct 2019 12:21:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon, 14 Oct 2019 06:04:38 -0700

> We need to extend the rcu_read_lock() section in rxrpc_error_report()
> and use rcu_dereference_sk_user_data() instead of plain access
> to sk->sk_user_data to make sure all rules are respected.
> 
> The compiler wont reload sk->sk_user_data at will, and RCU rules
> prevent memory beeing freed too soon.
> 
> Fixes: f0308fb07080 ("rxrpc: Fix possible NULL pointer access in ICMP handling")
> Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Howells <dhowells@redhat.com>

Applied, thanks Eric.
