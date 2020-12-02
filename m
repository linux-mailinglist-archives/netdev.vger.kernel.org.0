Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A042CB385
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 04:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgLBDac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 22:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbgLBDac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 22:30:32 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A512C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 19:29:46 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so398764ejm.0
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 19:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mC7NATN5fdjUhjEcui+zCZKWukwACRp2Fb9GN0WZCDg=;
        b=me5p8I+uyXoIsbQ/KL71p7oysbM8P0Wqqg0/1JzIOGM/Nkiw3o3zWnB/hQtz/gDk/F
         YLvZ4Gn8mabeiXzsXXBFviafILt6sbalJ5TylI35x98jotBeu0G6BG/5lL/2eQZODZ3C
         HIUj00JYMJJE5NidSQvnaOneZ9tvRpvvxQbEaqKX8JVGlQjnEnZdZl3zlh8vb/yu95dF
         qLTk79vHtXPhZSwI9EseNb7GQjZHeJBAnmsyB9HnHh/Bh8awG6Q0H6CWZeJ36wVfRiLI
         K8EaY7FCtKNEOZOR7I80azPmGRj/IEtGjlpARFl05rQcsf5mt6dWsIEbCVW705WuBuYv
         NL7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mC7NATN5fdjUhjEcui+zCZKWukwACRp2Fb9GN0WZCDg=;
        b=fDjvqPyg8ZBQ83bkXardWx2Zj27QLne1VLLLCu35QkNsilO8YCEQYYFie4FdTK0jgX
         PYW8QIYdvD5eESzzHvTT4HEDsAGV40xzYaXmh2AQ9YqwYXWTNJG/8Aa0gE+YZ1eXQq/A
         U2MevhTfJo1B2mmD/a4HGj64dbUngqz8BIVMudQE1E65N5ZKt1+1lUwHyOwLayTIwI3H
         Ljgll3e4FyMCGkxGH/Y+zfcgbH5pIhGUSe2UfljDuO0/RmRqdcvYNkVtCAm1Olr5FJvH
         ZNlWBY2e7Rh7isTUsH6PJkCs6M174ADuciWk2dLigFvdSKBYro5ieptW580atgIyDSCA
         pdFQ==
X-Gm-Message-State: AOAM531Oe/cN1EVm+ph7weeypBP9700gyA/2HizGef3bxeN1KFd4wWID
        TQZunhzQ8ysCMj5UisO7sAOa7hLoyKR/+uewVUfD
X-Google-Smtp-Source: ABdhPJwPlpVRdNERy6bI0HedMqzM8eoaBzbgYZVjAe5T+QHfLIhsoPs3ig04m0syH3IwUOd2D5XMZiMrnc+PQ6AeROw=
X-Received: by 2002:a17:906:591a:: with SMTP id h26mr458720ejq.174.1606879784766;
 Tue, 01 Dec 2020 19:29:44 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com> <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com> <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com> <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
 <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com> <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322C80FB3C76B85A2D095CCDCF40@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 2 Dec 2020 11:29:33 +0800
Message-ID: <CACycT3vNXvNVUP+oqzv-MMgtzneeeZUoMaDVtEws7VizH0V+mA@mail.gmail.com>
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

On Tue, Dec 1, 2020 at 11:59 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Yongji Xie <xieyongji@bytedance.com>
> > Sent: Tuesday, December 1, 2020 7:49 PM
> >
> > On Tue, Dec 1, 2020 at 7:32 PM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > >
> > > > From: Yongji Xie <xieyongji@bytedance.com>
> > > > Sent: Tuesday, December 1, 2020 3:26 PM
> > > >
> > > > On Tue, Dec 1, 2020 at 2:25 PM Jason Wang <jasowang@redhat.com>
> > wrote:
> > > > >
> > > > >
> > > > > On 2020/11/30 =E4=B8=8B=E5=8D=883:07, Yongji Xie wrote:
> > > > > >>> Thanks for adding me, Jason!
> > > > > >>>
> > > > > >>> Now I'm working on a v2 patchset for VDUSE (vDPA Device in
> > > > > >>> Userspace) [1]. This tool is very useful for the vduse device=
.
> > > > > >>> So I'm considering integrating this into my v2 patchset. But
> > > > > >>> there is one problem=EF=BC=9A
> > > > > >>>
> > > > > >>> In this tool, vdpa device config action and enable action are
> > > > > >>> combined into one netlink msg: VDPA_CMD_DEV_NEW. But in
> > vduse
> > > > > >>> case, it needs to be splitted because a chardev should be
> > > > > >>> created and opened by a userspace process before we enable th=
e
> > > > > >>> vdpa device (call vdpa_register_device()).
> > > > > >>>
> > > > > >>> So I'd like to know whether it's possible (or have some plans=
)
> > > > > >>> to add two new netlink msgs something like:
> > > > > >>> VDPA_CMD_DEV_ENABLE
> > > > and
> > > > > >>> VDPA_CMD_DEV_DISABLE to make the config path more flexible.
> > > > > >>>
> > > > > >> Actually, we've discussed such intermediate step in some early
> > > > > >> discussion. It looks to me VDUSE could be one of the users of =
this.
> > > > > >>
> > > > > >> Or I wonder whether we can switch to use anonymous inode(fd)
> > > > > >> for VDUSE then fetching it via an VDUSE_GET_DEVICE_FD ioctl?
> > > > > >>
> > > > > > Yes, we can. Actually the current implementation in VDUSE is
> > > > > > like this.  But seems like this is still a intermediate step.
> > > > > > The fd should be binded to a name or something else which need
> > > > > > to be configured before.
> > > > >
> > > > >
> > > > > The name could be specified via the netlink. It looks to me the
> > > > > real issue is that until the device is connected with a userspace=
,
> > > > > it can't be used. So we also need to fail the enabling if it does=
n't
> > opened.
> > > > >
> > > >
> > > > Yes, that's true. So you mean we can firstly try to fetch the fd
> > > > binded to a name/vduse_id via an VDUSE_GET_DEVICE_FD, then use the
> > > > name/vduse_id as a attribute to create vdpa device? It looks fine t=
o me.
> > >
> > > I probably do not well understand. I tried reading patch [1] and few =
things
> > do not look correct as below.
> > > Creating the vdpa device on the bus device and destroying the device =
from
> > the workqueue seems unnecessary and racy.
> > >
> > > It seems vduse driver needs
> > > This is something should be done as part of the vdpa dev add command,
> > instead of connecting two sides separately and ensuring race free acces=
s to
> > it.
> > >
> > > So VDUSE_DEV_START and VDUSE_DEV_STOP should possibly be avoided.
> > >
> >
> > Yes, we can avoid these two ioctls with the help of the management tool=
.
> >
> > > $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> > >
> > > When above command is executed it creates necessary vdpa device foo2
> > on the bus.
> > > When user binds foo2 device with the vduse driver, in the probe(), it
> > creates respective char device to access it from user space.
> >
> I see. So vduse cannot work with any existing vdpa devices like ifc, mlx5=
 or netdevsim.
> It has its own implementation similar to fuse with its own backend of cho=
ice.
> More below.
>
> > But vduse driver is not a vdpa bus driver. It works like vdpasim driver=
, but
> > offloads the data plane and control plane to a user space process.
>
> In that case to draw parallel lines,
>
> 1. netdevsim:
> (a) create resources in kernel sw
> (b) datapath simulates in kernel
>
> 2. ifc + mlx5 vdpa dev:
> (a) creates resource in hw
> (b) data path is in hw
>
> 3. vduse:
> (a) creates resources in userspace sw
> (b) data path is in user space.
> hence creates data path resources for user space.
> So char device is created, removed as result of vdpa device creation.
>
> For example,
> $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
>
> Above command will create char device for user space.
>
> Similar command for ifc/mlx5 would have created similar channel for rest =
of the config commands in hw.
> vduse channel =3D char device, eventfd etc.
> ifc/mlx5 hw channel =3D bar, irq, command interface etc
> Netdev sim channel =3D sw direct calls
>
> Does it make sense?

In my understanding, to make vdpa work, we need a backend (datapath
resources) and a frontend (a vdpa device attached to a vdpa bus). In
the above example, it looks like we use the command "vdpa dev add ..."
 to create a backend, so do we need another command to create a
frontend?

Thanks,
Yongji
