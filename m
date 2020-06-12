Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E031F7A94
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 17:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgFLPTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 11:19:17 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:56422 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726085AbgFLPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 11:19:16 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id CD2A7100E4720;
        Fri, 12 Jun 2020 15:19:14 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:2895:2901:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:3871:3872:3873:3874:4321:4425:5007:6119:6742:7514:7903:10004:10400:10848:10967:11026:11232:11658:11914:12297:12740:12760:12895:13069:13095:13311:13357:13439:14096:14097:14181:14659:14721:21067:21080:21212:21433:21451:21627:30012:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: toy64_4f084a126ddd
X-Filterd-Recvd-Size: 2858
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Fri, 12 Jun 2020 15:19:12 +0000 (UTC)
Message-ID: <0b82952a6e0b4a05c93f4d18b3d0b2f43b61ab98.camel@perches.com>
Subject: Re: [PATCH] xdp_rxq_info_user: Replace malloc/memset w/calloc
From:   Joe Perches <joe@perches.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Gaurav Singh <gaurav1086@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:XDP (eXpress Data Path)" <netdev@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Fri, 12 Jun 2020 08:19:10 -0700
In-Reply-To: <20200612140520.1e3c0461@carbon>
References: <20200611150221.15665-1-gaurav1086@gmail.com>
         <20200612003640.16248-1-gaurav1086@gmail.com>
         <20200612084244.4ab4f6c6@carbon>
         <427be84b1154978342ef861f1f4634c914d03a94.camel@perches.com>
         <20200612140520.1e3c0461@carbon>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-12 at 14:05 +0200, Jesper Dangaard Brouer wrote:
> On Fri, 12 Jun 2020 03:14:58 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Fri, 2020-06-12 at 08:42 +0200, Jesper Dangaard Brouer wrote:
> > > On Thu, 11 Jun 2020 20:36:40 -0400
> > > Gaurav Singh <gaurav1086@gmail.com> wrote:
> > >   
> > > > Replace malloc/memset with calloc
> > > > 
> > > > Fixes: 0fca931a6f21 ("samples/bpf: program demonstrating access to xdp_rxq_info")
> > > > Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>  
> > > 
> > > Above is the correct use of Fixes + Signed-off-by.
> > > 
> > > Now you need to update/improve the description, to also
> > > mention/describe that this also solves the bug you found.  
> > 
> > This is not a fix, it's a conversion of one
> > correct code to a shorter one.
> 
> Read the code again Joe.  There is a bug in the code that gets removed,
> as it runs memset on the memory before checking if it was NULL.
> 
> IHMO this proves why is it is necessary to mention in the commit
> message, as you didn't notice the bug in your code review.

I didn't review the code at all, just the commit message,

It's important to have commit messages that describe the
defect being corrected too.

Otherwise, a simple malloc/memset(0) vs zalloc equivalent
is not actually a defect.


