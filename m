Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117B44494C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfFMRQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:16:27 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39358 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbfFLVfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 17:35:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id i125so11379451qkd.6
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 14:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MUnq9jOM8dJLTQDR9/mOwq6nBMrQE23d1OvsNuItDrs=;
        b=H+yAVU362tVFFxFjSdDC4DxsRCnxepuDes4EIZarJs9jlB+4ithe3emLY1+E2Qmd87
         BMB0Mb+SJHUy7XrB3YRCFFX+/OTMHbAOe8ZweQuYn3QFeYkFDAGIi3d8JMhn8KR8peZA
         DLI4XPIC2LII1MoHZJwD7/Su8X57vxNKEG1Eb34aXVlEpM0sWLgX+N8uxJrDfrCE9KBv
         g1CdpjpyUTVs1twexDPiFS3WEpQnPXXkV/JuPb52ZZ5j02gjz/ld+PJlLOY2+D8nrl9j
         8Jvxkil6cX9rYvDx6x7diy5xfigjeBffc/o1F2IHUUyFcU5NXFIxC2wgZQSHicnAdvNQ
         wLXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MUnq9jOM8dJLTQDR9/mOwq6nBMrQE23d1OvsNuItDrs=;
        b=HLA0myRTUaDVQUif27Cfi8XV1Xm7Vk+gbv9xf1WCkDFkPud4FLAIAUzo9FowPhTk+U
         3kYDLkWEnJ7QV/HQzaB3foH2TflSpB8R7ybBeO4ZUGmjG8FensKhe/1AcgjivJZ/cSea
         SCfQLx4ycyQVcd/sRG35olkaIYYkyjq+q0MkGL5iukcaGGnj3+TQs2z5T+E63iHPwYyF
         ANLWZIxF+gbm+AZVDS+ftabayTlgojTvFFkzBnk8/MpyPhj6otw9dNeVlm+xTb6hj6xE
         ctxLnnESqrX8Q0qD89My03/YgHHtoPbZZzSSgmNsD5d0jPQ+FkyQC05TWC2UZExywYQh
         4HPg==
X-Gm-Message-State: APjAAAViIkTKAx4AL9xeZAZSmZCk8Hh4uZQZkCcnXN4q5qnXcqQtcTW3
        1Ilospm/UmMJLyeeP+QCvR5zTA==
X-Google-Smtp-Source: APXvYqyVTLp3lAEPAshUKIOhni0tjb8rZf1OdSuWgrQEKu9iXHdx6JLi6NxdV5PfBFqV9RDgIXfUNg==
X-Received: by 2002:a37:e10e:: with SMTP id c14mr50012315qkm.54.1560375304289;
        Wed, 12 Jun 2019 14:35:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f25sm598097qta.81.2019.06.12.14.35.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 14:35:04 -0700 (PDT)
Date:   Wed, 12 Jun 2019 14:34:58 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190612143458.0b6fe526@cakuba.netronome.com>
In-Reply-To: <20190612191859.GJ31797@unicorn.suse.cz>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
        <20190612180239.GA3499@localhost.localdomain>
        <20190612114627.4dd137ab@cakuba.netronome.com>
        <60a0183a1f8508d0132feb7790baac86dd70fe52.camel@sipsolutions.net>
        <20190612191859.GJ31797@unicorn.suse.cz>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jun 2019 21:18:59 +0200, Michal Kubecek wrote:
> On Wed, Jun 12, 2019 at 08:56:10PM +0200, Johannes Berg wrote:
> > (switching to my personal email)
> >   
> > > > I can't add these actions with current net-next and iproute-next:
> > > > # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> > > > Error: NLA_F_NESTED is missing.
> > > > We have an error talking to the kernel
> > > > 
> > > > This also happens with the current post of act_ct and should also
> > > > happen with the act_mpls post (thus why Cc'ing John as well).
> > > > 
> > > > I'm not sure how we should fix this. In theory the kernel can't get
> > > > stricter with userspace here, as that breaks user applications as
> > > > above, so older actions can't use the more stricter parser. Should we
> > > > have some actions behaving one way, and newer ones in a different way?
> > > > That seems bad.  
> > 
> > I think you could just fix all of the actions in userspace, since the
> > older kernel would allow both with and without the flag, and then from a
> > userspace POV it all behaves the same, just the kernel accepts some
> > things without the flag for compatibility with older iproute2?
> >   
> > > > Or maybe all actions should just use nla_parse_nested_deprecated()?
> > > > I'm thinking this last. Yet, then the _deprecated suffix may not make
> > > > much sense here. WDYT?  
> > > 
> > > Surely for new actions we can require strict validation, there is
> > > no existing user space to speak of..    
> > 
> > That was the original idea.
> >   
> > > Perhaps act_ctinfo and act_ct
> > > got slightly confused with the race you described, but in principle
> > > there is nothing stopping new actions from implementing the user space
> > > correctly, right?  
> > 
> > There's one potential thing where you have a new command in netlink
> > (which thus will use strict validation), but you use existing code in
> > userspace to build the netlink message or parts thereof?
> > 
> > But then again you can just fix that while you test it, and the current
> > and older kernel will accept the stricter version for the existing use
> > of the existing code too, right?  
> 
> Userspace can safely set NLA_F_NESTED on every nested attribute as there
> are only few places in kernel where nla->type is accessed directly
> rather than through nla_type() and those are rather specific (mostly
> when attribute type is actually used as an array index). So the best
> course of action would be letting userspace always set NLA_F_NESTED.
> So kernel can only by strict on newly added attributes but userspace can
> (and should) set NLA_F_NESTED always.
> 
> The opposite direction (kernel -> userspace) is more tricky as we can
> never be sure there isn't some userspace client accessing the type directly
> without masking out the flags. Thus kernel can only set NLA_F_NESTED on
> new attributes where there cannot be any userspace program used to it
> not being set.

Agreed, so it's just the slight inconsistency in the dumps, which I'd
think is a fair price to pay here.  Old user space won't recognize the
new attributes, anyway, so doesn't matter what flags they have..
