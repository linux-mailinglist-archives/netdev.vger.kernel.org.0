Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124087C006
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbfGaLct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:32:49 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:56467 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726378AbfGaLcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 07:32:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 8462C1F17;
        Wed, 31 Jul 2019 11:32:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2553:2559:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7903:9025:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12296:12297:12438:12555:12740:12760:12895:13069:13071:13311:13357:13439:14180:14181:14581:14659:14721:21060:21080:21451:21627:21740:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:25,LUA_SUMMARY:none
X-HE-Tag: train36_6f5bba09d615e
X-Filterd-Recvd-Size: 2209
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Wed, 31 Jul 2019 11:32:45 +0000 (UTC)
Message-ID: <eac3fe457d553a2b366e1c1898d47ae8c048087c.camel@perches.com>
Subject: Re: [PATCH] net: sctp: Rename fallthrough label to unhandled
From:   Joe Perches <joe@perches.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 31 Jul 2019 04:32:43 -0700
In-Reply-To: <20190731111932.GA9823@hmswarspite.think-freely.org>
References: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
         <20190731111932.GA9823@hmswarspite.think-freely.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-31 at 07:19 -0400, Neil Horman wrote:
> On Tue, Jul 30, 2019 at 10:04:37PM -0700, Joe Perches wrote:
> > fallthrough may become a pseudo reserved keyword so this only use of
> > fallthrough is better renamed to allow it.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> Are you referring to the __attribute__((fallthrough)) statement that gcc
> supports?  If so the compiler should by all rights be able to differentiate
> between a null statement attribute and a explicit goto and label without the
> need for renaming here.  Or are you referring to something else?

Hi.

I sent after this a patch that adds

# define fallthrough                    __attribute__((__fallthrough__))

https://lore.kernel.org/patchwork/patch/1108577/

So this rename is a prerequisite to adding this #define.

> > diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
[]
> > @@ -2152,7 +2152,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
> >  	case SCTP_PARAM_SET_PRIMARY:
> >  		if (net->sctp.addip_enable)
> >  			break;
> > -		goto fallthrough;
> > +		goto unhandled;

etc...


