Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171B62A11E6
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgJaAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJaAXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:23:37 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DCA206E5;
        Sat, 31 Oct 2020 00:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604103816;
        bh=6aqhK4+VyLP+Jj9NC+5tkFP07ND2dumnrgS+UH/ZD6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y7G1Y9XXEwB2xQ+SExz5Jeq+xZLQ8E7hm8kkbCvEnzk7Aw1FqkSW+1ieBx4Lx/CON
         sZ1MWuKtK8R2EVYS1iaY6ZT2MUm8L1UeXFgC5uZnvC2tkGcEYr4+R66xSbD8oX4J+q
         jbj2YvodQ6ZUUiiATeBImSQrg6yJIUOSJpSEBTmY=
Date:   Fri, 30 Oct 2020 17:23:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 0/5] net: ipa: minor bug fixes
Message-ID: <20201030172335.38d39b47@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <2f62dbe1-a1b3-a5f9-8cba-82cd8061ff9b@linaro.org>
References: <20201028194148.6659-1-elder@linaro.org>
        <20201029091137.1ea13ecb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <2f62dbe1-a1b3-a5f9-8cba-82cd8061ff9b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 11:50:52 -0500 Alex Elder wrote:
> On 10/29/20 11:11 AM, Jakub Kicinski wrote:
> > On Wed, 28 Oct 2020 14:41:43 -0500 Alex Elder wrote:  
> >> This series fixes several bugs.  They are minor, in that the code
> >> currently works on supported platforms even without these patches
> >> applied, but they're bugs nevertheless and should be fixed.  
> > 
> > By which you mean "it seems to work just fine most of the time" or "the
> > current code does not exercise this paths/functionally these bugs don't
> > matter for current platforms".  
> 
> The latter, although for patch 3 I'm not 100% sure.
> 
> Case by case:
> Patch 1:
>    It works.  I inquired what the consequence of passing this
>    wrong buffer pointer was, and for the way we are using IPA
>    it seems it's fine--the memory pointer we were assigning is
>    not used, so it's OK.  But we're assigning the wrong pointer.
> Patch 2:
>    It works.  Even though the bit field is 1 bit wide (not two)
>    we never actually write a value greater than 1, so we don't
>    cause a problem.  But the definition is incorrect.
> Patch 3:
>    It works, but on the SDM845 we should be assigning the endpoints
>    to use resource group 1 (they are 0 by default).  The way we
>    currently use this upstream we don't have other endpoints
>    competing for resources, so I think this is fine.  SC7180 we
>    will assign endpoints to resource group 0, which is the default.
> Patch 4:
>    It works.  This is like patch 2; we define the number of these
>    things incorrectly, but the way we currently use them we never
>    exceed the limit in a broken way.
> Patch 5:
>    It works.  The maximum number of supported groups is even,
>    and if a (smaller) odd number are used the remainder are
>    programmed with 0, which is appropriate for undefined
>    fields.
> 
> If you have any concerns about back-porting these fixes I
> think I'm comfortable posting them for net-next instead.
> I debated that before sending them out.  Please request that
> if it's what you think would be best.

Looks like these patches apply cleanly to net-next, so I put them there.

Thanks!
