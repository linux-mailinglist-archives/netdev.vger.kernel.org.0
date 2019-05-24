Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214A929DB3
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbfEXSEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:04:49 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:60685 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbfEXSEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:04:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 303EE18047635;
        Fri, 24 May 2019 18:04:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:599:877:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2553:2559:2562:2731:2828:2902:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3873:3874:4321:4605:5007:7902:10004:10400:10471:10848:11026:11232:11473:11658:11914:12295:12438:12555:12740:12760:12895:12986:13069:13255:13311:13357:13439:14659:21080:21212:21627:30029:30054:30060:30070:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:34,LUA_SUMMARY:none
X-HE-Tag: food21_c878d8e4561b
X-Filterd-Recvd-Size: 2257
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Fri, 24 May 2019 18:04:45 +0000 (UTC)
Message-ID: <8c138b300290efbff43631f2c527a37390c504d8.camel@perches.com>
Subject: Re: r8169: Link only up after 16 s (A link change request failed
 with some changes committed already. Interface enp3s0 may have been left
 with an inconsistent configuration, please check.)
From:   Joe Perches <joe@perches.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Fri, 24 May 2019 11:04:43 -0700
In-Reply-To: <5d25b4f3-20d3-6c93-2c0a-b95fde9e4c40@gmail.com>
References: <a05b0b6c-505c-db61-96ac-813e68a26cc6@molgen.mpg.de>
         <abb2d596-d9fe-5426-8f1d-2ef4a7eb9e1a@gmail.com>
         <48ad419a-65f4-40ca-d7a9-01fafee33d83@molgen.mpg.de>
         <5d25b4f3-20d3-6c93-2c0a-b95fde9e4c40@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-24 at 19:55 +0200, Heiner Kallweit wrote:
> On 24.05.2019 17:14, Paul Menzel wrote:
> > I applied the simple change below to `net/core/rtnetlink.c`.
> > 
> >                 if (err < 0)
> > -                       net_warn_ratelimited("A link change request failed with some changes committed already. Interface %s may have been left with an inconsistent configuration, please check.\n",
> > -                                            dev->name);
> > +                       net_warn_ratelimited("A link change request failed with some changes committed already (err = %i). Interface %s may have been left with an inconsistent configuration, please check.\n",
> > +                                            dev->name, err);
> > 
> > I get different results each time.
> > 
> > -304123904
> > -332128256
> > 
> > Any idea, how that can happen?
> > 
> Instead of %i you should use %d, and the order of arguments needs to be reversed.

Doesn't the patch generate a compilation warning?


