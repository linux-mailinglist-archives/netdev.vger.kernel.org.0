Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71FC36181A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 05:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237861AbhDPDOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 23:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbhDPDOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 23:14:17 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DF6C06175F
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:13:53 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id w23so24146071ejb.9
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 20:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oPn6nrbtIIi/otRhY/sdadda9UqY0FLEvAtSn1BGbPk=;
        b=jLoGDYGY3a5INx2p3ZGtEjh5krsUmpMORqpU/X5oAFvhXFQbvFNcR4/xoxTy/3PUZd
         TUMKdWcs92hQMy6cgZj9u2+DbJ4iWSb/dUaUKR/C+D2nsjjH6cV+nY43CXZQc4JahNPG
         LdpK1lJO5C63OAMfWYHkyFWegVdayQhceCm+o1fGGF6Sp5dGw7LbHFIR3uFqWliqmdC9
         +Fzq7Kni01pKs7Axa5cwY4xoQ6+QevG+P/gOPB5Y2ThaseQV+MG7WE7CBoJFAxlABn13
         Hjls2V/6Bw+kDhDU4492BagFy/ptGpuuybUajRRbm0onh+i/PTVwHJD4x1FBZwNxpEZB
         ttGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oPn6nrbtIIi/otRhY/sdadda9UqY0FLEvAtSn1BGbPk=;
        b=VNe2JghPYGzEdzC4cpeU/ZfcLl/9uePpLF8Hks9XuHg9DD8epeD6c84WiY2WOccEod
         jjusP8d1ZR8h4T9eeyjMubpCW0lHKVZyO9VP/MTmtOiw+0etoOFOGAb0L0bK5CppKv53
         nDGMiCIQ0XvRy64rQRyjLPMHPS8kfUX7cq4qCMCC7awTGKqhtdCyI96QZHm3SSo7r9uc
         ZRzxEVa3y+p9uzzlklj4T0uu5RI+Rt9wJLErp1TMu41TgoNx1MztPGihsttToTDA2j+L
         bYqHUhAaYyXlIwC0Ao/4EVJMeZBVUQ2EMWXqhjyQPgIx1jrD8vXYT8IAio3te50SuQCI
         qvhQ==
X-Gm-Message-State: AOAM531DN29e9azYVehDs86fZeaNi9i7KKvwkh33fVP/O9snpqgvBWLX
        /1N4NYegQFFblBAM6Nt/tjcSDpjN51JVIjOxEEPX
X-Google-Smtp-Source: ABdhPJyUlL90ZzXalWJXx8x39M0xoyCR8uJMNvALHlYLKd5/jJj401j1kaYO/M9OEl4x96SAQPWJT3mAagbavWrSL+Y=
X-Received: by 2002:a17:906:af5a:: with SMTP id ly26mr6250717ejb.372.1618542831901;
 Thu, 15 Apr 2021 20:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210331080519.172-1-xieyongji@bytedance.com> <20210331080519.172-11-xieyongji@bytedance.com>
 <YHb44R4HyLEUVSTF@stefanha-x1.localdomain> <CACycT3uNR+nZY5gY0UhPkeOyi7Za6XkX4b=hasuDcgqdc7fqfg@mail.gmail.com>
 <YHfo8pc7dIO9lNc3@stefanha-x1.localdomain> <80b31814-9e41-3153-7efb-c0c2fab44feb@redhat.com>
 <YHhP4i+yXgA2KkVJ@stefanha-x1.localdomain>
In-Reply-To: <YHhP4i+yXgA2KkVJ@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 16 Apr 2021 11:13:41 +0800
Message-ID: <CACycT3uNNbDPdxDk+0ry4vRJ4PU0oKqbpwc9bqKPOJHBcyLnww@mail.gmail.com>
Subject: Re: Re: [PATCH v6 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
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

On Thu, Apr 15, 2021 at 10:38 PM Stefan Hajnoczi <stefanha@redhat.com> wrot=
e:
>
> On Thu, Apr 15, 2021 at 04:36:35PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2021/4/15 =E4=B8=8B=E5=8D=883:19, Stefan Hajnoczi =E5=86=99=
=E9=81=93:
> > > On Thu, Apr 15, 2021 at 01:38:37PM +0800, Yongji Xie wrote:
> > > > On Wed, Apr 14, 2021 at 10:15 PM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
> > > > > On Wed, Mar 31, 2021 at 04:05:19PM +0800, Xie Yongji wrote:
> > > > > > VDUSE (vDPA Device in Userspace) is a framework to support
> > > > > > implementing software-emulated vDPA devices in userspace. This
> > > > > > document is intended to clarify the VDUSE design and usage.
> > > > > >
> > > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > > ---
> > > > > >   Documentation/userspace-api/index.rst |   1 +
> > > > > >   Documentation/userspace-api/vduse.rst | 212 +++++++++++++++++=
+++++++++++++++++
> > > > > >   2 files changed, 213 insertions(+)
> > > > > >   create mode 100644 Documentation/userspace-api/vduse.rst
> > > > > Just looking over the documentation briefly (I haven't studied th=
e code
> > > > > yet)...
> > > > >
> > > > Thank you!
> > > >
> > > > > > +How VDUSE works
> > > > > > +------------
> > > > > > +Each userspace vDPA device is created by the VDUSE_CREATE_DEV =
ioctl on
> > > > > > +the character device (/dev/vduse/control). Then a device file =
with the
> > > > > > +specified name (/dev/vduse/$NAME) will appear, which can be us=
ed to
> > > > > > +implement the userspace vDPA device's control path and data pa=
th.
> > > > > These steps are taken after sending the VDPA_CMD_DEV_NEW netlink
> > > > > message? (Please consider reordering the documentation to make it=
 clear
> > > > > what the sequence of steps are.)
> > > > >
> > > > No, VDUSE devices should be created before sending the
> > > > VDPA_CMD_DEV_NEW netlink messages which might produce I/Os to VDUSE=
.
> > > I see. Please include an overview of the steps before going into deta=
il.
> > > Something like:
> > >
> > >    VDUSE devices are started as follows:
> > >
> > >    1. Create a new VDUSE instance with ioctl(VDUSE_CREATE_DEV) on
> > >       /dev/vduse/control.
> > >
> > >    2. Begin processing VDUSE messages from /dev/vduse/$NAME. The firs=
t
> > >       messages will arrive while attaching the VDUSE instance to vDPA=
.
> > >
> > >    3. Send the VDPA_CMD_DEV_NEW netlink message to attach the VDUSE
> > >       instance to vDPA.
> > >
> > >    VDUSE devices are stopped as follows:
> > >
> > >    ...
> > >
> > > > > > +     static int netlink_add_vduse(const char *name, int device=
_id)
> > > > > > +     {
> > > > > > +             struct nl_sock *nlsock;
> > > > > > +             struct nl_msg *msg;
> > > > > > +             int famid;
> > > > > > +
> > > > > > +             nlsock =3D nl_socket_alloc();
> > > > > > +             if (!nlsock)
> > > > > > +                     return -ENOMEM;
> > > > > > +
> > > > > > +             if (genl_connect(nlsock))
> > > > > > +                     goto free_sock;
> > > > > > +
> > > > > > +             famid =3D genl_ctrl_resolve(nlsock, VDPA_GENL_NAM=
E);
> > > > > > +             if (famid < 0)
> > > > > > +                     goto close_sock;
> > > > > > +
> > > > > > +             msg =3D nlmsg_alloc();
> > > > > > +             if (!msg)
> > > > > > +                     goto close_sock;
> > > > > > +
> > > > > > +             if (!genlmsg_put(msg, NL_AUTO_PORT, NL_AUTO_SEQ, =
famid, 0, 0,
> > > > > > +                 VDPA_CMD_DEV_NEW, 0))
> > > > > > +                     goto nla_put_failure;
> > > > > > +
> > > > > > +             NLA_PUT_STRING(msg, VDPA_ATTR_DEV_NAME, name);
> > > > > > +             NLA_PUT_STRING(msg, VDPA_ATTR_MGMTDEV_DEV_NAME, "=
vduse");
> > > > > > +             NLA_PUT_U32(msg, VDPA_ATTR_DEV_ID, device_id);
> > > > > What are the permission/capability requirements for VDUSE?
> > > > >
> > > > Now I think we need privileged permission (root user). Because
> > > > userspace daemon is able to access avail vring, used vring, descrip=
tor
> > > > table in kernel driver directly.
> > > Please state this explicitly at the start of the document. Existing
> > > interfaces like FUSE are designed to avoid trusting userspace.
> >
> >
> > There're some subtle difference here. VDUSE present a device to kernel =
which
> > means IOMMU is probably the only thing to prevent a malicous device.
> >
> >
> > > Therefore
> > > people might think the same is the case here. It's critical that peop=
le
> > > are aware of this before deploying VDUSE with virtio-vdpa.
> > >
> > > We should probably pause here and think about whether it's possible t=
o
> > > avoid trusting userspace. Even if it takes some effort and costs some
> > > performance it would probably be worthwhile.
> >
> >
> > Since the bounce buffer is used the only attack surface is the coherent
> > area, if we want to enforce stronger isolation we need to use shadow
> > virtqueue (which is proposed in earlier version by me) in this case. Bu=
t I'm
> > not sure it's worth to do that.
>
> The security situation needs to be clear before merging this feature.
>
> I think the IOMMU and vring can be made secure. What is more concerning
> is the kernel code that runs on top: VIRTIO device drivers, network
> stack, file systems, etc. They trust devices to an extent.
>

I will dig into it to see if there is any security issue.

> Since virtio-vdpa is a big reason for doing VDUSE in the first place I
> don't think it makes sense to disable virtio-vdpa with VDUSE. A solution
> is needed.
>
> I'm going to be offline for a week and don't want to be a bottleneck.
> I'll catch up when I'm back.
>

Thanks for your comments!

Thanks,
Yongji
