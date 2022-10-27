Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C034610671
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiJ0XfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiJ0XfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:35:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9CD22B04;
        Thu, 27 Oct 2022 16:35:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ooCOq-0003mB-QB; Fri, 28 Oct 2022 01:35:01 +0200
Date:   Fri, 28 Oct 2022 01:35:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
Message-ID: <20221027233500.GA1915@breakpoint.cc>
References: <20220905100937.11459-1-fw@strlen.de>
 <20220905100937.11459-2-fw@strlen.de>
 <20221027133109.590bd74f@kernel.org>
 <2f528f1a320c55fdc7f3be55095c1f0eacee1032.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f528f1a320c55fdc7f3be55095c1f0eacee1032.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2022-10-27 at 13:31 -0700, Jakub Kicinski wrote:
> > On Mon,  5 Sep 2022 12:09:36 +0200 Florian Westphal wrote:
> > >  		struct {
> > >  			s16 min, max;
> > > +			u8 network_byte_order:1;
> > >  		};
> > 
> > This makes the union 64bit even on 32bit systems.
> > Do we care? Should we accept that and start using
> > full 64bits in other validation members?
> > 
> > We can quite easily steal a bit elsewhere, which
> > I reckon may be the right thing to do, but I thought
> > I'd ask.

I'm fine with scraping the marker elsewhere.

> In fact we could easily just have three extra types NLA_BE16, NLA_BE32
> and NLA_BE64 types without even stealing a bit?

Sure, I can make a patch if there is consensus that new types are the
way to go.
