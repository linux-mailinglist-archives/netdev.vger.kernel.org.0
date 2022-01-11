Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08CB48AF88
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 15:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241714AbiAKO3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 09:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbiAKO3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 09:29:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F41DC06173F;
        Tue, 11 Jan 2022 06:29:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n7I8w-0006gx-KW; Tue, 11 Jan 2022 15:28:58 +0100
Date:   Tue, 11 Jan 2022 15:28:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Tom Rix <trix@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: extend CONFIG_NF_CONNTRACK compile time checks
Message-ID: <20220111142858.GE32500@breakpoint.cc>
References: <20211225173744.3318250-1-trix@redhat.com>
 <Yd1SCbvjeXE+ceRo@salvia>
 <c31ca0e7-2895-eae9-c52d-41c0f187443e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c31ca0e7-2895-eae9-c52d-41c0f187443e@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tom Rix <trix@redhat.com> wrote:
> 
> On 1/11/22 1:46 AM, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Sat, Dec 25, 2021 at 09:37:44AM -0800, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > Extends
> > > commit 83ace77f5117 ("netfilter: ctnetlink: remove get_ct indirection")
> > > 
> > > Add some compile time checks by following the ct and ctinfo variables
> > > that are only set when CONFIG_NF_CONNTRACK is enabled.
> > > 
> > > In nfulnl_log_packet(), ct is only set when CONFIG_NF_CONNTRACK
> > > is enabled. ct's later use in __build_packet_message() is only
> > > meaningful when CONFIG_NF_CONNTRACK is enabled, so add a check.
> > > 
> > > In nfqnl_build_packet_message(), ct and ctinfo are only set when
> > > CONFIG_NF_CONNTRACK is enabled.  Add a check for their decl and use.
> > > 
> > > nfqnl_ct_parse() is a static function, move the check to the whole
> > > function.
> > > 
> > > In nfqa_parse_bridge(), ct and ctinfo are only set by the only
> > > call to nfqnl_ct_parse(), so add a check for their decl and use.
> > > 
> > > Consistently initialize ctinfo to 0.
> > Are compile warning being trigger without this patch, maybe with
> > CONFIG_NF_CONNTRACK=n?
> 
> No compiler warnings, this was found by visual inspection.
> 
> Robot says to entend more, so I want to make sure a human is also
> interested.

I hoped compiler was able to remove that without aid of preprocessor :/
