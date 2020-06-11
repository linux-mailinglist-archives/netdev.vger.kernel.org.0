Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3551F7047
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgFKWdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:33:51 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:43012 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726270AbgFKWdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 18:33:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id D65CC18029123;
        Thu, 11 Jun 2020 22:33:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:7514:7875:7903:8526:9040:10004:10400:10848:11026:11232:11473:11658:11914:12296:12297:12740:12760:12895:13095:13141:13142:13161:13229:13230:13439:14096:14097:14180:14181:14659:14721:21060:21080:21324:21433:21627:21740:21795:21972:21990:30012:30034:30051:30054:30070:30083:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: cakes14_3209fc126dd7
X-Filterd-Recvd-Size: 4066
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu, 11 Jun 2020 22:33:46 +0000 (UTC)
Message-ID: <3518483f1836bdfbc193292dc1639509ac33fe7c.camel@perches.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
From:   Joe Perches <joe@perches.com>
To:     Jason Baron <jbaron@akamai.com>, jim.cromie@gmail.com,
        Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 11 Jun 2020 15:33:45 -0700
In-Reply-To: <e65d2c81-6d0b-3c1e-582c-56d707c0d1f1@akamai.com>
References: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
         <20200609111414.GC780233@kroah.com>
         <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
         <20200610133717.GB1906670@kroah.com>
         <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
         <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
         <20200611062648.GA2529349@kroah.com>
         <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
         <20200611105217.73xwkd2yczqotkyo@holly.lan>
         <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
         <20200611121817.narzkqf5x7cvl6hp@holly.lan>
         <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
         <e65d2c81-6d0b-3c1e-582c-56d707c0d1f1@akamai.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-06-11 at 17:59 -0400, Jason Baron wrote:
> 
> On 6/11/20 5:19 PM, jim.cromie@gmail.com wrote:
> > trimmed..
> > 
> > > > > Currently I think there not enough "levels" to map something like
> > > > > drm.debug to the new dyn dbg feature. I don't think it is intrinsic
> > > > > but I couldn't find the bit of the code where the 5-bit level in struct
> > > > > _ddebug is converted from a mask to a bit number and vice-versa.
> > > > 
> > > > Here [1] is Joe's initial suggestion. But I decided that bitmask is a
> > > > good start for the discussion.
> > > > 
> > > > I guess we can add new member uint "level" in struct _ddebug so that we
> > > > can cover more "levels" (types, groups).
> > > 
> > > I don't think it is allocating only 5 bits that is the problem!

There were 6 unused bits in struct _ddebug;

The original idea was to avoid expanding the already somewhat
large struct _ddebug uses and the __verbose/__dyndbg section
that can have quite a lot of these structs.

I imagine adding another int or long wouldn't be too bad.

> > > The problem is that those 5 bits need not be encoded as a bitmask by
> > > dyndbg, that can simply be the category code for the message. They only
> > > need be converted into a mask when we compare them to the mask provided
> > > by the user.
> > > 

I also suggested adding a pointer to whatever is provided
by the developer so the address of something like
MODULE_PARM_DESC(variable, ...) can be also be used.

> > heres what I have in mind.  whats described here is working.
> > I'll send it out soon
> 
> Cool. thanks for working on this!

Truly, thank you both Jim and Stanimir.

Please remember that dynamic_debug is not required and
pr_debug should still work.

> >     API:
> > 
> >     - change pr_debug(...)  -->  pr_debug_typed(type_id=0, ...)
> >     - all existing uses have type_id=0
> >     - developer creates exclusive types of log messages with type_id>0
> >       1, 2, 3 are disjoint groups, for example: hi, mid, low

You could have a u8 for type if there are to be 3 classes

	bitmask
	level
	group by value

though I believe group by value might as well just be bitmask
and bool is_bitmask is enough (!is_bitmask would be level)

cheers, Joe

