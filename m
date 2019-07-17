Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C26B4DD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 05:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfGQDGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 23:06:38 -0400
Received: from smtprelay0182.hostedemail.com ([216.40.44.182]:35905 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726069AbfGQDGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 23:06:37 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 4A32B34A1;
        Wed, 17 Jul 2019 03:06:36 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4321:4605:5007:6119:7903:10004:10400:10848:11232:11658:11914:12296:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21433:21451:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:23,LUA_SUMMARY:none
X-HE-Tag: cause64_738513b3fb42d
X-Filterd-Recvd-Size: 1832
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Wed, 17 Jul 2019 03:06:33 +0000 (UTC)
Message-ID: <fa656d2d8a1677a0a1fbea4b7f60dfca2661827b.camel@perches.com>
Subject: Re: [PATCH] skbuff: fix compilation warnings in skb_dump()
From:   Joe Perches <joe@perches.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Qian Cai <cai@lca.pw>
Cc:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        clang-built-linux@googlegroups.com,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Tue, 16 Jul 2019 20:06:32 -0700
In-Reply-To: <CAF=yD-KW-XnDvD0i8VbzrkLGNWEY6cPoaEcHy40hbghGXTo+kA@mail.gmail.com>
References: <1563288840-1913-1-git-send-email-cai@lca.pw>
         <CAF=yD-KW-XnDvD0i8VbzrkLGNWEY6cPoaEcHy40hbghGXTo+kA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-07-16 at 17:04 +0200, Willem de Bruijn wrote:
> On Tue, Jul 16, 2019 at 4:56 PM Qian Cai <cai@lca.pw> wrote:
> > Fix them by using the proper types, and also fix some checkpatch
> > warnings by using pr_info().
> > 
> > WARNING: printk() should include KERN_<LEVEL> facility level
> > +               printk("%ssk family=%hu type=%u proto=%u\n",
> 
> Converting printk to pr_info lowers all levels to KERN_INFO.
> 
> skb_dump takes an explicit parameter level to be able to log at
> KERN_ERR or KERN_WARNING
> 
> I would like to avoid those checkpatch warnings, but this is not the
> right approach.

Just ignore checkpatch when it doesn't know that
the printk actually includes a KERN_<LEVEL> via
"%s...", level


