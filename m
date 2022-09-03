Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED145ABC66
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 04:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiICCn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 22:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiICCn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 22:43:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F01CF490F;
        Fri,  2 Sep 2022 19:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB4D162174;
        Sat,  3 Sep 2022 02:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23EBC433C1;
        Sat,  3 Sep 2022 02:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662173005;
        bh=v3RCRn1nqw5sKhkOzByGnzAzgt6LPwwlEgNDyNXkLA4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XDtUla1MRfqGIBwPmeb/itVYPlu5w9c4dywgti/8eYtQSrzrr9jacyjUTAq6HR4n+
         N4+5Llz7vtrSCJDFHJsrSY0TMh03m727iiqpT4YGjUbvnmVTBeet71nBCov7EdtJam
         lTrNMUom/cTm06J6kk5awGh6C4VoA8S9jGDFxVX9fPceAn6Eldm+zVU8bM4jJ/lNop
         J5YcDskBbrDR5/aOPt0Tk3iYw/cWGv+IgXY4D7wWQNXReI6LnbWPYEecngcFRmWETR
         qLlIniq2xKHCYfbtCOfEffDOqLId6F1323Azifs758H0fIVsuM1R8OH1yALF7X3KTR
         GPoYFeBeYzBCQ==
Date:   Fri, 2 Sep 2022 19:43:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net 1/4] netfilter: remove nf_conntrack_helper sysctl
 and modparam toggles
Message-ID: <20220902194323.5533a73f@kernel.org>
In-Reply-To: <20220902053928.GA5881@breakpoint.cc>
References: <20220901071238.3044-1-fw@strlen.de>
        <20220901071238.3044-2-fw@strlen.de>
        <20220901210715.00c7b4e1@kernel.org>
        <20220902053928.GA5881@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Sep 2022 07:39:28 +0200 Florian Westphal wrote:
> > From the description itself it's unclear why this is a part of a net PR.
> > Could you elucidate?  
> 
> Yes, there is improper checking in the irc dcc helper, its possible to
> trigger the 'please do dynamic port forward' from outside by embedding
> a 'DCC' in a PING request; if the client echos that back a expectation/
> port forward gets added.

I see, thanks!

> A fix for this will come in the next net PR, however, one part of the
> issue is that point-blank-autassign is problematic and that helpers
> should only be enabled for addresses that need it.
> 
> If you like I can resend the PR with an updated cover letter, or resend
> with the dcc helper fix included as well.

No need, I'll fold more of your explanation into the merge commit,
should be good enough.
