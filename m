Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD5537791B
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhEIW4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhEIW4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:56:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D8FC061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:55:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lfsKP-0003t2-Th; Mon, 10 May 2021 00:55:14 +0200
Date:   Mon, 10 May 2021 00:55:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] mptcp: avoid uninitialised errno usage
Message-ID: <20210509225513.GF4038@breakpoint.cc>
References: <20210503103631.30694-1-fw@strlen.de>
 <b8d9cc70-7667-d2b3-50b6-0ef0ce041735@gmail.com>
 <20210509222549.GE4038@breakpoint.cc>
 <3fc254ad-4766-a599-3500-ca16bd7d52c6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fc254ad-4766-a599-3500-ca16bd7d52c6@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> >  	if (rtnl_talk(grth, &req.n, &answer) < 0) {
> >  		fprintf(stderr, "Error talking to the kernel\n");
> > +		if (errno == 0)
> > +			errno = EOPNOTSUPP;
> 
> you don't list the above string in the output in the commit log. Staring
> at rtnl_talk and recvmsg and its failure paths, it seems unlikely that
> path is causing the problem.

Its not in my particular case, but if it would caller would still get random errno.

The sketch I sent merely provides a relible errno whenever ret is less
than 0.  Right now it may or may not have been set.
