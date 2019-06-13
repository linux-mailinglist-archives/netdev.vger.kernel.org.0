Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12F7144D1D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbfFMUMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:12:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35859 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfFMUMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:12:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id p15so4719939qtl.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 13:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ewl1pAu77WqzayHBwTc3fg2lD4g6b51JAfuJwo1MgDs=;
        b=ppXnau+CONN4uB6b+39KgdWj0qNVDwTDJZgLgBpE1H4z/YzhJdPOV4qJI1yEyWGaBW
         P9LREkWqLwDuomonZUy4hVUApj1WeKiQ9BQqUf4gAhyQf4NijAYooP202v9r6BGTdB+3
         nrGMNG0Pce+b5zSWsXnrS8CM250t0+Z3IqB8yk14mLU+gmN9MrjFjJygfIsKJxVACe8Y
         GVNHMjPgeLRwp61P+K0qZIVgQMbgK5UOR791aBwvXLPT8hp5vD37ppOwTWFLlI6rWSW1
         OKRN+oBxresZGPx1bJpelpiPHDniRPygBZNecGmSXWonYfVtu8zrzWacJpMjx+BhCsJ8
         VUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ewl1pAu77WqzayHBwTc3fg2lD4g6b51JAfuJwo1MgDs=;
        b=aQ/eobAMzbdL+B/9zkO6Yic9/OO/tssej0Z/s3AtH8PNZyONbqvVqLYrzI0X8NdJ88
         1pzMSRuKy6+e27dNSrhzTvg/hQKjIlgT7OZg7vh5Xp12CD5njLH1I7NXtAZOPQz6MD/c
         IV/zkcxyur0vEDesW78ZbsIxUE4WXSPW6MtAKBX5UScTTII/i92GuAVDDlQnYFwSLLDI
         MDja92lr7TLaj1X1W1Vct84ssrzkLyoEhMsh5SOKuJy6Ihtixao61aADIkpe6Bd4wy6T
         W3Es4vFCH2IT0LGVPRvDSf4UwWyQji4OPrKW7J+yt/RaNBUDR+kEAmN2RiqfnAE0MV63
         3pNQ==
X-Gm-Message-State: APjAAAUsqg/lqraFOvTNkCSRFpHlc8kfcAJNFsfJ5dXu7BUNAbSo82Rm
        dbARWbL+vKpu8XKl4Wu1CBQ=
X-Google-Smtp-Source: APXvYqwPy7x0rARV+Xd+rL90kFOAkOf+U2ool1FRvgOg3n0QqQz7T+clKaczlhrzA7vt9nKY2S9Atg==
X-Received: by 2002:a0c:8aaa:: with SMTP id 39mr5106739qvv.17.1560456765215;
        Thu, 13 Jun 2019 13:12:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:278e:68eb:7f4f:8f57:4b3a])
        by smtp.gmail.com with ESMTPSA id p64sm384468qkf.60.2019.06.13.13.12.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 13:12:44 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 20E43C1BC6; Thu, 13 Jun 2019 17:12:42 -0300 (-03)
Date:   Thu, 13 Jun 2019 17:12:42 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190613201242.GI3436@localhost.localdomain>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
 <20190612180239.GA3499@localhost.localdomain>
 <20190612114627.4dd137ab@cakuba.netronome.com>
 <60a0183a1f8508d0132feb7790baac86dd70fe52.camel@sipsolutions.net>
 <20190612191859.GJ31797@unicorn.suse.cz>
 <20190612143458.0b6fe526@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612143458.0b6fe526@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 02:34:58PM -0700, Jakub Kicinski wrote:
> On Wed, 12 Jun 2019 21:18:59 +0200, Michal Kubecek wrote:
> > On Wed, Jun 12, 2019 at 08:56:10PM +0200, Johannes Berg wrote:
> > > (switching to my personal email)
> > >   
> > > > > I can't add these actions with current net-next and iproute-next:
> > > > > # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
> > > > > Error: NLA_F_NESTED is missing.
> > > > > We have an error talking to the kernel
> > > > > 
> > > > > This also happens with the current post of act_ct and should also
> > > > > happen with the act_mpls post (thus why Cc'ing John as well).
> > > > > 
> > > > > I'm not sure how we should fix this. In theory the kernel can't get
> > > > > stricter with userspace here, as that breaks user applications as
> > > > > above, so older actions can't use the more stricter parser. Should we
> > > > > have some actions behaving one way, and newer ones in a different way?
> > > > > That seems bad.  
> > > 
> > > I think you could just fix all of the actions in userspace, since the
> > > older kernel would allow both with and without the flag, and then from a
> > > userspace POV it all behaves the same, just the kernel accepts some
> > > things without the flag for compatibility with older iproute2?
> > >   
> > > > > Or maybe all actions should just use nla_parse_nested_deprecated()?
> > > > > I'm thinking this last. Yet, then the _deprecated suffix may not make
> > > > > much sense here. WDYT?  
> > > > 
> > > > Surely for new actions we can require strict validation, there is
> > > > no existing user space to speak of..    
> > > 
> > > That was the original idea.
> > >   
> > > > Perhaps act_ctinfo and act_ct
> > > > got slightly confused with the race you described, but in principle
> > > > there is nothing stopping new actions from implementing the user space
> > > > correctly, right?  
> > > 
> > > There's one potential thing where you have a new command in netlink
> > > (which thus will use strict validation), but you use existing code in
> > > userspace to build the netlink message or parts thereof?
> > > 
> > > But then again you can just fix that while you test it, and the current
> > > and older kernel will accept the stricter version for the existing use
> > > of the existing code too, right?  
> > 
> > Userspace can safely set NLA_F_NESTED on every nested attribute as there
> > are only few places in kernel where nla->type is accessed directly
> > rather than through nla_type() and those are rather specific (mostly
> > when attribute type is actually used as an array index). So the best
> > course of action would be letting userspace always set NLA_F_NESTED.
> > So kernel can only by strict on newly added attributes but userspace can
> > (and should) set NLA_F_NESTED always.
> > 
> > The opposite direction (kernel -> userspace) is more tricky as we can
> > never be sure there isn't some userspace client accessing the type directly
> > without masking out the flags. Thus kernel can only set NLA_F_NESTED on
> > new attributes where there cannot be any userspace program used to it
> > not being set.
> 
> Agreed, so it's just the slight inconsistency in the dumps, which I'd
> think is a fair price to pay here.  Old user space won't recognize the
> new attributes, anyway, so doesn't matter what flags they have..

Thanks for your inputs. In summary, being able to do extra validations
for new actions is worth the inconsitency then.

  Marcelo
