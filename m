Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6086C3446EE
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 15:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhCVORt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 10:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230233AbhCVOR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 10:17:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 539DA6196C;
        Mon, 22 Mar 2021 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616422648;
        bh=bwSf3roiNZg1qwEarpE8pKI+u31TpiJ6uoP4/ITAco4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j471gm6KRKG0iyT25NnQfO/rGR5RTq1M1nsFTioML/MFtGOeVRt4D2tYNMXC2LDKt
         D4CFwvM1morpT2ykvcTbKsigqtquhjmR6gCC84LdRe1yt9HP1hM8fiQl6BWvFZ0QHc
         nnMOPjgpFMjYrAM6kOOnOrCKbw+xf8JAiGklpsnlLrprFl0nnPKU8KGBdjMc8iojU/
         z+0cJMuSaHtq9DvM1CZSs3X5WiRNBxv0IMtejJBiCaeXU3uILLRLdRwSFUAeMR1ly1
         VfBbN4wz34wXdMBPC3A2xXiVBuazAV4Lyv5lQSwlP8ctA1WfEGHZbd/+tx88XDLagB
         1FMgFm/oHF8Hw==
Date:   Mon, 22 Mar 2021 16:17:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: ipa: fix IPA validation
Message-ID: <YFim9CWuu45FcdcN@unreal>
References: <20210320141729.1956732-1-elder@linaro.org>
 <20210320141729.1956732-3-elder@linaro.org>
 <YFcCAr19ZXJ9vFQ5@unreal>
 <dd4619e2-f96a-122f-2cf6-ec19445c6a5c@linaro.org>
 <YFdO6UnWsm4DAkwc@unreal>
 <7bc3e7d7-d32f-1454-eecc-661b5dc61aeb@linaro.org>
 <YFg7yHUeYvQZt+/Z@unreal>
 <f152c274-6fe0-37a1-3723-330b7bfe249a@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f152c274-6fe0-37a1-3723-330b7bfe249a@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 08:17:59AM -0500, Alex Elder wrote:
> On 3/22/21 1:40 AM, Leon Romanovsky wrote:
> > > I'd like to suggest a plan so I can begin to make progress,
> > > but do so in a way you/others think is satisfactory.
> > > - I would first like to fix the existing bugs, namely that
> > >    if IPA_VALIDATION is defined there are build errors, and
> > >    that IPA_VALIDATION is not consistently used.  That is
> > >    this 2-patch series.
> > The thing is that IPA_VALIDATION is not defined in the upstream kernel.
> > There is nothing to be fixed in netdev repository
> > 
> > > - I assure you that my goal is to simplify the code that
> > >    does this sort of checking.  So here are some specific
> > >    things I can implement in the coming weeks toward that:
> > >      - Anything that can be checked at build time, will
> > >        be checked with BUILD_BUG_ON().
> > +1
> > 
> > >      - Anything checked with BUILD_BUG_ON() will*not*
> > >        be conditional.  I.e. it won't be inside an
> > >        #ifdef IPA_VALIDATION block.
> > >      - I will review all remaining VALIDATION code (which
> > >        can't--or can't always--be checked at build time),
> > >        If it looks prudent to make it*always*  be checked,
> > >        I will make it always be checked (not conditional
> > >        on IPA_VALIDATION).
> > +1
> > 
> > > The result should clearly separate checks that can be done
> > > at build time from those that can't.
> > > 
> > > And with what's left (especially on that third sub-bullet)
> > > I might have some better examples with which to argue
> > > for something different.  Or I might just concede that
> > > you were right all along.
> > I hope so.
> 
> I came up with a solution last night that I'm going to try
> to implement.  I will still do the things I mention above.
> 
> The solution is to create a user space tool inside the
> drivers/net/ipa directory that will link with the kernel
> source files and will perform all the basic one-time checks
> I want to make.

We are not talking about putting this tool in upstream repo, right?
If yes, please get buy-in from David/Jakub first.

Thanks
