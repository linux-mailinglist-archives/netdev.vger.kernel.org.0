Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D712BFD8F
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 05:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfI0DPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 23:15:05 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40675 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfI0DPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 23:15:05 -0400
Received: by mail-io1-f67.google.com with SMTP id h144so12463242iof.7;
        Thu, 26 Sep 2019 20:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dYunEev9Iy1DaEmo3jRoKgQjMkv8t3yrqqb66M4OYzE=;
        b=FKkkpEkTSd89T3J4/jyBX2tUS7bdH+2HuC32GpWJluWqJyzzpHph9NYB1jXs+qf+s4
         9SIKpb2p7CwfODB525SvASy5nHQAMsm0Afzl2kc+FXcaDDoyuc078bhmdRDMcdTPgcrm
         XTZ7L1O2NDu+IZ3K1FRVlZgQkcOrMMkpQn1vyOwJFMmNmW+tz+uVKa+++S24KE+OctD4
         WEFOo+DEiENrm2xQLIfpS0hwUTQ5jNTsL77R8ZIafAYFvwW8/Y/Z4KGFAFHYP0K097Mu
         jqaj3+VHTa+KDYHnGJKHyHI5g4OgHITiq3RI2oAjHClST5B3sGFmhcC4eOkw7XgJoyRQ
         0ohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dYunEev9Iy1DaEmo3jRoKgQjMkv8t3yrqqb66M4OYzE=;
        b=PBYWcBq8KPyCc3Qg0q1S7JNUFYtYHCgWQeiWZpj7l/HwldcuTXGfp9eRuNevZ9UNEf
         gxJQeEdnOJt+njleips73ciehFhvTUz2Ah23s3B1S4GW7wjkS+SGkULQf1MZ7X7iBfom
         blcgAT0i9t9/lalxzYaHaFn7RjVs0xwusC7PpGS12WA/flHCoQE0ie5pIds/V5aP0v/D
         nkjo4dg2nnuLdqv62evxSC2oojFxs13LD+xqYJe2Aybgrlc7tLtPZ7AaYWMdRX23Qfzo
         zpDdJp2cdE+UDCJ4Gc7MRUbSIZu4EPEOS64ZrZpkYhIQeQgp843xG8KlnmmQFNi/2CV0
         Fjtg==
X-Gm-Message-State: APjAAAUsUhVsAVO68cRryZA530yjinw+XdWXcnYAh9EVr7PCKe5t+UG6
        Odc2WFY6Zl6I3J/211+faTQ=
X-Google-Smtp-Source: APXvYqxEC0AYk3N0Amn/nwpDQflGg2+dHmOpRIpruCHoI1XoJpHwJgErQaixpmXKCi93rLnLKc9MuA==
X-Received: by 2002:a6b:fb19:: with SMTP id h25mr6667733iog.288.1569554103920;
        Thu, 26 Sep 2019 20:15:03 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.gmail.com with ESMTPSA id d6sm555156ilc.39.2019.09.26.20.15.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 26 Sep 2019 20:15:03 -0700 (PDT)
Date:   Thu, 26 Sep 2019 22:15:01 -0500
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ncsi: prevent memory leak in ncsi_rsp_handler_gc
Message-ID: <20190927031501.GF22969@cs-dulles.cs.umn.edu>
References: <20190925215854.14284-1-navid.emamdoost@gmail.com>
 <20190925230938.GQ26530@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925230938.GQ26530@ZenIV.linux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 12:09:38AM +0100, Al Viro wrote:
> On Wed, Sep 25, 2019 at 04:58:53PM -0500, Navid Emamdoost wrote:
> > In ncsi_rsp_handler_gc if allocation for nc->vlan_filter.vids fails the
> > allocated memory for nc->mac_filter.addrs should be released.
> > 
> > Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> > ---
> >  net/ncsi/ncsi-rsp.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> > index d5611f04926d..f3f7c3772994 100644
> > --- a/net/ncsi/ncsi-rsp.c
> > +++ b/net/ncsi/ncsi-rsp.c
> > @@ -800,8 +800,10 @@ static int ncsi_rsp_handler_gc(struct ncsi_request *nr)
> >  	nc->vlan_filter.vids = kcalloc(rsp->vlan_cnt,
> >  				       sizeof(*nc->vlan_filter.vids),
> >  				       GFP_ATOMIC);
> > -	if (!nc->vlan_filter.vids)
> > +	if (!nc->vlan_filter.vids) {
> > +		kfree(nc->mac_filter.addrs);
> >  		return -ENOMEM;
> > +	}
> 
> Again, why is it not a double-free?  IOW, what guarantees that we won't
> be calling <greps> ncsi_remove_channel(nc) at later point?
> 
> I'm not familiar with that code, so you _might_ be correct in this case,
> but you need a lot more analysis in commit message than "should be",
> considering the other similar patches from the same source, with the
> same level of details in them that had been provably broken.
> 
> I don't know what kind of heuristics you are using when looking for
> leaks, but they demonstrably give quite a few false positives.
> 
> It might be useful (and not just for you) to discuss those heuristics.
> Could you go over the patch series you've posted and follow them up
> with "here I've decided that we have a leak for such and such reason".
> _Including_ the ones where you've ended up with false positives.
> 
> Look at it this way: you've posted a lot of statements without any
> proofs of their correctness *or* any way to guess what those missing
> proofs might've been.  At least some of them are false.  I can try
> to prove them from scratch and post such proofs where the statement
> happens to be true and counterexamples where it happens to be false.
> However, it would've been much more useful to go through what you've
> actually done to arrive to those statements, so that mistakes
> would not be repeated in new problems.  And those mistakes are very
> unlikely to be yours alone, so other people would benefit as well.

Hi Al, thanks for elaborating. 
Here and in some other places when I see an error happening (i.e an errno
is returned here) then the previous allocations need to be release
somehow. The problem is that just by traversing the code using tools
like ctags or elixir I couldn't find any caller to ncsi_rsp_handler_gc
that handles such errnos. By your comment I found that
ncsi_remove_channel can be invoked to remove a channel, but again I
cannot find a clear call path including ncsi_rsp_handler_gc and then
ncsi_remove_channel or any thing like ncsi_unregister_dev (which I can
see is calling ncsi_remove_channel in ncsi-manage.c)
So it would be beneficial if we could somehow handle such cases
where we encounter function pointers on the way of constructing call
graph.

