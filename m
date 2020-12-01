Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2FE82CA575
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730491AbgLAOTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgLAOTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:19:34 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B57BC0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 06:18:48 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id d18so3461705edt.7
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 06:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fCXvBEwcMVtc8hy65Pn2ZYYH6fAo0MB7m9fPCxDsyC4=;
        b=W+Z72+nCeKjIgW8wSuAhRLQinqBk1lvJSqsTz/cAHZFK5n1PzHcckZ34DDaQf+Q1lA
         U+yEJ8fY/gfdeCYsWN+BZmMaaE/eiAK2mAPQcD82PKTch39mssy9vG7jfrQVmJo0FssH
         H+1HfQQdRaOCrqrCExS3usLPplj2SR58F0ftmPcA5pTw1MTDOZ/e0Lui88G/ynO3A24e
         rXy+vf25mZH+GKs04wXrgBQUi2MOj8Fl4/ZBbJhK8YVQ/+QJEAOrCfwSWPcC+igYu7h9
         Sy5vLuihM6M5PotiXao7nNYsrfp9rJcn6ME+EqZTtqL+ye1mR33vvbUkAYJMF612bssM
         Gucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fCXvBEwcMVtc8hy65Pn2ZYYH6fAo0MB7m9fPCxDsyC4=;
        b=oamQbSd9uu7ySBeoPwI0qTJFRuDBZeSjYwA1BMEIOdv+/eo/HjbCDH52wqGxYiVNLN
         guQlBBF7GoPxbD8I2gXO6NS+e5rt/6gRpEe0skgW2I7k4J16YRhWKh5ZJXibVH2QmPqe
         t0j7rPy/EMO/DR4eb9egAaKyIUKsphmbhx6MZvcP3jThPXxsxNSfh8OBuRSqrHgKGhNL
         oG8aRSJ4fEHKjglXxDxd7Eq0QoBTRxSdlIvhAAvPtZEM7q5o0RoOH2pFQBraJTUwRohf
         h+gIuMnHtqOtrSfc65vtKXYIBBGJHYbpn1UC88cAgzBHvXAWO8MKGVDzods/WTtAWDTv
         nTmA==
X-Gm-Message-State: AOAM532rTJ12GGJ08kRe1bSAd6BIQcxXhmraw29V/1kES9bfQw5RPMvW
        /LKRX0dKTYczCkFyKe3jpmCbod8eEHwsn5ZJXccr
X-Google-Smtp-Source: ABdhPJzDLWpx2EyYcsmsQ4VKUvuCZD9ajLFsXWAq668o10RFtGhFqVtSkcD/viTejS+wR52Kc/9moegK4zoPcdh+mCc=
X-Received: by 2002:aa7:c60c:: with SMTP id h12mr3253691edq.145.1606832326725;
 Tue, 01 Dec 2020 06:18:46 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com> <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com>
 <182708df-1082-0678-49b2-15d0199f20df@redhat.com> <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
 <7f80eeed-f5d3-8c6f-1b8c-87b7a449975c@redhat.com> <CACycT3uw6KJgTo+dBzSj07p2P_PziD+WBfX4yWVX-nDNUD2M3A@mail.gmail.com>
 <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB4330173AF4BA08FE12F68B5BDCF40@DM6PR12MB4330.namprd12.prod.outlook.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 1 Dec 2020 22:18:35 +0800
Message-ID: <CACycT3tTCmEzY37E5196Q2mqME2v+KpAp7Snn8wK4XtRKHEqEw@mail.gmail.com>
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

On Tue, Dec 1, 2020 at 7:32 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Yongji Xie <xieyongji@bytedance.com>
> > Sent: Tuesday, December 1, 2020 3:26 PM
> >
> > On Tue, Dec 1, 2020 at 2:25 PM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > On 2020/11/30 =E4=B8=8B=E5=8D=883:07, Yongji Xie wrote:
> > > >>> Thanks for adding me, Jason!
> > > >>>
> > > >>> Now I'm working on a v2 patchset for VDUSE (vDPA Device in
> > > >>> Userspace) [1]. This tool is very useful for the vduse device. So
> > > >>> I'm considering integrating this into my v2 patchset. But there i=
s
> > > >>> one problem=EF=BC=9A
> > > >>>
> > > >>> In this tool, vdpa device config action and enable action are
> > > >>> combined into one netlink msg: VDPA_CMD_DEV_NEW. But in vduse
> > > >>> case, it needs to be splitted because a chardev should be created
> > > >>> and opened by a userspace process before we enable the vdpa devic=
e
> > > >>> (call vdpa_register_device()).
> > > >>>
> > > >>> So I'd like to know whether it's possible (or have some plans) to
> > > >>> add two new netlink msgs something like: VDPA_CMD_DEV_ENABLE
> > and
> > > >>> VDPA_CMD_DEV_DISABLE to make the config path more flexible.
> > > >>>
> > > >> Actually, we've discussed such intermediate step in some early
> > > >> discussion. It looks to me VDUSE could be one of the users of this=
.
> > > >>
> > > >> Or I wonder whether we can switch to use anonymous inode(fd) for
> > > >> VDUSE then fetching it via an VDUSE_GET_DEVICE_FD ioctl?
> > > >>
> > > > Yes, we can. Actually the current implementation in VDUSE is like
> > > > this.  But seems like this is still a intermediate step. The fd
> > > > should be binded to a name or something else which need to be
> > > > configured before.
> > >
> > >
> > > The name could be specified via the netlink. It looks to me the real
> > > issue is that until the device is connected with a userspace, it can'=
t
> > > be used. So we also need to fail the enabling if it doesn't opened.
> > >
> >
> > Yes, that's true. So you mean we can firstly try to fetch the fd binded=
 to a
> > name/vduse_id via an VDUSE_GET_DEVICE_FD, then use the
> > name/vduse_id as a attribute to create vdpa device? It looks fine to me=
.
>
> I probably do not well understand. I tried reading patch [1] and few thin=
gs do not look correct as below.
> Creating the vdpa device on the bus device and destroying the device from=
 the workqueue seems unnecessary and racy.
>
> It seems vduse driver needs
> This is something should be done as part of the vdpa dev add command, ins=
tead of connecting two sides separately and ensuring race free access to it=
.
>
> So VDUSE_DEV_START and VDUSE_DEV_STOP should possibly be avoided.
>

Yes, we can avoid these two ioctls with the help of the management tool.

> $ vdpa dev add parentdev vduse_mgmtdev type net name foo2
>
> When above command is executed it creates necessary vdpa device foo2 on t=
he bus.
> When user binds foo2 device with the vduse driver, in the probe(), it cre=
ates respective char device to access it from user space.

But vduse driver is not a vdpa bus driver. It works like vdpasim
driver, but offloads the data plane and control plane to a user space
process.

Thanks,
Yongji
