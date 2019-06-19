Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F2D4C08E
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFSSKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:10:52 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:56895 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726175AbfFSSKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:10:52 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 311F7837F27D;
        Wed, 19 Jun 2019 18:10:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2559:2563:2682:2685:2731:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:6742:7903:8957:9010:9025:10004:10400:10848:11232:11658:11914:12043:12438:12555:12663:12679:12740:12760:12895:13019:13069:13073:13095:13311:13357:13439:14181:14659:14721:21080:21324:21365:21433:21451:21627:21740:30054:30060:30083:30090:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:34,LUA_SUMMARY:none
X-HE-Tag: way23_7b66ca55ffa0b
X-Filterd-Recvd-Size: 2550
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Wed, 19 Jun 2019 18:10:47 +0000 (UTC)
Message-ID: <6bb0ac7f70a12a4bb9cb6238b4e50e23674bde43.camel@perches.com>
Subject: Re: [PATCH] net/ipv4: fib_trie: Avoid cryptic ternary expressions
From:   Joe Perches <joe@perches.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Nathan Huckleberry <nhuck@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Date:   Wed, 19 Jun 2019 11:10:46 -0700
In-Reply-To: <CAKwvOdkJCt7Du01e3LreLdpREPuZXWYnUad6WzqwO_o4i0yk7A@mail.gmail.com>
References: <20190618211440.54179-1-mka@chromium.org>
         <20190618230420.GA84107@archlinux-epyc>
         <CAKwvOd=i2qsEO90cHn-Zvgd7vbhK5Z4RH89gJGy=Cjzbi9QRMA@mail.gmail.com>
         <f22006fedb0204ad05858609bc9d3ed0abc6078e.camel@perches.com>
         <CAKwvOdkJCt7Du01e3LreLdpREPuZXWYnUad6WzqwO_o4i0yk7A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-19 at 10:41 -0700, Nick Desaulniers wrote:
> On Wed, Jun 19, 2019 at 2:36 AM Joe Perches <joe@perches.com> wrote:
> > On Tue, 2019-06-18 at 16:23 -0700, Nick Desaulniers wrote:
> > > As a side note, I'm going to try to see if MAINTAINERS and
> > > scripts/get_maintainers.pl supports regexes on the commit messages in
> > > order to cc our mailing list
> > 
> > Neither.  Why should either?
> 
> Looks like `K:` is exactly what I'm looking for.

Using K: for commit message content isn't the intended
use, but if it works for you, fine by me.

> Joe, how does:
> https://github.com/ClangBuiltLinux/linux/commit/a0a64b8d65c4e7e033f49e48cc610d6e4002927e
> look?

You might consider using

K:	\b(?i:clang|llvm)\b

to get case insensitive matches.

> Is there a maintainer for MAINTAINERS or do I just send the
> patch to Linus?

Generally MAINTAINER patches go via Andrew Morton or
indirectly along with other changes via a pull request
to Linus.



