Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7483805ED
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 13:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389503AbfHCLPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 07:15:09 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:53510 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389458AbfHCLPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 07:15:09 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D179F180A76E1;
        Sat,  3 Aug 2019 11:15:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4250:4321:4384:4605:5007:7974:8604:9393:10004:10400:10848:11232:11657:11658:11914:12043:12296:12297:12679:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21451:21611:21627:30009:30012:30054:30070:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: boat09_83f32473a9e60
X-Filterd-Recvd-Size: 2184
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sat,  3 Aug 2019 11:15:06 +0000 (UTC)
Message-ID: <6ff800ceda4b1c1f1d9e519aac13db42dc703294.camel@perches.com>
Subject: Re: [PATCH] isdn: hysdn: Fix error spaces around '*'
From:   Joe Perches <joe@perches.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
Cc:     isdn@linux-pingi.de, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 03 Aug 2019 04:15:05 -0700
In-Reply-To: <20190803063246.GA10186@kroah.com>
References: <20190802195602.28414-1-joseespiriki@gmail.com>
         <20190803063246.GA10186@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2019-08-03 at 08:32 +0200, Greg KH wrote:
> On Fri, Aug 02, 2019 at 07:56:02PM +0000, Jose Carlos Cazarin Filho wrote:
> > Fix checkpath error:
> > CHECK: spaces preferred around that '*' (ctx:WxV)
> > +extern hysdn_card *card_root;        /* pointer to first card */
[]
> > diff --git a/drivers/staging/isdn/hysdn/hysdn_defs.h b/drivers/staging/isdn/hysdn/hysdn_defs.h
[]
> > @@ -220,7 +220,7 @@ typedef struct hycapictrl_info hycapictrl_info;
> >  /*****************/
> >  /* exported vars */
> >  /*****************/
> > -extern hysdn_card *card_root;	/* pointer to first card */
> > +extern hysdn_card * card_root;	/* pointer to first card */
> 
> The original code here is correct, checkpatch must be reporting this
> incorrectly.

Here checkpatch thinks that hydsn_card is an identifier rather
than a typedef.

It's defined as:
	typedef struct HYSDN_CARD {
	...
	} hysdn_card;

And that confuses checkpatch.

kernel source code style would not use a typedef for a struct.

A change would be to remove the typedef and declare this as:
	struct hysdn_card {
		...
	};

And then do a global:
	sed 's/\bhysdn_card\b/struct hysdn_card/g'

But that's not necessary as the driver is likely to be removed.


