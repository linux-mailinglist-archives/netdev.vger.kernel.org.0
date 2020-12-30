Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE502E7685
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgL3G31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:29:27 -0500
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:40978 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726363AbgL3G30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:29:26 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 592CB18029210;
        Wed, 30 Dec 2020 06:28:45 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:4321:5007:7652:10004:10400:10471:10848:11026:11232:11473:11658:11783:11914:12043:12297:12438:12740:12895:13019:13069:13255:13311:13357:13439:13894:14659:14721:21080:21324:21451:21627:21939:21990:30012:30025:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: music26_4715adf274a2
X-Filterd-Recvd-Size: 1768
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 30 Dec 2020 06:28:43 +0000 (UTC)
Message-ID: <1863fac248a37a92d9bacc4992caafecdcdac0dc.camel@perches.com>
Subject: Re: [PATCH] liquidio: style:  Identical condition and return
 expression  'retval', return value is always 0.
From:   Joe Perches <joe@perches.com>
To:     YANG LI <abaci-bugfix@linux.alibaba.com>, davem@davemloft.net
Cc:     kuba@kernel.org, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 29 Dec 2020 22:28:42 -0800
In-Reply-To: <1609308450-50695-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1609308450-50695-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-30 at 14:07 +0800, YANG LI wrote:
> The warning was because of the following line in function
> liquidio_set_fec():
> 
> retval = wait_for_sc_completion_timeout(oct, sc, 0);
>     if (retval)
> 	return (-EIO);

I presume abaci is a robot

Perhaps also the robot could look for code immediately above this like:

		oct->props[lio->ifidx].fec = var;
		if (resp->fec_setting == SEAPI_CMD_FEC_SET_RS)
			oct->props[lio->ifidx].fec = 1;
		else
			oct->props[lio->ifidx].fec = 0;

where a location is immediately overwritten.

so the line
		oct->props[lio->ifidx].fec = var;
could be highlighted and perhaps removed
and also perhaps the second test and set block could be written

		oct->props[lio->ifidx].fec = resp->fec_setting == SEAPI_CMD_FEC_SET_RS;



