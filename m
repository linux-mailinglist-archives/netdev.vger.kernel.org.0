Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAE140D9DD
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239437AbhIPM0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbhIPM0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:26:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C825C061574;
        Thu, 16 Sep 2021 05:24:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mQqRX-0002d3-8B; Thu, 16 Sep 2021 14:24:43 +0200
Date:   Thu, 16 Sep 2021 14:24:43 +0200
From:   Florian Westphal <fw@strlen.de>
To:     youling 257 <youling257@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] netfilter: x_tables: never register
 tables by default
Message-ID: <20210916122443.GD20414@breakpoint.cc>
References: <20210811084908.14744-10-pablo@netfilter.org>
 <20210915095116.14686-1-youling257@gmail.com>
 <20210915095650.GG25110@breakpoint.cc>
 <CAOzgRdb_Agb=vNcAc=TDjyB_vSjB8Jua_TPtWYcXZF0G3+pRAg@mail.gmail.com>
 <20210915143415.GA20414@breakpoint.cc>
 <CAOzgRdZKjg8iEdjEYQ07ENBvwtFPAqzESqrKJEppcNTBVw-RyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzgRdZKjg8iEdjEYQ07ENBvwtFPAqzESqrKJEppcNTBVw-RyQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

youling 257 <youling257@gmail.com> wrote:
> kernel 5.15rc1.

Thanks, this is due to a leftover __init annotation.
This patch should fix the bug:

diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -42,7 +42,7 @@ iptable_raw_hook(void *priv, struct sk_buff *skb,
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
 
-static int __net_init iptable_raw_table_init(struct net *net)
+static int iptable_raw_table_init(struct net *net)
 {
 	struct ipt_replace *repl;
 	const struct xt_table *table = &packet_raw;
