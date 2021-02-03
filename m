Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5383130D256
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232106AbhBCEIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhBCEIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 23:08:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D70BA64E39;
        Wed,  3 Feb 2021 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612325283;
        bh=mM8PUf9vnb9XiXIyXHiynHGsnBG5LTqxupOOthfJb0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=biKFQ0ozbRcWYcWPZlTvrJZ77TH0YXITtZFqnPWyjExYUeGx2WKMR39jdDMgB6BGD
         jJN0RfwUc34Mm/D1HlObvYIlBLDM8CUspPT3wQxEiSCk2VGEGpzecYOuv4UM6FErJv
         A/xhchMfMlriovlDjGGB3yt7RNg868WVQi7zZuazu2+xpTNqFkpP8evXhVkveaLpTF
         6ouZiozaq/XXlHLVhCMhWepmqIZGxbTbFVmWSC9uAAPJx4n1RBGU7OUySXgN055g7p
         Lh7GM6hvl5cWy9h46mbnolIE9SpNm0ozqPznVsNTruvJL7fUy0DiKcyXSCmebgu/w/
         tkVxz8aZhrp4w==
Date:   Tue, 2 Feb 2021 20:08:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/7] net: ipa: don't disable NAPI in suspend
Message-ID: <20210202200802.49c5d7a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-LerEd9ZyLSFOaW3JqjvWUrp5L0jVvyuJU56atmT=G1oQ@mail.gmail.com>
References: <20210201172850.2221624-1-elder@linaro.org>
        <CAF=yD-LerEd9ZyLSFOaW3JqjvWUrp5L0jVvyuJU56atmT=G1oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 13:44:20 -0500 Willem de Bruijn wrote:
> On Mon, Feb 1, 2021 at 12:28 PM Alex Elder <elder@linaro.org> wrote:
> >
> > This is version 2 of a series that reworks the order in which things
> > happen during channel stop and suspend (and start and resume), in
> > order to address a hang that has been observed during suspend.
> > The introductory message on the first version of the series gave
> > some history which is omitted here.
> >
> > The end result of this series is that we only enable NAPI and the
> > I/O completion interrupt on a channel when we start the channel for
> > the first time.  And we only disable them when stopping the channel
> > "for good."  In other words, NAPI and the completion interrupt
> > remain enabled while a channel is stopped for suspend.
> >
> > One comment on version 1 of the series suggested *not* returning
> > early on success in a function, instead having both success and
> > error paths return from the same point at the end of the function
> > block.  This has been addressed in this version.
> >
> > In addition, this version consolidates things a little bit, but the
> > net result of the series is exactly the same as version 1 (with the
> > exception of the return fix mentioned above).
> >
> > First, patch 6 in the first version was a small step to make patch 7
> > easier to understand.  The two have been combined now.
> >
> > Second, previous version moved (and for suspend/resume, eliminated)
> > I/O completion interrupt and NAPI disable/enable control in separate
> > steps (patches).  Now both are moved around together in patch 5 and
> > 6, which eliminates the need for the final (NAPI-only) patch.
>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied, thanks!
