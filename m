Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4BD2845F0
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgJFGWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:22:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbgJFGWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601965343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cABuv5tFxr+o7caWDmev7YzIrHPEZqeTI2swVLejHzc=;
        b=BfhLJYnf8ukMkQocxyxef+lefAoQzXdoTTcmCn501GCBkLlNbXdc4Ec8RXa6hVvx6R1FLq
        wrLvf6BcqUCI6umKRh+0dvZO0uPy4uct5+6N6TFSsEpl0ZHCQHjsCB8/6EmD8aFUujEWbT
        XVOEWR5hcDDby3YOcqmHwb4DLjZLohA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-ieny6rzbO_q39g3NQRAiww-1; Tue, 06 Oct 2020 02:22:21 -0400
X-MC-Unique: ieny6rzbO_q39g3NQRAiww-1
Received: by mail-wr1-f70.google.com with SMTP id r16so4921904wrm.18
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cABuv5tFxr+o7caWDmev7YzIrHPEZqeTI2swVLejHzc=;
        b=OePvYenL6jaif+rE4FRjBzfnE9oh+wHhZ0lqCC/fLXm2nQzyaDkpWYh74Nu/9yUh4a
         CjMHdf+jRNgnKdHFKt/XCpLC3dO/+7yukw3YGbpYBqiTWWPejPTwGgY0kN0bakRQellH
         /1xzzSVyK2EqEF8EuwAMQkfxmaTQAWMHeUDiG3u9MLBcROYh9iyGAPMDaK5TH/bTMNyX
         I+e3c2el56PVhG16Tk2cuRw3VdYKYJyDdnHggeEtgpiHq1YC+BVF+g1sSEN/LY5ENfFU
         dWGNfjbH462FgC9aRbiDSlLj7GVrHP93DTvTAmlSmeO4EBUn+EwEYbHFQLl8GWKbu2uc
         m65Q==
X-Gm-Message-State: AOAM5308zVT5JqzZCB9WoE45XLniRzpIpDiXjF4uflnJaJW51vKu8/OB
        +wcU0axIGwj4awYFzyGKxspS3eTlTvkNG5QdCbetuoPurevibiulV7tShHG0TnlVkq9McUse1oR
        FyGd/viMdaKCMMMDs
X-Received: by 2002:a1c:6341:: with SMTP id x62mr2960292wmb.70.1601965339970;
        Mon, 05 Oct 2020 23:22:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2gvNV1LSmLX/+VDO4Yf2Zjs3i0Rf5UDSyb4S9V6nUVLErBUxWwCSSzaYv4MAqhHcHl83azg==
X-Received: by 2002:a1c:6341:: with SMTP id x62mr2960267wmb.70.1601965339738;
        Mon, 05 Oct 2020 23:22:19 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id g83sm2388409wmf.15.2020.10.05.23.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:22:18 -0700 (PDT)
Date:   Tue, 6 Oct 2020 02:22:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <siwliu.kernel@gmail.com>
Cc:     elic@nvidia.com, jasowang@redhat.com, netdev@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH] vdpa/mlx5: should keep avail_index despite device status
Message-ID: <20201006022133-mutt-send-email-mst@kernel.org>
References: <1601583511-15138-1-git-send-email-si-wei.liu@oracle.com>
 <CAPWQSg1y8uvpiwxxp_ONGFs8GeuOY09q3AShfLCmhv77ePma-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPWQSg1y8uvpiwxxp_ONGFs8GeuOY09q3AShfLCmhv77ePma-Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 01:17:00PM -0700, Si-Wei Liu wrote:
> + Eli.
> 
> On Thu, Oct 1, 2020 at 2:02 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >
> > A VM with mlx5 vDPA has below warnings while being reset:
> >
> > vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
> > vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
> >
> > We should allow userspace emulating the virtio device be
> > able to get to vq's avail_index, regardless of vDPA device
> > status. Save the index that was last seen when virtq was
> > stopped, so that userspace doesn't complain.
> >
> > Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>

Eli can you review this pls? I need to send a pull request to Linux by
tomorrow - do we want to include this?

> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 70676a6..74264e59 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1133,15 +1133,17 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> >         if (!mvq->initialized)
> >                 return;
> >
> > -       if (query_virtqueue(ndev, mvq, &attr)) {
> > -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> > -               return;
> > -       }
> >         if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
> >                 return;
> >
> >         if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
> >                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> > +
> > +       if (query_virtqueue(ndev, mvq, &attr)) {
> > +               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
> > +               return;
> > +       }
> > +       mvq->avail_idx = attr.available_index;
> >  }
> >
> >  static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> > @@ -1411,8 +1413,14 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
> >         struct mlx5_virtq_attr attr;
> >         int err;
> >
> > -       if (!mvq->initialized)
> > -               return -EAGAIN;
> > +       /* If the virtq object was destroyed, use the value saved at
> > +        * the last minute of suspend_vq. This caters for userspace
> > +        * that cares about emulating the index after vq is stopped.
> > +        */
> > +       if (!mvq->initialized) {
> > +               state->avail_index = mvq->avail_idx;
> > +               return 0;
> > +       }
> >
> >         err = query_virtqueue(ndev, mvq, &attr);
> >         if (err) {
> > --
> > 1.8.3.1
> >

