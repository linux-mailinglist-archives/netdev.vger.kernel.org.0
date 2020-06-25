Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA6720A808
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407397AbgFYWNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 18:13:18 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:35756 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406337AbgFYWNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:13:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 9ED4F837F24A;
        Thu, 25 Jun 2020 22:13:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:4321:4605:5007:6114:6642:10004:10400:10848:11026:11232:11658:11914:12043:12296:12297:12740:12760:12895:13069:13311:13357:13439:13972:14659:14721:21080:21324:21451:21627:21990:30029:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: soap97_08148e526e50
X-Filterd-Recvd-Size: 1802
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu, 25 Jun 2020 22:13:15 +0000 (UTC)
Message-ID: <049f51497b84e55e61aca989025b64493287cbab.camel@perches.com>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
From:   Joe Perches <joe@perches.com>
To:     Coiby Xu <coiby.xu@gmail.com>, devel@driverdev.osuosl.org
Cc:     Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 25 Jun 2020 15:13:14 -0700
In-Reply-To: <20200625215755.70329-3-coiby.xu@gmail.com>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
         <20200625215755.70329-3-coiby.xu@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-26 at 05:57 +0800, Coiby Xu wrote:
> Remove unnecessary elses after return or break.

unrelated trivia:

> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
[]
> @@ -1391,12 +1391,11 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
>  			pr_err("%s: Failed read of mac index register\n",
>  			       __func__);
>  			return;
> -		} else {
> -			if (value[0])
> -				pr_err("%s: CAM index %d CAM Lookup Lower = 0x%.08x:%.08x, Output = 0x%.08x\n",
> -				       qdev->ndev->name, i, value[1], value[0],
> -				       value[2]);

looks like all of these could use netdev_err

				netdev_err(qdev, "etc...",
					   i, value[1], value[0], value[2]);

etc...


