Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DE82258F0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgGTHuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:50:07 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:36313 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbgGTHuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 03:50:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id DF05F5C018D;
        Mon, 20 Jul 2020 03:50:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 20 Jul 2020 03:50:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=OLSM8W
        H1RpFOpDWh6lkvgoQETXsbuQm9lUlUSotQXIE=; b=JtWv6RawvEWiNGVWAnDglb
        KH76OaxIlY9xtl3q4OEp7p2n/YJOpw4AuVaKqw7WYqosIZslWJWFAFyCT8ea5nU6
        SuCeoqUml/K3VasKyxxypCU2ZzVXqwafPBb17MSLzAoWZW+VJYlldC0ZHAHAzXdZ
        ZXHEVZFcMH5aEnwfdE2n1s1YefKZmPCtBuqs7R6aM0DJ5l2A53IPQOyT8XaEfJcc
        2t7Nh2HxPwbSYxlIzwx2s8JS+xZapd8BsczPQnIEO53oLsQfrmkPbCq4Xkgzjk2p
        RRZ39HYpAfVwGwn05x02JJHsrwLhvBtH8ppqMTCLUfRZ6k5ddJaroSSREZo8YN5g
        ==
X-ME-Sender: <xms:rUwVX92KlLI8nTwhK-Uoszwi95GS3yyDfKro3EPuUnsReGV-XqtT_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgedvgdduudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepjeelrddukedurdefjedrkedvnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:rUwVX0HKs28KTdL-rCekUOzVJKKnfhSFADYGss1CJwrXDyLc0Rln0A>
    <xmx:rUwVX97bj-Cqsc-Zy6KvWxpEAYWiKtzIZgRtmmVyYx3018olfEBdCw>
    <xmx:rUwVX619VVZRglKz6mqj2Ve8wRHagFST7UhZ8SXESdduqp34JtsRBw>
    <xmx:rUwVX0ASW-IaII8OuEAAO57EpMgjZjP-jyX5LQOkGAqH5uVkoSLNRg>
Received: from localhost (bzq-79-181-37-82.red.bezeqint.net [79.181.37.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id EFE52328005E;
        Mon, 20 Jul 2020 03:50:04 -0400 (EDT)
Date:   Mon, 20 Jul 2020 10:50:00 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] sched: sch_api: add missing rcu read lock to
 silence the warning
Message-ID: <20200720075000.GA352399@shredder>
References: <20200720072248.6184-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720072248.6184-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 09:22:48AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> In case the qdisc_match_from_root function() is called from non-rcu path
> with rtnl mutex held, a suspiciout rcu usage warning appears:
> 
> [  241.504354] =============================
> [  241.504358] WARNING: suspicious RCU usage
> [  241.504366] 5.8.0-rc4-custom-01521-g72a7c7d549c3 #32 Not tainted
> [  241.504370] -----------------------------
> [  241.504378] net/sched/sch_api.c:270 RCU-list traversed in non-reader section!!
> [  241.504382]
>                other info that might help us debug this:
> [  241.504388]
>                rcu_scheduler_active = 2, debug_locks = 1
> [  241.504394] 1 lock held by tc/1391:
> [  241.504398]  #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0
> [  241.504431]
>                stack backtrace:
> [  241.504440] CPU: 0 PID: 1391 Comm: tc Not tainted 5.8.0-rc4-custom-01521-g72a7c7d549c3 #32
> [  241.504446] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
> [  241.504453] Call Trace:
> [  241.504465]  dump_stack+0x100/0x184
> [  241.504482]  lockdep_rcu_suspicious+0x153/0x15d
> [  241.504499]  qdisc_match_from_root+0x293/0x350
> 
> Fix this by taking the rcu_lock for qdisc_hash iteration.
> 
> Reported-by: Ido Schimmel <idosch@mellanox.com>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/sched/sch_api.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 11ebba60da3b..c7cfd8dc6a77 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -267,10 +267,12 @@ static struct Qdisc *qdisc_match_from_root(struct Qdisc *root, u32 handle)
>  	    root->handle == handle)
>  		return root;
>  
> +	rcu_read_lock();
>  	hash_for_each_possible_rcu(qdisc_dev(root)->qdisc_hash, q, hash, handle) {
>  		if (q->handle == handle)
>  			return q;

You don't unlock here, but I'm not sure it's the best fix. It's weird to
return an object from an RCU critical section without taking a
reference. It can also hide a bug if someone calls
qdisc_match_from_root() without RTNL or RCU.

hash_for_each_possible_rcu() is basically hlist_for_each_entry_rcu()
which already accepts:

@cond:       optional lockdep expression if called from non-RCU protection.

So maybe extend hash_for_each_possible_rcu() with 'cond' and pass a
lockdep expression to see if RTNL is held?

>  	}
> +	rcu_read_unlock();
>  	return NULL;
>  }
>  
> -- 
> 2.21.3
> 
