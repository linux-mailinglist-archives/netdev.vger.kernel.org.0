Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AB823B201
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgHDA6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:58:55 -0400
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:35118 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726276AbgHDA6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:58:55 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 8E29C181D330D;
        Tue,  4 Aug 2020 00:58:54 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:2902:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4605:5007:7576:7903:8603:10004:10400:10848:10967:11026:11232:11233:11473:11658:11914:12050:12296:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14347:14659:14721:21080:21451:21627:21939:30012:30046:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rat04_10160b926fa2
X-Filterd-Recvd-Size: 2290
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue,  4 Aug 2020 00:58:53 +0000 (UTC)
Message-ID: <5f7a5ec560775f3c43fdbb6ac93f858d8b5e37f3.camel@perches.com>
Subject: Re: [PATCH] via-velocity: Add missing KERN_<LEVEL> where needed
From:   Joe Perches <joe@perches.com>
To:     David Miller <davem@davemloft.net>
Cc:     romieu@fr.zoreil.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 03 Aug 2020 17:58:52 -0700
In-Reply-To: <20200803.154248.2020214547846261577.davem@davemloft.net>
References: <e45d15ad36a0c9a994b5a1136c72518215c99f7a.camel@perches.com>
         <20200803.154248.2020214547846261577.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-03 at 15:42 -0700, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Sat, 01 Aug 2020 08:51:03 -0700
> 
> > Link status is emitted on multiple lines as it does not use
> > KERN_CONT.
> > 
> > Coalesce the multi-part logging into a single line output and
> > add missing KERN_<LEVEL> to a couple logging calls.
> > 
> > This also reduces object size.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> The real problem is the whole VELOCITY_PRT() private debug log
> control business this driver is doing.
> 
> It should be using the standard netdev logging level infrastructure.
> 
> > +                     VELOCITY_PRT(MSG_LEVEL_INFO, KERN_INFO "set Velocity to forced full mode\n");
> 
> You can't tell me that this "KERN_INFO blah blah blah" is really
> something we should add more of these days, right?
> 
> If you're going to improve this driver's logging code please do
> so by having it use the standard interfaces.

The existing code is not great and definitely odd.

This is just a bug fix until such time as it's better.

VELOCITY_PRT is not just used for debugging.

The default is output if MSG_LEVEL_INFO and
there's a control for further output.

This is just fixing Linus' change for KERN_CONT
uses on separate lines from awhile ago.

It'd be nice if a via maintainer actually fixed it.


