Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84F229CC
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 04:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfETCA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 22:00:28 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40011 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfETCA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 22:00:28 -0400
Received: by mail-pl1-f193.google.com with SMTP id g69so5935046plb.7;
        Sun, 19 May 2019 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=szNHxG8meqm9etTBVqy2eCrpsCzhCZREkY37myKt80c=;
        b=eaLcUgnXbgIvmnq47LUhcV9OwlPzBl3XBB+DlelTQLrzU9J2HUNlEDtEYAIxcsHK2C
         3PuEP0Pz60lQ9TT38cIkYupC9iozwP5FjXbMSoEEYRi+APurkuKHg3N3QTM4vMHRUWeu
         Htjtc0Ez7Ncbn+8WE5qEw0DKciLm9hLyZnFIZMLSXgu+C+CcaQ9TtOMFGm/VJHXqwAEe
         ivXCo1m6EX59TMn24QPWiD+eJ43ipiLGNHhURZdcU4QOtucwQQavJoS13QEGWSe33RFo
         nhBwchrGgn0Afs3sTsgiJ+G6ObQYIEFFYM2HuzUBq7iMxueKgylzIOapgeyQg38xNbOt
         3Snw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=szNHxG8meqm9etTBVqy2eCrpsCzhCZREkY37myKt80c=;
        b=eGyXG8bU6b6N3AVlN6JKl6zZ9VLUPVz9OMKg1v2dfqAjuRQ0rIVLtjdqoAj3YYupwo
         ap0VyTHa+i9Yjh+0OAVBBS+2q2ZKYFk7vgodwOYrYJ6Q+H2XMuVpHWu1A5FcVF0/8O5E
         Z/ZKS/agW/W9a86FBImv7G84LdMnmDQ0DS8Mao9PA/+cdWTkd+eQ+2CzQldMzavgxrlj
         444pRDKLBJvQonNuVLz/tmT41j7CunPcWiHSYs20TmuXyfFNjqrwMMFfnDBnBPhZ4hat
         /mqO4zHWaNcwmNE/KwSWmVyAGVq/7cUs/bF7ft5mSwA3SCqXHHS7fJndvT10/ohhmM/h
         Vz4w==
X-Gm-Message-State: APjAAAVGNKFG6QlRaC3SJj+JKr/sLs6qePUZev9Wd4s9RFd8ole+mqJH
        3xqwkh6TnwPVrdvEa+DKTDg=
X-Google-Smtp-Source: APXvYqybcv39OBAsitwlWlgiNXxZ0xtqorujhjy1k3bkomTh4rbMJ73GBX1J7FSkwaBG4LFU5OJrIQ==
X-Received: by 2002:a17:902:e9:: with SMTP id a96mr46448758pla.37.1558317627612;
        Sun, 19 May 2019 19:00:27 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r18sm36509937pfg.141.2019.05.19.19.00.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 19:00:26 -0700 (PDT)
Date:   Mon, 20 May 2019 10:00:16 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied
Message-ID: <20190520020016.GU18865@dhcp-12-139.nay.redhat.com>
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
 <20190519154348.GA113991@archlinux-epyc>
 <20190519202753.p5hsfe2uqmgsfbcq@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519202753.p5hsfe2uqmgsfbcq@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 19, 2019 at 10:27:53PM +0200, Florian Westphal wrote:
> Nathan Chancellor <natechancellor@gmail.com> wrote:
> > On Wed, May 15, 2019 at 12:56:16PM +0200, Greg Kroah-Hartman wrote:
> > > From: Hangbin Liu <liuhangbin@gmail.com>
> > > 
> > > [ Upstream commit e9919a24d3022f72bcadc407e73a6ef17093a849 ]
> 
> [..]
> 
> > > Fixes: 153380ec4b9 ("fib_rules: Added NLM_F_EXCL support to fib_nl_newrule")
> > > Reported-by: Thomas Haller <thaller@redhat.com>
> > > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  net/core/fib_rules.c |    6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > --- a/net/core/fib_rules.c
> > > +++ b/net/core/fib_rules.c
> > > @@ -429,9 +429,9 @@ int fib_nl_newrule(struct sk_buff *skb,
> > >  	if (rule->l3mdev && rule->table)
> > >  		goto errout_free;
> > >  
> > > -	if ((nlh->nlmsg_flags & NLM_F_EXCL) &&
> > > -	    rule_exists(ops, frh, tb, rule)) {
> > > -		err = -EEXIST;
> > > +	if (rule_exists(ops, frh, tb, rule)) {
> > > +		if (nlh->nlmsg_flags & NLM_F_EXCL)
> > > +			err = -EEXIST;
> > This commit is causing issues on Android devices when Wi-Fi and mobile
> > data are both enabled. The device will do a soft reboot consistently.
> 
> Not surprising, the patch can't be applied to 4.9 as-is.
> 
> In 4.9, code looks like this:
> 
>  err = -EINVAL;
>  /* irrelevant */
>  if (rule_exists(ops, frh, tb, rule)) {
>   if (nlh->nlmsg_flags & NLM_F_EXCL)
>     err = -EEXIST;
>     goto errout_free;
>  }
> 
> So, if rule_exists() is true, we return -EINVAL to caller
> instead of 0, unlike upstream.
> 
> I don't think this commit is stable material.

Thanks Florian for helping check it. So we need either revert this patch,
or at least backport adeb45cbb505 ("fib_rules: fix error return code") and
f9d4b0c1e969 ("fib_rules: move common handling of newrule delrule
msgs into fib_nl2rule").

For me, I agree to revert this patch from stable tree as it's a small fix. The
issue has been there for a long time and I didn't see much complain from
customer.

Thanks
Hangbin

