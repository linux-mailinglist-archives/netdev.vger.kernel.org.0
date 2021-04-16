Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F62D361824
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237782AbhDPDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234992AbhDPDUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:20:20 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65984C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:19:55 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id bx20so29380652edb.12
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BqKepk3n3iisXOAz1ZMwoseQpwEHSCEPTdaF5u3KV8c=;
        b=GK7AU6AIt+0uOahN6bWKClCM2qcp/btf3gF3MMEGA/QX+jVRtFfOqAinaSqZsNlPHj
         AaRX5m2jyv0oCrQexdAgFPJEwbcGQrU74NlE0CWjI0iqXoR+Mbed7Wv2vnIpMot8NUgC
         gk8YAniHs/oTIYSDZW16Tld2Cmjx+o5cUq4IjYg1dulJniYMshI+9XaGoue07UBEWI/a
         WxgYDpgmzcEwOFXfuqhcm434TGtgI/E5mMbbn4Pdg4Ypd2bzP1M2jmdbHw1WxyAH99KZ
         2VV7ncEMGg5+eiUSorI2k/HqDl4u3eFgazL4vT7Wu59Hah2VTr+9AtBRz2BsjwbfohEX
         R06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BqKepk3n3iisXOAz1ZMwoseQpwEHSCEPTdaF5u3KV8c=;
        b=nN5J6+nXZJZI32VgWlEp1i0JOSz0Q4BaBDKrLxCT8MJrEIUBaaZ0UqzWk8fYxblR3K
         HsCMo7UO5XuqlDm2sZED/dWodvmypH7I8rJetU6OgXb26UpzJ0CdWvhXkaPsCCfnL1S/
         VvnL//TVcB4xuHXtxezTqtFMNfYPXu9LqBYiOGnyYHIh3zrCG1kErLABYAXw1ncM79xY
         gh72sx3yUiXHt/JGPwaurydHB5YiRjHli4xXVQ83JEuQZlt4teFuHCgvayQPGsPWH80S
         N8slybrcTOeSePxCGHqh8r0Afg3MZnExyGxBGCev38hReoxBHuQX7WgnkxguBUk+UqsO
         tJHQ==
X-Gm-Message-State: AOAM532f5jhCS5DCX3jG1nmWJ+as4BDfT402VhrSnDSCZecCl2SSscDr
        f8ioag4dGpblg2/TUeAv0u0jx+VOEbt7euBdjAVj
X-Google-Smtp-Source: ABdhPJxGTg3ZGro05RYsnqHORW80T9or2KhOn1zwF04zBCf1X54e0MQiyoCAYWfBPCkRWISdy418LcXMhWAwwXpdtGM=
X-Received: by 2002:a05:6402:5149:: with SMTP id n9mr7514445edd.195.1618543194146;
 Thu, 15 Apr 2021 20:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain> <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <YHhP4i+yXgA2KkVJ@stefanha-x1.localdomain> <31aa139a-dd4e-ba8a-c671-a2a1c69c1ffc@redhat.com>
In-Reply-To: <31aa139a-dd4e-ba8a-c671-a2a1c69c1ffc@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 16 Apr 2021 11:19:43 +0800
Message-ID: <CACycT3u_qAE=D_ezLPU9SpXPMACErmpqpH5pMg0TZAb3CZVGdg@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 10:24 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=8810:38, Stefan Hajnoczi =E5=86=99=E9=
=81=93:
> > On Thu, Apr 15, 2021 at 04:36:35PM +0800, Jason Wang wrote:
> >> =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=883:19, Stefan Hajnoczi =E5=86=99=
=E9=81=93:
> >>> On Thu, Apr 15, 2021 at 01:38:37PM +0800, Yongji Xie wrote:
> >>>> On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
> >>>>> On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> >>>>>> VDUSE (vDPA Device in Userspace) is a framework to support
> >>>>>> implementing software-emulated vDPA devices in userspace. This
> >>>>>> document is intended to clarify the VDUSE design and usage.
> >>>>>>
> >>>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>>>>> ---
> >>>>>>    Documentation/userspace-api/index.rst |   1 +
> >>>>>>    Documentation/userspace-api/vduse.rst | 212 +++++++++++++++++++=
+++++++++++++++
> >>>>>>    2 files changed, 213 insertions(+)
> >>>>>>    create mode 100644 Documentation/userspace-api/vduse.rst
> >>>>> Just looking over the documentation briefly (I haven't studied the =
code
> >>>>> yet)...
> >>>>>
> >>>> Thank you!
> >>>>
> >>>>>> +How VDUSE works
> >>>>>> +------------
> >>>>>> +Each userspace vDPA device is created by the VDUSE_CREATE_DEV ioc=
tl on
> >>>>>> +the character device (/dev/vduse/control). Then a device file wit=
h the
> >>>>>> +specified name (/dev/vduse/$NAME) will appear, which can be used =
to
> >>>>>> +implement the userspace vDPA device's control path and data path.
> >>>>> These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
> >>>>> message? (Please consider reordering the documentation to make it c=
lear
> >>>>> what the sequence of steps are.)
> >>>>>
> >>>> No, VDUSE devices should be created before sending the
> >>>> VDPA_CMD_DEV_NEW netlink messages which might produce I/Os to VDUSE.
> >>> I see. Please include an overview of the steps before going into deta=
il.
> >>> Something like:
> >>>
> >>>     VDUSE devices are started as follows:
> >>>
> >>>     1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> >>>        /dev/vduse/control.
> >>>
> >>>     2. Begin processing VDUSE messages from /dev/vduse/$NAME. The fir=
st
> >>>        messages will arrive while attaching the VDUSE instance to vDP=
A.
> >>>
> >>>     3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
> >>>        instance to vDPA.
> >>>
> >>>     VDUSE devices are stopped as follows:
> >>>
> >>>     ...
> >>>
> >>>>>> +     static int netlink_add_vduse(const char *name, int device_id=
)
> >>>>>> +     {
> >>>>>> +             struct nl_sock *nlsock;
> >>>>>> +             struct nl_msg *msg;
> >>>>>> +             int famid;
> >>>>>> +
> >>>>>> +             nlsock =3D nl_socket_alloc();
> >>>>>> +             if (!nlsock)
> >>>>>> +                     return -ENOMEM;
> >>>>>> +
> >>>>>> +             if (genl_connect(nlsock))
> >>>>>> +                     goto free_sock;
> >>>>>> +
> >>>>>> +             famid =3D genl_ctrl_resolve(nlsock, VDPA_GENL_NAME);
> >>>>>> +             if (famid < 0)
> >>>>>> +                     goto close_sock;
> >>>>>> +
> >>>>>> +             msg =3D nlmsg_alloc();
> >>>>>> +             if (!msg)
> >>>>>> +                     goto close_sock;
> >>>>>> +
> >>>>>> +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, fam=
id, 0, 0,
> >>>>>> +                 VDPA_CMD_DEV_NEW, 0))
> >>>>>> +                     goto nla_put_failure;
> >>>>>> +
> >>>>>> +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> >>>>>> +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "vdu=
se");
> >>>>>> +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
> >>>>> What are the permission/capability requirements for VDUSE?
> >>>>>
> >>>> Now I think we need privileged permission (root user). Because
> >>>> userspace daemon is able to access avail vring, used vring, descript=
or
> >>>> table in kernel driver directly.
> >>> Please state this explicitly at the start of the document. Existing
> >>> interfaces like FUSE are designed to avoid trusting userspace.
> >>
> >> There're some subtle difference here. VDUSE present a device to kernel=
 which
> >> means IOMMU is probably the only thing to prevent a malicous device.
> >>
> >>
> >>> Therefore
> >>> people might think the same is the case here. It's critical that peop=
le
> >>> are aware of this before deploying VDUSE with virtio-vdpa.
> >>>
> >>> We should probably pause here and think about whether it's possible t=
o
> >>> avoid trusting userspace. Even if it takes some effort and costs some
> >>> performance it would probably be worthwhile.
> >>
> >> Since the bounce buffer is used the only attack surface is the coheren=
t
> >> area, if we want to enforce stronger isolation we need to use shadow
> >> virtqueue (which is proposed in earlier version by me) in this case. B=
ut I'm
> >> not sure it's worth to do that.
> > The security situation needs to be clear before merging this feature.
>
>
> +1
>
>
> >
> > I think the IOMMU and vring can be made secure. What is more concerning
> > is the kernel code that runs on top: VIRTIO device drivers, network
> > stack, file systems, etc. They trust devices to an extent.
> >
> > Since virtio-vdpa is a big reason for doing VDUSE in the first place I
> > don't think it makes sense to disable virtio-vdpa with VDUSE. A solutio=
n
> > is needed.
>
>
> Yes, so the case of VDUSE is something similar to the case of e.g SEV.
>
> Both cases won't trust device and use some kind of software IOTLB.
>
> That means we need to protect at both IOTLB and virtio drivers.
>
> Let me post patches for virtio first.
>

Looking forward your patches.

Thanks.
Yongji
