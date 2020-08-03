Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0575423AD2C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 21:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgHCTfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 15:35:54 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:52322 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726906AbgHCTfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 15:35:54 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id DDA80180A9F5C;
        Mon,  3 Aug 2020 19:35:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:965:966:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2525:2553:2560:2563:2682:2685:2731:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4184:4250:4321:4385:4390:4395:5007:7903:8603:9025:10004:10400:10848:10967:11026:11232:11658:11914:12043:12050:12114:12297:12438:12555:12740:12895:12986:13069:13311:13357:13439:13845:13894:14096:14097:14180:14181:14659:14721:21060:21080:21212:21433:21451:21627:21740:21811:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: silk24_410b3b026fa0
X-Filterd-Recvd-Size: 2397
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Mon,  3 Aug 2020 19:35:51 +0000 (UTC)
Message-ID: <69b4c4838cb743e24a79f81de487ac2e494843ef.camel@perches.com>
Subject: Re: [PATCH] gve: Fix the size used in a 'dma_free_coherent()' call
From:   Joe Perches <joe@perches.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, lrizzo@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date:   Mon, 03 Aug 2020 12:35:49 -0700
In-Reply-To: <3a25ddc6-adaa-d17d-50f4-8f8ab2ed25eb@wanadoo.fr>
References: <20200802141523.691565-1-christophe.jaillet@wanadoo.fr>
         <20200803084106.050eb7f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <3a25ddc6-adaa-d17d-50f4-8f8ab2ed25eb@wanadoo.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-03 at 21:19 +0200, Christophe JAILLET wrote:
> Le 03/08/2020 à 17:41, Jakub Kicinski a écrit :
> > On Sun,  2 Aug 2020 16:15:23 +0200 Christophe JAILLET wrote:
> > > Update the size used in 'dma_free_coherent()' in order to match the one
> > > used in the corresponding 'dma_alloc_coherent()'.
> > > 
> > > Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > 
> > Fixes tag: Fixes: 893ce44df5 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> > Has these problem(s):
> > 	- SHA1 should be at least 12 digits long
> > 	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
> > 	  or later) just making sure it is not set (or set to "auto").
> > 
> 
> Hi,
> 
> I have git 2.25.1 and core.abbrev is already 12, both in my global 
> .gitconfig and in the specific .git/gitconfig of my repo.
> 
> I would have expected checkpatch to catch this kind of small issue.
> Unless I do something wrong, it doesn't.
> 
> Joe, does it make sense to you and would one of the following patch help?

18 months ago I sent:

https://lore.kernel.org/lkml/40bfc40958fca6e2cc9b86101153aa0715fac4f7.camel@perches.com/


