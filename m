Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4242FCB2A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbhATGqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbhATGp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 01:45:28 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8569EC061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 22:44:47 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h16so24428647edt.7
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 22:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=awHFENDHpSgXNCFvxRpb7rmLK90gRrgZnQPYnvBPgnc=;
        b=xV7eseVydqeNtWhSFSleOckNhm5fLNJabUt/tK2xayIYrcHZC9XFp4n8pMFlG3Y5xy
         w/IpPTE7BplvUlayXdODXrE6N+J3aEkcE6AhUVusF2ooHUTMG7HTxMBn2ZbJ7AafLA53
         i8oM4kBlqJx5RPo/GDX2RfvIQUCoUVMwNO9+Sd6a2d5DiDuEnuHA8T+yXcjehEi8+rEZ
         30WBCJegSPciZTd5MK/fcmQqTfY9lXXEC9jo/dhI+H73P+PoJHu2gwGH65UVrDnM++Q7
         t0xUYJmI4zghuucN6tzDr8RbgCJoaXQtvAbXY4hMo48ivs1aP5A73Xg79qAp4HSwzplJ
         PMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=awHFENDHpSgXNCFvxRpb7rmLK90gRrgZnQPYnvBPgnc=;
        b=gY3AsSuVIANCtpfKUqz3RBrnBTbTlPNSR/pALwXiJ5pQeXVhCFkLdI3pXJ1K/uqcvE
         kv4njvfWzC1hWaYT5aKERPUm3Xohd43yVyasfPb2arlgTYJKDkZkTCN05KO2E+oZIlS3
         h2ApXxJcNSkYYpVvXAHmttcrd8cmxInvhDib22sLpl+TKZXhCafjqQS303KKIyaz/YoE
         8G7TMDKuWBIBcAkun3ieeeQtt7h9gbSYOF2kQGdEvfDZVA2iqQNZ7YSzEj8BkwQBFYSx
         V8MRH4G5ofeYCaJfyEgFNWgusY+AQgy2qnWnX9qgFOrKzo+mLB5vOWkTOAxcK9E6T9PC
         a6dg==
X-Gm-Message-State: AOAM531wppo7vVKmcrEYOAQ+NqMKJHenLAshRyMlrKRpoKsWeAJ/LCCP
        3TyBU/P3DBHBNVqL99+njn7P7tGzlzRfxcPZdOW6
X-Google-Smtp-Source: ABdhPJx0sMXnqlQ8lzSp/rChsvvxS/AZYoGtK+bkAoS67Se/guN/SdAuI3TVMPEKXrD0Ab3nmellLx0Sza0G3TU7i8Y=
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr6275234edc.344.1611125086314;
 Tue, 19 Jan 2021 22:44:46 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-5-xieyongji@bytedance.com>
 <8fbcb4c3-a09a-a00a-97e2-dde0a03be5a9@redhat.com>
In-Reply-To: <8fbcb4c3-a09a-a00a-97e2-dde0a03be5a9@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 20 Jan 2021 14:44:35 +0800
Message-ID: <CACycT3vxi-Rkaixdd7Wa6t0ELXHgPJDLp6nwFYkXbr7kFrhyCA@mail.gmail.com>
Subject: Re: Re: [RFC v3 04/11] vhost-vdpa: protect concurrent access to vhost
 device iotlb
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
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

On Wed, Jan 20, 2021 at 11:44 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> > Introduce a mutex to protect vhost device iotlb from
> > concurrent access.
> >
> > Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vhost/vdpa.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 448be7875b6d..4a241d380c40 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -49,6 +49,7 @@ struct vhost_vdpa {
> >       struct eventfd_ctx *config_ctx;
> >       int in_batch;
> >       struct vdpa_iova_range range;
> > +     struct mutex mutex;
>
>
> Let's use the device mutex like what vhost_process_iotlb_msg() did.
>

Looks fine.

Thanks,
Yongji
