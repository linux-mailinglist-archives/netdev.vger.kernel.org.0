Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC973B907B
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 12:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhGAK3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 06:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbhGAK3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 06:29:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA52C061756
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 03:26:34 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i24so7672055edx.4
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 03:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a9K4jyXYx47Q8btyuDKrrTrq0PEaaUA3+QP6HJIrGos=;
        b=UbsrHWUQ+mj/292xk46YRGIEWdXS7+QUOxq+6nNb3yIUs4zHYJrkuHGgQOce8DFrQe
         md9AW7iO+3I2/Gy/0pAB4ksC45W+234IMOkL++jK9Ut5s1vRLJE3bHdXjN761/r4oe2f
         rrENVsppo3Jrt+VvPkoj8uviilfOhQYD1fLZsSYmxlaq+oX/ZAl36g/kjQIzB82UT/ci
         MsYhbtWrw18oEv5eBIolntsiKHP3qi59dFbBWXD2KwR7OAOnPaSBv5xvF7/vHO2gDnY9
         DYJCzMg6LY4GJsFkzIZYE13B6X8/NPbpnEh/pX4mSS3+UYLngtGXoFLSkaU2VGZ/3SUB
         VdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a9K4jyXYx47Q8btyuDKrrTrq0PEaaUA3+QP6HJIrGos=;
        b=lzcFlBNEp0pnrOoy3aRBj9ihM70zDLzy+Dl93q2jAC52XzNZZRx/lkXg7TjMCuQTOK
         GCIaEeuyza+lCpX+3eMrOJ9Q0UDugK9lM/m6jlAb4LgZ7OPm/VIPI67cxULhP9LP+w3K
         dbYLjmum+l1TZnS7UnXybydB4ABolozXKCCeqEybQmbfR/5ZeVRxi//3RGtYsmSS+h/p
         4yw82gmbWuF5Zg82t3jYJPYdQLohlOaBy5YMjCiSGMTmcLZzr++3W3McMyIoxt1fuydq
         l9G5evNuOqYi/GMKsv6DtfYOLDMAswj6rP+cxebHHjbwr2LrhBlOj37GAOjxeZ6h/9bV
         NlyA==
X-Gm-Message-State: AOAM533nBcgZdyvSBKl4eDHv2qHvwJ2tUN9eOU2eg8Jby2IVGAtNxfYt
        1sGjCNPBY8Nuep33qRHEkb7hZjmZZCRIkec/IQN9
X-Google-Smtp-Source: ABdhPJz1/meMgJS0CbGomq08efo6oPox9DOh/ZiqfZwarY0z7LVGZFk2nW7ff1FIg7dKAGvVHmDMMOZVK5XkBCN2Y10=
X-Received: by 2002:a50:ff01:: with SMTP id a1mr52286665edu.253.1625135192829;
 Thu, 01 Jul 2021 03:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-10-xieyongji@bytedance.com>
 <YNSatrDFsg+4VvH4@stefanha-x1.localdomain> <CACycT3vaXQ4dxC9QUzXXJs7og6TVqqVGa8uHZnTStacsYAiFwQ@mail.gmail.com>
 <YNw+q/ADMPviZi6S@stefanha-x1.localdomain> <CACycT3t6M5i0gznABm52v=rdmeeLZu8smXAOLg+WsM3WY1fgTw@mail.gmail.com>
 <7264cb0b-7072-098e-3d22-2b7e89216545@redhat.com>
In-Reply-To: <7264cb0b-7072-098e-3d22-2b7e89216545@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 1 Jul 2021 18:26:21 +0800
Message-ID: <CACycT3v7pYXAFtijPgWCMZ2WXxjT2Y-DUwS3hN_T7dhfE5o_6g@mail.gmail.com>
Subject: Re: Re: [PATCH v8 09/10] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 3:55 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/1 =E4=B8=8B=E5=8D=882:50, Yongji Xie =E5=86=99=E9=81=93:
> > On Wed, Jun 30, 2021 at 5:51 PM Stefan Hajnoczi <stefanha@redhat.com> w=
rote:
> >> On Tue, Jun 29, 2021 at 10:59:51AM +0800, Yongji Xie wrote:
> >>> On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com>=
 wrote:
> >>>> On Tue, Jun 15, 2021 at 10:13:30PM +0800, Xie Yongji wrote:
> >>>>> +/* ioctls */
> >>>>> +
> >>>>> +struct vduse_dev_config {
> >>>>> +     char name[VDUSE_NAME_MAX]; /* vduse device name */
> >>>>> +     __u32 vendor_id; /* virtio vendor id */
> >>>>> +     __u32 device_id; /* virtio device id */
> >>>>> +     __u64 features; /* device features */
> >>>>> +     __u64 bounce_size; /* bounce buffer size for iommu */
> >>>>> +     __u16 vq_size_max; /* the max size of virtqueue */
> >>>> The VIRTIO specification allows per-virtqueue sizes. A device can ha=
ve
> >>>> two virtqueues, where the first one allows up to 1024 descriptors an=
d
> >>>> the second one allows only 128 descriptors, for example.
> >>>>
> >>> Good point! But it looks like virtio-vdpa/virtio-pci doesn't support
> >>> that now. All virtqueues have the same maximum size.
> >> I see struct vpda_config_ops only supports a per-device max vq size:
> >> u16 (*get_vq_num_max)(struct vdpa_device *vdev);
> >>
> >> virtio-pci supports per-virtqueue sizes because the struct
> >> virtio_pci_common_cfg->queue_size register is per-queue (controlled by
> >> queue_select).
> >>
> > Oh, yes. I miss queue_select.
> >
> >> I guess this is a question for Jason: will vdpa will keep this limitat=
ion?
> >> If yes, then VDUSE can stick to it too without running into problems i=
n
> >> the future.
>
>
> I think it's better to extend the get_vq_num_max() per virtqueue.
>
> Currently, vDPA assumes the parent to have a global max size. This seems
> to work on most of the parents but not vp-vDPA (which could be backed by
> QEMU, in that case cvq's size is smaller).
>
> Fortunately, we haven't enabled had cvq support in the userspace now.
>
> I can post the fixes.
>

OK. If so, it looks like we need to support the per-vq configuration.
I wonder if it's better to use something like: VDUSE_CREATE_DEVICE ->
VDUSE_SETUP_VQ -> VDUSE_SETUP_VQ -> ... -> VDUSE_ENABLE_DEVICE to do
initialization rather than only use VDUSE_CREATE_DEVICE.

Thanks,
Yongji
