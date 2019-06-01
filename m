Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509CC31A8B
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 10:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfFAI1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 04:27:35 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35804 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfFAI1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 04:27:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWzMS-0001Ow-5U; Sat, 01 Jun 2019 10:27:32 +0200
Date:   Sat, 1 Jun 2019 10:27:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: add support for matching IPv4 options
Message-ID: <20190601082732.fpgrqtcj7i7g6wek@breakpoint.cc>
References: <20190523093801.3747-1-ssuryaextr@gmail.com>
 <20190531171101.5pttvxlbernhmlra@salvia>
 <20190531193558.GB4276@ubuntu>
 <20190601002230.bo6dhdf3lhlkknqq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190601002230.bo6dhdf3lhlkknqq@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > »       iph = skb_header_pointer(skb, *offset, sizeof(_iph), &_iph);
> > »       if (!iph || skb->protocol != htons(ETH_P_IP))
> > »       »       return -EBADMSG;
> 
> I mean, you make this check upfront from the _eval() path, ie.
> 
> static void nft_exthdr_ipv4_eval(const struct nft_expr *expr,
>                                  ...
> {
>         ...
> 
>         if (skb->protocol != htons(ETH_P_IP))
>                 goto err;

Wouldn't it be preferable to just use nft_pf() != NFPROTO_IPV4?
