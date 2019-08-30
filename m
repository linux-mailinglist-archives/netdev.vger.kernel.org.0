Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0639BA3B21
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH3P60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:58:26 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57806 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727280AbfH3P60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:58:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3jI3-0004tU-DS; Fri, 30 Aug 2019 17:58:19 +0200
Date:   Fri, 30 Aug 2019 17:58:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190830155819.GQ20113@breakpoint.cc>
References: <20190821141505.2394-1-leonardo@linux.ibm.com>
 <db0f02c5b1a995fde174f036540a3d11008cf116.camel@linux.ibm.com>
 <b6585989069fd832a65b73d1c4f4319a10714165.camel@linux.ibm.com>
 <20190829205832.GM20113@breakpoint.cc>
 <4b3b52d0f73aeb1437b4b2a46325b36e9c41f92b.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3b52d0f73aeb1437b4b2a46325b36e9c41f92b.camel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> On Thu, 2019-08-29 at 22:58 +0200, Florian Westphal wrote:
> [...]
> > 1. add a patch to BREAK in nft_fib_netdev.c for !ipv6_mod_enabled()
> [...]
> 
> But this is still needed? I mean, in nft_fib_netdev_eval there are only
> 2 functions being called for IPv6 protocol : nft_fib6_eval and
> nft_fib6_eval_type. Both are already protected by this current patch.
> 
> Is your 1st suggestion about this patch, or you think it's better to
> move this change to nft_fib_netdev_eval ?

Ah, it was the latter.
Making bridge netfilter not pass packets up with ipv6 off closes
the problem for fib_ipv6 and inet, so only _netdev.c needs fixing.
