Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080B65EF978
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiI2PuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiI2Pt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:49:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B1DF13D56
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:49:49 -0700 (PDT)
Date:   Thu, 29 Sep 2022 17:49:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Guillaume Nault <gnault@redhat.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: Re: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags for
 new commands
Message-ID: <YzW+ml81tM9Rlt1i@salvia>
References: <20220929142809.1167546-1-kuba@kernel.org>
 <YzWxbrXkvsjnl50R@salvia>
 <20220929080650.370b5977@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220929080650.370b5977@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 08:06:50AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 16:53:34 +0200 Pablo Neira Ayuso wrote:
> > > +	flags = nlh->nlmsg_flags;
> > > +	if ((flags & NLM_F_DUMP) == NLM_F_DUMP) /* DUMP is 2 bits */
> > > +		flags &= ~NLM_F_DUMP;  
> > 
> > no bail out for incorrectly set NLM_F_DUMP flag?
> 
> Incorrectly? Special handling is because we want to make sure both bits
> are set for DUMP, if they are not we'll not clear them here and the
> condition below will fire. Or do you mean some other incorrectness?

I have seen software in the past setting only one of the bits in the
NLM_F_DUMP bitmask to request a dump. I agree that userspace software
relying in broken semantics and that software should be fixed. What I
am discussing if silently clearing the 2 bits is the best approach.
