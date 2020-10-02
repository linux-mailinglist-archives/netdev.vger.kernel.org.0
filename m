Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E03A2815DC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgJBOzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgJBOzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:55:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75D7020665;
        Fri,  2 Oct 2020 14:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601650540;
        bh=jnHBNRbkIfW9TUxwiCuyKW0hoW4fw6GoUO15PR99J90=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zDg3pfMvBoyz2K8Sy9r5hPtbf5j29Zn1TxmEVSguJVaptYHV5V9s62ND0YvphHyoZ
         MfBR0P5h6E0qXXNW3Pd7Zq9Av3EmbIE1muAe/Ewdar0hhJ4lWxh8QrakVgrrwJJgn1
         xhUXK4Jk+ZHrWoR35IsM4Z5cPqOHR4E3i+HNBLqU=
Date:   Fri, 2 Oct 2020 07:55:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <20201001173644.74ed67da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
        <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 16:42:09 +0200 Johannes Berg wrote:
> On Fri, 2020-10-02 at 07:40 -0700, Jakub Kicinski wrote:
> 
> > > I suppose you could make an argument that only some attrs might be
> > > accepted in doit and somewhat others in dumpit, or perhaps none in
> > > dumpit because filtering wasn't implemented?  
> > 
> > Right? Feels like it goes against our strict validation policy to
> > ignore input on dumpit.
> >   
> > > But still ... often we treat filtering as "advisory" anyway (except
> > > perhaps where there's no doit at all, like the dump_policy thing here),
> > > so it wouldn't matter if some attribute is ending up ignored?  
> > 
> > It may be useful for feature discovery to know if an attribute is
> > supported.  
> 
> Fair point.
> 
> > I don't think it matters for any user right now, but maybe we should
> > require user space to specify if they are interested in normal req
> > policy or dump policy? That'd give us the ability to report different
> > ones in the future when the need arises.  
> 
> Or just give them both? I mean, in many (most?) cases they're anyway
> going to be the same, so with the patches I posted you could just give
> them the two different policy indexes, and they can be the same?

Ah, I missed your posting! Like this?

[OP_POLICY]
   [OP]
      [DO]   -> u32
      [DUMP] -> u32

> But whichever, doesn't really matter much.

