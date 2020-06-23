Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D301204A64
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbgFWHBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:01:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45282 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731276AbgFWHBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:01:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592895696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zy58zDIczPqYbbCU2I0rBDICf2p/vJOkTqkK2TZ8PAQ=;
        b=a/BcGEsJWnDpN1L/CQe/esfPC5/4bR7k18k//Ent0/sbaJDZbznMdGNBfmwfyzBkcDXFzy
        hAC8r2x60nKqPUAqI+NpVvSmCztawiShnkCUoHqvQkq3SXvGiNXHh6PWvAosDzZ79xGswF
        AnhjAuWOOTYyawEeKQNiE5zY/s947aA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-10GiUjL5OwapBXnc3gej5A-1; Tue, 23 Jun 2020 03:01:35 -0400
X-MC-Unique: 10GiUjL5OwapBXnc3gej5A-1
Received: by mail-qk1-f197.google.com with SMTP id s75so8987705qka.1
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 00:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zy58zDIczPqYbbCU2I0rBDICf2p/vJOkTqkK2TZ8PAQ=;
        b=mmT6gC7oe67ewSeAuEu3mSIO8w5FFAodWroiYMeINPpOWZnP0iSzuk7Uj6dr3KzGZe
         l3KK/3zTSLBf2FEc3Uzon9FcCwLqNfLy0U7F39iI3nDL9nQLwGkhISeboGwBqkhGKN7B
         qFH0ntVJ2kGBbAvs/Gh3+LC67WINJ8BMd+kGADjq7OCM0OIyEpBjRTl9n3earx2pLmQX
         RkpMHKeH69VTlyQZEXeEc40GipqEn1D6IwHL0YQ+uQZ0ODmh6fnkCU8IUPnRwKseBm17
         qyoU1atg9L6YXPp9SPo/KVmSQYHmElaNXzJ/zQrN45m2H85ONbuVxz+cRa0X5m/4hSqA
         dMlg==
X-Gm-Message-State: AOAM531ShZXG+dTRUJisKBeq9v7/6cdETOGpLFo0hY3SF9IBesTy/eJ8
        +1FV+/mePNnfey4KgxxEuBuRCZNSqUSkQaqnOEM//M4J7Ta9JSteEDffz1DFQuoxVkob16vNFU7
        QvuEzbtFNt0km7L8fPXzkdaEbWFXA5kiu
X-Received: by 2002:ae9:e841:: with SMTP id a62mr19452232qkg.497.1592895694369;
        Tue, 23 Jun 2020 00:01:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOZBN3nbHPtHiWYdDSxBqd0YcCYWHIzJTjzaFifnLqnQv36MEZ0ptTmo2xbqy/ajLlIIBFDzPj3siE/rmhtiE=
X-Received: by 2002:ae9:e841:: with SMTP id a62mr19452207qkg.497.1592895693904;
 Tue, 23 Jun 2020 00:01:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200611113404.17810-1-mst@redhat.com> <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com> <20200622115946-mutt-send-email-mst@kernel.org>
 <c56cc86d-a420-79ca-8420-e99db91980fa@redhat.com>
In-Reply-To: <c56cc86d-a420-79ca-8420-e99db91980fa@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Tue, 23 Jun 2020 09:00:57 +0200
Message-ID: <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 4:51 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/6/23 =E4=B8=8A=E5=8D=8812:00, Michael S. Tsirkin wrote:
> > On Wed, Jun 17, 2020 at 11:19:26AM +0800, Jason Wang wrote:
> >> On 2020/6/11 =E4=B8=8B=E5=8D=887:34, Michael S. Tsirkin wrote:
> >>>    static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
> >>>    {
> >>>     kfree(vq->descs);
> >>> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_d=
ev *dev)
> >>>     for (i =3D 0; i < dev->nvqs; ++i) {
> >>>             vq =3D dev->vqs[i];
> >>>             vq->max_descs =3D dev->iov_limit;
> >>> +           if (vhost_vq_num_batch_descs(vq) < 0) {
> >>> +                   return -EINVAL;
> >>> +           }
> >> This check breaks vdpa which set iov_limit to zero. Consider iov_limit=
 is
> >> meaningless to vDPA, I wonder we can skip the test when device doesn't=
 use
> >> worker.
> >>
> >> Thanks
> > It doesn't need iovecs at all, right?
> >
> > -- MST
>
>
> Yes, so we may choose to bypass the iovecs as well.
>
> Thanks
>

I think that the kmalloc_array returns ZERO_SIZE_PTR for all of them
in that case, so I didn't bother to skip the kmalloc_array parts.
Would you prefer to skip them all and let them NULL? Or have I
misunderstood what you mean?

Thanks!

