Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1213D5B28BC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIHVtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 17:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIHVtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 17:49:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C331F3BE2
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 14:49:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oWPON-0008Oi-BY; Thu, 08 Sep 2022 23:48:59 +0200
Date:   Thu, 8 Sep 2022 23:48:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: b118509076b3 (probably) breaks my firewall
Message-ID: <20220908214859.GD16543@breakpoint.cc>
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Clayton <chris2553@googlemail.com> wrote:

[ CC Pablo ]

> On 08/09/2022 20:19, Florian Westphal wrote:
> > Chris Clayton <chris2553@googlemail.com> wrote:
> >> Just a heads up and a question...
> >>
> >> I've pulled the latest and greatest from Linus' tree and built and installed the kernel. git describe gives
> >> v6.0-rc4-126-g26b1224903b3.
> >>
> >> I find that my firewall is broken because /proc/sys/net/netfilter/nf_conntrack_helper no longer exists. It existed on an
> >> -rc4 kernel. Are changes like this supposed to be introduced at this stage of the -rc cycle?
> > 
> > The problem is that the default-autoassign (nf_conntrack_helper=1) has
> > side effects that most people are not aware of.
> > 
> > The bug that propmpted this toggle from getting axed was that the irc (dcc) helper allowed
> > a remote client to create a port forwarding to the local client.
> 
> 
> Ok, but I still think it's not the sort of change that should be introduced at this stage of the -rc cycle.
> The other problem is that the documentation (Documentation/networking/nf_conntrack-sysctl.rst) hasn't been updated. So I
> know my firewall is broken but there's nothing I can find that tells me how to fix it.

Pablo, I don't think revert+move the 'next' will avoid this kinds of
problems, but at least the nf_conntrack-sysctl.rst should be amended to
reflect that this was removed.

I'd keep it though because people that see an error wrt. this might be
looking at nf_conntrack-sysctl.rst.

Maybe just a link to
https://home.regit.org/netfilter-en/secure-use-of-helpers/?

What do you think?
