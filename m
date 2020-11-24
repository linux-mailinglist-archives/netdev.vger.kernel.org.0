Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3972C2B23
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389280AbgKXPWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:22:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730757AbgKXPWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606231349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ChAGzIwucY8bxXwOeJCi+g4y29+3D7RAHEPEShB7UzE=;
        b=RXnRIt9DnwyZZja3722y/H98sbedY3nOvIUkvTWToRpeKK164gAGW9u5dRhmbJxlilHb4p
        NxzjAwMRxDnw+oj3NPdi30yMW4phKRLoVyxSVzfon+89piVw2qmyK7LGqXkje3L5iqoN6g
        6W9jrnlJ99E/87OexKvzL/myxLQfLsU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-fhtCutbLOGK678-_tCtNVA-1; Tue, 24 Nov 2020 10:22:27 -0500
X-MC-Unique: fhtCutbLOGK678-_tCtNVA-1
Received: by mail-wm1-f70.google.com with SMTP id k128so1340596wme.7
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 07:22:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ChAGzIwucY8bxXwOeJCi+g4y29+3D7RAHEPEShB7UzE=;
        b=XAyJZE5upSzcMfGxl5HUNh6dRxhYeIEI6vszZMgHh4ORr2Bdj6tzKl7w6ivItS/m4z
         NNOLGm+9nhgQgdlqfmJmOaSMqfxqAyTxAjIflxc+msz40EEkpnsBqiC9Qp7HoRGjr2cb
         F2AlM5FR1U3j2x+F4ccxkqGxeUEHcBqDUSoKMH0pSGCZJFj5KLM4Z5UTrssR4TOSGNId
         S4AG63Z8mYUUBAO4lhTqnRtQ4kfhcLQZ3/5trWphhocEZuRz8rfOlatwvrEPnkS726dZ
         v1SvFEeZIeFLNVlU0CWpIeYjcLyzsTCLzqlFiDfdBNuBnJGzq9DrjZ/Q6GTcsrusbVmS
         44cQ==
X-Gm-Message-State: AOAM532PB7foHEtBxxljHBsMuKWU3hR30kMWkohqSTiefQvyIK9HmKp6
        JojFCwMrBmudvtUSSDPCyWRrSw+3uievtCQzH4W6ANUE4HbHnBmkPXY3WuuE/Sz7Zrl0flwPkd4
        W3bJ9a0cFBFqtPSHC
X-Received: by 2002:a05:600c:2048:: with SMTP id p8mr5076972wmg.165.1606231345521;
        Tue, 24 Nov 2020 07:22:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLjMuLs03pFbeTYSspfYd5oqq8ImIVkcA8plASm2UM7XPda7IPVlBeduajR9CCi+8XiOF6cw==
X-Received: by 2002:a05:600c:2048:: with SMTP id p8mr5076955wmg.165.1606231345290;
        Tue, 24 Nov 2020 07:22:25 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b4sm6904403wmc.1.2020.11.24.07.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 07:22:24 -0800 (PST)
Date:   Tue, 24 Nov 2020 16:22:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Russell Strong <russell@strong.id.au>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing v2
Message-ID: <20201124152222.GB28947@linux.home>
References: <20201121182250.661bfee5@192-168-1-16.tpgi.com.au>
 <20201123225505.GA21345@linux.home>
 <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124124149.11fe991e@192-168-1-16.tpgi.com.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 12:41:49PM +1000, Russell Strong wrote:
> On Mon, 23 Nov 2020 23:55:05 +0100 Guillaume Nault <gnault@redhat.com> wrote:
> > On Sat, Nov 21, 2020 at 06:24:46PM +1000, Russell Strong wrote:
> 
> I was wondering if one patch would be acceptable, or should it be broken
> up?  If broken up. It would not make sense to apply 1/2 of them.

A patch series would be applied in its entirety or not applied at all.
However, it's not acceptable to temporarily bring regressions in one
patch and fix it later in the series. The tree has to remain
bisectable.

Anyway, I believe there's no need to replace all the TOS macros in the
same patch series. DSCP doesn't have to be enabled everywhere at once.
Small, targeted, patch series are much easier to review.

> > RT_TOS didn't clear the second lowest bit, while the new IP_DSCP does.
> > Therefore, there's no guarantee that such a blanket replacement isn't
> > going to change existing behaviours. Replacements have to be done
> > step by step and accompanied by an explanation of why they're safe.
> 
> Original TOS did not use this bit until it was added in RFC1349 as "lowcost".
> The DSCP change (RFC2474) marked these as currently unused, but worse than that,
> with the introduction of ECN, both of those now "unused" bits are for ECN.
> Other parts of the kernel are using those bits for ECN, so bit 1 probably
> shouldn't be used in routing anymore as congestion could create unexpected
> routing behaviour, i.e. fib_rules

The IETF meaning and history of these bits are well understood. But we
can't write patches based on assumptions like "bit 1 probably shouldn't
be used". The actual code is what matters. That's why, again, changes
have to be done incrementally and in a reviewable manner.

> > For example some of the ip6_make_flowinfo() calls can probably
> > erroneously mark some packets with ECT(0). Instead of masking the
> > problem in this patch, I think it'd be better to have an explicit fix
> > that'd mask the ECN bits in ip6_make_flowinfo() and drop the buggy
> > RT_TOS() in the callers.
> > 
> > Another example is inet_rtm_getroute(). It calls
> > ip_route_output_key_hash_rcu() without masking the tos field first.
> 
> Should rtm->tos be checked for validity in inet_rtm_valid_getroute_req? Seems
> like it was missed.

Well, I don't think so. inet_rtm_valid_getroute_req() is supposed to
return an error if a parameter is wrong. Verifying ->tos should have
been done since day 1, yes. However, in practice, we've been accepting
any value for years. That's the kind of user space behaviour that we
can't really change. The only solution I can see is to mask the ECN
bits silently. That way, users can still pass whatever they like (we
won't break any script), but the result will be right (that is,
consistent with what routing does).

> > Therefore it can return a different route than what the routing code
> > would actually use. Like for the ip6_make_flowinfo() case, it might
> > be better to stop relying on the callers to mask ECN bits and do that
> > in ip_route_output_key_hash_rcu() instead.
> 
> In this context one of the ECN bits is not an ECN bit, as can be seen by
> 
> #define RT_FL_TOS(oldflp4) \
>         ((oldflp4)->flowi4_tos & (IP_DSCP_MASK | RTO_ONLINK))

The RTO_ONLINK flag would have to be passed in a different way. Not a
trivial task (many places to audit), but that looks feasible.

> It's all a bit messy and spread about.  Reducing the distributed nature of
> the masking would be good.

Yes, that's why I'd like to stop sprinkling RT_TOS everywhere and mask
the bits in central places when possible. Once the RT_TOS situation
improves, adding DSCP support will be much easier.

> > I'll verify that these two problems can actually happen in practice
> > and will send patches if necessary.
> 
> Thanks
> 

