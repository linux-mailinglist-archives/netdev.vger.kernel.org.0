Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3283F87E4
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbhHZMrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 08:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhHZMrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 08:47:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FC7C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 05:46:55 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d26so4966171wrc.0
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 05:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J/V57brLPYY5jnrdQPYr8fJbHXqMIzmot3eb2MxdirQ=;
        b=e547UDkHbCKDSq5a6G4DayKrhQEhriMF65O9/07W/2jykrstmJsiA2HbfBLuhx/Z+j
         ODXSjZAim1u+1iZ6qRENc/1eK5OWOmfEorXvkyha2TbY9iJjhNzY9w/4TAo9rRD+xDPB
         dbK2MNhvOPWMVswQqZTTDXONooQaKfLz50hU9fDZbQ2Y/RYGSo2fLGJXvHTdhb39y2UI
         Ba86/Ht4bKTrlfqFE8R/HlTjaO7xPcGqBVoa9mbIOxf5/1hrYeRdBmRXm3AyQv0ZwaiL
         M7UqKVeBMpAIvon28TtFziNif29Gt0l9Szb28OdNNOUIGX063H9XbCEtghhdqjYigb+R
         gj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J/V57brLPYY5jnrdQPYr8fJbHXqMIzmot3eb2MxdirQ=;
        b=AiiO0GdBFUwIEK6q3nQRO2Zqw/I033GezA/thCZNtMyTRjb4QBnBfE2eMtYe3IDC1H
         5LthjQ7AS/mJx7fyi5kVSeBrNgK80Esda6wyxCKdR0Q4RE5wmmZEMqbCj0lIlWXFJI8D
         ANwgfGp5ZQlTusfLRUiIK+4xmJjryqfvtrttRnUr1RSa4L0pZS3COH2hfMyAGIVhRXGw
         PXvnv/IozzzF6EKUvUVniVl5k2U6Cb0TVgou1Q6TiFEbE8wgC6xhz6EM8Qe1YPk5vKlm
         FKfEmXu1ILinki7B7d1bA6zFQ6RTlz3N2UiDyuzRswFWX7Vock0YVT5sW7xbTLfyQrmD
         /bXw==
X-Gm-Message-State: AOAM533JYwP24KPMXG2RFGghDHvKboqH525kWiGteWTOw0KUvsFNv9bb
        fC6wFh2xp5EuqaUyAaM87V8=
X-Google-Smtp-Source: ABdhPJxWVfqEiCKc0ff22174xwdGAkckheWHZt2cdF58X5fhWOYARZEzOI/4Y9cZWhjSzLvqOeT1dw==
X-Received: by 2002:a05:6000:1c4:: with SMTP id t4mr3766155wrx.414.1629982013617;
        Thu, 26 Aug 2021 05:46:53 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id q10sm2539644wmq.12.2021.08.26.05.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 05:46:53 -0700 (PDT)
Date:   Thu, 26 Aug 2021 15:46:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     michael.chan@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] bnxt: count discards due to memory
 allocation errors
Message-ID: <20210826124651.x2vbqgbc6irroaid@skbuf>
References: <20210825231830.2748915-1-kuba@kernel.org>
 <20210825231830.2748915-4-kuba@kernel.org>
 <20210826002257.yffn4cf2dtyr23q3@skbuf>
 <20210825173537.19351263@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210826004208.porufhkzwtc3zgny@skbuf>
 <20210825184451.2cf343c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825184451.2cf343c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 06:44:51PM -0700, Jakub Kicinski wrote:
> On Thu, 26 Aug 2021 03:42:08 +0300 Vladimir Oltean wrote:
> > On Wed, Aug 25, 2021 at 05:35:37PM -0700, Jakub Kicinski wrote:
> > > On Thu, 26 Aug 2021 03:22:57 +0300 Vladimir Oltean wrote:
> > > > 'Could you consider adding "driver" stats under RTM_GETSTATS,
> > > > or a similar new structured interface over ethtool?
> > > >
> > > > Looks like the statistic in question has pretty clear semantics,
> > > > and may be more broadly useful.'
> > >
> > > It's commonly reported per ring, I need for make a home for these
> > > first by adding that damn netlink queue API. It's my next project.
> > >
> > > I can drop the ethtool stat from this patch if you have a strong
> > > preference.
> >
> > I don't have any strong preference, far from it. What would you do if
> > you were reviewing somebody else's patch which made the same change?
>
> If someone else posted this patch I'd probably not complain, as I said
> there is no well suited API, and my knee jerk expectation was it should
> be reported in the per-queue API which doesn't exist.
>
> When you'd seem me complain is when drivers expose in -S stats which
> have proper APIs or when higher layer/common code is trying to piggy
> back on -S instead of creating its own structured interface.
>
> I don't see value in tracking this particular statistic in production
> settings, maybe that's also affecting my judgment here. But since
> that's the case I'll just drop it.
>
>
> If you have any feedback on my suggestions, reviews, comments etc.
> please do share on- or off-list at any time. No need to wait a year
> until I post a vaguely similar patch ;)

I don't know why you get the impression that "I waited a year until you
posted a vaguely similar patch". I am not following you, it just happens
that I was online and reading netdev when you posted this change now.
From the experience of threads that I directly participated in (and this
is why I dug up a DSA thread from a year ago, that was the one I could
find the quickest, again I am not watching your footsteps but
statistically speaking, it would be unlikely for the threads I
participated in to be the only ones where you've said this), you do seem
to tell people to try and use more "generic" and "structured" methods of
statistics reporting as opposed to putting everything in the plain
"ethtool -S", even if those methods don't exist or don't work for that
particular driver and would require major rework (like ndo_get_stats64
which is non-sleepable).

The 'driver stats under RTM_GETSTATS' was a direct quote exactly for
this reason. Now if this rx_oom_discards counter would be better expressed
as a generic 'driver counter' or a 'per-queue counter', none of which exist,
I don't know/don't care. I do wonder sometimes if you think about what
is the people's reaction when you tell them that ethtool -S is not fine
and they should use a kernel interface which doesn't exist, and I was
just curious to see what would yours be.

To create a new kernel interface for statistics would need not only the
vision, but also the passion and dedication to stick to those patches.
People will generally lack the desire to do that, because for better or
worse, "ethtool -S" is the central place to diagnose interface-level
problems. You've also expressed this clearer than words can say by
sending a patch to extend an interface you don't like.

In fact, my message seems to have hit quite the wrong way. I did not
want you to drop the counter from ethtool -S, please keep it if you want
it, but to sway you towards a more relaxed attitude when reviewing
patches for new counters added through that interface. Heck, I would
even like to resubmit the ethtool -S realloc counters if they had any
chance of getting accepted, it's not as if I had any serious intention
of extending the statistics reporting interfaces for something that minor.
