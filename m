Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4796F30CE49
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 22:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233928AbhBBV4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 16:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:56500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232865AbhBBV4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 16:56:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F34B660295;
        Tue,  2 Feb 2021 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612302933;
        bh=b2g6aK56icJbbaoYzrVicAD1k5eiCUfcw7T7FlJlGEs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q0Uwy77AqXBwy9C/hru+aYHDsFvylsB3yrfAQQwsW0BtZkCu5wRU5ePZ3QxiC4AaE
         JUSG1VHzCUVine/ot8zy9MKjg5Q+xPRtx4nRRjOmQzhx68oZuliOaYcLvYKkc23VZ/
         QvcOhFAcjdOy1I7iWjout02+koYFj87CDgsrW4uQ0yRhOcentejhbmzxa+awhrjbRF
         rJMPbxD23+hwRcW8ANaXWiQkShulcqbLB08i+E2i05rnwkgsuGq3b8VJwAvZ5jCGRC
         tmzZU70IaXn1U0UOrhp8uyU2IKgrEht6jpku6k8SOo57l9gZIn9a+e/jHsWu+BODoy
         YFigy9+bxqBmw==
Date:   Tue, 2 Feb 2021 13:55:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        coreteam@netfilter.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>, linux-kernel@vger.kernel.org,
        lvs-devel@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net 1/4] ipv6: silence compilation warning for non-IPV6
 builds
Message-ID: <20210202135531.043ed176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202185528.GE3264866@unreal>
References: <20210202135544.3262383-1-leon@kernel.org>
        <20210202135544.3262383-2-leon@kernel.org>
        <20210202082909.7d8f479f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210202185528.GE3264866@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 20:55:28 +0200 Leon Romanovsky wrote:
> On Tue, Feb 02, 2021 at 08:29:09AM -0800, Jakub Kicinski wrote:
> > On Tue,  2 Feb 2021 15:55:41 +0200 Leon Romanovsky wrote:  
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > The W=1 compilation of allmodconfig generates the following warning:
> > >
> > > net/ipv6/icmp.c:448:6: warning: no previous prototype for 'icmp6_send' [-Wmissing-prototypes]
> > >   448 | void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
> > >       |      ^~~~~~~~~~
> > >
> > > In such configuration, the icmp6_send() is not used outside of icmp.c, so close
> > > its EXPORT_SYMBOL and add "static" word to limit the scope.
> > >
> > > Fixes: cc7a21b6fbd9 ("ipv6: icmp6: avoid indirect call for icmpv6_send()")
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>  
> >
> > That's a little much ifdefinery, why not move the declaration from
> > under the ifdef in the header instead?  
> 
> We will find ourselves with exported but not used function, it will
> increase symbol file, not big deal but not nice, either.

For those all so common builds where IPv6 is a module :)
But I don't feel strongly, up to you.

> > If you repost please target net-next, admittedly these fixes are pretty
> > "obviously correct" but they are not urgent either.  
> 
> I'll do.

Thanks!
