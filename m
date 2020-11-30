Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B011D2C7E6A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 08:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgK3HH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 02:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgK3HH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 02:07:57 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6EC0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 23:07:17 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id y22so6268636edv.1
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 23:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kUcUTrp9YZCAEiXq2Xppmzwz6Q0tuM+Tj8uLwJ0A368=;
        b=cijGqTlNlxYG9CDengeNQuumVT7IWCBdt28MHL4PtjAOodEj9tRKWaKteWQgp0a2d/
         ZJ/0Wd34y9pcPEM8yQXMtZJHnLdriXR/mGxDcuRTInpV6s3RR/WfHkTvgrigqQxWj4dM
         WS7pYggIKUZK7iDQiNf359k65byVNygkrzLfOasPuoB8GLFU167iqPB7zwaVCKQAGwU7
         f02vL/SeGIijeZZdCJKSC9n478/VETQi99ofEZUEM/hM1DqW9+e0FlCMnTO+TxiBTg0R
         vH2G48yZYJzIA8PSPXEJXPGbFeSTU68skXYhLmERtyP9I8lLYT5pmvkJ349EPCSbIEAT
         0aWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kUcUTrp9YZCAEiXq2Xppmzwz6Q0tuM+Tj8uLwJ0A368=;
        b=MEpg/8ATYiNX2w4qUO9Dx9pn42DSavqy0YVCw+x0dc1/rNR2qPOzAcB2Fs3REIaXFr
         ckvC1TOdOYNC4ZW6SrnZFIJejikhM0oTZRI1H508qHxcnr9fVOr1xcuYn+cpyqlByWhs
         SD8j6PjntG8UAhq6RmnACsMGSP908ZkeX069o8htxqm6xZpvebdmDaUuQnzNs6RTwoa3
         bDWslLiJ2goTeaH8Nsusf2SErIundUg4GCT4yJQh3FwLcQDF5fjes1R6lOQp6BiZnZzi
         lXnZfCIzlrId2oQfsS9emBLTbJLSABKkMOAD3n4bwZEVy/tC2+LOeqMrAb2Kk/n7jtcw
         xmNQ==
X-Gm-Message-State: AOAM530j6eP1k/djB+bIz+jKmura7QaiBauX4SHXwwc+EgEj1/CrjAKA
        yBUbkoCAgxv1kvgtQU0Q5op633ub5lfTZNMC2r7q
X-Google-Smtp-Source: ABdhPJx7w6szkseq/ysmzepdNPjsjBiRqnbhT4pNSmd9sICnlV9ekODmIkxSUCf5u8FQdINaydpQpL1bQAzCq5Lyonk=
X-Received: by 2002:aa7:c248:: with SMTP id y8mr4498257edo.344.1606720035870;
 Sun, 29 Nov 2020 23:07:15 -0800 (PST)
MIME-Version: 1.0
References: <20201112064005.349268-1-parav@nvidia.com> <5b2235f6-513b-dbc9-3670-e4c9589b4d1f@redhat.com>
 <CACycT3sYScObb9nN3g7L3cesjE7sCZWxZ5_5R1usGU9ePZEeqA@mail.gmail.com> <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
In-Reply-To: <182708df-1082-0678-49b2-15d0199f20df@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 30 Nov 2020 15:07:04 +0800
Message-ID: <CACycT3votu2eyacKg+w12xZ_ujEOgTY0f8A7qcpbM-fwTpjqAw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH 0/7] Introduce vdpa management tool
To:     Jason Wang <jasowang@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>, elic@nvidia.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 11:36 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/11/27 =E4=B8=8B=E5=8D=881:52, Yongji Xie wrote:
> > On Fri, Nov 27, 2020 at 11:53 AM Jason Wang <jasowang@redhat.com
> > <mailto:jasowang@redhat.com>> wrote:
> >
> >
> >     On 2020/11/12 =E4=B8=8B=E5=8D=882:39, Parav Pandit wrote:
> >     > This patchset covers user requirements for managing existing
> >     vdpa devices,
> >     > using a tool and its internal design notes for kernel drivers.
> >     >
> >     > Background and user requirements:
> >     > ----------------------------------
> >     > (1) Currently VDPA device is created by driver when driver is
> >     loaded.
> >     > However, user should have a choice when to create or not create
> >     a vdpa device
> >     > for the underlying parent device.
> >     >
> >     > For example, mlx5 PCI VF and subfunction device supports
> >     multiple classes of
> >     > device such netdev, vdpa, rdma. Howevever it is not required to
> >     always created
> >     > vdpa device for such device.
> >     >
> >     > (2) In another use case, a device may support creating one or
> >     multiple vdpa
> >     > device of same or different class such as net and block.
> >     > Creating vdpa devices at driver load time further limits this
> >     use case.
> >     >
> >     > (3) A user should be able to monitor and query vdpa queue level
> >     or device level
> >     > statistics for a given vdpa device.
> >     >
> >     > (4) A user should be able to query what class of vdpa devices
> >     are supported
> >     > by its parent device.
> >     >
> >     > (5) A user should be able to view supported features and
> >     negotiated features
> >     > of the vdpa device.
> >     >
> >     > (6) A user should be able to create a vdpa device in vendor
> >     agnostic manner
> >     > using single tool.
> >     >
> >     > Hence, it is required to have a tool through which user can
> >     create one or more
> >     > vdpa devices from a parent device which addresses above user
> >     requirements.
> >     >
> >     > Example devices:
> >     > ----------------
> >     >   +-----------+ +-----------+ +---------+ +--------+ +-----------=
+
> >     >   |vdpa dev 0 | |vdpa dev 1 | |rdma dev | |netdev  | |vdpa dev 3 =
|
> >     >   |type=3Dnet   | |type=3Dblock | |mlx5_0   | |ens3f0  | |type=3D=
net   |
> >     >   +----+------+ +-----+-----+ +----+----+ +-----+--+ +----+------=
+
> >     >        |              |            |            |    |
> >     >        |              |            |            |    |
> >     >   +----+-----+        |       +----+----+       | +----+----+
> >     >   |  mlx5    +--------+       |mlx5     +-------+ |mlx5     |
> >     >   |pci vf 2  |                |pci vf 4 | |pci sf 8 |
> >     >   |03:00:2   |                |03:00.4  | |mlx5_sf.8|
> >     >   +----+-----+                +----+----+ +----+----+
> >     >        |                           |   |
> >     >        |                      +----+-----+   |
> >     >        +----------------------+mlx5 +----------------+
> >     >                               |pci pf 0  |
> >     >                               |03:00.0   |
> >     >                               +----------+
> >     >
> >     > vdpa tool:
> >     > ----------
> >     > vdpa tool is a tool to create, delete vdpa devices from a parent
> >     device. It is a
> >     > tool that enables user to query statistics, features and may be
> >     more attributes
> >     > in future.
> >     >
> >     > vdpa tool command draft:
> >     > ------------------------
> >     > (a) List parent devices which supports creating vdpa devices.
> >     > It also shows which class types supported by this parent device.
> >     > In below command example two parent devices support vdpa device
> >     creation.
> >     > First is PCI VF whose bdf is 03.00:2.
> >     > Second is PCI VF whose name is 03:00.4.
> >     > Third is PCI SF whose name is mlx5_core.sf.8
> >     >
> >     > $ vdpa parentdev list
> >     > vdpasim
> >     >    supported_classes
> >     >      net
> >     > pci/0000:03.00:3
> >     >    supported_classes
> >     >      net block
> >     > pci/0000:03.00:4
> >     >    supported_classes
> >     >      net block
> >     > auxiliary/mlx5_core.sf.8
> >     >    supported_classes
> >     >      net
> >     >
> >     > (b) Now add a vdpa device of networking class and show the device=
.
> >     > $ vdpa dev add parentdev pci/0000:03.00:2 type net name foo0 $
> >     vdpa dev show foo0
> >     > foo0: parentdev pci/0000:03.00:2 type network parentdev vdpasim
> >     vendor_id 0 max_vqs 2 max_vq_size 256
> >     >
> >     > (c) Show features of a vdpa device
> >     > $ vdpa dev features show foo0
> >     > supported
> >     >    iommu platform
> >     >    version 1
> >     >
> >     > (d) Dump vdpa device statistics
> >     > $ vdpa dev stats show foo0
> >     > kickdoorbells 10
> >     > wqes 100
> >     >
> >     > (e) Now delete a vdpa device previously created.
> >     > $ vdpa dev del foo0
> >     >
> >     > vdpa tool support in this patchset:
> >     > -----------------------------------
> >     > vdpa tool is created to create, delete and query vdpa devices.
> >     > examples:
> >     > Show vdpa parent device that supports creating, deleting vdpa
> >     devices.
> >     >
> >     > $ vdpa parentdev show
> >     > vdpasim:
> >     >    supported_classes
> >     >      net
> >     >
> >     > $ vdpa parentdev show -jp
> >     > {
> >     >      "show": {
> >     >         "vdpasim": {
> >     >            "supported_classes": {
> >     >               "net"
> >     >          }
> >     >      }
> >     > }
> >     >
> >     > Create a vdpa device of type networking named as "foo2" from the
> >     parent device vdpasim:
> >     >
> >     > $ vdpa dev add parentdev vdpasim type net name foo2
> >     >
> >     > Show the newly created vdpa device by its name:
> >     > $ vdpa dev show foo2
> >     > foo2: type network parentdev vdpasim vendor_id 0 max_vqs 2
> >     max_vq_size 256
> >     >
> >     > $ vdpa dev show foo2 -jp
> >     > {
> >     >      "dev": {
> >     >          "foo2": {
> >     >              "type": "network",
> >     >              "parentdev": "vdpasim",
> >     >              "vendor_id": 0,
> >     >              "max_vqs": 2,
> >     >              "max_vq_size": 256
> >     >          }
> >     >      }
> >     > }
> >     >
> >     > Delete the vdpa device after its use:
> >     > $ vdpa dev del foo2
> >     >
> >     > vdpa tool support by kernel:
> >     > ----------------------------
> >     > vdpa tool user interface will be supported by existing vdpa
> >     kernel framework,
> >     > i.e. drivers/vdpa/vdpa.c It services user command through a
> >     netlink interface.
> >     >
> >     > Each parent device registers supported callback operations with
> >     vdpa subsystem
> >     > through which vdpa device(s) can be managed.
> >     >
> >     > FAQs:
> >     > -----
> >     > 1. Where does userspace vdpa tool reside which users can use?
> >     > Ans: vdpa tool can possibly reside in iproute2 [1] as it enables
> >     user to
> >     > create vdpa net devices.
> >     >
> >     > 2. Why not create and delete vdpa device using sysfs/configfs?
> >     > Ans:
> >     > (a) A device creation may involve passing one or more attributes.
> >     > Passing multiple attributes and returning error code and more
> >     verbose
> >     > information for invalid attributes cannot be handled by
> >     sysfs/configfs.
> >     >
> >     > (b) netlink framework is rich that enables user space and kernel
> >     driver to
> >     > provide nested attributes.
> >     >
> >     > (c) Exposing device specific file under sysfs without net namespa=
ce
> >     > awareness exposes details to multiple containers. Instead exposin=
g
> >     > attributes via a netlink socket secures the communication
> >     channel with kernel.
> >     >
> >     > (d) netlink socket interface enables to run syscaller kernel test=
s.
> >     >
> >     > 3. Why not use ioctl() interface?
> >     > Ans: ioctl() interface replicates the necessary plumbing which
> >     already
> >     > exists through netlink socket.
> >     >
> >     > 4. What happens when one or more user created vdpa devices exist
> >     for a
> >     > parent PCI VF or SF and such parent device is removed?
> >     > Ans: All user created vdpa devices are removed that belong to a
> >     parent.
> >     >
> >     > [1]
> >     git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git
> >     <http://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git>
> >     >
> >     > Next steps:
> >     > -----------
> >     > (a) Post this patchset and iproute2/vdpa inclusion, remaining
> >     two drivers
> >     > will be coverted to support vdpa tool instead of creating
> >     unmanaged default
> >     > device on driver load.
> >     > (b) More net specific parameters such as mac, mtu will be added.
> >     > (c) Features bits get and set interface will be added.
> >
> >
> >     Adding Yong Ji for sharing some thoughts from the view of
> >     userspace vDPA
> >     device.
> >
> >
> > Thanks for adding me, Jason!
> >
> > Now I'm working on a v2 patchset for VDUSE (vDPA Device in Userspace)
> > [1]. This tool is very useful for the vduse device. So I'm considering
> > integrating this into my v2 patchset. But there is one problem=EF=BC=9A
> >
> > In this tool, vdpa device config action and enable action are combined
> > into one netlink msg: VDPA_CMD_DEV_NEW. But in vduse case, it needs to
> > be splitted because a chardev should be created and opened by a
> > userspace process before we enable the vdpa device (call
> > vdpa_register_device()).
> >
> > So I'd like to know whether it's possible (or have some plans) to add
> > two new netlink msgs something like: VDPA_CMD_DEV_ENABLE and
> > VDPA_CMD_DEV_DISABLE to make the config path more flexible.
> >
>
> Actually, we've discussed such intermediate step in some early
> discussion. It looks to me VDUSE could be one of the users of this.
>
> Or I wonder whether we can switch to use anonymous inode(fd) for VDUSE
> then fetching it via an VDUSE_GET_DEVICE_FD ioctl?
>

Yes, we can. Actually the current implementation in VDUSE is like
this.  But seems like this is still a intermediate step. The fd should
be binded to a name or something else which need to be configured
before.

Thanks,
Yongji
