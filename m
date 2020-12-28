Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF782E34F8
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 09:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgL1IPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 03:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgL1IPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 03:15:07 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84D2C061795
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 00:14:26 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id 6so13209297ejz.5
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 00:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pdUVhZZoD73iZZaWy47RptTdXwr6Fs6H6YNsjspMfnc=;
        b=rGetNqB+aGY/xVlipnoIT0fAIAGr/yBoQGgx2lPEiyYnB8gfivT8wIv8WU2aysCfDO
         qwlaENDU9RsIErLtxrP7YWlwbOY4L1UCHBptLr+boI3G1i38hyaR664YiyXBnPNFDBpM
         0HBs4CzwS3IDlvgtQrbefhLPP7gPAD3WY4Ej6mlmUsCaEzxfAWZgZg9I/0te1+bfgQVr
         HAZwsSfZ1x7/hVOAEka56mBZVwVyUbrFcxglR82DUiuhWlb2y4Gl152cw5t7EuQF2Aqt
         6VhsIYdjs2QV9ZD1Yf0AQG5fv4HZhQdUDJeWzVJ+QKmu+kVdfrKR8ndKH9S3zLz9sDds
         V/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pdUVhZZoD73iZZaWy47RptTdXwr6Fs6H6YNsjspMfnc=;
        b=UclTWOkEDmyF3+o0CXLgch6yj7DZPghbCGtW2lF9qWrXct2VoUhtO4LRvXzSdIcpj2
         EPgcN1YbVK4hrraTqOPaMvATS1XNTYfJ1ssCktrwP61+IstHPAXPYKmUzO/bv0KjNznJ
         wCtRYJ9G0Qfob7qekoMm7lLAx+Yrt6n32udD3Cd3exOnMCy9QL9U/Nn6ovYI39h7q41j
         KPx+deqfmGcHSJP/72ng/QONh8fb+QFizPjCojGvlx+2jdZDlTDB3QXsrxwPfAgDMtF3
         yfeEY7E3ir9fkqwA65UfYKW6ZsAVoL3Eptxlp0m6/7JouyaB3bM5AnbdyS5fSwPkCRu8
         GXQw==
X-Gm-Message-State: AOAM531r68VtEmzMsg5k0dlZdVvIh2T22ZYKxKefaEdjehmirdJtuVFs
        g2/uuJPphxSWGxetAINAXr4/KqiGlt8TdvMK650Trh30m/x6
X-Google-Smtp-Source: ABdhPJwbxfSEbmzvq4wvRiInGgXqJZk2slatkY0WzHI97TYYQyUD8aoWsACzZHQX4SEdFBjcKHVC/Dr4TbPobxkdr1Q=
X-Received: by 2002:a17:906:edc8:: with SMTP id sb8mr40936245ejb.247.1609143265352;
 Mon, 28 Dec 2020 00:14:25 -0800 (PST)
MIME-Version: 1.0
References: <20201222145221.711-1-xieyongji@bytedance.com> <20201222145221.711-10-xieyongji@bytedance.com>
 <6818a214-d587-4f0b-7de6-13c4e7e94ab6@redhat.com> <CACycT3vVU9vg6R6UujSnSdk8cwxWPVgeJJs0JaBH_Zg4xC-epQ@mail.gmail.com>
 <595fe7d6-7876-26e4-0b7c-1d63ca6d7a97@redhat.com> <CACycT3s=m=PQb5WFoMGhz8TNGme4+=rmbbBTtrugF9ZmNnWxEw@mail.gmail.com>
 <0e6faf9c-117a-e23c-8d6d-488d0ec37412@redhat.com> <CACycT3uwXBYvRbKDWdN3oCekv+o6_Lc=-KTrxejD=fr-zgibGw@mail.gmail.com>
 <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com>
In-Reply-To: <2b24398c-e6d9-14ec-2c0d-c303d528e377@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 28 Dec 2020 16:14:14 +0800
Message-ID: <CACycT3uDV43ecScrMh1QVpStuwDETHykJzzY=pkmZjP2Dd2kvg@mail.gmail.com>
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

On Mon, Dec 28, 2020 at 3:43 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/25 =E4=B8=8B=E5=8D=886:31, Yongji Xie wrote:
> > On Fri, Dec 25, 2020 at 2:58 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2020/12/24 =E4=B8=8B=E5=8D=883:37, Yongji Xie wrote:
> >>> On Thu, Dec 24, 2020 at 10:41 AM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>> On 2020/12/23 =E4=B8=8B=E5=8D=888:14, Yongji Xie wrote:
> >>>>> On Wed, Dec 23, 2020 at 5:05 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2020/12/22 =E4=B8=8B=E5=8D=8810:52, Xie Yongji wrote:
> >>>>>>> To support vhost-vdpa bus driver, we need a way to share the
> >>>>>>> vhost-vdpa backend process's memory with the userspace VDUSE proc=
ess.
> >>>>>>>
> >>>>>>> This patch tries to make use of the vhost iotlb message to achiev=
e
> >>>>>>> that. We will get the shm file from the iotlb message and pass it
> >>>>>>> to the userspace VDUSE process.
> >>>>>>>
> >>>>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>>>>>> ---
> >>>>>>>      Documentation/driver-api/vduse.rst |  15 +++-
> >>>>>>>      drivers/vdpa/vdpa_user/vduse_dev.c | 147 +++++++++++++++++++=
+++++++++++++++++-
> >>>>>>>      include/uapi/linux/vduse.h         |  11 +++
> >>>>>>>      3 files changed, 171 insertions(+), 2 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/Documentation/driver-api/vduse.rst b/Documentation/d=
river-api/vduse.rst
> >>>>>>> index 623f7b040ccf..48e4b1ba353f 100644
> >>>>>>> --- a/Documentation/driver-api/vduse.rst
> >>>>>>> +++ b/Documentation/driver-api/vduse.rst
> >>>>>>> @@ -46,13 +46,26 @@ The following types of messages are provided =
by the VDUSE framework now:
> >>>>>>>
> >>>>>>>      - VDUSE_GET_CONFIG: Read from device specific configuration =
space
> >>>>>>>
> >>>>>>> +- VDUSE_UPDATE_IOTLB: Update the memory mapping in device IOTLB
> >>>>>>> +
> >>>>>>> +- VDUSE_INVALIDATE_IOTLB: Invalidate the memory mapping in devic=
e IOTLB
> >>>>>>> +
> >>>>>>>      Please see include/linux/vdpa.h for details.
> >>>>>>>
> >>>>>>> -In the data path, VDUSE framework implements a MMU-based on-chip=
 IOMMU
> >>>>>>> +The data path of userspace vDPA device is implemented in differe=
nt ways
> >>>>>>> +depending on the vdpa bus to which it is attached.
> >>>>>>> +
> >>>>>>> +In virtio-vdpa case, VDUSE framework implements a MMU-based on-c=
hip IOMMU
> >>>>>>>      driver which supports mapping the kernel dma buffer to a use=
rspace iova
> >>>>>>>      region dynamically. The userspace iova region can be created=
 by passing
> >>>>>>>      the userspace vDPA device fd to mmap(2).
> >>>>>>>
> >>>>>>> +In vhost-vdpa case, the dma buffer is reside in a userspace memo=
ry region
> >>>>>>> +which will be shared to the VDUSE userspace processs via the fil=
e
> >>>>>>> +descriptor in VDUSE_UPDATE_IOTLB message. And the corresponding =
address
> >>>>>>> +mapping (IOVA of dma buffer <-> VA of the memory region) is also=
 included
> >>>>>>> +in this message.
> >>>>>>> +
> >>>>>>>      Besides, the eventfd mechanism is used to trigger interrupt =
callbacks and
> >>>>>>>      receive virtqueue kicks in userspace. The following ioctls o=
n the userspace
> >>>>>>>      vDPA device fd are provided to support that:
> >>>>>>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vd=
pa_user/vduse_dev.c
> >>>>>>> index b974333ed4e9..d24aaacb6008 100644
> >>>>>>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> >>>>>>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> >>>>>>> @@ -34,6 +34,7 @@
> >>>>>>>
> >>>>>>>      struct vduse_dev_msg {
> >>>>>>>          struct vduse_dev_request req;
> >>>>>>> +     struct file *iotlb_file;
> >>>>>>>          struct vduse_dev_response resp;
> >>>>>>>          struct list_head list;
> >>>>>>>          wait_queue_head_t waitq;
> >>>>>>> @@ -325,12 +326,80 @@ static int vduse_dev_set_vq_state(struct vd=
use_dev *dev,
> >>>>>>>          return ret;
> >>>>>>>      }
> >>>>>>>
> >>>>>>> +static int vduse_dev_update_iotlb(struct vduse_dev *dev, struct =
file *file,
> >>>>>>> +                             u64 offset, u64 iova, u64 size, u8 =
perm)
> >>>>>>> +{
> >>>>>>> +     struct vduse_dev_msg *msg;
> >>>>>>> +     int ret;
> >>>>>>> +
> >>>>>>> +     if (!size)
> >>>>>>> +             return -EINVAL;
> >>>>>>> +
> >>>>>>> +     msg =3D vduse_dev_new_msg(dev, VDUSE_UPDATE_IOTLB);
> >>>>>>> +     msg->req.size =3D sizeof(struct vduse_iotlb);
> >>>>>>> +     msg->req.iotlb.offset =3D offset;
> >>>>>>> +     msg->req.iotlb.iova =3D iova;
> >>>>>>> +     msg->req.iotlb.size =3D size;
> >>>>>>> +     msg->req.iotlb.perm =3D perm;
> >>>>>>> +     msg->req.iotlb.fd =3D -1;
> >>>>>>> +     msg->iotlb_file =3D get_file(file);
> >>>>>>> +
> >>>>>>> +     ret =3D vduse_dev_msg_sync(dev, msg);
> >>>>>> My feeling is that we should provide consistent API for the usersp=
ace
> >>>>>> device to use.
> >>>>>>
> >>>>>> E.g we'd better carry the IOTLB message for both virtio/vhost driv=
ers.
> >>>>>>
> >>>>>> It looks to me for virtio drivers we can still use UPDAT_IOTLB mes=
sage
> >>>>>> by using VDUSE file as msg->iotlb_file here.
> >>>>>>
> >>>>> It's OK for me. One problem is when to transfer the UPDATE_IOTLB
> >>>>> message in virtio cases.
> >>>> Instead of generating IOTLB messages for userspace.
> >>>>
> >>>> How about record the mappings (which is a common case for device hav=
e
> >>>> on-chip IOMMU e.g mlx5e and vdpa simlator), then we can introduce io=
ctl
> >>>> for userspace to query?
> >>>>
> >>> If so, the IOTLB UPDATE is actually triggered by ioctl, but
> >>> IOTLB_INVALIDATE is triggered by the message. Is it a little odd?
> >>
> >> Good point.
> >>
> >> Some questions here:
> >>
> >> 1) Userspace think the IOTLB was flushed after IOTLB_INVALIDATE syscal=
l
> >> is returned. But this patch doesn't have this guarantee. Can this lead
> >> some issues?
> > I'm not sure. But should it be guaranteed in VDUSE userspace? Just
> > like what vhost-user backend process does.
>
>
> I think so. This is because the userspace device needs a way to
> synchronize invalidation with its datapath. Otherwise, guest may thing
> the buffer is freed to be used by other parts but the it actually can be
> used by the VDUSE device. The may cause security issues.
>
>
> >
> >> 2) I think after VDUSE userspace receives IOTLB_INVALIDATE, it needs t=
o
> >> issue a munmap(). What if it doesn't do that?
> >>
> > Yes, the munmap() is needed. If it doesn't do that, VDUSE userspace
> > could still access the corresponding guest memory region.
>
>
> I see. So all the above two questions are because VHOST_IOTLB_INVALIDATE
> is expected to be synchronous. This need to be solved by tweaking the
> current VDUSE API or we can re-visit to go with descriptors relaying firs=
t.
>

Actually all vdpa related operations are synchronous in current
implementation. The ops.set_map/dma_map/dma_unmap should not return
until the VDUSE_UPDATE_IOTLB/VDUSE_INVALIDATE_IOTLB message is replied
by userspace. Could it solve this problem?

Thanks,
Yongji
