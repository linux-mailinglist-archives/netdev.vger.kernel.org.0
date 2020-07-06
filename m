Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC1B215BCB
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgGFQ30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgGFQ30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:29:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33592C061755;
        Mon,  6 Jul 2020 09:29:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jsTzX-0005wC-6M; Mon, 06 Jul 2020 18:29:15 +0200
Date:   Mon, 6 Jul 2020 18:29:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] netfilter: nf_defrag_ipv4: Add
 nf_ct_frag_gather support
Message-ID: <20200706162915.GB32005@breakpoint.cc>
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
 <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
 <20200706143826.GA32005@breakpoint.cc>
 <06700aee-f62f-7b83-de21-4f5b4928978e@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06700aee-f62f-7b83-de21-4f5b4928978e@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu <wenxu@ucloud.cn> wrote:
> 
> 在 2020/7/6 22:38, Florian Westphal 写道:
> > wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> Add nf_ct_frag_gather for conntrack defrag and it will
> >> elide the CB clear when packets are defragmented by
> >> connection tracking
> > Why is this patch required?
> > Can't you rework ip_defrag to avoid the cb clear if you need that?
> 
> The ip_defrag used by ip stack and can work with the cb setting.

Yes, but does it have to?

If yes, why does nf_ct_frag not need it whereas ip_defrag has to?

> Defragment case only for conntrack maybe need to avoid the cb
> 
> clear. So it is more clear to nf_ct_frag_gather for conntrack like the
> 
> function nf_ct_frag6_gather for ipv6.

nf_ct_frag6_gather() is only re-using less code from ipv6 for historical
reasons.  If anything, ipv6 conntrack defrag should re-use more code from
ipv6 defrag, rather than making ipv4 conntrack defrag look more like
ipv6 conntrack defrag.

