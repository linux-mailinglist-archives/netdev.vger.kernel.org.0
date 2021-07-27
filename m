Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618B63D83A0
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhG0XCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:02:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37010 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbhG0XCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:02:36 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 112606429D;
        Wed, 28 Jul 2021 01:02:03 +0200 (CEST)
Date:   Wed, 28 Jul 2021 01:02:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alex Forster <aforster@cloudflare.com>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
Message-ID: <20210727230230.GA30104@salvia>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
 <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 05:45:09PM -0500, Alex Forster wrote:
> > Yes, you can update iptables-nft to use nft_log instead of xt_LOG,
> > that requires no kernel upgrades and it will work with older kernels.
> 
> I've always been under the impression that mixing xtables and nftables
> was impossible. Forgive me, but I just want to clarify one more time:
> you're saying we should be able to modify iptables-nft such that the
> following rule will use xt_bpf to match a packet and then nft_log to
> log it, rather than xt_log as it does today?

You could actually use *any* of the existing extensions to match a
packet, the matching side is completely irrelevant to this picture.

As I said, userspace iptables-nft can be updated to use nft_log
instead of xt_LOG.

>     iptables-nft -A test-chain -d 11.22.33.44/32 -m bpf --bytecode
> "1,6 0 0 65536" -j NFLOG --nflog-prefix
> "0123456789012345678901234567890123456789012345678901234567890123456789"
> 
> We had some unexplained performance loss when we were evaluating
> switching to iptables-nft, but if this sort of mixing is possible then
> it is certainly worth reevaluating.
