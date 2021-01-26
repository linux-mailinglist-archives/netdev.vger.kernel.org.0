Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421023048E4
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbhAZFh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbhAZCeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 21:34:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D82A622B37;
        Tue, 26 Jan 2021 02:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611628401;
        bh=4ajdCImO6fw2kJ8zy315owSVLJtWw0Ta2IZ7DSbr9wQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gqXiV+Hv0ke4PHl3hhSq5hcW42UDT19C43qo7wvy8/NBx0HTIHXh78t2lix0GHPiW
         dVQtFeJGqsEtGN5RLJF5HZSw25wXdS5Ovqrr7Ho1FD5vwtVdnxzXHUTditKXr7i0zQ
         rzTWPDAKczvGknLnNVABd4CsFlLg9O7OF6yADbkQDG1MsqNBt9VJGQb9KJxv5fLK3Q
         GPE0NXixrNQ+g3adPkrPoXF8f9nPKNYtUu0VRARCSG3f3/xgU4r7ckwqr7O+Bkjwu4
         FN0KGGTVklkppydsLy8IvyMQ6Gqb44Zie4844WHJYI/QCIUWblgAd1ANDBwvO5xfgn
         7mb9ecqKS2cJw==
Date:   Mon, 25 Jan 2021 18:33:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     <roopa@nvidia.com>, <davem@davemloft.net>,
        <natechancellor@gmail.com>, <ndesaulniers@google.com>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] bridge: Use PTR_ERR_OR_ZERO instead if(IS_ERR(...)) +
 PTR_ERR
Message-ID: <20210125183320.161f0afb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4c68f49c-a537-3f8f-73ed-5f243cb142a9@nvidia.com>
References: <1611542381-91178-1-git-send-email-abaci-bugfix@linux.alibaba.com>
        <4c68f49c-a537-3f8f-73ed-5f243cb142a9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 10:23:00 +0200 Nikolay Aleksandrov wrote:
> On 25/01/2021 04:39, Jiapeng Zhong wrote:
> > coccicheck suggested using PTR_ERR_OR_ZERO() and looking at the code.
> > 
> > Fix the following coccicheck warnings:
> > 
> > ./net/bridge/br_multicast.c:1295:7-13: WARNING: PTR_ERR_OR_ZERO can be
> > used.
> > 
> > Reported-by: Abaci <abaci@linux.alibaba.com>
> > Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
> > ---
> >  net/bridge/br_multicast.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > index 257ac4e..2229d10 100644
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -1292,7 +1292,7 @@ static int br_multicast_add_group(struct net_bridge *br,
> >  	pg = __br_multicast_add_group(br, port, group, src, filter_mode,
> >  				      igmpv2_mldv1, false);
> >  	/* NULL is considered valid for host joined groups */
> > -	err = IS_ERR(pg) ? PTR_ERR(pg) : 0;
> > +	err = PTR_ERR_OR_ZERO(pg);
> >  	spin_unlock(&br->multicast_lock);
> >  
> >  	return err;
> >   
> 
> This should be targeted at net-next.
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Applied, thanks!
