Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A8E253A5F
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgHZWth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZWth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:49:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5043CC061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:49:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B2842128F6DFA;
        Wed, 26 Aug 2020 15:32:50 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:49:36 -0700 (PDT)
Message-Id: <20200826.154936.1813080115853524926.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] mptcp: free acked data before waiting for more
 memory
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825233105.15172-1-fw@strlen.de>
References: <20200825233105.15172-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:32:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Wed, 26 Aug 2020 01:31:05 +0200

> After subflow lock is dropped, more wmem might have been made available.
> 
> This fixes a deadlock in mptcp_connect.sh 'mmap' mode: wmem is exhausted.
> But as the mptcp socket holds on to already-acked data (for retransmit)
> no wakeup will occur.
> 
> Using 'goto restart' calls mptcp_clean_una(sk) which will free pages
> that have been acked completely in the mean time.
> 
> Fixes: fb529e62d3f3 ("mptcp: break and restart in case mptcp sndbuf is full")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied and queued up for -stable, thanks.
