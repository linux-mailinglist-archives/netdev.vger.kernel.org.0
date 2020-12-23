Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D1A2E1C27
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 13:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgLWMO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 07:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbgLWMO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 07:14:57 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F07DC0613D6
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 04:14:17 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id w1so22517817ejf.11
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 04:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=35ZYuDz/NHbYVvs0C4L+62CLzf5DN21GLodcbsEQFC8=;
        b=aJinXqPssChyo572Y/V2zRy6J5OkTR1TQN+MEuQ4oNarcAhB2somhmUhWV0HmgGikG
         e+TIqXxNraeIrU+WeupO3HTQPFteA8XEkMdqkUmBSeAWWQs239UH4vagR6/13LiAJHu8
         yfWpPCNf4skU5igECuQuVO1SHWwpluiHTqNlURKhYiKtdGrksxeXzX0NDUalwkVuAbQA
         JYQ12n2V0vxQ1VS2QymReXwjFDLc0DV3Lf73j6tylIA9XUeIy1YBOKqikAtUUQm99Hoa
         /NV96IPBMICQtMBOSsG2cV1Ym4ZQLD07TZef94tSuVP7IBfcKCUbc+9mwgP2H9hgqYLx
         Ly5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=35ZYuDz/NHbYVvs0C4L+62CLzf5DN21GLodcbsEQFC8=;
        b=Eiv/MFlkZLUHirNqvwojGgVF2VU3hzzQxZL6+NoQxruqr8C6TWrOXnou87lDlCWsjP
         HXNW1z5o1YX60MIZbKRrPSHbQsh6lJHiUtvuczBNM59CYOKQdxCoOLhMJcop2UB4xyLh
         DsnLT74tV3YtFK3Hxsab8sB4Gk8O02nOBn6j7c3e40rebmTscU+s+g+4k75kpOcANNnn
         2wMa6dzjEcr6aEQ/LoYlGr/ddIcU1Nr1cuu5VpzXa1770u+tYF/BY/lZqynz9E43KOgx
         Dx51FwcQBbIvFrdY3g4MhNFpkvrxHMzJOPhV2iRiOMhDaOgRin73ATwEUXiVp9VtDO3y
         OHvg==
X-Gm-Message-State: AOAM531qrBZLlX7PmU/HsCz/UQ0ufr9UvzQmm34+6nLIwKo3fFpK7mXp
        uPfSbEh5dyO3rQ+UepE1Nko9gWn2v17MUmqpau2U
X-Google-Smtp-Source: ABdhPJxvFGv55SXnvmstsRrPts85FfsZeW8DhW7IZ56OFMBLubAQ02qrxBnCF2WTw9XipJ1ju0Clb5hATd78E6jruXA=
X-Received: by 2002:a17:906:94c5:: with SMTP id d5mr23137335ejy.427.1608725655618;
 Wed, 23 Dec 2020 04:14:15 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com>
In-Reply-To: <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 23 Dec 2020 20:14:04 +0800
Message-ID: <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
Subject: Re: [External] Re: [RFC v2 09/13] vduse: Add support for processing
 vhost iotlb message
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

On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> > To support vhost-vdpa bus driver, we need a way to share the
> > vhost-vdpa backend process's memory with the userspace VDUSE process.
> >
> > This patch tries to make use of the vhost iotlb message to achieve
> > that. We will get the shm file from the iotlb message and pass it
> > to the userspace VDUSE process.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   Documentation/driver-api/vduse.rst |  15 +++-
> >   drivers/vdpa/vdpa_user/vduse_dev.c | 147 ++++++++++++++++++++++++++++=
++++++++-
> >   include/uapi/linux/vduse.h         |  11 +++
> >   3 files changed, 171 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/driver-api/vduse.rst b/Documentation/driver-=
api/vduse.rst
> > index 623f7b040ccf..48e4b1ba353f 100644
> > --- a/Documentation/driver-api/vduse.rst
> > +++ b/Documentation/driver-api/vduse.rst
> > @@ -46,13 +46,26 @@ The following types of messages are provided by the=
 VDUSE framework now:
> >
> >   - VDUSE_GET_CONFIG: Read from device specific configuration space
> >
> > +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
> > +
> > +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device IOTL=
B
> > +
> >   Please see include/linux/vdpa.h for details.
> >
> > -In the data path, VDUSE framework implements a MMU-based on-chip IOMMU
> > +The data path of userspace vDPA device is implemented in different way=
s
> > +depending on the vdpa bus to which it is attached.
> > +
> > +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chip IO=
MMU
> >   driver which supports mapping the kernel dma buffer to a userspace io=
va
> >   region dynamically. The userspace iova region can be created by passi=
ng
> >   the userspace vDPA device fd to mmap(2).
> >
> > +In vhost-vdpa case, the dma buffer is reside in a userspace memory reg=
ion
> > +which will be shared to the VDUSE userspace processs via the file
> > +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding addres=
s
> > +mapping (IOVA of dma buffer <-> VA of the memory region) is also inclu=
ded
> > +in this message.
> > +
> >   Besides, the eventfd mechanism is used to trigger interrupt callbacks=
 and
> >   receive virtqueue kicks in userspace. The following ioctls on the use=
rspace
> >   vDPA device fd are provided to support that:
> > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_use=
r/vduse_dev.c
> > index b974333ed4e9..d24aaacb6008 100644
> > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > @@ -34,6 +34,7 @@
> >
> >   struct vduse_dev_msg {
> >       struct vduse_dev_request req;
> > +     struct file *iotlb_file;
> >       struct vduse_dev_response resp;
> >       struct list_head list;
> >       wait_queue_head_t waitq;
> > @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vduse_de=
v *dev,
> >       return ret;
> >   }
> >
> > +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct file *=
file,
> > +                             u64 offset, u64 iova, u64 size, u8 perm)
> > +{
> > +     struct vduse_dev_msg *msg;
> > +     int ret;
> > +
> > +     if (!size)
> > +             return -EINVAL;
> > +
> > +     msg =3D vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
> > +     msg->req.size =3D sizeof(struct vduse_iotlb);
> > +     msg->req.iotlb.offset =3D offset;
> > +     msg->req.iotlb.iova =3D iova;
> > +     msg->req.iotlb.size =3D size;
> > +     msg->req.iotlb.perm =3D perm;
> > +     msg->req.iotlb.fd =3D -1;
> > +     msg->iotlb_file =3D get_file(file);
> > +
> > +     ret =3D vduse_dev_msg_sync(dev, msg);
>
>
> My feeling is that we should provide consistent API for the userspace
> device to use.
>
> E.g we'd better carry the IOTLB message for both virtio/vhost drivers.
>
> It looks to me for virtio drivers we can still use UPDAT_IOTLB message
> by using VDUSE file as msg->iotlb_file here.
>

It's OK for me. One problem is when to transfer the UPDATE_IOTLB
message in virtio cases.

>
> > +     vduse_dev_msg_put(msg);
> > +     fput(file);
> > +
> > +     return ret;
> > +}
> > +
> > +static int vduse_dev_invalidate_iotlb(struct vduse_dev *dev,
> > +                                     u64 iova, u64 size)
> > +{
> > +     struct vduse_dev_msg *msg;
> > +     int ret;
> > +
> > +     if (!size)
> > +             return -EINVAL;
> > +
> > +     msg =3D vduse_dev_new_msg(dev, VDUSE_INVALIDATE_IOTLB);
> > +     msg->req.size =3D sizeof(struct vduse_iotlb);
> > +     msg->req.iotlb.iova =3D iova;
> > +     msg->req.iotlb.size =3D size;
> > +
> > +     ret =3D vduse_dev_msg_sync(dev, msg);
> > +     vduse_dev_msg_put(msg);
> > +
> > +     return ret;
> > +}
> > +
> > +static unsigned int perm_to_file_flags(u8 perm)
> > +{
> > +     unsigned int flags =3D 0;
> > +
> > +     switch (perm) {
> > +     case VHOST_ACCESS_WO:
> > +             flags |=3D O_WRONLY;
> > +             break;
> > +     case VHOST_ACCESS_RO:
> > +             flags |=3D O_RDONLY;
> > +             break;
> > +     case VHOST_ACCESS_RW:
> > +             flags |=3D O_RDWR;
> > +             break;
> > +     default:
> > +             WARN(1, "invalidate vhost IOTLB permission\n");
> > +             break;
> > +     }
> > +
> > +     return flags;
> > +}
> > +
> >   static ssize_t vduse_dev_read_iter(struct kiocb *iocb, struct iov_ite=
r *to)
> >   {
> >       struct file *file =3D iocb->ki_filp;
> >       struct vduse_dev *dev =3D file->private_data;
> >       struct vduse_dev_msg *msg;
> > -     int size =3D sizeof(struct vduse_dev_request);
> > +     unsigned int flags;
> > +     int fd, size =3D sizeof(struct vduse_dev_request);
> >       ssize_t ret =3D 0;
> >
> >       if (iov_iter_count(to) < size)
> > @@ -349,6 +418,18 @@ static ssize_t vduse_dev_read_iter(struct kiocb *i=
ocb, struct iov_iter *to)
> >               if (ret)
> >                       return ret;
> >       }
> > +
> > +     if (msg->req.type =3D=3D VDUSE_UPDATE_IOTLB && msg->req.iotlb.fd =
=3D=3D -1) {
> > +             flags =3D perm_to_file_flags(msg->req.iotlb.perm);
> > +             fd =3D get_unused_fd_flags(flags);
> > +             if (fd < 0) {
> > +                     vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> > +                     return fd;
> > +             }
> > +             fd_install(fd, get_file(msg->iotlb_file));
> > +             msg->req.iotlb.fd =3D fd;
> > +     }
> > +
> >       ret =3D copy_to_iter(&msg->req, size, to);
> >       if (ret !=3D size) {
> >               vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
> > @@ -565,6 +646,69 @@ static void vduse_vdpa_set_config(struct vdpa_devi=
ce *vdpa, unsigned int offset,
> >       vduse_dev_set_config(dev, offset, buf, len);
> >   }
> >
> > +static void vduse_vdpa_invalidate_iotlb(struct vduse_dev *dev,
> > +                                     struct vhost_iotlb_msg *msg)
> > +{
> > +     vduse_dev_invalidate_iotlb(dev, msg->iova, msg->size);
> > +}
> > +
> > +static int vduse_vdpa_update_iotlb(struct vduse_dev *dev,
> > +                                     struct vhost_iotlb_msg *msg)
> > +{
> > +     u64 uaddr =3D msg->uaddr;
> > +     u64 iova =3D msg->iova;
> > +     u64 size =3D msg->size;
> > +     u64 offset;
> > +     struct vm_area_struct *vma;
> > +     int ret;
> > +
> > +     while (uaddr < msg->uaddr + msg->size) {
> > +             vma =3D find_vma(current->mm, uaddr);
> > +             ret =3D -EINVAL;
> > +             if (!vma)
> > +                     goto err;
> > +
> > +             size =3D min(msg->size, vma->vm_end - uaddr);
> > +             offset =3D (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->v=
m_start;
> > +             if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
> > +                     ret =3D vduse_dev_update_iotlb(dev, vma->vm_file,=
 offset,
> > +                                                     iova, size, msg->=
perm);
> > +                     if (ret)
> > +                             goto err;
>
>
> My understanding is that vma is something that should not be known by a
> device. So I suggest to move the above processing to vhost-vdpa.c.
>

Will do it.

Thanks,
Yongji
