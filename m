Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC792E3192
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 15:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgL0OlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 09:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgL0OlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 09:41:04 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C89C061794
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 06:40:24 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cm17so7643637edb.4
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 06:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GgQW8GUePvvLbxLOBIAlSRCdN+m+qNFa+08R/NG/XIo=;
        b=X6gCEWNWlreqYvTVp8aWGebhelqynrqk1k9WslpPxooaLzeqVjaKc0tqpxGPh5PYeM
         2Sf3LPv0SDNtO50exC5nbgj1JBkp2q8vf7N9unZEMDa7Y0sza4pGSEo+AjavT0+eEqDN
         YjNizqNJ3ayC8cvKAh6XmADnZzRLMdlQYhxluvS5MMegPQushGktutI7wN9ivQxdHskZ
         aalJbCUrXg6azjTcP962mOTglWZk/x/wJCoQ/xfP2KlzWwqFwhGVis2qTC6VoKc27lZe
         tvPjRMkR6NAotBsVXfqiavdxgoDHdp1Nog50KdlvW8VTnyJ946JjYqYA5rQSyFNGl6i8
         uwaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GgQW8GUePvvLbxLOBIAlSRCdN+m+qNFa+08R/NG/XIo=;
        b=Zrtcp9jTVeqSgonFSDYqulCF8latJHlUlSjG24drlek9JvhHSZq/mkrze9IEGkwnlR
         nzxrLOibQnWTLhWwFxSuFmxyPtA82CgjAVS+Sn1u+fqtNAE13rv2iQDc4VfHfl8xXTuP
         oVLws/MeSeR7bjROnj2OTuvIgdnLBfnOTud9XNBvBu4vlZPikJD+KHsV5oThitjMOjyy
         JrYUVxw2QFbVcp0KPlZEOe6OMFH6KdOb+MJ0KZSV4UTI4VfaeNEeJPQqauXtMupeqcNX
         03XaezbhWm28JjomIGJzuOwW8Br/MnwCu6GWEY9nbF0VNziVHFU+TGX4FlzUtZGDMHvx
         jplg==
X-Gm-Message-State: AOAM5330qpiCcVsCiewtp+ejFSNAN+d7aljIy2MS4p9AfNIQdDTgSoWQ
        UWk0Y0tJXvY8AoFRyA4dOZl2snz1ZFcCXzMkNcW3J5Im0QTMcg==
X-Google-Smtp-Source: ABdhPJzI8Og1fe0ZdqyU00tCiB/s1KPvzS9PbMCT35t7NlKnMb9daqk47SgVXw8IwPAdLFiwZnAuZGan6jG2qea9DJA=
X-Received: by 2002:a50:ab51:: with SMTP id t17mr38856015edc.89.1609080022719;
 Sun, 27 Dec 2020 06:40:22 -0800 (PST)
MIME-Version: 1.0
References: <20201223165250.14505-1-ap420073@gmail.com> <CAM_iQpW_Mc4HzjtVt+AmfPYEJhafVmxwsW_ZVuLVvG0kRCAufg@mail.gmail.com>
In-Reply-To: <CAM_iQpW_Mc4HzjtVt+AmfPYEJhafVmxwsW_ZVuLVvG0kRCAufg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 27 Dec 2020 23:40:11 +0900
Message-ID: <CAMArcTWCY49YxbVnYjWxH=e+J+oFVjXQ1cJKxLorULXYw-c=+Q@mail.gmail.com>
Subject: Re: [PATCH net] mld: fix panic in mld_newpack()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Dec 2020 at 04:27, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>

Hi Cong,
Thank you so much for the review!

> On Wed, Dec 23, 2020 at 8:55 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > mld_newpack() doesn't allow to allocate high order page,
> > just order-0 allocation is allowed.
> > If headroom size is too large, a kernel panic could occur in skb_put().
> ...
> > Allowing high order page allocation could fix this problem.
> >
> > Fixes: 72e09ad107e7 ("ipv6: avoid high order allocations")
>
> So you just revert this commit which fixes another issue. ;)
>

Yes, This patch is actually to revert 72e09ad107e7 commit.
But I found conflict while I do "git revert". so I just sent a normal patch :)

> How about changing timers to delayed works so that we can
> make both sides happy? It is certainly much more work, but
> looks worthy of it.
>

Thank you so much for your advice!
But I'm so sorry I didn't understand some points.

1. you said "both side" and I understand these as follows:
a) failure of allocation because of a high order and it is fixed
by 72e09ad107e7
b) kernel panic because of 72e09ad107e7
Are these two issues right?

2. So, as far as I understand your mention, these timers are
good to be changed to the delayed works And these timers are mca_timer,
mc_gq_timer, mc_ifc_timer, mc_dad_timer.
Do I understand your mention correctly?
If so, what is the benefit of it?
I, unfortunately, couldn't understand the relationship between changing
timers to the delayed works and these issues.

Could you please explain the above things again?

Thank you!
