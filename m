Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEE02CB8D5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgLBJ2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgLBJ2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:28:06 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88257C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 01:27:25 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ga15so2789804ejb.4
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CGbiK6TyEMGKwnONuPCseNHCURx/ip/ZeeqFCWqA7q8=;
        b=ADUc/RPl6YYRkAK4uarh7rUWBsKk8rK+5g3NvbDKDq8uLP7ieRx+DbmnWXlt8qPewa
         cZZlgyTB6JmlCW7Q1LnElH37JQW+RQC69UAHeCkOBYwsgX0IKt5DbwLIHOq9PQI9qhG0
         pOJOE2xwyDTdSTYdpYpQ2YTHaMtSMsLO8lXjuqt6rEzySNkYrzXT50fkv/O6FvDNjfKR
         smhMaY+zG2vlDQIi9Yvxo3StwlhZmWOh3g255byoWl3Q9ix4u07ML/c40pfa1aTrG3p8
         GS29qwYk65zgTdghCIad1XRs3Vi/AMrRSieeiYJqIrjpWjZAmoqz2E37UF3BvHAGqo/b
         nR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CGbiK6TyEMGKwnONuPCseNHCURx/ip/ZeeqFCWqA7q8=;
        b=ae+srw1wUboS0ezg4ru4CaukvgXFVjqT5dXnpvbF5Rw/oVlvS1UrD+rKg8lXzjaCfZ
         LQmcuQaF+hTV7/3tEGjrMdPMV+AbVfSwkHa6H+J+8N30ICLIwcQFi6zFKTVkXZwbOXkv
         0kmtrIjd09fNUL01y5jR7pjHEax9fZqQz0oZvfDhLSho/p+23Fr2Z/jT5//Adju7GEoo
         kd6M/KBRVTGchiT3yPAapamGoLpdBHRwPKl8gIliYLxycd4BEf5Pnv05x8ZEVFaQ3POV
         /lSLnZQqQOcxKTxGvE5TXXoua08aZzvFvDeRauxaRGlZmg89jbgvj8NuWTgEivGo27zM
         jISQ==
X-Gm-Message-State: AOAM5336jSB+OnmbzJ30eHeMGmpGUs0QfdksTz8+F+2hAYo9VTXiT8Um
        e4tbEVp+Px6yI7qGHFKIUpu62l2C8Phl3cRy4RqE
X-Google-Smtp-Source: ABdhPJyWscBZGsovU8DCNS4gwkZgpqmDctKifuSuaR6SOVVugi+igRNK5Sg0l4uelpnrYiOZE8GmdL/h6SD8YNfISbs=
X-Received: by 2002:a17:906:a43:: with SMTP id x3mr1363603ejf.197.1606901244132;
 Wed, 02 Dec 2020 01:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com> <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com> <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com> <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
 <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com>
 <BY5PR12MB4322446CDB07B3CC5603F7D1DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <3d91bf80-1a35-9f79-dbca-596358acc0a7@redhat.com>
In-Reply-To: <3d91bf80-1a35-9f79-dbca-596358acc0a7@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 2 Dec 2020 17:27:13 +0800
Message-ID: <CACycT3uifi3ckbixEX1sCsU0jVRb74ONrbKS2SoMVHmq+pgLgg@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 0/7] Introduce vdpa management tool
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 1:51 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/2 =E4=B8=8B=E5=8D=8812:53, Parav Pandit wrote:
> >
> >> From: Yongji Xie <xieyongji@bytedance.com>
> >> Sent: Wednesday, December 2, 2020 9:00 AM
> >>
> >> On Tue, Dec 1, 2020 at 11:59 PM Parav Pandit <parav@nvidia.com> wrote:
> >>>
> >>>
> >>>> From: Yongji Xie <xieyongji@bytedance.com>
> >>>> Sent: Tuesday, December 1, 2020 7:49 PM
> >>>>
> >>>> On Tue, Dec 1, 2020 at 7:32 PM Parav Pandit <parav@nvidia.com> wrote=
:
> >>>>>
> >>>>>
> >>>>>> From: Yongji Xie <xieyongji@bytedance.com>
> >>>>>> Sent: Tuesday, December 1, 2020 3:26 PM
> >>>>>>
> >>>>>> On Tue, Dec 1, 2020 at 2:25 PM Jason Wang <jasowang@redhat.com>
> >>>> wrote:
> >>>>>>>
> >>>>>>> On 2020/11/30 =E4=B8=8B=E5=8D=883:07, Yongji Xie wrote:
> >>>>>>>>>> Thanks for adding me, Jason!
> >>>>>>>>>>
> >>>>>>>>>> Now I'm working on a v2 patchset for VDUSE (vDPA Device in
> >>>>>>>>>> Userspace) [1]. This tool is very useful for the vduse device.
> >>>>>>>>>> So I'm considering integrating this into my v2 patchset.
> >>>>>>>>>> But there is one problem=EF=BC=9A
> >>>>>>>>>>
> >>>>>>>>>> In this tool, vdpa device config action and enable action
> >>>>>>>>>> are combined into one netlink msg: VDPA_CMD_DEV_NEW. But
> >>>>>>>>>> in
> >>>> vduse
> >>>>>>>>>> case, it needs to be splitted because a chardev should be
> >>>>>>>>>> created and opened by a userspace process before we enable
> >>>>>>>>>> the vdpa device (call vdpa_register_device()).
> >>>>>>>>>>
> >>>>>>>>>> So I'd like to know whether it's possible (or have some
> >>>>>>>>>> plans) to add two new netlink msgs something like:
> >>>>>>>>>> VDPA_CMD_DEV_ENABLE
> >>>>>> and
> >>>>>>>>>> VDPA_CMD_DEV_DISABLE to make the config path more flexible.
> >>>>>>>>>>
> >>>>>>>>> Actually, we've discussed such intermediate step in some
> >>>>>>>>> early discussion. It looks to me VDUSE could be one of the user=
s of
> >> this.
> >>>>>>>>> Or I wonder whether we can switch to use anonymous
> >>>>>>>>> inode(fd) for VDUSE then fetching it via an VDUSE_GET_DEVICE_FD
> >> ioctl?
> >>>>>>>> Yes, we can. Actually the current implementation in VDUSE is
> >>>>>>>> like this.  But seems like this is still a intermediate step.
> >>>>>>>> The fd should be binded to a name or something else which
> >>>>>>>> need to be configured before.
> >>>>>>>
> >>>>>>> The name could be specified via the netlink. It looks to me
> >>>>>>> the real issue is that until the device is connected with a
> >>>>>>> userspace, it can't be used. So we also need to fail the
> >>>>>>> enabling if it doesn't
> >>>> opened.
> >>>>>> Yes, that's true. So you mean we can firstly try to fetch the fd
> >>>>>> binded to a name/vduse_id via an VDUSE_GET_DEVICE_FD, then use
> >>>>>> the name/vduse_id as a attribute to create vdpa device? It looks f=
ine to
> >> me.
> >>>>> I probably do not well understand. I tried reading patch [1] and
> >>>>> few things
> >>>> do not look correct as below.
> >>>>> Creating the vdpa device on the bus device and destroying the
> >>>>> device from
> >>>> the workqueue seems unnecessary and racy.
> >>>>> It seems vduse driver needs
> >>>>> This is something should be done as part of the vdpa dev add
> >>>>> command,
> >>>> instead of connecting two sides separately and ensuring race free
> >>>> access to it.
> >>>>> So VDUSE_DEV_START and VDUSE_DEV_STOP should possibly be avoided.
> >>>>>
> >>>> Yes, we can avoid these two ioctls with the help of the management t=
ool.
> >>>>
> >>>>> $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> >>>>>
> >>>>> When above command is executed it creates necessary vdpa device
> >>>>> foo2
> >>>> on the bus.
> >>>>> When user binds foo2 device with the vduse driver, in the probe(),
> >>>>> it
> >>>> creates respective char device to access it from user space.
> >>>>
> >>> I see. So vduse cannot work with any existing vdpa devices like ifc, =
mlx5 or
> >> netdevsim.
> >>> It has its own implementation similar to fuse with its own backend of=
 choice.
> >>> More below.
> >>>
> >>>> But vduse driver is not a vdpa bus driver. It works like vdpasim
> >>>> driver, but offloads the data plane and control plane to a user spac=
e process.
> >>> In that case to draw parallel lines,
> >>>
> >>> 1. netdevsim:
> >>> (a) create resources in kernel sw
> >>> (b) datapath simulates in kernel
> >>>
> >>> 2. ifc + mlx5 vdpa dev:
> >>> (a) creates resource in hw
> >>> (b) data path is in hw
> >>>
> >>> 3. vduse:
> >>> (a) creates resources in userspace sw
> >>> (b) data path is in user space.
> >>> hence creates data path resources for user space.
> >>> So char device is created, removed as result of vdpa device creation.
> >>>
> >>> For example,
> >>> $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> >>>
> >>> Above command will create char device for user space.
> >>>
> >>> Similar command for ifc/mlx5 would have created similar channel for r=
est of
> >> the config commands in hw.
> >>> vduse channel =3D char device, eventfd etc.
> >>> ifc/mlx5 hw channel =3D bar, irq, command interface etc Netdev sim
> >>> channel =3D sw direct calls
> >>>
> >>> Does it make sense?
> >> In my understanding, to make vdpa work, we need a backend (datapath
> >> resources) and a frontend (a vdpa device attached to a vdpa bus). In t=
he above
> >> example, it looks like we use the command "vdpa dev add ..."
> >>   to create a backend, so do we need another command to create a front=
end?
> >>
> > For block device there is certainly some backend to process the IOs.
> > Sometimes backend to be setup first, before its front end is exposed.
> > "vdpa dev add" is the front end command who connects to the backend (im=
plicitly) for network device.
> >
> > vhost->vdpa_block_device->backend_io_processor (usr,hw,kernel).
> >
> > And it needs a way to connect to backend when explicitly specified duri=
ng creation time.
> > Something like,
> > $ vdpa dev add parentdev vdpa_vduse type block name foo3 handle <uuid>
> > In above example some vendor device specific unique handle is passed ba=
sed on backend setup in hardware/user space.
> >
> > In below 3 examples, vdpa block simulator is connecting to backend bloc=
k or file.
> >
> > $ vdpa dev add parentdev vdpa_blocksim type block name foo4 blockdev /d=
ev/zero
> >
> > $ vdpa dev add parentdev vdpa_blocksim type block name foo5 blockdev /d=
ev/sda2 size=3D100M offset=3D10M
> >
> > $ vdpa dev add parentdev vdpa_block filebackend_sim type block name foo=
6 file /root/file_backend.txt
> >
> > Or may be backend connects to the created vdpa device is bound to the d=
river.
> > Can vduse attach to the created vdpa block device through the char devi=
ce and establish the channel to receive IOs, and to setup the block config =
space?
>
>
> I think it can work.
>
> Another thing I wonder it that, do we consider more than one VDUSE
> parentdev(or management dev)? This allows us to have separated devices
> implemented via different processes.
>
> If yes, VDUSE ioctl needs to be extended to register/unregister parentdev=
.
>

Yes, we need to extend the ioctl to support that. Now we only have one
parentdev represented by /dev/vduse.

Thanks,
Yongji
