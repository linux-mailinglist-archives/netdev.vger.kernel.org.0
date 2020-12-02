Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CBB2CB8A9
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbgLBJWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728306AbgLBJWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:22:47 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27D3C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 01:22:06 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id ga15so2752240ejb.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zLyMVWmuUt0sNAIE4pEx4EW9+sOWKqUa1L/RrHU1WNI=;
        b=fFCSNGSm1Fj+yumvHUT+yal2v7tzqbr4JTN1ETEIEcrKXtXjpMcLChUsYH1i87o/Jt
         YadzjHvJjoK/4T5jM1/42JX0R5e+34f09UvlhqNenJNk40/iqG7khbMqkw/QpMSu7Pf4
         9wzANNtAW1lWkaveIJHG34CgSHpPzLaJB+DjpuxBeMKEB0VEwGcsscphXZ+9bSMOLT69
         9mpQDwfsklE4sv6zkEsecxupe7W4WFW7X/lvQ6XwKkVdVQAfM29RZVD/UJ7F0mj66ibr
         Pt3EkNIWUcSa3HvnbdwVo5KKgSDoEZohiSADjS+BOgTtpiG8aALTF3sCjyhGztAljFV5
         lx1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zLyMVWmuUt0sNAIE4pEx4EW9+sOWKqUa1L/RrHU1WNI=;
        b=g1GLfMkQht739Igzx/FcDboMB9kL4b1dxfbt7sdxdZbcSML7MkxIsK1hkbQBlVs1H0
         ZfmvcerzZnHaQGlHiat/z0zwtK/s/edjCDxcYqnswO8TTBSqHvBa/jW1bPoApGj6eBs1
         KCZVkPAK6mTIqO/ZYM9KgU8ZSbBQBhwvKdppYaFC7UCTQNrGGp/q+lRpAVHLAZGJ0v3c
         tc+mOZ2L0Djql6G6GpyzGvQ5vFB+tO1FvOm7uclbZvlXSbffeEvWMHiQZEmOhbYPboyq
         XeJMr2y+3gSe3bivJVo1q2fwv7JI7F2oc9M4jxIcpZoXmxOwtP6I2P2x0UzqFbdfzNgC
         cqrA==
X-Gm-Message-State: AOAM530PWjva7s9yPZHtbXbeRxc7sZoQjiiboz2pFYZOIV9GMObFtQcq
        8Pocdco+mi7ErpgNjRuvQVXnuKsMKQQEyAG/uaQL
X-Google-Smtp-Source: ABdhPJxdITNa0qzyDp825wlCjh4k9jEKH1+h6zLyoeQC29CjR7y5ZFhKYfU1tZM1OoS3UyX5qDhYzLY32I9rF9qozvU=
X-Received: by 2002:a17:906:a218:: with SMTP id r24mr1375633ejy.372.1606900925614;
 Wed, 02 Dec 2020 01:22:05 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com> <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com> <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com> <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
 <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com> <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 2 Dec 2020 17:21:54 +0800
Message-ID: <CACycT3uV8e61kVF6Q8zE5VVK_Okp03e=WNRcUffdkFeeFpfKDQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 0/7] Introduce vdpa management tool
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 12:53 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Yongji Xie <xieyongji@bytedance.com>
> > Sent: Wednesday, December 2, 2020 9:00 AM
> >
> > On Tue, Dec 1, 2020 at 11:59 PM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > >
> > > > From: Yongji Xie <xieyongji@bytedance.com>
> > > > Sent: Tuesday, December 1, 2020 7:49 PM
> > > >
> > > > On Tue, Dec 1, 2020 at 7:32 PM Parav Pandit <parav@nvidia.com> wrot=
e:
> > > > >
> > > > >
> > > > >
> > > > > > From: Yongji Xie <xieyongji@bytedance.com>
> > > > > > Sent: Tuesday, December 1, 2020 3:26 PM
> > > > > >
> > > > > > On Tue, Dec 1, 2020 at 2:25 PM Jason Wang <jasowang@redhat.com>
> > > > wrote:
> > > > > > >
> > > > > > >
> > > > > > > On 2020/11/30 =E4=B8=8B=E5=8D=883:07, Yongji Xie wrote:
> > > > > > > >>> Thanks for adding me, Jason!
> > > > > > > >>>
> > > > > > > >>> Now I'm working on a v2 patchset for VDUSE (vDPA Device i=
n
> > > > > > > >>> Userspace) [1]. This tool is very useful for the vduse de=
vice.
> > > > > > > >>> So I'm considering integrating this into my v2 patchset.
> > > > > > > >>> But there is one problem=EF=BC=9A
> > > > > > > >>>
> > > > > > > >>> In this tool, vdpa device config action and enable action
> > > > > > > >>> are combined into one netlink msg: VDPA_CMD_DEV_NEW. But
> > > > > > > >>> in
> > > > vduse
> > > > > > > >>> case, it needs to be splitted because a chardev should be
> > > > > > > >>> created and opened by a userspace process before we enabl=
e
> > > > > > > >>> the vdpa device (call vdpa_register_device()).
> > > > > > > >>>
> > > > > > > >>> So I'd like to know whether it's possible (or have some
> > > > > > > >>> plans) to add two new netlink msgs something like:
> > > > > > > >>> VDPA_CMD_DEV_ENABLE
> > > > > > and
> > > > > > > >>> VDPA_CMD_DEV_DISABLE to make the config path more flexibl=
e.
> > > > > > > >>>
> > > > > > > >> Actually, we've discussed such intermediate step in some
> > > > > > > >> early discussion. It looks to me VDUSE could be one of the=
 users of
> > this.
> > > > > > > >>
> > > > > > > >> Or I wonder whether we can switch to use anonymous
> > > > > > > >> inode(fd) for VDUSE then fetching it via an VDUSE_GET_DEVI=
CE_FD
> > ioctl?
> > > > > > > >>
> > > > > > > > Yes, we can. Actually the current implementation in VDUSE i=
s
> > > > > > > > like this.  But seems like this is still a intermediate ste=
p.
> > > > > > > > The fd should be binded to a name or something else which
> > > > > > > > need to be configured before.
> > > > > > >
> > > > > > >
> > > > > > > The name could be specified via the netlink. It looks to me
> > > > > > > the real issue is that until the device is connected with a
> > > > > > > userspace, it can't be used. So we also need to fail the
> > > > > > > enabling if it doesn't
> > > > opened.
> > > > > > >
> > > > > >
> > > > > > Yes, that's true. So you mean we can firstly try to fetch the f=
d
> > > > > > binded to a name/vduse_id via an VDUSE_GET_DEVICE_FD, then use
> > > > > > the name/vduse_id as a attribute to create vdpa device? It look=
s fine to
> > me.
> > > > >
> > > > > I probably do not well understand. I tried reading patch [1] and
> > > > > few things
> > > > do not look correct as below.
> > > > > Creating the vdpa device on the bus device and destroying the
> > > > > device from
> > > > the workqueue seems unnecessary and racy.
> > > > >
> > > > > It seems vduse driver needs
> > > > > This is something should be done as part of the vdpa dev add
> > > > > command,
> > > > instead of connecting two sides separately and ensuring race free
> > > > access to it.
> > > > >
> > > > > So VDUSE_DEV_START and VDUSE_DEV_STOP should possibly be avoided.
> > > > >
> > > >
> > > > Yes, we can avoid these two ioctls with the help of the management =
tool.
> > > >
> > > > > $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> > > > >
> > > > > When above command is executed it creates necessary vdpa device
> > > > > foo2
> > > > on the bus.
> > > > > When user binds foo2 device with the vduse driver, in the probe()=
,
> > > > > it
> > > > creates respective char device to access it from user space.
> > > >
> > > I see. So vduse cannot work with any existing vdpa devices like ifc, =
mlx5 or
> > netdevsim.
> > > It has its own implementation similar to fuse with its own backend of=
 choice.
> > > More below.
> > >
> > > > But vduse driver is not a vdpa bus driver. It works like vdpasim
> > > > driver, but offloads the data plane and control plane to a user spa=
ce process.
> > >
> > > In that case to draw parallel lines,
> > >
> > > 1. netdevsim:
> > > (a) create resources in kernel sw
> > > (b) datapath simulates in kernel
> > >
> > > 2. ifc + mlx5 vdpa dev:
> > > (a) creates resource in hw
> > > (b) data path is in hw
> > >
> > > 3. vduse:
> > > (a) creates resources in userspace sw
> > > (b) data path is in user space.
> > > hence creates data path resources for user space.
> > > So char device is created, removed as result of vdpa device creation.
> > >
> > > For example,
> > > $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> > >
> > > Above command will create char device for user space.
> > >
> > > Similar command for ifc/mlx5 would have created similar channel for r=
est of
> > the config commands in hw.
> > > vduse channel =3D char device, eventfd etc.
> > > ifc/mlx5 hw channel =3D bar, irq, command interface etc Netdev sim
> > > channel =3D sw direct calls
> > >
> > > Does it make sense?
> >
> > In my understanding, to make vdpa work, we need a backend (datapath
> > resources) and a frontend (a vdpa device attached to a vdpa bus). In th=
e above
> > example, it looks like we use the command "vdpa dev add ..."
> >  to create a backend, so do we need another command to create a fronten=
d?
> >
> For block device there is certainly some backend to process the IOs.
> Sometimes backend to be setup first, before its front end is exposed.

Yes, the backend need to be setup firstly, this is vendor device
specific, not vdpa specific.

> "vdpa dev add" is the front end command who connects to the backend (impl=
icitly) for network device.
>
> vhost->vdpa_block_device->backend_io_processor (usr,hw,kernel).
>
> And it needs a way to connect to backend when explicitly specified during=
 creation time.
> Something like,
> $ vdpa dev add parentdev vdpa_vduse type block name foo3 handle <uuid>
> In above example some vendor device specific unique handle is passed base=
d on backend setup in hardware/user space.
>

Yes, we can work like this. After we setup a backend through an
anonymous inode(fd) from /dev/vduse, we can get a unique handle. Then
use it to create a frontend which will connect to the specific
backend.

> In below 3 examples, vdpa block simulator is connecting to backend block =
or file.
>
> $ vdpa dev add parentdev vdpa_blocksim type block name foo4 blockdev /dev=
/zero
>
> $ vdpa dev add parentdev vdpa_blocksim type block name foo5 blockdev /dev=
/sda2 size=3D100M offset=3D10M
>
> $ vdpa dev add parentdev vdpa_block filebackend_sim type block name foo6 =
file /root/file_backend.txt
>
> Or may be backend connects to the created vdpa device is bound to the dri=
ver.
> Can vduse attach to the created vdpa block device through the char device=
 and establish the channel to receive IOs, and to setup the block config sp=
ace?
>

How to create the vdpa block device? If we use the command "vdpa dev
add..", the command will hang there until a vduse process attaches to
the vdpa block device.

Thanks,
Yongji
