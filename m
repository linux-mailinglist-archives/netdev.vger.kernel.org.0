Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F9221BA29
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgGJQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:00:52 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:35094 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726925AbgGJQAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:00:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 79AB018224D66;
        Fri, 10 Jul 2020 16:00:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1381:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3165:3353:3622:3653:3865:3866:3867:3868:3870:3872:3873:4321:5007:6119:6737:7903:10004:10400:10848:11232:11473:11658:11914:12043:12048:12297:12555:12679:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: swim81_190e06826ecf
X-Filterd-Recvd-Size: 2357
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Fri, 10 Jul 2020 16:00:48 +0000 (UTC)
Message-ID: <a2f48c734bdc6b865a41ad684e921ac04b221821.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: XDP: restrict N: and K:
From:   Joe Perches <joe@perches.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, mchehab+huawei@kernel.org,
        robh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Fri, 10 Jul 2020 09:00:46 -0700
In-Reply-To: <7d4427cc-a57c-ca99-1119-1674d509ba9d@iogearbox.net>
References: <20200709194257.26904-1-grandmaster@al2klimov.de>
         <d7689340-55fc-5f3f-60ee-b9c952839cab@iogearbox.net>
         <19a4a48b-3b83-47b9-ac48-e0a95a50fc5e@al2klimov.de>
         <7d4427cc-a57c-ca99-1119-1674d509ba9d@iogearbox.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-07-10 at 17:14 +0200, Daniel Borkmann wrote:
> On 7/10/20 8:17 AM, Alexander A. Klimov wrote:
> > Am 09.07.20 um 22:37 schrieb Daniel Borkmann:
> > > On 7/9/20 9:42 PM, Alexander A. Klimov wrote:
> > > > Rationale:
> > > > Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
> > > > which has nothing to do with XDP.
[]
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > > > @@ -18708,8 +18708,8 @@ F:    include/trace/events/xdp.h
> > > >   F:    kernel/bpf/cpumap.c
> > > >   F:    kernel/bpf/devmap.c
> > > >   F:    net/core/xdp.c
> > > > -N:    xdp
> > > > -K:    xdp
> > > > +N:    (?:\b|_)xdp(?:\b|_)
> > > > +K:    (?:\b|_)xdp(?:\b|_)
> > > 
> > > Please also include \W to generally match on non-alphanumeric char given you
> > > explicitly want to avoid [a-z0-9] around the term xdp.
> > Aren't \W, ^ and $ already covered by \b?
> 
> Ah, true; it says '\b really means (?:(?<=\w)(?!\w)|(?<!\w)(?=\w))', so all good.
> In case this goes via net or net-next tree:

This N: pattern does not match files like:

	samples/bpf/xdp1_kern.c

and does match files like:

	drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c

Should it?


