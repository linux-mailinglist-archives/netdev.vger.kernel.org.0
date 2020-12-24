Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8FB2E2541
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 08:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgLXHiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 02:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgLXHiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 02:38:03 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA89EC061794
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 23:37:22 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cw27so1432833edb.5
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 23:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GCpEe9bgcinu2yB8dDVslobyM9KIB6TrbsIPt4r9UaE=;
        b=wJtOPzCiU2BNyGRZwvpISTXAlJmybWeFPLzYdvCc8iE8/9pBk7j2/JHXlnsn5SiHJq
         /VhmQ14nzfxHny+5Xt82jx4MMOBVBI0fW2rVd+EE/jGoYgVjlLDcth5SLiwaBua67nQx
         Rr8cqU879rdLCTQGfKgqyGbkEaaqzpWwFZDYEFTAqBerD3BqdLPGwwM9fxzMP62ZawKz
         xTDEWqZnlmWGlYwvOsb+K0h23Dg1BbxFmwDz2ZPLWiHHRdu+O0iZ1Z15O7vn1IHcFly6
         YrMGQYjqrJunNEHTTmGJGAl5VWi3MnVZwT5tz6Pe1tYPAYqGre8Tl3xSih9PxZYGoAnI
         1udA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GCpEe9bgcinu2yB8dDVslobyM9KIB6TrbsIPt4r9UaE=;
        b=oUToaiLlVYBPiPcOdTRiXS06eBKhSK9SaXm5pmA9xRmxJRGt3G1ERbtp7dIozYLZ04
         YndrsvIP2vthAToFOjGkwx+xc7HbUhoNz/2w7IY/6OeAqktsJezwQ71lUeTtPWccpWga
         187jlQ/vq/Xonw7Esa7R3Bzd9FFCOCfui/oEf9ArgEZ0IzqqJ9tHN+BeLZd06xZeyVpI
         U0Fr3ChpgHHPPCLKTICkRvnh9qUW/ZTZC2rPOhBKqBz1MF2rp+euWd2T+Esknx0O16iy
         Y6YzJojgspHXAANFovZbaNkIuueUM6hrgj3CM6uC7hfbEsAAoRyCJUQJ8CZIlitgoKoJ
         256Q==
X-Gm-Message-State: AOAM531lEVTBEm41X0UR3cO3rRGTdoiH6VG4FShaI1V3ci487bD5JE6i
        /n9onWVzsIqkzcWmmHisWkrNJQTJ4faW2e5RKeyd
X-Google-Smtp-Source: ABdhPJzIXBdUKvYXI8RIu6cIsVGbPRa/53lrumD//6NgHswloThw+T8myoLHefv1bkK72Rx12WVC0SaSlDURKfiWuHE=
X-Received: by 2002:a50:f40e:: with SMTP id r14mr27056186edm.5.1608795441570;
 Wed, 23 Dec 2020 23:37:21 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com> <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com>
In-Reply-To: <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 24 Dec 2020 15:37:10 +0800
Message-ID: <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
Subject: Re: Re: [RFC v2 09/13] vduse: Add support for processing vhost iotlb message
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

On Thu, Dec 24, 2020 at 10:41 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/23 =E4=B8=8B=E5=8D=888:14, Yongji Xie wrote:
> > On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> >>> To support vhost-vdpa bus driver, we need a way to share the
> >>> vhost-vdpa backend process's memory with the userspace VDUSE process.
> >>>
> >>> This patch tries to make use of the vhost iotlb message to achieve
> >>> that. We will get the shm file from the iotlb message and pass it
> >>> to the userspace VDUSE process.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    Documentation/driver-api/vduse.rst |  15 +++-
> >>>    drivers/vdpa/vdpa_user/vduse_dev.c | 147 +++++++++++++++++++++++++=
+++++++++++-
> >>>    include/uapi/linux/vduse.h         |  11 +++
> >>>    3 files changed, 171 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/drive=
r-api/vduse.rst
> >>> index 623f7b040ccf..48e4b1ba353f 100644
> >>> --- a/Documentation/driver-api/vduse.rst
> >>> +++ b/Documentation/driver-api/vduse.rst
> >>> @@ -46,13 +46,26 @@ The following types of messages are provided by t=
he VDUSE framework now:
> >>>
> >>>    - VDUSE_GET_CONFIG: Read from device specific configuration space
> >>>
> >>> +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
> >>> +
> >>> +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device IO=
TLB
> >>> +
> >>>    Please see include/linux/vdpa.h for details.
> >>>
> >>> -In the data path, VDUSE framework implements a MMU-based on-chip IOM=
MU
> >>> +The data path of userspace vDPA device is implemented in different w=
ays
> >>> +depending on the vdpa bus to which it is attached.
> >>> +
> >>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip =
IOMMU
> >>>    driver which supports mapping the kernel dma buffer to a userspace=
 iova
> >>>    region dynamically. The userspace iova region can be created by pa=
ssing
> >>>    the userspace vDPA device fd to mmap(2).
> >>>
> >>> +In vhost-vdpa case, the dma buffer is reside in a userspace memory r=
egion
> >>> +which will be shared to the VDUSE userspace processs via the file
> >>> +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding addr=
ess
> >>> +mapping (IOVA of dma buffer <-> VA of the memory region) is also inc=
luded
> >>> +in this message.
> >>> +
> >>>    Besides, the eventfd mechanism is used to trigger interrupt callba=
cks and
> >>>    receive virtqueue kicks in userspace. The following ioctls on the =
userspace
> >>>    vDPA device fd are provided to support that:
> >>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_u=
ser/vduse_dev.c
> >>> index b974333ed4e9..d24aaacb6008 100644
> >>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> >>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>> @@ -34,6 +34,7 @@
> >>>
> >>>    struct vduse_dev_msg {
> >>>        struct vduse_dev_request req;
> >>> +     struct file *iotlb_file;
> >>>        struct vduse_dev_response resp;
> >>>        struct list_head list;
> >>>        wait_queue_head_t waitq;
> >>> @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vduse_=
dev *dev,
> >>>        return ret;
> >>>    }
> >>>
> >>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct file=
 *file,
> >>> +                             u64 offset, u64 iova, u64 size, u8 perm=
)
> >>> +{
> >>> +     struct vduse_dev_msg *msg;
> >>> +     int ret;
> >>> +
> >>> +     if (!size)
> >>> +             return -EINVAL;
> >>> +
> >>> +     msg =3D vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
> >>> +     msg->req.size =3D sizeof(struct vduse_iotlb);
> >>> +     msg->req.iotlb.offset =3D offset;
> >>> +     msg->req.iotlb.iova =3D iova;
> >>> +     msg->req.iotlb.size =3D size;
> >>> +     msg->req.iotlb.perm =3D perm;
> >>> +     msg->req.iotlb.fd =3D -1;
> >>> +     msg->iotlb_file =3D get_file(file);
> >>> +
> >>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>
> >> My feeling is that we should provide consistent API for the userspace
> >> device to use.
> >>
> >> E.g we'd better carry the IOTLB message for both virtio/vhost drivers.
> >>
> >> It looks to me for virtio drivers we can still use UPDAT_IOTLB message
> >> by using VDUSE file as msg->iotlb_file here.
> >>
> > It's OK for me. One problem is when to transfer the UPDATE_IOTLB
> > message in virtio cases.
>
>
> Instead of generating IOTLB messages for userspace.
>
> How about record the mappings (which is a common case for device have
> on-chip IOMMU e.g mlx5e and vdpa simlator), then we can introduce ioctl
> for userspace to query?
>

If so, the IOTLB UPDATE is actually triggered by ioctl, but
IOTLB_INVALIDATE is triggered by the message. Is it a little odd? Or
how about trigger it when userspace call mmap() on the device fd?

Thanks,
Yongji
