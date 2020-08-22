Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B410224E969
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgHVThB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728640AbgHVTg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:36:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28750C061574
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:36:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f18so3421041wmc.0
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tfz-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D2UpM4JiRz3DSJbLEVUit3CMbJBOHMsg2oZwhaPpIVA=;
        b=mE1R29cUE7e5dkG7Erf7qXQPY5FC1XBoN3dQ3DNlq6pOwtQs2QA/HXJg+Dgi5aOmH0
         eukcJ8ZutRhpaQncdPJv6JPb+cI8dUgxhZOl7G7h/+GRuyQAtNLkf8bbjBOFeimdSOEw
         OaSqA1PNnbdqb/ubLToV2eloOntz6ZLCiKy70oadVyFZ6JzY3sG06ZyzadCo2EyeY4nG
         3JyI0xU5lcq7UK77Ay6zWGuRPL+JSUd8q02b2LvB8p3d4NzD1i5DxjlxVKlcNoBjBOzM
         VtysgUcFhUiCjFFRHWw5qkE45NrxOCH/R44dGkF6SqKuKXiIW/RNpcd0ktK642yGEniJ
         kzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D2UpM4JiRz3DSJbLEVUit3CMbJBOHMsg2oZwhaPpIVA=;
        b=lGf18WlywJJQmo8kmw6IYDofcOOyJcSQELp+xX8TGVZJ8NPC8H55GzSVDB+r4gVJky
         tWEPL+l5m3z+wrLYFkYDgpzyOpDrRI/aTuB7qeBfI/4I7/uGMAX/GURmq73bm6Iuvqlq
         fK+MxBVsnGkC6XvYx9bJzxcX5+7FLYRD74BZMJ/4Fd255C6EeAlhjgkg20RLz4Wtfdll
         7kuZUsalp5pg8jhNPYNtUzun7/VqiH1aTOOL+S2Q+Y7T8dSj5a4wterbbZQCfQY+zn2s
         O8u3gbEtsTyV/IdRsCgD+KQoI0aMeI5zxf0BuNGYInJW2eTkqHORjcOzCxPxQIiF4mHb
         X3ng==
X-Gm-Message-State: AOAM533mVRh/vGNZ7n6qHNZe7z8QYdesdq2SE5MIEUiy33vxVqYnSFll
        l2pZyPxTbNZHmBEVQH3gd0oqodtFX+gxk6duwGUC7w==
X-Google-Smtp-Source: ABdhPJw1FjXS8okxIasqbI2eFqqO4wV94l6O3Rxxnnk5P/VzZuRcNZ/6J3YlyMeLV+ABXrCSAZNjs+lqNalSNkMLC0c=
X-Received: by 2002:a7b:c15a:: with SMTP id z26mr8502959wmi.35.1598125014765;
 Sat, 22 Aug 2020 12:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200815182344.7469-1-kalou@tfz.net> <20200822032827.6386-1-kalou@tfz.net>
 <20200821205154.365e230dbf6f2b93a47443c4@linux-foundation.org>
In-Reply-To: <20200821205154.365e230dbf6f2b93a47443c4@linux-foundation.org>
From:   Pascal Bouchareine <kalou@tfz.net>
Date:   Sat, 22 Aug 2020 12:36:44 -0700
Message-ID: <CAGbU3_=K4aEhsc6kFyJC7PQSieTzH6=6-FVKUcBdogpFvuCJJw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: add GFP mask param to strndup_user
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for taking a look!

On Fri, Aug 21, 2020 at 8:51 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> Why change all existing callsites so that one callsite can pass in a
> different gfp_t?

My initial thought was to change strndup_user to use
GFP_KERNEL_ACCOUNT (or GFP_USER | __GFP_ACCOUNT ?) unconditionally.

(Would that work? that would be a simpler change for sure)

In the case it was not wanted, I assumed a good proportion of callers
might do the same on a case-by-case basis (esp. with regards to
enabling accounting).

> Also...
>
> why does strndup_user() use GFP_USER?  Nobody will be mapping the
> resulting strings into user pagetables (will they?).  This was done by
> Al's 6c2c97a24f096e32, which doesn't have a changelog :(

FWIW, I believe related to this: https://lkml.org/lkml/2018/1/6/333

It's a bit over my head (is GFP_USER cheaper?) if strndup_user needs
to follow memdup_user

> In [patch 2/2],
>
> +       desc = strndup_user(user_desc, SK_MAX_DESC_SIZE, GFP_KERNEL_ACCOUNT);
>
> if GFP_USER is legit then shouldn't this be GFP_USER_ACCOUNT (ie,
> GFP_USER|__GFP_ACCOUNT)?

Yes! I'll see clearer if I manage to wrap my head around what
strndup_user should do
Thanks!
