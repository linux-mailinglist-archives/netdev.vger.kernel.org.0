Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8411F2D9128
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 00:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395476AbgLMX0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 18:26:21 -0500
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:39834 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730631AbgLMX0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 18:26:21 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id ABDC1180A7FD3;
        Sun, 13 Dec 2020 23:25:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2565:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4362:5007:6742:9025:10004:10400:10848:11232:11658:11914:12043:12294:12295:12297:12438:12555:12740:12760:12895:13069:13141:13230:13311:13357:13439:14181:14659:14721:21080:21324:21366:21433:21451:21627:21811:21939:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: fear65_5806dcd27416
X-Filterd-Recvd-Size: 2900
Received: from XPS-9350.home (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun, 13 Dec 2020 23:25:37 +0000 (UTC)
Message-ID: <cf2a184e2264a2b9fd2c8d7f10d524924d417d57.camel@perches.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Sun, 13 Dec 2020 15:25:36 -0800
In-Reply-To: <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
         <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
         <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
         <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
         <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
         <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-12-13 at 11:21 -0800, Tom Rix wrote:
> On 12/2/20 2:34 PM, Nick Desaulniers wrote:
> > On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
> > > On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
> > > 
> > > > Yeah, we could go through and remove %h and %hh to solve this, too, right?
> > > Yup.
> > > 
> > > I think one of the checkpatch improvement mentees is adding
> > > some suggestion and I hope an automated fix mechanism for that.
> > > 
> > > https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
> > + Tom, who's been looking at leveraging clang-tidy to automate such
> > treewide mechanical changes.
> > ex. https://reviews.llvm.org/D91789
> > 
> > See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
> > use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
> > related context.
> 
> I have posted the fixer here
> 
> https://reviews.llvm.org/D93182
> 
> It catches about 200 problems in 100 files, I'll be posting these soon.

Thanks, but see below:
 
> clang-tidy-fix's big difference over checkpatch is using the __printf(x,y) attribute to find the log functions.
> 
> I will be doing a follow-on to add the missing __printf or __scanf's and rerunning the fixer.

scanf should not be tested because the %h use is required there.


