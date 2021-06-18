Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1B23AC154
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 05:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhFRDbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 23:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbhFRDbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 23:31:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A86C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 20:29:31 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w21so6622098edv.3
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 20:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RMJgBEdiibhwSUyvuLKFkBrL4/U8fE/jxx04irYLGbA=;
        b=av/95B/MiI0xJSuNnIDSIou3GubtAy+v+Cj0IrEJ68VjpsLdRM7w3o1oORGPuxM9E9
         WcXBTXk69tPR+JRT9pirwPl1i4rEmPN+ROSzO+PpYUb6DGevaUs4cQChuJ9gWp9jybLU
         337xsWnlSDEFmVS8b9WCf45xojO+ucnKBtO3ThsQgErg6gNQGMsF1NJtWAQTA+IzuLEE
         lYIbqpRQcPEBixvBPRcSDXBPAnVFOEE11AW5zQ6nXaMHXzougZshHL3HBZOa0i1hhh2b
         I2Et2SNidVGS73kG8qlrW1IyTkcBNKTv++J6c5+xl/hwwNMONF8NwQMk+WXrJ33LwaNC
         opBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RMJgBEdiibhwSUyvuLKFkBrL4/U8fE/jxx04irYLGbA=;
        b=kRQQ9WkOs46BQf0GvT+rp96tQrt6FwLYBkXNtdPIBRywEFYq3QHO0iE+AVuNmDEkTX
         0AhpmOLuqVy+KiOShnpqBDehTEUt5DJR8LuGKSI9FY+FGoqvprOyQDIdnu4Lp+rwGg9F
         fgFR2ZTrM3g3laYZpGLbedxs7AMFK8KtHX0RvDD6jegYabfmtwVMCnWyM771mMz7Ma58
         Kgzj4UOJ1tRE0pWCRlktukrZhev7pZjouwSeED1DrUk5+1t7JNWPJeuGN+pKL8plkSx5
         a/0UzlZTHgL1w4cpdJl/lZ9t3vuDbo74CT5ZsSDNTOTF7y+mNvOqt8z/LdXY1lynnUZ+
         rsXA==
X-Gm-Message-State: AOAM531xIOrbtAvd15v7PvCxYpULRzSceEVqNMBmAItQl+yNI5d/qUm0
        +Mc8sVjeo8BEddsSQV7YXMIxEbODFmJx/YtYrM1F
X-Google-Smtp-Source: ABdhPJykGigJ4CmNJwWRgh5x2T6MNjBJPAc2OA16hTcBQrCjxSZwuj53EmfZdOWUW2UcDeCGl7ONh7uq9+Uou058YZU=
X-Received: by 2002:aa7:d9d3:: with SMTP id v19mr2042806eds.145.1623986969936;
 Thu, 17 Jun 2021 20:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-4-xieyongji@bytedance.com>
 <8aeac914-7602-7323-31bd-71015a26f74c@windriver.com>
In-Reply-To: <8aeac914-7602-7323-31bd-71015a26f74c@windriver.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 18 Jun 2021 11:29:19 +0800
Message-ID: <CACycT3t1Dgrzsr7LbBrDhRLDa3qZ85ZOgj9H7r1fqPi-kf7r6Q@mail.gmail.com>
Subject: Re: Re: [PATCH v8 03/10] eventfd: Increase the recursion depth of eventfd_signal()
To:     He Zhe <zhe.he@windriver.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qiang.zhang@windriver.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 4:34 PM He Zhe <zhe.he@windriver.com> wrote:
>
>
>
> On 6/15/21 10:13 PM, Xie Yongji wrote:
> > Increase the recursion depth of eventfd_signal() to 1. This
> > is the maximum recursion depth we have found so far, which
> > can be triggered with the following call chain:
> >
> >     kvm_io_bus_write                        [kvm]
> >       --> ioeventfd_write                   [kvm]
> >         --> eventfd_signal                  [eventfd]
> >           --> vhost_poll_wakeup             [vhost]
> >             --> vduse_vdpa_kick_vq          [vduse]
> >               --> eventfd_signal            [eventfd]
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
>
> The fix had been posted one year ago.
>
> https://lore.kernel.org/lkml/20200410114720.24838-1-zhe.he@windriver.com/
>

OK, so it seems to be a fix for the RT system if my understanding is
correct? Any reason why it's not merged? I'm happy to rebase my series
on your patch if you'd like to repost it.

BTW, I also notice another thread for this issue:

https://lore.kernel.org/linux-fsdevel/DM6PR11MB420291B550A10853403C7592FF349@DM6PR11MB4202.namprd11.prod.outlook.com/T/

>
> > ---
> >  fs/eventfd.c            | 2 +-
> >  include/linux/eventfd.h | 5 ++++-
> >  2 files changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/eventfd.c b/fs/eventfd.c
> > index e265b6dd4f34..cc7cd1dbedd3 100644
> > --- a/fs/eventfd.c
> > +++ b/fs/eventfd.c
> > @@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
> >        * it returns true, the eventfd_signal() call should be deferred to a
> >        * safe context.
> >        */
> > -     if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
> > +     if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
> >               return 0;
> >
> >       spin_lock_irqsave(&ctx->wqh.lock, flags);
> > diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
> > index fa0a524baed0..886d99cd38ef 100644
> > --- a/include/linux/eventfd.h
> > +++ b/include/linux/eventfd.h
> > @@ -29,6 +29,9 @@
> >  #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> >  #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> >
> > +/* Maximum recursion depth */
> > +#define EFD_WAKE_DEPTH 1
> > +
> >  struct eventfd_ctx;
> >  struct file;
> >
> > @@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
> >
> >  static inline bool eventfd_signal_count(void)
> >  {
> > -     return this_cpu_read(eventfd_wake_count);
> > +     return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;
>
> count is just count. How deep is acceptable should be put
> where eventfd_signal_count is called.
>

The return value of this function is boolean rather than integer.
Please see the comments in eventfd_signal():

"then it should check eventfd_signal_count() before calling this
function. If it returns true, the eventfd_signal() call should be
deferred to a safe context."

Thanks,
Yongji
