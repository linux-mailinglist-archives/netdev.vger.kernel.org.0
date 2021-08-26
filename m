Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333643F8EBD
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 21:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243424AbhHZTdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 15:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhHZTdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 15:33:13 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A41DC061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:32:26 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k78so4783932ybf.10
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 12:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZI+OhT1MCQG9gG7q/7ArwxyXn3un7FGoyfSjHaTyhOM=;
        b=kQX+oQq/Sp6COd3yQxHmFpgYnV2mBIe3iFdwshg3RmcerJoXOm3x2dj67RLn7x6evr
         EGdWQCShPe6dRwc6H03Ci6KF/5a4HTfBzvoSFuCG4jPQRL8utzEnLal1yYoFl/PgViKO
         beGJJwFGVjWUeE93Irsu14xtpZFhoDnC2mDxRMjHZKnnEJ9bkZrrLu3A5sHh81k2D7wD
         jatiexbWuhdk1FS/0yJ7P472kEFQShZ6bCMoVgLNnJP00oJdP1DujadUC39RWRjajg5O
         YNhqVq5ouF075W37nBJ6eDsyHCSB2pIjsJ4kcCNAnV4YgeUY7neWcWY8N5xmy6Tf89tK
         E/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZI+OhT1MCQG9gG7q/7ArwxyXn3un7FGoyfSjHaTyhOM=;
        b=nX/oErfA4nqO7wYEQ0iz276p54Z1nIxkYwQu8IHaY2ifqPx3GrbjvduDwmlRJI7xmq
         Hhto6aGHOwPVgQh18o9M3cB8EyPtxHqgA29bxespfDKYG6MIb5KS9Ik9IV4P/E4YHfRX
         juTfbbVml+KF0UK/9b6Ze+HZkjQRM6DkVZDgQSaUMQCf7KLLSnZH2RzDGwR0e0kq3pBv
         c1JkKfUGTQRnLas/AtcfilTx+9rMlG5Vi9jvGJoyPBThg44Py/KTzRGwDLwXb3d+Wsz3
         sAQjJDYOP/7SbMIbSLcv9HUBpAlwftn8oAbYSwfFW56eQeFQ3UMXMOtyMRubdDRadDMy
         gU3g==
X-Gm-Message-State: AOAM531hXLfk1GXrkOFLL2SeaXup16pa9mvdQwOmfajr1vyxMMeCky/l
        QyYhObSWt9MzqzjDnJaXg6kuDX12xJuyW65hSkiafw==
X-Google-Smtp-Source: ABdhPJyqEenXlfYJzBebRhDWMkfwqhU7ttEThoWeek253raKCqq7OZ9wIanc9YkQ1JY3S8iEq2DyxHNdd+9RHQJftdg=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr434028ybj.504.1630006345164;
 Thu, 26 Aug 2021 12:32:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210825210117.1668371-1-ntspring@fb.com> <CAK6E8=cB=XA25CYftOvUYR+8euEZC=iU8-JY79v45qghY0vtXg@mail.gmail.com>
In-Reply-To: <CAK6E8=cB=XA25CYftOvUYR+8euEZC=iU8-JY79v45qghY0vtXg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 26 Aug 2021 12:32:15 -0700
Message-ID: <CANn89iL+nob7ipXSmbyv0PrWfvq6hRtQJnTG=L6cvbdAx-C+4w@mail.gmail.com>
Subject: Re: [PATCH net-next v3] tcp: enable mid stream window clamp
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Neil Spring <ntspring@fb.com>, David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 12:11 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Wed, Aug 25, 2021 at 2:02 PM Neil Spring <ntspring@fb.com> wrote:
> >
> > The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the size
> > of the advertised window to this value."  Window clamping is distributed
> > across two variables, window_clamp ("Maximal window to advertise" in
> > tcp.h) and rcv_ssthresh ("Current window clamp").
> >
> > This patch updates the function where the window clamp is set to also
> > reduce the current window clamp, rcv_sshthresh, if needed.  With this,
> > setting the TCP_WINDOW_CLAMP option has the documented effect of limiting
> > the window.
> This patch looks like a bug-fix so it should be applied to net not net-next?

It seems TCP_WINDOW_CLAMP never worked in this context, not sure
if any application was expecting it to work.

Note that if we target net tree, we would like a Fixes: tag.

I will give my SOB a bit later in the day, I have to run some errands.

Thanks.
