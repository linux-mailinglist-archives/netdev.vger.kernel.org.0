Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D58360817
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 13:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhDOLRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 07:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhDOLRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 07:17:44 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F92C061756
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 04:17:20 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id n2so36251188ejy.7
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 04:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F2DnwbhM0K3eDbNV4OV/TxWIHc5j6rhfh7F0juu/TCM=;
        b=AcT1wLlEsw/hLOv9QVCK3pqYeHDLF0S+eaz51VVr8uYsXgRZeLZ8SX14FP/ssoFxXE
         R6WOrfa9wrzY/RDAiVI0Y7MTMehK81Ip1mxpyCwCO8ainJ4eo5vhUKUFAJGr/r//8Ucv
         uXcxtATK1evfslAqNE6cVpB533Rjx8jCplNXy5Fjlr/izCvWUUg9Nn0zB8bLmqdxWsOI
         yrUrsn1f9MY9c+lSCyv4m7uC3QRbsMlFqIu6BkNreQCZ7g/b7oHkU+qKKAPQlCAvz+5Q
         5J0MKHcBO86FfvBHtIqdT+lQSrFMUVPWqMO1WIMajZNbE3+mXiPRg5X8/oP0wfek+1uB
         WlSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F2DnwbhM0K3eDbNV4OV/TxWIHc5j6rhfh7F0juu/TCM=;
        b=VV9AcTXboikw4g0HcfvDjhSFJTqysh+lE7URM/iDnz9beNeiJOsxqgvlG8trd8VPmM
         h2H8fUYcvQh4AtuVbKBhWIeSeTzDgdWYCBaVqMblvc9msRwOkS/PXQ3sqEvvbqb2+uQR
         MmZh23R6ihwUEkSq4wQUjZxUDqvTZ9JLWZQ4i+KLwWNj0AtP1e1kWeBq4+sPBNLfL8ED
         ohTXM09FtdphbpRygPAf8Wua/kZUqZeuateu5r64DdOQTCxWujKKM+meP4PvsHQs1mq5
         43GlBmUczFFXv/M3zDNSVnOFd3jG1f9Ra5aLP0HC3aB4rIbukoapFO1Q/2htda9Nkxjr
         FUqg==
X-Gm-Message-State: AOAM530Mh17AWpi9kVkp85/F2Xa66N7ubNpay+QpKCEbXk3FJphgzPkv
        IdNeXJWxLg2Z0G09Rq3GxJ/C6wpI/Jue4QzRl2ac
X-Google-Smtp-Source: ABdhPJxIpQXfXBo/LLGFCyadIaJENXp32QQMzwuSrfXBhX4qR+8lwIcRxRI0FBc6gO1lL3MVnpwlBAcZljWAliGUbS8=
X-Received: by 2002:a17:906:2a16:: with SMTP id j22mr2886917eje.247.1618485439307;
 Thu, 15 Apr 2021 04:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain> <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com>
In-Reply-To: <02c19c22-13ea-ea97-d99b-71edfee0b703@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 15 Apr 2021 19:17:08 +0800
Message-ID: <CACycT3tL7URz3n-KhMAwYH+Sn1e1TSyfU+RKcc8jpPDJ7WcZ2w@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=884:36, Jason Wang =E5=86=99=E9=81=93=
:
> >>>
> >> Please state this explicitly at the start of the document. Existing
> >> interfaces like FUSE are designed to avoid trusting userspace.
> >
> >
> > There're some subtle difference here. VDUSE present a device to kernel
> > which means IOMMU is probably the only thing to prevent a malicous
> > device.
> >
> >
> >> Therefore
> >> people might think the same is the case here. It's critical that peopl=
e
> >> are aware of this before deploying VDUSE with virtio-vdpa.
> >>
> >> We should probably pause here and think about whether it's possible to
> >> avoid trusting userspace. Even if it takes some effort and costs some
> >> performance it would probably be worthwhile.
> >
> >
> > Since the bounce buffer is used the only attack surface is the
> > coherent area, if we want to enforce stronger isolation we need to use
> > shadow virtqueue (which is proposed in earlier version by me) in this
> > case. But I'm not sure it's worth to do that.
>
>
>
> So this reminds me the discussion in the end of last year. We need to
> make sure we don't suffer from the same issues for VDUSE at least
>
> https://yhbt.net/lore/all/c3629a27-3590-1d9f-211b-c0b7be152b32@redhat.com=
/T/#mc6b6e2343cbeffca68ca7a97e0f473aaa871c95b
>
> Or we can solve it at virtio level, e.g remember the dma address instead
> of depending on the addr in the descriptor ring
>

I might miss something. But VDUSE has recorded the dma address during
dma mapping, so we would not do bouncing if the addr/length is invalid
during dma unmapping. Is it enough?

Thanks,
Yongji
