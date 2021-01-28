Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8B7306BE9
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 05:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhA1EHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 23:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhA1EGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 23:06:35 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B138C0617A9
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:52:58 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id by1so5804730ejc.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 19:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+O2qMiPa6DUHQGJGAVdYPz1g1ToZM+iWzcVRsrY0Xi8=;
        b=cWVeFbmTHgO16wYgh40uSg+31tascuZOZGOnAVpdbRi9aI/sw1iSNSjNGZlY4fZrHI
         Yr/cjYT6LahUKE4PZ/ukO5cBl32ntZ1Nj2Usso+D7lateBQZkMOOvUKzggpEjrsZbVSt
         p6qFA7TycMwqn/IsSqvCB2nh7lzVpaM/bPqGmayDPbHbmvvKG2yhWXgLzOlfK4WjotTC
         RylAk5xck6CSApCMP8OHFiqcFTTfYaMTXEXqz80EfLXTpbgAm9Im5cugb3EvTNA5r4bT
         m/rKxQ1qYCHWx/xV/9cSaInXcxQTWnJKKR2l7q0P/7faYgVLJWyh0mHJSswcuqaFPfCM
         +pyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+O2qMiPa6DUHQGJGAVdYPz1g1ToZM+iWzcVRsrY0Xi8=;
        b=pGWuRmv95/jh1mMSgrIaXXPRAUv4XfcP3VBgGx6Po5LX986eCGxTV7VS9luOWmkf3m
         epqrZ8IFaahoPTffcxY3wi8p1FvscbUFSjyo3s09opnI2BJ4OPuBUKqHI/cjQjd2dvxO
         shTb0bFaBTvZfbGpJeTKXxjQUrtxbXOnlnCTJjGFFsBYb3ze3H784uhUh4BQZWLU6ojE
         ZwLQGq3g9IQCxArrNqyMulQmwbmGGX+Gbt3aBGyCoDlosnI8mn4lnAkqfGGa3kXJBCsH
         rG1hA3rRUL27HOsuS/W6I891maK024JeMuBJuiJN+4zx33V1auvgIYcj2LR6CUTQ9LN4
         N8Ow==
X-Gm-Message-State: AOAM533yMHwAZZifiNkNC4Yv6E4fOdcVXogfJLDj1GivykgtX1GQjFh7
        324zFfpMxyvpIrN1W6Q4sK3jokf0SfFO45zNMr7m
X-Google-Smtp-Source: ABdhPJzTganDrHuz8JhcC1ya1QviFsDqnAscuVEhbF7bZ5b0uFePTtg2FCy+ZiWVARQ6EkK0Zu2XAwYNJMdtwF0Ttcg=
X-Received: by 2002:a17:907:1629:: with SMTP id hb41mr8917531ejc.197.1611805976826;
 Wed, 27 Jan 2021 19:52:56 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-2-xieyongji@bytedance.com>
 <e8a2cc15-80f5-01e0-75ec-ea6281fda0eb@redhat.com> <CACycT3sN0+dg-NubAK+N-DWf3UDXwWh=RyRX-qC9fwdg3QaLWA@mail.gmail.com>
 <6a5f0186-c2e3-4603-9826-50d5c68a3fda@redhat.com> <CACycT3sqDgccOfNcY_FNcHDqJ2DeMbigdFuHYm9DxWWMjkL7CQ@mail.gmail.com>
 <b5c9f2d4-5b95-4552-3886-f5cbcb7de232@redhat.com>
In-Reply-To: <b5c9f2d4-5b95-4552-3886-f5cbcb7de232@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 28 Jan 2021 11:52:45 +0800
Message-ID: <CACycT3u6Ayf_X8Mv4EvF+B=B4OzFSK8ygvJMRnO6CDgYF13Qnw@mail.gmail.com>
Subject: Re: Re: [RFC v3 01/11] eventfd: track eventfd_signal() recursion
 depth separately in different cases
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/27 =E4=B8=8B=E5=8D=885:11, Yongji Xie wrote:
> > On Wed, Jan 27, 2021 at 11:38 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> On 2021/1/20 =E4=B8=8B=E5=8D=882:52, Yongji Xie wrote:
> >>> On Wed, Jan 20, 2021 at 12:24 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>> On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> >>>>> Now we have a global percpu counter to limit the recursion depth
> >>>>> of eventfd_signal(). This can avoid deadlock or stack overflow.
> >>>>> But in stack overflow case, it should be OK to increase the
> >>>>> recursion depth if needed. So we add a percpu counter in eventfd_ct=
x
> >>>>> to limit the recursion depth for deadlock case. Then it could be
> >>>>> fine to increase the global percpu counter later.
> >>>> I wonder whether or not it's worth to introduce percpu for each even=
tfd.
> >>>>
> >>>> How about simply check if eventfd_signal_count() is greater than 2?
> >>>>
> >>> It can't avoid deadlock in this way.
> >>
> >> I may miss something but the count is to avoid recursive eventfd call.
> >> So for VDUSE what we suffers is e.g the interrupt injection path:
> >>
> >> userspace write IRQFD -> vq->cb() -> another IRQFD.
> >>
> >> It looks like increasing EVENTFD_WAKEUP_DEPTH should be sufficient?
> >>
> > Actually I mean the deadlock described in commit f0b493e ("io_uring:
> > prevent potential eventfd recursion on poll"). It can break this bug
> > fix if we just increase EVENTFD_WAKEUP_DEPTH.
>
>
> Ok, so can wait do something similar in that commit? (using async stuffs
> like wq).
>

We can do that. But it will reduce the performance. Because the
eventfd recursion will be triggered every time kvm kick eventfd in
vhost-vdpa cases:

KVM write KICKFD -> ops->kick_vq -> VDUSE write KICKFD

Thanks,
Yongji
