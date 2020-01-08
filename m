Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B6134DF2
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgAHUxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:53:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47718 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgAHUxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:53:30 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1100E1584C8E5;
        Wed,  8 Jan 2020 12:53:30 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:53:29 -0800 (PST)
Message-Id: <20200108.125329.978670665805978687.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
Subject: Re: [PATCH net] macvlan: do not assume mac_header is set in
 macvlan_broadcast()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106203048.204196-1-edumazet@google.com>
References: <20200106203048.204196-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:53:30 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Mon,  6 Jan 2020 12:30:48 -0800

> Use of eth_hdr() in tx path is error prone.
> 
> Many drivers call skb_reset_mac_header() before using it,
> but others do not.
> 
> Commit 6d1ccff62780 ("net: reset mac header in dev_start_xmit()")
> attempted to fix this generically, but commit d346a3fae3ff
> ("packet: introduce PACKET_QDISC_BYPASS socket option") brought
> back the macvlan bug.
> 
> Lets add a new helper, so that tx paths no longer have
> to call skb_reset_mac_header() only to get a pointer
> to skb->data.
> 
> Hopefully we will be able to revert 6d1ccff62780
> ("net: reset mac header in dev_start_xmit()") and save few cycles
> in transmit fast path.
 ...
> Fixes: b863ceb7ddce ("[NET]: Add macvlan driver")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>

Applied and queued up for -stable, thanks Eric.
