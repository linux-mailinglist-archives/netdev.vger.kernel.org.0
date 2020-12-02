Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B362CBE17
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgLBNTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbgLBNTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 08:19:14 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0C56C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 05:18:28 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id 7so4270532ejm.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 05:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UIKTs0s2q5YEPcaivKknIvt+mFQ9QlENqVBETcRPjLg=;
        b=qu7sw3q0n6xtfSzumO4Ow8DcbGK1gqE+Z8E50g/rKBjB4L8ke/GqBZDo9zrfwxbliA
         RqJDkGBlDC0AJP0GK37fCpx7SvxEmkgdraVXOrApXnUvMuQbC+WC14iMtGs0sGpDUiav
         ncD7P5B0Yxf0cGnAHH2EFcPontotDNtBT8kox3/sH0bNAKGp/+fk6vTgHfposZVq3P8k
         GnMKmrYmWLhAB5mEo1UK6i5RGP8jEE4RACkqjF29kPLHKB+gyxEOvOhUFf6uzS7fUzJZ
         gqlQiWYg6B0J1EajbmrgnmsKN6s5mJJFO4z57bMbB2VYpmxc7o7D82E7nEjdBU9I6kIE
         +sRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UIKTs0s2q5YEPcaivKknIvt+mFQ9QlENqVBETcRPjLg=;
        b=LtRw5rx6EMl0K6kWq3VUzFZ3NTIt4J40Vz7zJchTtGMplTXK3CUO0A9C8+4RvFUR8J
         KYc8BNT89F9HajdyHFvHrWUxlmBXykrdgRSW4Fn4jGlNfUFJV10IqhTqF1S6/wcqjYd5
         PA5nCExLkO1YG8jSyWuQ7yvcPY8/7LJyg9ZrFdKBOlJ34mWNK7iYAts5R1XdU5qFq665
         SPAojLsujSbnr8/fNqRgh/IbS3MdYZEBSF8LHLRPDZdCuLn2rsa2R7nX5JzH3YHkeUBu
         oilibuLTvAt3S6fO5+RLV8C4hvqvnJf9isoEsgx0ZCra0zf5NSzLk8ObjV1nNe3/fTDu
         Fl1Q==
X-Gm-Message-State: AOAM5315jVpGzJPKTs6AwON+iY5uIqfmT4ITbciNuq+Aro6QcdCc6ro4
        3+E3cscq0n7MoW89MjO4YokSKbd/s729G7GYLfH7
X-Google-Smtp-Source: ABdhPJyzudcnjKM5T5boqRLmQdJSRKVOwWz4R4FcGaKpL2zAb0hqPM5loR2HRdsf4QR9JIDKuJ3WqgJjPVov2q3OUFw=
X-Received: by 2002:a17:906:a43:: with SMTP id x3mr2162621ejf.197.1606915107200;
 Wed, 02 Dec 2020 05:18:27 -0800 (PST)
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
 <CACycT3uV8e61kVF6Q8zE5VVK_Okp03e=WNRcUffdkFeeFpfKDQ@mail.gmail.com> <BY5PR12MB43226BFFC334789D799F66D5DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43226BFFC334789D799F66D5DCF30@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 2 Dec 2020 21:18:16 +0800
Message-ID: <CACycT3sdz+eoeE38z-5_HSB60ZzCsOwu+gYm1FyF9CC94OjL_A@mail.gmail.com>
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

On Wed, Dec 2, 2020 at 7:13 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Yongji Xie <xieyongji@bytedance.com>
> > Sent: Wednesday, December 2, 2020 2:52 PM
> >
> > On Wed, Dec 2, 2020 at 12:53 PM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > >
> > > > From: Yongji Xie <xieyongji@bytedance.com>
> > > > Sent: Wednesday, December 2, 2020 9:00 AM
> > > >
> > > > On Tue, Dec 1, 2020 at 11:59 PM Parav Pandit <parav@nvidia.com> wro=
te:
> > > > >
> > > > >
> > > > >
> > > > > > From: Yongji Xie <xieyongji@bytedance.com>
> > > > > > Sent: Tuesday, December 1, 2020 7:49 PM
> > > > > >
> > > > > > On Tue, Dec 1, 2020 at 7:32 PM Parav Pandit <parav@nvidia.com>
> > wrote:
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > > From: Yongji Xie <xieyongji@bytedance.com>
> > > > > > > > Sent: Tuesday, December 1, 2020 3:26 PM
> > > > > > > >
> > > > > > > > On Tue, Dec 1, 2020 at 2:25 PM Jason Wang
> > > > > > > > <jasowang@redhat.com>
> > > > > > wrote:
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > On 2020/11/30 =E4=B8=8B=E5=8D=883:07, Yongji Xie wrote:
> > > > > > > > > >>> Thanks for adding me, Jason!
> > > > > > > > > >>>
> > > > > > > > > >>> Now I'm working on a v2 patchset for VDUSE (vDPA
> > > > > > > > > >>> Device in
> > > > > > > > > >>> Userspace) [1]. This tool is very useful for the vdus=
e device.
> > > > > > > > > >>> So I'm considering integrating this into my v2 patchs=
et.
> > > > > > > > > >>> But there is one problem=EF=BC=9A
> > > > > > > > > >>>
> > > > > > > > > >>> In this tool, vdpa device config action and enable
> > > > > > > > > >>> action are combined into one netlink msg:
> > > > > > > > > >>> VDPA_CMD_DEV_NEW. But in
> > > > > > vduse
> > > > > > > > > >>> case, it needs to be splitted because a chardev shoul=
d
> > > > > > > > > >>> be created and opened by a userspace process before w=
e
> > > > > > > > > >>> enable the vdpa device (call vdpa_register_device()).
> > > > > > > > > >>>
> > > > > > > > > >>> So I'd like to know whether it's possible (or have
> > > > > > > > > >>> some
> > > > > > > > > >>> plans) to add two new netlink msgs something like:
> > > > > > > > > >>> VDPA_CMD_DEV_ENABLE
> > > > > > > > and
> > > > > > > > > >>> VDPA_CMD_DEV_DISABLE to make the config path more
> > flexible.
> > > > > > > > > >>>
> > > > > > > > > >> Actually, we've discussed such intermediate step in
> > > > > > > > > >> some early discussion. It looks to me VDUSE could be
> > > > > > > > > >> one of the users of
> > > > this.
> > > > > > > > > >>
> > > > > > > > > >> Or I wonder whether we can switch to use anonymous
> > > > > > > > > >> inode(fd) for VDUSE then fetching it via an
> > > > > > > > > >> VDUSE_GET_DEVICE_FD
> > > > ioctl?
> > > > > > > > > >>
> > > > > > > > > > Yes, we can. Actually the current implementation in
> > > > > > > > > > VDUSE is like this.  But seems like this is still a int=
ermediate
> > step.
> > > > > > > > > > The fd should be binded to a name or something else
> > > > > > > > > > which need to be configured before.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > The name could be specified via the netlink. It looks to
> > > > > > > > > me the real issue is that until the device is connected
> > > > > > > > > with a userspace, it can't be used. So we also need to
> > > > > > > > > fail the enabling if it doesn't
> > > > > > opened.
> > > > > > > > >
> > > > > > > >
> > > > > > > > Yes, that's true. So you mean we can firstly try to fetch
> > > > > > > > the fd binded to a name/vduse_id via an VDUSE_GET_DEVICE_FD=
,
> > > > > > > > then use the name/vduse_id as a attribute to create vdpa
> > > > > > > > device? It looks fine to
> > > > me.
> > > > > > >
> > > > > > > I probably do not well understand. I tried reading patch [1]
> > > > > > > and few things
> > > > > > do not look correct as below.
> > > > > > > Creating the vdpa device on the bus device and destroying the
> > > > > > > device from
> > > > > > the workqueue seems unnecessary and racy.
> > > > > > >
> > > > > > > It seems vduse driver needs
> > > > > > > This is something should be done as part of the vdpa dev add
> > > > > > > command,
> > > > > > instead of connecting two sides separately and ensuring race
> > > > > > free access to it.
> > > > > > >
> > > > > > > So VDUSE_DEV_START and VDUSE_DEV_STOP should possibly be
> > avoided.
> > > > > > >
> > > > > >
> > > > > > Yes, we can avoid these two ioctls with the help of the managem=
ent
> > tool.
> > > > > >
> > > > > > > $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> > > > > > >
> > > > > > > When above command is executed it creates necessary vdpa
> > > > > > > device
> > > > > > > foo2
> > > > > > on the bus.
> > > > > > > When user binds foo2 device with the vduse driver, in the
> > > > > > > probe(), it
> > > > > > creates respective char device to access it from user space.
> > > > > >
> > > > > I see. So vduse cannot work with any existing vdpa devices like
> > > > > ifc, mlx5 or
> > > > netdevsim.
> > > > > It has its own implementation similar to fuse with its own backen=
d of
> > choice.
> > > > > More below.
> > > > >
> > > > > > But vduse driver is not a vdpa bus driver. It works like vdpasi=
m
> > > > > > driver, but offloads the data plane and control plane to a user=
 space
> > process.
> > > > >
> > > > > In that case to draw parallel lines,
> > > > >
> > > > > 1. netdevsim:
> > > > > (a) create resources in kernel sw
> > > > > (b) datapath simulates in kernel
> > > > >
> > > > > 2. ifc + mlx5 vdpa dev:
> > > > > (a) creates resource in hw
> > > > > (b) data path is in hw
> > > > >
> > > > > 3. vduse:
> > > > > (a) creates resources in userspace sw
> > > > > (b) data path is in user space.
> > > > > hence creates data path resources for user space.
> > > > > So char device is created, removed as result of vdpa device creat=
ion.
> > > > >
> > > > > For example,
> > > > > $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
> > > > >
> > > > > Above command will create char device for user space.
> > > > >
> > > > > Similar command for ifc/mlx5 would have created similar channel
> > > > > for rest of
> > > > the config commands in hw.
> > > > > vduse channel =3D char device, eventfd etc.
> > > > > ifc/mlx5 hw channel =3D bar, irq, command interface etc Netdev si=
m
> > > > > channel =3D sw direct calls
> > > > >
> > > > > Does it make sense?
> > > >
> > > > In my understanding, to make vdpa work, we need a backend (datapath
> > > > resources) and a frontend (a vdpa device attached to a vdpa bus). I=
n
> > > > the above example, it looks like we use the command "vdpa dev add .=
.."
> > > >  to create a backend, so do we need another command to create a
> > frontend?
> > > >
> > > For block device there is certainly some backend to process the IOs.
> > > Sometimes backend to be setup first, before its front end is exposed.
> >
> > Yes, the backend need to be setup firstly, this is vendor device specif=
ic, not
> > vdpa specific.
> >
> > > "vdpa dev add" is the front end command who connects to the backend
> > (implicitly) for network device.
> > >
> > > vhost->vdpa_block_device->backend_io_processor (usr,hw,kernel).
> > >
> > > And it needs a way to connect to backend when explicitly specified du=
ring
> > creation time.
> > > Something like,
> > > $ vdpa dev add parentdev vdpa_vduse type block name foo3 handle
> > <uuid>
> > > In above example some vendor device specific unique handle is passed
> > based on backend setup in hardware/user space.
> > >
> >
> > Yes, we can work like this. After we setup a backend through an anonymo=
us
> > inode(fd) from /dev/vduse, we can get a unique handle. Then use it to
> > create a frontend which will connect to the specific backend.
>
> I do not fully understand the inode. But I assume this is some unique han=
dle say uuid or something that both sides backend and vdpa device understan=
d.
> It cannot be some kernel internal handle expose to user space.
>

Yes, the unique handle should be a user-defined stuff.

> >
> > > In below 3 examples, vdpa block simulator is connecting to backend bl=
ock
> > or file.
> > >
> > > $ vdpa dev add parentdev vdpa_blocksim type block name foo4 blockdev
> > > /dev/zero
> > >
> > > $ vdpa dev add parentdev vdpa_blocksim type block name foo5 blockdev
> > > /dev/sda2 size=3D100M offset=3D10M
> > >
> > > $ vdpa dev add parentdev vdpa_block filebackend_sim type block name
> > > foo6 file /root/file_backend.txt
> > >
> > > Or may be backend connects to the created vdpa device is bound to the
> > driver.
> > > Can vduse attach to the created vdpa block device through the char de=
vice
> > and establish the channel to receive IOs, and to setup the block config=
 space?
> > >
> >
> > How to create the vdpa block device? If we use the command "vdpa dev
> > add..", the command will hang there until a vduse process attaches to t=
he
> > vdpa block device.
> I was suggesting that vdpa device is created, but it doesn=E2=80=99t have=
 backend attached to it.
> It is attached to the backend when ioctl() side does enough setup. This s=
tate is handled internally the vduse driver.
>
> But the above method of preparing backend looks more sane.
>
> Regardless of which method is preferred, vduse driver must need a state t=
o detach the vdpa bus device queues etc from the user space.
> This is needed because user space process can terminate anytime resulting=
 in detaching dpa bus device in_use by the vhost side.

I think the vdpa device should only be detached by the command "vdpa
dev del...". The vduse driver can support reconnecting when user space
process is terminated.

Thanks,
Yongji
