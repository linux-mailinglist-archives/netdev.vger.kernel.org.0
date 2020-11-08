Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6C2AAA81
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 11:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKHKK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 05:10:29 -0500
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:49930 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726206AbgKHKK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 05:10:29 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id EA59A1730869;
        Sun,  8 Nov 2020 10:10:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2565:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6119:6742:7557:7903:8957:9025:10004:10400:10848:11232:11658:11914:12043:12294:12297:12438:12555:12740:12760:12895:13069:13095:13311:13357:13439:14181:14659:14721:14777:21080:21433:21451:21627:21811:21939:30012:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:364,LUA_SUMMARY:none
X-HE-Tag: bone67_5b0d737272e3
X-Filterd-Recvd-Size: 3142
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Sun,  8 Nov 2020 10:10:25 +0000 (UTC)
Message-ID: <5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com>
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
From:   Joe Perches <joe@perches.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Aditya Srivastava <yashsri421@gmail.com>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Sun, 08 Nov 2020 02:10:24 -0800
In-Reply-To: <alpine.DEB.2.21.2011080829080.4909@felia>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
         <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
         <alpine.DEB.2.21.2011080829080.4909@felia>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-11-08 at 08:34 +0100, Lukas Bulwahn wrote:
> On Sat, 7 Nov 2020, Joe Perches wrote:
> > On Fri, 2020-11-06 at 23:55 -0800, Nick Desaulniers wrote:
> > > Clang is more aggressive about -Wformat warnings when the format flag
> > > specifies a type smaller than the parameter. Fixes 8 instances of:
> > > 
> > > warning: format specifies type 'unsigned short' but the argument has
> > > type 'int' [-Wformat]
> > 
> > Likely clang's -Wformat message is still bogus.
> > Wasn't that going to be fixed?
> > 
> > Integer promotions are already done on these types to int anyway.
> > Didn't we have this discussion last year?
> > 
> > https://lore.kernel.org/lkml/CAKwvOd=mqzj2pAZEUsW-M_62xn4pijpCJmP=B1h_-wEb0NeZsA@mail.gmail.com/
> > https://lore.kernel.org/lkml/CAHk-=wgoxnmsj8GEVFJSvTwdnWm8wVJthefNk2n6+4TC=20e0Q@mail.gmail.com/
> > https://lore.kernel.org/lkml/a68114afb134b8633905f5a25ae7c4e6799ce8f1.camel@perches.com/
> > 
> > Look at commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
> > of unnecessary %h[xudi] and %hh[xudi]")
> > 
> > The "h" and "hh" things should never be used. The only reason for them
> > being used if if you have an "int", but you want to print it out as a
> > "char" (and honestly, that is a really bad reason, you'd be better off
> > just using a proper cast to make the code more obvious).
> > 
> Joe, would this be a good rule to check for in checkpatch?
> 
> Can Dwaipayan or Aditya give it a try to create a suitable patch to add 
> such a rule?

$ git grep -P '"[^"]*%[\d\.\*\-]*h+[idux].*"'

I suppose so.
Please avoid warning on scanf and its variants and the asm bits though.

> Dwaipayan, Aditya, if Joe thinks it is worth a rule, it is "first come, 
> first serve" for you to take that task. 


