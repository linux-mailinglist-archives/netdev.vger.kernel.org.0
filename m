Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB10A2E2B5C
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 12:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgLYLhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 06:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbgLYLhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 06:37:20 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E44C061573
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 03:36:40 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b2so4060591edm.3
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 03:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dW0U27CQ5PW1ixet51Jw3cXT7HN2RV6YZF1yER1fAkk=;
        b=bP1qF27nPbQAJyxjeo2/LdyaHDUjjfA+i2j4NfbjaBRu45vb1JR6A0dR2/3VUsfZqP
         qyhuiBcWlp8cJMZe672468m9IfFb2puLOZ1RmA5ZpV5v3ouDorQZxqrdJFjBR+KwkqJ2
         k4MBOGfo+dEB+SG8+JYvOjc1xuElJPrKH4TT4SV+EHb9uETKBpDAkdStgJ1pAtJrrQJN
         U0CydeZsnEl9IB6/DDlyqO8L58oaAH3Ld9C0J34VFkeAedS5NnepeFaWERhL3PQ3vq9v
         v7AkE0/uyDbOK8NAPHASAFb04Ipic29wbXY+L02DUfLDiGmayao5aPFG0VZUQL7Dk2ir
         xXjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dW0U27CQ5PW1ixet51Jw3cXT7HN2RV6YZF1yER1fAkk=;
        b=hDwGUTx5JkLOxrccdsu/JW2X3TrW3V547BNy0Hbnu58CMRBQeOcsGL3rF4guRvVio2
         LEUgoXtZha5MlxbjE60YOwULGppYA41p5fPpMjNoW6loEK3dKXms4IjWGiI5obM9MusT
         AVVFl0zAuECfYkK6zSp+wXqDTwYckWB6980jQYhvzAJ3l2OKwgbtseEQRhF3rQTk6+cC
         Pl3NlY3FW+JOAOJ5ws9S3TiG1aOlhTw+Utsg7jDHTzivmkuOjImGMS/THc+3me+S7UHq
         X/tyziU4xqWZ56b8q+2DMblcKtXKjc1C7Vv47iWm2Gcqu/tj/LqY8c0NhTq8mo5G1BA6
         ShJg==
X-Gm-Message-State: AOAM531EF7KML5W+Qy9QwhAn9JhUC7SRhHsqCOT9m8nTBvN32geuirU7
        MBBZzOej0mxGyANCx/jydp+XhfHgnwTR30bIRQtY
X-Google-Smtp-Source: ABdhPJyfzVm0KQD3jJjRSeRPyWJpRRybRK+7ycfHra1KVC7YY/1Zl7tBpHlK54DG5AW8RaYtsXWSJpqzc1yIYXCPwj4=
X-Received: by 2002:a50:f304:: with SMTP id p4mr30922018edm.118.1608896198476;
 Fri, 25 Dec 2020 03:36:38 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com> <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <CACycT3tLG=13fDdY0YPzViK2-AUy5F+uJor2cmVDFOGjXTOaYA@mail.gmail.com> <cc8b670c-66b9-9513-1ffb-b0bcef6ccf21@redhat.com>
In-Reply-To: <cc8b670c-66b9-9513-1ffb-b0bcef6ccf21@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 25 Dec 2020 19:36:28 +0800
Message-ID: <CACycT3vPzPiK-qMOvnNx=oWmZgQd35QjLRW_kQGMu2W349e9RA@mail.gmail.com>
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

On Fri, Dec 25, 2020 at 3:02 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/25 =E4=B8=8A=E5=8D=8810:37, Yongji Xie wrote:
> > On Thu, Dec 24, 2020 at 3:37 PM Yongji Xie <xieyongji@bytedance.com> wr=
ote:
> >> On Thu, Dec 24, 2020 at 10:41 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>
> >>> On 2020/12/23 =E4=B8=8B=E5=8D=888:14, Yongji Xie wrote:
> >>>> On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>>> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> >>>>>> To support vhost-vdpa bus driver, we need a way to share the
> >>>>>> vhost-vdpa backend process's memory with the userspace VDUSE proce=
ss.
> >>>>>>
> >>>>>> This patch tries to make use of the vhost iotlb message to achieve
> >>>>>> that. We will get the shm file from the iotlb message and pass it
> >>>>>> to the userspace VDUSE process.
> >>>>>>
> >>>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>>>>> ---
> >>>>>>     Documentation/driver-api/vduse.rst |  15 +++-
> >>>>>>     drivers/vdpa/vdpa_user/vduse_dev.c | 147 +++++++++++++++++++++=
+++++++++++++++-
> >>>>>>     include/uapi/linux/vduse.h         |  11 +++
> >>>>>>     3 files changed, 171 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/dr=
iver-api/vduse.rst
> >>>>>> index 623f7b040ccf..48e4b1ba353f 100644
> >>>>>> --- a/Documentation/driver-api/vduse.rst
> >>>>>> +++ b/Documentation/driver-api/vduse.rst
> >>>>>> @@ -46,13 +46,26 @@ The following types of messages are provided b=
y the VDUSE framework now:
> >>>>>>
> >>>>>>     - VDUSE_GET_CONFIG: Read from device specific configuration sp=
ace
> >>>>>>
> >>>>>> +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
> >>>>>> +
> >>>>>> +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in device=
 IOTLB
> >>>>>> +
> >>>>>>     Please see include/linux/vdpa.h for details.
> >>>>>>
> >>>>>> -In the data path, VDUSE framework implements a MMU-based on-chip =
IOMMU
> >>>>>> +The data path of userspace vDPA device is implemented in differen=
t ways
> >>>>>> +depending on the vdpa bus to which it is attached.
> >>>>>> +
> >>>>>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-ch=
ip IOMMU
> >>>>>>     driver which supports mapping the kernel dma buffer to a users=
pace iova
> >>>>>>     region dynamically. The userspace iova region can be created b=
y passing
> >>>>>>     the userspace vDPA device fd to mmap(2).
> >>>>>>
> >>>>>> +In vhost-vdpa case, the dma buffer is reside in a userspace memor=
y region
> >>>>>> +which will be shared to the VDUSE userspace processs via the file
> >>>>>> +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding a=
ddress
> >>>>>> +mapping (IOVA of dma buffer <-> VA of the memory region) is also =
included
> >>>>>> +in this message.
> >>>>>> +
> >>>>>>     Besides, the eventfd mechanism is used to trigger interrupt ca=
llbacks and
> >>>>>>     receive virtqueue kicks in userspace. The following ioctls on =
the userspace
> >>>>>>     vDPA device fd are provided to support that:
> >>>>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdp=
a_user/vduse_dev.c
> >>>>>> index b974333ed4e9..d24aaacb6008 100644
> >>>>>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> >>>>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>>>>> @@ -34,6 +34,7 @@
> >>>>>>
> >>>>>>     struct vduse_dev_msg {
> >>>>>>         struct vduse_dev_request req;
> >>>>>> +     struct file *iotlb_file;
> >>>>>>         struct vduse_dev_response resp;
> >>>>>>         struct list_head list;
> >>>>>>         wait_queue_head_t waitq;
> >>>>>> @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vdu=
se_dev *dev,
> >>>>>>         return ret;
> >>>>>>     }
> >>>>>>
> >>>>>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct f=
ile *file,
> >>>>>> +                             u64 offset, u64 iova, u64 size, u8 p=
erm)
> >>>>>> +{
> >>>>>> +     struct vduse_dev_msg *msg;
> >>>>>> +     int ret;
> >>>>>> +
> >>>>>> +     if (!size)
> >>>>>> +             return -EINVAL;
> >>>>>> +
> >>>>>> +     msg =3D vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
> >>>>>> +     msg->req.size =3D sizeof(struct vduse_iotlb);
> >>>>>> +     msg->req.iotlb.offset =3D offset;
> >>>>>> +     msg->req.iotlb.iova =3D iova;
> >>>>>> +     msg->req.iotlb.size =3D size;
> >>>>>> +     msg->req.iotlb.perm =3D perm;
> >>>>>> +     msg->req.iotlb.fd =3D -1;
> >>>>>> +     msg->iotlb_file =3D get_file(file);
> >>>>>> +
> >>>>>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>>>> My feeling is that we should provide consistent API for the userspa=
ce
> >>>>> device to use.
> >>>>>
> >>>>> E.g we'd better carry the IOTLB message for both virtio/vhost drive=
rs.
> >>>>>
> >>>>> It looks to me for virtio drivers we can still use UPDAT_IOTLB mess=
age
> >>>>> by using VDUSE file as msg->iotlb_file here.
> >>>>>
> >>>> It's OK for me. One problem is when to transfer the UPDATE_IOTLB
> >>>> message in virtio cases.
> >>>
> >>> Instead of generating IOTLB messages for userspace.
> >>>
> >>> How about record the mappings (which is a common case for device have
> >>> on-chip IOMMU e.g mlx5e and vdpa simlator), then we can introduce ioc=
tl
> >>> for userspace to query?
> >>>
> >> If so, the IOTLB UPDATE is actually triggered by ioctl, but
> >> IOTLB_INVALIDATE is triggered by the message. Is it a little odd? Or
> >> how about trigger it when userspace call mmap() on the device fd?
> >>
> > Oh sorry, looks like mmap() needs to be called in IOTLB UPDATE message
> > handler. Is it possible for the vdpa device to know which vdpa bus it
> > is attached to?
>
>
> We'd better not. It's kind of layer violation.
>

OK. Now I think both ioctl and message are needed. The ioctl is useful
when VDUSE userspace daemon reboot. And the IOTLB_UPDATE message could
be generated during the first DMA mapping in the virtio-vdpa case.

Thanks,
Yongji
