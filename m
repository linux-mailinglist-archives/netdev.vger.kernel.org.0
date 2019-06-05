Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45753634A
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFESYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:24:03 -0400
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:41368 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725950AbfFESYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:24:03 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 1ABD163D;
        Wed,  5 Jun 2019 18:24:02 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:6117:6119:6120:7875:7901:7903:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12740:12760:12895:13069:13311:13357:13439:14659:14721:21063:21080:21627:30012:30030:30054:30083:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: women45_600e0ccee119
X-Filterd-Recvd-Size: 2384
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Wed,  5 Jun 2019 18:24:01 +0000 (UTC)
Message-ID: <95fa3d641e5df79b7e69ff377593c4273e812bb6.camel@perches.com>
Subject: Re: [PATCH RFC iproute2-next v4] tc: add support for action
 act_ctinfo
From:   Joe Perches <joe@perches.com>
To:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Date:   Wed, 05 Jun 2019 11:23:59 -0700
In-Reply-To: <20190603135040.75408-1-ldir@darbyshire-bryant.me.uk>
References: <20190602185020.40787-1-ldir@darbyshire-bryant.me.uk>
         <20190603135040.75408-1-ldir@darbyshire-bryant.me.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-03 at 14:50 +0100, Kevin Darbyshire-Bryant wrote:
> ctinfo is an action restoring data stored in conntrack marks to various
> fields.  At present it has two independent modes of operation,
> restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
> marks into packet skb marks.
[]
> v2 - fix whitespace issue in pkt_cls
>      fix most warnings from checkpatch - some lines still over 80 chars
>      due to long TLV names.
> v3 - fix some dangling else warnings.
>      refactor stats printing to please checkpatch.
>      send zone TLV even if default '0' zone.
>      now checkpatch clean even though I think some of the formatting
>      is horrible :-)

Strict 80 column limits with long identifiers are just silly.

I don't know how strictly enforced the iproute2 80 column limit
actually is, but I suggest ignoring that limit where appropriate.

e.g.:

> diff --git a/tc/m_ctinfo.c b/tc/m_ctinfo.c
[]
> +static int print_ctinfo(struct action_util *au, FILE *f, struct rtattr *arg)
> +{
[]
> +	if (tb[TCA_CTINFO_PARMS_DSCP_MASK]) {
> +		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_DSCP_MASK]) >=
> +		    sizeof(__u32))

I think code like this should just be single line.

> +	if (tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) {
> +		if (RTA_PAYLOAD(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) >=
> +		    sizeof(__u32))
> +			dscpstatemask = rta_getattr_u32(
> +					tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]);

here too, etc...


