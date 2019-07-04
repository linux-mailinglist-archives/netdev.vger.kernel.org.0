Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0382B5FD8F
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfGDTzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:55:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51081 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727091AbfGDTzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:55:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id B66F02177A;
        Thu,  4 Jul 2019 15:55:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Jul 2019 15:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=sR6FK6
        wqiBzNtxlzGk6SfV4KUNKuNzdHTlJq97KtCs4=; b=oN/590eeF0el74q/TTobzu
        CI7Pj/f1EanfRWuj4OjG/ujBMRUpkTcmqzI7REhQHvPK9Io1uTwOW2jhFIm0x1kr
        VBO8D+0tm1gD+/IUo3Ci3knM4YgyBi41GxGSUO9tv4lJPQFsmoumqqrJXHMvUF2H
        3QuhvF9cYtWP7ws3Axn7ccbx2k8DjEXsJXSndk8ErccadYUsbrBG6on8N80eVdlF
        C6MZorI3BtcMUygtuqvBj2IpMGO1T8FwIto9Iq5199bdToI4fLVuM+M6Sx97a0kM
        u7o84H4KsHua5OEt6dKIIixg+/ZwsrVYc2fjtO4akpwpCjO2bclLh+P6YvY+8TAQ
        ==
X-ME-Sender: <xms:nFkeXQimoWqRCvxwerUFmUQ4Ef8roWm41bRGJ7vDo7AE5AgYjn5BXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfedvgddugeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecukfhppedutd
    elrdeihedrieefrddutddunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nFkeXe29gSXIiXUy-3YWmGWt7SClDZ4gmE0ED8G15P_e9kLPGg0Gwg>
    <xmx:nFkeXdLecSd7yEWNG0gsXyBHntAZRpdxAIZoD2-BnxJ1NPJvA7S3ZQ>
    <xmx:nFkeXQSS4cz-7-Z9RH5ZuFCrrbT3T5pZSHhC6AsPi7Gl67n2_lNVjg>
    <xmx:nFkeXUMAp1Gi6XIojis0kvcKTJly0n46QkaRLqMQePlvapwMmGYtYg>
Received: from localhost (bzq-109-65-63-101.red.bezeqint.net [109.65.63.101])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E35C380074;
        Thu,  4 Jul 2019 15:55:07 -0400 (EDT)
Date:   Thu, 4 Jul 2019 22:55:04 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] ipv4: Fix NULL pointer dereference in
 ipv4_neigh_lookup()
Message-ID: <20190704195504.GA20705@splinter>
References: <20190704162638.17913-1-idosch@idosch.org>
 <20190704.122449.742393341056317443.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704.122449.742393341056317443.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 12:24:49PM -0700, David Miller wrote:
> From: Ido Schimmel <idosch@idosch.org>
> Date: Thu,  4 Jul 2019 19:26:38 +0300
> 
> > Both ip_neigh_gw4() and ip_neigh_gw6() can return either a valid pointer
> > or an error pointer, but the code currently checks that the pointer is
> > not NULL.
>  ...
> > @@ -447,7 +447,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
> >  		n = ip_neigh_gw4(dev, pkey);
> >  	}
> >  
> > -	if (n && !refcount_inc_not_zero(&n->refcnt))
> > +	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
> >  		n = NULL;
> >  
> >  	rcu_read_unlock_bh();
> 
> Don't the callers expect only non-error pointers?

It is actually OK to return an error pointer here. In fact, before the
commit I cited the function returned the return value of neigh_create().

If you think it's clearer, we can do this instead:

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 8ea0735a6754..40697fcd2889 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -447,6 +447,9 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
                n = ip_neigh_gw4(dev, pkey);
        }
 
+       if (IS_ERR(n))
+               n = NULL;
+
        if (n && !refcount_inc_not_zero(&n->refcnt))
                n = NULL;
