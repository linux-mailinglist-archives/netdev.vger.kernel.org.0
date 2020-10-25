Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26E3297FDE
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 03:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766701AbgJYC1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 22:27:19 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:53418 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729717AbgJYC1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 22:27:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 5054F1730873;
        Sun, 25 Oct 2020 02:27:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:4321:5007:10004:10400:10848:11026:11232:11658:11914:12043:12048:12295:12296:12297:12438:12740:12895:13069:13161:13229:13311:13357:13439:13894:13972:14659:14721:21080:21627:30034:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: grass98_27119d227267
X-Filterd-Recvd-Size: 1760
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Sun, 25 Oct 2020 02:27:16 +0000 (UTC)
Message-ID: <a9bc6a8898116bc017152136265a523d5097da84.camel@perches.com>
Subject: Re: [PATCH -next] neigh: remove the extra slash
From:   Joe Perches <joe@perches.com>
To:     Vasily Averin <vvs@virtuozzo.com>,
        Zhang Qilong <zhangqilong3@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     lirongqing@baidu.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org
Date:   Sat, 24 Oct 2020 19:27:10 -0700
In-Reply-To: <e3e6a453-6a73-3f88-e94b-fa39b38252d9@virtuozzo.com>
References: <20201023100146.34948-1-zhangqilong3@huawei.com>
         <e3e6a453-6a73-3f88-e94b-fa39b38252d9@virtuozzo.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-23 at 13:16 +0300, Vasily Averin wrote:
> On 10/23/20 1:01 PM, Zhang Qilong wrote:
> > The normal path has only one slash.
> 
> it is not normal path
> this string is used to calculate number of symbols in "net/%s/neigh/%s" used below

Then probably better would be to add +1 rather than
use a rather odd filename.

> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
[]
> > @@ -3623,7 +3623,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
> >  	int i;
> >  	struct neigh_sysctl_table *t;
> >  	const char *dev_name_source;
> > -	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
> > +	char neigh_path[sizeof("net/neigh/") + IFNAMSIZ + IFNAMSIZ];
> >  	char *p_name;
> >  
> > 
> >  	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
> > 


