Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F34B2E2B29
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 11:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgLYKcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 05:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbgLYKcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 05:32:52 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2B7C061575
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 02:32:11 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id q22so6014096eja.2
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 02:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2mdCx8xshli0kq7RXAVNqICilQ2AU3zt5Tqdm2EKCLQ=;
        b=XHrk+HxpxJfSLPSAqKrGz89HFPu92jTr7hPqzlNf+DYajtX3L5tr0f8DkIklYOaP+E
         CO9a94G5f48tM6mE0i5WPygQMYl22znCz+uc4YvVQfTCTgFrXm3OScanUTdKzg8WroRg
         r7S+Q2iwZruqJUt6HyXXgtksk3ezLRVm8nTes4TCWYBNlB/AooRu0FQJLyTBaqxiY4QW
         XOPSfdloKOcQ5fnz2FksaLFz0tsfHVPzVGBW4WAAgsjFmz57RQwMFGhVWNnTRvFkGXcx
         EGsEsh6x9fHTk1t4qyePbLXJSRxm+9AMDFQmm33iN/q41hf0lXbZtMCRElnGdvmQm/TO
         dqJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2mdCx8xshli0kq7RXAVNqICilQ2AU3zt5Tqdm2EKCLQ=;
        b=n6EwdPNTdjv+I78y+MnoiYGQ+bAWfwzs3TyLT0rKUxK5AotiR2Ch1r1t1CuajXtU2Q
         Sw1oz1/nw/iBR75dK+JKIHQGGCO41mOb2zJvvo0Kv7p6SEd6cl/d5eljc6YlnRzzcVeS
         1BIZMuLdIZ/H9usKFowdGAdKHJpzlTs4GCFjL5koefM/9P+WpuNbKLwip9UBGxBxAMWF
         cQ3O6nk9q3EJoECCbPZcV1AuLtMY3Ymnjxpt9Xuo2eNjjrCq/pFa5RusnI4vXuhnGiFy
         uGc+WLGjFn5mdBGvefGpZF7pth6ZsSVsKdM8CEBF70PYARR4/H8XiRE2NlIT/Ow0nLXV
         ytRg==
X-Gm-Message-State: AOAM5303NmpFgtfH8Yf8c5/d7XMq85sw2ccbtytTCjrO8rM3AOK7eI+t
        9UY5kd9tx9IHw37kQjsd8Isprw4zCCxqwJ8D/dKt
X-Google-Smtp-Source: ABdhPJww2xAopk83ZdoX/cRPZyu9BQyjWxojT4QhW2ZKQOFY8WAjhfKWqXDqPzt7WkNdEsvxZjvGu3wuksqFY2z+SIc=
X-Received: by 2002:a17:906:878d:: with SMTP id za13mr30846699ejb.395.1608892328568;
 Fri, 25 Dec 2020 02:32:08 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com> <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com>
In-Reply-To: <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 25 Dec 2020 18:31:58 +0800
Message-ID: <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
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

On Fri, Dec 25, 2020 at 2:58 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/24 =E4=B8=8B=E5=8D=883:37, Yongji Xie wrote:
> > On Thu, Dec 24, 2020 at 10:41 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> On 2020/12/23 =E4=B8=8B=E5=8D=888:14, Yongji Xie wrote:
> >>> On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> >>>>> To support vhost-vdpa bus driver, we need a way to share the
> >>>>> vhost-vdpa backend process's memory with the userspace VDUSE proces=
s.
> >>>>>
> >>>>> This patch tries to make use of the vhost iotlb message to achieve
> >>>>> that. We will get the shm file from the iotlb message and pass it
> >>>>> to the userspace VDUSE process.
> >>>>>
> >>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>>>> ---
> >>>>>     Documentation/driver-api/vduse.rst |  15 +++-
> >>>>>     drivers/vdpa/vdpa_user/vduse_dev.c | 147 ++++++++++++++++++++++=
++++++++++++++-
> >>>>>     include/uapi/linux/vduse.h         |  11 +++
> >>>>>     3 files changed, 171 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/dri=
ver-api/vduse.rst
> >>>>> index 623f7b040ccf..48e4b1ba353f 100644
> >>>>> --- a/Documentation/driver-api/vduse.rst
> >>>>> +++ b/Documentation/driver-api/vduse.rst
> >>>>> @@ -46,13 +46,26 @@ The following types of messages are provided by=
 the VDUSE framework now:
> >>>>>
> >>>>>     - VDUSE_GET_CONFIG: Read from device specific configuration spa=
ce
> >>>>>
> >>>>> +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
> >>>>> +
> >>>>> +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device =
IOTLB
> >>>>> +
> >>>>>     Please see include/linux/vdpa.h for details.
> >>>>>
> >>>>> -In the data path, VDUSE framework implements a MMU-based on-chip I=
OMMU
> >>>>> +The data path of userspace vDPA device is implemented in different=
 ways
> >>>>> +depending on the vdpa bus to which it is attached.
> >>>>> +
> >>>>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-chi=
p IOMMU
> >>>>>     driver which supports mapping the kernel dma buffer to a usersp=
ace iova
> >>>>>     region dynamically. The userspace iova region can be created by=
 passing
> >>>>>     the userspace vDPA device fd to mmap(2).
> >>>>>
> >>>>> +In vhost-vdpa case, the dma buffer is reside in a userspace memory=
 region
> >>>>> +which will be shared to the VDUSE userspace processs via the file
> >>>>> +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding ad=
dress
> >>>>> +mapping (IOVA of dma buffer <-> VA of the memory region) is also i=
ncluded
> >>>>> +in this message.
> >>>>> +
> >>>>>     Besides, the eventfd mechanism is used to trigger interrupt cal=
lbacks and
> >>>>>     receive virtqueue kicks in userspace. The following ioctls on t=
he userspace
> >>>>>     vDPA device fd are provided to support that:
> >>>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa=
_user/vduse_dev.c
> >>>>> index b974333ed4e9..d24aaacb6008 100644
> >>>>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> >>>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>>>> @@ -34,6 +34,7 @@
> >>>>>
> >>>>>     struct vduse_dev_msg {
> >>>>>         struct vduse_dev_request req;
> >>>>> +     struct file *iotlb_file;
> >>>>>         struct vduse_dev_response resp;
> >>>>>         struct list_head list;
> >>>>>         wait_queue_head_t waitq;
> >>>>> @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vdus=
e_dev *dev,
> >>>>>         return ret;
> >>>>>     }
> >>>>>
> >>>>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct fi=
le *file,
> >>>>> +                             u64 offset, u64 iova, u64 size, u8 pe=
rm)
> >>>>> +{
> >>>>> +     struct vduse_dev_msg *msg;
> >>>>> +     int ret;
> >>>>> +
> >>>>> +     if (!size)
> >>>>> +             return -EINVAL;
> >>>>> +
> >>>>> +     msg =3D vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
> >>>>> +     msg->req.size =3D sizeof(struct vduse_iotlb);
> >>>>> +     msg->req.iotlb.offset =3D offset;
> >>>>> +     msg->req.iotlb.iova =3D iova;
> >>>>> +     msg->req.iotlb.size =3D size;
> >>>>> +     msg->req.iotlb.perm =3D perm;
> >>>>> +     msg->req.iotlb.fd =3D -1;
> >>>>> +     msg->iotlb_file =3D get_file(file);
> >>>>> +
> >>>>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>>> My feeling is that we should provide consistent API for the userspac=
e
> >>>> device to use.
> >>>>
> >>>> E.g we'd better carry the IOTLB message for both virtio/vhost driver=
s.
> >>>>
> >>>> It looks to me for virtio drivers we can still use UPDAT_IOTLB messa=
ge
> >>>> by using VDUSE file as msg->iotlb_file here.
> >>>>
> >>> It's OK for me. One problem is when to transfer the UPDATE_IOTLB
> >>> message in virtio cases.
> >>
> >> Instead of generating IOTLB messages for userspace.
> >>
> >> How about record the mappings (which is a common case for device have
> >> on-chip IOMMU e.g mlx5e and vdpa simlator), then we can introduce ioct=
l
> >> for userspace to query?
> >>
> > If so, the IOTLB UPDATE is actually triggered by ioctl, but
> > IOTLB_INVALIDATE is triggered by the message. Is it a little odd?
>
>
> Good point.
>
> Some questions here:
>
> 1) Userspace think the IOTLB was flushed after IOTLB_INVALIDATE syscall
> is returned. But this patch doesn't have this guarantee. Can this lead
> some issues?

I'm not sure. But should it be guaranteed in VDUSE userspace? Just
like what vhost-user backend process does.

> 2) I think after VDUSE userspace receives IOTLB_INVALIDATE, it needs to
> issue a munmap(). What if it doesn't do that?
>

Yes, the munmap() is needed. If it doesn't do that, VDUSE userspace
could still access the corresponding guest memory region.

Thanks,
Yongji
