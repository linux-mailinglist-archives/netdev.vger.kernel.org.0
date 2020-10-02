Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8892815FC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388222AbgJBPDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 11:03:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F6A3206CA;
        Fri,  2 Oct 2020 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601650989;
        bh=X7Z3+MIObLFHv++1os+W4+cR5Bs43xV46/zSl6jTvCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BmFJD3fzSdCyEdmbZFKVPtpU4H4ZSI4vWooJxbybPwTdVebACniKzb/YInc++mOot
         TnXQNtRgyy+AzK/WppuTIFRH8ZEvKZjzS2tL/k2ntkOw+4r5ekRdqdYuT+DAqsXPvk
         KTr2HhEcahBo1nkIVWczYp1JMAqxd72Tv1pWyhSE=
Date:   Fri, 2 Oct 2020 08:03:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
        <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
        <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 16:58:33 +0200 Johannes Berg wrote:
> > > Or just give them both? I mean, in many (most?) cases they're anyway
> > > going to be the same, so with the patches I posted you could just give
> > > them the two different policy indexes, and they can be the same?  
> > 
> > Ah, I missed your posting!  
> 
> Huh, I even CC'ed you I think?

I filter stuff which is to:netdev cc:me and get to it when I read the
ML. There's too much of it.

> https://lore.kernel.org/netdev/20201002090944.195891-1-johannes@sipsolutions.net/t/#u
> 
> and userspace:
> 
> https://lore.kernel.org/netdev/20201002102609.224150-1-johannes@sipsolutions.net/t/#u
> 
> >  Like this?
> > 
> > [OP_POLICY]
> >    [OP]
> >       [DO]   -> u32
> >       [DUMP] -> u32  
> 
> Yeah, that'd work. I'd probably wonder if we shouldn't do
> 
> [OP_POLICY]
>   [OP] -> (u32, u32)
> 
> in a struct with two u32's, since that's quite a bit more compact.

What do we do if the op doesn't have a dump or do callback?
0 is a valid policy ID, sadly :(
