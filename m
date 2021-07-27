Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F03D80FC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhG0VKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:10:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36444 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhG0VKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:10:37 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 381C2605D7;
        Tue, 27 Jul 2021 23:10:05 +0200 (CEST)
Date:   Tue, 27 Jul 2021 23:10:29 +0200
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
Message-ID: <20210727211029.GA17432@salvia>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 03:06:05PM -0500, Alex Forster wrote:
> (And again, this time as plain-text...)
> 
> > Why do you need to make the two consistent? iptables NFLOG prefix
> > length is a subset of nftables log action, this is sufficient for the
> > iptables-nft layer. I might be missing the use-case on your side,
> > could you please elaborate?
> 
> We use the nflog prefix space to attach various bits of metadata to
> iptables and nftables rules that are dynamically generated and
> installed on our edge. 63 printable chars is a bit too tight to fit
> everything that we need, so we're running this patch internally and
> are looking to upstream it.

It should be possible to update iptables-nft to use nft_log from
userspace (instead of xt_LOG) which removes this limitation, there is
no need for a kernel upgrade.
