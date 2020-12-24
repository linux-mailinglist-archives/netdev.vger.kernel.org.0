Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7213D2E2532
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgLXHZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgLXHZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 02:25:47 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B24C061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 23:25:06 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id dk8so1432500edb.1
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 23:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wqSoUJ0wK428r/8qtbJUJtWlo8/XxBIZ7I2arOIoVvg=;
        b=uCfDQp+rckuVdcZ/vely7IwCRxCR6p1idVLIxaoZT9ytRtnDQPr53X7ewWQqhyQeRt
         DGMuYQ/Fnt3huQeBJtDG+Ek3MxXEHmmOPiQWIkWYaFZlyepi/JdTJezVIRCTSKgSdiQo
         QYx56uo5cPF/9QZ0DvERgrRadxTp4j/sFjxeGc8+d1FaZPqGAMURnQONgUeeIzc+/VRS
         AsZlCV8qbRQeBZ2i0xspi7zbX3DtDcn2ZK8muC7HN9BMacgiC+ikbOEG7paMdjGNt+a2
         mvJycjddQn7HMe4Xj8tNRld7Dr4eRKlgCuW44RhNjMZ33MP8wgf+4jDILoVtr+fht/nF
         NSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wqSoUJ0wK428r/8qtbJUJtWlo8/XxBIZ7I2arOIoVvg=;
        b=ZT/EKo+AlhRU1/A3RHLh3e2dlKha9xBFnbkhjcKlIR0zK1sPrp5HOPd8DOZEwa6zKB
         ZJo0kkoYkaOH/9lSv507BbD3wZDgH2PQ3PLesQEfe/YWHXwV5GRuYEWsX8Iieh0Jx3tQ
         A9Ut7FWUM7bZExZqxuLUz6cgJ9z/raDROvpJ4WuEJYglDFu8Dr9rcf+dPO1EBvEohTZQ
         4KY7MdmPlazmqCHcXL8oECFB7c6XJ/JLLLF0bZBi6tpiLU9j2ZgBFlURHHDpormSOsOV
         BP+aTZBwHYzBpHIdDNXVDy9uS2A5XxMYiyQGR5xYqNu2rPLFdbWrAQzYDR1y14StSeaR
         eRdQ==
X-Gm-Message-State: AOAM533ZHG4y5KYg3tVakH7RbwRVTrVHSqS9Ar/bYQf6YeqooHbfnhXb
        3NW6I9WdTtPSEH9OBpMUxPseEmrUHkO6Sgdawovt
X-Google-Smtp-Source: ABdhPJxYtKj5zSF9sYKP0JW8AGDlYbzQ/DtgYlMviG2drnktYahrLMoBL4l3uXC37jhXyO2bXLesu8cNLrFWF81FKb8=
X-Received: by 2002:aa7:c60c:: with SMTP id h12mr27893759edq.145.1608794704858;
 Wed, 23 Dec 2020 23:25:04 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-9-xieyongji@bytedance.com>
 <5b36bc51-1e19-2b59-6287-66aed435c8ed@redhat.com> <CACycT3tP8mgj043idjJW3BF12qmOhmHzYz8X5FyL8t5MbwLysw@mail.gmail.com>
 <4b13e574-d898-55cc-9ec6-78f28a7f2cd9@redhat.com>
In-Reply-To: <4b13e574-d898-55cc-9ec6-78f28a7f2cd9@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 24 Dec 2020 15:24:54 +0800
Message-ID: <CACycT3uPGEGsY-=Yak02B0pb77KCKH=bgvHMCQXvBdaWU=22zg@mail.gmail.com>
Subject: Re: Re: [RFC v2 08/13] vdpa: Introduce process_iotlb_msg() in vdpa_config_ops
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 10:37 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/23 =E4=B8=8B=E5=8D=887:06, Yongji Xie wrote:
> > On Wed, Dec 23, 2020 at 4:37 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> >>> This patch introduces a new method in the vdpa_config_ops to
> >>> support processing the raw vhost memory mapping message in the
> >>> vDPA device driver.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    drivers/vhost/vdpa.c | 5 ++++-
> >>>    include/linux/vdpa.h | 7 +++++++
> >>>    2 files changed, 11 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >>> index 448be7875b6d..ccbb391e38be 100644
> >>> --- a/drivers/vhost/vdpa.c
> >>> +++ b/drivers/vhost/vdpa.c
> >>> @@ -728,6 +728,9 @@ static int vhost_vdpa_process_iotlb_msg(struct vh=
ost_dev *dev,
> >>>        if (r)
> >>>                return r;
> >>>
> >>> +     if (ops->process_iotlb_msg)
> >>> +             return ops->process_iotlb_msg(vdpa, msg);
> >>> +
> >>>        switch (msg->type) {
> >>>        case VHOST_IOTLB_UPDATE:
> >>>                r =3D vhost_vdpa_process_iotlb_update(v, msg);
> >>> @@ -770,7 +773,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_v=
dpa *v)
> >>>        int ret;
> >>>
> >>>        /* Device want to do DMA by itself */
> >>> -     if (ops->set_map || ops->dma_map)
> >>> +     if (ops->set_map || ops->dma_map || ops->process_iotlb_msg)
> >>>                return 0;
> >>>
> >>>        bus =3D dma_dev->bus;
> >>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> >>> index 656fe264234e..7bccedf22f4b 100644
> >>> --- a/include/linux/vdpa.h
> >>> +++ b/include/linux/vdpa.h
> >>> @@ -5,6 +5,7 @@
> >>>    #include <linux/kernel.h>
> >>>    #include <linux/device.h>
> >>>    #include <linux/interrupt.h>
> >>> +#include <linux/vhost_types.h>
> >>>    #include <linux/vhost_iotlb.h>
> >>>    #include <net/genetlink.h>
> >>>
> >>> @@ -172,6 +173,10 @@ struct vdpa_iova_range {
> >>>     *                          @vdev: vdpa device
> >>>     *                          Returns the iova range supported by
> >>>     *                          the device.
> >>> + * @process_iotlb_msg:               Process vhost memory mapping me=
ssage (optional)
> >>> + *                           Only used for VDUSE device now
> >>> + *                           @vdev: vdpa device
> >>> + *                           @msg: vhost memory mapping message
> >>>     * @set_map:                        Set device memory mapping (opt=
ional)
> >>>     *                          Needed for device that using device
> >>>     *                          specific DMA translation (on-chip IOMM=
U)
> >>> @@ -240,6 +245,8 @@ struct vdpa_config_ops {
> >>>        struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *v=
dev);
> >>>
> >>>        /* DMA ops */
> >>> +     int (*process_iotlb_msg)(struct vdpa_device *vdev,
> >>> +                              struct vhost_iotlb_msg *msg);
> >>>        int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *i=
otlb);
> >>>        int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> >>>                       u64 pa, u32 perm);
> >>
> >> Is there any reason that it can't be done via dma_map/dma_unmap or set=
_map?
> >>
> > To get the shmfd, we need the vma rather than physical address. And
> > it's not necessary to pin the user pages in VDUSE case.
>
>
> Right, actually, vhost-vDPA is planning to support shared virtual
> address space.
>
> So let's try to reuse the existing config ops. How about just introduce
> an attribute to vdpa device that tells the bus tells the bus it can do
> shared virtual memory. Then when the device is probed by vhost-vDPA, use
> pages won't be pinned and we will do VA->VA mapping as IOVA->PA mapping
> in the vhost IOTLB and the config ops. vhost IOTLB needs to be extended
> to accept opaque pointer to store the file. And the file was pass via
> the config ops as well.
>

OK, I see. Will try it in v3.

Thanks,
Yongji
