Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9232F4820
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbhAMJ6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbhAMJ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:58:29 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D46C061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 01:57:49 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u17so2937502iow.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 01:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n1jNxtfMTustTuQZ5M9CizfRNm12PLqLOtR5vdWeND8=;
        b=sZhh00eUlpX7LCLIOZdPiz5+2kspcUOxu1y3RvLTATlXu0TETWvxSoN8ynAIHMlYGz
         GjN+bMNgnaUE7y/J2B10gNp1xFV8MKrJt7WuDqfYss7armoKaIDU36ozmZbZOuffVZUM
         TeWgr6RhR+REbmIe8InXaV5ubUa6MuPIU01uQgf2uH7zFqTX6vHpSApiZ9PiMMOw8lWx
         hNzdshqthntPQGmeD/rDsruEKe6oq/JbEgaS/g2Rzg+H3QU5VmMzwtEFMiwq4rKk8Eaq
         fUOrP1yiisz7/bB7H4XkMtFOnLcNqomPTr9Dv7/tkHMxi5pMZG1YDQ4CXyAriAP5bk20
         JNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n1jNxtfMTustTuQZ5M9CizfRNm12PLqLOtR5vdWeND8=;
        b=eLwn5VeswhKGjxrTc+ap0xyXZGoocWOswu73ln349mXUI7jH3uzZPJ++MJF79Y+0dK
         Gwe1dggmPbO2mTrzxyXKxAaNTovkOttyn6NSe2TdMFhXOKx1hDgAKfnV3b/VRUNj5bAU
         EOVkNgXUyC1CmwHJiY1+18pOapfMtsX71IvzsaskVaTbPxuGK3N7H0A2qk34qJhbCrk7
         7PKOxMyeA3lOOAjuPVI8FSTh95+4TCPP2SMfB8Jcp+geuFo42bHaPdF4UKw4UUtZOkqY
         gMHpq+x8JfOVqU62kgjTjv+7WcGH+gKPUjdXsd2u6xi4sK7F7tujbNOFDejhRhmtUwDP
         KM8g==
X-Gm-Message-State: AOAM532GjzaUlzxQH5Rk2vODKG1g3KgQdbtGvbO42lhTpdMME7xhofNx
        1XTMEopSmYt8f8bg7dDxQ6O9Z2fvyY+7KUTO9ytG1BBn7Mo=
X-Google-Smtp-Source: ABdhPJxQGPEKGxIdAnp/QR9uBe64NTMnoeDYUmuRWeoNbRYo25BS8fZ5GFt7rcszie//xZ/bMl1EsGuRhpGvKoqOSaA=
X-Received: by 2002:a92:9153:: with SMTP id t80mr1651676ild.216.1610531868249;
 Wed, 13 Jan 2021 01:57:48 -0800 (PST)
MIME-Version: 1.0
References: <20210113051207.142711-1-eric.dumazet@gmail.com> <20210113043722-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210113043722-mutt-send-email-mst@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Jan 2021 10:57:36 +0100
Message-ID: <CANn89iKeggsJuHPvxCU5QLwr_5=pmntQYtpm+csdkOJ5Gps89w@mail.gmail.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace netdev_alloc_skb_ip_align()
 with napi_alloc_skb()"
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 10:53 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jan 12, 2021 at 09:12:07PM -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > This reverts commit c67f5db82027ba6d2ea4ac9176bc45996a03ae6a.
> >
> > While using page fragments instead of a kmalloc backed skb->head might give
> > a small performance improvement in some cases, there is a huge risk of
> > memory use under estimation.
> >
> > GOOD_COPY_LEN is 128 bytes. This means that we need a small amount
> > of memory to hold the headers and struct skb_shared_info
> >
> > Yet, napi_alloc_skb() might use a whole 32KB page (or 64KB on PowerPc)
> > for long lived incoming TCP packets.
> >
> > We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> > but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
>
> Are you using virtio on the host then? Is this with a hardware virtio
> device? These do exist, guest is just more common, so I wanted to
> make sure this is not a mistake.
>
> > Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> > would still be there on arches with PAGE_SIZE >= 32768
> >
> > Using alloc_skb() and thus standard kmallloc() for skb->head allocations
> > will get the benefit of letting other objects in each page being independently
> > used by other skbs, regardless of the lifetime.
> >
> > Note that a similar problem exists for skbs allocated from napi_get_frags(),
> > this is handled in a separate patch.
> >
> > I would like to thank Greg Thelen for his precious help on this matter,
> > analysing crash dumps is always a time consuming task.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Greg Thelen <gthelen@google.com>
>
> Just curious - is the way virtio used napi_alloc_skb wrong somehow?
>
> The idea was to benefit from better batching and less play with irq save
> ...
>
> It would be helpful to improve the comments for napi_alloc_skb
> to make it clearer how to use it correctly.
>
> Are other uses of napi_alloc_skb ok?

Yeah, as I mentioned already, the real problem lies in use of
fragments for skb->head in general,
especially for small buffers.

It is too dangerous to use 32KB pages to allocate ~1KB buffers.

I am working on it.
