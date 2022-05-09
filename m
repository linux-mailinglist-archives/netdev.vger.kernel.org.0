Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5F51F517
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiEIHQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiEIHNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C738E1ACF86
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652080049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJB9Em6I7OuLyYTTBEaXQS40dd84xL6H6gQSfOQOSK4=;
        b=GRWs4DQhY6XpTeJ7ZW1bxIl80mIb0FxZhyKyGvDQXNyNwE5UkCfSdfamx09eAPqsKmgELt
        WyHuzD1QMBU/xnXDiPhxLSofk9ZVvvfi6Z+yc3+elG7wBRRx/M+1MMue0ArkBvd7coIezP
        cfjQj9hXNBtL4p6ZfrYuWJFAlKA50U8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-495-11dtLhZcPuu9twYZGbzoRg-1; Mon, 09 May 2022 03:07:27 -0400
X-MC-Unique: 11dtLhZcPuu9twYZGbzoRg-1
Received: by mail-wr1-f71.google.com with SMTP id s14-20020adfa28e000000b0020ac7532f08so5414020wra.15
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XJB9Em6I7OuLyYTTBEaXQS40dd84xL6H6gQSfOQOSK4=;
        b=zL7mQ4FescN63wLtERQzz3BB6jwNaYkB8ZOKGfgI3IORnSkXYKlxrxMI/4mR48M/ax
         2kUpINKRkrSlOwO13AkdDPE7dMTxMa863hUTj6kjKkeVwcI/SG/wPapmWWp416PsldLC
         8xJ5YkpKV86sEccEZUZxmf2rs+aYQusjcVmHaoBA/KIE99to+ryX1S1eHHSL3wFVSX1Z
         FZoOZTypNDyqNCiRyoMR43jaq5vlD5+seRxKDXFOcpFKyQwIZviKi5GQoW3tW9IdzC0E
         9uWpsehJ5UZAdwifTaqlc1BeQO5brC90RGiHpIhks+K60kmf/8aKH0BydcVJCNiIoNx1
         Q5Dw==
X-Gm-Message-State: AOAM532OdmxmPidJEfvnjzzAq3I3jRpPlrkJ0wltAvvECWINlTJlQSMW
        /Oi0IGirfMuA9voyemQ6h+fWKhfN4U0nYR4PYxk9YfkGsVBRQlMzifapR3NQM44JsfdZBoA6RLl
        RUZFTxR4xjLfj42hB
X-Received: by 2002:a7b:cf04:0:b0:394:27c8:d28a with SMTP id l4-20020a7bcf04000000b0039427c8d28amr20487803wmg.94.1652080046493;
        Mon, 09 May 2022 00:07:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyCyHCGQCbWEwWZ/UHI0DnttZzMiYsb/44YfiPVnJDRlGYZi1SIGptJp+PDbsNZyHEwx15Iog==
X-Received: by 2002:a7b:cf04:0:b0:394:27c8:d28a with SMTP id l4-20020a7bcf04000000b0039427c8d28amr20487743wmg.94.1652080045958;
        Mon, 09 May 2022 00:07:25 -0700 (PDT)
Received: from redhat.com ([2.53.130.81])
        by smtp.gmail.com with ESMTPSA id l6-20020a05600c1d0600b003942a244f34sm15441415wms.13.2022.05.09.00.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 00:07:24 -0700 (PDT)
Date:   Mon, 9 May 2022 03:07:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, Gautam Dawar <gautam.dawar@xilinx.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Martin Porter <martinpo@xilinx.com>,
        Pablo Cascon Katchadourian <pabloc@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>, tanuj.kamde@amd.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        eperezma <eperezma@redhat.com>, Gautam Dawar <gdawar@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH v2 00/19] Control VQ support in vDPA
Message-ID: <20220509030656-mutt-send-email-mst@kernel.org>
References: <20220330180436.24644-1-gdawar@xilinx.com>
 <CACGkMEsPTui8XDLvvLCq4myx1gWh=W1=W_9tXe+Lps5ExdE4+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsPTui8XDLvvLCq4myx1gWh=W1=W_9tXe+Lps5ExdE4+g@mail.gmail.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 11:42:10AM +0800, Jason Wang wrote:
> On Thu, Mar 31, 2022 at 2:05 AM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
> >
> > Hi All:
> >
> > This series tries to add the support for control virtqueue in vDPA.
> >
> > Control virtqueue is used by networking device for accepting various
> > commands from the driver. It's a must to support multiqueue and other
> > configurations.
> >
> > When used by vhost-vDPA bus driver for VM, the control virtqueue
> > should be shadowed via userspace VMM (Qemu) instead of being assigned
> > directly to Guest. This is because Qemu needs to know the device state
> > in order to start and stop device correctly (e.g for Live Migration).
> >
> > This requies to isolate the memory mapping for control virtqueue
> > presented by vhost-vDPA to prevent guest from accessing it directly.
> >
> > To achieve this, vDPA introduce two new abstractions:
> >
> > - address space: identified through address space id (ASID) and a set
> >                  of memory mapping in maintained
> > - virtqueue group: the minimal set of virtqueues that must share an
> >                  address space
> >
> > Device needs to advertise the following attributes to vDPA:
> >
> > - the number of address spaces supported in the device
> > - the number of virtqueue groups supported in the device
> > - the mappings from a specific virtqueue to its virtqueue groups
> >
> > The mappings from virtqueue to virtqueue groups is fixed and defined
> > by vDPA device driver. E.g:
> >
> > - For the device that has hardware ASID support, it can simply
> >   advertise a per virtqueue group.
> > - For the device that does not have hardware ASID support, it can
> >   simply advertise a single virtqueue group that contains all
> >   virtqueues. Or if it wants a software emulated control virtqueue, it
> >   can advertise two virtqueue groups, one is for cvq, another is for
> >   the rest virtqueues.
> >
> > vDPA also allow to change the association between virtqueue group and
> > address space. So in the case of control virtqueue, userspace
> > VMM(Qemu) may use a dedicated address space for the control virtqueue
> > group to isolate the memory mapping.
> >
> > The vhost/vhost-vDPA is also extend for the userspace to:
> >
> > - query the number of virtqueue groups and address spaces supported by
> >   the device
> > - query the virtqueue group for a specific virtqueue
> > - assocaite a virtqueue group with an address space
> > - send ASID based IOTLB commands
> >
> > This will help userspace VMM(Qemu) to detect whether the control vq
> > could be supported and isolate memory mappings of control virtqueue
> > from the others.
> >
> > To demonstrate the usage, vDPA simulator is extended to support
> > setting MAC address via a emulated control virtqueue.
> >
> > Please review.
> 
> Michael, this looks good to me, do you have comments on this?
> 
> Thanks


I'll merge this for next.

> >
> > Changes since RFC v2:
> >
> > - Fixed memory leak for asid 0 in vhost_vdpa_remove_as()
> > - Removed unnecessary NULL check for iotlb in vhost_vdpa_unmap() and
> >   changed its return type to void.
> > - Removed insignificant used_as member field from struct vhost_vdpa.
> > - Corrected the iommu parameter in call to vringh_set_iotlb() from
> >   vdpasim_set_group_asid()
> > - Fixed build errors with vdpa_sim_net
> > - Updated alibaba, vdpa_user and virtio_pci vdpa parent drivers to
> >   call updated vDPA APIs and ensured successful build
> > - Tested control (MAC address configuration) and data-path using
> >   single virtqueue pair on Xilinx (now AMD) SN1022 SmartNIC device
> >   and vdpa_sim_net software device using QEMU release at [1]
> > - Removed two extra blank lines after set_group_asid() in
> >   include/linux/vdpa.h
> >
> > Changes since v1:
> >
> > - Rebased the v1 patch series on vhost branch of MST vhost git repo
> >   git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
> > - Updates to accommodate vdpa_sim changes from monolithic module in
> >   kernel used v1 patch series to current modularized class (net, block)
> >   based approach.
> > - Added new attributes (ngroups and nas) to "vdpasim_dev_attr" and
> >   propagated them from vdpa_sim_net to vdpa_sim
> > - Widened the data-type for "asid" member of vhost_msg_v2 to __u32
> >   to accommodate PASID
> > - Fixed the buildbot warnings
> > - Resolved all checkpatch.pl errors and warnings
> > - Tested both control and datapath with Xilinx Smartnic SN1000 series
> >   device using QEMU implementing the Shadow virtqueue and support for
> >   VQ groups and ASID available at [1]
> >
> > Changes since RFC:
> >
> > - tweak vhost uAPI documentation
> > - switch to use device specific IOTLB really in patch 4
> > - tweak the commit log
> > - fix that ASID in vhost is claimed to be 32 actually but 16bit
> >   actually
> > - fix use after free when using ASID with IOTLB batching requests
> > - switch to use Stefano's patch for having separated iov
> > - remove unused "used_as" variable
> > - fix the iotlb/asid checking in vhost_vdpa_unmap()
> >
> > [1] Development QEMU release with support for SVQ, VQ groups and ASID:
> >   github.com/eugpermar/qemu/releases/tag/vdpa_sw_live_migration.d%2F
> >   asid_groups-v1.d%2F00
> >
> > Thanks
> >
> > Gautam Dawar (19):
> >   vhost: move the backend feature bits to vhost_types.h
> >   virtio-vdpa: don't set callback if virtio doesn't need it
> >   vhost-vdpa: passing iotlb to IOMMU mapping helpers
> >   vhost-vdpa: switch to use vhost-vdpa specific IOTLB
> >   vdpa: introduce virtqueue groups
> >   vdpa: multiple address spaces support
> >   vdpa: introduce config operations for associating ASID to a virtqueue
> >     group
> >   vhost_iotlb: split out IOTLB initialization
> >   vhost: support ASID in IOTLB API
> >   vhost-vdpa: introduce asid based IOTLB
> >   vhost-vdpa: introduce uAPI to get the number of virtqueue groups
> >   vhost-vdpa: introduce uAPI to get the number of address spaces
> >   vhost-vdpa: uAPI to get virtqueue group id
> >   vhost-vdpa: introduce uAPI to set group ASID
> >   vhost-vdpa: support ASID based IOTLB API
> >   vdpa_sim: advertise VIRTIO_NET_F_MTU
> >   vdpa_sim: factor out buffer completion logic
> >   vdpa_sim: filter destination mac address
> >   vdpasim: control virtqueue support
> >
> >  drivers/vdpa/alibaba/eni_vdpa.c      |   2 +-
> >  drivers/vdpa/ifcvf/ifcvf_main.c      |   8 +-
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c    |  11 +-
> >  drivers/vdpa/vdpa.c                  |   5 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 100 ++++++++--
> >  drivers/vdpa/vdpa_sim/vdpa_sim.h     |   3 +
> >  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 169 +++++++++++++----
> >  drivers/vdpa/vdpa_user/vduse_dev.c   |   3 +-
> >  drivers/vdpa/virtio_pci/vp_vdpa.c    |   2 +-
> >  drivers/vhost/iotlb.c                |  23 ++-
> >  drivers/vhost/vdpa.c                 | 267 +++++++++++++++++++++------
> >  drivers/vhost/vhost.c                |  23 ++-
> >  drivers/vhost/vhost.h                |   4 +-
> >  drivers/virtio/virtio_vdpa.c         |   2 +-
> >  include/linux/vdpa.h                 |  44 ++++-
> >  include/linux/vhost_iotlb.h          |   2 +
> >  include/uapi/linux/vhost.h           |  26 ++-
> >  include/uapi/linux/vhost_types.h     |  11 +-
> >  18 files changed, 563 insertions(+), 142 deletions(-)
> >
> > --
> > 2.30.1
> >

