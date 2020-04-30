Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4874E1BF4C9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgD3KDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:03:11 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:57568 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726378AbgD3KDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:03:11 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id DDE4F1263;
        Thu, 30 Apr 2020 10:03:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3873:4321:5007:7903:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:14721:21080:21627:21939:21990:30046:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:5,LUA_SUMMARY:none
X-HE-Tag: grip36_8fddf9ae77656
X-Filterd-Recvd-Size: 1988
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Thu, 30 Apr 2020 10:03:08 +0000 (UTC)
Message-ID: <4c91091b304fc5df2a2f292a1e0c78d80217bb94.camel@perches.com>
Subject: Re: [PATCH v2 2/7] staging: qlge: Remove gotos from
 ql_set_mac_addr_reg
From:   Joe Perches <joe@perches.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Rylan Dmello <mail@rylan.coffee>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 30 Apr 2020 03:03:07 -0700
In-Reply-To: <20200430093835.GT2014@kadam>
References: <cover.1588209862.git.mail@rylan.coffee>
         <a6f485e43eb55e8fdc64a7a346cb0419b55c3cb6.1588209862.git.mail@rylan.coffee>
         <20200430093835.GT2014@kadam>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-30 at 12:38 +0300, Dan Carpenter wrote:
> On Wed, Apr 29, 2020 at 09:33:04PM -0400, Rylan Dmello wrote:
> > As suggested by Joe Perches, this patch removes the 'exit' label
> > from the ql_set_mac_addr_reg function and replaces the goto
> > statements with break statements.
[]
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
[]
> > @@ -336,22 +336,20 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
> >  
> >  		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
> >  		if (status)
> > -			goto exit;
> > +			break;
> 
> Just "return status".  A direct return is immediately clear but with a
> break statement then you have to look down a bit and then scroll back.

To me, 6 of 1, half dozen of other as
all the case breaks could be returns.

So either form is fine with me.

The old form was poor through.


