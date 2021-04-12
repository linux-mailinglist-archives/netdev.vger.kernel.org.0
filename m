Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74835C04C
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 11:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbhDLJML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 05:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbhDLJHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 05:07:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776C3C06137A;
        Mon, 12 Apr 2021 02:02:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lVsSf-0004hh-JE; Mon, 12 Apr 2021 11:02:25 +0200
Date:   Mon, 12 Apr 2021 11:02:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210412090225.GB14932@breakpoint.cc>
References: <20210412150416.4465b518@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412150416.4465b518@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no member named 'tables'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |                                 ^
> include/linux/list.h:619:20: note: in definition of macro 'list_entry_is_head'
>   619 |  (&pos->member == (head))
>       |                    ^~~~
> net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list_for_each_entry'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |  ^~~~~~~~~~~~~~~~~~~
> 
> Caused by commit
> 
>   5b53951cfc85 ("netfilter: ebtables: use net_generic infra")
> 
> interacting with commit
> 
>   7ee3c61dcd28 ("netfilter: bridge: add pre_exit hooks for ebtable unregistration")

Right, the fixup is correct.
