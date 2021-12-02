Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789C0466791
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241825AbhLBQJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:09:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241791AbhLBQJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:09:19 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467B4C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 08:05:56 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id d10so951854ybe.3
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 08:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PwTLQzcNtzCzTsoxZHvBgjnIaB41CA8BM1n+DiMncr0=;
        b=ovHBH4KpO2cDYGp4mfNs2ujOXOfd+gSMHZYI6XK9lyjRY9Bw94RkCzUBkIKKGlQyX5
         5PXUDvmP7wen84lJsT0oa+qR5seZHfkNsYz+SseRdJ38VC3K0IoWaZmwuGl0VPXM6wCJ
         lVX0lLqAkefAH2a3lnW5kfkjAA8M0UVuqjeAHaVafYkDorH+2OLxEzu993tdiDkIRF1l
         Xdyi8A08Pu+ah54kI9BVSW82AYmfr+l2oKWBkGQgR0czYddE9kc3pF/8phtmZIoYvHPv
         eIpYnfpv92G3LOHE+cL+HJQ8H5xi4XzIBlheIfIbD7NXM4HZveUvt3S+qWd4rYQOlKDn
         f9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PwTLQzcNtzCzTsoxZHvBgjnIaB41CA8BM1n+DiMncr0=;
        b=h6EPKjUymAH9992SjCrBGyJFzPgKH7c7bWZN6s/CFaV7AYQGSJpqNHipTE4N8LtPz3
         xFpHc0ZjjuhtBqirMODfyyQmVyW++TJs5LznvtH/Tm1RavZFGzQzyQlJtxx935AwZbF2
         IL+BMCn8arW+JSZgr6RBvyoYeJjo+tFK53/NzIJa8G3GB9p0APL7WQxTp5Em5hWH9NMn
         8/wMyjafvWyuaGxGYGliTlHKSTtadj5fZ6i5FQpojMLd07+WVb8u7/ZryOVW4hocD81L
         A6E5/Ymxw7IibPxqoHoVoTgrZnekQVDZVyxGDMcL6w5KP2odiwBd1tg2iJxlq6veseWr
         zz9w==
X-Gm-Message-State: AOAM530kXUG3+/a3EGucgFRorr5VLX9ioiln0wNr4yGiRXPQud6T+t9c
        6ER0w6zIv4tV7rvuFBzDlGc3h/Nep1NMCpx4pAp94Q==
X-Google-Smtp-Source: ABdhPJyysQJir/IGP8I/NZ06tX2hCzQjZHSsvIOdCbO9dE0rgPmNqoXvCIVQwdHiD3hxnv3VCFkEeFPyUBYcHkfwn/Y=
X-Received: by 2002:a25:760d:: with SMTP id r13mr17433346ybc.296.1638461155101;
 Thu, 02 Dec 2021 08:05:55 -0800 (PST)
MIME-Version: 1.0
References: <20211202032139.3156411-1-eric.dumazet@gmail.com>
 <20211202032139.3156411-2-eric.dumazet@gmail.com> <CACT4Y+ZUOZsuK84tiwWt62EFySAgVO0A2FnYyU5aBoxosSO9xA@mail.gmail.com>
In-Reply-To: <CACT4Y+ZUOZsuK84tiwWt62EFySAgVO0A2FnYyU5aBoxosSO9xA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 08:05:43 -0800
Message-ID: <CANn89iK5TYT=EiS7hMCVtOLk4P5F9wZCQYCkR+cTWUV7J4Ho_w@mail.gmail.com>
Subject: Re: [PATCH net-next 01/19] lib: add reference counting tracking infrastructure
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 12:13 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Thu, 2 Dec 2021 at 04:21, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > From: Eric Dumazet <edumazet@google.com>
> >
> > It can be hard to track where references are taken and released.
> >
> > In networking, we have annoying issues at device or netns dismantles,
> > and we had various proposals to ease root causing them.
> >
> > This patch adds new infrastructure pairing refcount increases
> > and decreases. This will self document code, because programmers
> > will have to associate increments/decrements.
> >
> > This is controled by CONFIG_REF_TRACKER which can be selected
> > by users of this feature.
> >
> > This adds both cpu and memory costs, and thus should probably be
> > used with care.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
>

Thanks !

> > +
> > +       if (!tracker) {
> > +               refcount_dec(&dir->untracked);
>
> Nice approach.

Yes, I found that a boolean was weak, we can do a full refcounted way,

Transition from 1 to 0 will generate a warning/stacktrace

>
> > +               return -EEXIST;
> > +       }
> > +       nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
> > +       nr_entries = filter_irq_stacks(entries, nr_entries);
>
> Marco sent a patch to do this as part of stack_depot_save() as we spoke:
> https://lore.kernel.org/lkml/20211130095727.2378739-1-elver@google.com/
> I am not sure in what order these patches will reach trees, but
> ultimately filter_irq_stacks() won't be needed here anymore...
>

Great, I will keep this in mind, thanks.
