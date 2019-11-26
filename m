Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0026F10A24E
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728557AbfKZQix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:38:53 -0500
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:41130 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725995AbfKZQix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:38:53 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 6652118028E8F;
        Tue, 26 Nov 2019 16:38:52 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:4250:4321:5007:6119:7903:10004:10400:10848:11026:11232:11658:11914:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21433:21627:21972:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:9,LUA_SUMMARY:none
X-HE-Tag: order07_302b770f34016
X-Filterd-Recvd-Size: 1486
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Tue, 26 Nov 2019 16:38:50 +0000 (UTC)
Message-ID: <99648842d1cfaaabd7178fe55e8f287a87e18a6a.camel@perches.com>
Subject: Re: [PATCH] net: sunrpc:  replace 0 with NULL
From:   Joe Perches <joe@perches.com>
To:     Jules Irenge <jbi.octave@gmail.com>,
        trond.myklebust@hammerspace.com
Cc:     anna.schumaker@netapp.com, davem@davemloft.net,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Nov 2019 08:38:24 -0800
In-Reply-To: <20191125225239.384343-1-jbi.octave@gmail.com>
References: <20191125225239.384343-1-jbi.octave@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-11-25 at 22:52 +0000, Jules Irenge wrote:
> Replace 0 with NULL to fix warning detected by sparse tool.
> warning: Using plain integer as NULL pointer
[]
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
[]
> @@ -614,7 +614,7 @@ xs_read_stream_reply(struct sock_xprt *transport, struct msghdr *msg, int flags)
>  static ssize_t
>  xs_read_stream(struct sock_xprt *transport, int flags)
>  {
> -	struct msghdr msg = { 0 };
> +	struct msghdr msg = { NULL };

Rather than depending on the first member to be a pointer
perhaps better to use the equivalent

	struct msghdr msg = {};


